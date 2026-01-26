import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../../domain/entities/bank_balance.dart';
import 'currency_dto.dart';

part 'bank_balance_dto.freezed.dart';
part 'bank_balance_dto.g.dart';

/// Bank Balance DTO (Multi-Currency)
///
/// Maps to universal RPC: cash_ending_insert_amount_multi_currency
/// Handles JSON serialization/deserialization and RPC parameter formatting
@freezed
class BankBalanceDto with _$BankBalanceDto {
  const BankBalanceDto._();

  const factory BankBalanceDto({
    @JsonKey(name: 'bank_amount_id') String? balanceId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'created_by') required String userId,
    @JsonKey(name: 'record_date') required DateTime recordDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default([]) List<CurrencyDto> currencies,
  }) = _BankBalanceDto;

  factory BankBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$BankBalanceDtoFromJson(json);

  /// Convert to RPC parameters for universal multi-currency RPC
  ///
  /// ✅ Uses cash_ending_insert_amount_multi_currency with Entry-based workflow
  /// Bank uses total_amount (no denominations)
  Map<String, dynamic> toRpcParams() {
    // Build currencies array for RPC
    // Bank: Each currency has total_amount only (no denominations)
    final currenciesJson = currencies.map((currency) {
      // Calculate total amount from denominations (Bank uses single virtual denomination)
      final totalAmount = currency.denominations.fold<double>(
        0.0,
        (sum, denom) => sum + (denom.quantity * denom.value),
      );

      return {
        'currency_id': currency.currencyId,
        'total_amount': totalAmount,
      };
    }).toList();

    return {
      'p_entry_type': 'bank',
      'p_company_id': companyId,
      'p_location_id': locationId,
      'p_record_date': DateTimeUtils.toDateOnly(recordDate),
      'p_created_by': userId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_description': 'Bank balance',
      'p_currencies': currenciesJson,
    };
  }

  /// Convert to Domain Entity
  BankBalance toEntity() {
    return BankBalance(
      balanceId: balanceId,
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      userId: userId,
      recordDate: recordDate,
      createdAt: createdAt,
      currencies: currencies.map((c) => c.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory BankBalanceDto.fromEntity(BankBalance entity) {
    return BankBalanceDto(
      balanceId: entity.balanceId,
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      userId: entity.userId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
      currencies: entity.currencies
          .map((c) => CurrencyDto.fromEntity(c))
          .toList(),
    );
  }
}
