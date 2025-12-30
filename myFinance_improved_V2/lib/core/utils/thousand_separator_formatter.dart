/// Thousand Separator Input Formatter
///
/// Purpose: Custom TextInputFormatter for thousand separators (000,000 format)
/// Used for amount input fields across the app.
///
/// Clean Architecture: SHARED LAYER - Utility
library;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Custom TextInputFormatter for thousand separators (000,000 format)
class ThousandSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty input
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Handle decimal numbers
    final parts = cleanText.split('.');
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    // Parse and format integer part
    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    final intValue = int.tryParse(integerPart) ?? 0;
    String formattedText = _formatter.format(intValue);

    // Add decimal part if exists
    if (decimalPart != null) {
      formattedText = '$formattedText.$decimalPart';
    }

    // Calculate new cursor position
    int cursorOffset = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}
