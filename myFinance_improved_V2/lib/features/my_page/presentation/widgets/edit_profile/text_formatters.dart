import 'package:flutter/services.dart';

/// Uppercase text formatter: auto-converts input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Smart bank account formatter: allows letters only for IBAN format
class BankAccountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase();

    // If empty or just starting, allow any input
    if (text.isEmpty) {
      return TextEditingValue(
        text: text,
        selection: newValue.selection,
      );
    }

    // Check if user is typing IBAN format (starts with 2 letters)
    final startsWithTwoLetters = RegExp(r'^[A-Z]{1,2}$').hasMatch(text);
    final isIBANFormat = text.length >= 2 && RegExp(r'^[A-Z]{2}').hasMatch(text);

    // If starting with letters (IBAN), allow alphanumeric + spaces
    if (startsWithTwoLetters || isIBANFormat) {
      // IBAN format: allow letters, digits, and spaces
      if (RegExp(r'^[A-Z0-9\s]*$').hasMatch(text)) {
        return TextEditingValue(
          text: text,
          selection: newValue.selection,
        );
      }
    } else {
      // Regular account number: digits only
      if (RegExp(r'^[0-9]*$').hasMatch(text)) {
        return TextEditingValue(
          text: text,
          selection: newValue.selection,
        );
      }
    }

    // If invalid, keep old value
    return oldValue;
  }
}
