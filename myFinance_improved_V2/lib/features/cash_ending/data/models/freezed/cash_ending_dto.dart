import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../../domain/entities/cash_ending.dart';
import 'currency_dto.dart';

part 'cash_ending_dto.freezed.dart';
part 'cash_ending_dto.g.dart';

/// Cash Ending DTO
///
/// Maps to DB table: cash_ending_master
/// Handles JSON serialization/deserialization and RPC parameter formatting
@freezed
class CashEndingDto with _$CashEndingDto {
  const CashEndingDto._();

  const factory CashEndingDto({
    @JsonKey(name: 'cash_ending_id') String? cashEndingId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'record_date') required DateTime recordDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default([]) List<CurrencyDto> currencies,
  }) = _CashEndingDto;

  factory CashEndingDto.fromJson(Map<String, dynamic> json) =>
      _$CashEndingDtoFromJson(json);

  /// Convert to RPC parameters for Supabase (cash_ending_insert_amount_multi_currency)
  ///
  /// ✅ Universal Multi-Currency RPC format with Entry-based workflow
  Map<String, dynamic> toRpcParams() {
    // Build currencies array for RPC
    final currenciesJson = currencies.map((currency) {
      // Include all denominations with their quantities
      final denominationsJson = currency.denominations
          .map((d) => {
                'denomination_id': d.denominationId,
                'quantity': d.quantity,  // ✅ Cash uses Stock method
              })
          .toList();

      return {
        'currency_id': currency.currencyId,
        'denominations': denominationsJson,
      };
    }).toList();

    final effectiveUserId = userId ?? createdBy ?? '';

    return {
      'p_entry_type': 'cash',  // ✅ NEW: Entry type
      'p_company_id': companyId,
      'p_location_id': locationId,
      'p_record_date': DateTimeUtils.toDateOnly(recordDate),
      'p_created_by': effectiveUserId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_description': 'Cash ending',
      'p_currencies': currenciesJson,
    };
  }

  /// Convert to Domain Entity
  CashEnding toEntity() {
    final effectiveUserId = userId ?? createdBy ?? '';

    return CashEnding(
      cashEndingId: cashEndingId,
      companyId: companyId,
      userId: effectiveUserId,
      locationId: locationId,
      storeId: storeId,
      recordDate: recordDate,
      createdAt: createdAt,
      currencies: currencies.map((c) => c.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory CashEndingDto.fromEntity(CashEnding entity) {
    return CashEndingDto(
      cashEndingId: entity.cashEndingId,
      companyId: entity.companyId,
      userId: entity.userId,
      locationId: entity.locationId,
      storeId: entity.storeId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
      currencies: entity.currencies
          .map((c) => CurrencyDto.fromEntity(c))
          .toList(),
    );
  }
}
