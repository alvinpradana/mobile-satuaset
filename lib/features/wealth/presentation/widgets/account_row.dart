import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_item.dart';

class AccountRow extends StatelessWidget {
  final WealthItem account;
  final VoidCallback onTap;

  const AccountRow({
    super.key,
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    final isArchived = account.status == WealthItemStatus.archived;
    
    // Subdued colors for archived
    final textColor = isArchived ? AppColors.textSecondary : AppColors.textPrimary;
    final iconColor = isArchived ? AppColors.textSecondary : AppColors.textPrimary;
    final statusColor = isArchived ? AppColors.textSecondary : AppColors.primaryAccent;
    final statusText = isArchived ? 'Archived' : 'Active';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceHover,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  account.iconData,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Middle section (Name, Provider, Identifier)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (account.institution != null)
                        Text(
                          account.institution!,
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(isArchived ? 0.5 : 1.0),
                            fontSize: 13,
                          ),
                        ),
                      if (account.institution != null && account.identifier != null)
                        Text(
                          ' · ',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(isArchived ? 0.5 : 1.0),
                            fontSize: 13,
                          ),
                        ),
                      if (account.identifier != null)
                        Text(
                          account.identifier!.length > 4 
                              ? '••••${account.identifier!.substring(account.identifier!.length - 4)}'
                              : account.identifier!,
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(isArchived ? 0.5 : 1.0),
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Right section (Balance, Status)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormatter.format(account.value),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(isArchived ? 0.5 : 1.0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
