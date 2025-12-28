import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../providers/attendance_providers.dart';
import '../providers/monthly_attendance_providers.dart';
import '../widgets/monthly/monthly_schedule_tab.dart';
import 'shift_requests_tab.dart';
import 'my_schedule_tab.dart';
import 'stats_tab.dart';

/// AttendanceMainPage - Main page with tabs
///
/// Tabs vary by salary type:
/// - Hourly: My Schedule, Shift Sign Up, Stats (3 tabs)
/// - Monthly: My Schedule, Stats (2 tabs)
class AttendanceMainPage extends ConsumerStatefulWidget {
  const AttendanceMainPage({super.key});

  @override
  ConsumerState<AttendanceMainPage> createState() => _AttendanceMainPageState();
}

class _AttendanceMainPageState extends ConsumerState<AttendanceMainPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _selectedStoreId;
  bool _isMonthly = false;
  bool _salaryTypeLoaded = false;

  @override
  void initState() {
    super.initState();
    // TabController는 salaryType 로딩 후 생성

    // Initialize selected store from app state
    final appState = ref.read(appStateProvider);
    _selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    // Refresh all data when page is entered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAllData();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _initTabController(bool isMonthly) {
    if (_salaryTypeLoaded && _isMonthly == isMonthly) return;

    _tabController?.dispose();
    _tabController = TabController(
      length: isMonthly ? 2 : 3,
      vsync: this,
    );
    _isMonthly = isMonthly;
    _salaryTypeLoaded = true;
  }

  /// Invalidate all attendance-related providers to force data refresh
  void _refreshAllData() {
    // Invalidate Stats tab data
    ref.invalidate(userShiftStatsProvider);
    ref.invalidate(baseCurrencyProvider);

    // Invalidate My Schedule tab data
    final now = DateTime.now();
    final currentYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    ref.invalidate(monthlyShiftCardsProvider(currentYearMonth));

    // Invalidate current shift status
    ref.invalidate(currentShiftProvider);
  }

  /// Extract stores from user data for the currently selected company
  List<Map<String, dynamic>> _extractStores() {
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    final selectedCompanyId = appState.companyChoosen;

    if (userData.isEmpty || selectedCompanyId.isEmpty) return [];

    try {
      final companies = userData['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) return [];

      for (final company in companies) {
        final companyMap = company as Map<String, dynamic>;
        final companyId = companyMap['company_id']?.toString() ?? '';
        if (companyId == selectedCompanyId) {
          final stores = companyMap['stores'] as List<dynamic>?;
          return stores?.cast<Map<String, dynamic>>() ?? [];
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Handle store change with loading state
  Future<void> _handleStoreChange(String newStoreId) async {
    if (newStoreId == _selectedStoreId) return;

    // Get store name
    final stores = _extractStores();
    String? storeName;
    for (final store in stores) {
      if (store['store_id']?.toString() == newStoreId) {
        storeName = store['store_name']?.toString();
        break;
      }
    }

    // Start loading
    ref.read(attendanceStoreLoadingProvider.notifier).state = true;

    // Update local state
    setState(() {
      _selectedStoreId = newStoreId;
    });

    // Update app state
    ref.read(appStateProvider.notifier).selectStore(
      newStoreId,
      storeName: storeName,
    );

    // Invalidate all providers
    _refreshAllData();

    // Wait for essential data to load
    final now = DateTime.now();
    final currentYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    try {
      // Wait for all essential providers to complete
      await Future.wait([
        ref.read(monthlyShiftCardsProvider(currentYearMonth).future),
        ref.read(userShiftStatsProvider.future),
      ]);
    } catch (e) {
      // Ignore errors, UI will handle them
    } finally {
      // Stop loading
      if (mounted) {
        ref.read(attendanceStoreLoadingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stores = _extractStores();
    final isLoading = ref.watch(attendanceStoreLoadingProvider);
    final salaryTypeAsync = ref.watch(userSalaryTypeProvider);

    return salaryTypeAsync.when(
      data: (salaryType) {
        final isMonthly = salaryType == 'monthly';

        // TabController 초기화 (salaryType에 따라)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _initTabController(isMonthly);
            setState(() {});
          }
        });

        // TabController가 아직 없으면 로딩 표시
        if (_tabController == null) {
          return TossScaffold(
            backgroundColor: TossColors.background,
            appBar: const TossAppBar1(
              title: 'Attendance',
              backgroundColor: TossColors.background,
            ),
            body: const TossLoadingView(),
          );
        }

        return TossScaffold(
          backgroundColor: TossColors.background,
          appBar: const TossAppBar1(
            title: 'Attendance',
            backgroundColor: TossColors.background,
          ),
          body: SafeArea(
            child: Column(
              children: [
                TossTabBar1(
                  tabs: isMonthly
                      ? const ['My Schedule', 'Stats']
                      : const ['My Schedule', 'Shift Sign Up', 'Stats'],
                  controller: _tabController!,
                ),
                // Show loading view when changing store
                if (isLoading)
                  const Expanded(
                    child: TossLoadingView(
                      message: 'Loading store data...',
                    ),
                  )
                else
                  Expanded(
                    child: TabBarView(
                      controller: _tabController!,
                      children: isMonthly
                          ? [
                              // Monthly: 2 tabs
                              const MonthlyScheduleTab(),
                              const StatsTab(),
                            ]
                          : [
                              // Hourly: 3 tabs (기존 로직)
                              MyScheduleTab(
                                tabController: _tabController!,
                                stores: stores,
                                selectedStoreId: _selectedStoreId,
                                onStoreChanged: _handleStoreChange,
                              ),
                              ShiftRequestsTab(
                                stores: stores,
                                selectedStoreId: _selectedStoreId,
                                onStoreChanged: _handleStoreChange,
                              ),
                              const StatsTab(),
                            ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => TossScaffold(
        backgroundColor: TossColors.background,
        appBar: const TossAppBar1(
          title: 'Attendance',
          backgroundColor: TossColors.background,
        ),
        body: const TossLoadingView(),
      ),
      error: (e, _) {
        // 에러 시 기본값 Hourly로 처리
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_salaryTypeLoaded) {
            _initTabController(false);
            setState(() {});
          }
        });

        if (_tabController == null) {
          return TossScaffold(
            backgroundColor: TossColors.background,
            appBar: const TossAppBar1(
              title: 'Attendance',
              backgroundColor: TossColors.background,
            ),
            body: const TossLoadingView(),
          );
        }

        return TossScaffold(
          backgroundColor: TossColors.background,
          appBar: const TossAppBar1(
            title: 'Attendance',
            backgroundColor: TossColors.background,
          ),
          body: SafeArea(
            child: Column(
              children: [
                TossTabBar1(
                  tabs: const ['My Schedule', 'Shift Sign Up', 'Stats'],
                  controller: _tabController!,
                ),
                if (isLoading)
                  const Expanded(
                    child: TossLoadingView(
                      message: 'Loading store data...',
                    ),
                  )
                else
                  Expanded(
                    child: TabBarView(
                      controller: _tabController!,
                      children: [
                        MyScheduleTab(
                          tabController: _tabController!,
                          stores: stores,
                          selectedStoreId: _selectedStoreId,
                          onStoreChanged: _handleStoreChange,
                        ),
                        ShiftRequestsTab(
                          stores: stores,
                          selectedStoreId: _selectedStoreId,
                          onStoreChanged: _handleStoreChange,
                        ),
                        const StatsTab(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
