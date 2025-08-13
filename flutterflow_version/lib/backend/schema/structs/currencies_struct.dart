// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CurrenciesStruct extends BaseStruct {
  CurrenciesStruct({
    String? currencyId,
    List<DenominationsStruct>? denominations,
  })  : _currencyId = currencyId,
        _denominations = denominations;

  // "currency_id" field.
  String? _currencyId;
  String get currencyId => _currencyId ?? '';
  set currencyId(String? val) => _currencyId = val;

  bool hasCurrencyId() => _currencyId != null;

  // "denominations" field.
  List<DenominationsStruct>? _denominations;
  List<DenominationsStruct> get denominations => _denominations ?? const [];
  set denominations(List<DenominationsStruct>? val) => _denominations = val;

  void updateDenominations(Function(List<DenominationsStruct>) updateFn) {
    updateFn(_denominations ??= []);
  }

  bool hasDenominations() => _denominations != null;

  static CurrenciesStruct fromMap(Map<String, dynamic> data) =>
      CurrenciesStruct(
        currencyId: data['currency_id'] as String?,
        denominations: getStructList(
          data['denominations'],
          DenominationsStruct.fromMap,
        ),
      );

  static CurrenciesStruct? maybeFromMap(dynamic data) => data is Map
      ? CurrenciesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'currency_id': _currencyId,
        'denominations': _denominations?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'currency_id': serializeParam(
          _currencyId,
          ParamType.String,
        ),
        'denominations': serializeParam(
          _denominations,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static CurrenciesStruct fromSerializableMap(Map<String, dynamic> data) =>
      CurrenciesStruct(
        currencyId: deserializeParam(
          data['currency_id'],
          ParamType.String,
          false,
        ),
        denominations: deserializeStructParam<DenominationsStruct>(
          data['denominations'],
          ParamType.DataStruct,
          true,
          structBuilder: DenominationsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CurrenciesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CurrenciesStruct &&
        currencyId == other.currencyId &&
        listEquality.equals(denominations, other.denominations);
  }

  @override
  int get hashCode => const ListEquality().hash([currencyId, denominations]);
}

CurrenciesStruct createCurrenciesStruct({
  String? currencyId,
}) =>
    CurrenciesStruct(
      currencyId: currencyId,
    );
