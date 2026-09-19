import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';

class GoalPreviewCard extends StatelessWidget {
  const GoalPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your priority goal',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Icon(
                UIcons.regularRounded.target,
                color: AppColors.primaryAccent.withOpacity(0.8),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Beli Rumah',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Rp 650.000.000',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Rp 1.200.000.000',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 54,
                        child: Container(
                          color: AppColors.positive,
                        ),
                      ),
                      Expanded(
                        flex: 46,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '54%',
                style: TextStyle(
                  color: AppColors.positive,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
