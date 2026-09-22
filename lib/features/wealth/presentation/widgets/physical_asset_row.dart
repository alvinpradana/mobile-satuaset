import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/physical_asset_model.dart';

class PhysicalAssetRow extends StatelessWidget {
  final PhysicalAssetModel asset;
  final VoidCallback onTap;

  const PhysicalAssetRow({
    super.key,
    required this.asset,
    required this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'property':
      case 'real estate':
        return UIcons.solidRounded.home;
      case 'vehicle':
      case 'vehicles':
        return UIcons.solidRounded.car;
      case 'gold':
      case 'jewelry':
        return UIcons.solidRounded.diamond;
      default:
        return UIcons.solidRounded.box;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    final compactCurrencyFormatter = NumberFormat.compactCurrency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final isSold = asset.status == PhysicalAssetStatus.sold;
    final valueToDisplay = isSold ? (asset.salePrice ?? 0) : asset.currentEstimatedValue;
    final gain = isSold ? asset.realizedGain : asset.estimatedGain;
    final gainPercentage = isSold ? asset.realizedGainPercentage : asset.estimatedGainPercentage;
    
    final isGainPositive = gain >= 0;
    final gainColor = isGainPositive ? AppColors.positive : AppColors.negative;
    final gainPrefix = isGainPositive ? '+' : '';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon (matching Accounts item icon style)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceHover,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(asset.category),
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Name & Purchase Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSold 
                      ? 'Sold ${compactCurrencyFormatter.format(asset.salePrice ?? 0)}'
                      : 'Purchase ${compactCurrencyFormatter.format(asset.purchasePrice)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            
            // Value & Gain
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormatter.format(valueToDisplay),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$gainPrefix${compactCurrencyFormatter.format(gain)}',
                      style: TextStyle(
                        color: gainColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: gainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isGainPositive 
                                ? UIcons.regularRounded.arrow_trend_up 
                                : UIcons.regularRounded.arrow_trend_down,
                            size: 8,
                            color: gainColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${gainPercentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: gainColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
