// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CalendarDayStruct extends BaseStruct {
  CalendarDayStruct({
    bool? isPreviousMonth,
    bool? isNextMonth,
    DateTime? calendarDate,
  })  : _isPreviousMonth = isPreviousMonth,
        _isNextMonth = isNextMonth,
        _calendarDate = calendarDate;

  // "isPreviousMonth" field.
  bool? _isPreviousMonth;
  bool get isPreviousMonth => _isPreviousMonth ?? false;
  set isPreviousMonth(bool? val) => _isPreviousMonth = val;

  bool hasIsPreviousMonth() => _isPreviousMonth != null;

  // "isNextMonth" field.
  bool? _isNextMonth;
  bool get isNextMonth => _isNextMonth ?? false;
  set isNextMonth(bool? val) => _isNextMonth = val;

  bool hasIsNextMonth() => _isNextMonth != null;

  // "CalendarDate" field.
  DateTime? _calendarDate;
  DateTime? get calendarDate => _calendarDate;
  set calendarDate(DateTime? val) => _calendarDate = val;

  bool hasCalendarDate() => _calendarDate != null;

  static CalendarDayStruct fromMap(Map<String, dynamic> data) =>
      CalendarDayStruct(
        isPreviousMonth: data['isPreviousMonth'] as bool?,
        isNextMonth: data['isNextMonth'] as bool?,
        calendarDate: data['CalendarDate'] as DateTime?,
      );

  static CalendarDayStruct? maybeFromMap(dynamic data) => data is Map
      ? CalendarDayStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'isPreviousMonth': _isPreviousMonth,
        'isNextMonth': _isNextMonth,
        'CalendarDate': _calendarDate,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'isPreviousMonth': serializeParam(
          _isPreviousMonth,
          ParamType.bool,
        ),
        'isNextMonth': serializeParam(
          _isNextMonth,
          ParamType.bool,
        ),
        'CalendarDate': serializeParam(
          _calendarDate,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static CalendarDayStruct fromSerializableMap(Map<String, dynamic> data) =>
      CalendarDayStruct(
        isPreviousMonth: deserializeParam(
          data['isPreviousMonth'],
          ParamType.bool,
          false,
        ),
        isNextMonth: deserializeParam(
          data['isNextMonth'],
          ParamType.bool,
          false,
        ),
        calendarDate: deserializeParam(
          data['CalendarDate'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'CalendarDayStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CalendarDayStruct &&
        isPreviousMonth == other.isPreviousMonth &&
        isNextMonth == other.isNextMonth &&
        calendarDate == other.calendarDate;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([isPreviousMonth, isNextMonth, calendarDate]);
}

CalendarDayStruct createCalendarDayStruct({
  bool? isPreviousMonth,
  bool? isNextMonth,
  DateTime? calendarDate,
}) =>
    CalendarDayStruct(
      isPreviousMonth: isPreviousMonth,
      isNextMonth: isNextMonth,
      calendarDate: calendarDate,
    );
