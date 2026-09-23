import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_summary_model.dart';

class PortfolioAllocation extends StatefulWidget {
  final List<WealthAllocation> allocations;
  final double? totalValue;

  const PortfolioAllocation({super.key, required this.allocations, this.totalValue});

  @override
  State<PortfolioAllocation> createState() => _PortfolioAllocationState();
}

class _PortfolioAllocationState extends State<PortfolioAllocation> {
  int? _selectedIndex = 0; // Default open for first asset

  // Dynamic colors for the segmented bar, matching ValueBreakdownBar
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
    if (widget.allocations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort allocations descending so the largest segment gets the primary color
    final sortedAllocations = List<WealthAllocation>.from(widget.allocations)
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    final currencyFormatter = widget.totalValue != null ? NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PORTFOLIO ALLOCATION',
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
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = _selectedIndex == index ? null : index;
                      });
                    },
                    child: Container(
                      color: _selectedIndex == null || _selectedIndex == index 
                          ? color 
                          : color.withOpacity(0.3), // Highlight selected
                    ),
                  ),
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
            final isSelected = _selectedIndex == index;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = isSelected ? null : index;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: _selectedIndex == null || isSelected ? color : color.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            allocation.label,
                            style: TextStyle(
                              color: _selectedIndex == null || isSelected ? AppColors.textPrimary : AppColors.textSecondary,
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
                      ),
                      if (isSelected && widget.totalValue != null && currencyFormatter != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          currencyFormatter.format(widget.totalValue! * allocation.percentage / 100),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
