// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CounterPartyDebtStruct extends BaseStruct {
  CounterPartyDebtStruct({
    String? counterpartyId,
    String? name,
    int? netValue,
    bool? isInner,
    bool? isCompanyDebt,
  })  : _counterpartyId = counterpartyId,
        _name = name,
        _netValue = netValue,
        _isInner = isInner,
        _isCompanyDebt = isCompanyDebt;

  // "counterparty_id" field.
  String? _counterpartyId;
  String get counterpartyId => _counterpartyId ?? '';
  set counterpartyId(String? val) => _counterpartyId = val;

  bool hasCounterpartyId() => _counterpartyId != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "net_value" field.
  int? _netValue;
  int get netValue => _netValue ?? 0;
  set netValue(int? val) => _netValue = val;

  void incrementNetValue(int amount) => netValue = netValue + amount;

  bool hasNetValue() => _netValue != null;

  // "is_inner" field.
  bool? _isInner;
  bool get isInner => _isInner ?? false;
  set isInner(bool? val) => _isInner = val;

  bool hasIsInner() => _isInner != null;

  // "is_company_debt" field.
  bool? _isCompanyDebt;
  bool get isCompanyDebt => _isCompanyDebt ?? false;
  set isCompanyDebt(bool? val) => _isCompanyDebt = val;

  bool hasIsCompanyDebt() => _isCompanyDebt != null;

  static CounterPartyDebtStruct fromMap(Map<String, dynamic> data) =>
      CounterPartyDebtStruct(
        counterpartyId: data['counterparty_id'] as String?,
        name: data['name'] as String?,
        netValue: castToType<int>(data['net_value']),
        isInner: data['is_inner'] as bool?,
        isCompanyDebt: data['is_company_debt'] as bool?,
      );

  static CounterPartyDebtStruct? maybeFromMap(dynamic data) => data is Map
      ? CounterPartyDebtStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'counterparty_id': _counterpartyId,
        'name': _name,
        'net_value': _netValue,
        'is_inner': _isInner,
        'is_company_debt': _isCompanyDebt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'counterparty_id': serializeParam(
          _counterpartyId,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'net_value': serializeParam(
          _netValue,
          ParamType.int,
        ),
        'is_inner': serializeParam(
          _isInner,
          ParamType.bool,
        ),
        'is_company_debt': serializeParam(
          _isCompanyDebt,
          ParamType.bool,
        ),
      }.withoutNulls;

  static CounterPartyDebtStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CounterPartyDebtStruct(
        counterpartyId: deserializeParam(
          data['counterparty_id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        netValue: deserializeParam(
          data['net_value'],
          ParamType.int,
          false,
        ),
        isInner: deserializeParam(
          data['is_inner'],
          ParamType.bool,
          false,
        ),
        isCompanyDebt: deserializeParam(
          data['is_company_debt'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'CounterPartyDebtStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CounterPartyDebtStruct &&
        counterpartyId == other.counterpartyId &&
        name == other.name &&
        netValue == other.netValue &&
        isInner == other.isInner &&
        isCompanyDebt == other.isCompanyDebt;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([counterpartyId, name, netValue, isInner, isCompanyDebt]);
}

CounterPartyDebtStruct createCounterPartyDebtStruct({
  String? counterpartyId,
  String? name,
  int? netValue,
  bool? isInner,
  bool? isCompanyDebt,
}) =>
    CounterPartyDebtStruct(
      counterpartyId: counterpartyId,
      name: name,
      netValue: netValue,
      isInner: isInner,
      isCompanyDebt: isCompanyDebt,
    );
