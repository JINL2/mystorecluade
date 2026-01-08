import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Status badge for shift cards
/// Uses TossStatusBadge from shared widgets with shift-specific status mappings
/// Extracted from MyScheduleTab._buildStatusBadge
class ScheduleStatusBadge extends StatelessWidget {
  final ShiftCardStatus status;

  const ScheduleStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (status) {
      ShiftCardStatus.upcoming => ('Upcoming', TossColors.primary),
      ShiftCardStatus.inProgress => ('In Progress', TossColors.success),
      ShiftCardStatus.completed => ('Completed', TossColors.gray500),
      ShiftCardStatus.late => ('Late', TossColors.error),
      ShiftCardStatus.onTime => ('On-time', TossColors.success),
      ShiftCardStatus.undone => ('Undone', TossColors.gray500),
      ShiftCardStatus.absent => ('Absent', TossColors.error),
      ShiftCardStatus.noCheckout => ('No Checkout', TossColors.error),
      ShiftCardStatus.earlyLeave => ('Early Leave', TossColors.error),
      ShiftCardStatus.reported => ('Reported', TossColors.warning),
      ShiftCardStatus.resolved => ('Resolved', TossColors.success),
    };

    // Chip style with solid fill background and white text
    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2 + TossSpacing.space1 / 2, vertical: TossSpacing.space1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Text(
        label,
        style: TossTextStyles.labelSmall.copyWith(
          color: TossColors.white,
          fontWeight: TossFontWeight.semibold,
        ),
      ),
    );
  }
}
