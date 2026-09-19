import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/activity_item.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/mock_activity_repository.dart';

// Provide the repository instance (mock for now)
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return MockActivityRepository();
});

// Provide the summary data
final activitySummaryProvider = FutureProvider<Map<String, double>>((ref) async {
  final repo = ref.watch(activityRepositoryProvider);
  return repo.getActivitySummary();
});

// State class for the paginated activity list
class ActivityState {
  final List<ActivityItem> activities;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final String filterType;
  final String searchQuery;
  final int page;

  ActivityState({
    this.activities = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.filterType = 'All',
    this.searchQuery = '',
    this.page = 1,
  });

  ActivityState copyWith({
    List<ActivityItem>? activities,
    bool? isLoading,
    bool? hasMore,
    String? error,
    String? filterType,
    String? searchQuery,
    int? page,
  }) {
    return ActivityState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      filterType: filterType ?? this.filterType,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
    );
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  final ActivityRepository _repository;

  ActivityNotifier(this._repository) : super(ActivityState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null, page: 1, hasMore: true, activities: []);
    
    try {
      final items = await _repository.getActivities(
        page: 1,
        limit: 20,
        filterType: state.filterType,
        searchQuery: state.searchQuery,
      );
      
      state = state.copyWith(
        activities: items,
        isLoading: false,
        hasMore: items.length == 20,
        page: 2,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    
    // We don't set isLoading=true here so we don't clear the list or show full screen loader,
    // we can use a separate flag for bottom loading if needed, but for simplicity we'll just fetch.
    
    try {
      final items = await _repository.getActivities(
        page: state.page,
        limit: 20,
        filterType: state.filterType,
        searchQuery: state.searchQuery,
      );
      
      state = state.copyWith(
        activities: [...state.activities, ...items],
        hasMore: items.length == 20,
        page: state.page + 1,
      );
    } catch (e) {
      // Just set error, don't clear activities
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  void setFilter(String filter) {
    if (state.filterType == filter) return;
    state = state.copyWith(filterType: filter);
    loadInitial();
  }

  void setSearchQuery(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query);
    loadInitial();
  }

  Future<void> deleteActivity(String id) async {
    try {
      await _repository.deleteActivity(id);
      
      // Update local state by removing the deleted activity
      final updatedActivities = state.activities.where((a) => a.id != id).toList();
      state = state.copyWith(activities: updatedActivities);
    } catch (e) {
      // Could show a snackbar or just ignore for mock
      state = state.copyWith(error: 'Failed to delete: ${e.toString()}');
    }
  }
}

final activityNotifierProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  final repo = ref.watch(activityRepositoryProvider);
  return ActivityNotifier(repo);
});
