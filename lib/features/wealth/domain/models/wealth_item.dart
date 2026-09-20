import 'package:flutter/material.dart';

class WealthItem {
  final String id;
  final String domainId; // e.g. 'accounts', 'investments'
  final String category; // e.g. 'Crypto', 'Stocks', 'E-Wallet'
  final String name; // e.g. 'Bank BCA', 'Reksadana Saham'
  final String? institution; // e.g. 'BCA', 'Bibit'
  final double value;
  final double? percentageChange; // e.g. 163.44, -13.44
  final IconData iconData;
  final String currency;

  const WealthItem({
    required this.id,
    required this.domainId,
    required this.category,
    required this.name,
    this.institution,
    required this.value,
    this.percentageChange,
    required this.iconData,
    this.currency = 'USD',
  });
}
