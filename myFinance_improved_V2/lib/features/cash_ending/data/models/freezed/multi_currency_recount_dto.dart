import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../../domain/entities/multi_currency_recount.dart';
import 'vault_recount_dto.dart';

/// Multi-Currency Recount DTO
///
/// Maps to universal RPC: insert_amount_multi_currency with p_vault_transaction_type='recount'
/// Handles multiple currencies in a single RPC call
///
/// Note: This is a simple DTO class (not freezed) because it's only used internally
/// for entity-to-RPC conversion and doesn't need JSON serialization
class MultiCurrencyRecountDto {
  final String companyId;
  final String? storeId;
  final String locationId;
  final String userId;
  final DateTime recordDate;
  final List<VaultRecountDto> currencyRecounts;

  const MultiCurrencyRecountDto({
    required this.companyId,
    this.storeId,
    required this.locationId,
    required this.userId,
    required this.recordDate,
    required this.currencyRecounts,
  });

  /// Convert to RPC parameters for universal multi-currency RPC
  ///
  /// ✅ Uses insert_amount_multi_currency with p_vault_transaction_type='recount'
  /// RECOUNT: Stock method - quantity
  Map<String, dynamic> toRpcParams() {
    // Build currencies array for RPC (multiple currencies)
    final currenciesJson = currencyRecounts
        .map((recount) => {
              'currency_id': recount.currencyId,
              'denominations': recount.denominations
                  .where((d) => d.quantity > 0)
                  .map((d) => {
                        'denomination_id': d.denominationId,
                        'quantity': d.quantity, // RECOUNT uses quantity (stock method)
                      })
                  .toList(),
            })
        .toList();

    return {
      'p_entry_type': 'vault',
      'p_vault_transaction_type': 'recount',
      'p_company_id': companyId,
      'p_location_id': locationId,
      'p_record_date': DateTimeUtils.toDateOnly(recordDate),
      'p_created_by': userId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_description': 'Multi-currency vault recount',
      'p_currencies': currenciesJson,
    };
  }

  /// Convert to Domain Entity
  MultiCurrencyRecount toEntity() {
    return MultiCurrencyRecount(
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      userId: userId,
      recordDate: recordDate,
      currencyRecounts: currencyRecounts.map((d) => d.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory MultiCurrencyRecountDto.fromEntity(MultiCurrencyRecount entity) {
    return MultiCurrencyRecountDto(
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      userId: entity.userId,
      recordDate: entity.recordDate,
      currencyRecounts: entity.currencyRecounts
          .map((r) => VaultRecountDto.fromEntity(r))
          .toList(),
    );
  }
}
