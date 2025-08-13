// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GetTodayPlusMinusStruct extends BaseStruct {
  GetTodayPlusMinusStruct({
    DateTime? dateM2,
    String? dayM2,
    DateTime? dateM1,
    String? dayM1,
    DateTime? date0,
    String? day0,
    DateTime? datetmw,
    String? daytmw,
    DateTime? datetmw2,
    String? daytmw2,
  })  : _dateM2 = dateM2,
        _dayM2 = dayM2,
        _dateM1 = dateM1,
        _dayM1 = dayM1,
        _date0 = date0,
        _day0 = day0,
        _datetmw = datetmw,
        _daytmw = daytmw,
        _datetmw2 = datetmw2,
        _daytmw2 = daytmw2;

  // "dateM2" field.
  DateTime? _dateM2;
  DateTime? get dateM2 => _dateM2;
  set dateM2(DateTime? val) => _dateM2 = val;

  bool hasDateM2() => _dateM2 != null;

  // "dayM2" field.
  String? _dayM2;
  String get dayM2 => _dayM2 ?? '';
  set dayM2(String? val) => _dayM2 = val;

  bool hasDayM2() => _dayM2 != null;

  // "dateM1" field.
  DateTime? _dateM1;
  DateTime? get dateM1 => _dateM1;
  set dateM1(DateTime? val) => _dateM1 = val;

  bool hasDateM1() => _dateM1 != null;

  // "dayM1" field.
  String? _dayM1;
  String get dayM1 => _dayM1 ?? '';
  set dayM1(String? val) => _dayM1 = val;

  bool hasDayM1() => _dayM1 != null;

  // "date0" field.
  DateTime? _date0;
  DateTime? get date0 => _date0;
  set date0(DateTime? val) => _date0 = val;

  bool hasDate0() => _date0 != null;

  // "day0" field.
  String? _day0;
  String get day0 => _day0 ?? '';
  set day0(String? val) => _day0 = val;

  bool hasDay0() => _day0 != null;

  // "datetmw" field.
  DateTime? _datetmw;
  DateTime? get datetmw => _datetmw;
  set datetmw(DateTime? val) => _datetmw = val;

  bool hasDatetmw() => _datetmw != null;

  // "daytmw" field.
  String? _daytmw;
  String get daytmw => _daytmw ?? '';
  set daytmw(String? val) => _daytmw = val;

  bool hasDaytmw() => _daytmw != null;

  // "datetmw2" field.
  DateTime? _datetmw2;
  DateTime? get datetmw2 => _datetmw2;
  set datetmw2(DateTime? val) => _datetmw2 = val;

  bool hasDatetmw2() => _datetmw2 != null;

  // "daytmw2" field.
  String? _daytmw2;
  String get daytmw2 => _daytmw2 ?? '';
  set daytmw2(String? val) => _daytmw2 = val;

  bool hasDaytmw2() => _daytmw2 != null;

  static GetTodayPlusMinusStruct fromMap(Map<String, dynamic> data) =>
      GetTodayPlusMinusStruct(
        dateM2: data['dateM2'] as DateTime?,
        dayM2: data['dayM2'] as String?,
        dateM1: data['dateM1'] as DateTime?,
        dayM1: data['dayM1'] as String?,
        date0: data['date0'] as DateTime?,
        day0: data['day0'] as String?,
        datetmw: data['datetmw'] as DateTime?,
        daytmw: data['daytmw'] as String?,
        datetmw2: data['datetmw2'] as DateTime?,
        daytmw2: data['daytmw2'] as String?,
      );

  static GetTodayPlusMinusStruct? maybeFromMap(dynamic data) => data is Map
      ? GetTodayPlusMinusStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'dateM2': _dateM2,
        'dayM2': _dayM2,
        'dateM1': _dateM1,
        'dayM1': _dayM1,
        'date0': _date0,
        'day0': _day0,
        'datetmw': _datetmw,
        'daytmw': _daytmw,
        'datetmw2': _datetmw2,
        'daytmw2': _daytmw2,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'dateM2': serializeParam(
          _dateM2,
          ParamType.DateTime,
        ),
        'dayM2': serializeParam(
          _dayM2,
          ParamType.String,
        ),
        'dateM1': serializeParam(
          _dateM1,
          ParamType.DateTime,
        ),
        'dayM1': serializeParam(
          _dayM1,
          ParamType.String,
        ),
        'date0': serializeParam(
          _date0,
          ParamType.DateTime,
        ),
        'day0': serializeParam(
          _day0,
          ParamType.String,
        ),
        'datetmw': serializeParam(
          _datetmw,
          ParamType.DateTime,
        ),
        'daytmw': serializeParam(
          _daytmw,
          ParamType.String,
        ),
        'datetmw2': serializeParam(
          _datetmw2,
          ParamType.DateTime,
        ),
        'daytmw2': serializeParam(
          _daytmw2,
          ParamType.String,
        ),
      }.withoutNulls;

  static GetTodayPlusMinusStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      GetTodayPlusMinusStruct(
        dateM2: deserializeParam(
          data['dateM2'],
          ParamType.DateTime,
          false,
        ),
        dayM2: deserializeParam(
          data['dayM2'],
          ParamType.String,
          false,
        ),
        dateM1: deserializeParam(
          data['dateM1'],
          ParamType.DateTime,
          false,
        ),
        dayM1: deserializeParam(
          data['dayM1'],
          ParamType.String,
          false,
        ),
        date0: deserializeParam(
          data['date0'],
          ParamType.DateTime,
          false,
        ),
        day0: deserializeParam(
          data['day0'],
          ParamType.String,
          false,
        ),
        datetmw: deserializeParam(
          data['datetmw'],
          ParamType.DateTime,
          false,
        ),
        daytmw: deserializeParam(
          data['daytmw'],
          ParamType.String,
          false,
        ),
        datetmw2: deserializeParam(
          data['datetmw2'],
          ParamType.DateTime,
          false,
        ),
        daytmw2: deserializeParam(
          data['daytmw2'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'GetTodayPlusMinusStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GetTodayPlusMinusStruct &&
        dateM2 == other.dateM2 &&
        dayM2 == other.dayM2 &&
        dateM1 == other.dateM1 &&
        dayM1 == other.dayM1 &&
        date0 == other.date0 &&
        day0 == other.day0 &&
        datetmw == other.datetmw &&
        daytmw == other.daytmw &&
        datetmw2 == other.datetmw2 &&
        daytmw2 == other.daytmw2;
  }

  @override
  int get hashCode => const ListEquality().hash([
        dateM2,
        dayM2,
        dateM1,
        dayM1,
        date0,
        day0,
        datetmw,
        daytmw,
        datetmw2,
        daytmw2
      ]);
}

GetTodayPlusMinusStruct createGetTodayPlusMinusStruct({
  DateTime? dateM2,
  String? dayM2,
  DateTime? dateM1,
  String? dayM1,
  DateTime? date0,
  String? day0,
  DateTime? datetmw,
  String? daytmw,
  DateTime? datetmw2,
  String? daytmw2,
}) =>
    GetTodayPlusMinusStruct(
      dateM2: dateM2,
      dayM2: dayM2,
      dateM1: dateM1,
      dayM1: dayM1,
      date0: date0,
      day0: day0,
      datetmw: datetmw,
      daytmw: daytmw,
      datetmw2: datetmw2,
      daytmw2: daytmw2,
    );
