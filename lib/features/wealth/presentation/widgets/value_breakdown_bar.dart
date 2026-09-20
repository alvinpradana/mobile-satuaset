import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/physical_asset_model.dart';

class ValueBreakdownBar extends StatelessWidget {
  final List<AssetAllocation> allocations;

  const ValueBreakdownBar({
    super.key,
    required this.allocations,
  });

  // Dynamic colors for the segmented bar
  static const List<Color> _segmentColors = [
    AppColors.primaryAccent,
    Color(0xFF00E676), // Positive
    Color(0xFF69F0AE),
    Color(0xFF81C784),
    Color(0xFFAED581),
    Color(0xFFDCE775),
    Color(0xFFFFF176),
  ];

  @override
  Widget build(BuildContext context) {
    if (allocations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort allocations descending so the largest segment gets the primary color
    final sortedAllocations = List<AssetAllocation>.from(allocations)
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VALUE BREAKDOWN',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        
        // Segmented Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 12,
            child: Row(
              children: sortedAllocations.asMap().entries.map((entry) {
                final index = entry.key;
                final allocation = entry.value;
                final color = _segmentColors[index % _segmentColors.length];
                
                final flex = (allocation.percentage * 100).round();
                if (flex == 0) return const SizedBox.shrink();

                return Expanded(
                  flex: flex,
                  child: Container(color: color),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: sortedAllocations.asMap().entries.map((entry) {
            final index = entry.key;
            final allocation = entry.value;
            final color = _segmentColors[index % _segmentColors.length];
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  allocation.category,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${allocation.percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
