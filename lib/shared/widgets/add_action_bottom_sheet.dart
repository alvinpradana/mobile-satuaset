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
                  'Add Record',
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
                    // Money Section
                      MenuSectionGroup(
                        title: 'Cashflow',
                        children: [
                          MenuListItem(
                            icon: UIcons.regularRounded.shopping_cart,
                            label: 'Expense',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Expense Form
                            },
                          ),
                          MenuListItem(
                            icon: UIcons.regularRounded.wallet,
                            label: 'Income',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Income Form
                            },
                          ),
                          MenuListItem(
                            icon: UIcons.regularRounded.exchange,
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
                      
                      // Wealth Section
                      MenuSectionGroup(
                        title: 'Wealth',
                        children: [
                          MenuListItem(
                            icon: UIcons.regularRounded.chart_pie_alt,
                            label: 'Investment',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Investment Form
                            },
                          ),
                          MenuListItem(
                            icon: UIcons.regularRounded.home,
                            label: 'Asset',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Asset Form
                            },
                          ),
                          MenuListItem(
                            icon: UIcons.regularRounded.file_invoice,
                            label: 'Liability',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to Liability Form
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
