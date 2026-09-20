import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/dashboard_header.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_summary.dart';
import '../widgets/activity_filter_bar.dart';
import '../widgets/activity_row.dart';
import '../widgets/activity_detail_sheet.dart';
import '../widgets/cashflow_overview.dart';
import '../../domain/models/activity_item.dart';
import 'package:uicons/uicons.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  int _currentTab = 0; // 0 for Activity, 1 for Cashflow

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  void _onSearchFocusChange() {
    if (_searchFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          // Scroll down to hide top headers and show the transaction list
          final double targetOffset = 380.0;
          final double maxScroll = _scrollController.position.maxScrollExtent;
          _scrollController.animateTo(
            targetOffset > maxScroll ? maxScroll : targetOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(activityNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activityNotifierProvider);
    final summaryAsync = ref.watch(activitySummaryProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await ref.read(activityNotifierProvider.notifier).refresh();
              ref.invalidate(activitySummaryProvider);
            },
            color: AppColors.primaryAccent,
            backgroundColor: AppColors.surface,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          const DashboardHeader(showWelcomeText: false),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 48,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Stack(
                                      children: [
                                        AnimatedAlign(
                                          alignment: _currentTab == 0 ? Alignment.centerLeft : Alignment.centerRight,
                                          duration: const Duration(milliseconds: 250),
                                          curve: Curves.easeOutCubic,
                                          child: FractionallySizedBox(
                                            widthFactor: 0.5,
                                            child: Container(
                                              margin: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                onTap: () {
                                                  if (_currentTab != 0) setState(() => _currentTab = 0);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Activity',
                                                    style: TextStyle(
                                                      color: _currentTab == 0 ? AppColors.primaryAccent : AppColors.textSecondary,
                                                      fontWeight: _currentTab == 0 ? FontWeight.bold : FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                onTap: () {
                                                  if (_currentTab != 1) setState(() => _currentTab = 1);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Cashflow',
                                                    style: TextStyle(
                                                      color: _currentTab == 1 ? AppColors.primaryAccent : AppColors.textSecondary,
                                                      fontWeight: _currentTab == 1 ? FontWeight.bold : FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Date Period Selector
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // TODO: Show Period Selector Bottom Sheet
                          },
                          child: Row(
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(DateTime.now()),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                UIcons.regularRounded.angle_down,
                                color: AppColors.textSecondary,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showSecondaryFilterSheet(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(UIcons.solidRounded.settings_sliders, color: AppColors.textPrimary, size: 12),
                                SizedBox(width: 6),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Summary
                if (_currentTab == 0) ...[
                  // --- TIMELINE MODE ---
                  SliverToBoxAdapter(
                    child: summaryAsync.when(
                      data: (data) => ActivitySummary(
                        income: data['income'] ?? 0,
                        expense: data['expense'] ?? 0,
                      ),
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                        child: Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
                      ),
                      error: (e, st) => const SizedBox(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: ActivityFilterBar(
                        selectedFilter: state.filterType,
                        onFilterSelected: (filter) {
                          ref.read(activityNotifierProvider.notifier).setFilter(filter);
                        },
                      ),
                    ),
                  ),
                  
                  // Search State or List State
                  if (state.isLoading && state.activities.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
                    )
                  else if (state.error != null && state.activities.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Unable to load activity', style: TextStyle(color: AppColors.textPrimary)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => ref.read(activityNotifierProvider.notifier).refresh(),
                              child: const Text('Retry'),
                            )
                          ],
                        ),
                      ),
                    )
                  else if (state.activities.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'No activity found',
                              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Try changing your filters or date range.',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    _buildActivityList(state.activities),
                    
                  // Bottom Loading Indicator
                  if (state.isLoading && state.activities.isNotEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
                      ),
                    ),
                ] else ...[
                  // --- CASHFLOW MODE ---
                  const SliverToBoxAdapter(
                    child: CashflowOverview(),
                  ),
                ],
                
                // Extra bottom padding for search bar + bottom nav
                const SliverToBoxAdapter(child: SizedBox(height: 160)),
              ],
            ),
          ),

          // Floating Glassmorphism Search Bar
          if (_currentTab == 0)
            Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 120,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7, // 70% of screen width
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Icon(UIcons.regularRounded.search, color: AppColors.textSecondary, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Search your transaction',
                                hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) {
                                ref.read(activityNotifierProvider.notifier).setSearchQuery(val);
                              },
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                ref.read(activityNotifierProvider.notifier).setSearchQuery('');
                              },
                              child: Icon(UIcons.solidRounded.cross, color: AppColors.textSecondary, size: 14),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildActivityList(List<ActivityItem> activities) {
    // Group activities by date
    Map<String, List<ActivityItem>> grouped = {};
    final DateFormat headerFormat = DateFormat('dd MMM yyyy');
    
    for (var activity in activities) {
      String key;
      final now = DateTime.now();
      final date = activity.date;
      
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        key = 'TODAY';
      } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
        key = 'YESTERDAY';
      } else {
        key = headerFormat.format(date).toUpperCase();
      }
      
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(activity);
    }

    final keys = grouped.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final key = keys[index];
          final items = grouped[key]!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    key,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                      children: List.generate(items.length, (i) {
                      final item = items[i];
                      return Column(
                        children: [
                          ActivityRow(
                            activity: item,
                            isFirst: i == 0,
                            isLast: i == items.length - 1,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => ActivityDetailSheet(activity: item),
                                );
                              },
                          ),
                          if (i < items.length - 1)
                            const Divider(color: AppColors.divider, height: 1, indent: 16, endIndent: 16),
                        ],
                      );
                      }),
                    ),
                  ),
              ],
            ),
          );
        },
        childCount: keys.length,
      ),
    );
  }

  void _showSecondaryFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildFilterSheetOption('Date', 'All Time'),
                _buildFilterSheetOption('Account', 'All Accounts'),
                _buildFilterSheetOption('Category', 'All Categories'),
                _buildFilterSheetOption('Type', 'All Types'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Apply Filters',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSheetOption(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(width: 8),
              Icon(UIcons.regularRounded.angle_right, color: AppColors.textSecondary, size: 14),
            ],
          )
        ],
      ),
    );
  }
}
