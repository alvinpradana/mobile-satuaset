import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../../../activity/presentation/screens/activity_screen.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../wealth/presentation/screens/wealth_tab_navigator.dart';
import '../../../more/presentation/screens/more_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ActivityScreen(),
    const WealthTabNavigator(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Render the current screen
          _screens[_currentIndex],
          
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
              currentIndex: _currentIndex,
              onTabSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
