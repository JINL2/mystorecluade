import 'package:intl/intl.dart';

/// Currency information
class TradeCurrency {
  final String id;
  final String code;
  final String name;
  final String symbol;
  final int decimalPlaces;

  const TradeCurrency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    this.decimalPlaces = 2,
  });

  /// Common currencies
  static const TradeCurrency usd = TradeCurrency(
    id: 'usd', code: 'USD', name: 'US Dollar', symbol: '\$',
  );
  static const TradeCurrency eur = TradeCurrency(
    id: 'eur', code: 'EUR', name: 'Euro', symbol: '€',
  );
  static const TradeCurrency krw = TradeCurrency(
    id: 'krw', code: 'KRW', name: 'Korean Won', symbol: '₩', decimalPlaces: 0,
  );
  static const TradeCurrency jpy = TradeCurrency(
    id: 'jpy', code: 'JPY', name: 'Japanese Yen', symbol: '¥', decimalPlaces: 0,
  );
  static const TradeCurrency cny = TradeCurrency(
    id: 'cny', code: 'CNY', name: 'Chinese Yuan', symbol: '¥',
  );
  static const TradeCurrency gbp = TradeCurrency(
    id: 'gbp', code: 'GBP', name: 'British Pound', symbol: '£',
  );

  static List<TradeCurrency> get commonList => [usd, eur, krw, jpy, cny, gbp];

  static TradeCurrency fromCode(String code) {
    return commonList.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => TradeCurrency(id: code, code: code, name: code, symbol: code),
    );
  }
}

/// Trade amount with currency
class TradeAmount {
  final double amount;
  final String currencyCode;
  final TradeCurrency? currency;

  const TradeAmount({
    required this.amount,
    required this.currencyCode,
    this.currency,
  });

  factory TradeAmount.zero({String currencyCode = 'USD'}) => TradeAmount(
        amount: 0,
        currencyCode: currencyCode,
      );

  /// Get currency object
  TradeCurrency get currencyInfo => currency ?? TradeCurrency.fromCode(currencyCode);

  /// Format amount with currency symbol
  String get formatted {
    final curr = currencyInfo;
    final formatter = NumberFormat.currency(
      symbol: curr.symbol,
      decimalDigits: curr.decimalPlaces,
    );
    return formatter.format(amount);
  }

  /// Format amount without symbol (just number)
  String get formattedNumber {
    final curr = currencyInfo;
    final formatter = NumberFormat.decimalPatternDigits(
      decimalDigits: curr.decimalPlaces,
    );
    return formatter.format(amount);
  }

  /// Format with currency code (e.g., "USD 1,000.00")
  String get formattedWithCode => '$currencyCode ${formattedNumber}';

  /// Check if amount is zero
  bool get isZero => amount == 0;

  /// Check if amount is positive
  bool get isPositive => amount > 0;

  /// Add amounts
  TradeAmount operator +(TradeAmount other) {
    if (currencyCode != other.currencyCode) {
      throw ArgumentError('Cannot add amounts with different currencies');
    }
    return TradeAmount(
      amount: amount + other.amount,
      currencyCode: currencyCode,
      currency: currency,
    );
  }

  /// Subtract amounts
  TradeAmount operator -(TradeAmount other) {
    if (currencyCode != other.currencyCode) {
      throw ArgumentError('Cannot subtract amounts with different currencies');
    }
    return TradeAmount(
      amount: amount - other.amount,
      currencyCode: currencyCode,
      currency: currency,
    );
  }

  /// Multiply by scalar
  TradeAmount operator *(double factor) {
    return TradeAmount(
      amount: amount * factor,
      currencyCode: currencyCode,
      currency: currency,
    );
  }
}

/// L/C amount with tolerance calculation
class LCAmount {
  final double amount;
  final String currencyCode;
  final double tolerancePlusPercent;
  final double toleranceMinusPercent;
  final double amountUtilized;

  const LCAmount({
    required this.amount,
    required this.currencyCode,
    this.tolerancePlusPercent = 0,
    this.toleranceMinusPercent = 0,
    this.amountUtilized = 0,
  });

  /// Maximum drawable amount (with tolerance)
  double get maxDrawable => amount * (1 + tolerancePlusPercent / 100);

  /// Minimum acceptable amount (with tolerance)
  double get minAcceptable => amount * (1 - toleranceMinusPercent / 100);

  /// Remaining drawable amount
  double get remainingDrawable => maxDrawable - amountUtilized;

  /// Utilization percentage
  double get utilizationPercent =>
      amount > 0 ? (amountUtilized / amount) * 100 : 0;

  /// Check if fully utilized
  bool get isFullyUtilized => amountUtilized >= amount;

  /// Check if can draw more
  bool get canDrawMore => remainingDrawable > 0;

  /// Format amount
  String get formatted => TradeAmount(
        amount: amount,
        currencyCode: currencyCode,
      ).formatted;

  /// Format with tolerance info
  String get formattedWithTolerance {
    if (tolerancePlusPercent == 0 && toleranceMinusPercent == 0) {
      return formatted;
    }
    if (tolerancePlusPercent == toleranceMinusPercent) {
      return '$formatted (±${tolerancePlusPercent.toStringAsFixed(0)}%)';
    }
    return '$formatted (+${tolerancePlusPercent.toStringAsFixed(0)}%/-${toleranceMinusPercent.toStringAsFixed(0)}%)';
  }

  /// Validate if amount is within tolerance
  bool isWithinTolerance(double checkAmount) {
    return checkAmount >= minAcceptable && checkAmount <= maxDrawable;
  }

  /// Get tolerance status for a given amount
  ToleranceStatus getToleranceStatus(double checkAmount) {
    if (checkAmount < minAcceptable) {
      return ToleranceStatus.belowMinimum;
    }
    if (checkAmount > maxDrawable) {
      return ToleranceStatus.aboveMaximum;
    }
    if (checkAmount < amount) {
      return ToleranceStatus.withinLowerTolerance;
    }
    if (checkAmount > amount) {
      return ToleranceStatus.withinUpperTolerance;
    }
    return ToleranceStatus.exact;
  }
}

enum ToleranceStatus {
  exact,
  withinLowerTolerance,
  withinUpperTolerance,
  belowMinimum,
  aboveMaximum,
}

/// Extension for tolerance status display
extension ToleranceStatusExtension on ToleranceStatus {
  String get message {
    switch (this) {
      case ToleranceStatus.exact:
        return 'Amount matches exactly';
      case ToleranceStatus.withinLowerTolerance:
        return 'Amount within lower tolerance';
      case ToleranceStatus.withinUpperTolerance:
        return 'Amount within upper tolerance';
      case ToleranceStatus.belowMinimum:
        return 'Amount below minimum acceptable';
      case ToleranceStatus.aboveMaximum:
        return 'Amount exceeds maximum allowed';
    }
  }

  bool get isValid =>
      this == ToleranceStatus.exact ||
      this == ToleranceStatus.withinLowerTolerance ||
      this == ToleranceStatus.withinUpperTolerance;
}
