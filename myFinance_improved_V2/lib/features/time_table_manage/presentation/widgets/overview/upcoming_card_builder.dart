import 'package:flutter/material.dart';

import '../../../domain/entities/daily_shift_data.dart';
import 'current_activity_card_builder.dart';
import 'shift_info_card.dart';

/// Builder for Upcoming shift card in Overview tab
class UpcomingCardBuilder extends StatelessWidget {
  final ShiftWithRequests? upcomingShift;

  const UpcomingCardBuilder({
    super.key,
    required this.upcomingShift,
  });

  @override
  Widget build(BuildContext context) {
    // If no upcoming shift, show placeholder
    if (upcomingShift == null) {
      return ShiftInfoCard(
        date: 'No upcoming shifts',
        shiftName: '-',
        timeRange: '-',
        type: ShiftCardType.upcoming,
        statusLabel: '0/0 assigned',
        statusType: ShiftStatusType.neutral,
        staffList: const [],
      );
    }

    final shift = upcomingShift!.shift;
    final approvedCount = upcomingShift!.approvedRequests.length;
    final targetCount = shift.targetCount;

    // Build staff list from approved requests
    final staffList = upcomingShift!.approvedRequests.map((req) => StaffMember(
      name: req.employee.userName,
      avatarUrl: req.employee.profileImage,
    )).toList();

    return ShiftInfoCard(
      date: OverviewCardHelpers.formatDate(shift.planStartTime),
      shiftName: shift.shiftName ?? 'Unnamed Shift',
      timeRange: OverviewCardHelpers.formatTimeRange(shift.planStartTime, shift.planEndTime),
      type: ShiftCardType.upcoming,
      statusLabel: '$approvedCount/$targetCount assigned',
      statusType: ShiftStatusType.neutral,
      staffList: staffList,
    );
  }
}
