// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CompaniesStruct extends BaseStruct {
  CompaniesStruct({
    RoleStruct? role,
    List<StoresStruct>? stores,
    String? companyId,
    int? storeCount,
    String? companyCode,
    String? companyName,
  })  : _role = role,
        _stores = stores,
        _companyId = companyId,
        _storeCount = storeCount,
        _companyCode = companyCode,
        _companyName = companyName;

  // "role" field.
  RoleStruct? _role;
  RoleStruct get role => _role ?? RoleStruct();
  set role(RoleStruct? val) => _role = val;

  void updateRole(Function(RoleStruct) updateFn) {
    updateFn(_role ??= RoleStruct());
  }

  bool hasRole() => _role != null;

  // "stores" field.
  List<StoresStruct>? _stores;
  List<StoresStruct> get stores => _stores ?? const [];
  set stores(List<StoresStruct>? val) => _stores = val;

  void updateStores(Function(List<StoresStruct>) updateFn) {
    updateFn(_stores ??= []);
  }

  bool hasStores() => _stores != null;

  // "company_id" field.
  String? _companyId;
  String get companyId => _companyId ?? '';
  set companyId(String? val) => _companyId = val;

  bool hasCompanyId() => _companyId != null;

  // "store_count" field.
  int? _storeCount;
  int get storeCount => _storeCount ?? 0;
  set storeCount(int? val) => _storeCount = val;

  void incrementStoreCount(int amount) => storeCount = storeCount + amount;

  bool hasStoreCount() => _storeCount != null;

  // "company_code" field.
  String? _companyCode;
  String get companyCode => _companyCode ?? '';
  set companyCode(String? val) => _companyCode = val;

  bool hasCompanyCode() => _companyCode != null;

  // "company_name" field.
  String? _companyName;
  String get companyName => _companyName ?? '';
  set companyName(String? val) => _companyName = val;

  bool hasCompanyName() => _companyName != null;

  static CompaniesStruct fromMap(Map<String, dynamic> data) => CompaniesStruct(
        role: data['role'] is RoleStruct
            ? data['role']
            : RoleStruct.maybeFromMap(data['role']),
        stores: getStructList(
          data['stores'],
          StoresStruct.fromMap,
        ),
        companyId: data['company_id'] as String?,
        storeCount: castToType<int>(data['store_count']),
        companyCode: data['company_code'] as String?,
        companyName: data['company_name'] as String?,
      );

  static CompaniesStruct? maybeFromMap(dynamic data) => data is Map
      ? CompaniesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'role': _role?.toMap(),
        'stores': _stores?.map((e) => e.toMap()).toList(),
        'company_id': _companyId,
        'store_count': _storeCount,
        'company_code': _companyCode,
        'company_name': _companyName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'role': serializeParam(
          _role,
          ParamType.DataStruct,
        ),
        'stores': serializeParam(
          _stores,
          ParamType.DataStruct,
          isList: true,
        ),
        'company_id': serializeParam(
          _companyId,
          ParamType.String,
        ),
        'store_count': serializeParam(
          _storeCount,
          ParamType.int,
        ),
        'company_code': serializeParam(
          _companyCode,
          ParamType.String,
        ),
        'company_name': serializeParam(
          _companyName,
          ParamType.String,
        ),
      }.withoutNulls;

  static CompaniesStruct fromSerializableMap(Map<String, dynamic> data) =>
      CompaniesStruct(
        role: deserializeStructParam(
          data['role'],
          ParamType.DataStruct,
          false,
          structBuilder: RoleStruct.fromSerializableMap,
        ),
        stores: deserializeStructParam<StoresStruct>(
          data['stores'],
          ParamType.DataStruct,
          true,
          structBuilder: StoresStruct.fromSerializableMap,
        ),
        companyId: deserializeParam(
          data['company_id'],
          ParamType.String,
          false,
        ),
        storeCount: deserializeParam(
          data['store_count'],
          ParamType.int,
          false,
        ),
        companyCode: deserializeParam(
          data['company_code'],
          ParamType.String,
          false,
        ),
        companyName: deserializeParam(
          data['company_name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CompaniesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CompaniesStruct &&
        role == other.role &&
        listEquality.equals(stores, other.stores) &&
        companyId == other.companyId &&
        storeCount == other.storeCount &&
        companyCode == other.companyCode &&
        companyName == other.companyName;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([role, stores, companyId, storeCount, companyCode, companyName]);
}

CompaniesStruct createCompaniesStruct({
  RoleStruct? role,
  String? companyId,
  int? storeCount,
  String? companyCode,
  String? companyName,
}) =>
    CompaniesStruct(
      role: role ?? RoleStruct(),
      companyId: companyId,
      storeCount: storeCount,
      companyCode: companyCode,
      companyName: companyName,
    );
