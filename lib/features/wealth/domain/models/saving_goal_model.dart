import 'package:flutter/material.dart';

enum SavingGoalStatus { active, completed }

class SavingGoal {
  final String id;
  final String name;
  final String category; // e.g. 'EMERGENCY', 'HOUSING', 'TRAVEL', 'VEHICLE', 'GADGET'
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final IconData iconData;
  final Color color;
  final String? accountName;
  final SavingGoalStatus status;

  const SavingGoal({
    required this.id,
    required this.name,
    required this.category,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.iconData,
    this.color = const Color(0xFF00E5FF),
    this.accountName,
    this.status = SavingGoalStatus.active,
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }

  double get remainingAmount {
    final rem = targetAmount - currentAmount;
    return rem < 0 ? 0 : rem;
  }

  int get remainingMonths {
    final now = DateTime.now();
    final differenceInDays = targetDate.difference(now).inDays;
    if (differenceInDays <= 0) return 0;
    return (differenceInDays / 30).ceil();
  }

  double get recommendedMonthlyDeposit {
    final months = remainingMonths;
    if (months <= 0) return remainingAmount;
    return remainingAmount / months;
  }
}
