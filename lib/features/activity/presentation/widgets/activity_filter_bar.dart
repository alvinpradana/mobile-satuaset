import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ActivityFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const ActivityFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Income', 'Expense', 'Transfer', 'Investment'];

    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {

              final filter = filters[index];
              final isSelected = filter == selectedFilter;

              return GestureDetector(
                onTap: () => onFilterSelected(filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryAccent.withOpacity(0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryAccent : AppColors.divider,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
          // Scroll indicator with gradient shadow
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 48,
              padding: const EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.background.withOpacity(0.0),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
