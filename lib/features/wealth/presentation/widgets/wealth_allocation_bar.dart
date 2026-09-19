import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_summary_model.dart';

class WealthAllocationBar extends StatelessWidget {
  final List<WealthAllocation> allocations;

  const WealthAllocationBar({
    super.key,
    required this.allocations,
  });

  @override
  Widget build(BuildContext context) {
    // Generate colors based on app theme
    final List<Color> colors = [
      AppColors.primaryAccent,
      AppColors.textSecondary,
      const Color(0xFF6B7280), // Gray 500
      const Color(0xFF374151), // Gray 700
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Allocation Bar
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: List.generate(allocations.length, (index) {
              final alloc = allocations[index];
              return Expanded(
                flex: (alloc.percentage * 10).toInt(),
                child: Container(
                  color: colors[index % colors.length],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: List.generate(allocations.length, (index) {
            final alloc = allocations[index];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  alloc.label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${alloc.percentage.toInt()}%',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
