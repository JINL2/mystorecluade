import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../utils/attendance_formatters.dart';

/// Bottom sheet showing all attendance history
class AllAttendanceHistorySheet extends StatelessWidget {
  final List<Map<String, dynamic>> allShiftCardsData;
  final void Function(Map<String, dynamic>) onActivityTap;

  const AllAttendanceHistorySheet({
    super.key,
    required this.allShiftCardsData,
    required this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space2),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space5,
              vertical: TossSpacing.space4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Activity',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(TossSpacing.space2),
                    decoration: const BoxDecoration(
                      color: TossColors.gray50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),

          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              itemCount: allShiftCardsData.length,
              itemBuilder: (context, index) {
                return _buildActivityCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, int index) {
    final card = allShiftCardsData[index];

    // Parse date
    final dateStr = (card['request_date'] ?? '').toString();
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3
        ? DateTime(
            int.parse(dateParts[0].toString()),
            int.parse(dateParts[1].toString()),
            int.parse(dateParts[2].toString()),
          )
        : DateTime.now();

    // Parse times
    final actualStart = card['confirm_start_time'];
    final actualEnd = card['confirm_end_time'];
    String checkInTime = '--:--';
    String checkOutTime = '--:--';
    String hoursWorked = '0h 0m';

    if (actualStart != null && actualStart.toString().isNotEmpty) {
      try {
        if (actualStart.toString().contains(':')) {
          final timeParts = actualStart.toString().split(':');
          if (timeParts.length >= 2) {
            checkInTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
          }
        }
      } catch (e) {
        checkInTime = '--:--';
      }
    }

    if (actualEnd != null && actualEnd.toString().isNotEmpty) {
      try {
        if (actualEnd.toString().contains(':')) {
          final timeParts = actualEnd.toString().split(':');
          if (timeParts.length >= 2) {
            checkOutTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
          }
        }

        // Calculate hours worked
        if (actualStart != null && actualEnd != null) {
          try {
            final startParts = actualStart.toString().split(':');
            final endParts = actualEnd.toString().split(':');
            if (startParts.length >= 2 && endParts.length >= 2) {
              final startHour = int.parse(startParts[0]);
              final startMin = int.parse(startParts[1]);
              final endHour = int.parse(endParts[0]);
              final endMin = int.parse(endParts[1]);

              var totalMinutes = (endHour * 60 + endMin) - (startHour * 60 + startMin);
              if (totalMinutes < 0) totalMinutes += 24 * 60;

              final hours = totalMinutes ~/ 60;
              final minutes = totalMinutes % 60;
              hoursWorked = '${hours}h ${minutes}m';
            }
          } catch (e) {
            // Keep default
          }
        }
      } catch (e) {
        checkOutTime = '--:--';
      }
    }

    final isApproved = card['is_approved'] ?? false;
    final isReported = card['is_reported'] ?? false;
    final shiftName = card['shift_name'] ?? 'Shift';
    final shiftTime = card['shift_time'] ?? '--:-- ~ --:--';

    // Check if this is first item or if month changed
    bool showMonthHeader = false;
    String monthHeader = '';
    if (index == 0) {
      showMonthHeader = true;
      monthHeader = '${AttendanceFormatters.getMonthName(date.month)} ${date.year}';
    } else {
      final prevCard = allShiftCardsData[index - 1];
      final prevDateStr = (prevCard['request_date'] ?? '').toString();
      final prevDateParts = prevDateStr.split('-');
      if (prevDateParts.length == 3) {
        final prevMonth = int.parse(prevDateParts[1].toString());
        if (prevMonth != date.month) {
          showMonthHeader = true;
          monthHeader = '${AttendanceFormatters.getMonthName(date.month)} ${date.year}';
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month header if needed
        if (showMonthHeader) ...[
          if (index > 0) const SizedBox(height: TossSpacing.space4),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space1,
              vertical: TossSpacing.space2,
            ),
            child: Text(
              monthHeader,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
        ],

        // Activity Card
        Container(
          margin: const EdgeInsets.only(bottom: TossSpacing.space2),
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: TossColors.gray100,
              width: 1,
            ),
          ),
          child: Material(
            color: TossColors.transparent,
            child: InkWell(
              onTap: () {
                final activity = {
                  'date': date,
                  'checkIn': checkInTime,
                  'checkOut': checkOutTime,
                  'hours': hoursWorked,
                  'store': card['store_name'] ?? 'Store',
                  'status': actualEnd != null ? 'completed' : 'in_progress',
                  'isApproved': isApproved,
                  'rawCard': card,
                };
                Navigator.pop(context);
                onActivityTap(activity);
                HapticFeedback.selectionClick();
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space3),
                child: Row(
                  children: [
                    // Date
                    SizedBox(
                      width: 44,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            date.day.toString(),
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            AttendanceFormatters.getWeekdayShort(date.weekday),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Vertical divider
                    Container(
                      height: 32,
                      width: 1,
                      color: TossColors.gray100,
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                    ),

                    // Time and Store
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                checkInTime,
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: checkInTime == '--:--'
                                      ? TossColors.gray400
                                      : TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' → ',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray400,
                                ),
                              ),
                              Text(
                                checkOutTime,
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: checkOutTime == '--:--'
                                      ? TossColors.gray400
                                      : TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$shiftName • $shiftTime',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Duration and status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          hoursWorked,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Approval status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (isApproved == true)
                                    ? TossColors.success.withOpacity(0.1)
                                    : TossColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: (isApproved == true)
                                          ? TossColors.success
                                          : TossColors.warning,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (isApproved == true) ? 'Approved' : 'Pending',
                                    style: TossTextStyles.caption.copyWith(
                                      color: (isApproved == true)
                                          ? TossColors.success
                                          : TossColors.warning,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Reported status
                            if (isReported == true) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space2,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.flag,
                                      size: 10,
                                      color: TossColors.error,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Reported',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.error,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
