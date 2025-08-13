// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CalenderHorizontalStruct extends BaseStruct {
  CalenderHorizontalStruct({
    DateTime? calenderDate,
    String? calenderDay,
  })  : _calenderDate = calenderDate,
        _calenderDay = calenderDay;

  // "CalenderDate" field.
  DateTime? _calenderDate;
  DateTime? get calenderDate => _calenderDate;
  set calenderDate(DateTime? val) => _calenderDate = val;

  bool hasCalenderDate() => _calenderDate != null;

  // "CalenderDay" field.
  String? _calenderDay;
  String get calenderDay => _calenderDay ?? '';
  set calenderDay(String? val) => _calenderDay = val;

  bool hasCalenderDay() => _calenderDay != null;

  static CalenderHorizontalStruct fromMap(Map<String, dynamic> data) =>
      CalenderHorizontalStruct(
        calenderDate: data['CalenderDate'] as DateTime?,
        calenderDay: data['CalenderDay'] as String?,
      );

  static CalenderHorizontalStruct? maybeFromMap(dynamic data) => data is Map
      ? CalenderHorizontalStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'CalenderDate': _calenderDate,
        'CalenderDay': _calenderDay,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'CalenderDate': serializeParam(
          _calenderDate,
          ParamType.DateTime,
        ),
        'CalenderDay': serializeParam(
          _calenderDay,
          ParamType.String,
        ),
      }.withoutNulls;

  static CalenderHorizontalStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CalenderHorizontalStruct(
        calenderDate: deserializeParam(
          data['CalenderDate'],
          ParamType.DateTime,
          false,
        ),
        calenderDay: deserializeParam(
          data['CalenderDay'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CalenderHorizontalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CalenderHorizontalStruct &&
        calenderDate == other.calenderDate &&
        calenderDay == other.calenderDay;
  }

  @override
  int get hashCode => const ListEquality().hash([calenderDate, calenderDay]);
}

CalenderHorizontalStruct createCalenderHorizontalStruct({
  DateTime? calenderDate,
  String? calenderDay,
}) =>
    CalenderHorizontalStruct(
      calenderDate: calenderDate,
      calenderDay: calenderDay,
    );
