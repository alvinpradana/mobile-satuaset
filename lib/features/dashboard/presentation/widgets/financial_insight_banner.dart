import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:uicons/uicons.dart';

class FinancialInsightBanner extends StatelessWidget {
  const FinancialInsightBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryAccent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.sparkles,
              color: AppColors.primaryAccent,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: 'You saved '),
                    TextSpan(
                      text: 'Rp 17.000.000',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' this month — '),
                    TextSpan(
                      text: '12%',
                      style: TextStyle(
                        color: AppColors.positive,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' above your 6-month average.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
