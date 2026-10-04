import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../../../activity/presentation/screens/activity_screen.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../wealth/presentation/screens/wealth_tab_navigator.dart';
import '../../../more/presentation/screens/more_screen.dart';
import '../providers/main_navigation_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    DashboardScreen(),
    ActivityScreen(),
    WealthTabNavigator(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainNavigationProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Render the current screen
          _screens[currentIndex],
          
          // Gradient shadow to smoothly fade out the content behind the bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withOpacity(0.0),
                      AppColors.background.withOpacity(0.8),
                      AppColors.background,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom Navigation overlapping the screen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNav(
              currentIndex: currentIndex,
              onTabSelected: (index) {
                ref.read(mainNavigationProvider.notifier).state = index;
              },
            ),
          ),
        ],
      ),
    );
  }
}
