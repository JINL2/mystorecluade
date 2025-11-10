import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/shift_card_data.dart';
import '../utils/date_format_utils.dart';

/// Modal bottom sheet that displays full attendance history
///
/// Shows a scrollable list of all shift activities with:
/// - Month-based grouping
/// - Check-in/check-out times
/// - Hours worked calculation
/// - Approval and reported status badges
/// - Tap to view activity details
class AttendanceHistoryModal extends StatelessWidget {
  final List<ShiftCardData> allShiftCardsData;
  final Function(Map<String, dynamic>) onShowActivityDetails;

  const AttendanceHistoryModal({
    super.key,
    required this.allShiftCardsData,
    required this.onShowActivityDetails,
  });

  /// Shows the modal bottom sheet
  static void show({
    required BuildContext context,
    required List<ShiftCardData> allShiftCardsData,
    required Function(Map<String, dynamic>) onShowActivityDetails,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => AttendanceHistoryModal(
        allShiftCardsData: allShiftCardsData,
        onShowActivityDetails: onShowActivityDetails,
      ),
    );
  }

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
          // Handle bar - Toss style
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space2),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),

          // Header - Minimalist
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
                // Close button
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

          // History List - Clean Toss style
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              itemCount: allShiftCardsData.length,
              itemBuilder: (context, index) {
                final card = allShiftCardsData[index];
                return _buildActivityCard(context, card, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, ShiftCardData card, int index) {
    // Parse date
    final dateStr = card.requestDate;
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3
        ? DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2])
          )
        : DateTime.now();

    // Parse times and calculate duration
    final timeData = _parseTimeData(card);

    // Check if this is first item or if month changed
    final showMonthHeader = _shouldShowMonthHeader(index, date);
    final monthHeader = showMonthHeader ? '${DateFormatUtils.getMonthName(date.month)} ${date.year}' : '';

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

        // Activity Card - Clean Toss style
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
                // Create activity object and show details
                final activity = {
                  'date': date,
                  'checkIn': timeData['checkInTime'],
                  'checkOut': timeData['checkOutTime'],
                  'hours': timeData['hoursWorked'],
                  'store': card.storeId,
                  'status': card.actualEndTime != null ? 'completed' : 'in_progress',
                  'isApproved': card.isApproved,
                  'rawCard': card,
                };
                Navigator.pop(context); // Close bottom sheet
                onShowActivityDetails(activity);
                HapticFeedback.selectionClick();
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space3),
                child: Row(
                  children: [
                    // Date - Compact
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
                            DateFormatUtils.getWeekdayShort(date.weekday),
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
                          // Time display
                          Row(
                            children: [
                              Text(
                                timeData['checkInTime']!,
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: timeData['checkInTime'] == '--:--'
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
                                timeData['checkOutTime']!,
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: timeData['checkOutTime'] == '--:--'
                                      ? TossColors.gray400
                                      : TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Shift Name and Time
                          Text(
                            '${card.shiftId} • ${card.shiftTime}',
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
                        // Duration
                        Text(
                          timeData['hoursWorked']!,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Status badges
                        _buildStatusBadges(card.isApproved, card.isReported),
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

  Widget _buildStatusBadges(bool isApproved, bool isReported) {
    return Column(
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
                  color: isApproved ? TossColors.success : TossColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isApproved ? 'Approved' : 'Pending',
                style: TossTextStyles.caption.copyWith(
                  color: isApproved ? TossColors.success : TossColors.warning,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Reported status if applicable
        if (isReported) ...[
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
    );
  }

  /// Parse time data from ShiftCardData
  Map<String, String> _parseTimeData(ShiftCardData card) {
    String checkInTime = '--:--';
    String checkOutTime = '--:--';
    String hoursWorked = '0h 0m';

    final actualStart = card.actualStartTime;
    final actualEnd = card.actualEndTime;

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
              if (totalMinutes < 0) totalMinutes += 24 * 60; // Handle overnight shifts

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

    return {
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'hoursWorked': hoursWorked,
    };
  }

  /// Check if month header should be shown
  bool _shouldShowMonthHeader(int index, DateTime date) {
    if (index == 0) return true;

    final prevCard = allShiftCardsData[index - 1];
    final prevDateStr = prevCard.requestDate;
    final prevDateParts = prevDateStr.split('-');
    if (prevDateParts.length == 3) {
      final prevMonth = int.parse(prevDateParts[1].toString());
      if (prevMonth != date.month) {
        return true;
      }
    }
    return false;
  }
}
