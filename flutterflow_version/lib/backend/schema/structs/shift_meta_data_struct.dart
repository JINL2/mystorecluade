// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShiftMetaDataStruct extends BaseStruct {
  ShiftMetaDataStruct({
    String? shiftId,
    String? storeId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
  })  : _shiftId = shiftId,
        _storeId = storeId,
        _shiftName = shiftName,
        _startTime = startTime,
        _endTime = endTime,
        _numberShift = numberShift;

  // "shift_id" field.
  String? _shiftId;
  String get shiftId => _shiftId ?? '';
  set shiftId(String? val) => _shiftId = val;

  bool hasShiftId() => _shiftId != null;

  // "store_id" field.
  String? _storeId;
  String get storeId => _storeId ?? '';
  set storeId(String? val) => _storeId = val;

  bool hasStoreId() => _storeId != null;

  // "shift_name" field.
  String? _shiftName;
  String get shiftName => _shiftName ?? '';
  set shiftName(String? val) => _shiftName = val;

  bool hasShiftName() => _shiftName != null;

  // "start_time" field.
  String? _startTime;
  String get startTime => _startTime ?? '';
  set startTime(String? val) => _startTime = val;

  bool hasStartTime() => _startTime != null;

  // "end_time" field.
  String? _endTime;
  String get endTime => _endTime ?? '';
  set endTime(String? val) => _endTime = val;

  bool hasEndTime() => _endTime != null;

  // "number_shift" field.
  int? _numberShift;
  int get numberShift => _numberShift ?? 0;
  set numberShift(int? val) => _numberShift = val;

  void incrementNumberShift(int amount) => numberShift = numberShift + amount;

  bool hasNumberShift() => _numberShift != null;

  static ShiftMetaDataStruct fromMap(Map<String, dynamic> data) =>
      ShiftMetaDataStruct(
        shiftId: data['shift_id'] as String?,
        storeId: data['store_id'] as String?,
        shiftName: data['shift_name'] as String?,
        startTime: data['start_time'] as String?,
        endTime: data['end_time'] as String?,
        numberShift: castToType<int>(data['number_shift']),
      );

  static ShiftMetaDataStruct? maybeFromMap(dynamic data) => data is Map
      ? ShiftMetaDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'shift_id': _shiftId,
        'store_id': _storeId,
        'shift_name': _shiftName,
        'start_time': _startTime,
        'end_time': _endTime,
        'number_shift': _numberShift,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'shift_id': serializeParam(
          _shiftId,
          ParamType.String,
        ),
        'store_id': serializeParam(
          _storeId,
          ParamType.String,
        ),
        'shift_name': serializeParam(
          _shiftName,
          ParamType.String,
        ),
        'start_time': serializeParam(
          _startTime,
          ParamType.String,
        ),
        'end_time': serializeParam(
          _endTime,
          ParamType.String,
        ),
        'number_shift': serializeParam(
          _numberShift,
          ParamType.int,
        ),
      }.withoutNulls;

  static ShiftMetaDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      ShiftMetaDataStruct(
        shiftId: deserializeParam(
          data['shift_id'],
          ParamType.String,
          false,
        ),
        storeId: deserializeParam(
          data['store_id'],
          ParamType.String,
          false,
        ),
        shiftName: deserializeParam(
          data['shift_name'],
          ParamType.String,
          false,
        ),
        startTime: deserializeParam(
          data['start_time'],
          ParamType.String,
          false,
        ),
        endTime: deserializeParam(
          data['end_time'],
          ParamType.String,
          false,
        ),
        numberShift: deserializeParam(
          data['number_shift'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ShiftMetaDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ShiftMetaDataStruct &&
        shiftId == other.shiftId &&
        storeId == other.storeId &&
        shiftName == other.shiftName &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        numberShift == other.numberShift;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([shiftId, storeId, shiftName, startTime, endTime, numberShift]);
}

ShiftMetaDataStruct createShiftMetaDataStruct({
  String? shiftId,
  String? storeId,
  String? shiftName,
  String? startTime,
  String? endTime,
  int? numberShift,
}) =>
    ShiftMetaDataStruct(
      shiftId: shiftId,
      storeId: storeId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      numberShift: numberShift,
    );
