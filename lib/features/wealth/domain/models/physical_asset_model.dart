import 'package:flutter/material.dart';

enum PhysicalAssetStatus { owned, sold }

class PhysicalAssetModel {
  final String id;
  final String category; // e.g. 'Property', 'Vehicle', 'Gold', 'Other'
  final String name; // e.g. 'House', 'Honda Jazz'
  final double purchasePrice; // e.g. 450000000.0
  final double currentEstimatedValue; // e.g. 600000000.0
  final DateTime purchaseDate;
  final DateTime? lastValuedDate;
  final String? location;
  final String? notes;
  final PhysicalAssetStatus status;
  final double? salePrice;
  final DateTime? saleDate;

  const PhysicalAssetModel({
    required this.id,
    required this.category,
    required this.name,
    required this.purchasePrice,
    required this.currentEstimatedValue,
    required this.purchaseDate,
    this.lastValuedDate,
    this.location,
    this.notes,
    this.status = PhysicalAssetStatus.owned,
    this.salePrice,
    this.saleDate,
  });

  double get estimatedGain => currentEstimatedValue - purchasePrice;
  double get estimatedGainPercentage => (purchasePrice > 0) ? (estimatedGain / purchasePrice) * 100 : 0.0;
  
  double get realizedGain => (salePrice != null) ? salePrice! - purchasePrice : 0.0;
  double get realizedGainPercentage => (salePrice != null && purchasePrice > 0) ? (realizedGain / purchasePrice) * 100 : 0.0;
}

class PhysicalAssetsSummary {
  final double totalValue;
  final double totalEstimatedGain;
  final int activeAssetsCount;
  final List<AssetAllocation> allocations;

  const PhysicalAssetsSummary({
    required this.totalValue,
    required this.totalEstimatedGain,
    required this.activeAssetsCount,
    required this.allocations,
  });
  
  double get totalPurchaseCost => totalValue - totalEstimatedGain;
  double get totalGainPercentage => (totalPurchaseCost > 0) ? (totalEstimatedGain / totalPurchaseCost) * 100 : 0.0;
}

class AssetAllocation {
  final String category;
  final double percentage;

  const AssetAllocation({
    required this.category,
    required this.percentage,
  });
}
