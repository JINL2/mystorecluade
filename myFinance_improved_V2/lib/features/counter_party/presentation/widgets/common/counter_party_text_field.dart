import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Counter party feature specialized text field with prefix icon support
///
/// Used throughout counter party forms for consistent input styling.
/// Features:
/// - Prefix icon support (not available in TossTextField)
/// - Required field indicator
/// - Custom validation
/// - Consistent counter party form styling
class CounterPartyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool required;
  final String? Function(String?)? validator;

  const CounterPartyTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.required = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional required indicator
        Row(
          children: [
            Text(
              label,
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TossTextStyles.body.copyWith(color: TossColors.error),
              ),
            ],
          ],
        ),
        const SizedBox(height: TossSpacing.space2),

        // Text field with prefix icon
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: TossTextStyles.body.copyWith(color: TossColors.gray900),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TossTextStyles.body.copyWith(color: TossColors.gray400),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(icon, size: 20, color: TossColors.gray500),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: TossColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.gray200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.error, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
