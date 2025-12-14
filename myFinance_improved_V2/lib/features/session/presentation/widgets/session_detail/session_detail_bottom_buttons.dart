import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Bottom action buttons for session detail page
class SessionDetailBottomButtons extends StatelessWidget {
  final bool isOwner;
  final Color typeColor;
  final VoidCallback onSavePressed;
  final VoidCallback onNextPressed;

  const SessionDetailBottomButtons({
    super.key,
    required this.isOwner,
    required this.typeColor,
    required this.onSavePressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: isOwner ? _buildOwnerButtons() : _buildMemberButton(),
      ),
    );
  }

  Widget _buildOwnerButtons() {
    return Row(
      children: [
        // Save Button
        Expanded(
          child: OutlinedButton(
            onPressed: onSavePressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: TossColors.textPrimary,
              side: const BorderSide(color: TossColors.border),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Text(
              'Save',
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        // Next Button
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: typeColor,
              foregroundColor: TossColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              elevation: 0,
            ),
            child: Text(
              'Next',
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onSavePressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: TossColors.textPrimary,
          side: const BorderSide(color: TossColors.border),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
        child: Text(
          'Save',
          style: TossTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
