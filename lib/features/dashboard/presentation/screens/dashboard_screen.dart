import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primaryAccent,
          backgroundColor: AppColors.surface,
          onRefresh: () async {
            // TODO: Implement actual API refresh logic here
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const DashboardHeader(),
                const SizedBox(height: 32),
                const NetWorthSummary(),
                const SizedBox(height: 24),
                const FinancialInsightBanner(),
                const SizedBox(height: 32),
                const AssetAllocationCarousel(),
                const SizedBox(height: 40),
                const FinancialGoalsList(),
                const SizedBox(height: 40),
                const RecentActivityList(),
                const SizedBox(height: 120), // Padding for the floating dock
              ],
            ),
          ),
        ),
      ),
    );
  }
}
