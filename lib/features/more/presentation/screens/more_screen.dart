import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/menu_section_group.dart';
import '../../../../shared/widgets/menu_list_item.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title
              const Text(
                'Menu',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),

              // 1. User Profile Header Card
              _buildProfileCard(context),
              const SizedBox(height: 24),

              // 2. Core Tools (2 Tiles Grid)
              _buildCoreToolsGrid(context),
              const SizedBox(height: 24),

              // 3. Account & Preferences Group
              MenuSectionGroup(
                title: 'Account & Preferences',
                children: [
                  MenuListItem(
                    icon: UIcons.solidRounded.user,
                    label: 'Profile',
                    iconColor: AppColors.primaryAccent,
                    iconBackgroundColor: AppColors.primaryAccent.withOpacity(0.12),
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.solidRounded.bell,
                    label: 'Notifications',
                    iconColor: const Color(0xFFF59E0B),
                    iconBackgroundColor: const Color(0xFFF59E0B).withOpacity(0.12),
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.solidRounded.settings_sliders,
                    label: 'Preferences',
                    iconColor: const Color(0xFF3B82F6),
                    iconBackgroundColor: const Color(0xFF3B82F6).withOpacity(0.12),
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),

              // 4. Security & Data Group
              MenuSectionGroup(
                title: 'Security & Data',
                children: [
                  MenuListItem(
                    icon: UIcons.solidRounded.shield,
                    label: 'Security & PIN',
                    iconColor: const Color(0xFF10B981),
                    iconBackgroundColor: const Color(0xFF10B981).withOpacity(0.12),
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.solidRounded.document,
                    label: 'Export Data',
                    iconColor: const Color(0xFF8B5CF6),
                    iconBackgroundColor: const Color(0xFF8B5CF6).withOpacity(0.12),
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),

              // 5. Support & About Group
              MenuSectionGroup(
                title: 'Support & App Info',
                children: [
                  MenuListItem(
                    icon: UIcons.solidRounded.interrogation,
                    label: 'Help & FAQ',
                    iconColor: const Color(0xFF06B6D4),
                    iconBackgroundColor: const Color(0xFF06B6D4).withOpacity(0.12),
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.solidRounded.info,
                    label: 'About SatuAset',
                    iconColor: AppColors.textSecondary,
                    iconBackgroundColor: AppColors.surfaceHover,
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 6. Sign Out Button
              _buildSignOutButton(context),

              const SizedBox(height: 120), // Padding for bottom nav bar
            ],
          ),
        ),
      ),
    );
  }

  // User Profile Header Card Widget
  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHover,
            ),
            alignment: Alignment.center,
            child: const Text(
              'AN',
              style: TextStyle(
                color: AppColors.primaryAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // User Info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alvin Novian',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'alvin@satuaset.id',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Right chevron
          Icon(
            UIcons.regularRounded.angle_right,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }

  // Core Tools 2 Tile Grid Widget
  Widget _buildCoreToolsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildToolCard(
            icon: UIcons.solidRounded.chart_pie_alt,
            title: 'Reports',
            accentColor: const Color(0xFF68E3F3),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToolCard(
            icon: UIcons.solidRounded.target,
            title: 'Financial Goals',
            accentColor: const Color(0xFF10B981),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  // Individual Tool Tile Widget
  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign Out Button Widget
  Widget _buildSignOutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.negative.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.negative.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement Sign Out
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  UIcons.solidRounded.exit,
                  color: AppColors.negative,
                  size: 18,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: AppColors.negative,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
