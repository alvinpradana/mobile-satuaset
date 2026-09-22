import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/saving_goal_model.dart';
import '../providers/wealth_provider.dart';
import '../widgets/add_goal_bottom_sheet.dart';

class GoalsDetailScreen extends ConsumerStatefulWidget {
  const GoalsDetailScreen({super.key});

  @override
  ConsumerState<GoalsDetailScreen> createState() => _GoalsDetailScreenState();
}

class _GoalsDetailScreenState extends ConsumerState<GoalsDetailScreen> {
  bool _isCompletedExpanded = false;

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(savingGoalsProvider);

    final activeGoals = goals.where((g) => g.status == SavingGoalStatus.active).toList();
    final completedGoals = goals.where((g) => g.status == SavingGoalStatus.completed).toList();

    final totalSaved = goals.fold<double>(0, (sum, g) => sum + g.currentAmount);
    final totalTarget = goals.fold<double>(0, (sum, g) => sum + g.targetAmount);
    final overallProgressPct = totalTarget > 0 ? (totalSaved / totalTarget) : 0.0;

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final compactCurrencyFormatter = NumberFormat.compactCurrency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Icon(UIcons.regularRounded.angle_left, color: AppColors.textPrimary, size: 20),
                  ),
                ),
              ),
            ),
            title: const Text(
              'Saving Goals',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
                child: GestureDetector(
                  onTap: () {},
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Icon(UIcons.regularRounded.search, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                ),
              )
            ],
          ),

          // 2. Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  const Text(
                    'TOTAL SAVED IN GOALS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(totalSaved),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(UIcons.solidRounded.target, size: 14, color: AppColors.primaryAccent),
                            const SizedBox(width: 8),
                            Text(
                              '${activeGoals.length} active goals',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(UIcons.solidRounded.chart_histogram, size: 12, color: AppColors.primaryAccent),
                            const SizedBox(width: 6),
                            Text(
                              '${(overallProgressPct * 100).toStringAsFixed(1)}% of total target',
                              style: const TextStyle(
                                color: AppColors.primaryAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Overall Target Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Target Accumulation',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              currencyFormatter.format(totalTarget),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: overallProgressPct,
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceHover,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Section Title
                  const Text(
                    'ACTIVE SAVING GOALS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Active Goals Cards
                  if (activeGoals.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.surfaceHover.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(UIcons.solidRounded.target, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No active saving goals',
                            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Start planning your financial targets by creating a new goal.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  else
                    ...activeGoals.map((goal) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _SavingGoalCard(
                          goal: goal,
                          currencyFormatter: currencyFormatter,
                          compactCurrencyFormatter: compactCurrencyFormatter,
                        ),
                      );
                    }),

                  const SizedBox(height: 16),

                  // Completed Goals Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCompletedExpanded = !_isCompletedExpanded;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'COMPLETED GOALS',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              AnimatedRotation(
                                turns: _isCompletedExpanded ? 0.25 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  UIcons.regularRounded.angle_right,
                                  color: AppColors.textSecondary,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(width: double.infinity),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (completedGoals.isNotEmpty) ...[
                              const Divider(color: AppColors.border, height: 16, thickness: 1),
                              ...completedGoals.map((goal) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: _SavingGoalCard(
                                      goal: goal,
                                      currencyFormatter: currencyFormatter,
                                      compactCurrencyFormatter: compactCurrencyFormatter,
                                    ),
                                  ),
                                );
                              }),
                            ] else
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  'No completed goals yet',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ),
                          ],
                        ),
                        crossFadeState: _isCompletedExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 250),
                      ),
                    ],
                  ),

                  // Bottom spacing
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AddGoalBottomSheet(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Create new goal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SavingGoalCard extends StatelessWidget {
  final SavingGoal goal;
  final NumberFormat currencyFormatter;
  final NumberFormat compactCurrencyFormatter;

  const _SavingGoalCard({
    required this.goal,
    required this.currencyFormatter,
    required this.compactCurrencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = goal.status == SavingGoalStatus.completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Icon, Title & Category Badge
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: goal.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    goal.iconData,
                    color: goal.color,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.category,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.positive.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(UIcons.solidRounded.shield_check, size: 12, color: AppColors.positive),
                      const SizedBox(width: 4),
                      const Text(
                        'Achieved',
                        style: TextStyle(
                          color: AppColors.positive,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${goal.remainingMonths} mos left',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: Saved / Target Amounts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: currencyFormatter.format(goal.currentAmount),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${currencyFormatter.format(goal.targetAmount)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(goal.progressPercentage * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: goal.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: goal.progressPercentage,
              minHeight: 8,
              backgroundColor: AppColors.surfaceHover,
              valueColor: AlwaysStoppedAnimation<Color>(goal.color),
            ),
          ),
          const SizedBox(height: 14),

          // Footer info: Recommended monthly deposit & Connected Account
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isCompleted && goal.recommendedMonthlyDeposit > 0)
                Row(
                  children: [
                    Icon(UIcons.regularRounded.clock, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${compactCurrencyFormatter.format(goal.recommendedMonthlyDeposit)}/mo deposit',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else if (isCompleted)
                Row(
                  children: [
                    Icon(UIcons.solidRounded.shield_check, size: 12, color: AppColors.positive),
                    const SizedBox(width: 4),
                    const Text(
                      'Target 100% Reached',
                      style: TextStyle(
                        color: AppColors.positive,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(),

              if (goal.accountName != null)
                Row(
                  children: [
                    Icon(UIcons.solidRounded.wallet, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      goal.accountName!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
