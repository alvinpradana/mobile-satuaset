import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/physical_asset_model.dart';
import '../providers/physical_assets_provider.dart';

class PhysicalAssetDetailScreen extends ConsumerWidget {
  final String assetId;

  const PhysicalAssetDetailScreen({
    super.key,
    required this.assetId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(physicalAssetsProvider);
    final asset = assets.firstWhere((a) => a.id == assetId, orElse: () => assets.first); // fallback just in case

    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final isSold = asset.status == PhysicalAssetStatus.sold;

    final gain = isSold ? asset.realizedGain : asset.estimatedGain;
    final gainPercentage = isSold ? asset.realizedGainPercentage : asset.estimatedGainPercentage;
    final isPositive = gain >= 0;
    
    // According to color rules: Positive/Gain -> AppColors.positive
    final gainColor = isPositive ? AppColors.positive : AppColors.negative;
    final gainPrefix = isPositive ? '+' : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(UIcons.regularRounded.angle_left, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ),
        title: Text(
          asset.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: GestureDetector(
              onTap: () {
                // Edit asset
              },
              behavior: HitTestBehavior.opaque,
              child: Icon(UIcons.regularRounded.pencil, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero
            Column(
              children: [
                const Text(
                  'CURRENT ESTIMATED VALUE',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  currencyFormatter.format(asset.currentEstimatedValue),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? UIcons.regularRounded.arrow_trend_up : UIcons.regularRounded.arrow_trend_down,
                      size: 14,
                      color: gainColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$gainPrefix${currencyFormatter.format(gain)}',
                      style: TextStyle(
                        color: gainColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: gainColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${gainPrefix}${gainPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: gainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Summary Grid
            const Text(
              'PURCHASE DETAILS',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          title: 'Purchase Price',
                          value: currencyFormatter.format(asset.purchasePrice),
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          title: 'Purchase Date',
                          value: DateFormat('dd MMM yyyy').format(asset.purchaseDate),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: AppColors.border, height: 1),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          title: 'Category',
                          value: asset.category,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          title: 'Last Updated',
                          value: asset.lastValuedDate != null
                              ? DateFormat('dd MMM yyyy').format(asset.lastValuedDate!)
                              : '-',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (asset.location != null || asset.notes != null) ...[
              const SizedBox(height: 32),
              const Text(
                'ADDITIONAL INFO',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    if (asset.location != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(UIcons.regularRounded.marker, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Location',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  asset.location!,
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (asset.location != null && asset.notes != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(color: AppColors.border, height: 1),
                      ),
                    if (asset.notes != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(UIcons.regularRounded.document, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Notes',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  asset.notes!,
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],

            if (isSold && asset.salePrice != null && asset.saleDate != null) ...[
              const SizedBox(height: 32),
              const Text(
                'SALES DETAILS',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface, // muted/dull color for sold
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            title: 'Sale Price',
                            value: currencyFormatter.format(asset.salePrice),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            title: 'Sale Date',
                            value: DateFormat('dd MMM yyyy').format(asset.saleDate!),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(color: AppColors.border, height: 1),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            title: 'Realized Gain',
                            value: '$gainPrefix${currencyFormatter.format(asset.realizedGain)}',
                            valueColor: gainColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: !isSold ? SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    // Mark as sold
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: const Size(0, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: const Text(
                    'Sell Asset',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    // Update value
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(0, 56),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: const Text(
                    'Update Value',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ) : null,
    );
  }

  Widget _buildInfoItem({required String title, required String value, Color valueColor = AppColors.textPrimary}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
