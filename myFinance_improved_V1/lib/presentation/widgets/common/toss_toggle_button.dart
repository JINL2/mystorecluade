import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Toggle button widget for binary choices
class TossToggleButton extends StatelessWidget {
  final String label;
  final String value;
  final String? selectedValue;
  final ValueChanged<String> onPressed;
  final Color? activeColor;
  final Color? activeTextColor;
  final bool enableHaptic;
  final IconData? icon;
  final bool expand;

  const TossToggleButton({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onPressed,
    this.activeColor,
    this.activeTextColor,
    this.enableHaptic = true,
    this.icon,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    
    Widget button = GestureDetector(
      onTap: () {
        if (enableHaptic) {
          HapticFeedback.selectionClick();
        }
        onPressed(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space4,
          horizontal: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (activeColor ?? TossColors.primary)
              : TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected
                ? (activeColor ?? TossColors.primary)
                : TossColors.gray300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? (activeTextColor ?? TossColors.white)
                    : TossColors.gray600,
              ),
              const SizedBox(width: TossSpacing.space2),
            ],
            Text(
              label,
              style: TossTextStyles.bodyLarge.copyWith(
                color: isSelected
                    ? (activeTextColor ?? TossColors.white)
                    : TossColors.gray600,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

    return expand ? Expanded(child: button) : button;
  }
}

/// Toggle button group for multiple toggle buttons
class TossToggleButtonGroup extends StatelessWidget {
  final List<TossToggleButtonData> buttons;
  final String? selectedValue;
  final ValueChanged<String> onPressed;
  final Color? activeColor;
  final Color? activeTextColor;
  final bool enableHaptic;
  final double spacing;

  const TossToggleButtonGroup({
    super.key,
    required this.buttons,
    required this.selectedValue,
    required this.onPressed,
    this.activeColor,
    this.activeTextColor,
    this.enableHaptic = true,
    this.spacing = TossSpacing.space3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: buttons.map((button) {
        final index = buttons.indexOf(button);
        return [
          TossToggleButton(
            label: button.label,
            value: button.value,
            selectedValue: selectedValue,
            onPressed: onPressed,
            activeColor: button.activeColor ?? activeColor,
            activeTextColor: button.activeTextColor ?? activeTextColor,
            enableHaptic: enableHaptic,
            icon: button.icon,
            expand: true,
          ),
          if (index < buttons.length - 1) SizedBox(width: spacing),
        ];
      }).expand((element) => element).toList(),
    );
  }
}

/// Data class for toggle button
class TossToggleButtonData {
  final String label;
  final String value;
  final IconData? icon;
  final Color? activeColor;
  final Color? activeTextColor;

  const TossToggleButtonData({
    required this.label,
    required this.value,
    this.icon,
    this.activeColor,
    this.activeTextColor,
  });
}