import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import '../../../core/theme/app_colors.dart';
import 'menu_section_group.dart';
import 'menu_list_item.dart';

class AddActionBottomSheet extends StatelessWidget {
  const AddActionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.95,
              ),
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
              const SizedBox(height: 24),
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Record Activity',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Menu Sections
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cashflow Section
                      MenuSectionGroup(
                        title: 'Cashflow',
                        children: [
                          MenuListItem(
                            icon: UIcons.solidRounded.shopping_cart,
                            label: 'Expense',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Expense Form
                            },
                          ),
                          MenuListItem(
                            icon: UIcons.solidRounded.wallet,
                            label: 'Income',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Income Form
                            },
                          ),
                          MenuListItem(
                            icon: UIcons.solidRounded.exchange,
                            label: 'Transfer',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Transfer Form
                            },
                            showDivider: false,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Investments Section
                      MenuSectionGroup(
                        title: 'Investments',
                        children: [
                          MenuListItem(
                            icon: UIcons.solidRounded.arrow_down,
                            label: 'Buy',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Buy Form
                            },
                          ),
                          MenuListItem(
                            icon: UIcons.solidRounded.arrow_up,
                            label: 'Sell',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Sell Form
                            },
                            showDivider: false,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Assets Section
                      MenuSectionGroup(
                        title: 'Assets',
                        children: [
                          MenuListItem(
                            icon: UIcons.solidRounded.home,
                            label: 'Purchase',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Purchase Form
                            },
                          ),
                          MenuListItem(
                            icon: UIcons.solidRounded.money_bill_wave,
                            label: 'Sale',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Sale Form
                            },
                            showDivider: false,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Other Section
                      MenuSectionGroup(
                        title: 'Other',
                        children: [
                          MenuListItem(
                            icon: UIcons.solidRounded.edit,
                            label: 'Adjustment',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Adjustment Form
                            },
                            showDivider: false,
                          ),
                        ],
                      ),
                      
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
