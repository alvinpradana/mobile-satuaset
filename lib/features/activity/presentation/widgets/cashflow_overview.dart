import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/activity_provider.dart';

class CashflowOverview extends ConsumerWidget {
  const CashflowOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(activitySummaryProvider);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Summary Cards
          summaryAsync.when(
            data: (data) => _buildSummaryRow(data['income'] ?? 0, data['expense'] ?? 0),
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
            error: (e, st) => const SizedBox(),
          ),
          
          const SizedBox(height: 32),
          
          // 2. Trend Chart Title
          const Text(
            'Cashflow Trend',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // 3. Trend Chart
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildTrendChart(),
          ),
          
          const SizedBox(height: 32),
          
          // 4. Expense Breakdown Title
          const Text(
            'Top Expenses',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // 5. Expense Breakdown List
          _buildExpenseBreakdown(),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(double income, double expense) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp', // removed space to match ActivitySummary
      decimalDigits: 0,
    );
    
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Income',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  '+${currencyFormatter.format(income)}',
                  style: const TextStyle(
                    color: AppColors.positive,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expense',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  '-${currencyFormatter.format(expense)}',
                  style: const TextStyle(
                    color: AppColors.negative,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => AppColors.surfaceHover,
            maxContentWidth: 250, // Added to prevent text wrapping
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (rodIndex != 0) return null; // Only show one tooltip per group

              final currencyFormatter = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              );

              final inflowStr = currencyFormatter.format(group.barRods[0].toY * 1000000);
              final outflowStr = currencyFormatter.format(group.barRods[1].toY * 1000000);
              
              return BarTooltipItem(
                'Income: ',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                textAlign: TextAlign.left,
                children: [
                  TextSpan(
                    text: '+ $inflowStr\n',
                    style: const TextStyle(
                      color: AppColors.positive,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  const TextSpan(
                    text: 'Expenses: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  TextSpan(
                    text: '- $outflowStr',
                    style: const TextStyle(
                      color: AppColors.negative,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                );
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('Week 1', style: style);
                    break;
                  case 1:
                    text = const Text('Week 2', style: style);
                    break;
                  case 2:
                    text = const Text('Week 3', style: style);
                    break;
                  case 3:
                    text = const Text('Week 4', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        maxY: 25,
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: 15, color: AppColors.positive, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
            BarChartRodData(toY: 8, color: AppColors.negative, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: 10, color: AppColors.positive, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
            BarChartRodData(toY: 12, color: AppColors.negative, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: 18, color: AppColors.positive, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
            BarChartRodData(toY: 6, color: AppColors.negative, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: 20, color: AppColors.positive, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
            BarChartRodData(toY: 15, color: AppColors.negative, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
          ]),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown() {
    // Mock expense breakdown
    final Map<String, double> expenses = {
      'Food & Drink': 4500000,
      'Transportation': 2100000,
      'Housing': 6500000,
      'Entertainment': 1800000,
    };
    
    final double total = expenses.values.fold(0, (sum, val) => sum + val);
    
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: expenses.entries.map((entry) {
          final percentage = entry.value / total;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(entry.value),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.surfaceHover,
                    color: AppColors.negative,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
