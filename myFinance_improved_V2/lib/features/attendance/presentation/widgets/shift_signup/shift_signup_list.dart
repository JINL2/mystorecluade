import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/shift_metadata.dart';
import 'shift_signup_card.dart';

// Type aliases for better type inference
typedef ShiftStatusGetter = ShiftSignupStatus Function(ShiftMetadata);
typedef IntGetter = int Function(ShiftMetadata);
typedef BoolGetter = bool Function(ShiftMetadata);
typedef StringListGetter = List<String> Function(ShiftMetadata);
typedef TimeFormatter = String Function(String, String);
typedef ShiftCallback = void Function(ShiftMetadata);

/// ShiftSignupList
///
/// Displays list of available shifts for selected date
/// Shows "Available Shifts on {date}" header and shift cards
///
/// **Design:**
/// - Section header with date
/// - Empty state when no shifts
/// - Grid of shift cards using ShiftSignupCard component
/// - Follows Toss design system spacing and typography
class ShiftSignupList extends StatelessWidget {
  final DateTime selectedDate;
  final List<ShiftMetadata> shifts;
  final String storeName;
  final ShiftStatusGetter getShiftStatus;
  final IntGetter getFilledSlots;
  final IntGetter getAppliedCount;
  final BoolGetter getUserApplied;
  final StringListGetter getEmployeeAvatars;
  final TimeFormatter formatTimeRange;
  final ShiftCallback? onApply;
  final ShiftCallback? onWaitlist;
  final ShiftCallback? onLeaveWaitlist;
  final ShiftCallback? onWithdraw;
  final ShiftCallback? onShiftTap;
  final ShiftCallback? onViewAppliedUsers;

  const ShiftSignupList({
    super.key,
    required this.selectedDate,
    required this.shifts,
    required this.storeName,
    required this.getShiftStatus,
    required this.getFilledSlots,
    required this.getAppliedCount,
    required this.getUserApplied,
    required this.getEmployeeAvatars,
    required this.formatTimeRange,
    this.onApply,
    this.onWaitlist,
    this.onLeaveWaitlist,
    this.onWithdraw,
    this.onShiftTap,
    this.onViewAppliedUsers,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // "Available Shifts on {date}" header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              TossSpacing.space4,
              TossSpacing.space2,
              TossSpacing.space4,
              TossSpacing.space3,
            ),
            child: Text(
              'Available Shifts on ${DateFormat.MMMd().format(selectedDate)}',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),

        // Shift Cards List or Empty State
        if (shifts.isEmpty)
          SliverToBoxAdapter(
            child: _buildEmptyState(),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildShiftCard(shifts[index]),
                childCount: shifts.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(TossSpacing.space8),
      child: Center(
        child: Text(
          'No shifts available',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildShiftCard(ShiftMetadata shift) {
    final status = getShiftStatus(shift);
    final filledSlots = getFilledSlots(shift);
    final totalSlots = shift.numberShift ?? 3;
    final appliedCount = getAppliedCount(shift);
    final userApplied = getUserApplied(shift);
    final avatars = getEmployeeAvatars(shift);

    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space3),
      child: ShiftSignupCard(
        shiftType: shift.shiftName,
        timeRange: formatTimeRange(shift.startTime, shift.endTime),
        location: storeName,
        status: status,
        filledSlots: filledSlots,
        totalSlots: totalSlots,
        appliedCount: appliedCount,
        userApplied: userApplied,
        assignedUserAvatars: avatars.isNotEmpty ? avatars : null,
        onApply: status == ShiftSignupStatus.available && onApply != null
            ? () => onApply!(shift)
            : null,
        onWaitlist: status == ShiftSignupStatus.waitlist && onWaitlist != null
            ? () => onWaitlist!(shift)
            : null,
        onLeaveWaitlist: status == ShiftSignupStatus.onWaitlist &&
                onLeaveWaitlist != null
            ? () => onLeaveWaitlist!(shift)
            : null,
        onWithdraw: status == ShiftSignupStatus.applied && onWithdraw != null
            ? () => onWithdraw!(shift)
            : null,
        onTap: onShiftTap != null ? () => onShiftTap!(shift) : null,
        onViewAppliedUsers: (status == ShiftSignupStatus.assigned ||
                    appliedCount > 0 ||
                    userApplied) &&
                onViewAppliedUsers != null
            ? () => onViewAppliedUsers!(shift)
            : null,
      ),
    );
  }
}
