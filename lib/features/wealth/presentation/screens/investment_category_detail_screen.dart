import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/wealth_provider.dart';
import '../widgets/wealth_item_row.dart';
import 'holding_detail_screen.dart';
import '../widgets/add_investment_bottom_sheet.dart';

enum GroupingMode { asset, platform }

class PlatformGroup {
  final String platformName;
  final double totalValue;
  final List<PlatformAssetItem> items;
  PlatformGroup({required this.platformName, required this.totalValue, required this.items});
}

class PlatformAssetItem {
  final WealthItem asset;
  final double units;
  final double value;
  PlatformAssetItem({required this.asset, required this.units, required this.value});
}

class InvestmentCategoryDetailScreen extends ConsumerStatefulWidget {
  final String category;

  const InvestmentCategoryDetailScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<InvestmentCategoryDetailScreen> createState() => _InvestmentCategoryDetailScreenState();
}

class _InvestmentCategoryDetailScreenState extends ConsumerState<InvestmentCategoryDetailScreen> {
  GroupingMode _groupingMode = GroupingMode.asset;

  List<PlatformGroup> _groupByPlatform(List<WealthItem> categoryItems) {
    Map<String, List<PlatformAssetItem>> map = {};
    for (var item in categoryItems) {
      if (item.exchangeAllocations != null && item.exchangeAllocations!.isNotEmpty) {
        for (var alloc in item.exchangeAllocations!) {
          map.putIfAbsent(alloc.exchangeName, () => []).add(PlatformAssetItem(asset: item, units: alloc.units, value: alloc.value));
        }
      } else {
        map.putIfAbsent(item.institution ?? 'Unknown', () => []).add(PlatformAssetItem(asset: item, units: item.units ?? 0, value: item.value));
      }
    }

    List<PlatformGroup> groups = [];
    map.forEach((platform, items) {
      double total = items.fold(0, (sum, i) => sum + i.value);
      // sort items by value desc
      items.sort((a, b) => b.value.compareTo(a.value));
      groups.add(PlatformGroup(platformName: platform, totalValue: total, items: items));
    });
    groups.sort((a, b) => b.totalValue.compareTo(a.totalValue));
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final allItems = ref.watch(wealthItemsProvider('investments'));
    final categoryItems = allItems.where((item) => item.category == widget.category).toList();

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    double categoryTotal = 0;
    for (var item in categoryItems) {
      categoryTotal += item.value;
    }

    final platformGroups = _groupByPlatform(categoryItems);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primaryAccent,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
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
              title: Text(
                widget.category,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Value',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormatter.format(categoryTotal),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Filter Toggle Slider
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHover,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: _groupingMode == GroupingMode.asset ? Alignment.centerLeft : Alignment.centerRight,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (_groupingMode != GroupingMode.asset) setState(() => _groupingMode = GroupingMode.asset);
                                  },
                                  child: Center(
                                    child: Text(
                                      'By Asset',
                                      style: TextStyle(
                                        color: _groupingMode == GroupingMode.asset ? AppColors.primaryAccent : AppColors.textSecondary,
                                        fontWeight: _groupingMode == GroupingMode.asset ? FontWeight.bold : FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (_groupingMode != GroupingMode.platform) setState(() => _groupingMode = GroupingMode.platform);
                                  },
                                  child: Center(
                                    child: Text(
                                      'By Platform',
                                      style: TextStyle(
                                        color: _groupingMode == GroupingMode.platform ? AppColors.primaryAccent : AppColors.textSecondary,
                                        fontWeight: _groupingMode == GroupingMode.platform ? FontWeight.bold : FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Animated List Switcher
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.05, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _groupingMode == GroupingMode.asset
                          ? _buildAssetGroups(categoryItems, currencyFormatter)
                          : _buildPlatformGroups(platformGroups, currencyFormatter),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => AddInvestmentBottomSheet(
                initialCategory: widget.category,
                isCategoryLocked: true,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Add Allocation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetGroups(List<WealthItem> categoryItems, NumberFormat formatter) {
    return Container(
      key: const ValueKey('AssetGroups'),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoryItems.asMap().entries.map((itemEntry) {
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
                if (index < categoryItems.length - 1)
                  const Divider(
                    color: AppColors.border,
                    height: 1,
                    thickness: 1,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPlatformGroups(List<PlatformGroup> groups, NumberFormat formatter) {
    return Column(
      key: const ValueKey('PlatformGroups'),
      children: groups.map((group) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform Header Label
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border.withOpacity(0.5)),
                      ),
                      child: Center(
                        child: Icon(UIcons.regularRounded.building, size: 14, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        group.platformName,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      formatter.format(group.totalValue),
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Card for Assets
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: group.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                builder: (context) => HoldingDetailScreen(item: item.asset),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceHover,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(item.asset.iconData, color: AppColors.textPrimary, size: 20),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.asset.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Text('${item.units} units', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                Text(
                                  formatter.format(item.value),
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index < group.items.length - 1)
                          const Divider(color: AppColors.border, height: 1, thickness: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
