import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/providers/privacy_provider.dart';

class AssetsLiabilitiesSummary extends ConsumerWidget {
  final double totalAssets;
  final double totalLiabilities;

  const AssetsLiabilitiesSummary({
    super.key,
    required this.totalAssets,
    required this.totalLiabilities,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MetricPair(
              label: 'Assets',
              value: totalAssets,
              isObscured: ref.watch(privacyProvider),
              isPositive: true,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: _MetricPair(
              label: 'Liabilities',
              value: totalLiabilities,
              isObscured: ref.watch(privacyProvider),
              isPositive: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPair extends StatelessWidget {
  final String label;
  final double value;
  final bool isObscured;
  final bool isPositive;

  const _MetricPair({
    required this.label,
    required this.value,
    required this.isObscured,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    );
    String formattedValue = currencyFormatter.format(value).trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isObscured ? 'Rp ••••••' : 'Rp $formattedValue',
          style: TextStyle(
            color: isPositive ? AppColors.textPrimary : AppColors.negative,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
