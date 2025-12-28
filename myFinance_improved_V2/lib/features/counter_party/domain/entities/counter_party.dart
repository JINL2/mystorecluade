import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/counter_party_type.dart';

part 'counter_party.freezed.dart';

/// Main Counter Party Entity (Pure Domain - No JSON)
@freezed
class CounterParty with _$CounterParty {
  const CounterParty._();

  const factory CounterParty({
    required String counterpartyId,
    required String companyId,
    required String name,
    required CounterPartyType type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    @Default(false) bool isInternal,
    String? linkedCompanyId,
    String? linkedCompanyName,
    String? createdBy,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(false) bool isDeleted,
    DateTime? lastTransactionDate,
    @Default(0) int totalTransactions,
    @Default(0.0) double balance,
  }) = _CounterParty;
}
