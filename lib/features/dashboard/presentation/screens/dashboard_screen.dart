import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/net_worth_summary.dart';
import '../widgets/financial_insight_banner.dart';
import '../widgets/asset_allocation_carousel.dart';
import '../widgets/financial_goals_list.dart';
import '../widgets/recent_activity_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  DashboardHeader(),
                  SizedBox(height: 32),
                  NetWorthSummary(),
                  SizedBox(height: 24),
                  FinancialInsightBanner(),
                  SizedBox(height: 32),
                  AssetAllocationCarousel(),
                  SizedBox(height: 40),
                  FinancialGoalsList(),
                  SizedBox(height: 40),
                  RecentActivityList(),
                  SizedBox(height: 120), // Padding for the floating dock
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const CustomBottomNav(),
          ),
        ],
      ),
    );
  }
}
