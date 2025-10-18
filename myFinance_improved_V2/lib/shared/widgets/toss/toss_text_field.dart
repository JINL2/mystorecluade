import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';

class TossTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int? maxLines;
  final bool autocorrect;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool showKeyboardToolbar;
  final VoidCallback? onKeyboardDone;
  final VoidCallback? onKeyboardNext;
  final VoidCallback? onKeyboardPrevious;
  final String keyboardDoneText;
  final bool isImportant; // New field for important emphasis
  final TextStyle? labelStyle; // New field for custom label style

  const TossTextField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.autocorrect = true,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.showKeyboardToolbar = false,
    this.onKeyboardDone,
    this.onKeyboardNext,
    this.onKeyboardPrevious,
    this.keyboardDoneText = 'Done',
    this.isImportant = false,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: labelStyle ?? TossTextStyles.label.copyWith(
              color: TossColors.gray700,
              fontWeight: isImportant ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          autocorrect: autocorrect,
          focusNode: focusNode,
          textInputAction: textInputAction ?? TextInputAction.done,
          onFieldSubmitted: onFieldSubmitted ?? ((value) {
            if (onKeyboardDone != null) {
              onKeyboardDone!();
            } else {
              FocusScope.of(context).unfocus();
            }
          }),
          inputFormatters: inputFormatters,
          style: TossTextStyles.body.copyWith(
            color: enabled ? TossColors.gray900 : TossColors.gray500,
          ),
          cursorColor: TossColors.primary,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
            filled: true,
            fillColor: enabled ? TossColors.gray50 : TossColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide(
                color: TossColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide(
                color: TossColors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide(
                color: TossColors.error,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: maxLines! > 1 ? TossSpacing.space4 : TossSpacing.space4,
            ),
            suffixIcon: suffixIcon,
            errorStyle: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ),
      ],
    );
  }
}