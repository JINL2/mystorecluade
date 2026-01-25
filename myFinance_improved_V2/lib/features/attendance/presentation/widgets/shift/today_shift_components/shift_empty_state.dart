import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Empty state widget when user has no shift
/// Extracted from today_shift_card.dart for better modularity
class ShiftEmptyState extends StatelessWidget {
  final VoidCallback? onGoToShiftSignUp;

  const ShiftEmptyState({
    super.key,
    this.onGoToShiftSignUp,
  });

  @override
  Widget build(BuildContext context) {
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
              size: TossSpacing.iconXXL,
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'You have no shift',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: TossFontWeight.semibold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space1),
            TossButton.textButton(
              text: 'Go to shift sign up',
              onPressed: onGoToShiftSignUp,
            ),
          ],
        ),
      ),
    );
  }
}
