import 'dart:async';
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
  Timer? _hideTimer;

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
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _selectedIndex = null;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
        _hideTimer?.cancel();
      } else {
        _selectedIndex = index;
        _startHideTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.allocations.isEmpty) {
      return const SizedBox.shrink();
    }

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
                    onTap: () => _onItemTapped(index),
                    child: Container(
                      color: _selectedIndex == null || _selectedIndex == index 
                          ? color 
                          : color.withOpacity(0.3),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 28), // Added extra space for tooltip overlap
        
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 24, // Added more run spacing for tooltips
          children: sortedAllocations.asMap().entries.map((entry) {
            final index = entry.key;
            final allocation = entry.value;
            final color = _segmentColors[index % _segmentColors.length];
            final isSelected = _selectedIndex == index;
            
            String formattedValue = '';
            if (widget.totalValue != null && currencyFormatter != null) {
              formattedValue = currencyFormatter.format(widget.totalValue! * allocation.percentage / 100);
            }
            
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              behavior: HitTestBehavior.opaque,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Base Label
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _selectedIndex == null || isSelected ? color : color.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
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
                  
                  // Tooltip
                  if (formattedValue.isNotEmpty)
                    Positioned(
                      bottom: 24, // Push above the text
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: AnimatedScale(
                            scale: isSelected ? 1.0 : 0.8,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutBack,
                            child: _BubbleTooltip(text: formattedValue),
                          ),
                        ),
                      ),
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

class _BubbleTooltip extends StatelessWidget {
  final String text;

  const _BubbleTooltip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1), // Purple-ish matching screenshot
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ),
        CustomPaint(
          size: const Size(12, 6),
          painter: _TrianglePainter(color: const Color(0xFF6366F1)),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
