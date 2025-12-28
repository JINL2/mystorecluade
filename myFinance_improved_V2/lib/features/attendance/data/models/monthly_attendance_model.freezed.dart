// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlyAttendanceModel _$MonthlyAttendanceModelFromJson(
    Map<String, dynamic> json) {
  return _MonthlyAttendanceModel.fromJson(json);
}

/// @nodoc
mixin _$MonthlyAttendanceModel {
  @JsonKey(name: 'attendance_id')
  String get attendanceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_schedule_template_id')
  String? get workScheduleTemplateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_date')
  String get attendanceDate =>
      throw _privateConstructorUsedError; // V3: _utc suffix (TIMESTAMPTZ)
  @JsonKey(name: 'scheduled_start_time_utc')
  String? get scheduledStartTimeUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_end_time_utc')
  String? get scheduledEndTimeUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'check_in_time_utc')
  String? get checkInTimeUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'check_out_time_utc')
  String? get checkOutTimeUtc => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_late')
  bool get isLate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_early_leave')
  bool get isEarlyLeave => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_name')
  String? get templateName => throw _privateConstructorUsedError;
  @JsonKey(name: 'day_of_week')
  int? get dayOfWeek => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;

  /// Serializes this MonthlyAttendanceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyAttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyAttendanceModelCopyWith<MonthlyAttendanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyAttendanceModelCopyWith<$Res> {
  factory $MonthlyAttendanceModelCopyWith(MonthlyAttendanceModel value,
          $Res Function(MonthlyAttendanceModel) then) =
      _$MonthlyAttendanceModelCopyWithImpl<$Res, MonthlyAttendanceModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'attendance_id') String attendanceId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'work_schedule_template_id')
      String? workScheduleTemplateId,
      @JsonKey(name: 'attendance_date') String attendanceDate,
      @JsonKey(name: 'scheduled_start_time_utc') String? scheduledStartTimeUtc,
      @JsonKey(name: 'scheduled_end_time_utc') String? scheduledEndTimeUtc,
      @JsonKey(name: 'check_in_time_utc') String? checkInTimeUtc,
      @JsonKey(name: 'check_out_time_utc') String? checkOutTimeUtc,
      String status,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'is_early_leave') bool isEarlyLeave,
      String? notes,
      @JsonKey(name: 'template_name') String? templateName,
      @JsonKey(name: 'day_of_week') int? dayOfWeek,
      String? timezone});
}

/// @nodoc
class _$MonthlyAttendanceModelCopyWithImpl<$Res,
        $Val extends MonthlyAttendanceModel>
    implements $MonthlyAttendanceModelCopyWith<$Res> {
  _$MonthlyAttendanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyAttendanceModel
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
    Object? dayOfWeek = freezed,
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
              as String,
      scheduledStartTimeUtc: freezed == scheduledStartTimeUtc
          ? _value.scheduledStartTimeUtc
          : scheduledStartTimeUtc // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledEndTimeUtc: freezed == scheduledEndTimeUtc
          ? _value.scheduledEndTimeUtc
          : scheduledEndTimeUtc // ignore: cast_nullable_to_non_nullable
              as String?,
      checkInTimeUtc: freezed == checkInTimeUtc
          ? _value.checkInTimeUtc
          : checkInTimeUtc // ignore: cast_nullable_to_non_nullable
              as String?,
      checkOutTimeUtc: freezed == checkOutTimeUtc
          ? _value.checkOutTimeUtc
          : checkOutTimeUtc // ignore: cast_nullable_to_non_nullable
              as String?,
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
      dayOfWeek: freezed == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyAttendanceModelImplCopyWith<$Res>
    implements $MonthlyAttendanceModelCopyWith<$Res> {
  factory _$$MonthlyAttendanceModelImplCopyWith(
          _$MonthlyAttendanceModelImpl value,
          $Res Function(_$MonthlyAttendanceModelImpl) then) =
      __$$MonthlyAttendanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'attendance_id') String attendanceId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'work_schedule_template_id')
      String? workScheduleTemplateId,
      @JsonKey(name: 'attendance_date') String attendanceDate,
      @JsonKey(name: 'scheduled_start_time_utc') String? scheduledStartTimeUtc,
      @JsonKey(name: 'scheduled_end_time_utc') String? scheduledEndTimeUtc,
      @JsonKey(name: 'check_in_time_utc') String? checkInTimeUtc,
      @JsonKey(name: 'check_out_time_utc') String? checkOutTimeUtc,
      String status,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'is_early_leave') bool isEarlyLeave,
      String? notes,
      @JsonKey(name: 'template_name') String? templateName,
      @JsonKey(name: 'day_of_week') int? dayOfWeek,
      String? timezone});
}

/// @nodoc
class __$$MonthlyAttendanceModelImplCopyWithImpl<$Res>
    extends _$MonthlyAttendanceModelCopyWithImpl<$Res,
        _$MonthlyAttendanceModelImpl>
    implements _$$MonthlyAttendanceModelImplCopyWith<$Res> {
  __$$MonthlyAttendanceModelImplCopyWithImpl(
      _$MonthlyAttendanceModelImpl _value,
      $Res Function(_$MonthlyAttendanceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyAttendanceModel
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
    Object? dayOfWeek = freezed,
    Object? timezone = freezed,
  }) {
    return _then(_$MonthlyAttendanceModelImpl(
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
              as String,
      scheduledStartTimeUtc: freezed == scheduledStartTimeUtc
          ? _value.scheduledStartTimeUtc
          : scheduledStartTimeUtc // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledEndTimeUtc: freezed == scheduledEndTimeUtc
          ? _value.scheduledEndTimeUtc
          : scheduledEndTimeUtc // ignore: cast_nullable_to_non_nullable
              as String?,
      checkInTimeUtc: freezed == checkInTimeUtc
          ? _value.checkInTimeUtc
          : checkInTimeUtc // ignore: cast_nullable_to_non_nullable
              as String?,
      checkOutTimeUtc: freezed == checkOutTimeUtc
          ? _value.checkOutTimeUtc
          : checkOutTimeUtc // ignore: cast_nullable_to_non_nullable
              as String?,
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
      dayOfWeek: freezed == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyAttendanceModelImpl extends _MonthlyAttendanceModel {
  const _$MonthlyAttendanceModelImpl(
      {@JsonKey(name: 'attendance_id') required this.attendanceId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'work_schedule_template_id') this.workScheduleTemplateId,
      @JsonKey(name: 'attendance_date') required this.attendanceDate,
      @JsonKey(name: 'scheduled_start_time_utc') this.scheduledStartTimeUtc,
      @JsonKey(name: 'scheduled_end_time_utc') this.scheduledEndTimeUtc,
      @JsonKey(name: 'check_in_time_utc') this.checkInTimeUtc,
      @JsonKey(name: 'check_out_time_utc') this.checkOutTimeUtc,
      required this.status,
      @JsonKey(name: 'is_late') this.isLate = false,
      @JsonKey(name: 'is_early_leave') this.isEarlyLeave = false,
      this.notes,
      @JsonKey(name: 'template_name') this.templateName,
      @JsonKey(name: 'day_of_week') this.dayOfWeek,
      this.timezone})
      : super._();

  factory _$MonthlyAttendanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyAttendanceModelImplFromJson(json);

  @override
  @JsonKey(name: 'attendance_id')
  final String attendanceId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'work_schedule_template_id')
  final String? workScheduleTemplateId;
  @override
  @JsonKey(name: 'attendance_date')
  final String attendanceDate;
// V3: _utc suffix (TIMESTAMPTZ)
  @override
  @JsonKey(name: 'scheduled_start_time_utc')
  final String? scheduledStartTimeUtc;
  @override
  @JsonKey(name: 'scheduled_end_time_utc')
  final String? scheduledEndTimeUtc;
  @override
  @JsonKey(name: 'check_in_time_utc')
  final String? checkInTimeUtc;
  @override
  @JsonKey(name: 'check_out_time_utc')
  final String? checkOutTimeUtc;
  @override
  final String status;
  @override
  @JsonKey(name: 'is_late')
  final bool isLate;
  @override
  @JsonKey(name: 'is_early_leave')
  final bool isEarlyLeave;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'template_name')
  final String? templateName;
  @override
  @JsonKey(name: 'day_of_week')
  final int? dayOfWeek;
  @override
  final String? timezone;

  @override
  String toString() {
    return 'MonthlyAttendanceModel(attendanceId: $attendanceId, userId: $userId, companyId: $companyId, storeId: $storeId, workScheduleTemplateId: $workScheduleTemplateId, attendanceDate: $attendanceDate, scheduledStartTimeUtc: $scheduledStartTimeUtc, scheduledEndTimeUtc: $scheduledEndTimeUtc, checkInTimeUtc: $checkInTimeUtc, checkOutTimeUtc: $checkOutTimeUtc, status: $status, isLate: $isLate, isEarlyLeave: $isEarlyLeave, notes: $notes, templateName: $templateName, dayOfWeek: $dayOfWeek, timezone: $timezone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyAttendanceModelImpl &&
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
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
      dayOfWeek,
      timezone);

  /// Create a copy of MonthlyAttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyAttendanceModelImplCopyWith<_$MonthlyAttendanceModelImpl>
      get copyWith => __$$MonthlyAttendanceModelImplCopyWithImpl<
          _$MonthlyAttendanceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyAttendanceModelImplToJson(
      this,
    );
  }
}

abstract class _MonthlyAttendanceModel extends MonthlyAttendanceModel {
  const factory _MonthlyAttendanceModel(
      {@JsonKey(name: 'attendance_id') required final String attendanceId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'work_schedule_template_id')
      final String? workScheduleTemplateId,
      @JsonKey(name: 'attendance_date') required final String attendanceDate,
      @JsonKey(name: 'scheduled_start_time_utc')
      final String? scheduledStartTimeUtc,
      @JsonKey(name: 'scheduled_end_time_utc')
      final String? scheduledEndTimeUtc,
      @JsonKey(name: 'check_in_time_utc') final String? checkInTimeUtc,
      @JsonKey(name: 'check_out_time_utc') final String? checkOutTimeUtc,
      required final String status,
      @JsonKey(name: 'is_late') final bool isLate,
      @JsonKey(name: 'is_early_leave') final bool isEarlyLeave,
      final String? notes,
      @JsonKey(name: 'template_name') final String? templateName,
      @JsonKey(name: 'day_of_week') final int? dayOfWeek,
      final String? timezone}) = _$MonthlyAttendanceModelImpl;
  const _MonthlyAttendanceModel._() : super._();

  factory _MonthlyAttendanceModel.fromJson(Map<String, dynamic> json) =
      _$MonthlyAttendanceModelImpl.fromJson;

  @override
  @JsonKey(name: 'attendance_id')
  String get attendanceId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'work_schedule_template_id')
  String? get workScheduleTemplateId;
  @override
  @JsonKey(name: 'attendance_date')
  String get attendanceDate; // V3: _utc suffix (TIMESTAMPTZ)
  @override
  @JsonKey(name: 'scheduled_start_time_utc')
  String? get scheduledStartTimeUtc;
  @override
  @JsonKey(name: 'scheduled_end_time_utc')
  String? get scheduledEndTimeUtc;
  @override
  @JsonKey(name: 'check_in_time_utc')
  String? get checkInTimeUtc;
  @override
  @JsonKey(name: 'check_out_time_utc')
  String? get checkOutTimeUtc;
  @override
  String get status;
  @override
  @JsonKey(name: 'is_late')
  bool get isLate;
  @override
  @JsonKey(name: 'is_early_leave')
  bool get isEarlyLeave;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'template_name')
  String? get templateName;
  @override
  @JsonKey(name: 'day_of_week')
  int? get dayOfWeek;
  @override
  String? get timezone;

  /// Create a copy of MonthlyAttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyAttendanceModelImplCopyWith<_$MonthlyAttendanceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MonthlyCheckResultModel _$MonthlyCheckResultModelFromJson(
    Map<String, dynamic> json) {
  return _MonthlyCheckResultModel.fromJson(json);
}

/// @nodoc
mixin _$MonthlyCheckResultModel {
  bool get success => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// Serializes this MonthlyCheckResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyCheckResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyCheckResultModelCopyWith<MonthlyCheckResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyCheckResultModelCopyWith<$Res> {
  factory $MonthlyCheckResultModelCopyWith(MonthlyCheckResultModel value,
          $Res Function(MonthlyCheckResultModel) then) =
      _$MonthlyCheckResultModelCopyWithImpl<$Res, MonthlyCheckResultModel>;
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      Map<String, dynamic>? data});
}

/// @nodoc
class _$MonthlyCheckResultModelCopyWithImpl<$Res,
        $Val extends MonthlyCheckResultModel>
    implements $MonthlyCheckResultModelCopyWith<$Res> {
  _$MonthlyCheckResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyCheckResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? data = freezed,
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
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyCheckResultModelImplCopyWith<$Res>
    implements $MonthlyCheckResultModelCopyWith<$Res> {
  factory _$$MonthlyCheckResultModelImplCopyWith(
          _$MonthlyCheckResultModelImpl value,
          $Res Function(_$MonthlyCheckResultModelImpl) then) =
      __$$MonthlyCheckResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      Map<String, dynamic>? data});
}

/// @nodoc
class __$$MonthlyCheckResultModelImplCopyWithImpl<$Res>
    extends _$MonthlyCheckResultModelCopyWithImpl<$Res,
        _$MonthlyCheckResultModelImpl>
    implements _$$MonthlyCheckResultModelImplCopyWith<$Res> {
  __$$MonthlyCheckResultModelImplCopyWithImpl(
      _$MonthlyCheckResultModelImpl _value,
      $Res Function(_$MonthlyCheckResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyCheckResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_$MonthlyCheckResultModelImpl(
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
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyCheckResultModelImpl extends _MonthlyCheckResultModel {
  const _$MonthlyCheckResultModelImpl(
      {required this.success,
      this.error,
      this.message,
      final Map<String, dynamic>? data})
      : _data = data,
        super._();

  factory _$MonthlyCheckResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyCheckResultModelImplFromJson(json);

  @override
  final bool success;
  @override
  final String? error;
  @override
  final String? message;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MonthlyCheckResultModel(success: $success, error: $error, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyCheckResultModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, error, message,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of MonthlyCheckResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyCheckResultModelImplCopyWith<_$MonthlyCheckResultModelImpl>
      get copyWith => __$$MonthlyCheckResultModelImplCopyWithImpl<
          _$MonthlyCheckResultModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyCheckResultModelImplToJson(
      this,
    );
  }
}

abstract class _MonthlyCheckResultModel extends MonthlyCheckResultModel {
  const factory _MonthlyCheckResultModel(
      {required final bool success,
      final String? error,
      final String? message,
      final Map<String, dynamic>? data}) = _$MonthlyCheckResultModelImpl;
  const _MonthlyCheckResultModel._() : super._();

  factory _MonthlyCheckResultModel.fromJson(Map<String, dynamic> json) =
      _$MonthlyCheckResultModelImpl.fromJson;

  @override
  bool get success;
  @override
  String? get error;
  @override
  String? get message;
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of MonthlyCheckResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyCheckResultModelImplCopyWith<_$MonthlyCheckResultModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MonthlyAttendanceStatsModel _$MonthlyAttendanceStatsModelFromJson(
    Map<String, dynamic> json) {
  return _MonthlyAttendanceStatsModel.fromJson(json);
}

/// @nodoc
mixin _$MonthlyAttendanceStatsModel {
  bool get success => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  Map<String, dynamic>? get period => throw _privateConstructorUsedError;
  Map<String, dynamic>? get today => throw _privateConstructorUsedError;
  Map<String, dynamic>? get stats => throw _privateConstructorUsedError;

  /// Serializes this MonthlyAttendanceStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyAttendanceStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyAttendanceStatsModelCopyWith<MonthlyAttendanceStatsModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyAttendanceStatsModelCopyWith<$Res> {
  factory $MonthlyAttendanceStatsModelCopyWith(
          MonthlyAttendanceStatsModel value,
          $Res Function(MonthlyAttendanceStatsModel) then) =
      _$MonthlyAttendanceStatsModelCopyWithImpl<$Res,
          MonthlyAttendanceStatsModel>;
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      String? timezone,
      Map<String, dynamic>? period,
      Map<String, dynamic>? today,
      Map<String, dynamic>? stats});
}

/// @nodoc
class _$MonthlyAttendanceStatsModelCopyWithImpl<$Res,
        $Val extends MonthlyAttendanceStatsModel>
    implements $MonthlyAttendanceStatsModelCopyWith<$Res> {
  _$MonthlyAttendanceStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyAttendanceStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? timezone = freezed,
    Object? period = freezed,
    Object? today = freezed,
    Object? stats = freezed,
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
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      period: freezed == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      today: freezed == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyAttendanceStatsModelImplCopyWith<$Res>
    implements $MonthlyAttendanceStatsModelCopyWith<$Res> {
  factory _$$MonthlyAttendanceStatsModelImplCopyWith(
          _$MonthlyAttendanceStatsModelImpl value,
          $Res Function(_$MonthlyAttendanceStatsModelImpl) then) =
      __$$MonthlyAttendanceStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      String? timezone,
      Map<String, dynamic>? period,
      Map<String, dynamic>? today,
      Map<String, dynamic>? stats});
}

/// @nodoc
class __$$MonthlyAttendanceStatsModelImplCopyWithImpl<$Res>
    extends _$MonthlyAttendanceStatsModelCopyWithImpl<$Res,
        _$MonthlyAttendanceStatsModelImpl>
    implements _$$MonthlyAttendanceStatsModelImplCopyWith<$Res> {
  __$$MonthlyAttendanceStatsModelImplCopyWithImpl(
      _$MonthlyAttendanceStatsModelImpl _value,
      $Res Function(_$MonthlyAttendanceStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyAttendanceStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? timezone = freezed,
    Object? period = freezed,
    Object? today = freezed,
    Object? stats = freezed,
  }) {
    return _then(_$MonthlyAttendanceStatsModelImpl(
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
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      period: freezed == period
          ? _value._period
          : period // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      today: freezed == today
          ? _value._today
          : today // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      stats: freezed == stats
          ? _value._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyAttendanceStatsModelImpl extends _MonthlyAttendanceStatsModel {
  const _$MonthlyAttendanceStatsModelImpl(
      {required this.success,
      this.error,
      this.message,
      this.timezone,
      final Map<String, dynamic>? period,
      final Map<String, dynamic>? today,
      final Map<String, dynamic>? stats})
      : _period = period,
        _today = today,
        _stats = stats,
        super._();

  factory _$MonthlyAttendanceStatsModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MonthlyAttendanceStatsModelImplFromJson(json);

  @override
  final bool success;
  @override
  final String? error;
  @override
  final String? message;
  @override
  final String? timezone;
  final Map<String, dynamic>? _period;
  @override
  Map<String, dynamic>? get period {
    final value = _period;
    if (value == null) return null;
    if (_period is EqualUnmodifiableMapView) return _period;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _today;
  @override
  Map<String, dynamic>? get today {
    final value = _today;
    if (value == null) return null;
    if (_today is EqualUnmodifiableMapView) return _today;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _stats;
  @override
  Map<String, dynamic>? get stats {
    final value = _stats;
    if (value == null) return null;
    if (_stats is EqualUnmodifiableMapView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MonthlyAttendanceStatsModel(success: $success, error: $error, message: $message, timezone: $timezone, period: $period, today: $today, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyAttendanceStatsModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            const DeepCollectionEquality().equals(other._period, _period) &&
            const DeepCollectionEquality().equals(other._today, _today) &&
            const DeepCollectionEquality().equals(other._stats, _stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      error,
      message,
      timezone,
      const DeepCollectionEquality().hash(_period),
      const DeepCollectionEquality().hash(_today),
      const DeepCollectionEquality().hash(_stats));

  /// Create a copy of MonthlyAttendanceStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyAttendanceStatsModelImplCopyWith<_$MonthlyAttendanceStatsModelImpl>
      get copyWith => __$$MonthlyAttendanceStatsModelImplCopyWithImpl<
          _$MonthlyAttendanceStatsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyAttendanceStatsModelImplToJson(
      this,
    );
  }
}

abstract class _MonthlyAttendanceStatsModel
    extends MonthlyAttendanceStatsModel {
  const factory _MonthlyAttendanceStatsModel(
      {required final bool success,
      final String? error,
      final String? message,
      final String? timezone,
      final Map<String, dynamic>? period,
      final Map<String, dynamic>? today,
      final Map<String, dynamic>? stats}) = _$MonthlyAttendanceStatsModelImpl;
  const _MonthlyAttendanceStatsModel._() : super._();

  factory _MonthlyAttendanceStatsModel.fromJson(Map<String, dynamic> json) =
      _$MonthlyAttendanceStatsModelImpl.fromJson;

  @override
  bool get success;
  @override
  String? get error;
  @override
  String? get message;
  @override
  String? get timezone;
  @override
  Map<String, dynamic>? get period;
  @override
  Map<String, dynamic>? get today;
  @override
  Map<String, dynamic>? get stats;

  /// Create a copy of MonthlyAttendanceStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyAttendanceStatsModelImplCopyWith<_$MonthlyAttendanceStatsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MonthlyAttendanceListModel _$MonthlyAttendanceListModelFromJson(
    Map<String, dynamic> json) {
  return _MonthlyAttendanceListModel.fromJson(json);
}

/// @nodoc
mixin _$MonthlyAttendanceListModel {
  bool get success => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  Map<String, dynamic>? get period => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get data => throw _privateConstructorUsedError;

  /// Serializes this MonthlyAttendanceListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyAttendanceListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyAttendanceListModelCopyWith<MonthlyAttendanceListModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyAttendanceListModelCopyWith<$Res> {
  factory $MonthlyAttendanceListModelCopyWith(MonthlyAttendanceListModel value,
          $Res Function(MonthlyAttendanceListModel) then) =
      _$MonthlyAttendanceListModelCopyWithImpl<$Res,
          MonthlyAttendanceListModel>;
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      String? timezone,
      Map<String, dynamic>? period,
      int count,
      List<Map<String, dynamic>> data});
}

/// @nodoc
class _$MonthlyAttendanceListModelCopyWithImpl<$Res,
        $Val extends MonthlyAttendanceListModel>
    implements $MonthlyAttendanceListModelCopyWith<$Res> {
  _$MonthlyAttendanceListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyAttendanceListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? timezone = freezed,
    Object? period = freezed,
    Object? count = null,
    Object? data = null,
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
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      period: freezed == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyAttendanceListModelImplCopyWith<$Res>
    implements $MonthlyAttendanceListModelCopyWith<$Res> {
  factory _$$MonthlyAttendanceListModelImplCopyWith(
          _$MonthlyAttendanceListModelImpl value,
          $Res Function(_$MonthlyAttendanceListModelImpl) then) =
      __$$MonthlyAttendanceListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      String? timezone,
      Map<String, dynamic>? period,
      int count,
      List<Map<String, dynamic>> data});
}

/// @nodoc
class __$$MonthlyAttendanceListModelImplCopyWithImpl<$Res>
    extends _$MonthlyAttendanceListModelCopyWithImpl<$Res,
        _$MonthlyAttendanceListModelImpl>
    implements _$$MonthlyAttendanceListModelImplCopyWith<$Res> {
  __$$MonthlyAttendanceListModelImplCopyWithImpl(
      _$MonthlyAttendanceListModelImpl _value,
      $Res Function(_$MonthlyAttendanceListModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyAttendanceListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? timezone = freezed,
    Object? period = freezed,
    Object? count = null,
    Object? data = null,
  }) {
    return _then(_$MonthlyAttendanceListModelImpl(
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
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      period: freezed == period
          ? _value._period
          : period // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyAttendanceListModelImpl extends _MonthlyAttendanceListModel {
  const _$MonthlyAttendanceListModelImpl(
      {required this.success,
      this.error,
      this.message,
      this.timezone,
      final Map<String, dynamic>? period,
      this.count = 0,
      final List<Map<String, dynamic>> data = const []})
      : _period = period,
        _data = data,
        super._();

  factory _$MonthlyAttendanceListModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MonthlyAttendanceListModelImplFromJson(json);

  @override
  final bool success;
  @override
  final String? error;
  @override
  final String? message;
  @override
  final String? timezone;
  final Map<String, dynamic>? _period;
  @override
  Map<String, dynamic>? get period {
    final value = _period;
    if (value == null) return null;
    if (_period is EqualUnmodifiableMapView) return _period;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int count;
  final List<Map<String, dynamic>> _data;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'MonthlyAttendanceListModel(success: $success, error: $error, message: $message, timezone: $timezone, period: $period, count: $count, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyAttendanceListModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            const DeepCollectionEquality().equals(other._period, _period) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      error,
      message,
      timezone,
      const DeepCollectionEquality().hash(_period),
      count,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of MonthlyAttendanceListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyAttendanceListModelImplCopyWith<_$MonthlyAttendanceListModelImpl>
      get copyWith => __$$MonthlyAttendanceListModelImplCopyWithImpl<
          _$MonthlyAttendanceListModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyAttendanceListModelImplToJson(
      this,
    );
  }
}

abstract class _MonthlyAttendanceListModel extends MonthlyAttendanceListModel {
  const factory _MonthlyAttendanceListModel(
          {required final bool success,
          final String? error,
          final String? message,
          final String? timezone,
          final Map<String, dynamic>? period,
          final int count,
          final List<Map<String, dynamic>> data}) =
      _$MonthlyAttendanceListModelImpl;
  const _MonthlyAttendanceListModel._() : super._();

  factory _MonthlyAttendanceListModel.fromJson(Map<String, dynamic> json) =
      _$MonthlyAttendanceListModelImpl.fromJson;

  @override
  bool get success;
  @override
  String? get error;
  @override
  String? get message;
  @override
  String? get timezone;
  @override
  Map<String, dynamic>? get period;
  @override
  int get count;
  @override
  List<Map<String, dynamic>> get data;

  /// Create a copy of MonthlyAttendanceListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyAttendanceListModelImplCopyWith<_$MonthlyAttendanceListModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
