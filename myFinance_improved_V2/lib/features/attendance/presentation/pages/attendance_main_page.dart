import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../providers/attendance_providers.dart';
import 'shift_requests_tab.dart';
import 'my_schedule_tab.dart';
import 'stats_tab.dart';

/// AttendanceMainPage - Main page with 3 tabs
///
/// Tabs:
/// - My Schedule: Week/Month view with shift list and calendar
/// - Requests: Shift registration and management
/// - Stats: Attendance statistics (placeholder)
class AttendanceMainPage extends ConsumerStatefulWidget {
  const AttendanceMainPage({super.key});

  @override
  ConsumerState<AttendanceMainPage> createState() => _AttendanceMainPageState();
}

class _AttendanceMainPageState extends ConsumerState<AttendanceMainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedStoreId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
    _tabController.dispose();
    super.dispose();
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
              controller: _tabController,
            ),
            // Show loading view when changing store (same as Time Table Management)
            if (isLoading)
              const Expanded(
                child: TossLoadingView(
                  message: 'Loading store data...',
                ),
              )
            else
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MyScheduleTab(
                      tabController: _tabController,
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
  }
}
