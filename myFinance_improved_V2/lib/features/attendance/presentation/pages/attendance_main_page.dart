import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MyScheduleTab(tabController: _tabController),
                  const ShiftRequestsTab(),
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
