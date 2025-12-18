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

/// @nodoc
mixin _$ShiftCard {
// Basic info
  String get requestDate => throw _privateConstructorUsedError;
  String get shiftRequestId => throw _privateConstructorUsedError;
  String? get shiftName =>
      throw _privateConstructorUsedError; // e.g., "Afternoon", "Morning"
  String get shiftStartTime =>
      throw _privateConstructorUsedError; // e.g., "2025-06-01T14:00:00"
  String get shiftEndTime =>
      throw _privateConstructorUsedError; // e.g., "2025-06-01T18:00:00"
  String get storeName => throw _privateConstructorUsedError; // Schedule
  double get scheduledHours => throw _privateConstructorUsedError;
  bool get isApproved =>
      throw _privateConstructorUsedError; // Actual times (nullable - might not be checked in/out yet)
  String? get actualStartTime => throw _privateConstructorUsedError;
  String? get actualEndTime => throw _privateConstructorUsedError;
  String? get confirmStartTime => throw _privateConstructorUsedError;
  String? get confirmEndTime =>
      throw _privateConstructorUsedError; // Work hours
  double get paidHours => throw _privateConstructorUsedError; // Late status
  bool get isLate => throw _privateConstructorUsedError;
  num get lateMinutes => throw _privateConstructorUsedError;
  double get lateDeducutAmount =>
      throw _privateConstructorUsedError; // Overtime
  bool get isExtratime => throw _privateConstructorUsedError;
  num get overtimeMinutes =>
      throw _privateConstructorUsedError; // Pay (some are formatted strings with commas)
  String get basePay => throw _privateConstructorUsedError;
  double get bonusAmount => throw _privateConstructorUsedError;
  String get totalPayWithBonus => throw _privateConstructorUsedError;
  String get salaryType => throw _privateConstructorUsedError;
  String get salaryAmount =>
      throw _privateConstructorUsedError; // Location validation
  bool? get isValidCheckinLocation => throw _privateConstructorUsedError;
  double? get checkinDistanceFromStore => throw _privateConstructorUsedError;
  double? get checkoutDistanceFromStore =>
      throw _privateConstructorUsedError; // Problem reporting
  bool get isReported => throw _privateConstructorUsedError;
  bool get isProblem => throw _privateConstructorUsedError;
  bool get isProblemSolved => throw _privateConstructorUsedError;

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
      {String requestDate,
      String shiftRequestId,
      String? shiftName,
      String shiftStartTime,
      String shiftEndTime,
      String storeName,
      double scheduledHours,
      bool isApproved,
      String? actualStartTime,
      String? actualEndTime,
      String? confirmStartTime,
      String? confirmEndTime,
      double paidHours,
      bool isLate,
      num lateMinutes,
      double lateDeducutAmount,
      bool isExtratime,
      num overtimeMinutes,
      String basePay,
      double bonusAmount,
      String totalPayWithBonus,
      String salaryType,
      String salaryAmount,
      bool? isValidCheckinLocation,
      double? checkinDistanceFromStore,
      double? checkoutDistanceFromStore,
      bool isReported,
      bool isProblem,
      bool isProblemSolved});
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
    Object? shiftName = freezed,
    Object? shiftStartTime = null,
    Object? shiftEndTime = null,
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
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftStartTime: null == shiftStartTime
          ? _value.shiftStartTime
          : shiftStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      shiftEndTime: null == shiftEndTime
          ? _value.shiftEndTime
          : shiftEndTime // ignore: cast_nullable_to_non_nullable
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
      {String requestDate,
      String shiftRequestId,
      String? shiftName,
      String shiftStartTime,
      String shiftEndTime,
      String storeName,
      double scheduledHours,
      bool isApproved,
      String? actualStartTime,
      String? actualEndTime,
      String? confirmStartTime,
      String? confirmEndTime,
      double paidHours,
      bool isLate,
      num lateMinutes,
      double lateDeducutAmount,
      bool isExtratime,
      num overtimeMinutes,
      String basePay,
      double bonusAmount,
      String totalPayWithBonus,
      String salaryType,
      String salaryAmount,
      bool? isValidCheckinLocation,
      double? checkinDistanceFromStore,
      double? checkoutDistanceFromStore,
      bool isReported,
      bool isProblem,
      bool isProblemSolved});
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
    Object? shiftName = freezed,
    Object? shiftStartTime = null,
    Object? shiftEndTime = null,
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
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftStartTime: null == shiftStartTime
          ? _value.shiftStartTime
          : shiftStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      shiftEndTime: null == shiftEndTime
          ? _value.shiftEndTime
          : shiftEndTime // ignore: cast_nullable_to_non_nullable
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

class _$ShiftCardImpl extends _ShiftCard {
  const _$ShiftCardImpl(
      {required this.requestDate,
      required this.shiftRequestId,
      this.shiftName,
      required this.shiftStartTime,
      required this.shiftEndTime,
      required this.storeName,
      required this.scheduledHours,
      required this.isApproved,
      this.actualStartTime,
      this.actualEndTime,
      this.confirmStartTime,
      this.confirmEndTime,
      required this.paidHours,
      required this.isLate,
      required this.lateMinutes,
      required this.lateDeducutAmount,
      required this.isExtratime,
      required this.overtimeMinutes,
      required this.basePay,
      required this.bonusAmount,
      required this.totalPayWithBonus,
      required this.salaryType,
      required this.salaryAmount,
      this.isValidCheckinLocation,
      this.checkinDistanceFromStore,
      this.checkoutDistanceFromStore,
      required this.isReported,
      required this.isProblem,
      required this.isProblemSolved})
      : super._();

// Basic info
  @override
  final String requestDate;
  @override
  final String shiftRequestId;
  @override
  final String? shiftName;
// e.g., "Afternoon", "Morning"
  @override
  final String shiftStartTime;
// e.g., "2025-06-01T14:00:00"
  @override
  final String shiftEndTime;
// e.g., "2025-06-01T18:00:00"
  @override
  final String storeName;
// Schedule
  @override
  final double scheduledHours;
  @override
  final bool isApproved;
// Actual times (nullable - might not be checked in/out yet)
  @override
  final String? actualStartTime;
  @override
  final String? actualEndTime;
  @override
  final String? confirmStartTime;
  @override
  final String? confirmEndTime;
// Work hours
  @override
  final double paidHours;
// Late status
  @override
  final bool isLate;
  @override
  final num lateMinutes;
  @override
  final double lateDeducutAmount;
// Overtime
  @override
  final bool isExtratime;
  @override
  final num overtimeMinutes;
// Pay (some are formatted strings with commas)
  @override
  final String basePay;
  @override
  final double bonusAmount;
  @override
  final String totalPayWithBonus;
  @override
  final String salaryType;
  @override
  final String salaryAmount;
// Location validation
  @override
  final bool? isValidCheckinLocation;
  @override
  final double? checkinDistanceFromStore;
  @override
  final double? checkoutDistanceFromStore;
// Problem reporting
  @override
  final bool isReported;
  @override
  final bool isProblem;
  @override
  final bool isProblemSolved;

  @override
  String toString() {
    return 'ShiftCard(requestDate: $requestDate, shiftRequestId: $shiftRequestId, shiftName: $shiftName, shiftStartTime: $shiftStartTime, shiftEndTime: $shiftEndTime, storeName: $storeName, scheduledHours: $scheduledHours, isApproved: $isApproved, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, confirmStartTime: $confirmStartTime, confirmEndTime: $confirmEndTime, paidHours: $paidHours, isLate: $isLate, lateMinutes: $lateMinutes, lateDeducutAmount: $lateDeducutAmount, isExtratime: $isExtratime, overtimeMinutes: $overtimeMinutes, basePay: $basePay, bonusAmount: $bonusAmount, totalPayWithBonus: $totalPayWithBonus, salaryType: $salaryType, salaryAmount: $salaryAmount, isValidCheckinLocation: $isValidCheckinLocation, checkinDistanceFromStore: $checkinDistanceFromStore, checkoutDistanceFromStore: $checkoutDistanceFromStore, isReported: $isReported, isProblem: $isProblem, isProblemSolved: $isProblemSolved)';
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
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.shiftStartTime, shiftStartTime) ||
                other.shiftStartTime == shiftStartTime) &&
            (identical(other.shiftEndTime, shiftEndTime) ||
                other.shiftEndTime == shiftEndTime) &&
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

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        requestDate,
        shiftRequestId,
        shiftName,
        shiftStartTime,
        shiftEndTime,
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
}

abstract class _ShiftCard extends ShiftCard {
  const factory _ShiftCard(
      {required final String requestDate,
      required final String shiftRequestId,
      final String? shiftName,
      required final String shiftStartTime,
      required final String shiftEndTime,
      required final String storeName,
      required final double scheduledHours,
      required final bool isApproved,
      final String? actualStartTime,
      final String? actualEndTime,
      final String? confirmStartTime,
      final String? confirmEndTime,
      required final double paidHours,
      required final bool isLate,
      required final num lateMinutes,
      required final double lateDeducutAmount,
      required final bool isExtratime,
      required final num overtimeMinutes,
      required final String basePay,
      required final double bonusAmount,
      required final String totalPayWithBonus,
      required final String salaryType,
      required final String salaryAmount,
      final bool? isValidCheckinLocation,
      final double? checkinDistanceFromStore,
      final double? checkoutDistanceFromStore,
      required final bool isReported,
      required final bool isProblem,
      required final bool isProblemSolved}) = _$ShiftCardImpl;
  const _ShiftCard._() : super._();

// Basic info
  @override
  String get requestDate;
  @override
  String get shiftRequestId;
  @override
  String? get shiftName; // e.g., "Afternoon", "Morning"
  @override
  String get shiftStartTime; // e.g., "2025-06-01T14:00:00"
  @override
  String get shiftEndTime; // e.g., "2025-06-01T18:00:00"
  @override
  String get storeName; // Schedule
  @override
  double get scheduledHours;
  @override
  bool
      get isApproved; // Actual times (nullable - might not be checked in/out yet)
  @override
  String? get actualStartTime;
  @override
  String? get actualEndTime;
  @override
  String? get confirmStartTime;
  @override
  String? get confirmEndTime; // Work hours
  @override
  double get paidHours; // Late status
  @override
  bool get isLate;
  @override
  num get lateMinutes;
  @override
  double get lateDeducutAmount; // Overtime
  @override
  bool get isExtratime;
  @override
  num get overtimeMinutes; // Pay (some are formatted strings with commas)
  @override
  String get basePay;
  @override
  double get bonusAmount;
  @override
  String get totalPayWithBonus;
  @override
  String get salaryType;
  @override
  String get salaryAmount; // Location validation
  @override
  bool? get isValidCheckinLocation;
  @override
  double? get checkinDistanceFromStore;
  @override
  double? get checkoutDistanceFromStore; // Problem reporting
  @override
  bool get isReported;
  @override
  bool get isProblem;
  @override
  bool get isProblemSolved;

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftCardImplCopyWith<_$ShiftCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
