// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftCard _$ShiftCardFromJson(Map<String, dynamic> json) {
  return _ShiftCard.fromJson(json);
}

/// @nodoc
mixin _$ShiftCard {
// Basic info
  @JsonKey(name: 'request_date')
  String get requestDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_time')
  String get shiftTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError; // Schedule
  @JsonKey(name: 'scheduled_hours')
  double get scheduledHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved =>
      throw _privateConstructorUsedError; // Actual times (nullable - might not be checked in/out yet)
  @JsonKey(name: 'actual_start_time')
  String? get actualStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_end_time')
  String? get actualEndTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirm_start_time')
  String? get confirmStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirm_end_time')
  String? get confirmEndTime =>
      throw _privateConstructorUsedError; // Work hours
  @JsonKey(name: 'paid_hours')
  double get paidHours => throw _privateConstructorUsedError; // Late status
  @JsonKey(name: 'is_late')
  bool get isLate => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_minutes')
  num get lateMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_deducut_amount')
  double get lateDeducutAmount =>
      throw _privateConstructorUsedError; // Overtime
  @JsonKey(name: 'is_extratime')
  bool get isExtratime => throw _privateConstructorUsedError;
  @JsonKey(name: 'overtime_minutes')
  num get overtimeMinutes =>
      throw _privateConstructorUsedError; // Pay (some are formatted strings with commas)
  @JsonKey(name: 'base_pay')
  String get basePay => throw _privateConstructorUsedError;
  @JsonKey(name: 'bonus_amount')
  double get bonusAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pay_with_bonus')
  String get totalPayWithBonus => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_type')
  String get salaryType => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_amount')
  String get salaryAmount =>
      throw _privateConstructorUsedError; // Location validation
  @JsonKey(name: 'is_valid_checkin_location')
  bool? get isValidCheckinLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkin_distance_from_store')
  double? get checkinDistanceFromStore => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkout_distance_from_store')
  double? get checkoutDistanceFromStore =>
      throw _privateConstructorUsedError; // Problem reporting
  @JsonKey(name: 'is_reported')
  bool get isReported => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_problem')
  bool get isProblem => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_problem_solved')
  bool get isProblemSolved => throw _privateConstructorUsedError;

  /// Serializes this ShiftCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftCardCopyWith<ShiftCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftCardCopyWith<$Res> {
  factory $ShiftCardCopyWith(ShiftCard value, $Res Function(ShiftCard) then) =
      _$ShiftCardCopyWithImpl<$Res, ShiftCard>;
  @useResult
  $Res call(
      {@JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'shift_time') String shiftTime,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'scheduled_hours') double scheduledHours,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'actual_start_time') String? actualStartTime,
      @JsonKey(name: 'actual_end_time') String? actualEndTime,
      @JsonKey(name: 'confirm_start_time') String? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') String? confirmEndTime,
      @JsonKey(name: 'paid_hours') double paidHours,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'late_minutes') num lateMinutes,
      @JsonKey(name: 'late_deducut_amount') double lateDeducutAmount,
      @JsonKey(name: 'is_extratime') bool isExtratime,
      @JsonKey(name: 'overtime_minutes') num overtimeMinutes,
      @JsonKey(name: 'base_pay') String basePay,
      @JsonKey(name: 'bonus_amount') double bonusAmount,
      @JsonKey(name: 'total_pay_with_bonus') String totalPayWithBonus,
      @JsonKey(name: 'salary_type') String salaryType,
      @JsonKey(name: 'salary_amount') String salaryAmount,
      @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      double? checkinDistanceFromStore,
      @JsonKey(name: 'checkout_distance_from_store')
      double? checkoutDistanceFromStore,
      @JsonKey(name: 'is_reported') bool isReported,
      @JsonKey(name: 'is_problem') bool isProblem,
      @JsonKey(name: 'is_problem_solved') bool isProblemSolved});
}

/// @nodoc
class _$ShiftCardCopyWithImpl<$Res, $Val extends ShiftCard>
    implements $ShiftCardCopyWith<$Res> {
  _$ShiftCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestDate = null,
    Object? shiftRequestId = null,
    Object? shiftTime = null,
    Object? storeName = null,
    Object? scheduledHours = null,
    Object? isApproved = null,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? confirmStartTime = freezed,
    Object? confirmEndTime = freezed,
    Object? paidHours = null,
    Object? isLate = null,
    Object? lateMinutes = null,
    Object? lateDeducutAmount = null,
    Object? isExtratime = null,
    Object? overtimeMinutes = null,
    Object? basePay = null,
    Object? bonusAmount = null,
    Object? totalPayWithBonus = null,
    Object? salaryType = null,
    Object? salaryAmount = null,
    Object? isValidCheckinLocation = freezed,
    Object? checkinDistanceFromStore = freezed,
    Object? checkoutDistanceFromStore = freezed,
    Object? isReported = null,
    Object? isProblem = null,
    Object? isProblemSolved = null,
  }) {
    return _then(_value.copyWith(
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftTime: null == shiftTime
          ? _value.shiftTime
          : shiftTime // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledHours: null == scheduledHours
          ? _value.scheduledHours
          : scheduledHours // ignore: cast_nullable_to_non_nullable
              as double,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmStartTime: freezed == confirmStartTime
          ? _value.confirmStartTime
          : confirmStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmEndTime: freezed == confirmEndTime
          ? _value.confirmEndTime
          : confirmEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      paidHours: null == paidHours
          ? _value.paidHours
          : paidHours // ignore: cast_nullable_to_non_nullable
              as double,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      lateMinutes: null == lateMinutes
          ? _value.lateMinutes
          : lateMinutes // ignore: cast_nullable_to_non_nullable
              as num,
      lateDeducutAmount: null == lateDeducutAmount
          ? _value.lateDeducutAmount
          : lateDeducutAmount // ignore: cast_nullable_to_non_nullable
              as double,
      isExtratime: null == isExtratime
          ? _value.isExtratime
          : isExtratime // ignore: cast_nullable_to_non_nullable
              as bool,
      overtimeMinutes: null == overtimeMinutes
          ? _value.overtimeMinutes
          : overtimeMinutes // ignore: cast_nullable_to_non_nullable
              as num,
      basePay: null == basePay
          ? _value.basePay
          : basePay // ignore: cast_nullable_to_non_nullable
              as String,
      bonusAmount: null == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayWithBonus: null == totalPayWithBonus
          ? _value.totalPayWithBonus
          : totalPayWithBonus // ignore: cast_nullable_to_non_nullable
              as String,
      salaryType: null == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String,
      salaryAmount: null == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as String,
      isValidCheckinLocation: freezed == isValidCheckinLocation
          ? _value.isValidCheckinLocation
          : isValidCheckinLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinDistanceFromStore: freezed == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      checkoutDistanceFromStore: freezed == checkoutDistanceFromStore
          ? _value.checkoutDistanceFromStore
          : checkoutDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblem: null == isProblem
          ? _value.isProblem
          : isProblem // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblemSolved: null == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftCardImplCopyWith<$Res>
    implements $ShiftCardCopyWith<$Res> {
  factory _$$ShiftCardImplCopyWith(
          _$ShiftCardImpl value, $Res Function(_$ShiftCardImpl) then) =
      __$$ShiftCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'shift_time') String shiftTime,
      @JsonKey(name: 'store_name') String storeName,
      @JsonKey(name: 'scheduled_hours') double scheduledHours,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'actual_start_time') String? actualStartTime,
      @JsonKey(name: 'actual_end_time') String? actualEndTime,
      @JsonKey(name: 'confirm_start_time') String? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') String? confirmEndTime,
      @JsonKey(name: 'paid_hours') double paidHours,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'late_minutes') num lateMinutes,
      @JsonKey(name: 'late_deducut_amount') double lateDeducutAmount,
      @JsonKey(name: 'is_extratime') bool isExtratime,
      @JsonKey(name: 'overtime_minutes') num overtimeMinutes,
      @JsonKey(name: 'base_pay') String basePay,
      @JsonKey(name: 'bonus_amount') double bonusAmount,
      @JsonKey(name: 'total_pay_with_bonus') String totalPayWithBonus,
      @JsonKey(name: 'salary_type') String salaryType,
      @JsonKey(name: 'salary_amount') String salaryAmount,
      @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      double? checkinDistanceFromStore,
      @JsonKey(name: 'checkout_distance_from_store')
      double? checkoutDistanceFromStore,
      @JsonKey(name: 'is_reported') bool isReported,
      @JsonKey(name: 'is_problem') bool isProblem,
      @JsonKey(name: 'is_problem_solved') bool isProblemSolved});
}

/// @nodoc
class __$$ShiftCardImplCopyWithImpl<$Res>
    extends _$ShiftCardCopyWithImpl<$Res, _$ShiftCardImpl>
    implements _$$ShiftCardImplCopyWith<$Res> {
  __$$ShiftCardImplCopyWithImpl(
      _$ShiftCardImpl _value, $Res Function(_$ShiftCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestDate = null,
    Object? shiftRequestId = null,
    Object? shiftTime = null,
    Object? storeName = null,
    Object? scheduledHours = null,
    Object? isApproved = null,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? confirmStartTime = freezed,
    Object? confirmEndTime = freezed,
    Object? paidHours = null,
    Object? isLate = null,
    Object? lateMinutes = null,
    Object? lateDeducutAmount = null,
    Object? isExtratime = null,
    Object? overtimeMinutes = null,
    Object? basePay = null,
    Object? bonusAmount = null,
    Object? totalPayWithBonus = null,
    Object? salaryType = null,
    Object? salaryAmount = null,
    Object? isValidCheckinLocation = freezed,
    Object? checkinDistanceFromStore = freezed,
    Object? checkoutDistanceFromStore = freezed,
    Object? isReported = null,
    Object? isProblem = null,
    Object? isProblemSolved = null,
  }) {
    return _then(_$ShiftCardImpl(
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftTime: null == shiftTime
          ? _value.shiftTime
          : shiftTime // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledHours: null == scheduledHours
          ? _value.scheduledHours
          : scheduledHours // ignore: cast_nullable_to_non_nullable
              as double,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmStartTime: freezed == confirmStartTime
          ? _value.confirmStartTime
          : confirmStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmEndTime: freezed == confirmEndTime
          ? _value.confirmEndTime
          : confirmEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      paidHours: null == paidHours
          ? _value.paidHours
          : paidHours // ignore: cast_nullable_to_non_nullable
              as double,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      lateMinutes: null == lateMinutes
          ? _value.lateMinutes
          : lateMinutes // ignore: cast_nullable_to_non_nullable
              as num,
      lateDeducutAmount: null == lateDeducutAmount
          ? _value.lateDeducutAmount
          : lateDeducutAmount // ignore: cast_nullable_to_non_nullable
              as double,
      isExtratime: null == isExtratime
          ? _value.isExtratime
          : isExtratime // ignore: cast_nullable_to_non_nullable
              as bool,
      overtimeMinutes: null == overtimeMinutes
          ? _value.overtimeMinutes
          : overtimeMinutes // ignore: cast_nullable_to_non_nullable
              as num,
      basePay: null == basePay
          ? _value.basePay
          : basePay // ignore: cast_nullable_to_non_nullable
              as String,
      bonusAmount: null == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayWithBonus: null == totalPayWithBonus
          ? _value.totalPayWithBonus
          : totalPayWithBonus // ignore: cast_nullable_to_non_nullable
              as String,
      salaryType: null == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String,
      salaryAmount: null == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as String,
      isValidCheckinLocation: freezed == isValidCheckinLocation
          ? _value.isValidCheckinLocation
          : isValidCheckinLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinDistanceFromStore: freezed == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      checkoutDistanceFromStore: freezed == checkoutDistanceFromStore
          ? _value.checkoutDistanceFromStore
          : checkoutDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblem: null == isProblem
          ? _value.isProblem
          : isProblem // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblemSolved: null == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftCardImpl extends _ShiftCard {
  const _$ShiftCardImpl(
      {@JsonKey(name: 'request_date') required this.requestDate,
      @JsonKey(name: 'shift_request_id') required this.shiftRequestId,
      @JsonKey(name: 'shift_time') required this.shiftTime,
      @JsonKey(name: 'store_name') required this.storeName,
      @JsonKey(name: 'scheduled_hours') required this.scheduledHours,
      @JsonKey(name: 'is_approved') required this.isApproved,
      @JsonKey(name: 'actual_start_time') this.actualStartTime,
      @JsonKey(name: 'actual_end_time') this.actualEndTime,
      @JsonKey(name: 'confirm_start_time') this.confirmStartTime,
      @JsonKey(name: 'confirm_end_time') this.confirmEndTime,
      @JsonKey(name: 'paid_hours') required this.paidHours,
      @JsonKey(name: 'is_late') required this.isLate,
      @JsonKey(name: 'late_minutes') required this.lateMinutes,
      @JsonKey(name: 'late_deducut_amount') required this.lateDeducutAmount,
      @JsonKey(name: 'is_extratime') required this.isExtratime,
      @JsonKey(name: 'overtime_minutes') required this.overtimeMinutes,
      @JsonKey(name: 'base_pay') required this.basePay,
      @JsonKey(name: 'bonus_amount') required this.bonusAmount,
      @JsonKey(name: 'total_pay_with_bonus') required this.totalPayWithBonus,
      @JsonKey(name: 'salary_type') required this.salaryType,
      @JsonKey(name: 'salary_amount') required this.salaryAmount,
      @JsonKey(name: 'is_valid_checkin_location') this.isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      this.checkinDistanceFromStore,
      @JsonKey(name: 'checkout_distance_from_store')
      this.checkoutDistanceFromStore,
      @JsonKey(name: 'is_reported') required this.isReported,
      @JsonKey(name: 'is_problem') required this.isProblem,
      @JsonKey(name: 'is_problem_solved') required this.isProblemSolved})
      : super._();

  factory _$ShiftCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftCardImplFromJson(json);

// Basic info
  @override
  @JsonKey(name: 'request_date')
  final String requestDate;
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;
  @override
  @JsonKey(name: 'shift_time')
  final String shiftTime;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
// Schedule
  @override
  @JsonKey(name: 'scheduled_hours')
  final double scheduledHours;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
// Actual times (nullable - might not be checked in/out yet)
  @override
  @JsonKey(name: 'actual_start_time')
  final String? actualStartTime;
  @override
  @JsonKey(name: 'actual_end_time')
  final String? actualEndTime;
  @override
  @JsonKey(name: 'confirm_start_time')
  final String? confirmStartTime;
  @override
  @JsonKey(name: 'confirm_end_time')
  final String? confirmEndTime;
// Work hours
  @override
  @JsonKey(name: 'paid_hours')
  final double paidHours;
// Late status
  @override
  @JsonKey(name: 'is_late')
  final bool isLate;
  @override
  @JsonKey(name: 'late_minutes')
  final num lateMinutes;
  @override
  @JsonKey(name: 'late_deducut_amount')
  final double lateDeducutAmount;
// Overtime
  @override
  @JsonKey(name: 'is_extratime')
  final bool isExtratime;
  @override
  @JsonKey(name: 'overtime_minutes')
  final num overtimeMinutes;
// Pay (some are formatted strings with commas)
  @override
  @JsonKey(name: 'base_pay')
  final String basePay;
  @override
  @JsonKey(name: 'bonus_amount')
  final double bonusAmount;
  @override
  @JsonKey(name: 'total_pay_with_bonus')
  final String totalPayWithBonus;
  @override
  @JsonKey(name: 'salary_type')
  final String salaryType;
  @override
  @JsonKey(name: 'salary_amount')
  final String salaryAmount;
// Location validation
  @override
  @JsonKey(name: 'is_valid_checkin_location')
  final bool? isValidCheckinLocation;
  @override
  @JsonKey(name: 'checkin_distance_from_store')
  final double? checkinDistanceFromStore;
  @override
  @JsonKey(name: 'checkout_distance_from_store')
  final double? checkoutDistanceFromStore;
// Problem reporting
  @override
  @JsonKey(name: 'is_reported')
  final bool isReported;
  @override
  @JsonKey(name: 'is_problem')
  final bool isProblem;
  @override
  @JsonKey(name: 'is_problem_solved')
  final bool isProblemSolved;

  @override
  String toString() {
    return 'ShiftCard(requestDate: $requestDate, shiftRequestId: $shiftRequestId, shiftTime: $shiftTime, storeName: $storeName, scheduledHours: $scheduledHours, isApproved: $isApproved, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, confirmStartTime: $confirmStartTime, confirmEndTime: $confirmEndTime, paidHours: $paidHours, isLate: $isLate, lateMinutes: $lateMinutes, lateDeducutAmount: $lateDeducutAmount, isExtratime: $isExtratime, overtimeMinutes: $overtimeMinutes, basePay: $basePay, bonusAmount: $bonusAmount, totalPayWithBonus: $totalPayWithBonus, salaryType: $salaryType, salaryAmount: $salaryAmount, isValidCheckinLocation: $isValidCheckinLocation, checkinDistanceFromStore: $checkinDistanceFromStore, checkoutDistanceFromStore: $checkoutDistanceFromStore, isReported: $isReported, isProblem: $isProblem, isProblemSolved: $isProblemSolved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftCardImpl &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.shiftTime, shiftTime) ||
                other.shiftTime == shiftTime) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.scheduledHours, scheduledHours) ||
                other.scheduledHours == scheduledHours) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.actualStartTime, actualStartTime) ||
                other.actualStartTime == actualStartTime) &&
            (identical(other.actualEndTime, actualEndTime) ||
                other.actualEndTime == actualEndTime) &&
            (identical(other.confirmStartTime, confirmStartTime) ||
                other.confirmStartTime == confirmStartTime) &&
            (identical(other.confirmEndTime, confirmEndTime) ||
                other.confirmEndTime == confirmEndTime) &&
            (identical(other.paidHours, paidHours) ||
                other.paidHours == paidHours) &&
            (identical(other.isLate, isLate) || other.isLate == isLate) &&
            (identical(other.lateMinutes, lateMinutes) ||
                other.lateMinutes == lateMinutes) &&
            (identical(other.lateDeducutAmount, lateDeducutAmount) ||
                other.lateDeducutAmount == lateDeducutAmount) &&
            (identical(other.isExtratime, isExtratime) ||
                other.isExtratime == isExtratime) &&
            (identical(other.overtimeMinutes, overtimeMinutes) ||
                other.overtimeMinutes == overtimeMinutes) &&
            (identical(other.basePay, basePay) || other.basePay == basePay) &&
            (identical(other.bonusAmount, bonusAmount) ||
                other.bonusAmount == bonusAmount) &&
            (identical(other.totalPayWithBonus, totalPayWithBonus) ||
                other.totalPayWithBonus == totalPayWithBonus) &&
            (identical(other.salaryType, salaryType) ||
                other.salaryType == salaryType) &&
            (identical(other.salaryAmount, salaryAmount) ||
                other.salaryAmount == salaryAmount) &&
            (identical(other.isValidCheckinLocation, isValidCheckinLocation) ||
                other.isValidCheckinLocation == isValidCheckinLocation) &&
            (identical(
                    other.checkinDistanceFromStore, checkinDistanceFromStore) ||
                other.checkinDistanceFromStore == checkinDistanceFromStore) &&
            (identical(other.checkoutDistanceFromStore,
                    checkoutDistanceFromStore) ||
                other.checkoutDistanceFromStore == checkoutDistanceFromStore) &&
            (identical(other.isReported, isReported) ||
                other.isReported == isReported) &&
            (identical(other.isProblem, isProblem) ||
                other.isProblem == isProblem) &&
            (identical(other.isProblemSolved, isProblemSolved) ||
                other.isProblemSolved == isProblemSolved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        requestDate,
        shiftRequestId,
        shiftTime,
        storeName,
        scheduledHours,
        isApproved,
        actualStartTime,
        actualEndTime,
        confirmStartTime,
        confirmEndTime,
        paidHours,
        isLate,
        lateMinutes,
        lateDeducutAmount,
        isExtratime,
        overtimeMinutes,
        basePay,
        bonusAmount,
        totalPayWithBonus,
        salaryType,
        salaryAmount,
        isValidCheckinLocation,
        checkinDistanceFromStore,
        checkoutDistanceFromStore,
        isReported,
        isProblem,
        isProblemSolved
      ]);

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftCardImplCopyWith<_$ShiftCardImpl> get copyWith =>
      __$$ShiftCardImplCopyWithImpl<_$ShiftCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftCardImplToJson(
      this,
    );
  }
}

abstract class _ShiftCard extends ShiftCard {
  const factory _ShiftCard(
      {@JsonKey(name: 'request_date') required final String requestDate,
      @JsonKey(name: 'shift_request_id') required final String shiftRequestId,
      @JsonKey(name: 'shift_time') required final String shiftTime,
      @JsonKey(name: 'store_name') required final String storeName,
      @JsonKey(name: 'scheduled_hours') required final double scheduledHours,
      @JsonKey(name: 'is_approved') required final bool isApproved,
      @JsonKey(name: 'actual_start_time') final String? actualStartTime,
      @JsonKey(name: 'actual_end_time') final String? actualEndTime,
      @JsonKey(name: 'confirm_start_time') final String? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') final String? confirmEndTime,
      @JsonKey(name: 'paid_hours') required final double paidHours,
      @JsonKey(name: 'is_late') required final bool isLate,
      @JsonKey(name: 'late_minutes') required final num lateMinutes,
      @JsonKey(name: 'late_deducut_amount')
      required final double lateDeducutAmount,
      @JsonKey(name: 'is_extratime') required final bool isExtratime,
      @JsonKey(name: 'overtime_minutes') required final num overtimeMinutes,
      @JsonKey(name: 'base_pay') required final String basePay,
      @JsonKey(name: 'bonus_amount') required final double bonusAmount,
      @JsonKey(name: 'total_pay_with_bonus')
      required final String totalPayWithBonus,
      @JsonKey(name: 'salary_type') required final String salaryType,
      @JsonKey(name: 'salary_amount') required final String salaryAmount,
      @JsonKey(name: 'is_valid_checkin_location')
      final bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      final double? checkinDistanceFromStore,
      @JsonKey(name: 'checkout_distance_from_store')
      final double? checkoutDistanceFromStore,
      @JsonKey(name: 'is_reported') required final bool isReported,
      @JsonKey(name: 'is_problem') required final bool isProblem,
      @JsonKey(name: 'is_problem_solved')
      required final bool isProblemSolved}) = _$ShiftCardImpl;
  const _ShiftCard._() : super._();

  factory _ShiftCard.fromJson(Map<String, dynamic> json) =
      _$ShiftCardImpl.fromJson;

// Basic info
  @override
  @JsonKey(name: 'request_date')
  String get requestDate;
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;
  @override
  @JsonKey(name: 'shift_time')
  String get shiftTime;
  @override
  @JsonKey(name: 'store_name')
  String get storeName; // Schedule
  @override
  @JsonKey(name: 'scheduled_hours')
  double get scheduledHours;
  @override
  @JsonKey(name: 'is_approved')
  bool
      get isApproved; // Actual times (nullable - might not be checked in/out yet)
  @override
  @JsonKey(name: 'actual_start_time')
  String? get actualStartTime;
  @override
  @JsonKey(name: 'actual_end_time')
  String? get actualEndTime;
  @override
  @JsonKey(name: 'confirm_start_time')
  String? get confirmStartTime;
  @override
  @JsonKey(name: 'confirm_end_time')
  String? get confirmEndTime; // Work hours
  @override
  @JsonKey(name: 'paid_hours')
  double get paidHours; // Late status
  @override
  @JsonKey(name: 'is_late')
  bool get isLate;
  @override
  @JsonKey(name: 'late_minutes')
  num get lateMinutes;
  @override
  @JsonKey(name: 'late_deducut_amount')
  double get lateDeducutAmount; // Overtime
  @override
  @JsonKey(name: 'is_extratime')
  bool get isExtratime;
  @override
  @JsonKey(name: 'overtime_minutes')
  num get overtimeMinutes; // Pay (some are formatted strings with commas)
  @override
  @JsonKey(name: 'base_pay')
  String get basePay;
  @override
  @JsonKey(name: 'bonus_amount')
  double get bonusAmount;
  @override
  @JsonKey(name: 'total_pay_with_bonus')
  String get totalPayWithBonus;
  @override
  @JsonKey(name: 'salary_type')
  String get salaryType;
  @override
  @JsonKey(name: 'salary_amount')
  String get salaryAmount; // Location validation
  @override
  @JsonKey(name: 'is_valid_checkin_location')
  bool? get isValidCheckinLocation;
  @override
  @JsonKey(name: 'checkin_distance_from_store')
  double? get checkinDistanceFromStore;
  @override
  @JsonKey(name: 'checkout_distance_from_store')
  double? get checkoutDistanceFromStore; // Problem reporting
  @override
  @JsonKey(name: 'is_reported')
  bool get isReported;
  @override
  @JsonKey(name: 'is_problem')
  bool get isProblem;
  @override
  @JsonKey(name: 'is_problem_solved')
  bool get isProblemSolved;

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftCardImplCopyWith<_$ShiftCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
