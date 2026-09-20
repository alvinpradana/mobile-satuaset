import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_item.dart';

class WealthItemRow extends StatelessWidget {
  final WealthItem item;
  final VoidCallback onTap;

  const WealthItemRow({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: item.currency == 'Rp' ? 'id_ID' : 'en_US',
      symbol: item.currency == 'Rp' ? 'Rp ' : '\$',
      decimalDigits: item.currency == 'Rp' ? 0 : 2,
    );

    final isNegative = item.value < 0;
    // Main value color is usually white, unless it's a liability (which might be red)
    // Actually, in the screenshot, prices are white.
    final valueColor = AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // Icon / Avatar
            SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: Icon(
                  item.iconData,
                  color: AppColors.textPrimary, // Changed to textPrimary for more elegance, less 'glowing'
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.institution != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.institution!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Value and Percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormatter.format(item.value),
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.percentageChange != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: (item.percentageChange! > 0 ? AppColors.positive : AppColors.negative).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.percentageChange! > 0 
                              ? UIcons.regularRounded.arrow_trend_up 
                              : UIcons.regularRounded.arrow_trend_down,
                          size: 8,
                          color: item.percentageChange! > 0 ? AppColors.positive : AppColors.negative,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${item.percentageChange!.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: item.percentageChange! > 0 ? AppColors.positive : AppColors.negative,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
