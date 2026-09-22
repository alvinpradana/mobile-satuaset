import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_summary_model.dart';
import '../../../../shared/providers/privacy_provider.dart';
import 'package:uicons/uicons.dart';

class WealthDomainRow extends ConsumerWidget {
  final WealthDomain domain;
  final IconData icon;
  final VoidCallback onTap;
  final bool showDivider;

  const WealthDomainRow({
    super.key,
    required this.domain,
    required this.icon,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isObscured = ref.watch(privacyProvider);
    
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    );
    String formattedValue = currencyFormatter.format(domain.value).trim();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                // Icon Box (matching Accounts, Investments & Physical Assets)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Middle Column: Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        domain.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        domain.subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Right Column: Nominal Value & Chevron
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (domain.value > 0)
                      Text(
                        isObscured ? 'Rp ••••••••' : 'Rp $formattedValue',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      UIcons.regularRounded.angle_right,
                      color: AppColors.textSecondary,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showDivider)
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.divider,
            ),
        ],
      ),
    );
  }
}
