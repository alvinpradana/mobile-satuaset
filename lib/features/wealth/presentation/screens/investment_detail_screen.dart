import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/wealth_provider.dart';
import '../widgets/portfolio_performance.dart';
import '../widgets/portfolio_allocation.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/wealth_item_row.dart';
import 'investment_category_detail_screen.dart';
import 'holding_detail_screen.dart';

class InvestmentDetailScreen extends ConsumerStatefulWidget {
  const InvestmentDetailScreen({super.key});

  @override
  ConsumerState<InvestmentDetailScreen> createState() => _InvestmentDetailScreenState();
}

class _InvestmentDetailScreenState extends ConsumerState<InvestmentDetailScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Fetch Data
    final investmentSummary = ref.watch(investmentSummaryProvider);
    final items = ref.watch(wealthItemsProvider('investments'));

    // 2. Formatters
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final isNegativeReturn = investmentSummary.returnPercentage < 0;
    final returnSign = isNegativeReturn ? '' : '+';
    final returnColor = isNegativeReturn ? AppColors.negative : AppColors.positive;

    // 3. Group holdings
    final groupedItems = <String, List<WealthItem>>{};
    for (var item in items) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    // 3b. Search filtering
    List<WealthItem> filteredItems = [];
    if (_isSearching) {
      if (_searchQuery.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items.where((item) {
          final matchesName = item.name.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchesName;
        }).toList();
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primaryAccent,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          // TODO: Implement actual API refresh logic here
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
          // 4. App Bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  if (_isSearching) {
                    setState(() {
                      _isSearching = false;
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Icon(UIcons.regularRounded.angle_left, color: AppColors.textPrimary, size: 20),
                  ),
                ),
              ),
            ),
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Search assets...',
                      hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  )
                : const Text(
                    'Investments',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
            centerTitle: !_isSearching,
            actions: [
              if (!_isSearching)
                Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(UIcons.regularRounded.search, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                  ),
                )
              else if (_searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(UIcons.regularRounded.cross_small, color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                  ),
                )
            ],
          ),

          // 5. Main Content
          if (_isSearching)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'No assets found',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: filteredItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return Column(
                                children: [
                                  WealthItemRow(
                                    item: item,
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).push(
                                        CupertinoPageRoute(
                                          builder: (context) => HoldingDetailScreen(item: item),
                                        ),
                                      );
                                    },
                                  ),
                                  if (index < filteredItems.length - 1)
                                    const Divider(color: AppColors.border, height: 1, thickness: 1),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            )
          else
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Portfolio Value ---
                  const Text(
                    'Portfolio Value',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(investmentSummary.totalValue),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$returnSign${currencyFormatter.format(investmentSummary.unrealizedPnL)}',
                        style: TextStyle(
                          color: returnColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: returnColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              !isNegativeReturn 
                                  ? UIcons.regularRounded.arrow_trend_up 
                                  : UIcons.regularRounded.arrow_trend_down,
                              size: 10,
                              color: returnColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${investmentSummary.returnPercentage.abs().toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: returnColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'this year',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  // --- Portfolio Performance ---
                  PortfolioPerformance(spots: investmentSummary.performanceHistory),
                  
                  const SizedBox(height: 32),
                  // --- Portfolio Allocation ---
                  PortfolioAllocation(
                    allocations: investmentSummary.allocations,
                    totalValue: investmentSummary.totalValue,
                  ),

                  const SizedBox(height: 40),
                  // --- Holdings (Top Gainers by Category) ---
                  const Text(
                    'Top Gainers by Category',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  ...groupedItems.entries.map((entry) {
                    final category = entry.key;
                    var categoryItems = List<WealthItem>.from(entry.value);
                    
                    // Sort by percentageChange descending
                    categoryItems.sort((a, b) => (b.percentageChange ?? 0).compareTo(a.percentageChange ?? 0));
                    
                    // Take top 2
                    final topItems = categoryItems.take(2).toList();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).push(
                                    CupertinoPageRoute(
                                      builder: (context) => InvestmentCategoryDetailScreen(category: category),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      UIcons.regularRounded.angle_right,
                                      color: AppColors.textSecondary,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...topItems.asMap().entries.map((itemEntry) {
                                final index = itemEntry.key;
                                final item = itemEntry.value;
                                return Column(
                                  children: [
                                    WealthItemRow(
                                      item: item,
                                      onTap: () {
                                        Navigator.of(context, rootNavigator: true).push(
                                          CupertinoPageRoute(
                                            builder: (context) => HoldingDetailScreen(item: item),
                                          ),
                                        );
                                      },
                                    ),
                                    if (index < topItems.length - 1)
                                      const Divider(
                                        color: AppColors.border,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          )
        ],
      ),
      ),
      ),
    );
  }
}
