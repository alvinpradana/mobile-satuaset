import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/providers/privacy_provider.dart';
import '../../../../shared/widgets/privacy_toggle_button.dart';

class WealthHero extends ConsumerWidget {
  final double netWorth;
  final double changePercentage;

  const WealthHero({
    super.key,
    required this.netWorth,
    required this.changePercentage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isObscured = ref.watch(privacyProvider);
    
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    );
    String formattedNetWorth = currencyFormatter.format(netWorth).trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Total Net Worth',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 8),
            PrivacyToggleButton(color: AppColors.textSecondary, size: 14),
          ],
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            isObscured ? 'Rp •••••••••' : 'Rp $formattedNetWorth',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.0,
              letterSpacing: -0.8,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '+Rp 58.800.000', // Mock nominal gain
              style: TextStyle(
                color: AppColors.positive,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.positive.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    UIcons.regularRounded.arrow_trend_up,
                    size: 10,
                    color: AppColors.positive,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${changePercentage.abs().toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: AppColors.positive,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'this month',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Chart period selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['1H', '1D', '1W', '1M', 'YTD', '1Y', 'ALL'].map((period) {
            final isSelected = period == '1M';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
        ),
      ],
    );
  }
}
