import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:uicons/uicons.dart';

class MenuListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showDivider;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String? badgeText;

  const MenuListItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.showDivider = true,
    this.iconColor,
    this.iconBackgroundColor,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.textPrimary;
    final effectiveBgColor = iconBackgroundColor ?? AppColors.surfaceHover;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: effectiveBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      color: effectiveIconColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (badgeText != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  badgeText!,
                                  style: const TextStyle(
                                    color: AppColors.primaryAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    UIcons.regularRounded.angle_right,
                    color: AppColors.textSecondary,
                    size: 14,
                  ),
                ],
              ),
            ),
            if (showDivider)
              const Divider(
                color: AppColors.divider,
                height: 1,
                thickness: 1,
              ),
          ],
        ),
      ),
    );
  }
}
