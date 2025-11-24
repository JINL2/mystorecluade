// lib/features/cash_ending/domain/entities/balance_summary.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_summary.freezed.dart';

/// Domain Entity for Balance Summary
///
/// Represents the comparison between Journal (book balance) and Real (actual cash count).
/// This is the "single source of truth" in the domain layer.
@freezed
class BalanceSummary with _$BalanceSummary {
  const BalanceSummary._();

  const factory BalanceSummary({
    required String locationId,
    required String locationName,
    required String locationType,

    // Balance amounts
    required double totalJournal,
    required double totalReal,
    required double difference,

    // Status flags
    required bool isBalanced,
    required bool hasShortage,
    required bool hasSurplus,

    // Currency info
    required String currencySymbol,
    required String currencyCode,

    // Metadata
    DateTime? lastUpdated,
  }) = _BalanceSummary;

  /// Check if auto-balance is needed
  bool get needsAutoBalance => !isBalanced && difference.abs() > 0.01;

  /// Get balance status as enum
  BalanceStatus get status {
    if (isBalanced) return BalanceStatus.balanced;
    if (hasShortage) return BalanceStatus.shortage;
    if (hasSurplus) return BalanceStatus.surplus;
    return BalanceStatus.unknown;
  }

  /// Get formatted amounts with currency symbol
  String get formattedTotalJournal =>
      '$currencySymbol${totalJournal.toStringAsFixed(2)}';

  String get formattedTotalReal =>
      '$currencySymbol${totalReal.toStringAsFixed(2)}';

  String get formattedDifference {
    final sign = difference > 0 ? '+' : '';
    return '$sign$currencySymbol${difference.toStringAsFixed(2)}';
  }

  /// Calculate difference percentage (difference / totalReal * 100)
  /// Returns 0 if totalReal is 0 to avoid division by zero
  double get differencePercentage {
    if (totalReal == 0) return 0.0;
    return (difference / totalReal) * 100;
  }

  /// Get formatted percentage with sign
  String get formattedPercentage {
    final sign = differencePercentage > 0 ? '+' : '';
    return '$sign${differencePercentage.toStringAsFixed(2)}%';
  }

  /// Get percentage color based on threshold
  /// - Green (balanced): 0% or positive difference
  /// - Orange (warning): 1-5%
  /// - Red (critical): > 5%
  PercentageLevel get percentageLevel {
    final absPercentage = differencePercentage.abs();

    if (isBalanced || difference >= 0) {
      return PercentageLevel.safe;
    } else if (absPercentage > 5.0) {
      return PercentageLevel.critical;
    } else if (absPercentage > 1.0) {
      return PercentageLevel.warning;
    }
    return PercentageLevel.safe;
  }
}

/// Percentage level enumeration for color coding
enum PercentageLevel {
  /// Safe: 0% or positive (green)
  safe,

  /// Warning: 1-5% shortage (orange)
  warning,

  /// Critical: > 5% shortage (red)
  critical;

  /// Get display color name
  String get colorName {
    switch (this) {
      case PercentageLevel.safe:
        return 'green';
      case PercentageLevel.warning:
        return 'orange';
      case PercentageLevel.critical:
        return 'red';
    }
  }
}

/// Balance status enumeration
enum BalanceStatus {
  balanced,
  shortage,
  surplus,
  unknown;

  /// Get display name
  String get displayName {
    switch (this) {
      case BalanceStatus.balanced:
        return 'Balanced';
      case BalanceStatus.shortage:
        return 'Shortage';
      case BalanceStatus.surplus:
        return 'Surplus';
      case BalanceStatus.unknown:
        return 'Unknown';
    }
  }

  /// Get icon
  String get icon {
    switch (this) {
      case BalanceStatus.balanced:
        return '✓';
      case BalanceStatus.shortage:
        return '⚠️';
      case BalanceStatus.surplus:
        return '⬆️';
      case BalanceStatus.unknown:
        return '?';
    }
  }
}
