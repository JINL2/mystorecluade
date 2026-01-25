import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../../domain/entities/shift_status.dart';

/// Status badge widget (On-time, In Progress, Late, Upcoming, etc.)
/// Extracted from today_shift_card.dart for better modularity
class ShiftStatusBadge extends StatelessWidget {
  final ShiftStatus status;

  const ShiftStatusBadge({
    super.key,
    required this.status,
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

  @override
  Widget build(BuildContext context) {
    if (status == ShiftStatus.noShift) {
      return const SizedBox.shrink();
    }

    return Container(
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
          fontWeight: TossFontWeight.semibold,
        ),
      ),
    );
  }
}
