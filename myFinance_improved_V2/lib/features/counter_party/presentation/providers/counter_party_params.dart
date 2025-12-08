import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/value_objects/counter_party_type.dart';

part 'counter_party_params.freezed.dart';

/// Parameters for creating a counter party
@freezed
class CreateCounterPartyParams with _$CreateCounterPartyParams {
  const factory CreateCounterPartyParams({
    required String companyId,
    required String name,
    required CounterPartyType type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    @Default(false) bool isInternal,
    String? linkedCompanyId,
  }) = _CreateCounterPartyParams;
}

/// Parameters for updating a counter party
@freezed
class UpdateCounterPartyParams with _$UpdateCounterPartyParams {
  const factory UpdateCounterPartyParams({
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
  }) = _UpdateCounterPartyParams;
}
