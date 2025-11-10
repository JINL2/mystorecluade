// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_card_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShiftCardData {
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_id')
  String get shiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_date')
  String get requestDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_month')
  String get requestMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_time')
  String get shiftTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_start_time')
  DateTime? get shiftStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_end_time')
  DateTime? get shiftEndTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_start_time')
  DateTime? get actualStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_end_time')
  DateTime? get actualEndTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirm_start_time')
  DateTime? get confirmStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirm_end_time')
  DateTime? get confirmEndTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_reported')
  bool get isReported => throw _privateConstructorUsedError;
  @JsonKey(name: 'approval_status')
  String? get approvalStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'report_reason')
  String? get reportReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_name')
  String? get shiftName => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_minutes')
  int get lateMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'overtime_minutes')
  int get overtimeMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'worked_minutes')
  int? get workedMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_hours')
  double? get scheduledHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_hours')
  double? get paidHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_type')
  String? get salaryType => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_amount')
  double? get salaryAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_pay')
  double? get basePay => throw _privateConstructorUsedError;
  @JsonKey(name: 'bonus_amount')
  double? get bonusAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pay_with_bonus')
  double? get totalPayWithBonus => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of ShiftCardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftCardDataCopyWith<ShiftCardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftCardDataCopyWith<$Res> {
  factory $ShiftCardDataCopyWith(
          ShiftCardData value, $Res Function(ShiftCardData) then) =
      _$ShiftCardDataCopyWithImpl<$Res, ShiftCardData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'request_month') String requestMonth,
      @JsonKey(name: 'shift_time') String shiftTime,
      @JsonKey(name: 'shift_start_time') DateTime? shiftStartTime,
      @JsonKey(name: 'shift_end_time') DateTime? shiftEndTime,
      @JsonKey(name: 'actual_start_time') DateTime? actualStartTime,
      @JsonKey(name: 'actual_end_time') DateTime? actualEndTime,
      @JsonKey(name: 'confirm_start_time') DateTime? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') DateTime? confirmEndTime,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'is_reported') bool isReported,
      @JsonKey(name: 'approval_status') String? approvalStatus,
      @JsonKey(name: 'report_reason') String? reportReason,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'late_minutes') int lateMinutes,
      @JsonKey(name: 'overtime_minutes') int overtimeMinutes,
      @JsonKey(name: 'worked_minutes') int? workedMinutes,
      @JsonKey(name: 'scheduled_hours') double? scheduledHours,
      @JsonKey(name: 'paid_hours') double? paidHours,
      @JsonKey(name: 'salary_type') String? salaryType,
      @JsonKey(name: 'salary_amount') double? salaryAmount,
      @JsonKey(name: 'base_pay') double? basePay,
      @JsonKey(name: 'bonus_amount') double? bonusAmount,
      @JsonKey(name: 'total_pay_with_bonus') double? totalPayWithBonus,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$ShiftCardDataCopyWithImpl<$Res, $Val extends ShiftCardData>
    implements $ShiftCardDataCopyWith<$Res> {
  _$ShiftCardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftCardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? userId = null,
    Object? storeId = null,
    Object? shiftId = null,
    Object? requestDate = null,
    Object? requestMonth = null,
    Object? shiftTime = null,
    Object? shiftStartTime = freezed,
    Object? shiftEndTime = freezed,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? confirmStartTime = freezed,
    Object? confirmEndTime = freezed,
    Object? isApproved = null,
    Object? isReported = null,
    Object? approvalStatus = freezed,
    Object? reportReason = freezed,
    Object? storeName = freezed,
    Object? shiftName = freezed,
    Object? lateMinutes = null,
    Object? overtimeMinutes = null,
    Object? workedMinutes = freezed,
    Object? scheduledHours = freezed,
    Object? paidHours = freezed,
    Object? salaryType = freezed,
    Object? salaryAmount = freezed,
    Object? basePay = freezed,
    Object? bonusAmount = freezed,
    Object? totalPayWithBonus = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      requestMonth: null == requestMonth
          ? _value.requestMonth
          : requestMonth // ignore: cast_nullable_to_non_nullable
              as String,
      shiftTime: null == shiftTime
          ? _value.shiftTime
          : shiftTime // ignore: cast_nullable_to_non_nullable
              as String,
      shiftStartTime: freezed == shiftStartTime
          ? _value.shiftStartTime
          : shiftStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shiftEndTime: freezed == shiftEndTime
          ? _value.shiftEndTime
          : shiftEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmStartTime: freezed == confirmStartTime
          ? _value.confirmStartTime
          : confirmStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmEndTime: freezed == confirmEndTime
          ? _value.confirmEndTime
          : confirmEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      approvalStatus: freezed == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      reportReason: freezed == reportReason
          ? _value.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      lateMinutes: null == lateMinutes
          ? _value.lateMinutes
          : lateMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      overtimeMinutes: null == overtimeMinutes
          ? _value.overtimeMinutes
          : overtimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      workedMinutes: freezed == workedMinutes
          ? _value.workedMinutes
          : workedMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledHours: freezed == scheduledHours
          ? _value.scheduledHours
          : scheduledHours // ignore: cast_nullable_to_non_nullable
              as double?,
      paidHours: freezed == paidHours
          ? _value.paidHours
          : paidHours // ignore: cast_nullable_to_non_nullable
              as double?,
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryAmount: freezed == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      basePay: freezed == basePay
          ? _value.basePay
          : basePay // ignore: cast_nullable_to_non_nullable
              as double?,
      bonusAmount: freezed == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      totalPayWithBonus: freezed == totalPayWithBonus
          ? _value.totalPayWithBonus
          : totalPayWithBonus // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftCardDataImplCopyWith<$Res>
    implements $ShiftCardDataCopyWith<$Res> {
  factory _$$ShiftCardDataImplCopyWith(
          _$ShiftCardDataImpl value, $Res Function(_$ShiftCardDataImpl) then) =
      __$$ShiftCardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'request_month') String requestMonth,
      @JsonKey(name: 'shift_time') String shiftTime,
      @JsonKey(name: 'shift_start_time') DateTime? shiftStartTime,
      @JsonKey(name: 'shift_end_time') DateTime? shiftEndTime,
      @JsonKey(name: 'actual_start_time') DateTime? actualStartTime,
      @JsonKey(name: 'actual_end_time') DateTime? actualEndTime,
      @JsonKey(name: 'confirm_start_time') DateTime? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') DateTime? confirmEndTime,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'is_reported') bool isReported,
      @JsonKey(name: 'approval_status') String? approvalStatus,
      @JsonKey(name: 'report_reason') String? reportReason,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'late_minutes') int lateMinutes,
      @JsonKey(name: 'overtime_minutes') int overtimeMinutes,
      @JsonKey(name: 'worked_minutes') int? workedMinutes,
      @JsonKey(name: 'scheduled_hours') double? scheduledHours,
      @JsonKey(name: 'paid_hours') double? paidHours,
      @JsonKey(name: 'salary_type') String? salaryType,
      @JsonKey(name: 'salary_amount') double? salaryAmount,
      @JsonKey(name: 'base_pay') double? basePay,
      @JsonKey(name: 'bonus_amount') double? bonusAmount,
      @JsonKey(name: 'total_pay_with_bonus') double? totalPayWithBonus,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$ShiftCardDataImplCopyWithImpl<$Res>
    extends _$ShiftCardDataCopyWithImpl<$Res, _$ShiftCardDataImpl>
    implements _$$ShiftCardDataImplCopyWith<$Res> {
  __$$ShiftCardDataImplCopyWithImpl(
      _$ShiftCardDataImpl _value, $Res Function(_$ShiftCardDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftCardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? userId = null,
    Object? storeId = null,
    Object? shiftId = null,
    Object? requestDate = null,
    Object? requestMonth = null,
    Object? shiftTime = null,
    Object? shiftStartTime = freezed,
    Object? shiftEndTime = freezed,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? confirmStartTime = freezed,
    Object? confirmEndTime = freezed,
    Object? isApproved = null,
    Object? isReported = null,
    Object? approvalStatus = freezed,
    Object? reportReason = freezed,
    Object? storeName = freezed,
    Object? shiftName = freezed,
    Object? lateMinutes = null,
    Object? overtimeMinutes = null,
    Object? workedMinutes = freezed,
    Object? scheduledHours = freezed,
    Object? paidHours = freezed,
    Object? salaryType = freezed,
    Object? salaryAmount = freezed,
    Object? basePay = freezed,
    Object? bonusAmount = freezed,
    Object? totalPayWithBonus = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ShiftCardDataImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      requestMonth: null == requestMonth
          ? _value.requestMonth
          : requestMonth // ignore: cast_nullable_to_non_nullable
              as String,
      shiftTime: null == shiftTime
          ? _value.shiftTime
          : shiftTime // ignore: cast_nullable_to_non_nullable
              as String,
      shiftStartTime: freezed == shiftStartTime
          ? _value.shiftStartTime
          : shiftStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shiftEndTime: freezed == shiftEndTime
          ? _value.shiftEndTime
          : shiftEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmStartTime: freezed == confirmStartTime
          ? _value.confirmStartTime
          : confirmStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmEndTime: freezed == confirmEndTime
          ? _value.confirmEndTime
          : confirmEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      approvalStatus: freezed == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      reportReason: freezed == reportReason
          ? _value.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      lateMinutes: null == lateMinutes
          ? _value.lateMinutes
          : lateMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      overtimeMinutes: null == overtimeMinutes
          ? _value.overtimeMinutes
          : overtimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      workedMinutes: freezed == workedMinutes
          ? _value.workedMinutes
          : workedMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledHours: freezed == scheduledHours
          ? _value.scheduledHours
          : scheduledHours // ignore: cast_nullable_to_non_nullable
              as double?,
      paidHours: freezed == paidHours
          ? _value.paidHours
          : paidHours // ignore: cast_nullable_to_non_nullable
              as double?,
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryAmount: freezed == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      basePay: freezed == basePay
          ? _value.basePay
          : basePay // ignore: cast_nullable_to_non_nullable
              as double?,
      bonusAmount: freezed == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      totalPayWithBonus: freezed == totalPayWithBonus
          ? _value.totalPayWithBonus
          : totalPayWithBonus // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ShiftCardDataImpl extends _ShiftCardData {
  const _$ShiftCardDataImpl(
      {@JsonKey(name: 'shift_request_id') required this.shiftRequestId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'shift_id') required this.shiftId,
      @JsonKey(name: 'request_date') required this.requestDate,
      @JsonKey(name: 'request_month') required this.requestMonth,
      @JsonKey(name: 'shift_time') required this.shiftTime,
      @JsonKey(name: 'shift_start_time') this.shiftStartTime,
      @JsonKey(name: 'shift_end_time') this.shiftEndTime,
      @JsonKey(name: 'actual_start_time') this.actualStartTime,
      @JsonKey(name: 'actual_end_time') this.actualEndTime,
      @JsonKey(name: 'confirm_start_time') this.confirmStartTime,
      @JsonKey(name: 'confirm_end_time') this.confirmEndTime,
      @JsonKey(name: 'is_approved') this.isApproved = false,
      @JsonKey(name: 'is_reported') this.isReported = false,
      @JsonKey(name: 'approval_status') this.approvalStatus,
      @JsonKey(name: 'report_reason') this.reportReason,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'shift_name') this.shiftName,
      @JsonKey(name: 'late_minutes') this.lateMinutes = 0,
      @JsonKey(name: 'overtime_minutes') this.overtimeMinutes = 0,
      @JsonKey(name: 'worked_minutes') this.workedMinutes,
      @JsonKey(name: 'scheduled_hours') this.scheduledHours,
      @JsonKey(name: 'paid_hours') this.paidHours,
      @JsonKey(name: 'salary_type') this.salaryType,
      @JsonKey(name: 'salary_amount') this.salaryAmount,
      @JsonKey(name: 'base_pay') this.basePay,
      @JsonKey(name: 'bonus_amount') this.bonusAmount,
      @JsonKey(name: 'total_pay_with_bonus') this.totalPayWithBonus,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'shift_id')
  final String shiftId;
  @override
  @JsonKey(name: 'request_date')
  final String requestDate;
  @override
  @JsonKey(name: 'request_month')
  final String requestMonth;
  @override
  @JsonKey(name: 'shift_time')
  final String shiftTime;
  @override
  @JsonKey(name: 'shift_start_time')
  final DateTime? shiftStartTime;
  @override
  @JsonKey(name: 'shift_end_time')
  final DateTime? shiftEndTime;
  @override
  @JsonKey(name: 'actual_start_time')
  final DateTime? actualStartTime;
  @override
  @JsonKey(name: 'actual_end_time')
  final DateTime? actualEndTime;
  @override
  @JsonKey(name: 'confirm_start_time')
  final DateTime? confirmStartTime;
  @override
  @JsonKey(name: 'confirm_end_time')
  final DateTime? confirmEndTime;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'is_reported')
  final bool isReported;
  @override
  @JsonKey(name: 'approval_status')
  final String? approvalStatus;
  @override
  @JsonKey(name: 'report_reason')
  final String? reportReason;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
  @override
  @JsonKey(name: 'shift_name')
  final String? shiftName;
  @override
  @JsonKey(name: 'late_minutes')
  final int lateMinutes;
  @override
  @JsonKey(name: 'overtime_minutes')
  final int overtimeMinutes;
  @override
  @JsonKey(name: 'worked_minutes')
  final int? workedMinutes;
  @override
  @JsonKey(name: 'scheduled_hours')
  final double? scheduledHours;
  @override
  @JsonKey(name: 'paid_hours')
  final double? paidHours;
  @override
  @JsonKey(name: 'salary_type')
  final String? salaryType;
  @override
  @JsonKey(name: 'salary_amount')
  final double? salaryAmount;
  @override
  @JsonKey(name: 'base_pay')
  final double? basePay;
  @override
  @JsonKey(name: 'bonus_amount')
  final double? bonusAmount;
  @override
  @JsonKey(name: 'total_pay_with_bonus')
  final double? totalPayWithBonus;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ShiftCardData(shiftRequestId: $shiftRequestId, userId: $userId, storeId: $storeId, shiftId: $shiftId, requestDate: $requestDate, requestMonth: $requestMonth, shiftTime: $shiftTime, shiftStartTime: $shiftStartTime, shiftEndTime: $shiftEndTime, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, confirmStartTime: $confirmStartTime, confirmEndTime: $confirmEndTime, isApproved: $isApproved, isReported: $isReported, approvalStatus: $approvalStatus, reportReason: $reportReason, storeName: $storeName, shiftName: $shiftName, lateMinutes: $lateMinutes, overtimeMinutes: $overtimeMinutes, workedMinutes: $workedMinutes, scheduledHours: $scheduledHours, paidHours: $paidHours, salaryType: $salaryType, salaryAmount: $salaryAmount, basePay: $basePay, bonusAmount: $bonusAmount, totalPayWithBonus: $totalPayWithBonus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftCardDataImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.requestMonth, requestMonth) ||
                other.requestMonth == requestMonth) &&
            (identical(other.shiftTime, shiftTime) ||
                other.shiftTime == shiftTime) &&
            (identical(other.shiftStartTime, shiftStartTime) ||
                other.shiftStartTime == shiftStartTime) &&
            (identical(other.shiftEndTime, shiftEndTime) ||
                other.shiftEndTime == shiftEndTime) &&
            (identical(other.actualStartTime, actualStartTime) ||
                other.actualStartTime == actualStartTime) &&
            (identical(other.actualEndTime, actualEndTime) ||
                other.actualEndTime == actualEndTime) &&
            (identical(other.confirmStartTime, confirmStartTime) ||
                other.confirmStartTime == confirmStartTime) &&
            (identical(other.confirmEndTime, confirmEndTime) ||
                other.confirmEndTime == confirmEndTime) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.isReported, isReported) ||
                other.isReported == isReported) &&
            (identical(other.approvalStatus, approvalStatus) ||
                other.approvalStatus == approvalStatus) &&
            (identical(other.reportReason, reportReason) ||
                other.reportReason == reportReason) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.lateMinutes, lateMinutes) ||
                other.lateMinutes == lateMinutes) &&
            (identical(other.overtimeMinutes, overtimeMinutes) ||
                other.overtimeMinutes == overtimeMinutes) &&
            (identical(other.workedMinutes, workedMinutes) ||
                other.workedMinutes == workedMinutes) &&
            (identical(other.scheduledHours, scheduledHours) ||
                other.scheduledHours == scheduledHours) &&
            (identical(other.paidHours, paidHours) ||
                other.paidHours == paidHours) &&
            (identical(other.salaryType, salaryType) ||
                other.salaryType == salaryType) &&
            (identical(other.salaryAmount, salaryAmount) ||
                other.salaryAmount == salaryAmount) &&
            (identical(other.basePay, basePay) || other.basePay == basePay) &&
            (identical(other.bonusAmount, bonusAmount) ||
                other.bonusAmount == bonusAmount) &&
            (identical(other.totalPayWithBonus, totalPayWithBonus) ||
                other.totalPayWithBonus == totalPayWithBonus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        shiftRequestId,
        userId,
        storeId,
        shiftId,
        requestDate,
        requestMonth,
        shiftTime,
        shiftStartTime,
        shiftEndTime,
        actualStartTime,
        actualEndTime,
        confirmStartTime,
        confirmEndTime,
        isApproved,
        isReported,
        approvalStatus,
        reportReason,
        storeName,
        shiftName,
        lateMinutes,
        overtimeMinutes,
        workedMinutes,
        scheduledHours,
        paidHours,
        salaryType,
        salaryAmount,
        basePay,
        bonusAmount,
        totalPayWithBonus,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of ShiftCardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftCardDataImplCopyWith<_$ShiftCardDataImpl> get copyWith =>
      __$$ShiftCardDataImplCopyWithImpl<_$ShiftCardDataImpl>(this, _$identity);
}

abstract class _ShiftCardData extends ShiftCardData {
  const factory _ShiftCardData(
      {@JsonKey(name: 'shift_request_id') required final String shiftRequestId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'store_id') required final String storeId,
      @JsonKey(name: 'shift_id') required final String shiftId,
      @JsonKey(name: 'request_date') required final String requestDate,
      @JsonKey(name: 'request_month') required final String requestMonth,
      @JsonKey(name: 'shift_time') required final String shiftTime,
      @JsonKey(name: 'shift_start_time') final DateTime? shiftStartTime,
      @JsonKey(name: 'shift_end_time') final DateTime? shiftEndTime,
      @JsonKey(name: 'actual_start_time') final DateTime? actualStartTime,
      @JsonKey(name: 'actual_end_time') final DateTime? actualEndTime,
      @JsonKey(name: 'confirm_start_time') final DateTime? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') final DateTime? confirmEndTime,
      @JsonKey(name: 'is_approved') final bool isApproved,
      @JsonKey(name: 'is_reported') final bool isReported,
      @JsonKey(name: 'approval_status') final String? approvalStatus,
      @JsonKey(name: 'report_reason') final String? reportReason,
      @JsonKey(name: 'store_name') final String? storeName,
      @JsonKey(name: 'shift_name') final String? shiftName,
      @JsonKey(name: 'late_minutes') final int lateMinutes,
      @JsonKey(name: 'overtime_minutes') final int overtimeMinutes,
      @JsonKey(name: 'worked_minutes') final int? workedMinutes,
      @JsonKey(name: 'scheduled_hours') final double? scheduledHours,
      @JsonKey(name: 'paid_hours') final double? paidHours,
      @JsonKey(name: 'salary_type') final String? salaryType,
      @JsonKey(name: 'salary_amount') final double? salaryAmount,
      @JsonKey(name: 'base_pay') final double? basePay,
      @JsonKey(name: 'bonus_amount') final double? bonusAmount,
      @JsonKey(name: 'total_pay_with_bonus') final double? totalPayWithBonus,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$ShiftCardDataImpl;
  const _ShiftCardData._() : super._();

  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'shift_id')
  String get shiftId;
  @override
  @JsonKey(name: 'request_date')
  String get requestDate;
  @override
  @JsonKey(name: 'request_month')
  String get requestMonth;
  @override
  @JsonKey(name: 'shift_time')
  String get shiftTime;
  @override
  @JsonKey(name: 'shift_start_time')
  DateTime? get shiftStartTime;
  @override
  @JsonKey(name: 'shift_end_time')
  DateTime? get shiftEndTime;
  @override
  @JsonKey(name: 'actual_start_time')
  DateTime? get actualStartTime;
  @override
  @JsonKey(name: 'actual_end_time')
  DateTime? get actualEndTime;
  @override
  @JsonKey(name: 'confirm_start_time')
  DateTime? get confirmStartTime;
  @override
  @JsonKey(name: 'confirm_end_time')
  DateTime? get confirmEndTime;
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'is_reported')
  bool get isReported;
  @override
  @JsonKey(name: 'approval_status')
  String? get approvalStatus;
  @override
  @JsonKey(name: 'report_reason')
  String? get reportReason;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;
  @override
  @JsonKey(name: 'shift_name')
  String? get shiftName;
  @override
  @JsonKey(name: 'late_minutes')
  int get lateMinutes;
  @override
  @JsonKey(name: 'overtime_minutes')
  int get overtimeMinutes;
  @override
  @JsonKey(name: 'worked_minutes')
  int? get workedMinutes;
  @override
  @JsonKey(name: 'scheduled_hours')
  double? get scheduledHours;
  @override
  @JsonKey(name: 'paid_hours')
  double? get paidHours;
  @override
  @JsonKey(name: 'salary_type')
  String? get salaryType;
  @override
  @JsonKey(name: 'salary_amount')
  double? get salaryAmount;
  @override
  @JsonKey(name: 'base_pay')
  double? get basePay;
  @override
  @JsonKey(name: 'bonus_amount')
  double? get bonusAmount;
  @override
  @JsonKey(name: 'total_pay_with_bonus')
  double? get totalPayWithBonus;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of ShiftCardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftCardDataImplCopyWith<_$ShiftCardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
