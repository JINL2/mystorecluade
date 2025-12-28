// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlyAttendance {
  String get attendanceId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get workScheduleTemplateId => throw _privateConstructorUsedError;

  /// 출근 날짜 (로컬 기준)
  DateTime get attendanceDate => throw _privateConstructorUsedError;

  /// 예정 시간 (UTC) - V3: TIMESTAMPTZ로 변경됨
  /// DB에서 template 시간 + company timezone → UTC로 변환하여 저장
  DateTime? get scheduledStartTimeUtc => throw _privateConstructorUsedError;
  DateTime? get scheduledEndTimeUtc => throw _privateConstructorUsedError;

  /// 실제 출퇴근 시간 (UTC)
  DateTime? get checkInTimeUtc => throw _privateConstructorUsedError;
  DateTime? get checkOutTimeUtc => throw _privateConstructorUsedError;

  /// 상태: scheduled, checked_in, completed, absent, day_off
  String get status => throw _privateConstructorUsedError;

  /// 문제 플래그 (참고용, 금액 계산 없음)
  bool get isLate => throw _privateConstructorUsedError;
  bool get isEarlyLeave => throw _privateConstructorUsedError;

  /// 메모
  String? get notes => throw _privateConstructorUsedError;

  /// 템플릿 이름 (UI 표시용)
  String? get templateName => throw _privateConstructorUsedError;

  /// 회사 timezone (UI 표시용)
  String? get timezone => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyAttendance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyAttendanceCopyWith<MonthlyAttendance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyAttendanceCopyWith<$Res> {
  factory $MonthlyAttendanceCopyWith(
          MonthlyAttendance value, $Res Function(MonthlyAttendance) then) =
      _$MonthlyAttendanceCopyWithImpl<$Res, MonthlyAttendance>;
  @useResult
  $Res call(
      {String attendanceId,
      String userId,
      String companyId,
      String? storeId,
      String? workScheduleTemplateId,
      DateTime attendanceDate,
      DateTime? scheduledStartTimeUtc,
      DateTime? scheduledEndTimeUtc,
      DateTime? checkInTimeUtc,
      DateTime? checkOutTimeUtc,
      String status,
      bool isLate,
      bool isEarlyLeave,
      String? notes,
      String? templateName,
      String? timezone});
}

/// @nodoc
class _$MonthlyAttendanceCopyWithImpl<$Res, $Val extends MonthlyAttendance>
    implements $MonthlyAttendanceCopyWith<$Res> {
  _$MonthlyAttendanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyAttendance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendanceId = null,
    Object? userId = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? workScheduleTemplateId = freezed,
    Object? attendanceDate = null,
    Object? scheduledStartTimeUtc = freezed,
    Object? scheduledEndTimeUtc = freezed,
    Object? checkInTimeUtc = freezed,
    Object? checkOutTimeUtc = freezed,
    Object? status = null,
    Object? isLate = null,
    Object? isEarlyLeave = null,
    Object? notes = freezed,
    Object? templateName = freezed,
    Object? timezone = freezed,
  }) {
    return _then(_value.copyWith(
      attendanceId: null == attendanceId
          ? _value.attendanceId
          : attendanceId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      workScheduleTemplateId: freezed == workScheduleTemplateId
          ? _value.workScheduleTemplateId
          : workScheduleTemplateId // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceDate: null == attendanceDate
          ? _value.attendanceDate
          : attendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledStartTimeUtc: freezed == scheduledStartTimeUtc
          ? _value.scheduledStartTimeUtc
          : scheduledStartTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTimeUtc: freezed == scheduledEndTimeUtc
          ? _value.scheduledEndTimeUtc
          : scheduledEndTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkInTimeUtc: freezed == checkInTimeUtc
          ? _value.checkInTimeUtc
          : checkInTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTimeUtc: freezed == checkOutTimeUtc
          ? _value.checkOutTimeUtc
          : checkOutTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      isEarlyLeave: null == isEarlyLeave
          ? _value.isEarlyLeave
          : isEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      templateName: freezed == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyAttendanceImplCopyWith<$Res>
    implements $MonthlyAttendanceCopyWith<$Res> {
  factory _$$MonthlyAttendanceImplCopyWith(_$MonthlyAttendanceImpl value,
          $Res Function(_$MonthlyAttendanceImpl) then) =
      __$$MonthlyAttendanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String attendanceId,
      String userId,
      String companyId,
      String? storeId,
      String? workScheduleTemplateId,
      DateTime attendanceDate,
      DateTime? scheduledStartTimeUtc,
      DateTime? scheduledEndTimeUtc,
      DateTime? checkInTimeUtc,
      DateTime? checkOutTimeUtc,
      String status,
      bool isLate,
      bool isEarlyLeave,
      String? notes,
      String? templateName,
      String? timezone});
}

/// @nodoc
class __$$MonthlyAttendanceImplCopyWithImpl<$Res>
    extends _$MonthlyAttendanceCopyWithImpl<$Res, _$MonthlyAttendanceImpl>
    implements _$$MonthlyAttendanceImplCopyWith<$Res> {
  __$$MonthlyAttendanceImplCopyWithImpl(_$MonthlyAttendanceImpl _value,
      $Res Function(_$MonthlyAttendanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyAttendance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendanceId = null,
    Object? userId = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? workScheduleTemplateId = freezed,
    Object? attendanceDate = null,
    Object? scheduledStartTimeUtc = freezed,
    Object? scheduledEndTimeUtc = freezed,
    Object? checkInTimeUtc = freezed,
    Object? checkOutTimeUtc = freezed,
    Object? status = null,
    Object? isLate = null,
    Object? isEarlyLeave = null,
    Object? notes = freezed,
    Object? templateName = freezed,
    Object? timezone = freezed,
  }) {
    return _then(_$MonthlyAttendanceImpl(
      attendanceId: null == attendanceId
          ? _value.attendanceId
          : attendanceId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      workScheduleTemplateId: freezed == workScheduleTemplateId
          ? _value.workScheduleTemplateId
          : workScheduleTemplateId // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceDate: null == attendanceDate
          ? _value.attendanceDate
          : attendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledStartTimeUtc: freezed == scheduledStartTimeUtc
          ? _value.scheduledStartTimeUtc
          : scheduledStartTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTimeUtc: freezed == scheduledEndTimeUtc
          ? _value.scheduledEndTimeUtc
          : scheduledEndTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkInTimeUtc: freezed == checkInTimeUtc
          ? _value.checkInTimeUtc
          : checkInTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTimeUtc: freezed == checkOutTimeUtc
          ? _value.checkOutTimeUtc
          : checkOutTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      isEarlyLeave: null == isEarlyLeave
          ? _value.isEarlyLeave
          : isEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      templateName: freezed == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MonthlyAttendanceImpl extends _MonthlyAttendance {
  const _$MonthlyAttendanceImpl(
      {required this.attendanceId,
      required this.userId,
      required this.companyId,
      this.storeId,
      this.workScheduleTemplateId,
      required this.attendanceDate,
      this.scheduledStartTimeUtc,
      this.scheduledEndTimeUtc,
      this.checkInTimeUtc,
      this.checkOutTimeUtc,
      required this.status,
      this.isLate = false,
      this.isEarlyLeave = false,
      this.notes,
      this.templateName,
      this.timezone})
      : super._();

  @override
  final String attendanceId;
  @override
  final String userId;
  @override
  final String companyId;
  @override
  final String? storeId;
  @override
  final String? workScheduleTemplateId;

  /// 출근 날짜 (로컬 기준)
  @override
  final DateTime attendanceDate;

  /// 예정 시간 (UTC) - V3: TIMESTAMPTZ로 변경됨
  /// DB에서 template 시간 + company timezone → UTC로 변환하여 저장
  @override
  final DateTime? scheduledStartTimeUtc;
  @override
  final DateTime? scheduledEndTimeUtc;

  /// 실제 출퇴근 시간 (UTC)
  @override
  final DateTime? checkInTimeUtc;
  @override
  final DateTime? checkOutTimeUtc;

  /// 상태: scheduled, checked_in, completed, absent, day_off
  @override
  final String status;

  /// 문제 플래그 (참고용, 금액 계산 없음)
  @override
  @JsonKey()
  final bool isLate;
  @override
  @JsonKey()
  final bool isEarlyLeave;

  /// 메모
  @override
  final String? notes;

  /// 템플릿 이름 (UI 표시용)
  @override
  final String? templateName;

  /// 회사 timezone (UI 표시용)
  @override
  final String? timezone;

  @override
  String toString() {
    return 'MonthlyAttendance(attendanceId: $attendanceId, userId: $userId, companyId: $companyId, storeId: $storeId, workScheduleTemplateId: $workScheduleTemplateId, attendanceDate: $attendanceDate, scheduledStartTimeUtc: $scheduledStartTimeUtc, scheduledEndTimeUtc: $scheduledEndTimeUtc, checkInTimeUtc: $checkInTimeUtc, checkOutTimeUtc: $checkOutTimeUtc, status: $status, isLate: $isLate, isEarlyLeave: $isEarlyLeave, notes: $notes, templateName: $templateName, timezone: $timezone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyAttendanceImpl &&
            (identical(other.attendanceId, attendanceId) ||
                other.attendanceId == attendanceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.workScheduleTemplateId, workScheduleTemplateId) ||
                other.workScheduleTemplateId == workScheduleTemplateId) &&
            (identical(other.attendanceDate, attendanceDate) ||
                other.attendanceDate == attendanceDate) &&
            (identical(other.scheduledStartTimeUtc, scheduledStartTimeUtc) ||
                other.scheduledStartTimeUtc == scheduledStartTimeUtc) &&
            (identical(other.scheduledEndTimeUtc, scheduledEndTimeUtc) ||
                other.scheduledEndTimeUtc == scheduledEndTimeUtc) &&
            (identical(other.checkInTimeUtc, checkInTimeUtc) ||
                other.checkInTimeUtc == checkInTimeUtc) &&
            (identical(other.checkOutTimeUtc, checkOutTimeUtc) ||
                other.checkOutTimeUtc == checkOutTimeUtc) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLate, isLate) || other.isLate == isLate) &&
            (identical(other.isEarlyLeave, isEarlyLeave) ||
                other.isEarlyLeave == isEarlyLeave) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      attendanceId,
      userId,
      companyId,
      storeId,
      workScheduleTemplateId,
      attendanceDate,
      scheduledStartTimeUtc,
      scheduledEndTimeUtc,
      checkInTimeUtc,
      checkOutTimeUtc,
      status,
      isLate,
      isEarlyLeave,
      notes,
      templateName,
      timezone);

  /// Create a copy of MonthlyAttendance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyAttendanceImplCopyWith<_$MonthlyAttendanceImpl> get copyWith =>
      __$$MonthlyAttendanceImplCopyWithImpl<_$MonthlyAttendanceImpl>(
          this, _$identity);
}

abstract class _MonthlyAttendance extends MonthlyAttendance {
  const factory _MonthlyAttendance(
      {required final String attendanceId,
      required final String userId,
      required final String companyId,
      final String? storeId,
      final String? workScheduleTemplateId,
      required final DateTime attendanceDate,
      final DateTime? scheduledStartTimeUtc,
      final DateTime? scheduledEndTimeUtc,
      final DateTime? checkInTimeUtc,
      final DateTime? checkOutTimeUtc,
      required final String status,
      final bool isLate,
      final bool isEarlyLeave,
      final String? notes,
      final String? templateName,
      final String? timezone}) = _$MonthlyAttendanceImpl;
  const _MonthlyAttendance._() : super._();

  @override
  String get attendanceId;
  @override
  String get userId;
  @override
  String get companyId;
  @override
  String? get storeId;
  @override
  String? get workScheduleTemplateId;

  /// 출근 날짜 (로컬 기준)
  @override
  DateTime get attendanceDate;

  /// 예정 시간 (UTC) - V3: TIMESTAMPTZ로 변경됨
  /// DB에서 template 시간 + company timezone → UTC로 변환하여 저장
  @override
  DateTime? get scheduledStartTimeUtc;
  @override
  DateTime? get scheduledEndTimeUtc;

  /// 실제 출퇴근 시간 (UTC)
  @override
  DateTime? get checkInTimeUtc;
  @override
  DateTime? get checkOutTimeUtc;

  /// 상태: scheduled, checked_in, completed, absent, day_off
  @override
  String get status;

  /// 문제 플래그 (참고용, 금액 계산 없음)
  @override
  bool get isLate;
  @override
  bool get isEarlyLeave;

  /// 메모
  @override
  String? get notes;

  /// 템플릿 이름 (UI 표시용)
  @override
  String? get templateName;

  /// 회사 timezone (UI 표시용)
  @override
  String? get timezone;

  /// Create a copy of MonthlyAttendance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyAttendanceImplCopyWith<_$MonthlyAttendanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MonthlyAttendanceStats {
  /// 기간 정보
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;

  /// 오늘 출석 정보 (null이면 오늘 기록 없음)
  MonthlyAttendance? get today => throw _privateConstructorUsedError;

  /// 통계
  int get completedDays => throw _privateConstructorUsedError;
  int get workedDays => throw _privateConstructorUsedError;
  int get absentDays => throw _privateConstructorUsedError;
  int get lateDays => throw _privateConstructorUsedError;
  int get earlyLeaveDays => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyAttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyAttendanceStatsCopyWith<MonthlyAttendanceStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyAttendanceStatsCopyWith<$Res> {
  factory $MonthlyAttendanceStatsCopyWith(MonthlyAttendanceStats value,
          $Res Function(MonthlyAttendanceStats) then) =
      _$MonthlyAttendanceStatsCopyWithImpl<$Res, MonthlyAttendanceStats>;
  @useResult
  $Res call(
      {int year,
      int month,
      DateTime startDate,
      DateTime endDate,
      MonthlyAttendance? today,
      int completedDays,
      int workedDays,
      int absentDays,
      int lateDays,
      int earlyLeaveDays});

  $MonthlyAttendanceCopyWith<$Res>? get today;
}

/// @nodoc
class _$MonthlyAttendanceStatsCopyWithImpl<$Res,
        $Val extends MonthlyAttendanceStats>
    implements $MonthlyAttendanceStatsCopyWith<$Res> {
  _$MonthlyAttendanceStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyAttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? today = freezed,
    Object? completedDays = null,
    Object? workedDays = null,
    Object? absentDays = null,
    Object? lateDays = null,
    Object? earlyLeaveDays = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      today: freezed == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as MonthlyAttendance?,
      completedDays: null == completedDays
          ? _value.completedDays
          : completedDays // ignore: cast_nullable_to_non_nullable
              as int,
      workedDays: null == workedDays
          ? _value.workedDays
          : workedDays // ignore: cast_nullable_to_non_nullable
              as int,
      absentDays: null == absentDays
          ? _value.absentDays
          : absentDays // ignore: cast_nullable_to_non_nullable
              as int,
      lateDays: null == lateDays
          ? _value.lateDays
          : lateDays // ignore: cast_nullable_to_non_nullable
              as int,
      earlyLeaveDays: null == earlyLeaveDays
          ? _value.earlyLeaveDays
          : earlyLeaveDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of MonthlyAttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MonthlyAttendanceCopyWith<$Res>? get today {
    if (_value.today == null) {
      return null;
    }

    return $MonthlyAttendanceCopyWith<$Res>(_value.today!, (value) {
      return _then(_value.copyWith(today: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MonthlyAttendanceStatsImplCopyWith<$Res>
    implements $MonthlyAttendanceStatsCopyWith<$Res> {
  factory _$$MonthlyAttendanceStatsImplCopyWith(
          _$MonthlyAttendanceStatsImpl value,
          $Res Function(_$MonthlyAttendanceStatsImpl) then) =
      __$$MonthlyAttendanceStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int year,
      int month,
      DateTime startDate,
      DateTime endDate,
      MonthlyAttendance? today,
      int completedDays,
      int workedDays,
      int absentDays,
      int lateDays,
      int earlyLeaveDays});

  @override
  $MonthlyAttendanceCopyWith<$Res>? get today;
}

/// @nodoc
class __$$MonthlyAttendanceStatsImplCopyWithImpl<$Res>
    extends _$MonthlyAttendanceStatsCopyWithImpl<$Res,
        _$MonthlyAttendanceStatsImpl>
    implements _$$MonthlyAttendanceStatsImplCopyWith<$Res> {
  __$$MonthlyAttendanceStatsImplCopyWithImpl(
      _$MonthlyAttendanceStatsImpl _value,
      $Res Function(_$MonthlyAttendanceStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyAttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? today = freezed,
    Object? completedDays = null,
    Object? workedDays = null,
    Object? absentDays = null,
    Object? lateDays = null,
    Object? earlyLeaveDays = null,
  }) {
    return _then(_$MonthlyAttendanceStatsImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      today: freezed == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as MonthlyAttendance?,
      completedDays: null == completedDays
          ? _value.completedDays
          : completedDays // ignore: cast_nullable_to_non_nullable
              as int,
      workedDays: null == workedDays
          ? _value.workedDays
          : workedDays // ignore: cast_nullable_to_non_nullable
              as int,
      absentDays: null == absentDays
          ? _value.absentDays
          : absentDays // ignore: cast_nullable_to_non_nullable
              as int,
      lateDays: null == lateDays
          ? _value.lateDays
          : lateDays // ignore: cast_nullable_to_non_nullable
              as int,
      earlyLeaveDays: null == earlyLeaveDays
          ? _value.earlyLeaveDays
          : earlyLeaveDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MonthlyAttendanceStatsImpl implements _MonthlyAttendanceStats {
  const _$MonthlyAttendanceStatsImpl(
      {required this.year,
      required this.month,
      required this.startDate,
      required this.endDate,
      this.today,
      this.completedDays = 0,
      this.workedDays = 0,
      this.absentDays = 0,
      this.lateDays = 0,
      this.earlyLeaveDays = 0});

  /// 기간 정보
  @override
  final int year;
  @override
  final int month;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  /// 오늘 출석 정보 (null이면 오늘 기록 없음)
  @override
  final MonthlyAttendance? today;

  /// 통계
  @override
  @JsonKey()
  final int completedDays;
  @override
  @JsonKey()
  final int workedDays;
  @override
  @JsonKey()
  final int absentDays;
  @override
  @JsonKey()
  final int lateDays;
  @override
  @JsonKey()
  final int earlyLeaveDays;

  @override
  String toString() {
    return 'MonthlyAttendanceStats(year: $year, month: $month, startDate: $startDate, endDate: $endDate, today: $today, completedDays: $completedDays, workedDays: $workedDays, absentDays: $absentDays, lateDays: $lateDays, earlyLeaveDays: $earlyLeaveDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyAttendanceStatsImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.completedDays, completedDays) ||
                other.completedDays == completedDays) &&
            (identical(other.workedDays, workedDays) ||
                other.workedDays == workedDays) &&
            (identical(other.absentDays, absentDays) ||
                other.absentDays == absentDays) &&
            (identical(other.lateDays, lateDays) ||
                other.lateDays == lateDays) &&
            (identical(other.earlyLeaveDays, earlyLeaveDays) ||
                other.earlyLeaveDays == earlyLeaveDays));
  }

  @override
  int get hashCode => Object.hash(runtimeType, year, month, startDate, endDate,
      today, completedDays, workedDays, absentDays, lateDays, earlyLeaveDays);

  /// Create a copy of MonthlyAttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyAttendanceStatsImplCopyWith<_$MonthlyAttendanceStatsImpl>
      get copyWith => __$$MonthlyAttendanceStatsImplCopyWithImpl<
          _$MonthlyAttendanceStatsImpl>(this, _$identity);
}

abstract class _MonthlyAttendanceStats implements MonthlyAttendanceStats {
  const factory _MonthlyAttendanceStats(
      {required final int year,
      required final int month,
      required final DateTime startDate,
      required final DateTime endDate,
      final MonthlyAttendance? today,
      final int completedDays,
      final int workedDays,
      final int absentDays,
      final int lateDays,
      final int earlyLeaveDays}) = _$MonthlyAttendanceStatsImpl;

  /// 기간 정보
  @override
  int get year;
  @override
  int get month;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;

  /// 오늘 출석 정보 (null이면 오늘 기록 없음)
  @override
  MonthlyAttendance? get today;

  /// 통계
  @override
  int get completedDays;
  @override
  int get workedDays;
  @override
  int get absentDays;
  @override
  int get lateDays;
  @override
  int get earlyLeaveDays;

  /// Create a copy of MonthlyAttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyAttendanceStatsImplCopyWith<_$MonthlyAttendanceStatsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MonthlyCheckResult {
  bool get success => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// 성공 시 데이터
  String? get attendanceId => throw _privateConstructorUsedError;
  DateTime? get attendanceDate => throw _privateConstructorUsedError;
  DateTime? get checkInTimeUtc => throw _privateConstructorUsedError;
  DateTime? get checkOutTimeUtc => throw _privateConstructorUsedError;

  /// 예정 시간 (UTC) - V3
  DateTime? get scheduledStartTimeUtc => throw _privateConstructorUsedError;
  DateTime? get scheduledEndTimeUtc => throw _privateConstructorUsedError;
  bool get isLate => throw _privateConstructorUsedError;
  bool get isEarlyLeave => throw _privateConstructorUsedError;
  String? get templateName => throw _privateConstructorUsedError;

  /// 회사 timezone (UI 표시용)
  String? get timezone => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyCheckResultCopyWith<MonthlyCheckResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyCheckResultCopyWith<$Res> {
  factory $MonthlyCheckResultCopyWith(
          MonthlyCheckResult value, $Res Function(MonthlyCheckResult) then) =
      _$MonthlyCheckResultCopyWithImpl<$Res, MonthlyCheckResult>;
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      String? attendanceId,
      DateTime? attendanceDate,
      DateTime? checkInTimeUtc,
      DateTime? checkOutTimeUtc,
      DateTime? scheduledStartTimeUtc,
      DateTime? scheduledEndTimeUtc,
      bool isLate,
      bool isEarlyLeave,
      String? templateName,
      String? timezone});
}

/// @nodoc
class _$MonthlyCheckResultCopyWithImpl<$Res, $Val extends MonthlyCheckResult>
    implements $MonthlyCheckResultCopyWith<$Res> {
  _$MonthlyCheckResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? attendanceId = freezed,
    Object? attendanceDate = freezed,
    Object? checkInTimeUtc = freezed,
    Object? checkOutTimeUtc = freezed,
    Object? scheduledStartTimeUtc = freezed,
    Object? scheduledEndTimeUtc = freezed,
    Object? isLate = null,
    Object? isEarlyLeave = null,
    Object? templateName = freezed,
    Object? timezone = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceId: freezed == attendanceId
          ? _value.attendanceId
          : attendanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceDate: freezed == attendanceDate
          ? _value.attendanceDate
          : attendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkInTimeUtc: freezed == checkInTimeUtc
          ? _value.checkInTimeUtc
          : checkInTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTimeUtc: freezed == checkOutTimeUtc
          ? _value.checkOutTimeUtc
          : checkOutTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledStartTimeUtc: freezed == scheduledStartTimeUtc
          ? _value.scheduledStartTimeUtc
          : scheduledStartTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTimeUtc: freezed == scheduledEndTimeUtc
          ? _value.scheduledEndTimeUtc
          : scheduledEndTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      isEarlyLeave: null == isEarlyLeave
          ? _value.isEarlyLeave
          : isEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      templateName: freezed == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyCheckResultImplCopyWith<$Res>
    implements $MonthlyCheckResultCopyWith<$Res> {
  factory _$$MonthlyCheckResultImplCopyWith(_$MonthlyCheckResultImpl value,
          $Res Function(_$MonthlyCheckResultImpl) then) =
      __$$MonthlyCheckResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      String? attendanceId,
      DateTime? attendanceDate,
      DateTime? checkInTimeUtc,
      DateTime? checkOutTimeUtc,
      DateTime? scheduledStartTimeUtc,
      DateTime? scheduledEndTimeUtc,
      bool isLate,
      bool isEarlyLeave,
      String? templateName,
      String? timezone});
}

/// @nodoc
class __$$MonthlyCheckResultImplCopyWithImpl<$Res>
    extends _$MonthlyCheckResultCopyWithImpl<$Res, _$MonthlyCheckResultImpl>
    implements _$$MonthlyCheckResultImplCopyWith<$Res> {
  __$$MonthlyCheckResultImplCopyWithImpl(_$MonthlyCheckResultImpl _value,
      $Res Function(_$MonthlyCheckResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? attendanceId = freezed,
    Object? attendanceDate = freezed,
    Object? checkInTimeUtc = freezed,
    Object? checkOutTimeUtc = freezed,
    Object? scheduledStartTimeUtc = freezed,
    Object? scheduledEndTimeUtc = freezed,
    Object? isLate = null,
    Object? isEarlyLeave = null,
    Object? templateName = freezed,
    Object? timezone = freezed,
  }) {
    return _then(_$MonthlyCheckResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceId: freezed == attendanceId
          ? _value.attendanceId
          : attendanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceDate: freezed == attendanceDate
          ? _value.attendanceDate
          : attendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkInTimeUtc: freezed == checkInTimeUtc
          ? _value.checkInTimeUtc
          : checkInTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTimeUtc: freezed == checkOutTimeUtc
          ? _value.checkOutTimeUtc
          : checkOutTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledStartTimeUtc: freezed == scheduledStartTimeUtc
          ? _value.scheduledStartTimeUtc
          : scheduledStartTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledEndTimeUtc: freezed == scheduledEndTimeUtc
          ? _value.scheduledEndTimeUtc
          : scheduledEndTimeUtc // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      isEarlyLeave: null == isEarlyLeave
          ? _value.isEarlyLeave
          : isEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      templateName: freezed == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MonthlyCheckResultImpl extends _MonthlyCheckResult {
  const _$MonthlyCheckResultImpl(
      {required this.success,
      this.error,
      this.message,
      this.attendanceId,
      this.attendanceDate,
      this.checkInTimeUtc,
      this.checkOutTimeUtc,
      this.scheduledStartTimeUtc,
      this.scheduledEndTimeUtc,
      this.isLate = false,
      this.isEarlyLeave = false,
      this.templateName,
      this.timezone})
      : super._();

  @override
  final bool success;
  @override
  final String? error;
  @override
  final String? message;

  /// 성공 시 데이터
  @override
  final String? attendanceId;
  @override
  final DateTime? attendanceDate;
  @override
  final DateTime? checkInTimeUtc;
  @override
  final DateTime? checkOutTimeUtc;

  /// 예정 시간 (UTC) - V3
  @override
  final DateTime? scheduledStartTimeUtc;
  @override
  final DateTime? scheduledEndTimeUtc;
  @override
  @JsonKey()
  final bool isLate;
  @override
  @JsonKey()
  final bool isEarlyLeave;
  @override
  final String? templateName;

  /// 회사 timezone (UI 표시용)
  @override
  final String? timezone;

  @override
  String toString() {
    return 'MonthlyCheckResult(success: $success, error: $error, message: $message, attendanceId: $attendanceId, attendanceDate: $attendanceDate, checkInTimeUtc: $checkInTimeUtc, checkOutTimeUtc: $checkOutTimeUtc, scheduledStartTimeUtc: $scheduledStartTimeUtc, scheduledEndTimeUtc: $scheduledEndTimeUtc, isLate: $isLate, isEarlyLeave: $isEarlyLeave, templateName: $templateName, timezone: $timezone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyCheckResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.attendanceId, attendanceId) ||
                other.attendanceId == attendanceId) &&
            (identical(other.attendanceDate, attendanceDate) ||
                other.attendanceDate == attendanceDate) &&
            (identical(other.checkInTimeUtc, checkInTimeUtc) ||
                other.checkInTimeUtc == checkInTimeUtc) &&
            (identical(other.checkOutTimeUtc, checkOutTimeUtc) ||
                other.checkOutTimeUtc == checkOutTimeUtc) &&
            (identical(other.scheduledStartTimeUtc, scheduledStartTimeUtc) ||
                other.scheduledStartTimeUtc == scheduledStartTimeUtc) &&
            (identical(other.scheduledEndTimeUtc, scheduledEndTimeUtc) ||
                other.scheduledEndTimeUtc == scheduledEndTimeUtc) &&
            (identical(other.isLate, isLate) || other.isLate == isLate) &&
            (identical(other.isEarlyLeave, isEarlyLeave) ||
                other.isEarlyLeave == isEarlyLeave) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      error,
      message,
      attendanceId,
      attendanceDate,
      checkInTimeUtc,
      checkOutTimeUtc,
      scheduledStartTimeUtc,
      scheduledEndTimeUtc,
      isLate,
      isEarlyLeave,
      templateName,
      timezone);

  /// Create a copy of MonthlyCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyCheckResultImplCopyWith<_$MonthlyCheckResultImpl> get copyWith =>
      __$$MonthlyCheckResultImplCopyWithImpl<_$MonthlyCheckResultImpl>(
          this, _$identity);
}

abstract class _MonthlyCheckResult extends MonthlyCheckResult {
  const factory _MonthlyCheckResult(
      {required final bool success,
      final String? error,
      final String? message,
      final String? attendanceId,
      final DateTime? attendanceDate,
      final DateTime? checkInTimeUtc,
      final DateTime? checkOutTimeUtc,
      final DateTime? scheduledStartTimeUtc,
      final DateTime? scheduledEndTimeUtc,
      final bool isLate,
      final bool isEarlyLeave,
      final String? templateName,
      final String? timezone}) = _$MonthlyCheckResultImpl;
  const _MonthlyCheckResult._() : super._();

  @override
  bool get success;
  @override
  String? get error;
  @override
  String? get message;

  /// 성공 시 데이터
  @override
  String? get attendanceId;
  @override
  DateTime? get attendanceDate;
  @override
  DateTime? get checkInTimeUtc;
  @override
  DateTime? get checkOutTimeUtc;

  /// 예정 시간 (UTC) - V3
  @override
  DateTime? get scheduledStartTimeUtc;
  @override
  DateTime? get scheduledEndTimeUtc;
  @override
  bool get isLate;
  @override
  bool get isEarlyLeave;
  @override
  String? get templateName;

  /// 회사 timezone (UI 표시용)
  @override
  String? get timezone;

  /// Create a copy of MonthlyCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyCheckResultImplCopyWith<_$MonthlyCheckResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
