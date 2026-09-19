import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/activity_item.dart';
import '../providers/activity_provider.dart';

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
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForType(activity.type),
              color: AppColors.textPrimary,
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
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (activity.account != null)
                  _buildMetaRow('Account', activity.account!),
                if (activity.destinationAccount != null)
                  _buildMetaRow('To', activity.destinationAccount!),
                if (activity.category != null)
                  _buildMetaRow('Category', activity.category!),
                if (activity.notes != null)
                  _buildMetaRow('Notes', activity.notes!),
                if (activity.status != null)
                  _buildMetaRow('Status', activity.status!),
              ],
            ),
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Open Edit Form
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
  
  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
        return UIcons.solidRounded.stats;
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
