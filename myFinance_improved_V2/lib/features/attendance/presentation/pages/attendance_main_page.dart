import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/ai_chat/ai_chat_fab.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import 'my_schedule_tab.dart';
import 'shift_signup_tab.dart';
import 'stats_tab.dart';

/// AttendanceMainPage - Main page with 3 tabs
///
/// Tabs:
/// - My Schedule: Week/Month view with shift list and calendar
/// - Requests: Shift registration and management
/// - Stats: Attendance statistics (placeholder)
class AttendanceMainPage extends ConsumerStatefulWidget {
  final dynamic feature;

  const AttendanceMainPage({super.key, this.feature});

  @override
  ConsumerState<AttendanceMainPage> createState() => _AttendanceMainPageState();
}

class _AttendanceMainPageState extends ConsumerState<AttendanceMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final String _aiChatSessionId;
  String? _featureName;
  String? _featureId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _aiChatSessionId = const Uuid().v4();

    // Extract feature info
    final feature = widget.feature;
    if (feature != null) {
      if (feature is Map) {
        _featureName = feature['featureName'] as String?;
        _featureId = feature['featureId'] as String?;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildPageContext() {
    return {
      'current_tab': _tabController.index == 0
          ? 'My Schedule'
          : _tabController.index == 1
              ? 'Requests'
              : 'Stats',
      'selected_date': DateTime.now().toIso8601String().split('T')[0],
    };
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
              controller: _tabController,
              tabs: const ['My Schedule', 'Requests', 'Stats'],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MyScheduleTab(),
                  ShiftSignupTab(),
                  StatsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AiChatFab(
        featureName: _featureName ?? 'Attendance',
        pageContext: _buildPageContext(),
        featureId: _featureId,
        sessionId: _aiChatSessionId,
      ),
    );
  }
}
