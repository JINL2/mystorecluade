import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../value_objects/counter_party_type.dart';

part 'counter_party.freezed.dart';
part 'counter_party.g.dart';

/// Main Counter Party Entity
@freezed
class CounterParty with _$CounterParty {
  const CounterParty._();

  const factory CounterParty({
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
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) required DateTime createdAt,
    @JsonKey(name: 'updated_at', includeIfNull: false, fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable) DateTime? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    // Additional fields for enhanced functionality
    @JsonKey(name: 'last_transaction_date', fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable) DateTime? lastTransactionDate,
    @JsonKey(name: 'total_transactions') @Default(0) int totalTransactions,
    @JsonKey(name: 'balance') @Default(0.0) double balance,
  }) = _CounterParty;

  factory CounterParty.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyFromJson(json);
}

// ✅ DB에서 읽을 때: UTC → 로컬 타임으로 변환
DateTime _dateTimeFromJson(String value) => DateTimeUtils.toLocal(value);

// ✅ DB에 저장할 때: 로컬 타임 → UTC로 변환
String _dateTimeToJson(DateTime value) => DateTimeUtils.toUtc(value);

// ✅ Nullable 버전
DateTime? _dateTimeFromJsonNullable(String? value) => DateTimeUtils.toLocalSafe(value);

String? _dateTimeToJsonNullable(DateTime? value) => value != null ? DateTimeUtils.toUtc(value) : null;
