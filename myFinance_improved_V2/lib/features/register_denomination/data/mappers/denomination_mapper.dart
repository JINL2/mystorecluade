import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/denomination.dart';

/// Mapper for converting Supabase JSON to Denomination entities
///
/// Centralizes denomination mapping logic to avoid code duplication
/// across repository methods.
class DenominationMapper {
  DenominationMapper._();

  /// Convert a single JSON map to Denomination entity
  ///
  /// Handles:
  /// - Type conversion from 'coin'/'bill' string to enum
  /// - Nullable type field with 'bill' as default
  /// - Date conversion from UTC string to local DateTime
  static Denomination fromJson(Map<String, dynamic> json) {
    final typeValue = json['type'] as String? ?? 'bill';
    final type = typeValue == 'coin'
        ? DenominationType.coin
        : DenominationType.bill;

    return Denomination(
      id: json['denomination_id'] as String,
      companyId: json['company_id'] as String,
      currencyId: json['currency_id'] as String,
      value: (json['value'] as num).toDouble(),
      type: type,
      displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
      emoji: type == DenominationType.coin ? '🪙' : '💵',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTimeUtils.toLocal(json['created_at'] as String)
          : null,
    );
  }

  /// Convert a list of JSON maps to List<Denomination>
  ///
  /// Safely handles dynamic lists from Supabase responses
  static List<Denomination> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .cast<Map<String, dynamic>>()
        .map(fromJson)
        .toList();
  }
}
