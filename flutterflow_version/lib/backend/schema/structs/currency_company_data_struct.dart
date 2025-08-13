// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CurrencyCompanyDataStruct extends BaseStruct {
  CurrencyCompanyDataStruct({
    String? currencyValue,
    String? currencySymbol,
  })  : _currencyValue = currencyValue,
        _currencySymbol = currencySymbol;

  // "currencyValue" field.
  String? _currencyValue;
  String get currencyValue => _currencyValue ?? '';
  set currencyValue(String? val) => _currencyValue = val;

  bool hasCurrencyValue() => _currencyValue != null;

  // "currencySymbol" field.
  String? _currencySymbol;
  String get currencySymbol => _currencySymbol ?? '';
  set currencySymbol(String? val) => _currencySymbol = val;

  bool hasCurrencySymbol() => _currencySymbol != null;

  static CurrencyCompanyDataStruct fromMap(Map<String, dynamic> data) =>
      CurrencyCompanyDataStruct(
        currencyValue: data['currencyValue'] as String?,
        currencySymbol: data['currencySymbol'] as String?,
      );

  static CurrencyCompanyDataStruct? maybeFromMap(dynamic data) => data is Map
      ? CurrencyCompanyDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'currencyValue': _currencyValue,
        'currencySymbol': _currencySymbol,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'currencyValue': serializeParam(
          _currencyValue,
          ParamType.String,
        ),
        'currencySymbol': serializeParam(
          _currencySymbol,
          ParamType.String,
        ),
      }.withoutNulls;

  static CurrencyCompanyDataStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CurrencyCompanyDataStruct(
        currencyValue: deserializeParam(
          data['currencyValue'],
          ParamType.String,
          false,
        ),
        currencySymbol: deserializeParam(
          data['currencySymbol'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CurrencyCompanyDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CurrencyCompanyDataStruct &&
        currencyValue == other.currencyValue &&
        currencySymbol == other.currencySymbol;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([currencyValue, currencySymbol]);
}

CurrencyCompanyDataStruct createCurrencyCompanyDataStruct({
  String? currencyValue,
  String? currencySymbol,
}) =>
    CurrencyCompanyDataStruct(
      currencyValue: currencyValue,
      currencySymbol: currencySymbol,
    );
