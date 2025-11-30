import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/shift_card.dart';
import '../helpers/format_helpers.dart';

/// Bottom sheet showing all attendance history
///
/// ✅ Clean Architecture: Uses ShiftCard Entity instead of Map<String, dynamic>
class AllAttendanceHistorySheet extends StatelessWidget {
  /// ✅ Clean Architecture: Use ShiftCard Entity list instead of Map list
  final List<ShiftCard> shiftCards;
  final void Function(ShiftCard) onActivityTap;

  const AllAttendanceHistorySheet({
    super.key,
    required this.shiftCards,
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
              itemCount: shiftCards.length,
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
    // ✅ Clean Architecture: Use ShiftCard Entity directly
    final card = shiftCards[index];

    // Parse date from Entity
    final dateStr = card.requestDate;
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3
        ? DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          )
        : DateTime.now();

    // ✅ Clean Architecture: Use Entity properties
    final actualStart = card.confirmStartTime;
    final actualEnd = card.confirmEndTime;
    String checkInTime = '--:--';
    String checkOutTime = '--:--';
    String hoursWorked = '0h 0m';

    if (actualStart != null && actualStart.isNotEmpty) {
      try {
        if (actualStart.contains(':')) {
          final timeParts = actualStart.split(':');
          if (timeParts.length >= 2) {
            checkInTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
          }
        }
      } catch (e) {
        checkInTime = '--:--';
      }
    }

    if (actualEnd != null && actualEnd.isNotEmpty) {
      try {
        if (actualEnd.contains(':')) {
          final timeParts = actualEnd.split(':');
          if (timeParts.length >= 2) {
            checkOutTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
          }
        }

        // Calculate hours worked
        if (actualStart != null) {
          try {
            final startParts = actualStart.split(':');
            final endParts = actualEnd.split(':');
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

    // ✅ Clean Architecture: Use Entity properties directly
    final isApproved = card.isApproved;
    final isReported = card.isReported;
    final shiftName = card.shiftName ?? 'Shift';
    final shiftTime = card.shiftTime;

    // Check if this is first item or if month changed
    bool showMonthHeader = false;
    String monthHeader = '';
    if (index == 0) {
      showMonthHeader = true;
      monthHeader = '${FormatHelpers.getMonthName(date.month)} ${date.year}';
    } else {
      final prevCard = shiftCards[index - 1];
      final prevDateStr = prevCard.requestDate;
      final prevDateParts = prevDateStr.split('-');
      if (prevDateParts.length == 3) {
        final prevMonth = int.parse(prevDateParts[1]);
        if (prevMonth != date.month) {
          showMonthHeader = true;
          monthHeader = '${FormatHelpers.getMonthName(date.month)} ${date.year}';
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
                Navigator.pop(context);
                // ✅ Clean Architecture: Pass Entity directly
                onActivityTap(card);
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
                            FormatHelpers.getWeekdayShort(date.weekday),
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
                                color: isApproved
                                    ? TossColors.success.withValues(alpha: 0.1)
                                    : TossColors.warning.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isApproved
                                          ? TossColors.success
                                          : TossColors.warning,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isApproved ? 'Approved' : 'Pending',
                                    style: TossTextStyles.caption.copyWith(
                                      color: isApproved
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
                            if (isReported) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space2,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.error.withValues(alpha: 0.1),
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
