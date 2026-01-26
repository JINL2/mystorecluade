import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/shift_problem_info.dart';
import '../../../domain/entities/shift_status.dart';
import 'today_shift_components/index.dart';

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
  final String? actualStartTime; // "07:09:00"
  final String? actualEndTime; // "17:30:00"
  final String? confirmStartTime; // "07:09"
  final String? confirmEndTime; // "17:30"

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

  @override
  Widget build(BuildContext context) {
    if (status == ShiftStatus.noShift) {
      return ShiftEmptyState(onGoToShiftSignUp: onGoToShiftSignUp);
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
                  style: TossTextStyles.h2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              // Status badge
              ShiftStatusBadge(status: status),
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
                  ' \u00b7 ',
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
          ShiftTimeSection(
            status: status,
            timeRange: timeRange,
            actualStartTime: actualStartTime,
            actualEndTime: actualEndTime,
            confirmStartTime: confirmStartTime,
            confirmEndTime: confirmEndTime,
            showPaymentTime: showPaymentTime,
          ),
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
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),

          // Warning for undone status (shift started but not checked in)
          ShiftUndoneWarning(status: status),

          // Problem section (after check-in)
          ShiftProblemSection(
            problemInfo: problemInfo,
            status: status,
            onReportIssue: onReportIssue,
          ),

          // Check-in/Check-out button
          ShiftActionButton(
            status: status,
            problemInfo: problemInfo,
            onCheckIn: onCheckIn,
            onCheckOut: onCheckOut,
            onReportIssue: onReportIssue,
            isLoading: isLoading,
          ),
          SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }
}
