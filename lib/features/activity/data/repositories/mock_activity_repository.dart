import '../../domain/models/activity_item.dart';
import 'activity_repository.dart';

class MockActivityRepository implements ActivityRepository {
  final List<ActivityItem> _mockActivities = [
    ActivityItem(
      id: '1',
      type: ActivityType.income,
      title: 'Salary',
      amount: 15000000,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      account: 'BCA',
      category: 'Income',
      notes: 'September Salary',
    ),
    ActivityItem(
      id: '2',
      type: ActivityType.expense,
      title: 'Starbucks',
      amount: 85000,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      account: 'BCA',
      category: 'Food & Drink',
      notes: 'Coffee break',
    ),
    ActivityItem(
      id: '3',
      type: ActivityType.transfer,
      title: 'Transfer',
      amount: 5000000,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      account: 'BCA',
      destinationAccount: 'Mandiri',
      notes: 'Monthly savings',
    ),
    ActivityItem(
      id: '4',
      type: ActivityType.investmentBuy,
      title: 'Buy Bitcoin',
      amount: 5000000,
      date: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      account: 'Binance',
      asset: 'BTC',
      quantity: 0.0214,
      notes: 'DCA',
    ),
    ActivityItem(
      id: '5',
      type: ActivityType.liabilityPayment,
      title: 'Mortgage Payment',
      amount: 4500000,
      date: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      account: 'BCA',
      category: 'Housing',
    ),
    ActivityItem(
      id: '6',
      type: ActivityType.goalContribution,
      title: 'Emergency Fund',
      amount: 2000000,
      date: DateTime.now().subtract(const Duration(days: 5)),
      account: 'BCA',
      category: 'Savings',
    ),
    ActivityItem(
      id: '7',
      type: ActivityType.assetPurchase,
      title: 'Bought Vehicle',
      amount: 220000000,
      date: DateTime.now().subtract(const Duration(days: 10)),
      account: 'BCA',
      asset: 'Toyota',
      category: 'Transportation',
    ),
    ActivityItem(
      id: '8',
      type: ActivityType.expense,
      title: 'Netflix',
      amount: 186000,
      date: DateTime.now().subtract(const Duration(days: 12)),
      account: 'Mandiri',
      category: 'Entertainment',
    ),
    ActivityItem(
      id: '9',
      type: ActivityType.income,
      title: 'Freelance Design',
      amount: 3500000,
      date: DateTime.now().subtract(const Duration(days: 14)),
      account: 'BCA',
      category: 'Income',
    ),
    ActivityItem(
      id: '10',
      type: ActivityType.transfer,
      title: 'Top Up GoPay',
      amount: 500000,
      date: DateTime.now().subtract(const Duration(days: 15)),
      account: 'BCA',
      destinationAccount: 'GoPay',
    ),
    // ... we can add more if needed to test pagination
  ];

  @override
  Future<List<ActivityItem>> getActivities({
    int page = 1,
    int limit = 20,
    String? filterType,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    List<ActivityItem> results = List.from(_mockActivities);

    if (filterType != null && filterType != 'All') {
      // Map UI filter to ActivityType
      // Simple mapping logic for mock
      results = results.where((item) {
        if (filterType == 'Income' && item.type == ActivityType.income) return true;
        if (filterType == 'Expense' && item.type == ActivityType.expense) return true;
        if (filterType == 'Transfer' && item.type == ActivityType.transfer) return true;
        if (filterType == 'Investment' && (item.type == ActivityType.investmentBuy || item.type == ActivityType.investmentSell)) return true;
        return false;
      }).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      results = results.where((item) =>
          item.title.toLowerCase().contains(query) ||
          (item.notes?.toLowerCase().contains(query) ?? false) ||
          (item.account?.toLowerCase().contains(query) ?? false) ||
          (item.category?.toLowerCase().contains(query) ?? false)).toList();
    }

    // Sort descending by date
    results.sort((a, b) => b.date.compareTo(a.date));

    // Pagination
    final startIndex = (page - 1) * limit;
    if (startIndex >= results.length) {
      return [];
    }

    final endIndex = (startIndex + limit) > results.length
        ? results.length
        : startIndex + limit;

    return results.sublist(startIndex, endIndex);
  }

  @override
  Future<Map<String, double>> getActivitySummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    double income = 0;
    double expense = 0;

    for (var item in _mockActivities) {
      if (item.type == ActivityType.income) {
        income += item.amount;
      } else if (item.type == ActivityType.expense) {
        expense += item.amount;
      }
    }

    return {
      'income': income,
      'expense': expense,
      'net': income - expense,
    };
  }

  @override
  Future<void> deleteActivity(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockActivities.removeWhere((item) => item.id == id);
  }
}
