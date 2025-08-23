import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Number input field with consistent styling
class TossNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextAlign textAlign;
  final double? height;
  final bool showBorder;
  final bool enabled;
  final FocusNode? focusNode;
  final String? prefix;
  final String? suffix;

  const TossNumberInput({
    super.key,
    required this.controller,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.textAlign = TextAlign.center,
    this.height = 48,
    this.showBorder = true,
    this.enabled = true,
    this.focusNode,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: enabled ? Colors.transparent : TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: showBorder
            ? Border.all(
                color: controller.text.isNotEmpty
                    ? TossColors.primary.withOpacity(0.3)
                    : TossColors.gray200,
              )
            : null,
      ),
      child: Row(
        children: [
          if (prefix != null)
            Padding(
              padding: const EdgeInsets.only(left: TossSpacing.space3),
              child: Text(
                prefix!,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: inputFormatters ??
                  [FilteringTextInputFormatter.digitsOnly],
              textAlign: textAlign,
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'JetBrains Mono',
              ),
              decoration: InputDecoration(
                hintText: hintText ?? '0',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray300,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space3),
              child: Text(
                suffix!,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}