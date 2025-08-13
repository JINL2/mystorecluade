// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StoresStruct extends BaseStruct {
  StoresStruct({
    String? storeId,
    String? storeCode,
    String? storeName,
    String? storePhone,
  })  : _storeId = storeId,
        _storeCode = storeCode,
        _storeName = storeName,
        _storePhone = storePhone;

  // "store_id" field.
  String? _storeId;
  String get storeId => _storeId ?? '';
  set storeId(String? val) => _storeId = val;

  bool hasStoreId() => _storeId != null;

  // "store_code" field.
  String? _storeCode;
  String get storeCode => _storeCode ?? '';
  set storeCode(String? val) => _storeCode = val;

  bool hasStoreCode() => _storeCode != null;

  // "store_name" field.
  String? _storeName;
  String get storeName => _storeName ?? '';
  set storeName(String? val) => _storeName = val;

  bool hasStoreName() => _storeName != null;

  // "store_phone" field.
  String? _storePhone;
  String get storePhone => _storePhone ?? '';
  set storePhone(String? val) => _storePhone = val;

  bool hasStorePhone() => _storePhone != null;

  static StoresStruct fromMap(Map<String, dynamic> data) => StoresStruct(
        storeId: data['store_id'] as String?,
        storeCode: data['store_code'] as String?,
        storeName: data['store_name'] as String?,
        storePhone: data['store_phone'] as String?,
      );

  static StoresStruct? maybeFromMap(dynamic data) =>
      data is Map ? StoresStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'store_id': _storeId,
        'store_code': _storeCode,
        'store_name': _storeName,
        'store_phone': _storePhone,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'store_id': serializeParam(
          _storeId,
          ParamType.String,
        ),
        'store_code': serializeParam(
          _storeCode,
          ParamType.String,
        ),
        'store_name': serializeParam(
          _storeName,
          ParamType.String,
        ),
        'store_phone': serializeParam(
          _storePhone,
          ParamType.String,
        ),
      }.withoutNulls;

  static StoresStruct fromSerializableMap(Map<String, dynamic> data) =>
      StoresStruct(
        storeId: deserializeParam(
          data['store_id'],
          ParamType.String,
          false,
        ),
        storeCode: deserializeParam(
          data['store_code'],
          ParamType.String,
          false,
        ),
        storeName: deserializeParam(
          data['store_name'],
          ParamType.String,
          false,
        ),
        storePhone: deserializeParam(
          data['store_phone'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StoresStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StoresStruct &&
        storeId == other.storeId &&
        storeCode == other.storeCode &&
        storeName == other.storeName &&
        storePhone == other.storePhone;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([storeId, storeCode, storeName, storePhone]);
}

StoresStruct createStoresStruct({
  String? storeId,
  String? storeCode,
  String? storeName,
  String? storePhone,
}) =>
    StoresStruct(
      storeId: storeId,
      storeCode: storeCode,
      storeName: storeName,
      storePhone: storePhone,
    );
