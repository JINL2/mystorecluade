// lib/features/cash_ending/data/models/denomination_model.dart

import '../../domain/entities/denomination.dart';

/// Data Transfer Object for Denomination
/// Handles JSON serialization/deserialization
class DenominationModel {
  final String denominationId;
  final String currencyId;
  final double value;
  final int quantity;

  const DenominationModel({
    required this.denominationId,
    required this.currencyId,
    required this.value,
    this.quantity = 0,
  });

  /// Create from JSON (from database)
  factory DenominationModel.fromJson(Map<String, dynamic> json) {
    return DenominationModel(
      denominationId: json['denomination_id']?.toString() ?? '',
      currencyId: json['currency_id']?.toString() ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert to JSON (to database)
  Map<String, dynamic> toJson() {
    return {
      'denomination_id': denominationId,
      'currency_id': currencyId,
      'value': value,
      'quantity': quantity,
    };
  }

  /// Convert to Domain Entity
  Denomination toEntity() {
    return Denomination(
      denominationId: denominationId,
      currencyId: currencyId,
      value: value,
      quantity: quantity,
    );
  }

  /// Create from Domain Entity
  factory DenominationModel.fromEntity(Denomination entity) {
    return DenominationModel(
      denominationId: entity.denominationId,
      currencyId: entity.currencyId,
      value: entity.value,
      quantity: entity.quantity,
    );
  }
}
