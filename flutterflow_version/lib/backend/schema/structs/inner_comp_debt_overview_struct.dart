// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InnerCompDebtOverviewStruct extends BaseStruct {
  InnerCompDebtOverviewStruct({
    String? storeId,
    String? storeName,
    int? netValue,
    bool? isHeadOffice,
  })  : _storeId = storeId,
        _storeName = storeName,
        _netValue = netValue,
        _isHeadOffice = isHeadOffice;

  // "store_id" field.
  String? _storeId;
  String get storeId => _storeId ?? '';
  set storeId(String? val) => _storeId = val;

  bool hasStoreId() => _storeId != null;

  // "store_name" field.
  String? _storeName;
  String get storeName => _storeName ?? '';
  set storeName(String? val) => _storeName = val;

  bool hasStoreName() => _storeName != null;

  // "net_value" field.
  int? _netValue;
  int get netValue => _netValue ?? 0;
  set netValue(int? val) => _netValue = val;

  void incrementNetValue(int amount) => netValue = netValue + amount;

  bool hasNetValue() => _netValue != null;

  // "is_head_office" field.
  bool? _isHeadOffice;
  bool get isHeadOffice => _isHeadOffice ?? false;
  set isHeadOffice(bool? val) => _isHeadOffice = val;

  bool hasIsHeadOffice() => _isHeadOffice != null;

  static InnerCompDebtOverviewStruct fromMap(Map<String, dynamic> data) =>
      InnerCompDebtOverviewStruct(
        storeId: data['store_id'] as String?,
        storeName: data['store_name'] as String?,
        netValue: castToType<int>(data['net_value']),
        isHeadOffice: data['is_head_office'] as bool?,
      );

  static InnerCompDebtOverviewStruct? maybeFromMap(dynamic data) => data is Map
      ? InnerCompDebtOverviewStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'store_id': _storeId,
        'store_name': _storeName,
        'net_value': _netValue,
        'is_head_office': _isHeadOffice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'store_id': serializeParam(
          _storeId,
          ParamType.String,
        ),
        'store_name': serializeParam(
          _storeName,
          ParamType.String,
        ),
        'net_value': serializeParam(
          _netValue,
          ParamType.int,
        ),
        'is_head_office': serializeParam(
          _isHeadOffice,
          ParamType.bool,
        ),
      }.withoutNulls;

  static InnerCompDebtOverviewStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      InnerCompDebtOverviewStruct(
        storeId: deserializeParam(
          data['store_id'],
          ParamType.String,
          false,
        ),
        storeName: deserializeParam(
          data['store_name'],
          ParamType.String,
          false,
        ),
        netValue: deserializeParam(
          data['net_value'],
          ParamType.int,
          false,
        ),
        isHeadOffice: deserializeParam(
          data['is_head_office'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'InnerCompDebtOverviewStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is InnerCompDebtOverviewStruct &&
        storeId == other.storeId &&
        storeName == other.storeName &&
        netValue == other.netValue &&
        isHeadOffice == other.isHeadOffice;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([storeId, storeName, netValue, isHeadOffice]);
}

InnerCompDebtOverviewStruct createInnerCompDebtOverviewStruct({
  String? storeId,
  String? storeName,
  int? netValue,
  bool? isHeadOffice,
}) =>
    InnerCompDebtOverviewStruct(
      storeId: storeId,
      storeName: storeName,
      netValue: netValue,
      isHeadOffice: isHeadOffice,
    );
