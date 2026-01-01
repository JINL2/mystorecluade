import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Step 1: Business Name Input
///
/// First step in the create business flow where user enters the business name.
class Step1BusinessName extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const Step1BusinessName({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's your business name?",
          style: TossTextStyles.h1.copyWith(
            fontWeight: FontWeight.w800,
            color: TossColors.textPrimary,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'This will be the name of your company in Storebase',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space8),
        _buildBusinessNameField(),
      ],
    );
  }

  Widget _buildBusinessNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Business Name',
              style: TossTextStyles.label.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: controller,
          focusNode: focusNode,
          hintText: 'Enter your business name',
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => nextFocusNode?.requestFocus(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your business name';
            }
            return null;
          },
        ),
      ],
    );
  }
}
