import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

import 'package:uicons/uicons.dart';
import 'add_action_bottom_sheet.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTabSelected;

  const CustomBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Glassmorphism background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.85), // Increased opacity for visibility
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavItem(
                        icon: UIcons.solidRounded.home, 
                        label: 'Home', 
                        isActive: currentIndex == 0,
                        onTap: () => onTabSelected?.call(0),
                      ),
                      _NavItem(
                        icon: UIcons.solidRounded.clock, 
                        label: 'Activity', 
                        isActive: currentIndex == 1,
                        onTap: () => onTabSelected?.call(1),
                      ),
                      const SizedBox(width: 56), // Space for FAB
                      _NavItem(
                        icon: UIcons.solidRounded.layers, 
                        label: 'Wealth', 
                        isActive: currentIndex == 2,
                        onTap: () => onTabSelected?.call(2),
                      ),
                      _NavItem(
                        customIcon: BinanceMoreIcon(
                          color: currentIndex == 3 ? AppColors.primaryAccent : AppColors.textSecondary,
                          accentColor: const Color(0xFFF0B90B),
                          size: 18,
                        ), 
                        label: 'More', 
                        isActive: currentIndex == 3,
                        onTap: () => onTabSelected?.call(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Floating Action Button overlapping the top
          Positioned(
            top: -16,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const AddActionBottomSheet(),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Icon(
                  UIcons.solidRounded.plus,
                  color: AppColors.background,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    this.icon,
    this.customIcon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryAccent : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (customIcon != null)
            customIcon!
          else if (icon != null)
            Icon(
              icon, 
              color: color, 
              size: 18,
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class BinanceMoreIcon extends StatelessWidget {
  final Color color;
  final Color accentColor;
  final double size;

  const BinanceMoreIcon({
    super.key,
    required this.color,
    this.accentColor = const Color(0xFFF0B90B),
    this.size = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: BinanceMoreIconPainter(
        color: color,
        accentColor: accentColor,
      ),
    );
  }
}

class BinanceMoreIconPainter extends CustomPainter {
  final Color color;
  final Color accentColor;

  BinanceMoreIconPainter({
    required this.color,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final gap = size.width * 0.16;
    final itemSize = (size.width - gap) / 2;
    final radius = itemSize * 0.22;

    // 1. Top-Left Square (Outlined)
    final topLeftRect = Rect.fromLTWH(0, 0, itemSize, itemSize);
    canvas.drawRRect(
      RRect.fromRectAndRadius(topLeftRect, Radius.circular(radius)),
      strokePaint,
    );

    // 2. Top-Right Diamond (Filled)
    final topRightCenter = Offset(size.width - itemSize / 2, itemSize / 2);
    canvas.save();
    canvas.translate(topRightCenter.dx, topRightCenter.dy);
    canvas.rotate(0.785398); // 45 degrees (pi / 4)
    final diamondSize = itemSize * 0.72;
    final diamondRect = Rect.fromCenter(
      center: Offset.zero,
      width: diamondSize,
      height: diamondSize,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(diamondRect, Radius.circular(radius * 0.8)),
      fillPaint,
    );
    canvas.restore();

    // 3. Bottom-Left Circle (Outlined)
    final bottomLeftCenter = Offset(itemSize / 2, size.height - itemSize / 2);
    canvas.drawCircle(bottomLeftCenter, itemSize / 2, strokePaint);

    // 4. Bottom-Right Square (Outlined)
    final bottomRightRect = Rect.fromLTWH(
      size.width - itemSize,
      size.height - itemSize,
      itemSize,
      itemSize,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bottomRightRect, Radius.circular(radius)),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant BinanceMoreIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.accentColor != accentColor;
  }
}
