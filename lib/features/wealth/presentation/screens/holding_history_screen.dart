import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_item.dart';
import '../../../activity/domain/models/activity_item.dart';
import '../../../activity/presentation/widgets/activity_row.dart';
import '../../../activity/presentation/widgets/activity_detail_sheet.dart';

class HoldingHistoryScreen extends StatelessWidget {
  final WealthItem item;

  const HoldingHistoryScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Helper to get platform/broker name for mock activities
    final allocations = item.exchangeAllocations;
    final primaryPlatform = item.institution ?? 'Primary Platform';
    final platform1 = (allocations != null && allocations.isNotEmpty) ? allocations[0].exchangeName : primaryPlatform;
    final platform2 = (allocations != null && allocations.length > 1) ? allocations[1].exchangeName : primaryPlatform;

    final List<ActivityItem> mockActivities = [
      ActivityItem(
        id: 'h1',
        type: ActivityType.investmentBuy,
        title: 'Buy ${item.name}',
        amount: 2500000,
        currency: item.currency,
        date: now,
        asset: item.name,
        quantity: 0.15,
        account: platform1,
        status: 'Completed',
      ),
      ActivityItem(
        id: 'h2',
        type: ActivityType.investmentBuy,
        title: 'Buy ${item.name}',
        amount: 5000000,
        currency: item.currency,
        date: now.subtract(const Duration(days: 1)),
        asset: item.name,
        quantity: 0.35,
        account: platform2,
        status: 'Completed',
      ),
      ActivityItem(
        id: 'h3',
        type: ActivityType.investmentSell,
        title: 'Sell ${item.name}',
        amount: 1500000,
        currency: item.currency,
        date: now.subtract(const Duration(days: 4)),
        asset: item.name,
        quantity: 0.1,
        account: platform1,
        status: 'Completed',
      ),
      ActivityItem(
        id: 'h4',
        type: ActivityType.investmentBuy,
        title: 'Buy ${item.name}',
        amount: 2000000,
        currency: item.currency,
        date: now.subtract(const Duration(days: 15)),
        asset: item.name,
        quantity: 0.12,
        account: platform2,
        status: 'Completed',
      ),
      ActivityItem(
        id: 'h5',
        type: ActivityType.investmentBuy,
        title: 'Buy ${item.name}',
        amount: 10000000,
        currency: item.currency,
        date: now.subtract(const Duration(days: 45)),
        asset: item.name,
        quantity: 0.6,
        account: platform1,
        status: 'Completed',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
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
            title: Text(
              '${item.name} History',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          
          _buildActivityList(mockActivities),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(List<ActivityItem> activities) {
    Map<String, List<ActivityItem>> grouped = {};
    final DateFormat headerFormat = DateFormat('dd MMM yyyy');
    
    for (var activity in activities) {
      String key;
      final now = DateTime.now();
      final date = activity.date;
      
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        key = 'TODAY';
      } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
        key = 'YESTERDAY';
      } else {
        key = headerFormat.format(date).toUpperCase();
      }
      
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(activity);
    }

    final keys = grouped.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final key = keys[index];
          final items = grouped[key]!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    key,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: List.generate(items.length, (i) {
                      final item = items[i];
                      return Column(
                        children: [
                          ActivityRow(
                            activity: item,
                            isFirst: i == 0,
                            isLast: i == items.length - 1,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => ActivityDetailSheet(activity: item),
                              );
                            },
                          ),
                          if (i < items.length - 1)
                            const Divider(color: AppColors.divider, height: 1, indent: 16, endIndent: 16),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
        childCount: keys.length,
      ),
    );
  }
}
