import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/monthly_attendance.dart';

/// 선택된 날짜의 출퇴근 상세 정보 (심플 버전)
class MonthlyDayDetail extends StatelessWidget {
  final DateTime selectedDate;
  final MonthlyAttendance? attendance;

  const MonthlyDayDetail({
    super.key,
    required this.selectedDate,
    this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    if (attendance == null) {
      return _buildNoDataContent();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status row
          Row(
            children: [
              Text(
                _getStatusText(),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(),
                ),
              ),
              const Spacer(),
              if (attendance!.isLate)
                _buildBadge('Late', TossColors.warning),
              if (attendance!.isEarlyLeave) ...[
                if (attendance!.isLate) const SizedBox(width: 4),
                _buildBadge('Early', TossColors.warning),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Scheduled time (V3: UTC → Local 변환)
          _buildInfoRow(
            'Scheduled',
            _getScheduledTimeRange(),
          ),

          // Actual check-in
          if (attendance!.checkInTimeUtc != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              'Check-in',
              _formatTime(attendance!.checkInTimeUtc!.toLocal()),
              valueColor: attendance!.isLate ? TossColors.error : TossColors.success,
            ),
          ],

          // Actual check-out
          if (attendance!.checkOutTimeUtc != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              'Check-out',
              _formatTime(attendance!.checkOutTimeUtc!.toLocal()),
              valueColor: attendance!.isEarlyLeave ? TossColors.warning : TossColors.success,
            ),
          ],

          // Notes
          if (attendance!.notes != null && attendance!.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              attendance!.notes!,
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
        ),
        const Spacer(),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: valueColor ?? TossColors.gray900,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TossTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNoDataContent() {
    final isFuture = selectedDate.isAfter(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Center(
        child: Text(
          isFuture ? 'Scheduled work day' : 'No record',
          style: TossTextStyles.body.copyWith(color: TossColors.gray500),
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (attendance!.status) {
      case 'completed':
        return 'Completed';
      case 'checked_in':
        return 'Working';
      case 'absent':
        return 'Absent';
      case 'day_off':
        return 'Day Off';
      default:
        return 'Scheduled';
    }
  }

  Color _getStatusColor() {
    switch (attendance!.status) {
      case 'completed':
        return TossColors.primary;
      case 'checked_in':
        return TossColors.success;
      case 'absent':
        return TossColors.error;
      case 'day_off':
        return TossColors.gray500;
      default:
        return TossColors.gray600;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// V3: UTC DateTime을 로컬 시간으로 변환하여 시간 범위 표시
  String _getScheduledTimeRange() {
    final startLocal = attendance?.scheduledStartTimeUtc?.toLocal();
    final endLocal = attendance?.scheduledEndTimeUtc?.toLocal();

    final startStr = startLocal != null ? _formatTime(startLocal) : '09:00';
    final endStr = endLocal != null ? _formatTime(endLocal) : '18:00';

    return '$startStr - $endStr';
  }
}
