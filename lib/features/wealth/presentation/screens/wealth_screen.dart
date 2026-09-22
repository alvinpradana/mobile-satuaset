import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/dashboard_header.dart';
import '../providers/wealth_provider.dart';
import '../widgets/wealth_hero.dart';
import '../widgets/assets_liabilities_summary.dart';
import '../widgets/wealth_allocation_bar.dart';
import '../widgets/wealth_domain_row.dart';
import '../widgets/goal_preview_card.dart';
import '../widgets/liabilities_reminder_card.dart';
import 'physical_assets_screen.dart';
import 'wealth_domain_detail_screen.dart';
import 'investment_detail_screen.dart';
import 'accounts_detail_screen.dart';
import 'liabilities_detail_screen.dart';
import 'goals_detail_screen.dart';

class WealthScreen extends ConsumerWidget {
  const WealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wealthSummary = ref.watch(wealthSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const DashboardHeader(showWelcomeText: false),
              const SizedBox(height: 32),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero
            WealthHero(
              netWorth: wealthSummary.netWorth,
              changePercentage: wealthSummary.netWorthChangePercentage,
            ),
            const SizedBox(height: 32),
            
            // Assets / Liabilities Summary
            AssetsLiabilitiesSummary(
              totalAssets: wealthSummary.totalAssets,
              totalLiabilities: wealthSummary.totalLiabilities,
            ),
            const SizedBox(height: 32),

            // Wealth Breakdown Module
            WealthAllocationBar(allocations: wealthSummary.allocations),
            const SizedBox(height: 32),

            // Financial Domain List
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'investments'),
                    icon: UIcons.solidRounded.chart_pie_alt,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const InvestmentDetailScreen(),
                        ),
                      );
                    },
                  ),
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'accounts'),
                    icon: UIcons.solidRounded.wallet,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (context) => const AccountsDetailScreen(),
                        ),
                      );
                    },
                  ),
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'physical_assets'),
                    icon: UIcons.solidRounded.home,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (context) => const PhysicalAssetsScreen(),
                        ),
                      );
                    },
                  ),
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'liabilities'),
                    icon: UIcons.solidRounded.file_invoice,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (context) => const LiabilitiesDetailScreen(),
                        ),
                      );
                    },
                  ),
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'goals'),
                    icon: UIcons.solidRounded.target,
                    showDivider: false,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (context) => const GoalsDetailScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

                    // Goal Preview
                    const GoalPreviewCard(),
                    const SizedBox(height: 24),
                    
                    // Liabilities Reminder
                    const LiabilitiesReminderCard(),
                    const SizedBox(height: 120), // Padding for bottom nav
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
