import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/activity_item.dart';
import '../../../../core/theme/app_colors.dart';

class ActivityRow extends StatelessWidget {
  final ActivityItem activity;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const ActivityRow({
    super.key,
    required this.activity,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: activity.currency == 'IDR' ? 'Rp ' : '${activity.currency} ',
      decimalDigits: 0,
    );

    final borderRadius = BorderRadius.vertical(
      top: isFirst ? const Radius.circular(16) : Radius.zero,
      bottom: isLast ? const Radius.circular(16) : Radius.zero,
    );

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            _buildIcon(),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildContextLine(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getAmountString(currencyFormatter),
                  style: TextStyle(
                    color: _getAmountColor(),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    if (activity.isPositive) {
      iconData = Icons.arrow_downward;
      iconColor = AppColors.positive;
    } else if (activity.isNegative) {
      iconData = Icons.arrow_upward;
      iconColor = AppColors.negative;
    } else {
      iconData = Icons.sync_alt; // Transfer/Neutral
      iconColor = AppColors.textSecondary;
    }

    // Specific overrides
    if (activity.type == ActivityType.investmentBuy || activity.type == ActivityType.investmentSell) {
      iconData = Icons.show_chart;
      iconColor = AppColors.primaryAccent;
    } else if (activity.type == ActivityType.assetPurchase || activity.type == ActivityType.assetSale) {
      iconData = Icons.directions_car; // Generic asset icon
      iconColor = AppColors.textPrimary;
    } else if (activity.type == ActivityType.liabilityPayment) {
      iconData = Icons.receipt_long;
      iconColor = AppColors.negative;
    } else if (activity.type == ActivityType.goalContribution) {
      iconData = Icons.track_changes;
      iconColor = AppColors.primaryAccent;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider),
      ),
      alignment: Alignment.center,
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  Widget _buildContextLine() {
    final timeFormat = DateFormat('HH:mm');
    String contextText = '';

    if (activity.type == ActivityType.transfer && activity.destinationAccount != null) {
      contextText = '${activity.account} → ${activity.destinationAccount} · ${timeFormat.format(activity.date)}';
    } else if (activity.type == ActivityType.investmentBuy || activity.type == ActivityType.investmentSell) {
      contextText = '${activity.quantity} ${activity.asset} · ${activity.account}';
    } else {
      contextText = '${activity.account ?? ''} · ${timeFormat.format(activity.date)}';
    }

    return Text(
      contextText,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _getAmountString(NumberFormat formatter) {
    String prefix = '';
    if (activity.isPositive) prefix = '+';
    if (activity.isNegative) prefix = '-';
    // Neutral (like transfer) gets no prefix by default, just the amount.
    return '$prefix${formatter.format(activity.amount)}';
  }

  Color _getAmountColor() {
    if (activity.isPositive) return AppColors.positive;
    if (activity.isNegative) return AppColors.negative;
    return AppColors.textPrimary; // Neutral
  }
}
