import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/physical_asset_model.dart';
import '../providers/physical_assets_provider.dart';
import '../widgets/physical_asset_row.dart';
import '../widgets/physical_assets_hero.dart';
import '../widgets/value_breakdown_bar.dart';

class PhysicalAssetsScreen extends ConsumerStatefulWidget {
  const PhysicalAssetsScreen({super.key});

  @override
  ConsumerState<PhysicalAssetsScreen> createState() => _PhysicalAssetsScreenState();
}

class _PhysicalAssetsScreenState extends ConsumerState<PhysicalAssetsScreen> {
  bool _isSoldAssetsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final assets = ref.watch(physicalAssetsProvider);
    final summary = ref.watch(physicalAssetsSummaryProvider);

    // Filter active and sold assets
    final activeAssets = assets.where((a) => a.status == PhysicalAssetStatus.owned).toList();
    final soldAssetsCount = assets.where((a) => a.status == PhysicalAssetStatus.sold).length;

    // Group active assets by category
    final groupedAssets = <String, List<PhysicalAssetModel>>{};
    for (var asset in activeAssets) {
      groupedAssets.putIfAbsent(asset.category, () => []).add(asset);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Icon(UIcons.regularRounded.angle_left, color: AppColors.textPrimary, size: 20),
                  ),
                ),
              ),
            ),
            title: const Text(
              'Physical Assets',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  PhysicalAssetsHero(summary: summary),
                  const SizedBox(height: 32),
                  
                  // Value Breakdown
                  ValueBreakdownBar(allocations: summary.allocations),
                  const SizedBox(height: 48),

                  // Your Assets Header
                  const Text(
                    'YOUR ASSETS',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Empty State
                  if (activeAssets.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.surfaceHover.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(UIcons.regularRounded.box, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No physical assets yet',
                            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add your property, vehicle, gold, or other valuable assets to complete your financial picture.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccent,
                              foregroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Add Asset'),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Grouped Assets List
                        ...groupedAssets.entries.map((entry) {
                          final category = entry.key;
                          final categoryAssets = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...categoryAssets.asMap().entries.map((entry) {
                                final index = entry.key;
                                final asset = entry.value;
                                return Column(
                                  children: [
                                    PhysicalAssetRow(
                                      asset: asset,
                                      onTap: () {
                                        // Navigate to asset detail
                                      },
                                    ),
                                    if (index < categoryAssets.length - 1)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 56.0),
                                        child: Divider(
                                          color: AppColors.surfaceHover.withOpacity(0.5),
                                          height: 1,
                                        ),
                                      ),
                                  ],
                                );
                              }).toList(),
                              const SizedBox(height: 24),
                            ],
                          );
                        }).toList(),
                      ],
                    ),

                  // Sold Assets Section
                  if (soldAssetsCount > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSoldAssetsExpanded = !_isSoldAssetsExpanded;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'SOLD ASSETS',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: _isSoldAssetsExpanded ? 0.25 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    UIcons.regularRounded.angle_right,
                                    color: AppColors.textSecondary,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isSoldAssetsExpanded)
                          ...assets.where((a) => a.status == PhysicalAssetStatus.sold).toList().asMap().entries.map((entry) {
                            final index = entry.key;
                            final asset = entry.value;
                            final soldList = assets.where((a) => a.status == PhysicalAssetStatus.sold).toList();
                            return Column(
                              children: [
                                Opacity(
                                  opacity: 0.5,
                                  child: PhysicalAssetRow(
                                    asset: asset,
                                    onTap: () {
                                      // Navigate to sold asset detail
                                    },
                                  ),
                                ),
                                if (index < soldList.length - 1)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 56.0),
                                    child: Divider(
                                      color: AppColors.surfaceHover.withOpacity(0.5),
                                      height: 1,
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                      ],
                    ),
                    
                  // Bottom spacing
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24), // Matches CustomBottomNav margin
        child: ElevatedButton(
          onPressed: () {
            // Add new asset action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Add new asset',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
