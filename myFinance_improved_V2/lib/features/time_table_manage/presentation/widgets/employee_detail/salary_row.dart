import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Salary row widget
class SalaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const SalaryRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TossTextStyles.body.copyWith(
                color: valueColor ?? TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
