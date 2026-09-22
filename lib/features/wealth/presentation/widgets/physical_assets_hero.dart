import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/physical_asset_model.dart';

class PhysicalAssetsHero extends StatelessWidget {
  final PhysicalAssetsSummary summary;

  const PhysicalAssetsHero({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
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

    final isGainPositive = summary.totalEstimatedGain >= 0;
    final gainColor = isGainPositive ? AppColors.positive : AppColors.negative;
    final gainPrefix = isGainPositive ? '+' : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL VALUE',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormatter.format(summary.totalValue),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Estimated Gain
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$gainPrefix${compactCurrencyFormatter.format(summary.totalEstimatedGain)}',
              style: TextStyle(
                color: gainColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: gainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    isGainPositive 
                        ? UIcons.regularRounded.arrow_trend_up 
                        : UIcons.regularRounded.arrow_trend_down,
                    size: 10,
                    color: gainColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${summary.totalGainPercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: gainColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'vs purchase cost',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
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
              Icon(UIcons.regularRounded.box, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '${summary.activeAssetsCount} active assets',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
