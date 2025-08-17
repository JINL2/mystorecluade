import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../../data/services/attendance_service.dart';
import 'package:intl/intl.dart';

class AttendanceMainPage extends StatefulWidget {
  const AttendanceMainPage({super.key});

  @override
  State<AttendanceMainPage> createState() => _AttendanceMainPageState();
}

class _AttendanceMainPageState extends State<AttendanceMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        backgroundColor: TossColors.white,
        elevation: 0,
        title: Text(
          'Attendance',
          style: TossTextStyles.h1.copyWith(
            color: TossColors.gray900,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: TossColors.primary,
          indicatorWeight: 3,
          labelColor: TossColors.primary,
          unselectedLabelColor: TossColors.gray500,
          labelStyle: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Register'),
            Tab(text: 'Check In/Out'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ShiftRegisterTab(),
          AttendanceContent(),
        ],
      ),
    );
  }
}

// Rest of the file content up to line 2790...
// (I'll copy the content from the original file up to the proper end of _CalendarBottomSheetState)