import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/recent_activity.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final activities = [
      RecentActivity(title: 'Gaji Bulanan', amount: 15000000, type: ActivityType.income, date: 'Hari ini, 09:00'),
      RecentActivity(title: 'Starbucks', amount: 65000, type: ActivityType.expense, date: 'Hari ini, 07:30'),
      RecentActivity(title: 'Pindah ke BCA', amount: 500000, type: ActivityType.transfer, date: 'Kemarin, 16:20'),
      RecentActivity(title: 'Top Up Gopay', amount: 200000, type: ActivityType.expense, date: 'Kemarin, 14:15'),
      RecentActivity(title: 'Dividen Saham', amount: 125000, type: ActivityType.income, date: '15 Sep 2026'),
    ];

    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to Activity History
                },
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      UIcons.regularRounded.angle_right,
                      color: AppColors.textSecondary,
                      size: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.divider, height: 1),
              ),
              itemBuilder: (context, index) {
                final activity = activities[index];
                
                IconData getIcon() {
                  switch (activity.type) {
                    case ActivityType.income: return UIcons.solidRounded.arrow_down;
                    case ActivityType.expense: return UIcons.solidRounded.arrow_up;
                    case ActivityType.transfer: return UIcons.solidRounded.exchange;
                  }
                }
                
                Color getIconColor() {
                  switch (activity.type) {
                    case ActivityType.income: return AppColors.positive;
                    case ActivityType.expense: return AppColors.negative;
                    case ActivityType.transfer: return AppColors.textSecondary;
                  }
                }

                Color getAmountColor() {
                  switch (activity.type) {
                    case ActivityType.income: return AppColors.positive;
                    case ActivityType.expense: return AppColors.negative;
                    case ActivityType.transfer: return AppColors.textPrimary;
                  }
                }

                String getSign() {
                  switch (activity.type) {
                    case ActivityType.income: return '+';
                    case ActivityType.expense: return '-';
                    case ActivityType.transfer: return '-';
                  }
                }

                return Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        getIcon(),
                        color: getIconColor(),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.date,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${getSign()}${currencyFormatter.format(activity.amount).replaceAll(',00', '')}',
                      style: TextStyle(
                        color: getAmountColor(),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
