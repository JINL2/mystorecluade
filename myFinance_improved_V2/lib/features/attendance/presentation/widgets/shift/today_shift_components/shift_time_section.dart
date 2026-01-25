import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../../domain/entities/shift_status.dart';

/// Time section showing scheduled time before check-in,
/// Real Time & Payment Time after check-in
/// Extracted from today_shift_card.dart for better modularity
class ShiftTimeSection extends StatelessWidget {
  final ShiftStatus status;
  final String? timeRange;
  final String? actualStartTime;
  final String? actualEndTime;
  final String? confirmStartTime;
  final String? confirmEndTime;

  /// V3: Monthly 직원은 Payment Time 불필요 (월급제라 시급 계산 없음)
  /// true: Hourly - Real Time + Payment Time 표시
  /// false: Monthly - Schedule Time + Real Time만 표시
  final bool showPaymentTime;

  const ShiftTimeSection({
    super.key,
    required this.status,
    this.timeRange,
    this.actualStartTime,
    this.actualEndTime,
    this.confirmStartTime,
    this.confirmEndTime,
    this.showPaymentTime = true,
  });

  /// timeRange에서 시작/종료 시간 추출 (예: "09:00 - 18:00")
  String _extractTime(String? range, {required bool isStart}) {
    if (range == null || !range.contains(' - ')) return '--:--';
    final parts = range.split(' - ');
    if (parts.length != 2) return '--:--';
    return isStart ? parts[0].trim() : parts[1].trim();
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
              fontWeight: TossFontWeight.semibold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      );
    }

    // After check-in: show time comparison
    // V3: Monthly (showPaymentTime=false) -> Schedule Time + Real Time
    //     Hourly  (showPaymentTime=true)  -> Real Time + Payment Time
    if (!showPaymentTime) {
      // Monthly: Schedule Time + Real Time (no payment calculation needed)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Schedule Time row (예정 시간)
          _ShiftTimeRow(
            label: 'Schedule',
            startTime: _extractTime(timeRange, isStart: true),
            endTime: _extractTime(timeRange, isStart: false),
            icon: Icons.event_note_outlined,
          ),
          SizedBox(height: TossSpacing.space2),
          // Real Time row (실제 체크인/아웃 시간)
          _ShiftTimeRow(
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
        _ShiftTimeRow(
          label: 'Real Time',
          startTime: _formatTimeDisplay(actualStartTime),
          endTime: _formatTimeDisplay(actualEndTime),
          icon: Icons.schedule,
        ),
        SizedBox(height: TossSpacing.space2),
        // Payment Time row (confirmed times for payroll)
        _ShiftTimeRow(
          label: 'Payment Time',
          startTime: _formatTimeDisplay(confirmStartTime),
          endTime: _formatTimeDisplay(confirmEndTime),
          icon: Icons.payments_outlined,
          highlight: true,
        ),
      ],
    );
  }
}

/// Time row widget
class _ShiftTimeRow extends StatelessWidget {
  final String label;
  final String startTime;
  final String endTime;
  final IconData icon;
  final bool highlight;

  const _ShiftTimeRow({
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: TossSpacing.iconSM2,
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
            fontWeight:
                highlight ? TossFontWeight.semibold : TossFontWeight.medium,
            color: highlight ? TossColors.primary : TossColors.gray900,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
