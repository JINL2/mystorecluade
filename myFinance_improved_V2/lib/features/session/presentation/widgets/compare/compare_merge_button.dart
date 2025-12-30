import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Fixed bottom merge button for session compare page
class CompareMergeButton extends StatelessWidget {
  final bool isMerging;
  final VoidCallback? onMerge;

  const CompareMergeButton({
    super.key,
    required this.isMerging,
    this.onMerge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isMerging ? null : onMerge,
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
              disabledBackgroundColor: TossColors.gray300,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
            ),
            child: isMerging
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TossColors.white,
                    ),
                  )
                : Text(
                    'Merge',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
