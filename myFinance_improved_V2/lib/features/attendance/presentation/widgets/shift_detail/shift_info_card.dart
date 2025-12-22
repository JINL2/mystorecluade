import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';

import '../../../domain/entities/shift_card.dart';

/// Shift info card widget showing date, type, time, and status
class ShiftInfoCard extends StatelessWidget {
  final ShiftCard shift;

  const ShiftInfoCard({
    super.key,
    required this.shift,
  });

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, d MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }

  String _getStatusText() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime? shiftDate;
    try {
      shiftDate = DateTime.parse(shift.shiftStartTime);
      shiftDate = DateTime(shiftDate.year, shiftDate.month, shiftDate.day);
    } catch (e) {
      shiftDate = null;
    }

    if (shiftDate != null && shiftDate.isAfter(today)) {
      return 'Upcoming';
    }

    if (shift.actualStartTime != null && shift.actualEndTime == null) {
      return 'In Progress';
    }

    final pd = shift.problemDetails;
    if (pd != null && pd.problemCount > 0) {
      if (pd.hasReported) {
        final isResolved = pd.isSolved || shift.managerMemos.isNotEmpty;
        return isResolved ? 'Resolved' : 'Reported';
      }
      if (pd.hasAbsence) return 'Absent';
      if (pd.hasNoCheckout) return 'No Checkout';
      if (pd.hasEarlyLeave) return 'Early Leave';
      if (pd.hasLate) return 'Late';
    }

    if (shift.actualStartTime != null && shift.actualEndTime != null) {
      return 'On-time';
    }

    if (shiftDate != null && shiftDate.isBefore(today)) {
      return 'Undone';
    }

    return 'Upcoming';
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'on-time':
        backgroundColor = TossColors.success;
        textColor = TossColors.white;
        break;
      case 'late':
      case 'absent':
      case 'no checkout':
      case 'early leave':
        backgroundColor = TossColors.error;
        textColor = TossColors.white;
        break;
      case 'reported':
        backgroundColor = TossColors.warning;
        textColor = TossColors.white;
        break;
      case 'resolved':
        backgroundColor = TossColors.success;
        textColor = TossColors.white;
        break;
      case 'in progress':
        backgroundColor = TossColors.primary;
        textColor = TossColors.white;
        break;
      case 'upcoming':
        backgroundColor = TossColors.primarySurface;
        textColor = TossColors.primary;
        break;
      case 'undone':
        backgroundColor = TossColors.gray200;
        textColor = TossColors.gray600;
        break;
      default:
        backgroundColor = TossColors.gray100;
        textColor = TossColors.gray700;
    }

    return TossBadge(
      label: status,
      backgroundColor: backgroundColor,
      textColor: textColor,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(shift.requestDate),
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  shift.shiftName ?? 'Shift',
                  style: TossTextStyles.titleMedium.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_formatHours(shift.scheduledHours)} scheduled',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(_getStatusText()),
        ],
      ),
    );
  }
}
