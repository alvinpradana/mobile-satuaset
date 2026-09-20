import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_summary_model.dart';

class PortfolioAllocation extends StatelessWidget {
  final List<WealthAllocation> allocations;

  const PortfolioAllocation({super.key, required this.allocations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Allocation',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...allocations.map((allocation) => AllocationBar(allocation: allocation)),
      ],
    );
  }
}

class AllocationBar extends StatelessWidget {
  final WealthAllocation allocation;

  const AllocationBar({super.key, required this.allocation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                allocation.label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${allocation.percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * (allocation.percentage / 100),
                    decoration: BoxDecoration(
                      color: _getColorForLabel(allocation.label),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getColorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'stocks':
        return AppColors.primaryAccent;
      case 'crypto':
        return Colors.orangeAccent;
      case 'bonds':
        return Colors.lightBlueAccent;
      case 'cash':
        return AppColors.positive;
      default:
        return AppColors.textSecondary;
    }
  }
}
