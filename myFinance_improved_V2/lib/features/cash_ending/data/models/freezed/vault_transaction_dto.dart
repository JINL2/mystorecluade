import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../../domain/entities/vault_transaction.dart';
import 'currency_dto.dart';

part 'vault_transaction_dto.freezed.dart';
part 'vault_transaction_dto.g.dart';

/// Vault Transaction DTO (Multi-Currency)
///
/// Maps to universal RPC: cash_ending_insert_amount_multi_currency
/// Handles JSON serialization/deserialization and RPC parameter formatting
@freezed
class VaultTransactionDto with _$VaultTransactionDto {
  const VaultTransactionDto._();

  const factory VaultTransactionDto({
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'created_by') required String userId,
    @JsonKey(name: 'record_date') required DateTime recordDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'credit') required bool isCredit,
    @Default([]) List<CurrencyDto> currencies,
  }) = _VaultTransactionDto;

  factory VaultTransactionDto.fromJson(Map<String, dynamic> json) =>
      _$VaultTransactionDtoFromJson(json);

  /// Convert to RPC parameters for universal multi-currency RPC
  ///
  /// ✅ Uses cash_ending_insert_amount_multi_currency with Entry-based workflow
  /// ✅ ALL Vault transactions send QUANTITY (RPC calculates amount)
  Map<String, dynamic> toRpcParams({String? transactionType}) {
    // Determine vault transaction type
    // If transactionType provided, use it; otherwise infer from isCredit
    final vaultTransactionType = transactionType ?? (isCredit ? 'out' : 'in');

    // Build currencies array for RPC
    final currenciesJson = currencies.map((currency) {
      // Build denominations for this currency
      // ✅ ALL vault transaction types send quantity (Stock method)
      final denominationsJson = currency.denominations
          .where((d) => d.quantity > 0)
          .map((d) => {
                'denomination_id': d.denominationId,
                'quantity': d.quantity,  // ✅ Always send quantity
              })
          .toList();

      return {
        'currency_id': currency.currencyId,
        'denominations': denominationsJson,
      };
    }).toList();

    return {
      'p_entry_type': 'vault',
      'p_vault_transaction_type': vaultTransactionType,
      'p_company_id': companyId,
      'p_location_id': locationId,
      'p_record_date': DateTimeUtils.toDateOnly(recordDate),
      'p_created_by': userId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_description': 'Vault $vaultTransactionType transaction',
      'p_currencies': currenciesJson,
    };
  }

  /// Convert to Domain Entity
  VaultTransaction toEntity() {
    return VaultTransaction(
      transactionId: transactionId,
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      userId: userId,
      recordDate: recordDate,
      createdAt: createdAt,
      isCredit: isCredit,
      currencies: currencies.map((c) => c.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory VaultTransactionDto.fromEntity(VaultTransaction entity) {
    return VaultTransactionDto(
      transactionId: entity.transactionId,
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      userId: entity.userId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
      isCredit: entity.isCredit,
      currencies: entity.currencies
          .map((c) => CurrencyDto.fromEntity(c))
          .toList(),
    );
  }
}
