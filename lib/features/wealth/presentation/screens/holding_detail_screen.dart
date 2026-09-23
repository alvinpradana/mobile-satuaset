import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_item.dart';
import '../widgets/portfolio_performance.dart';
import 'package:fl_chart/fl_chart.dart';
import 'holding_history_screen.dart';

class HoldingDetailScreen extends StatelessWidget {
  final WealthItem item;

  const HoldingDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: item.currency == 'Rp' ? 'id_ID' : 'en_US',
      symbol: item.currency == 'Rp' ? 'Rp ' : '\$',
      decimalDigits: item.currency == 'Rp' ? 0 : 2,
    );

    // Mock performance history for this specific holding
    const List<FlSpot> mockPerformance = [
      FlSpot(0, 1.3), FlSpot(1, 1.32), FlSpot(2, 1.35), FlSpot(3, 1.42),
      FlSpot(4, 1.45), FlSpot(5, 1.40), FlSpot(6, 1.48), FlSpot(7, 1.50),
    ];

    final isPositive = (item.percentageChange ?? 0) >= 0;
    final returnColor = isPositive ? AppColors.positive : AppColors.negative;

    // Calculate nominal PnL amount
    double? nominalPnL;
    if (item.averagePrice != null && item.units != null) {
      nominalPnL = item.value - (item.averagePrice! * item.units!);
    } else if (item.percentageChange != null) {
      nominalPnL = (item.value * item.percentageChange!) / 100;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
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
              item.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HoldingHistoryScreen(item: item),
                      ),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Icon(UIcons.regularRounded.time_past, color: AppColors.textPrimary, size: 20),
                ),
              ),
            ],
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and Value
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceHover,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.iconData,
                            size: 32,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currencyFormatter.format(item.value),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (item.percentageChange != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: returnColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive
                                      ? UIcons.regularRounded.arrow_trend_up
                                      : UIcons.regularRounded.arrow_trend_down,
                                  size: 13,
                                  color: returnColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  nominalPnL != null
                                      ? '${isPositive ? '+' : '-'}${currencyFormatter.format(nominalPnL.abs())} (${item.percentageChange!.abs().toStringAsFixed(1)}%)'
                                      : '${isPositive ? '+' : '-'}${item.percentageChange!.abs().toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: returnColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  // Performance Chart
                  const PortfolioPerformance(spots: mockPerformance),
                  
                  const SizedBox(height: 40),
                  // Holding Details
                  const Text(
                    'Holding Details',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          (item.exchangeAllocations != null && item.exchangeAllocations!.isNotEmpty)
                              ? 'Total Units'
                              : 'Units',
                          item.units?.toString() ?? '-',
                        ),
                        const Divider(color: AppColors.border, height: 24),
                        _buildDetailRow(
                          'Average Price',
                          item.averagePrice != null ? currencyFormatter.format(item.averagePrice) : '-',
                        ),
                        const Divider(color: AppColors.border, height: 24),
                        _buildDetailRow('Current Value', currencyFormatter.format(item.value)),
                      ],
                    ),
                  ),

                  // Platform / Broker Card
                  const SizedBox(height: 28),
                  const Text(
                    'Platform / Broker',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (item.exchangeAllocations != null && item.exchangeAllocations!.isNotEmpty)
                          ? item.exchangeAllocations!.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final alloc = entry.value;
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        alloc.exchangeName,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            currencyFormatter.format(alloc.value),
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${alloc.units} units',
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (idx < item.exchangeAllocations!.length - 1)
                                    const Divider(color: AppColors.border, height: 24),
                                ],
                              );
                            }).toList()
                          : [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.institution ?? 'Primary Platform',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        currencyFormatter.format(item.value),
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (item.units != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.units} units',
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ],
                    ),
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
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Implement sell action
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Sell',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement buy action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Buy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
