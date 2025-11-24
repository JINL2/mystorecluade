// lib/shared/widgets/common/total_display_box.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';
import '../../themes/toss_text_styles.dart';

/// Total display box widget
///
/// A reusable component for displaying label-value pairs, typically for totals and amounts.
///
/// Features:
/// - Customizable label and value text
/// - Optional background color
/// - Optional border
/// - Optional padding
/// - Automatic number formatting for amounts
/// - Currency symbol support
class TotalDisplayBox extends StatelessWidget {
  /// The label text to display on the left
  final String label;

  /// The value to display on the right (can be text or number)
  final String? value;

  /// The numeric amount to display (will be formatted with currency)
  final double? amount;

  /// Currency symbol to display with the amount (default: '₫')
  final String currencySymbol;

  /// Custom text style for the label
  final TextStyle? labelStyle;

  /// Custom text style for the value
  final TextStyle? valueStyle;

  /// Background color of the box
  final Color? backgroundColor;

  /// Border color of the box
  final Color? borderColor;

  /// Padding inside the box
  final EdgeInsetsGeometry? padding;

  /// Border radius of the box
  final double? borderRadius;

  /// Whether to show border (default: false)
  final bool showBorder;

  const TotalDisplayBox({
    super.key,
    required this.label,
    this.value,
    this.amount,
    this.currencySymbol = '₫',
    this.labelStyle,
    this.valueStyle,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
    this.showBorder = false,
  }) : assert(
          value != null || amount != null,
          'Either value or amount must be provided',
        );

  /// Factory constructor for amount display with default styling
  factory TotalDisplayBox.amount({
    required String label,
    required double amount,
    String currencySymbol = '₫',
    Color? backgroundColor,
    Color? borderColor,
    bool showBorder = false,
  }) {
    return TotalDisplayBox(
      label: label,
      amount: amount,
      currencySymbol: currencySymbol,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      showBorder: showBorder,
      labelStyle: TossTextStyles.body.copyWith(
        color: TossColors.gray700,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
      valueStyle: TossTextStyles.body.copyWith(
        color: TossColors.gray900,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    );
  }

  /// Factory constructor for text display
  factory TotalDisplayBox.text({
    required String label,
    required String value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    Color? backgroundColor,
    Color? borderColor,
    bool showBorder = false,
  }) {
    return TotalDisplayBox(
      label: label,
      value: value,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      showBorder: showBorder,
      labelStyle: labelStyle ??
          TossTextStyles.body.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
      valueStyle: valueStyle ??
          TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  /// Factory constructor for highlighted/emphasized display
  factory TotalDisplayBox.highlighted({
    required String label,
    double? amount,
    String? value,
    String currencySymbol = '₫',
  }) {
    return TotalDisplayBox(
      label: label,
      amount: amount,
      value: value,
      currencySymbol: currencySymbol,
      borderColor: TossColors.primary,
      showBorder: true,
      padding: const EdgeInsets.all(TossSpacing.space3),
      borderRadius: TossBorderRadius.md,
      labelStyle: TossTextStyles.body.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
      valueStyle: TossTextStyles.body.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    );
  }

  /// Factory constructor for card-style display
  factory TotalDisplayBox.card({
    required String label,
    double? amount,
    String? value,
    String currencySymbol = '₫',
  }) {
    return TotalDisplayBox(
      label: label,
      amount: amount,
      value: value,
      currencySymbol: currencySymbol,
      borderColor: TossColors.gray100,
      showBorder: true,
      padding: const EdgeInsets.all(TossSpacing.space4),
      borderRadius: TossBorderRadius.md,
    );
  }

  String _getDisplayValue() {
    if (value != null) {
      return value!;
    }

    if (amount != null) {
      final formatter = NumberFormat('#,###');
      return '$currencySymbol${formatter.format(amount!.toInt())}';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = _getDisplayValue();

    final defaultLabelStyle = TossTextStyles.body.copyWith(
      color: TossColors.gray700,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    );

    final defaultValueStyle = TossTextStyles.body.copyWith(
      color: TossColors.gray900,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ?? defaultLabelStyle,
        ),
        Text(
          displayValue,
          style: valueStyle ?? defaultValueStyle,
        ),
      ],
    );

    // If no background, border, or padding, return plain content
    if (backgroundColor == null && !showBorder && padding == null) {
      return content;
    }

    // Return decorated container
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorder
            ? Border.all(
                color: borderColor ?? TossColors.gray200,
                width: 1,
              )
            : null,
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : null,
      ),
      child: content,
    );
  }
}
