import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/wealth_provider.dart';
import '../widgets/wealth_item_row.dart';

class LiabilitiesDetailScreen extends ConsumerStatefulWidget {
  const LiabilitiesDetailScreen({super.key});

  @override
  ConsumerState<LiabilitiesDetailScreen> createState() => _LiabilitiesDetailScreenState();
}

class _LiabilitiesDetailScreenState extends ConsumerState<LiabilitiesDetailScreen> {
  bool _isSettledExpanded = false;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(wealthItemsProvider('liabilities'));
    final domain = ref.watch(wealthSummaryProvider).domains.firstWhere((d) => d.id == 'liabilities');

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final compactCurrencyFormatter = NumberFormat.compactCurrency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Active vs Settled liabilities
    final activeItems = items.where((i) => i.status != WealthItemStatus.archived).toList();
    final settledItems = items.where((i) => i.status == WealthItemStatus.archived).toList();

    // Total monthly payment estimation
    double totalMonthlyPayment = 5200000; // Mock monthly obligation sum

    // Group active items by category
    final groupedActiveItems = <String, List<WealthItem>>{};
    for (var item in activeItems) {
      groupedActiveItems.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar
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
              'Liabilities',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
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

          // 2. Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  const Text(
                    'TOTAL LIABILITIES',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(domain.value),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Active Liabilities & Monthly Payment Info Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(UIcons.solidRounded.file_invoice, size: 14, color: AppColors.negative),
                            const SizedBox(width: 8),
                            Text(
                              '${activeItems.length} active liabilities',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.negative.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(UIcons.regularRounded.clock, size: 12, color: AppColors.negative),
                            const SizedBox(width: 6),
                            Text(
                              '${compactCurrencyFormatter.format(totalMonthlyPayment)} / month',
                              style: const TextStyle(
                                color: AppColors.negative,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Liabilities Breakdown Bar
                  if (activeItems.isNotEmpty) ...[
                    _LiabilitiesBreakdownBar(items: activeItems, totalValue: domain.value),
                    const SizedBox(height: 36),
                  ],

                  // Active Liabilities Groups
                  if (activeItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.surfaceHover.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(UIcons.solidRounded.file_invoice, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No active liabilities',
                            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Great job! You have no outstanding loans or debt balances.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  else
                    ...groupedActiveItems.entries.map((entry) {
                      final category = entry.key;
                      final categoryItems = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...categoryItems.asMap().entries.map((itemEntry) {
                              final index = itemEntry.key;
                              final item = itemEntry.value;

                              return Column(
                                children: [
                                  WealthItemRow(
                                    item: item,
                                    onTap: () {
                                      // Action to view/manage liability
                                    },
                                  ),
                                  if (index < categoryItems.length - 1)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 56.0),
                                      child: Divider(
                                        color: AppColors.border,
                                        height: 1,
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ],
                        ),
                      );
                    }),

                  // Settled / Paid Off Liabilities Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSettledExpanded = !_isSettledExpanded;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'PAID OFF LIABILITIES',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              AnimatedRotation(
                                turns: _isSettledExpanded ? 0.25 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  UIcons.regularRounded.angle_right,
                                  color: AppColors.textSecondary,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(width: double.infinity),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (settledItems.isNotEmpty) ...[
                              const Divider(color: AppColors.border, height: 16, thickness: 1),
                              ...settledItems.map((item) {
                                return Opacity(
                                  opacity: 0.5,
                                  child: WealthItemRow(
                                    item: item,
                                    onTap: () {},
                                  ),
                                );
                              }),
                            ] else
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  'No paid off liabilities history',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ),
                          ],
                        ),
                        crossFadeState: _isSettledExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 250),
                      ),
                    ],
                  ),

                  // Bottom spacing
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiabilitiesBreakdownBar extends StatelessWidget {
  final List<WealthItem> items;
  final double totalValue;

  const _LiabilitiesBreakdownBar({
    required this.items,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    // Group totals by category
    final categoryTotals = <String, double>{};
    for (var item in items) {
      categoryTotals[item.category] = (categoryTotals[item.category] ?? 0) + item.value;
    }

    final colors = [
      AppColors.negative,
      const Color(0xFFF43F5E), // Rose 500
      const Color(0xFFFB7185), // Rose 400
      const Color(0xFFE11D48), // Rose 600
    ];

    final entries = categoryTotals.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bar
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: List.generate(entries.length, (index) {
              final entry = entries[index];
              final pct = totalValue > 0 ? (entry.value / totalValue) : (1.0 / entries.length);
              return Expanded(
                flex: (pct * 100).toInt().clamp(1, 100),
                child: Container(
                  color: colors[index % colors.length],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: List.generate(entries.length, (index) {
            final entry = entries[index];
            final pct = totalValue > 0 ? ((entry.value / totalValue) * 100).toStringAsFixed(1) : '0';
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.key,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  '$pct%',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
