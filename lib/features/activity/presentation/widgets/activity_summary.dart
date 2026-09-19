import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

class ActivitySummary extends StatelessWidget {
  final double income;
  final double expense;

  const ActivitySummary({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final netCashflow = income - expense;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Income', '+${currencyFormatter.format(income)}', AppColors.positive)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard('Expense', '-${currencyFormatter.format(expense)}', AppColors.negative)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildSummaryCard('Net', '${netCashflow >= 0 ? '+' : ''}${currencyFormatter.format(netCashflow)}', netCashflow >= 0 ? AppColors.positive : AppColors.negative),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color amountColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
