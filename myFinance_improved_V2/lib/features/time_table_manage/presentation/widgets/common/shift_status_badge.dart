import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/value_objects/shift_status.dart';

/// Shift Status Badge
///
/// Displays status badge for shifts and shift requests
class ShiftStatusBadge extends StatelessWidget {
  final ShiftRequestStatus status;
  final bool compact;

  const ShiftStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final backgroundColor = _getBackgroundColor();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.displayName,
        style: (compact ? TossTextStyles.caption : TossTextStyles.body)
            .copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case ShiftRequestStatus.pending:
        return TossColors.warning;
      case ShiftRequestStatus.approved:
        return TossColors.success;
      case ShiftRequestStatus.rejected:
        return TossColors.error;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case ShiftRequestStatus.pending:
        return TossColors.warningLight;
      case ShiftRequestStatus.approved:
        return TossColors.successLight;
      case ShiftRequestStatus.rejected:
        return TossColors.errorLight;
    }
  }
}
