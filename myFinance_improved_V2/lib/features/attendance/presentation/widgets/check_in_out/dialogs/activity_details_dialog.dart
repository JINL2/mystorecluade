import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../utils/attendance_helper_methods.dart';

/// Show activity details dialog
Future<void> showActivityDetailsDialog({
  required BuildContext context,
  required Map<String, dynamic> activity,
  String? currencySymbol,
  required Future<void> Function(String shiftRequestId, Map<String, dynamic> cardData) onReportIssue,
}) async {
  // Get the raw card data which contains all the shift information
  final cardData = activity['rawCard'] as Map<String, dynamic>?;
  if (cardData == null) {
    return;
  }

  // Capture the root context for ScaffoldMessenger
  final rootContext = context;

  // Parse date for better display
  final dateStr = (cardData['request_date'] ?? '').toString();
  final dateParts = dateStr.split('-');
  final date = dateParts.length == 3
      ? DateTime(
          int.parse(dateParts[0].toString()),
          int.parse(dateParts[1].toString()),
          int.parse(dateParts[2].toString()),
        )
      : DateTime.now();

  // Get currency symbol
  final currency = currencySymbol ?? 'VND';

  // Parse shift time and convert from UTC to local time
  final rawShiftTime = (cardData['shift_time'] ?? '09:00 ~ 17:00').toString();
  final requestDate = cardData['request_date']?.toString();
  String shiftTime = AttendanceHelpers.formatShiftTime(rawShiftTime, requestDate: requestDate);

  await showModalBottomSheet(
    context: context,
    backgroundColor: TossColors.transparent,
    isScrollControlled: true,
    builder: (context) {
      // State variables for expandable sections
      bool isInfoExpanded = false;
      bool isActualAttendanceExpanded = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: const BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar - Toss style (thinner)
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: TossColors.gray200,
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                  ),
                ),

                // Title - Centered with better weight
                Text(
                  'Shift Details',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: TossSpacing.space5),

                // Content with scroll
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info Section Heading with expandable arrow
                        InkWell(
                          onTap: () {
                            setState(() {
                              isInfoExpanded = !isInfoExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
                            child: Row(
                              children: [
                                Text(
                                  'Info',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Icon(
                                  isInfoExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: TossColors.gray600,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Info section content (collapsible)
                        if (isInfoExpanded) ...[
                          const SizedBox(height: TossSpacing.space3),
                          // Basic Information Section - Clean rows without Store
                          _buildInfoRow('Date', '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
                          const SizedBox(height: TossSpacing.space4),

                          _buildInfoRow('Shift Time', shiftTime),
                          const SizedBox(height: TossSpacing.space4),

                          // Work Status with proper detection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                              Text(
                                AttendanceHelpers.getWorkStatusFromCard(cardData),
                                style: TossTextStyles.body.copyWith(
                                  color: AttendanceHelpers.getWorkStatusColorFromCard(cardData),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          // Late info if exists
                          if ((cardData['is_late'] == true) || ((cardData['late_minutes'] as num?) ?? 0) > 0) ...[
                            const SizedBox(height: TossSpacing.space4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Late',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.error,
                                  ),
                                ),
                                Text(
                                  '${cardData['late_minutes'] ?? 0} minutes',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],

                        const SizedBox(height: TossSpacing.space6),

                        // Actual Attendance Section Heading with expandable arrow
                        InkWell(
                          onTap: () {
                            setState(() {
                              isActualAttendanceExpanded = !isActualAttendanceExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
                            child: Row(
                              children: [
                                Text(
                                  'Actual Attendance',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Icon(
                                  isActualAttendanceExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: TossColors.gray600,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Actual Attendance section content (collapsible)
                        if (isActualAttendanceExpanded) ...[
                          const SizedBox(height: TossSpacing.space3),

                          _buildInfoRow('Actual Check-in', AttendanceHelpers.formatTime(cardData['actual_start_time'], requestDate: cardData['request_date']?.toString())),
                          const SizedBox(height: TossSpacing.space3),
                          _buildInfoRow('Actual Check-out', AttendanceHelpers.formatTime(cardData['actual_end_time'], requestDate: cardData['request_date']?.toString())),

                          const SizedBox(height: TossSpacing.space4),

                          // Hours Section
                          _buildInfoRow('Scheduled Hours', '${cardData['scheduled_hours'] ?? 0.0} hours'),
                          const SizedBox(height: TossSpacing.space3),
                          _buildInfoRow('Paid Hours', '${cardData['paid_hours'] ?? 0} hours'),

                          const SizedBox(height: TossSpacing.space4),

                          // Salary information
                          _buildInfoRow('Salary Type', (cardData['salary_type'] ?? 'hourly').toString()),
                          const SizedBox(height: TossSpacing.space3),
                          _buildInfoRow('Salary per Hour', '$currency${AttendanceHelpers.formatNumber(cardData['salary_amount'] ?? 0)}'),
                        ],

                        const SizedBox(height: TossSpacing.space6),

                        // Confirmed Attendance - Simpler design with light background (Always visible)
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          decoration: BoxDecoration(
                            color: TossColors.info.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confirmed Attendance',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: TossSpacing.space3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Check-in',
                                    style: TossTextStyles.bodySmall.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                  Text(
                                    AttendanceHelpers.formatTime(cardData['confirm_start_time'], requestDate: cardData['request_date']?.toString()),
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: TossSpacing.space2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Check-out',
                                    style: TossTextStyles.bodySmall.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                  Text(
                                    AttendanceHelpers.formatTime(cardData['confirm_end_time'], requestDate: cardData['request_date']?.toString()),
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: TossSpacing.space4),

                        // Base Pay and Bonus Amount in blue box
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          decoration: BoxDecoration(
                            color: TossColors.info.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Base Pay',
                                    style: TossTextStyles.bodySmall.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                  Text(
                                    '$currency${AttendanceHelpers.formatNumber(cardData['base_pay'] ?? 0)}',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: TossSpacing.space2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bonus Amount',
                                    style: TossTextStyles.bodySmall.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                  Text(
                                    '$currency${AttendanceHelpers.formatNumber(cardData['bonus_amount'] ?? 0)}',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: TossSpacing.space6),

                        // Divider
                        Container(
                          height: 1,
                          color: TossColors.gray100,
                        ),

                        const SizedBox(height: TossSpacing.space4),

                        // Total Pay - More prominent
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Pay',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$currency${AttendanceHelpers.formatNumber(cardData['total_pay_with_bonus'] ?? '0')}',
                              style: TossTextStyles.h2.copyWith(
                                color: TossColors.info,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: TossSpacing.space5),

                        // Show reported status if already reported
                        if (cardData['is_reported'] == true) ...[
                          Container(
                            padding: const EdgeInsets.all(TossSpacing.space4),
                            decoration: BoxDecoration(
                              color: TossColors.warning.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              border: Border.all(
                                color: TossColors.warning.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: TossColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: TossSpacing.space3),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Issue Reported',
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.warning,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        (cardData['is_problem_solved'] == true)
                                            ? 'Your report has been resolved'
                                            : 'Your report is being reviewed',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space5),
                        ],

                        // Report Issue Button - Toss style with better visibility
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: (cardData['is_reported'] == true) || (cardData['is_approved'] != true)
                                ? TossColors.gray50
                                : TossColors.background,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            border: Border.all(
                              color: (cardData['is_reported'] == true) || (cardData['is_approved'] != true)
                                  ? TossColors.gray100
                                  : TossColors.gray200,
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: TossColors.transparent,
                            child: InkWell(
                              onTap: (cardData['is_reported'] == true) || (cardData['is_approved'] != true)
                                  ? null // Disable if already reported OR not approved
                                  : () async {
                                      final shiftRequestId = cardData['shift_request_id'];
                                      if (shiftRequestId == null) {
                                        return;
                                      }

                                      HapticFeedback.selectionClick();

                                      // Show the report issue dialog
                                      await onReportIssue(shiftRequestId as String, cardData);
                                    },
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: TossSpacing.space3,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.flag_outlined,
                                      size: 20,
                                      color: (cardData['is_reported'] == true) || (cardData['is_approved'] != true)
                                          ? TossColors.gray300
                                          : TossColors.gray600,
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    Text(
                                      'Report Issue',
                                      style: TossTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: (cardData['is_reported'] == true) || (cardData['is_approved'] != true)
                                            ? TossColors.gray300
                                            : TossColors.gray700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Add safe area padding below Report Issue button
                        SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// Helper widget to build info rows
Widget _buildInfoRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray500,
        ),
      ),
      Text(
        value,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
