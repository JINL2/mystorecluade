import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import 'shift_signup_tab.dart';
import 'my_schedule_tab.dart';
import 'stats_tab.dart';

/// AttendanceMainPage - Main page with 3 tabs
///
/// Tabs:
/// - My Schedule: Week/Month view with shift list and calendar
/// - Requests: Shift registration and management
/// - Stats: Attendance statistics (placeholder)
class AttendanceMainPage extends StatelessWidget {
  const AttendanceMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: const TossAppBar1(
        title: 'Attendance',
        backgroundColor: TossColors.background,
      ),
      body: SafeArea(
        child: TossTabBarView1(
          tabs: const ['My Schedule', 'Requests', 'Stats'],
          children: const [
            MyScheduleTab(),
            ShiftSignupTab(),
            StatsTab(),
          ],
        ),
      ),
    );
  }
}
