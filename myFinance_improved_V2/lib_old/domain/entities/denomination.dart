import 'package:freezed_annotation/freezed_annotation.dart';

part 'denomination.freezed.dart';
part 'denomination.g.dart';

@freezed
class Denomination with _$Denomination {
  const factory Denomination({
    required String id,
    required String companyId,
    required String currencyId,
    required double value,
    required DenominationType type,
    required String displayName,
    required String emoji,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Denomination;

  factory Denomination.fromJson(Map<String, dynamic> json) => _$DenominationFromJson(json);
}

extension DenominationExtensions on Denomination {
  /// Format the denomination value for display
  String get formattedValue {
    // Handle different currency formatting based on currencyId or value patterns
    if (value < 1.0) {
      // Small denominations (cents, etc.)
      return '${(value * 100).toInt()}¢';
    } else if (value >= 1000) {
      // Large denominations (Korean Won, Japanese Yen, etc.)
      return value.toInt().toString();
    } else {
      // Standard currency (dollars, euros, etc.)
      return value.toInt().toString();
    }
  }

  /// Get display name with proper formatting
  String get displayNameWithValue {
    return '$formattedValue $displayName';
  }

  /// Check if this is a small denomination (coin typically)
  bool get isSmallDenomination => value < 1.0;

  /// Check if this is a large denomination (high-value bill)
  bool get isLargeDenomination => value >= 100.0;
}

enum DenominationType {
  @JsonValue('coin')
  coin,
  @JsonValue('bill')
  bill;

  String get displayName => switch (this) {
    DenominationType.coin => 'Coin',
    DenominationType.bill => 'Bill',
  };

  String get emoji => switch (this) {
    DenominationType.coin => '🪙',
    DenominationType.bill => '💵',
  };
}

/// Input model for creating denominations
@freezed
class DenominationInput with _$DenominationInput {
  const factory DenominationInput({
    required String companyId,
    required String currencyId,
    required double value,
    required DenominationType type,
    String? displayName,
    String? emoji,
  }) = _DenominationInput;

  factory DenominationInput.fromJson(Map<String, dynamic> json) => _$DenominationInputFromJson(json);
}