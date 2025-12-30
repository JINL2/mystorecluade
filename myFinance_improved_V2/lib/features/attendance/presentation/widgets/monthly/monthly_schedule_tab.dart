import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../../shared/widgets/toss/toss_month_navigation.dart';
import '../../../../../shared/widgets/toss/toss_today_shift_card.dart';
import '../../../domain/entities/monthly_attendance.dart';
import '../../providers/monthly_attendance_providers.dart';
import 'monthly_calendar.dart';
import 'monthly_day_detail.dart';

/// Monthly 직원용 스케줄 탭
///
/// Hourly의 MyScheduleTab과 동일한 심플/미니멀 디자인
/// TossTodayShiftCard를 재사용하여 일관된 UI 제공
class MonthlyScheduleTab extends ConsumerStatefulWidget {
  const MonthlyScheduleTab({super.key});

  @override
  ConsumerState<MonthlyScheduleTab> createState() => _MonthlyScheduleTabState();
}

class _MonthlyScheduleTabState extends ConsumerState<MonthlyScheduleTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentMonthOffset = 0;
  DateTime _selectedDate = DateTime.now();

  DateTime get _currentMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + _currentMonthOffset, 1);
  }

  String get _yearMonth =>
      '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';

  void _navigateMonth(int offset) {
    if (offset == 0) {
      setState(() => _currentMonthOffset = 0);
    } else {
      setState(() => _currentMonthOffset += offset);
    }
  }

  void _handleDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
  }

  Future<void> _navigateToQRScanner() async {
    final result =
        await context.push<Map<String, dynamic>>('/attendance/qr-scanner');

    if (result != null && result['success'] == true) {
      ref.invalidate(todayMonthlyAttendanceProvider);
      ref.invalidate(monthlyAttendanceStatsProvider(_yearMonth));
      ref.invalidate(monthlyAttendanceListProvider(_yearMonth));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final todayAsync = ref.watch(todayMonthlyAttendanceProvider);
    final listAsync = ref.watch(monthlyAttendanceListProvider(_yearMonth));

    return todayAsync.when(
      data: (todayAttendance) => listAsync.when(
        data: (attendanceList) => _buildContent(todayAttendance, attendanceList),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildErrorView(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildErrorView(e.toString()),
    );
  }

  Widget _buildContent(
    MonthlyAttendance? todayAttendance,
    List<MonthlyAttendance> attendanceList,
  ) {
    final selectedAttendance = _findAttendanceForDate(attendanceList, _selectedDate);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================
          // Section 1: Today's Status Card (TossTodayShiftCard 사용)
          // ============================================
          Container(
            color: TossColors.white,
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: _buildTodayCard(todayAttendance),
          ),

          // ============================================
          // Gray Divider
          // ============================================
          const GrayDividerSpace(),

          // ============================================
          // Section 2: Calendar (white background)
          // ============================================
          Container(
            color: TossColors.white,
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Navigation
                TossMonthNavigation(
                  currentMonth: DateFormat.MMMM().format(_currentMonth),
                  year: _currentMonth.year,
                  onPrevMonth: () => _navigateMonth(-1),
                  onCurrentMonth: () => _navigateMonth(0),
                  onNextMonth: () => _navigateMonth(1),
                ),
                const SizedBox(height: 16),

                // Calendar
                MonthlyCalendar(
                  currentMonth: _currentMonth,
                  selectedDate: _selectedDate,
                  attendanceList: attendanceList,
                  onDateSelected: _handleDateSelected,
                ),
                const SizedBox(height: 16),

                // Selected Date Detail
                Text(
                  DateFormat('EEE, d MMM').format(_selectedDate),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                MonthlyDayDetail(
                  selectedDate: _selectedDate,
                  attendance: selectedAttendance,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Today's Card - TossTodayShiftCard 사용하여 Hourly와 동일한 디자인
  /// V3: scheduledStartTimeUtc / scheduledEndTimeUtc (DateTime, UTC)
  Widget _buildTodayCard(MonthlyAttendance? today) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEE, d MMM yyyy').format(now);

    // V3: UTC DateTime을 로컬 시간으로 변환하여 표시
    final scheduledStartLocal = today?.scheduledStartTimeUtc?.toLocal();
    final scheduledEndLocal = today?.scheduledEndTimeUtc?.toLocal();
    final startTimeStr =
        scheduledStartLocal != null ? _formatTime(scheduledStartLocal) : '09:00';
    final endTimeStr =
        scheduledEndLocal != null ? _formatTime(scheduledEndLocal) : '18:00';
    final timeRange = '$startTimeStr - $endTimeStr';

    // Status 결정
    final status = _determineStatus(today);

    // Problem info 생성 (Late, Early Leave 등)
    final problemInfo = _buildProblemInfo(today);

    // Actual times (체크인/체크아웃 시간)
    final actualStartTime = today?.checkInTimeUtc != null
        ? _formatTime(today!.checkInTimeUtc!.toLocal())
        : null;
    final actualEndTime = today?.checkOutTimeUtc != null
        ? _formatTime(today!.checkOutTimeUtc!.toLocal())
        : null;

    return TossTodayShiftCard(
      shiftType: 'Daily Schedule',
      date: dateStr,
      timeRange: timeRange,
      location: null, // Monthly는 location 표시 안함
      status: status,
      onCheckIn: _navigateToQRScanner,
      onCheckOut: _navigateToQRScanner,
      problemInfo: problemInfo,
      actualStartTime: actualStartTime,
      actualEndTime: actualEndTime,
      confirmStartTime: actualStartTime,
      confirmEndTime: actualEndTime,
      // V3: Monthly 직원은 월급제라 Payment Time 불필요
      // Schedule Time + Real Time만 비교
      showPaymentTime: false,
    );
  }

  /// MonthlyAttendance status를 ShiftStatus로 변환
  /// V3: UTC DateTime으로 시간 비교 (모든 시간이 UTC라서 바로 비교 가능)
  ShiftStatus _determineStatus(MonthlyAttendance? today) {
    // 체크인/체크아웃 완료된 경우
    if (today != null) {
      switch (today.status) {
        case 'completed':
          return ShiftStatus.completed;
        case 'checked_in':
          return today.isLate ? ShiftStatus.late : ShiftStatus.onTime;
      }
    }

    // 체크인 안 한 경우: UTC 시간 비교
    final nowUtc = DateTime.now().toUtc();

    // V3: scheduledStartTimeUtc / scheduledEndTimeUtc는 이미 UTC DateTime
    final startTimeUtc = today?.scheduledStartTimeUtc;
    final endTimeUtc = today?.scheduledEndTimeUtc;

    // 예정 시간이 없으면 기본값 사용 (오늘 09:00~18:00 UTC+7 = 02:00~11:00 UTC)
    if (startTimeUtc == null || endTimeUtc == null) {
      return ShiftStatus.upcoming;
    }

    // UTC끼리 비교
    if (nowUtc.isBefore(startTimeUtc)) {
      return ShiftStatus.upcoming; // 시작 전
    } else if (nowUtc.isBefore(endTimeUtc)) {
      return ShiftStatus.undone; // 시작됨, 체크인 안함
    } else {
      return ShiftStatus.undone; // 종료됨, 체크인 안함
    }
  }

  /// MonthlyAttendance에서 ShiftProblemInfo 생성
  /// V3: UTC DateTime으로 지각/조퇴 시간 계산
  ShiftProblemInfo? _buildProblemInfo(MonthlyAttendance? today) {
    if (today == null) return null;

    final hasLate = today.isLate;
    final hasEarlyLeave = today.isEarlyLeave;

    if (!hasLate && !hasEarlyLeave) return null;

    // V3: UTC 시간끼리 비교하여 지각/조퇴 분 계산
    int lateMinutes = 0;
    int earlyLeaveMinutes = 0;

    if (hasLate &&
        today.checkInTimeUtc != null &&
        today.scheduledStartTimeUtc != null) {
      lateMinutes = today.checkInTimeUtc!
          .difference(today.scheduledStartTimeUtc!)
          .inMinutes;
      if (lateMinutes < 0) lateMinutes = 0;
    }

    if (hasEarlyLeave &&
        today.checkOutTimeUtc != null &&
        today.scheduledEndTimeUtc != null) {
      earlyLeaveMinutes = today.scheduledEndTimeUtc!
          .difference(today.checkOutTimeUtc!)
          .inMinutes;
      if (earlyLeaveMinutes < 0) earlyLeaveMinutes = 0;
    }

    return ShiftProblemInfo(
      isLate: hasLate,
      lateMinutes: lateMinutes,
      isEarlyLeave: hasEarlyLeave,
      earlyLeaveMinutes: earlyLeaveMinutes,
      problemCount: (hasLate ? 1 : 0) + (hasEarlyLeave ? 1 : 0),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  MonthlyAttendance? _findAttendanceForDate(
    List<MonthlyAttendance> list,
    DateTime date,
  ) {
    try {
      return list.firstWhere(
        (a) =>
            a.attendanceDate.year == date.year &&
            a.attendanceDate.month == date.month &&
            a.attendanceDate.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
            const SizedBox(height: 16),
            Text(
              'Failed to load data',
              style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(todayMonthlyAttendanceProvider);
                ref.invalidate(monthlyAttendanceListProvider(_yearMonth));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
