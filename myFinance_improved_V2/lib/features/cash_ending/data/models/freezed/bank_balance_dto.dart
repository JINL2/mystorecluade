import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/bank_balance.dart';

part 'bank_balance_dto.freezed.dart';
part 'bank_balance_dto.g.dart';

/// Bank Balance DTO
///
/// Maps to DB table: bank_amount
/// Handles JSON serialization/deserialization and RPC parameter formatting
@freezed
class BankBalanceDto with _$BankBalanceDto {
  const BankBalanceDto._();

  const factory BankBalanceDto({
    @JsonKey(name: 'bank_amount_id') String? balanceId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'total_amount') required int totalAmount,
    @JsonKey(name: 'created_by') required String userId,
    @JsonKey(name: 'record_date') required DateTime recordDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BankBalanceDto;

  factory BankBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$BankBalanceDtoFromJson(json);

  /// Convert to RPC parameters for Supabase (bank_amount_insert_v2)
  ///
  /// This matches the exact format expected by the stored procedure
  Map<String, dynamic> toRpcParams() {
    // Format dates as required by RPC
    final recordDateStr = DateFormat('yyyy-MM-dd').format(recordDate);
    final createdAtStr = '${DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt)}.${createdAt.microsecond.toString().padLeft(6, '0')}';

    return {
      'p_company_id': companyId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_record_date': recordDateStr,
      'p_location_id': locationId,
      'p_currency_id': currencyId,
      'p_total_amount': totalAmount,
      'p_created_by': userId,
      'p_created_at': createdAtStr,
    };
  }

  /// Convert to Domain Entity
  BankBalance toEntity() {
    return BankBalance(
      balanceId: balanceId,
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      currencyId: currencyId,
      totalAmount: totalAmount,
      userId: userId,
      recordDate: recordDate,
      createdAt: createdAt,
    );
  }

  /// Create from Domain Entity
  factory BankBalanceDto.fromEntity(BankBalance entity) {
    return BankBalanceDto(
      balanceId: entity.balanceId,
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      currencyId: entity.currencyId,
      totalAmount: entity.totalAmount,
      userId: entity.userId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
    );
  }
}
