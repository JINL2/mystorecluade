import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/employee_monthly_detail.dart';

/// Attendance card widget - uses real EmployeeShiftRecord
class AttendanceCard extends StatelessWidget {
  final EmployeeShiftRecord shift;

  const AttendanceCard({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = shift.isProblemSolved;
    final clockIn = shift.displayClockIn;
    final clockOut = shift.displayClockOut;
    final workedHoursText = shift.workedHours != null
        ? '${shift.workedHours!.toStringAsFixed(1)}h'
        : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: TossColors.gray100,
            ),
            child: Center(
              child: Text(
                '${shift.dayOfMonth ?? '-'}',
                style: TossTextStyles.small.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray700,
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shift.shiftName ?? 'Shift',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$workedHoursText · ',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: clockIn,
                        style: TossTextStyles.caption.copyWith(
                          color: clockIn == '--:--'
                              ? (isResolved ? TossColors.gray500 : TossColors.error)
                              : TossColors.gray600,
                        ),
                      ),
                      TextSpan(
                        text: ' – ',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      TextSpan(
                        text: clockOut,
                        style: TossTextStyles.caption.copyWith(
                          color: clockOut == '--:--'
                              ? (isResolved ? TossColors.gray500 : TossColors.error)
                              : TossColors.gray600,
                        ),
                      ),
                      TextSpan(
                        text: ' · ',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                      TextSpan(
                        text: shift.isApproved ? 'Confirmed' : 'Need Confirm',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          if (shift.issueType != null) ...[
            const SizedBox(width: TossSpacing.space2),
            IssueBadge(
              issueType: shift.issueType!,
              isResolved: isResolved,
            ),
          ],
        ],
      ),
    );
  }
}

/// Issue badge for attendance cards
class IssueBadge extends StatelessWidget {
  final ShiftIssueType issueType;
  final bool isResolved;

  const IssueBadge({
    super.key,
    required this.issueType,
    this.isResolved = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isResolved ? TossColors.gray400 : TossColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        issueType.label,
        style: TossTextStyles.small.copyWith(
          color: TossColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
