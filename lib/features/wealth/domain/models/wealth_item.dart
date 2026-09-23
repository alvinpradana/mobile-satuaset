import 'package:flutter/material.dart';

enum WealthItemStatus { active, archived }

class AssetExchangeAllocation {
  final String exchangeName;
  final double units;
  final double value;
  final double? averagePrice;

  const AssetExchangeAllocation({
    required this.exchangeName,
    required this.units,
    required this.value,
    this.averagePrice,
  });
}

class WealthItem {
  final String id;
  final String domainId; // e.g. 'accounts', 'investments'
  final String category; // e.g. 'Crypto', 'Stocks', 'E-Wallet'
  final String name; // e.g. 'Bank BCA', 'Reksadana Saham'
  final String? institution; // e.g. 'BCA', 'Bibit'
  final String? identifier; // e.g. '•••• 1241'
  final double value;
  final double? units; // e.g. 0.15 BTC, 100 shares
  final double? averagePrice; // e.g. 40000 (avg buy price)
  final double? percentageChange; // e.g. 163.44, -13.44
  final IconData iconData;
  final String currency;
  final WealthItemStatus status;
  final List<AssetExchangeAllocation>? exchangeAllocations;

  const WealthItem({
    required this.id,
    required this.domainId,
    required this.category,
    required this.name,
    this.institution,
    this.identifier,
    required this.value,
    this.units,
    this.averagePrice,
    this.percentageChange,
    required this.iconData,
    this.currency = 'USD',
    this.status = WealthItemStatus.active,
    this.exchangeAllocations,
  });
}
