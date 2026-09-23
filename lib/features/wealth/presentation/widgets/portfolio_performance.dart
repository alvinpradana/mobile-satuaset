import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/wealth_provider.dart';

class PortfolioPerformance extends StatelessWidget {
  final List<FlSpot> spots;

  const PortfolioPerformance({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.primaryAccent,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primaryAccent.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const PerformancePeriodSelector(),
      ],
    );
  }
}

class PerformancePeriodSelector extends ConsumerWidget {
  const PerformancePeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(investmentPeriodProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['1W', '1M', '3M', '6M', '1Y', 'ALL'].map((period) {
        final isSelected = period == selectedPeriod;
        return GestureDetector(
          onTap: () {
            ref.read(investmentPeriodProvider.notifier).state = period;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.surfaceHover : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              period,
              style: TextStyle(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
