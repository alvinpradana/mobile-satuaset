import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_summary_model.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/wealth_provider.dart';
import '../widgets/portfolio_performance.dart';
import '../widgets/portfolio_allocation.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/wealth_item_row.dart';
import 'investment_category_detail_screen.dart';
import '../widgets/add_investment_bottom_sheet.dart';
import 'holding_detail_screen.dart';

class InvestmentDetailScreen extends ConsumerWidget {
  const InvestmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 4. App Bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
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
            title: const Text(
              'Investments',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
                child: GestureDetector(
                  onTap: () {},
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
            ],
          ),

          // 5. Main Content
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
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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
    );
  }
}
