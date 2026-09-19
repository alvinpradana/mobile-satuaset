import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:uicons/uicons.dart';

class MenuListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const MenuListItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), // Matches container roughly if ripple goes to edge
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.textPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
