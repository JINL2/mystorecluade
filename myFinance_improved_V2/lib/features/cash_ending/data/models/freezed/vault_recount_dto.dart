import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../../domain/entities/vault_recount.dart';
import 'denomination_dto.dart';

part 'vault_recount_dto.freezed.dart';
part 'vault_recount_dto.g.dart';

/// Vault Recount DTO
///
/// Maps to universal RPC: cash_ending_insert_amount_multi_currency with p_vault_transaction_type='recount'
/// Handles JSON serialization/deserialization and RPC parameter formatting
@freezed
class VaultRecountDto with _$VaultRecountDto {
  const VaultRecountDto._();

  const factory VaultRecountDto({
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'created_by') required String userId,
    @JsonKey(name: 'record_date') required DateTime recordDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default([]) List<DenominationDto> denominations,
  }) = _VaultRecountDto;

  factory VaultRecountDto.fromJson(Map<String, dynamic> json) =>
      _$VaultRecountDtoFromJson(json);

  /// Convert to RPC parameters for universal multi-currency RPC
  ///
  /// ✅ Uses cash_ending_insert_amount_multi_currency with p_vault_transaction_type='recount'
  /// RECOUNT: Stock method - quantity
  Map<String, dynamic> toRpcParams() {
    // Build currencies array for RPC (single currency for VaultRecount)
    final currenciesJson = [
      {
        'currency_id': currencyId,
        'denominations': denominations
            .where((d) => d.quantity > 0)
            .map((d) => {
                  'denomination_id': d.denominationId,
                  'quantity': d.quantity, // RECOUNT uses quantity (stock method)
                })
            .toList(),
      }
    ];

    return {
      'p_entry_type': 'vault',
      'p_vault_transaction_type': 'recount',
      'p_company_id': companyId,
      'p_location_id': locationId,
      'p_record_date': DateTimeUtils.toDateOnly(recordDate),
      'p_created_by': userId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_description': 'Vault recount',
      'p_currencies': currenciesJson,
    };
  }

  /// Convert to Domain Entity
  VaultRecount toEntity() {
    return VaultRecount(
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      currencyId: currencyId,
      userId: userId,
      recordDate: recordDate,
      createdAt: createdAt,
      denominations: denominations.map((d) => d.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory VaultRecountDto.fromEntity(VaultRecount entity) {
    return VaultRecountDto(
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      currencyId: entity.currencyId,
      userId: entity.userId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
      denominations: entity.denominations
          .map((d) => DenominationDto.fromEntity(d))
          .toList(),
    );
  }
}
