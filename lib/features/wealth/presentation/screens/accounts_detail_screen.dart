import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/wealth_provider.dart';
import '../widgets/account_row.dart';
import '../widgets/add_account_bottom_sheet.dart';
import 'account_management_screen.dart';

class AccountsDetailScreen extends ConsumerStatefulWidget {
  const AccountsDetailScreen({super.key});

  @override
  ConsumerState<AccountsDetailScreen> createState() => _AccountsDetailScreenState();
}

class _AccountsDetailScreenState extends ConsumerState<AccountsDetailScreen> {
  bool _isArchivedExpanded = false;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(wealthItemsProvider('accounts'));

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Filter active vs archived
    final activeItems = items.where((i) => i.status == WealthItemStatus.active).toList();
    final archivedItems = items.where((i) => i.status == WealthItemStatus.archived).toList();

    // Calculate total active cash
    final totalCash = activeItems.fold(0.0, (sum, item) => sum + item.value);

    // Group active items by category
    final groupedActiveItems = <String, List<WealthItem>>{};
    for (var item in activeItems) {
      groupedActiveItems.putIfAbsent(item.category, () => []).add(item);
    }

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
              'Accounts',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),

          // 2. Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Cash Hero
                  const Text(
                    'Total Cash',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(totalCash),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                        Icon(UIcons.regularRounded.wallet, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          '${activeItems.length} active accounts',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // Active Account Groups
                  ...groupedActiveItems.entries.map((entry) {
                    final category = entry.key;
                    final categoryItems = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...categoryItems.asMap().entries.map((itemEntry) {
                            final index = itemEntry.key;
                            final item = itemEntry.value;
                            return Column(
                              children: [
                                AccountRow(
                                  account: item,
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(
                                        builder: (context) => AccountManagementScreen(account: item),
                                      ),
                                    );
                                  },
                                ),
                                if (index < categoryItems.length - 1)
                                  const Divider(
                                    color: AppColors.border,
                                    height: 1,
                                    thickness: 1,
                                  ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 12),

                  // Archived Accounts Section
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isArchivedExpanded = !_isArchivedExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Archived Accounts',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AnimatedRotation(
                            turns: _isArchivedExpanded ? 0.25 : 0.0,
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
                  
                  if (_isArchivedExpanded)
                    if (archivedItems.isNotEmpty)
                      ...[
                        const Divider(color: AppColors.border, height: 24, thickness: 1),
                        ...archivedItems.map((item) {
                          return AccountRow(
                            account: item,
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => AccountManagementScreen(account: item),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ]
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'No archived accounts',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ),
                ],
              ),
            ),
          ),
          
          // Bottom padding so list items are not obscured by the bottom button
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24), // Matches CustomBottomNav margin
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AddAccountBottomSheet(),
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
              'Add new account',
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
