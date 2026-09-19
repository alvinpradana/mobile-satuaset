enum ActivityType {
  income,
  expense,
  transfer,
}

class RecentActivity {
  final String title;
  final double amount;
  final ActivityType type;
  final String date;

  RecentActivity({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });
}
