import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import '../../../core/theme/app_colors.dart';
import 'menu_list_item.dart';

class AddActionBottomSheet extends StatelessWidget {
  const AddActionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Record Activity',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            UIcons.regularRounded.cross,
                            color: AppColors.textSecondary,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section 1: Quick Actions (2x2 Grid)
                  const Text(
                    'QUICK ACTIONS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2x2 Grid Row 1
                  Row(
                    children: [
                      _buildQuickActionTile(
                        context: context,
                        icon: UIcons.solidRounded.shopping_cart,
                        label: 'Expense',
                        subtitle: 'Daily cash outflow',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navigate to Expense Form
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildQuickActionTile(
                        context: context,
                        icon: UIcons.solidRounded.wallet,
                        label: 'Income',
                        subtitle: 'Salary & revenue',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navigate to Income Form
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 2x2 Grid Row 2
                  Row(
                    children: [
                      _buildQuickActionTile(
                        context: context,
                        icon: UIcons.solidRounded.stats,
                        label: 'Buy Investment',
                        subtitle: 'Stocks, crypto, gold',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navigate to Buy Form
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildQuickActionTile(
                        context: context,
                        icon: UIcons.solidRounded.exchange,
                        label: 'Transfer',
                        subtitle: 'Account to account',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navigate to Transfer Form
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section 2: Other Transactions (Grouped Surface List)
                  const Text(
                    'OTHER TRANSACTIONS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        MenuListItem(
                          icon: UIcons.solidRounded.arrow_up,
                          label: 'Sell Investment',
                          subtitle: 'Liquidate portfolio holdings',
                          iconColor: AppColors.textPrimary,
                          iconBackgroundColor: AppColors.surfaceHover,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to Sell Form
                          },
                        ),
                        MenuListItem(
                          icon: UIcons.solidRounded.home,
                          label: 'Asset Purchase & Sale',
                          subtitle: 'Real estate, vehicles & valuables',
                          iconColor: AppColors.textPrimary,
                          iconBackgroundColor: AppColors.surfaceHover,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to Asset Transaction Form
                          },
                        ),
                        MenuListItem(
                          icon: UIcons.solidRounded.edit,
                          label: 'Balance Adjustment',
                          subtitle: 'Fix wallet or account balances',
                          iconColor: AppColors.textPrimary,
                          iconBackgroundColor: AppColors.surfaceHover,
                          showDivider: false,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to Adjustment Form
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

