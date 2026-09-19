import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
              // Header
              const Text(
                'Menu',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              
              // Tools Section
              MenuSectionGroup(
                title: 'Tools',
                children: [
                  MenuListItem(
                    icon: UIcons.regularRounded.chart_pie_alt,
                    label: 'Reports',
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.regularRounded.eye,
                    label: 'Watchlist',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              
              // Account Section
              MenuSectionGroup(
                title: 'Account',
                children: [
                  MenuListItem(
                    icon: UIcons.regularRounded.user,
                    label: 'Profile',
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.regularRounded.bell,
                    label: 'Notifications',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              
              // Settings Section
              MenuSectionGroup(
                title: 'Settings',
                children: [
                  MenuListItem(
                    icon: UIcons.regularRounded.settings_sliders,
                    label: 'Preferences',
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.regularRounded.shield,
                    label: 'Security',
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.regularRounded.lock,
                    label: 'Privacy',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              
              // Support Section
              MenuSectionGroup(
                title: 'Support',
                children: [
                  MenuListItem(
                    icon: UIcons.regularRounded.interrogation,
                    label: 'Help',
                    onTap: () {},
                  ),
                  MenuListItem(
                    icon: UIcons.regularRounded.info,
                    label: 'About',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              
              const SizedBox(height: 120), // Padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
