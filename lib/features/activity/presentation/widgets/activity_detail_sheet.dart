import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/activity_item.dart';
import '../providers/activity_provider.dart';
import 'edit_investment_activity_sheet.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';

class ActivityDetailSheet extends ConsumerWidget {
  final ActivityItem activity;
  
  const ActivityDetailSheet({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    final DateFormat dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    Color amountColor = AppColors.textPrimary;
    String amountPrefix = '';
    
    if (activity.isPositive) {
      amountColor = AppColors.positive;
      amountPrefix = '+';
    } else if (activity.isNegative) {
      amountColor = AppColors.negative;
      amountPrefix = '-';
    }

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 32),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          
          // Header Type & Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForType(activity.type),
              color: amountColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            activity.title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$amountPrefix${currencyFormatter.format(activity.amount)}',
            style: TextStyle(
              color: amountColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dateFormatter.format(activity.date),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 32),
          
          // Metadata rows
          Builder(
            builder: (context) {
              final metaRows = <Map<String, String>>[];
              
              if (activity.account != null) {
                metaRows.add({
                  'label': (activity.type == ActivityType.investmentBuy || activity.type == ActivityType.investmentSell)
                      ? 'Platform / Broker'
                      : 'Account',
                  'value': activity.account!
                });
              }
              if (activity.quantity != null) {
                metaRows.add({'label': 'Units', 'value': '${activity.quantity} ${activity.asset ?? ''}'.trim()});
              }
              if (activity.quantity != null && activity.quantity! > 0) {
                metaRows.add({'label': 'Average Price', 'value': currencyFormatter.format(activity.amount / activity.quantity!)});
              }
              if (activity.destinationAccount != null) {
                metaRows.add({'label': 'To', 'value': activity.destinationAccount!});
              }
              if (activity.category != null) {
                metaRows.add({'label': 'Category', 'value': activity.category!});
              }
              if (activity.notes != null) {
                metaRows.add({'label': 'Notes', 'value': activity.notes!});
              }

              if (metaRows.isEmpty) return const SizedBox.shrink();

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  children: List.generate(metaRows.length, (index) {
                    final row = metaRows[index];
                    return _buildMetaRow(
                      row['label']!,
                      row['value']!,
                      isLast: index == metaRows.length - 1,
                    );
                  }),
                ),
              );
            }
          ),
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceHover,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: () {
                    // We don't pop first so the context remains valid for the next bottom sheet, or we pop and then show.
                    // Better to just push the edit sheet on top, or replace. Let's push it on top.
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EditInvestmentActivitySheet(activity: activity),
                    );
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.negative.withOpacity(0.1),
                    elevation: 0,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                      side: const BorderSide(color: AppColors.negative, width: 1),
                    ),
                  ),
                  onPressed: () {
                    _showDeleteConfirmation(context, ref);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: AppColors.negative,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // SafeArea padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
  
  Widget _buildMetaRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(color: AppColors.border.withOpacity(0.3), height: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Activity', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('Are you sure you want to delete this activity? This action cannot be undone.', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              ref.read(activityNotifierProvider.notifier).deleteActivity(activity.id);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              
              SuccessAlertDialog.show(
                context,
                title: 'Transaction Deleted',
                message: 'The transaction has been successfully deleted.',
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.negative, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.income:
        return UIcons.solidRounded.arrow_down;
      case ActivityType.expense:
        return UIcons.solidRounded.arrow_up;
      case ActivityType.transfer:
        return UIcons.solidRounded.exchange;
      case ActivityType.investmentBuy:
        return UIcons.solidRounded.shopping_cart;
      case ActivityType.investmentSell:
        return UIcons.solidRounded.coins;
      case ActivityType.assetPurchase:
        return UIcons.solidRounded.car;
      case ActivityType.liabilityPayment:
        return UIcons.solidRounded.receipt;
      case ActivityType.goalContribution:
        return UIcons.solidRounded.target;
      default:
        return UIcons.solidRounded.wallet;
    }
  }
}
