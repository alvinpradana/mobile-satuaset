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

            // Wealth Breakdown
            const Text(
              'Where your wealth is',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
                    icon: UIcons.regularRounded.chart_pie_alt,
                    onTap: () {},
                  ),
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'accounts'),
                    icon: UIcons.regularRounded.wallet,
                    onTap: () {},
                  ),
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'physical_assets'),
                    icon: UIcons.regularRounded.home,
                    onTap: () {},
                  ),
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'liabilities'),
                    icon: UIcons.regularRounded.file_invoice,
                    onTap: () {},
                  ),
                  WealthDomainRow(
                    domain: wealthSummary.domains.firstWhere((d) => d.id == 'goals'),
                    icon: UIcons.regularRounded.target,
                    showDivider: false,
                    onTap: () {},
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
