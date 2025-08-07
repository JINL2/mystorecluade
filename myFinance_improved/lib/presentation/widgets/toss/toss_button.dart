// lib/presentation/widgets/toss/toss_button.dart

import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

class TossButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const TossButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? TossColors.gray100;
    final fgColor = textColor ?? TossColors.gray900;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled && !isLoading ? onPressed : null,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: isEnabled ? bgColor : TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: isEnabled ? bgColor : TossColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fgColor,
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
              ] else if (leadingIcon != null) ...[
                leadingIcon!,
                SizedBox(width: TossSpacing.space2),
              ],
              Text(
                text,
                style: TossTextStyles.labelLarge.copyWith(
                  color: isEnabled ? fgColor : TossColors.gray400,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (trailingIcon != null) ...[
                SizedBox(width: TossSpacing.space2),
                trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}