import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/shift_card_status.dart';

// Re-export for backward compatibility
export '../../../domain/entities/shift_card_status.dart';

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
      case ShiftCardStatus.absent:
        return 'Absent';
      case ShiftCardStatus.noCheckout:
        return 'No Checkout';
      case ShiftCardStatus.earlyLeave:
        return 'Early Leave';
      case ShiftCardStatus.reported:
        return 'Reported';
      case ShiftCardStatus.resolved:
        return 'Resolved';
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

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space2 + TossSpacing.space0_5, horizontal: TossSpacing.space3),
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
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray900,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                  Text(
                    timeRange,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray900,
                      fontWeight: TossFontWeight.semibold,
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
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  if (statusText != null) ...[
                    Text(' • ', style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray400)),
                    Text(
                      statusText,
                      style: TossTextStyles.bodySmall.copyWith(
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
      ),
    );
  }
}
