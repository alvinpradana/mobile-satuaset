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
    // Palette matching modern cyan dark mode
    final List<Color> colors = [
      AppColors.primaryAccent,
      const Color(0xFF38BDF8), // Sky Blue
      AppColors.textSecondary,
      const Color(0xFF475569), // Slate 600
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where your wealth is',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          // Allocation Bar
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
            runSpacing: 10,
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
      ),
    );
  }
}
