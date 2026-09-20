import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/physical_asset_model.dart';

final physicalAssetsProvider = Provider<List<PhysicalAssetModel>>((ref) {
  return [
    PhysicalAssetModel(
      id: 'pa1',
      category: 'Property',
      name: 'House',
      purchasePrice: 450000000.0,
      currentEstimatedValue: 600000000.0,
      purchaseDate: DateTime(2024, 1, 15),
      lastValuedDate: DateTime(2026, 9, 10),
      location: 'Yogyakarta',
      notes: 'Primary residence',
    ),
    PhysicalAssetModel(
      id: 'pa2',
      category: 'Vehicle',
      name: 'Honda Jazz',
      purchasePrice: 180000000.0,
      currentEstimatedValue: 150000000.0,
      purchaseDate: DateTime(2024, 1, 10),
      lastValuedDate: DateTime(2026, 9, 1),
    ),
    PhysicalAssetModel(
      id: 'pa2b',
      category: 'Vehicle',
      name: 'Toyota Avanza',
      purchasePrice: 220000000.0,
      currentEstimatedValue: 200000000.0,
      purchaseDate: DateTime(2023, 5, 20),
      lastValuedDate: DateTime(2026, 9, 15),
    ),
    PhysicalAssetModel(
      id: 'pa3',
      category: 'Gold',
      name: 'Gold Bar',
      purchasePrice: 42000000.0,
      currentEstimatedValue: 50000000.0,
      purchaseDate: DateTime(2023, 6, 20),
    ),
    PhysicalAssetModel(
      id: 'pa4',
      category: 'Vehicle',
      name: 'Yamaha NMAX',
      purchasePrice: 32000000.0,
      currentEstimatedValue: 20000000.0,
      purchaseDate: DateTime(2022, 5, 10),
      salePrice: 20000000.0,
      saleDate: DateTime(2026, 9, 18),
      status: PhysicalAssetStatus.sold,
    ),
    PhysicalAssetModel(
      id: 'pa5',
      category: 'Gold',
      name: 'Gold Ring',
      purchasePrice: 5000000.0,
      currentEstimatedValue: 6500000.0,
      purchaseDate: DateTime(2021, 2, 14),
      salePrice: 6000000.0,
      saleDate: DateTime(2026, 8, 10),
      status: PhysicalAssetStatus.sold,
    ),
  ];
});

final physicalAssetsSummaryProvider = Provider<PhysicalAssetsSummary>((ref) {
  final assets = ref.watch(physicalAssetsProvider);
  
  double totalValue = 0;
  double totalGain = 0;
  int activeCount = 0;
  
  // Maps to calculate breakdown
  final Map<String, double> categoryValues = {};
  
  for (var asset in assets) {
    if (asset.status == PhysicalAssetStatus.owned) {
      totalValue += asset.currentEstimatedValue;
      totalGain += asset.estimatedGain;
      activeCount++;
      
      categoryValues[asset.category] = (categoryValues[asset.category] ?? 0) + asset.currentEstimatedValue;
    }
  }
  
  List<AssetAllocation> allocations = [];
  if (totalValue > 0) {
    categoryValues.forEach((key, value) {
      allocations.add(AssetAllocation(
        category: key,
        percentage: (value / totalValue) * 100,
      ));
    });
    // Sort descending by percentage
    allocations.sort((a, b) => b.percentage.compareTo(a.percentage));
  }
  
  return PhysicalAssetsSummary(
    totalValue: totalValue,
    totalEstimatedGain: totalGain,
    activeAssetsCount: activeCount,
    allocations: allocations,
  );
});
