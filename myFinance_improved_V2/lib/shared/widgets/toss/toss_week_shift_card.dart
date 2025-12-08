import 'package:flutter/material.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';
import '../../themes/toss_border_radius.dart';
import '../../themes/toss_spacing.dart';

enum ShiftCardStatus {
  upcoming,    // No left border
  inProgress,  // Green left border
  completed,   // No left border  
  late,        // Red left border
  onTime,      // Green badge text
  undone,      // Gray badge text
}

class TossWeekShiftCard extends StatelessWidget {
  final String date;
  final String shiftType;
  final String timeRange;
  final ShiftCardStatus status;
  final VoidCallback? onTap;
  final bool isClosestUpcoming; // Blue border for closest upcoming shift

  const TossWeekShiftCard({
    super.key,
    required this.date,
    required this.shiftType,
    required this.timeRange,
    required this.status,
    this.onTap,
    this.isClosestUpcoming = false,
  });

  Color? _getLeftBorderColor() {
    // No left border for any status
    return null;
  }

  String? _getStatusText() {
    switch (status) {
      case ShiftCardStatus.onTime:
        return 'On-time';
      case ShiftCardStatus.late:
        return 'Late';
      case ShiftCardStatus.undone:
        return 'Undone';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final leftBorderColor = _getLeftBorderColor();
    final statusText = _getStatusText();

    // Determine border style
    BoxBorder border;
    if (isClosestUpcoming) {
      // Blue border for closest upcoming shift
      border = Border.all(color: TossColors.primary, width: 1);
    } else if (leftBorderColor != null) {
      // Left border for late/in-progress shifts
      border = Border(left: BorderSide(color: leftBorderColor, width: 4));
    } else {
      // Default gray border
      border = Border.all(color: TossColors.gray200, width: 1);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: border,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: Date and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TossTextStyles.body.copyWith(
                    fontSize: 13,
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  timeRange,
                  style: TossTextStyles.body.copyWith(
                    fontSize: 13,
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space1),
            // Second row: Shift type and status
            Row(
              children: [
                Text(
                  shiftType,
                  style: TossTextStyles.body.copyWith(
                    fontSize: 13,
                    color: TossColors.gray600,
                  ),
                ),
                if (statusText != null) ...[
                  Text(' • ', style: TossTextStyles.body.copyWith(fontSize: 13, color: TossColors.gray400)),
                  Text(
                    statusText,
                    style: TossTextStyles.body.copyWith(
                      fontSize: 13,
                      color: status == ShiftCardStatus.onTime
                          ? TossColors.success
                          : status == ShiftCardStatus.late
                              ? TossColors.error
                              : TossColors.gray600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
