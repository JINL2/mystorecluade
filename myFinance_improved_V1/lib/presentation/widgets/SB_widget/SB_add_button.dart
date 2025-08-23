import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// SB Add Button Component
/// A reusable add button typically used in app bars or floating action buttons
class SBAddButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool showIcon;
  final IconData? icon;
  final Color? textColor;
  final Color? backgroundColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;

  const SBAddButton({
    super.key,
    this.text = 'Add',
    this.onPressed,
    this.showIcon = false,
    this.icon = Icons.add,
    this.textColor,
    this.backgroundColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(TossBorderRadius.sm),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? TossColors.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showIcon) ...[
                      Icon(
                        icon,
                        size: 18,
                        color: textColor ?? TossColors.primary,
                      ),
                      SizedBox(width: TossSpacing.space1),
                    ],
                    Text(
                      text,
                      style: TossTextStyles.labelLarge.copyWith(
                        color: textColor ?? TossColors.primary,
                        fontSize: fontSize ?? 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// SB Add Button Builder
/// Helper class to create different variations of the add button
class SBAddButtonBuilder {
  
  /// Text-only add button (default style)
  static Widget text({
    String text = 'Add',
    VoidCallback? onPressed,
    Color? textColor,
  }) {
    return SBAddButton(
      text: text,
      onPressed: onPressed,
      textColor: textColor,
      showIcon: false,
    );
  }
  
  /// Add button with icon
  static Widget withIcon({
    String text = 'Add',
    VoidCallback? onPressed,
    IconData icon = Icons.add,
    Color? textColor,
  }) {
    return SBAddButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      textColor: textColor,
      showIcon: true,
    );
  }
  
  /// Primary style add button (filled background)
  static Widget primary({
    String text = 'Add',
    VoidCallback? onPressed,
    bool showIcon = false,
    IconData icon = Icons.add,
    bool isLoading = false,
  }) {
    return SBAddButton(
      text: text,
      onPressed: onPressed,
      showIcon: showIcon,
      icon: icon,
      textColor: TossColors.white,
      backgroundColor: TossColors.primary,
      isLoading: isLoading,
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
    );
  }
  
  /// Secondary style add button (outlined)
  static Widget secondary({
    String text = 'Add',
    VoidCallback? onPressed,
    bool showIcon = false,
    IconData icon = Icons.add,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: TossColors.primary,
          width: 1,
        ),
      ),
      child: SBAddButton(
        text: text,
        onPressed: onPressed,
        showIcon: showIcon,
        icon: icon,
        textColor: TossColors.primary,
        backgroundColor: Colors.transparent,
      ),
    );
  }
  
  /// Floating action button style
  static Widget fab({
    VoidCallback? onPressed,
    IconData icon = Icons.add,
    bool mini = false,
  }) {
    return Container(
      width: mini ? 40 : 56,
      height: mini ? 40 : 56,
      decoration: BoxDecoration(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(mini ? 20 : 28),
        boxShadow: [
          BoxShadow(
            color: TossColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(mini ? 20 : 28),
          child: Center(
            child: Icon(
              icon,
              color: TossColors.white,
              size: mini ? 20 : 24,
            ),
          ),
        ),
      ),
    );
  }
  
  /// Custom style add button
  static Widget custom({
    required String text,
    VoidCallback? onPressed,
    bool showIcon = false,
    IconData? icon,
    Color? textColor,
    Color? backgroundColor,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    bool isLoading = false,
  }) {
    return SBAddButton(
      text: text,
      onPressed: onPressed,
      showIcon: showIcon,
      icon: icon,
      textColor: textColor,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      padding: padding,
      borderRadius: borderRadius,
      isLoading: isLoading,
    );
  }
}