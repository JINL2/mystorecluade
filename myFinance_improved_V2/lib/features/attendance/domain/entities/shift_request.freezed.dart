// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShiftRequest {
// Core fields
  String get shiftRequestId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get shiftId => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get requestDate => throw _privateConstructorUsedError; // Approval
  bool? get isApproved => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError; // Time fields
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  DateTime? get actualStartTime => throw _privateConstructorUsedError;
  DateTime? get actualEndTime => throw _privateConstructorUsedError;
  DateTime? get confirmStartTime => throw _privateConstructorUsedError;
  DateTime? get confirmEndTime =>
      throw _privateConstructorUsedError; // Status flags
  bool? get isLate => throw _privateConstructorUsedError;
  bool? get isExtratime => throw _privateConstructorUsedError; // Location
  AttendanceLocation? get checkinLocation => throw _privateConstructorUsedError;
  double? get checkinDistanceFromStore => throw _privateConstructorUsedError;
  bool? get isValidCheckinLocation => throw _privateConstructorUsedError;
  AttendanceLocation? get checkoutLocation =>
      throw _privateConstructorUsedError;
  double? get checkoutDistanceFromStore => throw _privateConstructorUsedError;
  bool? get isValidCheckoutLocation =>
      throw _privateConstructorUsedError; // Financial
  double? get overtimeAmount => throw _privateConstructorUsedError;
  double? get lateDeducutAmount => throw _privateConstructorUsedError;
  double? get bonusAmount =>
      throw _privateConstructorUsedError; // Problem reporting
  bool? get isReported => throw _privateConstructorUsedError;
  DateTime? get reportTime => throw _privateConstructorUsedError;
  String? get problemType => throw _privateConstructorUsedError;
  bool? get isProblem => throw _privateConstructorUsedError;
  bool get isProblemSolved => throw _privateConstructorUsedError;
  String? get reportReason => throw _privateConstructorUsedError; // Metadata
  Map<String, dynamic>? get noticeTag => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftRequestCopyWith<ShiftRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftRequestCopyWith<$Res> {
  factory $ShiftRequestCopyWith(
          ShiftRequest value, $Res Function(ShiftRequest) then) =
      _$ShiftRequestCopyWithImpl<$Res, ShiftRequest>;
  @useResult
  $Res call(
      {String shiftRequestId,
      String userId,
      String shiftId,
      String storeId,
      String requestDate,
      bool? isApproved,
      String? approvedBy,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? actualStartTime,
      DateTime? actualEndTime,
      DateTime? confirmStartTime,
      DateTime? confirmEndTime,
      bool? isLate,
      bool? isExtratime,
      AttendanceLocation? checkinLocation,
      double? checkinDistanceFromStore,
      bool? isValidCheckinLocation,
      AttendanceLocation? checkoutLocation,
      double? checkoutDistanceFromStore,
      bool? isValidCheckoutLocation,
      double? overtimeAmount,
      double? lateDeducutAmount,
      double? bonusAmount,
      bool? isReported,
      DateTime? reportTime,
      String? problemType,
      bool? isProblem,
      bool isProblemSolved,
      String? reportReason,
      Map<String, dynamic>? noticeTag,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ShiftRequestCopyWithImpl<$Res, $Val extends ShiftRequest>
    implements $ShiftRequestCopyWith<$Res> {
  _$ShiftRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? userId = null,
    Object? shiftId = null,
    Object? storeId = null,
    Object? requestDate = null,
    Object? isApproved = freezed,
    Object? approvedBy = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? confirmStartTime = freezed,
    Object? confirmEndTime = freezed,
    Object? isLate = freezed,
    Object? isExtratime = freezed,
    Object? checkinLocation = freezed,
    Object? checkinDistanceFromStore = freezed,
    Object? isValidCheckinLocation = freezed,
    Object? checkoutLocation = freezed,
    Object? checkoutDistanceFromStore = freezed,
    Object? isValidCheckoutLocation = freezed,
    Object? overtimeAmount = freezed,
    Object? lateDeducutAmount = freezed,
    Object? bonusAmount = freezed,
    Object? isReported = freezed,
    Object? reportTime = freezed,
    Object? problemType = freezed,
    Object? isProblem = freezed,
    Object? isProblemSolved = null,
    Object? reportReason = freezed,
    Object? noticeTag = freezed,
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
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: freezed == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
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
      isLate: freezed == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool?,
      isExtratime: freezed == isExtratime
          ? _value.isExtratime
          : isExtratime // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinLocation: freezed == checkinLocation
          ? _value.checkinLocation
          : checkinLocation // ignore: cast_nullable_to_non_nullable
              as AttendanceLocation?,
      checkinDistanceFromStore: freezed == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      isValidCheckinLocation: freezed == isValidCheckinLocation
          ? _value.isValidCheckinLocation
          : isValidCheckinLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkoutLocation: freezed == checkoutLocation
          ? _value.checkoutLocation
          : checkoutLocation // ignore: cast_nullable_to_non_nullable
              as AttendanceLocation?,
      checkoutDistanceFromStore: freezed == checkoutDistanceFromStore
          ? _value.checkoutDistanceFromStore
          : checkoutDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      isValidCheckoutLocation: freezed == isValidCheckoutLocation
          ? _value.isValidCheckoutLocation
          : isValidCheckoutLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      overtimeAmount: freezed == overtimeAmount
          ? _value.overtimeAmount
          : overtimeAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      lateDeducutAmount: freezed == lateDeducutAmount
          ? _value.lateDeducutAmount
          : lateDeducutAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      bonusAmount: freezed == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      isReported: freezed == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool?,
      reportTime: freezed == reportTime
          ? _value.reportTime
          : reportTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      problemType: freezed == problemType
          ? _value.problemType
          : problemType // ignore: cast_nullable_to_non_nullable
              as String?,
      isProblem: freezed == isProblem
          ? _value.isProblem
          : isProblem // ignore: cast_nullable_to_non_nullable
              as bool?,
      isProblemSolved: null == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      reportReason: freezed == reportReason
          ? _value.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String?,
      noticeTag: freezed == noticeTag
          ? _value.noticeTag
          : noticeTag // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$ShiftRequestImplCopyWith<$Res>
    implements $ShiftRequestCopyWith<$Res> {
  factory _$$ShiftRequestImplCopyWith(
          _$ShiftRequestImpl value, $Res Function(_$ShiftRequestImpl) then) =
      __$$ShiftRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shiftRequestId,
      String userId,
      String shiftId,
      String storeId,
      String requestDate,
      bool? isApproved,
      String? approvedBy,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? actualStartTime,
      DateTime? actualEndTime,
      DateTime? confirmStartTime,
      DateTime? confirmEndTime,
      bool? isLate,
      bool? isExtratime,
      AttendanceLocation? checkinLocation,
      double? checkinDistanceFromStore,
      bool? isValidCheckinLocation,
      AttendanceLocation? checkoutLocation,
      double? checkoutDistanceFromStore,
      bool? isValidCheckoutLocation,
      double? overtimeAmount,
      double? lateDeducutAmount,
      double? bonusAmount,
      bool? isReported,
      DateTime? reportTime,
      String? problemType,
      bool? isProblem,
      bool isProblemSolved,
      String? reportReason,
      Map<String, dynamic>? noticeTag,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ShiftRequestImplCopyWithImpl<$Res>
    extends _$ShiftRequestCopyWithImpl<$Res, _$ShiftRequestImpl>
    implements _$$ShiftRequestImplCopyWith<$Res> {
  __$$ShiftRequestImplCopyWithImpl(
      _$ShiftRequestImpl _value, $Res Function(_$ShiftRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? userId = null,
    Object? shiftId = null,
    Object? storeId = null,
    Object? requestDate = null,
    Object? isApproved = freezed,
    Object? approvedBy = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? confirmStartTime = freezed,
    Object? confirmEndTime = freezed,
    Object? isLate = freezed,
    Object? isExtratime = freezed,
    Object? checkinLocation = freezed,
    Object? checkinDistanceFromStore = freezed,
    Object? isValidCheckinLocation = freezed,
    Object? checkoutLocation = freezed,
    Object? checkoutDistanceFromStore = freezed,
    Object? isValidCheckoutLocation = freezed,
    Object? overtimeAmount = freezed,
    Object? lateDeducutAmount = freezed,
    Object? bonusAmount = freezed,
    Object? isReported = freezed,
    Object? reportTime = freezed,
    Object? problemType = freezed,
    Object? isProblem = freezed,
    Object? isProblemSolved = null,
    Object? reportReason = freezed,
    Object? noticeTag = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ShiftRequestImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: freezed == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
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
      isLate: freezed == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool?,
      isExtratime: freezed == isExtratime
          ? _value.isExtratime
          : isExtratime // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinLocation: freezed == checkinLocation
          ? _value.checkinLocation
          : checkinLocation // ignore: cast_nullable_to_non_nullable
              as AttendanceLocation?,
      checkinDistanceFromStore: freezed == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      isValidCheckinLocation: freezed == isValidCheckinLocation
          ? _value.isValidCheckinLocation
          : isValidCheckinLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkoutLocation: freezed == checkoutLocation
          ? _value.checkoutLocation
          : checkoutLocation // ignore: cast_nullable_to_non_nullable
              as AttendanceLocation?,
      checkoutDistanceFromStore: freezed == checkoutDistanceFromStore
          ? _value.checkoutDistanceFromStore
          : checkoutDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      isValidCheckoutLocation: freezed == isValidCheckoutLocation
          ? _value.isValidCheckoutLocation
          : isValidCheckoutLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      overtimeAmount: freezed == overtimeAmount
          ? _value.overtimeAmount
          : overtimeAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      lateDeducutAmount: freezed == lateDeducutAmount
          ? _value.lateDeducutAmount
          : lateDeducutAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      bonusAmount: freezed == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      isReported: freezed == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool?,
      reportTime: freezed == reportTime
          ? _value.reportTime
          : reportTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      problemType: freezed == problemType
          ? _value.problemType
          : problemType // ignore: cast_nullable_to_non_nullable
              as String?,
      isProblem: freezed == isProblem
          ? _value.isProblem
          : isProblem // ignore: cast_nullable_to_non_nullable
              as bool?,
      isProblemSolved: null == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      reportReason: freezed == reportReason
          ? _value.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String?,
      noticeTag: freezed == noticeTag
          ? _value._noticeTag
          : noticeTag // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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

class _$ShiftRequestImpl extends _ShiftRequest {
  const _$ShiftRequestImpl(
      {required this.shiftRequestId,
      required this.userId,
      required this.shiftId,
      required this.storeId,
      required this.requestDate,
      this.isApproved,
      this.approvedBy,
      this.startTime,
      this.endTime,
      this.actualStartTime,
      this.actualEndTime,
      this.confirmStartTime,
      this.confirmEndTime,
      this.isLate,
      this.isExtratime,
      this.checkinLocation,
      this.checkinDistanceFromStore,
      this.isValidCheckinLocation,
      this.checkoutLocation,
      this.checkoutDistanceFromStore,
      this.isValidCheckoutLocation,
      this.overtimeAmount,
      this.lateDeducutAmount,
      this.bonusAmount,
      this.isReported,
      this.reportTime,
      this.problemType,
      this.isProblem,
      this.isProblemSolved = false,
      this.reportReason,
      final Map<String, dynamic>? noticeTag,
      this.createdAt,
      this.updatedAt})
      : _noticeTag = noticeTag,
        super._();

// Core fields
  @override
  final String shiftRequestId;
  @override
  final String userId;
  @override
  final String shiftId;
  @override
  final String storeId;
  @override
  final String requestDate;
// Approval
  @override
  final bool? isApproved;
  @override
  final String? approvedBy;
// Time fields
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final DateTime? actualStartTime;
  @override
  final DateTime? actualEndTime;
  @override
  final DateTime? confirmStartTime;
  @override
  final DateTime? confirmEndTime;
// Status flags
  @override
  final bool? isLate;
  @override
  final bool? isExtratime;
// Location
  @override
  final AttendanceLocation? checkinLocation;
  @override
  final double? checkinDistanceFromStore;
  @override
  final bool? isValidCheckinLocation;
  @override
  final AttendanceLocation? checkoutLocation;
  @override
  final double? checkoutDistanceFromStore;
  @override
  final bool? isValidCheckoutLocation;
// Financial
  @override
  final double? overtimeAmount;
  @override
  final double? lateDeducutAmount;
  @override
  final double? bonusAmount;
// Problem reporting
  @override
  final bool? isReported;
  @override
  final DateTime? reportTime;
  @override
  final String? problemType;
  @override
  final bool? isProblem;
  @override
  @JsonKey()
  final bool isProblemSolved;
  @override
  final String? reportReason;
// Metadata
  final Map<String, dynamic>? _noticeTag;
// Metadata
  @override
  Map<String, dynamic>? get noticeTag {
    final value = _noticeTag;
    if (value == null) return null;
    if (_noticeTag is EqualUnmodifiableMapView) return _noticeTag;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ShiftRequest(shiftRequestId: $shiftRequestId, userId: $userId, shiftId: $shiftId, storeId: $storeId, requestDate: $requestDate, isApproved: $isApproved, approvedBy: $approvedBy, startTime: $startTime, endTime: $endTime, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, confirmStartTime: $confirmStartTime, confirmEndTime: $confirmEndTime, isLate: $isLate, isExtratime: $isExtratime, checkinLocation: $checkinLocation, checkinDistanceFromStore: $checkinDistanceFromStore, isValidCheckinLocation: $isValidCheckinLocation, checkoutLocation: $checkoutLocation, checkoutDistanceFromStore: $checkoutDistanceFromStore, isValidCheckoutLocation: $isValidCheckoutLocation, overtimeAmount: $overtimeAmount, lateDeducutAmount: $lateDeducutAmount, bonusAmount: $bonusAmount, isReported: $isReported, reportTime: $reportTime, problemType: $problemType, isProblem: $isProblem, isProblemSolved: $isProblemSolved, reportReason: $reportReason, noticeTag: $noticeTag, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftRequestImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.actualStartTime, actualStartTime) ||
                other.actualStartTime == actualStartTime) &&
            (identical(other.actualEndTime, actualEndTime) ||
                other.actualEndTime == actualEndTime) &&
            (identical(other.confirmStartTime, confirmStartTime) ||
                other.confirmStartTime == confirmStartTime) &&
            (identical(other.confirmEndTime, confirmEndTime) ||
                other.confirmEndTime == confirmEndTime) &&
            (identical(other.isLate, isLate) || other.isLate == isLate) &&
            (identical(other.isExtratime, isExtratime) ||
                other.isExtratime == isExtratime) &&
            (identical(other.checkinLocation, checkinLocation) ||
                other.checkinLocation == checkinLocation) &&
            (identical(
                    other.checkinDistanceFromStore, checkinDistanceFromStore) ||
                other.checkinDistanceFromStore == checkinDistanceFromStore) &&
            (identical(other.isValidCheckinLocation, isValidCheckinLocation) ||
                other.isValidCheckinLocation == isValidCheckinLocation) &&
            (identical(other.checkoutLocation, checkoutLocation) ||
                other.checkoutLocation == checkoutLocation) &&
            (identical(other.checkoutDistanceFromStore, checkoutDistanceFromStore) ||
                other.checkoutDistanceFromStore == checkoutDistanceFromStore) &&
            (identical(other.isValidCheckoutLocation, isValidCheckoutLocation) ||
                other.isValidCheckoutLocation == isValidCheckoutLocation) &&
            (identical(other.overtimeAmount, overtimeAmount) ||
                other.overtimeAmount == overtimeAmount) &&
            (identical(other.lateDeducutAmount, lateDeducutAmount) ||
                other.lateDeducutAmount == lateDeducutAmount) &&
            (identical(other.bonusAmount, bonusAmount) ||
                other.bonusAmount == bonusAmount) &&
            (identical(other.isReported, isReported) ||
                other.isReported == isReported) &&
            (identical(other.reportTime, reportTime) ||
                other.reportTime == reportTime) &&
            (identical(other.problemType, problemType) ||
                other.problemType == problemType) &&
            (identical(other.isProblem, isProblem) ||
                other.isProblem == isProblem) &&
            (identical(other.isProblemSolved, isProblemSolved) ||
                other.isProblemSolved == isProblemSolved) &&
            (identical(other.reportReason, reportReason) ||
                other.reportReason == reportReason) &&
            const DeepCollectionEquality()
                .equals(other._noticeTag, _noticeTag) &&
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
        shiftId,
        storeId,
        requestDate,
        isApproved,
        approvedBy,
        startTime,
        endTime,
        actualStartTime,
        actualEndTime,
        confirmStartTime,
        confirmEndTime,
        isLate,
        isExtratime,
        checkinLocation,
        checkinDistanceFromStore,
        isValidCheckinLocation,
        checkoutLocation,
        checkoutDistanceFromStore,
        isValidCheckoutLocation,
        overtimeAmount,
        lateDeducutAmount,
        bonusAmount,
        isReported,
        reportTime,
        problemType,
        isProblem,
        isProblemSolved,
        reportReason,
        const DeepCollectionEquality().hash(_noticeTag),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftRequestImplCopyWith<_$ShiftRequestImpl> get copyWith =>
      __$$ShiftRequestImplCopyWithImpl<_$ShiftRequestImpl>(this, _$identity);
}

abstract class _ShiftRequest extends ShiftRequest {
  const factory _ShiftRequest(
      {required final String shiftRequestId,
      required final String userId,
      required final String shiftId,
      required final String storeId,
      required final String requestDate,
      final bool? isApproved,
      final String? approvedBy,
      final DateTime? startTime,
      final DateTime? endTime,
      final DateTime? actualStartTime,
      final DateTime? actualEndTime,
      final DateTime? confirmStartTime,
      final DateTime? confirmEndTime,
      final bool? isLate,
      final bool? isExtratime,
      final AttendanceLocation? checkinLocation,
      final double? checkinDistanceFromStore,
      final bool? isValidCheckinLocation,
      final AttendanceLocation? checkoutLocation,
      final double? checkoutDistanceFromStore,
      final bool? isValidCheckoutLocation,
      final double? overtimeAmount,
      final double? lateDeducutAmount,
      final double? bonusAmount,
      final bool? isReported,
      final DateTime? reportTime,
      final String? problemType,
      final bool? isProblem,
      final bool isProblemSolved,
      final String? reportReason,
      final Map<String, dynamic>? noticeTag,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ShiftRequestImpl;
  const _ShiftRequest._() : super._();

// Core fields
  @override
  String get shiftRequestId;
  @override
  String get userId;
  @override
  String get shiftId;
  @override
  String get storeId;
  @override
  String get requestDate; // Approval
  @override
  bool? get isApproved;
  @override
  String? get approvedBy; // Time fields
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  DateTime? get actualStartTime;
  @override
  DateTime? get actualEndTime;
  @override
  DateTime? get confirmStartTime;
  @override
  DateTime? get confirmEndTime; // Status flags
  @override
  bool? get isLate;
  @override
  bool? get isExtratime; // Location
  @override
  AttendanceLocation? get checkinLocation;
  @override
  double? get checkinDistanceFromStore;
  @override
  bool? get isValidCheckinLocation;
  @override
  AttendanceLocation? get checkoutLocation;
  @override
  double? get checkoutDistanceFromStore;
  @override
  bool? get isValidCheckoutLocation; // Financial
  @override
  double? get overtimeAmount;
  @override
  double? get lateDeducutAmount;
  @override
  double? get bonusAmount; // Problem reporting
  @override
  bool? get isReported;
  @override
  DateTime? get reportTime;
  @override
  String? get problemType;
  @override
  bool? get isProblem;
  @override
  bool get isProblemSolved;
  @override
  String? get reportReason; // Metadata
  @override
  Map<String, dynamic>? get noticeTag;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftRequestImplCopyWith<_$ShiftRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
