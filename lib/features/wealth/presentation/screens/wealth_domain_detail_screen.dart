import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/wealth_summary_model.dart';
import '../../domain/models/wealth_item.dart';
import '../providers/wealth_provider.dart';
import '../widgets/wealth_item_row.dart';

class WealthDomainDetailScreen extends ConsumerWidget {
  final WealthDomain domain;

  const WealthDomainDetailScreen({
    super.key,
    required this.domain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wealthItemsProvider(domain.id));

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Group items by category
    final groupedItems = <String, List<WealthItem>>{};
    for (var item in items) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            expandedHeight: 200,
            leading: IconButton(
              icon: Icon(UIcons.regularRounded.angle_left, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                domain.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: 24,
                    bottom: 64, // Positioned right above the title
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(domain.value),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grouped Items List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          'No items found',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  : Column(
                      children: groupedItems.entries.map((entry) {
                        final category = entry.key;
                        final categoryItems = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 24.0),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    UIcons.regularRounded.angle_right,
                                    color: AppColors.textSecondary,
                                    size: 16,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // List of items
                              ...categoryItems.map((item) {
                                return WealthItemRow(
                                  item: item,
                                  onTap: () {
                                    // Action to update/delete data (e.g. show bottom sheet)
                                  },
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          
          // Bottom spacing for custom bottom nav
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          )
        ],
      ),
    );
  }
}
