import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/vault_transaction.dart';
import 'denomination_dto.dart';

part 'vault_transaction_dto.freezed.dart';
part 'vault_transaction_dto.g.dart';

/// Vault Transaction DTO
///
/// Maps to DB table: vault_transactions
/// Handles JSON serialization/deserialization and RPC parameter formatting
@freezed
class VaultTransactionDto with _$VaultTransactionDto {
  const VaultTransactionDto._();

  const factory VaultTransactionDto({
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'created_by') required String userId,
    @JsonKey(name: 'record_date') required DateTime recordDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'credit') required bool isCredit,
    @Default([]) List<DenominationDto> denominations,
  }) = _VaultTransactionDto;

  factory VaultTransactionDto.fromJson(Map<String, dynamic> json) =>
      _$VaultTransactionDtoFromJson(json);

  /// Convert to RPC parameters for Supabase (vault_amount_insert)
  ///
  /// This matches the exact format expected by the stored procedure
  Map<String, dynamic> toRpcParams() {
    // Format dates as required by RPC
    final recordDateStr = DateFormat('yyyy-MM-dd').format(recordDate);
    final createdAtStr = '${DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt)}'
        '.${createdAt.microsecond.toString().padLeft(6, '0')}';

    // Build vault_amount_line_json with denomination details
    final List<Map<String, dynamic>> vaultAmountLineJson = [];

    for (final denom in denominations) {
      if (denom.quantity > 0) {
        vaultAmountLineJson.add({
          'quantity': denom.quantity.toString(),
          'denomination_id': denom.denominationId,
          'denomination_value': denom.value.toString(),
          'denomination_type': 'BILL', // Default type
        });
      }
    }

    return {
      'p_location_id': locationId,
      'p_company_id': companyId,
      'p_created_at': createdAtStr,
      'p_created_by': userId,
      'p_credit': isCredit,
      'p_debit': !isCredit,
      'p_currency_id': currencyId,
      'p_record_date': recordDateStr,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_vault_amount_line_json': vaultAmountLineJson,
    };
  }

  /// Convert to Domain Entity
  VaultTransaction toEntity() {
    return VaultTransaction(
      transactionId: transactionId,
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      currencyId: currencyId,
      userId: userId,
      recordDate: recordDate,
      createdAt: createdAt,
      isCredit: isCredit,
      denominations: denominations.map((d) => d.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory VaultTransactionDto.fromEntity(VaultTransaction entity) {
    return VaultTransactionDto(
      transactionId: entity.transactionId,
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      currencyId: entity.currencyId,
      userId: entity.userId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
      isCredit: entity.isCredit,
      denominations: entity.denominations
          .map((d) => DenominationDto.fromEntity(d))
          .toList(),
    );
  }
}
