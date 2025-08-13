// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CashAmountLineStruct extends BaseStruct {
  CashAmountLineStruct({
    String? companyId,
    String? storeId,
    String? locationId,
    String? recordDate,
    String? pCreatedBy,
    List<CurrenciesStruct>? currencies,
  })  : _companyId = companyId,
        _storeId = storeId,
        _locationId = locationId,
        _recordDate = recordDate,
        _pCreatedBy = pCreatedBy,
        _currencies = currencies;

  // "company_id" field.
  String? _companyId;
  String get companyId => _companyId ?? '';
  set companyId(String? val) => _companyId = val;

  bool hasCompanyId() => _companyId != null;

  // "store_id" field.
  String? _storeId;
  String get storeId => _storeId ?? '';
  set storeId(String? val) => _storeId = val;

  bool hasStoreId() => _storeId != null;

  // "location_id" field.
  String? _locationId;
  String get locationId => _locationId ?? '';
  set locationId(String? val) => _locationId = val;

  bool hasLocationId() => _locationId != null;

  // "record_date" field.
  String? _recordDate;
  String get recordDate => _recordDate ?? '';
  set recordDate(String? val) => _recordDate = val;

  bool hasRecordDate() => _recordDate != null;

  // "p_created_by" field.
  String? _pCreatedBy;
  String get pCreatedBy => _pCreatedBy ?? '';
  set pCreatedBy(String? val) => _pCreatedBy = val;

  bool hasPCreatedBy() => _pCreatedBy != null;

  // "currencies" field.
  List<CurrenciesStruct>? _currencies;
  List<CurrenciesStruct> get currencies => _currencies ?? const [];
  set currencies(List<CurrenciesStruct>? val) => _currencies = val;

  void updateCurrencies(Function(List<CurrenciesStruct>) updateFn) {
    updateFn(_currencies ??= []);
  }

  bool hasCurrencies() => _currencies != null;

  static CashAmountLineStruct fromMap(Map<String, dynamic> data) =>
      CashAmountLineStruct(
        companyId: data['company_id'] as String?,
        storeId: data['store_id'] as String?,
        locationId: data['location_id'] as String?,
        recordDate: data['record_date'] as String?,
        pCreatedBy: data['p_created_by'] as String?,
        currencies: getStructList(
          data['currencies'],
          CurrenciesStruct.fromMap,
        ),
      );

  static CashAmountLineStruct? maybeFromMap(dynamic data) => data is Map
      ? CashAmountLineStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'company_id': _companyId,
        'store_id': _storeId,
        'location_id': _locationId,
        'record_date': _recordDate,
        'p_created_by': _pCreatedBy,
        'currencies': _currencies?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'company_id': serializeParam(
          _companyId,
          ParamType.String,
        ),
        'store_id': serializeParam(
          _storeId,
          ParamType.String,
        ),
        'location_id': serializeParam(
          _locationId,
          ParamType.String,
        ),
        'record_date': serializeParam(
          _recordDate,
          ParamType.String,
        ),
        'p_created_by': serializeParam(
          _pCreatedBy,
          ParamType.String,
        ),
        'currencies': serializeParam(
          _currencies,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static CashAmountLineStruct fromSerializableMap(Map<String, dynamic> data) =>
      CashAmountLineStruct(
        companyId: deserializeParam(
          data['company_id'],
          ParamType.String,
          false,
        ),
        storeId: deserializeParam(
          data['store_id'],
          ParamType.String,
          false,
        ),
        locationId: deserializeParam(
          data['location_id'],
          ParamType.String,
          false,
        ),
        recordDate: deserializeParam(
          data['record_date'],
          ParamType.String,
          false,
        ),
        pCreatedBy: deserializeParam(
          data['p_created_by'],
          ParamType.String,
          false,
        ),
        currencies: deserializeStructParam<CurrenciesStruct>(
          data['currencies'],
          ParamType.DataStruct,
          true,
          structBuilder: CurrenciesStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CashAmountLineStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CashAmountLineStruct &&
        companyId == other.companyId &&
        storeId == other.storeId &&
        locationId == other.locationId &&
        recordDate == other.recordDate &&
        pCreatedBy == other.pCreatedBy &&
        listEquality.equals(currencies, other.currencies);
  }

  @override
  int get hashCode => const ListEquality().hash(
      [companyId, storeId, locationId, recordDate, pCreatedBy, currencies]);
}

CashAmountLineStruct createCashAmountLineStruct({
  String? companyId,
  String? storeId,
  String? locationId,
  String? recordDate,
  String? pCreatedBy,
}) =>
    CashAmountLineStruct(
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      recordDate: recordDate,
      pCreatedBy: pCreatedBy,
    );
