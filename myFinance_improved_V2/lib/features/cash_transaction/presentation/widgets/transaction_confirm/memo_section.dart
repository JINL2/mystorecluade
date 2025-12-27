import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Memo Section Widget for transaction confirmation
class MemoSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const MemoSection({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Memo (Optional)',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: 2,
            minLines: 1,
            style: TossTextStyles.body.copyWith(color: TossColors.gray900),
            decoration: InputDecoration(
              hintText: 'Add a note for this transaction...',
              hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(TossSpacing.space3),
            ),
          ),
        ),
      ],
    );
  }
}
