import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';

import '../../domain/entities/counter_party.dart';
import '../../domain/value_objects/counter_party_type.dart';

part 'counter_party_dto.freezed.dart';
part 'counter_party_dto.g.dart';

/// Counter Party DTO for JSON serialization
@freezed
class CounterPartyDto with _$CounterPartyDto {
  const CounterPartyDto._();

  const factory CounterPartyDto({
    @JsonKey(name: 'counterparty_id') required String counterpartyId,
    @JsonKey(name: 'company_id') required String companyId,
    required String name,
    @JsonKey(fromJson: counterPartyTypeFromJson, toJson: counterPartyTypeToJson)
    required CounterPartyType type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    @JsonKey(name: 'is_internal') @Default(false) bool isInternal,
    @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
    @JsonKey(name: 'linked_company_name') String? linkedCompanyName,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) required DateTime createdAt,
    @JsonKey(name: 'updated_at', includeIfNull: false, fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable) DateTime? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'last_transaction_date', fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable) DateTime? lastTransactionDate,
    @JsonKey(name: 'total_transactions') @Default(0) int totalTransactions,
    @JsonKey(name: 'balance') @Default(0.0) double balance,
  }) = _CounterPartyDto;

  factory CounterPartyDto.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyDtoFromJson(json);

  /// Convert to Domain Entity
  CounterParty toEntity() => CounterParty(
    counterpartyId: counterpartyId,
    companyId: companyId,
    name: name,
    type: type,
    email: email,
    phone: phone,
    address: address,
    notes: notes,
    isInternal: isInternal,
    linkedCompanyId: linkedCompanyId,
    linkedCompanyName: linkedCompanyName,
    createdBy: createdBy,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
    lastTransactionDate: lastTransactionDate,
    totalTransactions: totalTransactions,
    balance: balance,
  );

  /// Create DTO from Entity
  factory CounterPartyDto.fromEntity(CounterParty entity) => CounterPartyDto(
    counterpartyId: entity.counterpartyId,
    companyId: entity.companyId,
    name: entity.name,
    type: entity.type,
    email: entity.email,
    phone: entity.phone,
    address: entity.address,
    notes: entity.notes,
    isInternal: entity.isInternal,
    linkedCompanyId: entity.linkedCompanyId,
    linkedCompanyName: entity.linkedCompanyName,
    createdBy: entity.createdBy,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    isDeleted: entity.isDeleted,
    lastTransactionDate: entity.lastTransactionDate,
    totalTransactions: entity.totalTransactions,
    balance: entity.balance,
  );
}

// DateTime conversion helpers
DateTime _dateTimeFromJson(String value) => DateTimeUtils.toLocal(value);
String _dateTimeToJson(DateTime value) => DateTimeUtils.toUtc(value);
DateTime? _dateTimeFromJsonNullable(String? value) => DateTimeUtils.toLocalSafe(value);
String? _dateTimeToJsonNullable(DateTime? value) => value != null ? DateTimeUtils.toUtc(value) : null;
