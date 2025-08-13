// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CashEndingStruct extends BaseStruct {
  CashEndingStruct({
    String? companyId,
    String? storeId,
    List<String>? locationId,
    DateTime? recordDate,
    List<int>? denomination,
    List<int>? quantity,
    String? createBy,
  })  : _companyId = companyId,
        _storeId = storeId,
        _locationId = locationId,
        _recordDate = recordDate,
        _denomination = denomination,
        _quantity = quantity,
        _createBy = createBy;

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
  List<String>? _locationId;
  List<String> get locationId => _locationId ?? const [];
  set locationId(List<String>? val) => _locationId = val;

  void updateLocationId(Function(List<String>) updateFn) {
    updateFn(_locationId ??= []);
  }

  bool hasLocationId() => _locationId != null;

  // "record_date" field.
  DateTime? _recordDate;
  DateTime? get recordDate => _recordDate;
  set recordDate(DateTime? val) => _recordDate = val;

  bool hasRecordDate() => _recordDate != null;

  // "denomination" field.
  List<int>? _denomination;
  List<int> get denomination => _denomination ?? const [];
  set denomination(List<int>? val) => _denomination = val;

  void updateDenomination(Function(List<int>) updateFn) {
    updateFn(_denomination ??= []);
  }

  bool hasDenomination() => _denomination != null;

  // "quantity" field.
  List<int>? _quantity;
  List<int> get quantity => _quantity ?? const [];
  set quantity(List<int>? val) => _quantity = val;

  void updateQuantity(Function(List<int>) updateFn) {
    updateFn(_quantity ??= []);
  }

  bool hasQuantity() => _quantity != null;

  // "create_by" field.
  String? _createBy;
  String get createBy => _createBy ?? '';
  set createBy(String? val) => _createBy = val;

  bool hasCreateBy() => _createBy != null;

  static CashEndingStruct fromMap(Map<String, dynamic> data) =>
      CashEndingStruct(
        companyId: data['company_id'] as String?,
        storeId: data['store_id'] as String?,
        locationId: getDataList(data['location_id']),
        recordDate: data['record_date'] as DateTime?,
        denomination: getDataList(data['denomination']),
        quantity: getDataList(data['quantity']),
        createBy: data['create_by'] as String?,
      );

  static CashEndingStruct? maybeFromMap(dynamic data) => data is Map
      ? CashEndingStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'company_id': _companyId,
        'store_id': _storeId,
        'location_id': _locationId,
        'record_date': _recordDate,
        'denomination': _denomination,
        'quantity': _quantity,
        'create_by': _createBy,
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
          isList: true,
        ),
        'record_date': serializeParam(
          _recordDate,
          ParamType.DateTime,
        ),
        'denomination': serializeParam(
          _denomination,
          ParamType.int,
          isList: true,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
          isList: true,
        ),
        'create_by': serializeParam(
          _createBy,
          ParamType.String,
        ),
      }.withoutNulls;

  static CashEndingStruct fromSerializableMap(Map<String, dynamic> data) =>
      CashEndingStruct(
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
        locationId: deserializeParam<String>(
          data['location_id'],
          ParamType.String,
          true,
        ),
        recordDate: deserializeParam(
          data['record_date'],
          ParamType.DateTime,
          false,
        ),
        denomination: deserializeParam<int>(
          data['denomination'],
          ParamType.int,
          true,
        ),
        quantity: deserializeParam<int>(
          data['quantity'],
          ParamType.int,
          true,
        ),
        createBy: deserializeParam(
          data['create_by'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CashEndingStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CashEndingStruct &&
        companyId == other.companyId &&
        storeId == other.storeId &&
        listEquality.equals(locationId, other.locationId) &&
        recordDate == other.recordDate &&
        listEquality.equals(denomination, other.denomination) &&
        listEquality.equals(quantity, other.quantity) &&
        createBy == other.createBy;
  }

  @override
  int get hashCode => const ListEquality().hash([
        companyId,
        storeId,
        locationId,
        recordDate,
        denomination,
        quantity,
        createBy
      ]);
}

CashEndingStruct createCashEndingStruct({
  String? companyId,
  String? storeId,
  DateTime? recordDate,
  String? createBy,
}) =>
    CashEndingStruct(
      companyId: companyId,
      storeId: storeId,
      recordDate: recordDate,
      createBy: createBy,
    );
