import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Input Formatters for common use cases
///
/// These formatters can be reused across multiple features.

/// Thousand Separator Input Formatter
///
/// Formats numbers with comma separators (e.g., 1,000,000)
/// Usage: TextFormField(inputFormatters: [ThousandSeparatorInputFormatter()])
class ThousandSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Parse the number
    int number = int.tryParse(digitsOnly) ?? 0;

    // Format with commas
    String formatted = _formatter.format(number);

    // Calculate new cursor position
    int cursorPosition = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

/// Currency Input Formatter
///
/// Formats currency with symbol and thousand separators
/// Usage: TextFormField(inputFormatters: [CurrencyInputFormatter(symbol: '₩')])
class CurrencyInputFormatter extends TextInputFormatter {
  final String symbol;
  final NumberFormat _formatter = NumberFormat('#,###');

  CurrencyInputFormatter({this.symbol = '₩'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Parse the number
    int number = int.tryParse(digitsOnly) ?? 0;

    // Format with commas and symbol
    String formatted = '$symbol ${_formatter.format(number)}';

    // Calculate new cursor position
    int cursorPosition = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

/// Decimal Input Formatter
///
/// Formats numbers with decimal points
/// Usage: TextFormField(inputFormatters: [DecimalInputFormatter(decimalPlaces: 2)])
class DecimalInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  DecimalInputFormatter({this.decimalPlaces = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Allow only digits and one decimal point
    String filtered = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Ensure only one decimal point
    int decimalCount = filtered.split('.').length - 1;
    if (decimalCount > 1) {
      return oldValue;
    }

    // Limit decimal places
    if (filtered.contains('.')) {
      List<String> parts = filtered.split('.');
      if (parts.length == 2 && parts[1].length > decimalPlaces) {
        filtered = '${parts[0]}.${parts[1].substring(0, decimalPlaces)}';
      }
    }

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

/// Phone Number Input Formatter
///
/// Formats phone numbers (Korean format: 010-1234-5678)
/// Usage: TextFormField(inputFormatters: [PhoneNumberInputFormatter()])
class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format based on length
    String formatted = '';
    if (digitsOnly.length <= 3) {
      formatted = digitsOnly;
    } else if (digitsOnly.length <= 7) {
      formatted = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
    } else if (digitsOnly.length <= 11) {
      formatted =
          '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
    } else {
      // Limit to 11 digits
      digitsOnly = digitsOnly.substring(0, 11);
      formatted =
          '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
