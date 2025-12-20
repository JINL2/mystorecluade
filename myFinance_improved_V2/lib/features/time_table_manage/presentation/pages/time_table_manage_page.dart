// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, argument_type_not_assignable, invalid_assignment, non_bool_condition, non_bool_negation_expression, non_bool_operand, use_of_void_result
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/ai_chat/ai_chat.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../../homepage/domain/entities/top_feature.dart';
import '../../domain/entities/daily_shift_data.dart';
import '../../domain/entities/manager_overview.dart';
import '../providers/state/reliability_score_provider.dart';
import '../providers/time_table_providers.dart';
import '../widgets/bottom_sheets/add_shift_bottom_sheet.dart';
import '../widgets/overview/overview_tab.dart';
import '../widgets/schedule/schedule_tab_content.dart';
import '../widgets/timesheets/timesheets_tab.dart';
import 'shift_stats_tab.dart';

class TimeTableManagePage extends ConsumerStatefulWidget {
  final dynamic feature;

  const TimeTableManagePage({super.key, this.feature});

  @override
  ConsumerState<TimeTableManagePage> createState() => _TimeTableManagePageState();
}

class _TimeTableManagePageState extends ConsumerState<TimeTableManagePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  DateTime focusedMonth = DateTime.now();
  String? selectedStoreId;

  // ScrollController for Schedule tab
  final ScrollController _scheduleScrollController = ScrollController();

  /// Handle tab changes - fetch data when switching tabs
  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;

    HapticFeedback.selectionClick();

    final newIndex = _tabController.index;

    // Fetch overview data when switching to Overview tab
    if (newIndex == 0 && selectedStoreId != null) {
      fetchManagerOverview();
      fetchManagerCards();
    }
    // Fetch data when switching to Schedule tab
    if (newIndex == 1 && selectedStoreId != null) {
      fetchMonthlyShiftStatus();
    }
  }

  // ✅ Removed: shiftMetadata, isLoadingMetadata
  // Now managed by shiftMetadataProvider

  // Feature info extracted once
  String? _featureName;
  String? _featureId;
  bool _featureInfoExtracted = false;

  // ✅ Removed: monthlyShiftStatusList, loadedMonths, isLoadingShiftStatus
  // Now managed by monthlyShiftStatusProvider

  // ✅ Removed: selectedShiftRequests, selectedShiftApprovalStates, selectedShiftRequestIds
  // Now managed by selectedShiftRequestsProvider

  // ✅ Removed: managerOverviewDataByMonth, isLoadingOverview
  // Now managed by managerOverviewProvider

  // ✅ Removed: managerCardsDataByMonth, isLoadingCards
  // Now managed by managerCardsProvider

  // Preload profile images for faster loading
  void _preloadProfileImages(List<DailyShiftData> dailyShifts) {
    for (var dayData in dailyShifts) {
      for (var shiftWithReqs in dayData.shifts) {
        final allRequests = [
          ...shiftWithReqs.pendingRequests,
          ...shiftWithReqs.approvedRequests,
        ];

        for (var request in allRequests) {
          final profileImage = request.employee.profileImage;
          if (profileImage != null && profileImage.isNotEmpty) {
            // Preload image using precacheImage
            precacheImage(
              CachedNetworkImageProvider(profileImage),
              context,
            ).catchError((error) {
              // Ignore preload errors
            });
          }
        }
      }
    }
  }
  
  // Manage tab selected date for week view
  DateTime manageSelectedDate = DateTime.now();

  // Filter state for manage tab - default to show approved shifts
  String? selectedFilter = 'approved'; // null = 'all', 'problem', 'approved', 'pending'

  // Filter state for timesheets tab (used when navigating from Stats tab)
  String? _timesheetsFilter;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0); // Changed to 4 tabs, default to Overview
    _tabController.addListener(_onTabChanged);

    // Extract feature info once
    _extractFeatureInfo();

    // Initialize selectedStoreId from app state
    final appState = ref.read(appStateProvider);
    selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    // ✅ Fetch initial data AFTER build is complete to avoid Provider lifecycle violation
    // ✅ Always force refresh on page entry to ensure fresh data from RPC
    // This ensures data from other devices is visible when navigating to this page
    if (selectedStoreId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _forceRefreshAllData();
      });
    }
  }

  /// Force refresh all data providers on page entry
  ///
  /// This is critical for cross-device data sync:
  /// - When user A creates a schedule on device 1
  /// - User B on device 2 should see it when entering this page
  /// - Without force refresh, cached/stale data would be shown
  ///
  /// OPTIMIZATION: All RPC calls run in parallel using Future.wait
  /// This reduces total loading time from sum(T1+T2+T3) to max(T1,T2,T3)
  void _forceRefreshAllData() {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;

    // 1. Invalidate ALL providers to clear cached state
    // This ensures fresh provider instances with current companyId
    ref.invalidate(shiftMetadataProvider(selectedStoreId!));
    ref.invalidate(reliabilityScoreProvider(selectedStoreId!));
    ref.invalidate(monthlyShiftStatusProvider(selectedStoreId!));
    ref.invalidate(managerOverviewProvider(selectedStoreId!));
    ref.invalidate(managerCardsProvider(selectedStoreId!));

    // 2. Trigger FutureProviders to actually fetch data
    // FutureProvider only executes when watched/read, invalidate alone won't trigger fetch
    // Using read() after invalidate to trigger immediate fetch
    ref.read(shiftMetadataProvider(selectedStoreId!));
    ref.read(reliabilityScoreProvider(selectedStoreId!));

    // 3. StateNotifierProviders - run ALL in parallel for faster loading
    // Before: Sequential await (T1 + T2 + T3) ~3-5 seconds
    // After: Parallel max(T1, T2, T3) ~1-2 seconds
    Future.wait([
      fetchMonthlyShiftStatus(forceRefresh: true),
      fetchManagerOverview(forceRefresh: true),
      fetchManagerCards(forceRefresh: true),
    ]);
  }

  void _extractFeatureInfo() {
    if (_featureInfoExtracted) return;

    final feature = widget.feature;
    if (feature != null) {
      if (feature is Feature) {
        _featureName = feature.featureName;
        _featureId = feature.featureId;
      } else if (feature is TopFeature) {
        _featureName = feature.featureName;
        _featureId = feature.featureId;
      }
    }

    _featureInfoExtracted = true;
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _scheduleScrollController.dispose();
    super.dispose();
  }
  
  // Helper widget for common spacing
  
  @override
  Widget build(BuildContext context) {
    // ✅ Watch manager overview provider
    final managerOverviewState = selectedStoreId != null && selectedStoreId!.isNotEmpty
        ? ref.watch(managerOverviewProvider(selectedStoreId!))
        : null;
    final managerOverviewDataByMonth = managerOverviewState?.dataByMonth ?? {};

    return TossScaffold(
        appBar: const TossAppBar1(
          title: 'Time Table Manage',
          backgroundColor: TossColors.background,
        ),
        backgroundColor: TossColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Tab Bar
              TossTabBar1(
                controller: _tabController,
                tabs: const ['Overview', 'Schedule', 'Problems', 'Stats'],
                padding: EdgeInsets.zero,
              ),
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Overview Tab - New Design
                    OverviewTab(
                      selectedStoreId: selectedStoreId,
                      onStoreSelectorTap: () {
                        // Legacy callback - no longer needed but kept for compatibility
                      },
                      onStoreChanged: (newStoreId) => _handleStoreChange(newStoreId),
                      onNavigateToSchedule: (date) => _navigateToScheduleWithDate(date),
                      onNavigateToProblems: (date) => _navigateToProblemsWithDate(date),
                    ),
                    ScheduleTabContent(
                      selectedStoreId: selectedStoreId,
                      selectedDate: selectedDate,
                      focusedMonth: focusedMonth,
                      scrollController: _scheduleScrollController,
                      getMonthName: _getMonthName,
                      onAddShiftTap: _showAddShiftBottomSheet,
                      onDateSelected: (date) {
                        // Clear selection when changing dates
                        ref.read(selectedShiftRequestsProvider.notifier).clearAll();

                        setState(() {
                          selectedDate = date;
                        });
                        // Fetch shift status for the selected date
                        fetchMonthlyShiftStatus();
                        // Fetch overview data if on Manage tab and month changed
                        if (_tabController.index == 1) {
                          fetchManagerOverview();
                        }
                      },
                      onPreviousMonth: () async {
                        setState(() {
                          focusedMonth = DateTime(
                            focusedMonth.year,
                            focusedMonth.month - 1,
                          );
                          // Auto-select first day of the new month so data updates properly
                          selectedDate = DateTime(focusedMonth.year, focusedMonth.month, 1);
                        });
                        await fetchMonthlyShiftStatus(forDate: focusedMonth);
                      },
                      onNextMonth: () async {
                        setState(() {
                          focusedMonth = DateTime(
                            focusedMonth.year,
                            focusedMonth.month + 1,
                          );
                          // Auto-select first day of the new month so data updates properly
                          selectedDate = DateTime(focusedMonth.year, focusedMonth.month, 1);
                        });
                        await fetchMonthlyShiftStatus(forDate: focusedMonth);
                      },
                      onApprovalSuccess: _handleApprovalSuccess,
                      fetchMonthlyShiftStatus: fetchMonthlyShiftStatus,
                      onStoreSelectorTap: () {
                        // Legacy callback - no longer needed but kept for compatibility
                      },
                      onStoreChanged: (newStoreId) => _handleStoreChange(newStoreId),
                    ),
                    // Timesheets Tab
                    TimesheetsTab(
                      selectedStoreId: selectedStoreId,
                      onStoreChanged: (newStoreId) => _handleStoreChange(newStoreId),
                      onNavigateToSchedule: (date) => _navigateToScheduleWithDate(date),
                      initialFilter: _timesheetsFilter,
                      selectedDate: selectedDate,
                      focusedMonth: focusedMonth,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                          // Update focused month if month changed
                          if (date.month != focusedMonth.month || date.year != focusedMonth.year) {
                            focusedMonth = DateTime(date.year, date.month);
                          }
                        });
                        // Fetch data for the new month if needed
                        fetchMonthlyShiftStatus();
                        fetchManagerCards();
                      },
                      onPreviousMonth: () async {
                        setState(() {
                          focusedMonth = DateTime(focusedMonth.year, focusedMonth.month - 1);
                          // Auto-select first day of the new month so data updates properly
                          selectedDate = DateTime(focusedMonth.year, focusedMonth.month, 1);
                        });
                        await fetchMonthlyShiftStatus(forDate: focusedMonth);
                        await fetchManagerCards(forDate: focusedMonth);
                      },
                      onNextMonth: () async {
                        setState(() {
                          focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1);
                          // Auto-select first day of the new month so data updates properly
                          selectedDate = DateTime(focusedMonth.year, focusedMonth.month, 1);
                        });
                        await fetchMonthlyShiftStatus(forDate: focusedMonth);
                        await fetchManagerCards(forDate: focusedMonth);
                      },
                    ),
                    // Stats Tab
                    ShiftStatsTab(
                      selectedStoreId: selectedStoreId,
                      onStoreChanged: (newStoreId) => _handleStoreChange(newStoreId),
                      onNavigateToTimesheets: (filter) => _navigateToTimesheetsWithFilter(filter),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _tabController,
          builder: (context, child) {
            if (_tabController.index != 0) {
              return const SizedBox.shrink();
            }

            return AiChatFab(
              featureName: _featureName ?? 'Time Table Manage',
              pageContext: _buildPageContext(managerOverviewDataByMonth),
              featureId: _featureId,
            );
          },
        ),
    );
  }

  Map<String, dynamic> _buildPageContext(Map<String, ManagerOverview> overviewData) {
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final managerOverview = overviewData[monthKey];

    return {
      'current_tab': _tabController.index == 0 ? 'Manage' : 'Schedule',
      'selected_date': manageSelectedDate.toIso8601String().split('T')[0],
      if (managerOverview != null) ...{
        'total_requests': managerOverview.totalShifts,
        'approved_count': managerOverview.totalApprovedRequests,
        'pending_count': managerOverview.totalPendingRequests,
        'problem_count': managerOverview.additionalStats['total_problems'] ?? 0,
      },
    };
  }
  
  // ✅ Removed: fetchShiftMetadata() - now handled by shiftMetadataProvider
  
  // ✅ Refactored: Use monthlyShiftStatusProvider
  Future<void> fetchMonthlyShiftStatus({DateTime? forDate, bool forceRefresh = false}) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) {
      return;
    }

    // Use provided date or selected date
    final targetDate = forDate ?? selectedDate;

    // Load data via Provider - Provider handles caching internally
    await ref.read(monthlyShiftStatusProvider(selectedStoreId!).notifier).loadMonth(
      month: targetDate,
      forceRefresh: forceRefresh,
    );

    // Preload profile images after data is loaded
    final state = ref.read(monthlyShiftStatusProvider(selectedStoreId!));
    final allDailyShifts = state.allMonthlyStatuses.expand((status) => status.dailyShifts).toList();
    _preloadProfileImages(allDailyShifts);
  }
  
  // ✅ Refactored: Use managerOverviewProvider
  Future<void> fetchManagerOverview({DateTime? forDate, bool forceRefresh = false}) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;

    // Use provided date or manageSelectedDate for Manage tab
    final targetDate = forDate ?? manageSelectedDate;

    // Load data via Provider - Provider handles caching internally
    await ref.read(managerOverviewProvider(selectedStoreId!).notifier).loadMonth(
      month: targetDate,
      forceRefresh: forceRefresh,
    );
  }
  
  // Fetch manager shift cards from Supabase RPC
  Future<void> fetchManagerCards({DateTime? forDate, bool forceRefresh = false}) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;
    final targetDate = forDate ?? manageSelectedDate;

    await ref.read(managerCardsProvider(selectedStoreId!).notifier).loadMonth(
      month: targetDate,
      forceRefresh: forceRefresh,
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  /// Navigate to Schedule tab with a specific date selected
  ///
  /// Called when user taps on an understaffed shift in Need Attention section.
  /// Switches to Schedule tab and sets the selected date.
  void _navigateToScheduleWithDate(DateTime date) {
    setState(() {
      selectedDate = date;
      focusedMonth = DateTime(date.year, date.month);
    });

    _tabController.animateTo(1);
    fetchMonthlyShiftStatus(forDate: date);
  }

  /// Navigate to Problems tab with a specific date selected
  ///
  /// Called when user taps on a problem dot in Need Attention timeline.
  /// Switches to Problems tab and sets the selected date.
  void _navigateToProblemsWithDate(DateTime date) {
    setState(() {
      selectedDate = date;
      focusedMonth = DateTime(date.year, date.month);
    });

    _tabController.animateTo(2);
    fetchMonthlyShiftStatus(forDate: date);
    fetchManagerCards(forDate: date);
  }

  /// Navigate to Timesheets tab with a specific filter
  ///
  /// Called when user taps on "Problem solves" in Stats tab.
  /// Switches to Timesheets tab and sets the filter (e.g., 'this_month').
  void _navigateToTimesheetsWithFilter(String filter) {
    setState(() {
      _timesheetsFilter = filter;
    });

    // Switch to Timesheets tab (index 2)
    _tabController.animateTo(2);
  }

  /// Handle store change from dropdown selection
  ///
  /// Called when user selects a different store from the TossDropdown.
  /// Updates app state and re-fetches all data for the new store.
  Future<void> _handleStoreChange(String newStoreId) async {
    if (newStoreId == selectedStoreId) return;

    // Get store name from user data
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];
    String? storeName;

    for (final company in companies) {
      final stores = (company as Map<String, dynamic>)['stores'] as List<dynamic>?;
      if (stores != null) {
        for (final store in stores) {
          final storeMap = store as Map<String, dynamic>;
          if (storeMap['store_id']?.toString() == newStoreId) {
            storeName = storeMap['store_name']?.toString();
            break;
          }
        }
      }
    }

    // Clear previous store's provider data
    if (selectedStoreId != null && selectedStoreId!.isNotEmpty) {
      ref.read(monthlyShiftStatusProvider(selectedStoreId!).notifier).clearAll();
      ref.read(managerOverviewProvider(selectedStoreId!).notifier).clearAll();
      ref.read(managerCardsProvider(selectedStoreId!).notifier).clearAll();
    }

    // Clear selection when switching stores
    ref.read(selectedShiftRequestsProvider.notifier).clearAll();

    // Update local state
    setState(() {
      selectedStoreId = newStoreId;
    });

    // Update app state with the new store selection
    ref.read(appStateProvider.notifier).selectStore(
      newStoreId,
      storeName: storeName,
    );

    // Invalidate ALL providers to force fresh data with new store
    ref.invalidate(shiftMetadataProvider(newStoreId));
    ref.invalidate(reliabilityScoreProvider(newStoreId));
    ref.invalidate(monthlyShiftStatusProvider(newStoreId));
    ref.invalidate(managerOverviewProvider(newStoreId));
    ref.invalidate(managerCardsProvider(newStoreId));

    // Trigger FutureProviders to fetch immediately after invalidate
    ref.read(shiftMetadataProvider(newStoreId));
    ref.read(reliabilityScoreProvider(newStoreId));

    // Fetch data for the new store (StateNotifierProviders) - run ALL in parallel
    // Before: Sequential await (T1 + T2 + T3) ~3-5 seconds
    // After: Parallel max(T1, T2, T3) ~1-2 seconds
    await Future.wait([
      fetchMonthlyShiftStatus(forceRefresh: true),
      fetchManagerOverview(forceRefresh: true),
      fetchManagerCards(forceRefresh: true),
    ]);
  }
  // ✅ Refactored: Handle approval success callback using Provider
  Future<void> _handleApprovalSuccess() async {
    final monthKey = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}';

    // Clear selection via Provider
    ref.read(selectedShiftRequestsProvider.notifier).clearAll();

    // Clear Manager tab cached data to force refresh
    if (selectedStoreId != null && selectedStoreId!.isNotEmpty) {
      ref.read(managerCardsProvider(selectedStoreId!).notifier).clearMonth(monthKey);
    }

    // Force refresh the shift data to show updated status
    await fetchMonthlyShiftStatus(forDate: selectedDate, forceRefresh: true);

    // Also refresh Manager tab data to reflect the changes immediately
    await fetchManagerOverview(forDate: selectedDate, forceRefresh: true);
    await fetchManagerCards(forDate: selectedDate, forceRefresh: true);
  }

  // ✅ Extracted to ScheduleTabContent widget

  // Show add shift bottom sheet
  void _showAddShiftBottomSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => AddShiftBottomSheet(
        onShiftAdded: () async {
          // Refresh data immediately when shift is added (before closing bottom sheet)
          if (selectedStoreId != null && mounted) {
            // Refresh Schedule tab data - this will update the UI immediately
            await fetchMonthlyShiftStatus(forDate: focusedMonth, forceRefresh: true);
            // Refresh Manage tab data
            await fetchManagerOverview(forDate: manageSelectedDate, forceRefresh: true);
            await fetchManagerCards(forDate: manageSelectedDate, forceRefresh: true);
            // ✅ Provider가 자동으로 UI 업데이트하므로 setState() 불필요
          }
        },
      ),
    );

    // Additional refresh after bottom sheet closes
    if (result == true && mounted) {
      await fetchMonthlyShiftStatus(forDate: focusedMonth, forceRefresh: true);
      // ✅ Provider가 자동으로 UI 업데이트하므로 setState() 불필요
    }
  }
}
