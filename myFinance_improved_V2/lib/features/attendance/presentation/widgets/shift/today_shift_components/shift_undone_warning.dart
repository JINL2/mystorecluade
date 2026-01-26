import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../../domain/entities/shift_status.dart';

/// Warning banner for undone status (shift started but not checked in)
/// Extracted from today_shift_card.dart for better modularity
class ShiftUndoneWarning extends StatelessWidget {
  final ShiftStatus status;

  const ShiftUndoneWarning({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status != ShiftStatus.undone) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space4),
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.error.withValues(alpha: TossOpacity.light),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
            color: TossColors.error.withValues(alpha: TossOpacity.heavy)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: TossColors.error,
            size: TossSpacing.iconMD,
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              "You haven't checked in yet!",
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: TossFontWeight.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
