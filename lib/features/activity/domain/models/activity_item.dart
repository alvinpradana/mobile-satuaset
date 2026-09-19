enum ActivityType {
  income,
  expense,
  transfer,
  exchange,
  withdrawal,
  investmentBuy,
  investmentSell,
  assetPurchase,
  assetSale,
  liabilityPayment,
  goalContribution,
  adjustment,
}

class ActivityItem {
  final String id;
  final ActivityType type;
  final String title;
  final double amount;
  final String currency;
  final DateTime date;
  
  // Optional metadata depending on the activity type
  final String? account;
  final String? destinationAccount; // For transfers
  final String? category;
  final String? asset;
  final double? quantity; // For investments
  final String? notes;
  final String? status;

  ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.amount,
    required this.date,
    this.currency = 'IDR',
    this.account,
    this.destinationAccount,
    this.category,
    this.asset,
    this.quantity,
    this.notes,
    this.status,
  });

  // Helper getters for UI presentation
  bool get isPositive {
    return type == ActivityType.income || 
           type == ActivityType.investmentSell || 
           type == ActivityType.assetSale;
  }

  bool get isNegative {
    return type == ActivityType.expense || 
           type == ActivityType.investmentBuy || 
           type == ActivityType.assetPurchase || 
           type == ActivityType.liabilityPayment || 
           type == ActivityType.goalContribution;
  }

  bool get isNeutral {
    return type == ActivityType.transfer || 
           type == ActivityType.exchange || 
           type == ActivityType.withdrawal || 
           type == ActivityType.adjustment;
  }
}
