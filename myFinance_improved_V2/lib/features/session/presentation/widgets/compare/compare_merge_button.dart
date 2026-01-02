import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
        child: TossButton.primary(
          text: 'Merge',
          onPressed: isMerging ? null : onMerge,
          isLoading: isMerging,
          fullWidth: true,
          height: 52,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
