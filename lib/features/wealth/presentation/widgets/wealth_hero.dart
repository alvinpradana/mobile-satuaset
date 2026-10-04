import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
              fontSize: 40,
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
            Text(
              '+Rp 58.800.000 +${changePercentage.abs().toStringAsFixed(2)}%', // Mock nominal gain
              style: const TextStyle(
                color: AppColors.positive,
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
                  color: isSelected ? AppColors.textPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? AppColors.background : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
