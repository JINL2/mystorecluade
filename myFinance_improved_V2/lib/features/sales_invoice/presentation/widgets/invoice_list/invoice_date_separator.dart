// lib/features/sales_invoice/presentation/widgets/invoice_list/invoice_date_separator.dart
//
// Extracted date separator widget from sales_invoice_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Invoice date separator widget
///
/// Displays a formatted date header for grouping invoices by date.
class InvoiceDateSeparator extends StatelessWidget {
  final DateTime date;

  const InvoiceDateSeparator({
    super.key,
    required this.date,
  });

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final dayName = _dayNames[date.weekday - 1];
    final monthName = _monthNames[date.month - 1];

    return Text(
      '$dayName, ${date.day} $monthName ${date.year}',
      style: TossTextStyles.caption.copyWith(
        fontWeight: TossFontWeight.regular,
        color: TossColors.gray600,
      ),
    );
  }
}
