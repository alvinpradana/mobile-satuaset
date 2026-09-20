import 'package:fl_chart/fl_chart.dart';
import 'wealth_summary_model.dart';

class InvestmentSummary {
  final double totalValue;
  final double returnPercentage;
  final double unrealizedPnL;
  final List<FlSpot> performanceHistory;
  final List<WealthAllocation> allocations;

  const InvestmentSummary({
    required this.totalValue,
    required this.returnPercentage,
    required this.unrealizedPnL,
    required this.performanceHistory,
    required this.allocations,
  });
}
