import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:uicons/uicons.dart';

class DashboardHeader extends StatelessWidget {
  final bool showWelcomeText;

  const DashboardHeader({super.key, this.showWelcomeText = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'S',
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              // Right side actions
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          UIcons.solidRounded.bell,
                          color: AppColors.textSecondary,
                          size: 14,
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.negative,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 16,
                    color: AppColors.divider,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'A',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showWelcomeText) ...[
            const SizedBox(height: 32),
            const Text(
              'Welcome, Alvin!',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
