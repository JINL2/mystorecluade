// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CashStruct extends BaseStruct {
  CashStruct({
    String? cashLocationId,
    String? cashLocationName,
  })  : _cashLocationId = cashLocationId,
        _cashLocationName = cashLocationName;

  // "cash_location_id" field.
  String? _cashLocationId;
  String get cashLocationId => _cashLocationId ?? '';
  set cashLocationId(String? val) => _cashLocationId = val;

  bool hasCashLocationId() => _cashLocationId != null;

  // "cash_location_name" field.
  String? _cashLocationName;
  String get cashLocationName => _cashLocationName ?? '';
  set cashLocationName(String? val) => _cashLocationName = val;

  bool hasCashLocationName() => _cashLocationName != null;

  static CashStruct fromMap(Map<String, dynamic> data) => CashStruct(
        cashLocationId: data['cash_location_id'] as String?,
        cashLocationName: data['cash_location_name'] as String?,
      );

  static CashStruct? maybeFromMap(dynamic data) =>
      data is Map ? CashStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'cash_location_id': _cashLocationId,
        'cash_location_name': _cashLocationName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'cash_location_id': serializeParam(
          _cashLocationId,
          ParamType.String,
        ),
        'cash_location_name': serializeParam(
          _cashLocationName,
          ParamType.String,
        ),
      }.withoutNulls;

  static CashStruct fromSerializableMap(Map<String, dynamic> data) =>
      CashStruct(
        cashLocationId: deserializeParam(
          data['cash_location_id'],
          ParamType.String,
          false,
        ),
        cashLocationName: deserializeParam(
          data['cash_location_name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CashStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CashStruct &&
        cashLocationId == other.cashLocationId &&
        cashLocationName == other.cashLocationName;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([cashLocationId, cashLocationName]);
}

CashStruct createCashStruct({
  String? cashLocationId,
  String? cashLocationName,
}) =>
    CashStruct(
      cashLocationId: cashLocationId,
      cashLocationName: cashLocationName,
    );
