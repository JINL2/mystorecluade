import 'dart:math' as math;
import 'package:equatable/equatable.dart';

/// Value object representing a transaction amount with validation
/// 
/// Encapsulates monetary value with built-in validation rules and formatting.
/// This is an immutable value object that ensures data integrity.
class TransactionAmount extends Equatable {
  final double value;

  const TransactionAmount(this.value);

  /// Creates a TransactionAmount with validation
  factory TransactionAmount.create(double value) {
    if (value <= 0) {
      throw ArgumentError('Transaction amount must be greater than zero');
    }
    if (value > 999999999.99) {
      throw ArgumentError('Transaction amount exceeds maximum limit');
    }
    return TransactionAmount(value);
  }

  /// Creates a zero amount (useful for calculations)
  const TransactionAmount.zero() : value = 0;

  /// Validates the amount according to business rules
  bool get isValid => value > 0 && value <= 999999999.99;

  /// Checks if amount is zero
  bool get isZero => value == 0;

  /// Checks if amount is positive
  bool get isPositive => value > 0;

  /// Formats the amount for display
  String format({String currency = 'USD', int decimalPlaces = 2}) {
    return '\$${value.toStringAsFixed(decimalPlaces)}';
  }

  /// Formats for financial reports (with commas)
  String formatWithCommas({String currency = 'USD'}) {
    final formatter = value.toStringAsFixed(2);
    final parts = formatter.split('.');
    final wholePart = parts[0];
    final decimalPart = parts[1];
    
    // Add commas to whole number part
    final withCommas = wholePart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    
    return '\$$withCommas.$decimalPart';
  }

  /// Math operations that return new TransactionAmount instances
  TransactionAmount operator +(TransactionAmount other) {
    return TransactionAmount(value + other.value);
  }

  TransactionAmount operator -(TransactionAmount other) {
    final result = value - other.value;
    if (result < 0) {
      throw ArgumentError('Subtraction would result in negative amount');
    }
    return TransactionAmount(result);
  }

  TransactionAmount operator *(double factor) {
    if (factor < 0) {
      throw ArgumentError('Multiplication factor cannot be negative');
    }
    return TransactionAmount(value * factor);
  }

  TransactionAmount operator /(double divisor) {
    if (divisor <= 0) {
      throw ArgumentError('Divisor must be positive');
    }
    return TransactionAmount(value / divisor);
  }

  /// Comparison operations
  bool operator >(TransactionAmount other) => value > other.value;
  bool operator <(TransactionAmount other) => value < other.value;
  bool operator >=(TransactionAmount other) => value >= other.value;
  bool operator <=(TransactionAmount other) => value <= other.value;

  /// Calculates percentage of this amount
  TransactionAmount percentage(double percent) {
    if (percent < 0 || percent > 100) {
      throw ArgumentError('Percentage must be between 0 and 100');
    }
    return TransactionAmount(value * (percent / 100));
  }

  /// Rounds to specified decimal places
  TransactionAmount round([int decimalPlaces = 2]) {
    final factor = math.pow(10, decimalPlaces);
    final rounded = (value * factor).round() / factor;
    return TransactionAmount(rounded);
  }

  /// Converts to different currency (simplified - in real app would use exchange rates)
  TransactionAmount toCurrency(double exchangeRate) {
    if (exchangeRate <= 0) {
      throw ArgumentError('Exchange rate must be positive');
    }
    return TransactionAmount(value * exchangeRate);
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => format();
}