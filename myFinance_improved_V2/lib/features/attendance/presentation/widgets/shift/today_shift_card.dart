import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/shift_problem_info.dart';
import '../../../domain/entities/shift_status.dart';

// Re-export for backward compatibility
export '../../../domain/entities/shift_problem_info.dart';
export '../../../domain/entities/shift_status.dart';

/// TossTodayShiftCard - Featured card showing today's shift
///
/// Design matches the screenshot:
/// - Title: "Today's shift" (gray, small)
/// - Shift Type: "Morning" (large, bold)
/// - Date: "Tue, 18 Jun 2025" (gray)
/// - Time row: "Time" label + "09:00 - 17:00" value
/// - Location row: "Location" label + "Downtown Store" value
/// - Status badge: Top-right corner (green pill)
/// - Check-in button: Full-width blue button
/// - After check-in: Show problem details if any
/// - After check-out: Show Real Time and Payment Time
class TossTodayShiftCard extends StatelessWidget {
  final String? shiftType;
  final String? date;
  final String? timeRange;
  final String? location;
  final ShiftStatus status;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final VoidCallback? onGoToShiftSignUp;
  final VoidCallback? onReportIssue;
  final bool isLoading;
  final bool? isUpcoming;

  // v5: Problem details
  final ShiftProblemInfo? problemInfo;

  // v5: Actual times (for completed shifts)
  final String? actualStartTime;  // "07:09:00"
  final String? actualEndTime;    // "17:30:00"
  final String? confirmStartTime; // "07:09"
  final String? confirmEndTime;   // "17:30"

  /// V3: Monthly 직원은 Payment Time 불필요 (월급제라 시급 계산 없음)
  /// true: Hourly - Real Time + Payment Time 표시
  /// false: Monthly - Schedule Time + Real Time만 표시
  final bool showPaymentTime;

  const TossTodayShiftCard({
    super.key,
    this.shiftType,
    this.date,
    this.timeRange,
    this.location,
    required this.status,
    this.onCheckIn,
    this.onCheckOut,
    this.onGoToShiftSignUp,
    this.onReportIssue,
    this.isLoading = false,
    this.isUpcoming,
    this.problemInfo,
    this.actualStartTime,
    this.actualEndTime,
    this.confirmStartTime,
    this.confirmEndTime,
    this.showPaymentTime = true,
  });

  Color _getBadgeColor() {
    switch (status) {
      case ShiftStatus.onTime:
      case ShiftStatus.inProgress:
        return TossColors.success;
      case ShiftStatus.late:
        return TossColors.error;
      case ShiftStatus.upcoming:
        return TossColors.primary;
      case ShiftStatus.undone:
      case ShiftStatus.completed:
        return TossColors.gray400;
      case ShiftStatus.noShift:
        return TossColors.gray300;
    }
  }

  String _getStatusText() {
    switch (status) {
      case ShiftStatus.onTime:
        return 'On-time';
      case ShiftStatus.inProgress:
        return 'In Progress';
      case ShiftStatus.late:
        return 'Late';
      case ShiftStatus.upcoming:
        return 'Upcoming';
      case ShiftStatus.undone:
        return 'Undone';
      case ShiftStatus.completed:
        return 'Completed';
      case ShiftStatus.noShift:
        return '';
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space6),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: TossColors.gray400,
              size: 48,
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'You have no shift',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space1),
            TextButton(
              onPressed: onGoToShiftSignUp,
              child: Text(
                'Go to shift sign up',
                style: TossTextStyles.label.copyWith(
                  color: TossColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (status == ShiftStatus.noShift) {
      return const SizedBox.shrink();
    }

    String buttonText;
    IconData buttonIcon;
    VoidCallback? onPressed;
    Color buttonColor;
    bool isOutlined = false;

    switch (status) {
      // 체크인 대기 상태 (파란 버튼)
      case ShiftStatus.upcoming:
      case ShiftStatus.undone:
        buttonText = 'Check-in';
        buttonIcon = Icons.login;
        onPressed = onCheckIn;
        buttonColor = TossColors.primary;
        break;
      // 체크인 완료, 체크아웃 대기 상태 (빨간 버튼)
      case ShiftStatus.onTime:
      case ShiftStatus.inProgress:
      case ShiftStatus.late:
        buttonText = 'Check-out';
        buttonIcon = Icons.logout;
        onPressed = onCheckOut;
        buttonColor = TossColors.error;
        break;
      // 완료된 시프트 - Report 버튼 표시
      case ShiftStatus.completed:
        // 이미 리포트한 경우 - 회색 비활성화 버튼
        if (problemInfo?.isReported == true) {
          buttonText = 'Report Done';
          buttonIcon = Icons.check_circle_outline;
          onPressed = null; // non-clickable
          buttonColor = TossColors.gray400;
          isOutlined = true;
        } else {
          buttonText = 'Report Issue';
          buttonIcon = Icons.flag_outlined;
          onPressed = onReportIssue;
          buttonColor = TossColors.warning;
          isOutlined = true;
        }
        break;
      case ShiftStatus.noShift:
        return const SizedBox.shrink();
    }

    // Outlined style for Report button
    if (isOutlined) {
      return SizedBox(
        height: 48,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor.withValues(alpha: 0.5)),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(buttonIcon, size: 20),
                    SizedBox(width: TossSpacing.space2),
                    Text(
                      buttonText,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: TossColors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(buttonIcon, size: 20),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    buttonText,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Build warning banner for undone status (shift started but not checked in)
  Widget _buildUndoneWarning() {
    if (status != ShiftStatus.undone) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space4),
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: TossColors.error,
            size: 20,
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              "You haven't checked in yet!",
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build problem badges after check-in (max 2 visible, rest as +N)
  Widget _buildProblemSection() {
    if (problemInfo == null || !problemInfo!.hasProblem) {
      return const SizedBox.shrink();
    }

    final allProblems = <({IconData icon, String label, Color color})>[];

    // Late badge (priority 1 - most important)
    if (problemInfo!.isLate) {
      allProblems.add((
        icon: Icons.access_time,
        label: 'Late ${problemInfo!.lateMinutes}m',
        color: TossColors.error,
      ));
    }

    // No checkout badge (priority 2)
    if (problemInfo!.hasNoCheckout) {
      allProblems.add((
        icon: Icons.warning_amber,
        label: 'No Checkout',
        color: TossColors.error,
      ));
    }

    // Location issue badge (priority 3)
    if (problemInfo!.hasLocationIssue) {
      final distance = problemInfo!.checkinDistance;
      String label;
      if (distance != null && distance >= 1000) {
        label = 'Location ${(distance / 1000).toStringAsFixed(1)}km';
      } else if (distance != null) {
        label = 'Location ${distance}m';
      } else {
        label = 'Location Issue';
      }
      allProblems.add((
        icon: Icons.location_off,
        label: label,
        color: TossColors.warning,
      ));
    }

    // Early leave badge (priority 4)
    if (problemInfo!.isEarlyLeave) {
      allProblems.add((
        icon: Icons.exit_to_app,
        label: 'Early ${problemInfo!.earlyLeaveMinutes}m',
        color: TossColors.warning,
      ));
    }

    // Overtime badge (priority 5 - positive)
    if (problemInfo!.isOvertime) {
      allProblems.add((
        icon: Icons.more_time,
        label: 'OT ${problemInfo!.overtimeMinutes}m',
        color: TossColors.primary,
      ));
    }

    // Reported badge (priority 6)
    if (problemInfo!.isReported) {
      allProblems.add((
        icon: problemInfo!.isSolved ? Icons.check_circle : Icons.report,
        label: problemInfo!.isSolved ? 'Resolved' : 'Reported',
        color: problemInfo!.isSolved ? TossColors.success : TossColors.warning,
      ));
    }

    if (allProblems.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show max 2 badges, rest as +N
    const maxVisible = 2;
    final visibleProblems = allProblems.take(maxVisible).toList();
    final hiddenCount = allProblems.length - maxVisible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: TossColors.gray200, height: 1),
        SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            ...visibleProblems.map((p) => Padding(
              padding: EdgeInsets.only(right: TossSpacing.space2),
              child: _buildProblemBadge(
                icon: p.icon,
                label: p.label,
                color: p.color,
              ),
            )),
            if (hiddenCount > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Text(
                  '+$hiddenCount',
                  style: TossTextStyles.labelSmall.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        // Report button if there are unresolved problems (NOT for Completed status - handled in _buildActionButton)
        if (problemInfo!.hasProblem && !problemInfo!.isSolved && !problemInfo!.isReported &&
            status != ShiftStatus.completed && onReportIssue != null) ...[
          SizedBox(height: TossSpacing.space3),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onReportIssue,
              icon: Icon(Icons.flag_outlined, size: 18),
              label: Text('Report Issue'),
              style: OutlinedButton.styleFrom(
                foregroundColor: TossColors.warning,
                side: BorderSide(color: TossColors.warning.withValues(alpha: 0.5)),
                padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
              ),
            ),
          ),
        ],
        SizedBox(height: TossSpacing.space3),
      ],
    );
  }

  Widget _buildProblemBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TossTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build time section - shows scheduled time before check-in,
  /// Real Time & Payment Time after check-in
  ///
  /// V3: showPaymentTime == false (Monthly) → Schedule Time + Real Time만 표시
  ///     showPaymentTime == true (Hourly)  → Real Time + Payment Time 표시
  Widget _buildTimeSection() {
    // Before check-in: show scheduled time only
    final isCheckedIn = status == ShiftStatus.onTime ||
        status == ShiftStatus.inProgress ||
        status == ShiftStatus.late ||
        status == ShiftStatus.completed;

    if (!isCheckedIn) {
      // Show simple time row for upcoming/undone shifts
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Time',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            timeRange ?? 'No time',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      );
    }

    // After check-in: show time comparison
    // V3: Monthly (showPaymentTime=false) → Schedule Time + Real Time
    //     Hourly  (showPaymentTime=true)  → Real Time + Payment Time
    if (!showPaymentTime) {
      // Monthly: Schedule Time + Real Time (no payment calculation needed)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Schedule Time row (예정 시간)
          _buildTimeRow(
            label: 'Schedule',
            startTime: _extractTime(timeRange, isStart: true),
            endTime: _extractTime(timeRange, isStart: false),
            icon: Icons.event_note_outlined,
          ),
          SizedBox(height: TossSpacing.space2),
          // Real Time row (실제 체크인/아웃 시간)
          _buildTimeRow(
            label: 'Real Time',
            startTime: _formatTimeDisplay(actualStartTime),
            endTime: _formatTimeDisplay(actualEndTime),
            icon: Icons.schedule,
            highlight: true,
          ),
        ],
      );
    }

    // Hourly: Real Time + Payment Time (for payroll calculation)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Real Time row (actual check-in/out times)
        _buildTimeRow(
          label: 'Real Time',
          startTime: _formatTimeDisplay(actualStartTime),
          endTime: _formatTimeDisplay(actualEndTime),
          icon: Icons.schedule,
        ),
        SizedBox(height: TossSpacing.space2),
        // Payment Time row (confirmed times for payroll)
        _buildTimeRow(
          label: 'Payment Time',
          startTime: _formatTimeDisplay(confirmStartTime),
          endTime: _formatTimeDisplay(confirmEndTime),
          icon: Icons.payments_outlined,
          highlight: true,
        ),
      ],
    );
  }

  /// timeRange에서 시작/종료 시간 추출 (예: "09:00 - 18:00")
  String _extractTime(String? range, {required bool isStart}) {
    if (range == null || !range.contains(' - ')) return '--:--';
    final parts = range.split(' - ');
    if (parts.length != 2) return '--:--';
    return isStart ? parts[0].trim() : parts[1].trim();
  }

  Widget _buildTimeRow({
    required String label,
    required String startTime,
    required String endTime,
    required IconData icon,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: highlight ? TossColors.primary : TossColors.gray500,
        ),
        SizedBox(width: TossSpacing.space2),
        Text(
          label,
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Spacer(),
        Text(
          '$startTime - $endTime',
          style: TossTextStyles.body.copyWith(
            fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
            color: highlight ? TossColors.primary : TossColors.gray900,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  String _formatTimeDisplay(String? time) {
    if (time == null || time.isEmpty) return '--:--';
    // Remove seconds if present (07:09:00 -> 07:09)
    if (time.length > 5 && time.contains(':')) {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    if (status == ShiftStatus.noShift) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header label
          Text(
            isUpcoming == true ? 'Next shift' : 'Current shift',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space1),

          // Shift name + Status badge in same row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  shiftType ?? 'Unknown Shift',
                  style: TossTextStyles.h2.copyWith(
                    fontSize: 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: _getBadgeColor(),
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Text(
                  _getStatusText(),
                  style: TossTextStyles.labelSmall.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space1),

          // Date and scheduled time in same row
          Row(
            children: [
              Text(
                date ?? 'No date',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              if (timeRange != null) ...[
                Text(
                  ' · ',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray400,
                  ),
                ),
                Text(
                  timeRange!,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: TossSpacing.space4),

          // Time section - different based on check-in status
          _buildTimeSection(),
          SizedBox(height: TossSpacing.space2),

          // Location row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              Text(
                location ?? 'No location',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),

          // Warning for undone status (shift started but not checked in)
          _buildUndoneWarning(),

          // Problem section (after check-in)
          _buildProblemSection(),

          // Check-in/Check-out button
          _buildActionButton(),
          SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }
}
