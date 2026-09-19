import '../../domain/models/activity_item.dart';

abstract class ActivityRepository {
  /// Fetches a paginated list of activities based on optional filters.
  Future<List<ActivityItem>> getActivities({
    int page = 1,
    int limit = 20,
    String? filterType, // e.g., 'income', 'expense', 'transfer'
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Fetches the summary (total income, expense, net) for a given period.
  Future<Map<String, double>> getActivitySummary({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Deletes an activity by id.
  Future<void> deleteActivity(String id);
}
