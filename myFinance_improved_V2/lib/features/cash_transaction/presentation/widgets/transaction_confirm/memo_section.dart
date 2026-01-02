import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
    return TossTextField.filled(
      label: 'Memo (Optional)',
      controller: controller,
      focusNode: focusNode,
      maxLines: 2,
      hintText: 'Add a note for this transaction...',
    );
  }
}
