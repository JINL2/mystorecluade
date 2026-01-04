import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import 'section_title.dart';

/// Description input section with optional multi-line text field
///
/// Provides a text field for entering transaction descriptions.
class DescriptionInputSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onDone;

  const DescriptionInputSection({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Description (Optional)'),
        const SizedBox(height: TossSpacing.space2),
        TossEnhancedTextField(
          controller: controller,
          hintText: 'Enter description',
          maxLines: 2,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
            onDone?.call();
          },
          showKeyboardToolbar: true,
          keyboardDoneText: 'Done',
          onKeyboardDone: () => FocusScope.of(context).unfocus(),
          enableTapDismiss: false,
        ),
      ],
    );
  }
}
