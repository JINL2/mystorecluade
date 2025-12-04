import 'package:flutter/material.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';
import '../../themes/toss_border_radius.dart';
import '../../themes/toss_spacing.dart';

/// ShiftStatus enum - Defines the status of a shift
enum ShiftStatus {
  upcoming,    // Blue - not started yet
  inProgress,  // Green - currently working
  completed,   // Gray - shift finished
  noShift,     // No shift today
  onTime,      // Green badge - "On-time"
  late,        // Red badge - "Late"
  undone,      // Gray badge - "Undone"
}

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
class TossTodayShiftCard extends StatelessWidget {
  final String? shiftType;
  final String? date;
  final String? timeRange;
  final String? location;
  final ShiftStatus status;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final bool isLoading;
  final bool? isUpcoming;

  const TossTodayShiftCard({
    super.key,
    this.shiftType,
    this.date,
    this.timeRange,
    this.location,
    required this.status,
    this.onCheckIn,
    this.onCheckOut,
    this.isLoading = false,
    this.isUpcoming,
  });

  Color _getBadgeColor() {
    switch (status) {
      case ShiftStatus.onTime:
      case ShiftStatus.inProgress:
        return TossColors.success;
      case ShiftStatus.late:
        return TossColors.error;
      case ShiftStatus.upcoming:
        return TossColors.primary;
      case ShiftStatus.undone:
      case ShiftStatus.completed:
        return TossColors.gray400;
      case ShiftStatus.noShift:
        return TossColors.gray300;
    }
  }

  String _getStatusText() {
    switch (status) {
      case ShiftStatus.onTime:
        return 'On-time';
      case ShiftStatus.inProgress:
        return 'In Progress';
      case ShiftStatus.late:
        return 'Late';
      case ShiftStatus.upcoming:
        return 'Upcoming';
      case ShiftStatus.undone:
        return 'Undone';
      case ShiftStatus.completed:
        return 'Completed';
      case ShiftStatus.noShift:
        return '';
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space6),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: TossColors.gray400,
              size: 48,
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'You have no shift',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space1),
            Text(
              'Go to shift sign up',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (status == ShiftStatus.noShift) {
      return const SizedBox.shrink();
    }

    String buttonText;
    IconData buttonIcon;
    VoidCallback? onPressed;

    switch (status) {
      case ShiftStatus.upcoming:
      case ShiftStatus.onTime:
      case ShiftStatus.undone:
        buttonText = 'Check-in';
        buttonIcon = Icons.login;
        onPressed = onCheckIn;
        break;
      case ShiftStatus.inProgress:
        buttonText = 'Check-out';
        buttonIcon = Icons.logout;
        onPressed = onCheckOut;
        break;
      case ShiftStatus.completed:
      case ShiftStatus.late:
        buttonText = 'Check-in';
        buttonIcon = Icons.login;
        onPressed = onCheckIn;
        break;
      case ShiftStatus.noShift:
        return const SizedBox.shrink();
    }

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          foregroundColor: TossColors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(buttonIcon, size: 20),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    buttonText,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (status == ShiftStatus.noShift) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's shift",
                style: TossTextStyles.label.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: _getBadgeColor(),
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Text(
                  _getStatusText(),
                  style: TossTextStyles.labelSmall.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),

          // Shift type
          Text(
            shiftType ?? 'Unknown Shift',
            style: TossTextStyles.h2.copyWith(
              fontSize: 22,
            ),
          ),
          SizedBox(height: TossSpacing.space1),

          // Date
          Text(
            date ?? 'No date',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space4),

          // Time row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              Text(
                timeRange ?? 'No time',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),

          // Check-in button
          _buildActionButton(),
        ],
      ),
    );
  }
}
