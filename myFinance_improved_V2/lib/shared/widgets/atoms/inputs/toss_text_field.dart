import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// TextField 스타일 종류
enum TossTextFieldStyle {
  /// 둥근 테두리 (기본)
  outline,

  /// 밑줄만
  underline,

  /// 테두리 없음 (inline row용)
  none,
}

class TossTextField extends StatelessWidget {
  final String? label;
  final Widget? labelWidget; // Custom label widget (overrides label if provided)
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon; // Icon displayed at the start of the input field
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
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
  final bool isRequired; // Show red asterisk for required fields

  // ✨ 새로 추가된 필드들
  final TossTextFieldStyle style; // 스타일 종류
  final bool filled; // 배경 채움
  final Color? fillColor; // 배경색
  final TextAlign textAlign; // 텍스트 정렬
  final String? inlineLabel; // InputDecoration.labelText용 (인라인 라벨)
  final String? errorText; // 에러 메시지 직접 표시
  final String? prefixText; // 접두 텍스트 (예: 통화 코드)
  final String? suffixText; // 접미 텍스트 (예: %)
  final bool autofocus; // 자동 포커스

  const TossTextField({
    super.key,
    this.label,
    this.labelWidget,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
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
    this.isRequired = false,
    // 새로 추가된 필드들
    this.style = TossTextFieldStyle.outline,
    this.filled = false,
    this.fillColor,
    this.textAlign = TextAlign.start,
    this.inlineLabel,
    this.errorText,
    this.prefixText,
    this.suffixText,
    this.autofocus = false,
  });

  /// Outline + Filled 스타일 (lc_form_page 등에서 사용)
  factory TossTextField.filled({
    Key? key,
    String? label,
    required String hintText,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    bool enabled = true,
    int? maxLines = 1,
    bool isRequired = false,
    String? inlineLabel,
    String? errorText,
    String? prefixText,
    String? suffixText,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    TextInputAction? textInputAction,
    bool autocorrect = true,
    bool autofocus = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TossTextField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      keyboardType: keyboardType,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      maxLines: maxLines,
      isRequired: isRequired,
      inlineLabel: inlineLabel,
      errorText: errorText,
      prefixText: prefixText,
      suffixText: suffixText,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      textInputAction: textInputAction,
      autocorrect: autocorrect,
      autofocus: autofocus,
      style: TossTextFieldStyle.outline,
      filled: true,
      fillColor: TossColors.gray50,
    );
  }

  /// Underline 스타일 (text_edit_sheet 등에서 사용)
  factory TossTextField.underline({
    Key? key,
    String? label,
    required String hintText,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    bool enabled = true,
    int? maxLines = 1,
    int? minLines,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    TextStyle? labelStyle,
  }) {
    return TossTextField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      keyboardType: keyboardType,
      suffixIcon: suffixIcon,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      textAlign: textAlign,
      autofocus: autofocus,
      focusNode: focusNode,
      textInputAction: textInputAction,
      labelStyle: labelStyle,
      style: TossTextFieldStyle.underline,
    );
  }

  /// Inline Row 스타일 (product_form 등에서 사용) - 테두리 없음
  factory TossTextField.inline({
    Key? key,
    required String hintText,
    TextEditingController? controller,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    bool enabled = true,
    TextAlign textAlign = TextAlign.end,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TossTextField(
      key: key,
      hintText: hintText,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      enabled: enabled,
      textAlign: textAlign,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      style: TossTextFieldStyle.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom labelWidget takes priority, then label with optional isRequired asterisk
        if (labelWidget != null) ...[
          labelWidget!,
          const SizedBox(height: TossSpacing.space2),
        ] else if (label != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label!,
                style: labelStyle ??
                    TossTextStyles.label.copyWith(
                      color: TossColors.gray700,
                      fontWeight: isImportant ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 2),
                Text(
                  '*',
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
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
          minLines: minLines,
          autocorrect: autocorrect,
          focusNode: focusNode,
          autofocus: autofocus,
          textAlign: textAlign,
          textInputAction: textInputAction ?? TextInputAction.done,
          onFieldSubmitted: onFieldSubmitted ??
              ((value) {
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
          decoration: _buildInputDecoration(),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    final effectiveFillColor = fillColor ?? TossColors.gray50;

    // 스타일에 따른 border 생성
    InputBorder border;
    InputBorder enabledBorder;
    InputBorder focusedBorder;
    InputBorder errorBorder;
    InputBorder focusedErrorBorder;
    InputBorder disabledBorder;

    switch (style) {
      case TossTextFieldStyle.outline:
        border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: BorderSide(
            color: filled ? TossColors.gray300 : TossColors.gray100,
            width: 1,
          ),
        );
        enabledBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: BorderSide(
            color: filled ? TossColors.gray300 : TossColors.gray100,
            width: 1,
          ),
        );
        focusedBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: const BorderSide(
            color: TossColors.primary,
            width: 1,
          ),
        );
        errorBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: const BorderSide(
            color: TossColors.error,
            width: 1,
          ),
        );
        focusedErrorBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: const BorderSide(
            color: TossColors.error,
            width: 1,
          ),
        );
        disabledBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          borderSide: const BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        );

      case TossTextFieldStyle.underline:
        border = const UnderlineInputBorder(
          borderSide: BorderSide(color: TossColors.gray300, width: 2),
        );
        enabledBorder = const UnderlineInputBorder(
          borderSide: BorderSide(color: TossColors.gray300, width: 2),
        );
        focusedBorder = const UnderlineInputBorder(
          borderSide: BorderSide(color: TossColors.primary, width: 2),
        );
        errorBorder = const UnderlineInputBorder(
          borderSide: BorderSide(color: TossColors.error, width: 2),
        );
        focusedErrorBorder = const UnderlineInputBorder(
          borderSide: BorderSide(color: TossColors.error, width: 2),
        );
        disabledBorder = const UnderlineInputBorder(
          borderSide: BorderSide(color: TossColors.gray200, width: 2),
        );

      case TossTextFieldStyle.none:
        border = InputBorder.none;
        enabledBorder = InputBorder.none;
        focusedBorder = InputBorder.none;
        errorBorder = InputBorder.none;
        focusedErrorBorder = InputBorder.none;
        disabledBorder = InputBorder.none;
    }

    return InputDecoration(
      hintText: hintText,
      hintStyle: TossTextStyles.body.copyWith(
        color: TossColors.gray400,
      ),
      labelText: inlineLabel,
      labelStyle: TossTextStyles.body.copyWith(
        color: TossColors.gray600,
      ),
      floatingLabelStyle: TossTextStyles.caption.copyWith(
        color: TossColors.primary,
      ),
      filled: filled,
      fillColor: filled ? effectiveFillColor : null,
      border: border,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      disabledBorder: disabledBorder,
      contentPadding: _getContentPadding(),
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      prefixStyle: TossTextStyles.body.copyWith(
        color: TossColors.gray600,
      ),
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      suffixStyle: TossTextStyles.body.copyWith(
        color: TossColors.gray600,
      ),
      errorText: errorText,
      errorStyle: TossTextStyles.caption.copyWith(
        color: TossColors.error,
      ),
    );
  }

  EdgeInsets _getContentPadding() {
    switch (style) {
      case TossTextFieldStyle.outline:
        return EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: (maxLines ?? 1) > 1 ? TossSpacing.space4 : TossSpacing.space3,
        );
      case TossTextFieldStyle.underline:
        return const EdgeInsets.only(
          bottom: TossSpacing.space2,
        );
      case TossTextFieldStyle.none:
        return EdgeInsets.zero;
    }
  }
}
