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
  /// The shift request ID
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;

  /// Employee information
  EmployeeInfo get employee => throw _privateConstructorUsedError;

  /// Shift information
  Shift get shift => throw _privateConstructorUsedError;

  /// The date of the shift request (yyyy-MM-dd format)
  @JsonKey(name: 'request_date')
  String get requestDate => throw _privateConstructorUsedError;

  /// Whether the shift is approved
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;

  /// Whether there's a problem with this shift
  @JsonKey(name: 'is_problem')
  bool get hasProblem => throw _privateConstructorUsedError;

  /// Whether the problem has been solved
  @JsonKey(name: 'is_problem_solved', defaultValue: false)
  bool get isProblemSolved => throw _privateConstructorUsedError;

  /// Whether the employee was late
  @JsonKey(name: 'is_late', defaultValue: false)
  bool get isLate => throw _privateConstructorUsedError;

  /// Late duration in minutes
  @JsonKey(name: 'late_minute', defaultValue: 0)
  int get lateMinute => throw _privateConstructorUsedError;

  /// Whether the employee worked overtime
  @JsonKey(name: 'is_over_time', defaultValue: false)
  bool get isOverTime => throw _privateConstructorUsedError;

  /// Overtime duration in minutes
  @JsonKey(name: 'over_time_minute', defaultValue: 0)
  int get overTimeMinute => throw _privateConstructorUsedError;

  /// Paid hours for this shift
  @JsonKey(name: 'paid_hour', defaultValue: 0.0)
  double get paidHour => throw _privateConstructorUsedError;

  /// Whether this shift has been reported
  @JsonKey(name: 'is_reported', defaultValue: false)
  bool get isReported => throw _privateConstructorUsedError;

  /// Bonus amount (if any)
  @JsonKey(name: 'bonus_amount')
  double? get bonusAmount => throw _privateConstructorUsedError;

  /// Reason for bonus (if any)
  @JsonKey(name: 'bonus_reason')
  String? get bonusReason => throw _privateConstructorUsedError;

  /// Confirmed start time (manager-confirmed start time)
  @JsonKey(name: 'confirm_start_time')
  DateTime? get confirmedStartTime => throw _privateConstructorUsedError;

  /// Confirmed end time (manager-confirmed end time)
  @JsonKey(name: 'confirm_end_time')
  DateTime? get confirmedEndTime => throw _privateConstructorUsedError;

  /// Actual start time (employee's actual check-in time from device)
  @JsonKey(name: 'actual_start')
  DateTime? get actualStartTime => throw _privateConstructorUsedError;

  /// Actual end time (employee's actual check-out time from device)
  @JsonKey(name: 'actual_end')
  DateTime? get actualEndTime => throw _privateConstructorUsedError;

  /// Check-in location validity
  @JsonKey(name: 'is_valid_checkin_location')
  bool? get isValidCheckinLocation => throw _privateConstructorUsedError;

  /// Check-in distance from store in meters
  @JsonKey(name: 'checkin_distance_from_store')
  double? get checkinDistanceFromStore => throw _privateConstructorUsedError;

  /// Check-out location validity
  @JsonKey(name: 'is_valid_checkout_location')
  bool? get isValidCheckoutLocation => throw _privateConstructorUsedError;

  /// Check-out distance from store in meters
  @JsonKey(name: 'checkout_distance_from_store')
  double? get checkoutDistanceFromStore => throw _privateConstructorUsedError;

  /// Salary type ('hourly' or 'monthly')
  @JsonKey(name: 'salary_type')
  String? get salaryType => throw _privateConstructorUsedError;

  /// Salary amount (hourly rate or monthly salary)
  @JsonKey(name: 'salary_amount')
  String? get salaryAmount => throw _privateConstructorUsedError;

  /// List of tags associated with this shift card
  @JsonKey(name: 'notice_tag', defaultValue: <Tag>[])
  List<Tag> get tags => throw _privateConstructorUsedError;

  /// Problem type (e.g., "late", "early_checkout", etc.)
  @JsonKey(name: 'problem_type')
  String? get problemType => throw _privateConstructorUsedError;

  /// Report reason if this shift was reported
  @JsonKey(name: 'report_reason')
  String? get reportReason => throw _privateConstructorUsedError;

  /// When the request was created (optional, not returned by RPC)
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// When the request was approved (if approved)
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      EmployeeInfo employee,
      Shift shift,
      @JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'is_problem') bool hasProblem,
      @JsonKey(name: 'is_problem_solved', defaultValue: false)
      bool isProblemSolved,
      @JsonKey(name: 'is_late', defaultValue: false) bool isLate,
      @JsonKey(name: 'late_minute', defaultValue: 0) int lateMinute,
      @JsonKey(name: 'is_over_time', defaultValue: false) bool isOverTime,
      @JsonKey(name: 'over_time_minute', defaultValue: 0) int overTimeMinute,
      @JsonKey(name: 'paid_hour', defaultValue: 0.0) double paidHour,
      @JsonKey(name: 'is_reported', defaultValue: false) bool isReported,
      @JsonKey(name: 'bonus_amount') double? bonusAmount,
      @JsonKey(name: 'bonus_reason') String? bonusReason,
      @JsonKey(name: 'confirm_start_time') DateTime? confirmedStartTime,
      @JsonKey(name: 'confirm_end_time') DateTime? confirmedEndTime,
      @JsonKey(name: 'actual_start') DateTime? actualStartTime,
      @JsonKey(name: 'actual_end') DateTime? actualEndTime,
      @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      double? checkinDistanceFromStore,
      @JsonKey(name: 'is_valid_checkout_location')
      bool? isValidCheckoutLocation,
      @JsonKey(name: 'checkout_distance_from_store')
      double? checkoutDistanceFromStore,
      @JsonKey(name: 'salary_type') String? salaryType,
      @JsonKey(name: 'salary_amount') String? salaryAmount,
      @JsonKey(name: 'notice_tag', defaultValue: <Tag>[]) List<Tag> tags,
      @JsonKey(name: 'problem_type') String? problemType,
      @JsonKey(name: 'report_reason') String? reportReason,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'approved_at') DateTime? approvedAt});

  $EmployeeInfoCopyWith<$Res> get employee;
  $ShiftCopyWith<$Res> get shift;
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
    Object? shiftRequestId = null,
    Object? employee = null,
    Object? shift = null,
    Object? requestDate = null,
    Object? isApproved = null,
    Object? hasProblem = null,
    Object? isProblemSolved = null,
    Object? isLate = null,
    Object? lateMinute = null,
    Object? isOverTime = null,
    Object? overTimeMinute = null,
    Object? paidHour = null,
    Object? isReported = null,
    Object? bonusAmount = freezed,
    Object? bonusReason = freezed,
    Object? confirmedStartTime = freezed,
    Object? confirmedEndTime = freezed,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? isValidCheckinLocation = freezed,
    Object? checkinDistanceFromStore = freezed,
    Object? isValidCheckoutLocation = freezed,
    Object? checkoutDistanceFromStore = freezed,
    Object? salaryType = freezed,
    Object? salaryAmount = freezed,
    Object? tags = null,
    Object? problemType = freezed,
    Object? reportReason = freezed,
    Object? createdAt = freezed,
    Object? approvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      employee: null == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as EmployeeInfo,
      shift: null == shift
          ? _value.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as Shift,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      hasProblem: null == hasProblem
          ? _value.hasProblem
          : hasProblem // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblemSolved: null == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      lateMinute: null == lateMinute
          ? _value.lateMinute
          : lateMinute // ignore: cast_nullable_to_non_nullable
              as int,
      isOverTime: null == isOverTime
          ? _value.isOverTime
          : isOverTime // ignore: cast_nullable_to_non_nullable
              as bool,
      overTimeMinute: null == overTimeMinute
          ? _value.overTimeMinute
          : overTimeMinute // ignore: cast_nullable_to_non_nullable
              as int,
      paidHour: null == paidHour
          ? _value.paidHour
          : paidHour // ignore: cast_nullable_to_non_nullable
              as double,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      bonusAmount: freezed == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      bonusReason: freezed == bonusReason
          ? _value.bonusReason
          : bonusReason // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedStartTime: freezed == confirmedStartTime
          ? _value.confirmedStartTime
          : confirmedStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedEndTime: freezed == confirmedEndTime
          ? _value.confirmedEndTime
          : confirmedEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isValidCheckinLocation: freezed == isValidCheckinLocation
          ? _value.isValidCheckinLocation
          : isValidCheckinLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinDistanceFromStore: freezed == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      isValidCheckoutLocation: freezed == isValidCheckoutLocation
          ? _value.isValidCheckoutLocation
          : isValidCheckoutLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkoutDistanceFromStore: freezed == checkoutDistanceFromStore
          ? _value.checkoutDistanceFromStore
          : checkoutDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryAmount: freezed == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      problemType: freezed == problemType
          ? _value.problemType
          : problemType // ignore: cast_nullable_to_non_nullable
              as String?,
      reportReason: freezed == reportReason
          ? _value.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmployeeInfoCopyWith<$Res> get employee {
    return $EmployeeInfoCopyWith<$Res>(_value.employee, (value) {
      return _then(_value.copyWith(employee: value) as $Val);
    });
  }

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftCopyWith<$Res> get shift {
    return $ShiftCopyWith<$Res>(_value.shift, (value) {
      return _then(_value.copyWith(shift: value) as $Val);
    });
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
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      EmployeeInfo employee,
      Shift shift,
      @JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'is_problem') bool hasProblem,
      @JsonKey(name: 'is_problem_solved', defaultValue: false)
      bool isProblemSolved,
      @JsonKey(name: 'is_late', defaultValue: false) bool isLate,
      @JsonKey(name: 'late_minute', defaultValue: 0) int lateMinute,
      @JsonKey(name: 'is_over_time', defaultValue: false) bool isOverTime,
      @JsonKey(name: 'over_time_minute', defaultValue: 0) int overTimeMinute,
      @JsonKey(name: 'paid_hour', defaultValue: 0.0) double paidHour,
      @JsonKey(name: 'is_reported', defaultValue: false) bool isReported,
      @JsonKey(name: 'bonus_amount') double? bonusAmount,
      @JsonKey(name: 'bonus_reason') String? bonusReason,
      @JsonKey(name: 'confirm_start_time') DateTime? confirmedStartTime,
      @JsonKey(name: 'confirm_end_time') DateTime? confirmedEndTime,
      @JsonKey(name: 'actual_start') DateTime? actualStartTime,
      @JsonKey(name: 'actual_end') DateTime? actualEndTime,
      @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      double? checkinDistanceFromStore,
      @JsonKey(name: 'is_valid_checkout_location')
      bool? isValidCheckoutLocation,
      @JsonKey(name: 'checkout_distance_from_store')
      double? checkoutDistanceFromStore,
      @JsonKey(name: 'salary_type') String? salaryType,
      @JsonKey(name: 'salary_amount') String? salaryAmount,
      @JsonKey(name: 'notice_tag', defaultValue: <Tag>[]) List<Tag> tags,
      @JsonKey(name: 'problem_type') String? problemType,
      @JsonKey(name: 'report_reason') String? reportReason,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'approved_at') DateTime? approvedAt});

  @override
  $EmployeeInfoCopyWith<$Res> get employee;
  @override
  $ShiftCopyWith<$Res> get shift;
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
    Object? shiftRequestId = null,
    Object? employee = null,
    Object? shift = null,
    Object? requestDate = null,
    Object? isApproved = null,
    Object? hasProblem = null,
    Object? isProblemSolved = null,
    Object? isLate = null,
    Object? lateMinute = null,
    Object? isOverTime = null,
    Object? overTimeMinute = null,
    Object? paidHour = null,
    Object? isReported = null,
    Object? bonusAmount = freezed,
    Object? bonusReason = freezed,
    Object? confirmedStartTime = freezed,
    Object? confirmedEndTime = freezed,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? isValidCheckinLocation = freezed,
    Object? checkinDistanceFromStore = freezed,
    Object? isValidCheckoutLocation = freezed,
    Object? checkoutDistanceFromStore = freezed,
    Object? salaryType = freezed,
    Object? salaryAmount = freezed,
    Object? tags = null,
    Object? problemType = freezed,
    Object? reportReason = freezed,
    Object? createdAt = freezed,
    Object? approvedAt = freezed,
  }) {
    return _then(_$ShiftCardImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      employee: null == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as EmployeeInfo,
      shift: null == shift
          ? _value.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as Shift,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      hasProblem: null == hasProblem
          ? _value.hasProblem
          : hasProblem // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblemSolved: null == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      lateMinute: null == lateMinute
          ? _value.lateMinute
          : lateMinute // ignore: cast_nullable_to_non_nullable
              as int,
      isOverTime: null == isOverTime
          ? _value.isOverTime
          : isOverTime // ignore: cast_nullable_to_non_nullable
              as bool,
      overTimeMinute: null == overTimeMinute
          ? _value.overTimeMinute
          : overTimeMinute // ignore: cast_nullable_to_non_nullable
              as int,
      paidHour: null == paidHour
          ? _value.paidHour
          : paidHour // ignore: cast_nullable_to_non_nullable
              as double,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      bonusAmount: freezed == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      bonusReason: freezed == bonusReason
          ? _value.bonusReason
          : bonusReason // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedStartTime: freezed == confirmedStartTime
          ? _value.confirmedStartTime
          : confirmedStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedEndTime: freezed == confirmedEndTime
          ? _value.confirmedEndTime
          : confirmedEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isValidCheckinLocation: freezed == isValidCheckinLocation
          ? _value.isValidCheckinLocation
          : isValidCheckinLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinDistanceFromStore: freezed == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      isValidCheckoutLocation: freezed == isValidCheckoutLocation
          ? _value.isValidCheckoutLocation
          : isValidCheckoutLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkoutDistanceFromStore: freezed == checkoutDistanceFromStore
          ? _value.checkoutDistanceFromStore
          : checkoutDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double?,
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryAmount: freezed == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      problemType: freezed == problemType
          ? _value.problemType
          : problemType // ignore: cast_nullable_to_non_nullable
              as String?,
      reportReason: freezed == reportReason
          ? _value.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftCardImpl extends _ShiftCard {
  const _$ShiftCardImpl(
      {@JsonKey(name: 'shift_request_id') required this.shiftRequestId,
      required this.employee,
      required this.shift,
      @JsonKey(name: 'request_date') required this.requestDate,
      @JsonKey(name: 'is_approved') required this.isApproved,
      @JsonKey(name: 'is_problem') required this.hasProblem,
      @JsonKey(name: 'is_problem_solved', defaultValue: false)
      required this.isProblemSolved,
      @JsonKey(name: 'is_late', defaultValue: false) required this.isLate,
      @JsonKey(name: 'late_minute', defaultValue: 0) required this.lateMinute,
      @JsonKey(name: 'is_over_time', defaultValue: false)
      required this.isOverTime,
      @JsonKey(name: 'over_time_minute', defaultValue: 0)
      required this.overTimeMinute,
      @JsonKey(name: 'paid_hour', defaultValue: 0.0) required this.paidHour,
      @JsonKey(name: 'is_reported', defaultValue: false)
      required this.isReported,
      @JsonKey(name: 'bonus_amount') this.bonusAmount,
      @JsonKey(name: 'bonus_reason') this.bonusReason,
      @JsonKey(name: 'confirm_start_time') this.confirmedStartTime,
      @JsonKey(name: 'confirm_end_time') this.confirmedEndTime,
      @JsonKey(name: 'actual_start') this.actualStartTime,
      @JsonKey(name: 'actual_end') this.actualEndTime,
      @JsonKey(name: 'is_valid_checkin_location') this.isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      this.checkinDistanceFromStore,
      @JsonKey(name: 'is_valid_checkout_location') this.isValidCheckoutLocation,
      @JsonKey(name: 'checkout_distance_from_store')
      this.checkoutDistanceFromStore,
      @JsonKey(name: 'salary_type') this.salaryType,
      @JsonKey(name: 'salary_amount') this.salaryAmount,
      @JsonKey(name: 'notice_tag', defaultValue: <Tag>[])
      required final List<Tag> tags,
      @JsonKey(name: 'problem_type') this.problemType,
      @JsonKey(name: 'report_reason') this.reportReason,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'approved_at') this.approvedAt})
      : _tags = tags,
        super._();

  factory _$ShiftCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftCardImplFromJson(json);

  /// The shift request ID
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;

  /// Employee information
  @override
  final EmployeeInfo employee;

  /// Shift information
  @override
  final Shift shift;

  /// The date of the shift request (yyyy-MM-dd format)
  @override
  @JsonKey(name: 'request_date')
  final String requestDate;

  /// Whether the shift is approved
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;

  /// Whether there's a problem with this shift
  @override
  @JsonKey(name: 'is_problem')
  final bool hasProblem;

  /// Whether the problem has been solved
  @override
  @JsonKey(name: 'is_problem_solved', defaultValue: false)
  final bool isProblemSolved;

  /// Whether the employee was late
  @override
  @JsonKey(name: 'is_late', defaultValue: false)
  final bool isLate;

  /// Late duration in minutes
  @override
  @JsonKey(name: 'late_minute', defaultValue: 0)
  final int lateMinute;

  /// Whether the employee worked overtime
  @override
  @JsonKey(name: 'is_over_time', defaultValue: false)
  final bool isOverTime;

  /// Overtime duration in minutes
  @override
  @JsonKey(name: 'over_time_minute', defaultValue: 0)
  final int overTimeMinute;

  /// Paid hours for this shift
  @override
  @JsonKey(name: 'paid_hour', defaultValue: 0.0)
  final double paidHour;

  /// Whether this shift has been reported
  @override
  @JsonKey(name: 'is_reported', defaultValue: false)
  final bool isReported;

  /// Bonus amount (if any)
  @override
  @JsonKey(name: 'bonus_amount')
  final double? bonusAmount;

  /// Reason for bonus (if any)
  @override
  @JsonKey(name: 'bonus_reason')
  final String? bonusReason;

  /// Confirmed start time (manager-confirmed start time)
  @override
  @JsonKey(name: 'confirm_start_time')
  final DateTime? confirmedStartTime;

  /// Confirmed end time (manager-confirmed end time)
  @override
  @JsonKey(name: 'confirm_end_time')
  final DateTime? confirmedEndTime;

  /// Actual start time (employee's actual check-in time from device)
  @override
  @JsonKey(name: 'actual_start')
  final DateTime? actualStartTime;

  /// Actual end time (employee's actual check-out time from device)
  @override
  @JsonKey(name: 'actual_end')
  final DateTime? actualEndTime;

  /// Check-in location validity
  @override
  @JsonKey(name: 'is_valid_checkin_location')
  final bool? isValidCheckinLocation;

  /// Check-in distance from store in meters
  @override
  @JsonKey(name: 'checkin_distance_from_store')
  final double? checkinDistanceFromStore;

  /// Check-out location validity
  @override
  @JsonKey(name: 'is_valid_checkout_location')
  final bool? isValidCheckoutLocation;

  /// Check-out distance from store in meters
  @override
  @JsonKey(name: 'checkout_distance_from_store')
  final double? checkoutDistanceFromStore;

  /// Salary type ('hourly' or 'monthly')
  @override
  @JsonKey(name: 'salary_type')
  final String? salaryType;

  /// Salary amount (hourly rate or monthly salary)
  @override
  @JsonKey(name: 'salary_amount')
  final String? salaryAmount;

  /// List of tags associated with this shift card
  final List<Tag> _tags;

  /// List of tags associated with this shift card
  @override
  @JsonKey(name: 'notice_tag', defaultValue: <Tag>[])
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Problem type (e.g., "late", "early_checkout", etc.)
  @override
  @JsonKey(name: 'problem_type')
  final String? problemType;

  /// Report reason if this shift was reported
  @override
  @JsonKey(name: 'report_reason')
  final String? reportReason;

  /// When the request was created (optional, not returned by RPC)
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// When the request was approved (if approved)
  @override
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;

  @override
  String toString() {
    return 'ShiftCard(shiftRequestId: $shiftRequestId, employee: $employee, shift: $shift, requestDate: $requestDate, isApproved: $isApproved, hasProblem: $hasProblem, isProblemSolved: $isProblemSolved, isLate: $isLate, lateMinute: $lateMinute, isOverTime: $isOverTime, overTimeMinute: $overTimeMinute, paidHour: $paidHour, isReported: $isReported, bonusAmount: $bonusAmount, bonusReason: $bonusReason, confirmedStartTime: $confirmedStartTime, confirmedEndTime: $confirmedEndTime, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, isValidCheckinLocation: $isValidCheckinLocation, checkinDistanceFromStore: $checkinDistanceFromStore, isValidCheckoutLocation: $isValidCheckoutLocation, checkoutDistanceFromStore: $checkoutDistanceFromStore, salaryType: $salaryType, salaryAmount: $salaryAmount, tags: $tags, problemType: $problemType, reportReason: $reportReason, createdAt: $createdAt, approvedAt: $approvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftCardImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.employee, employee) ||
                other.employee == employee) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.hasProblem, hasProblem) ||
                other.hasProblem == hasProblem) &&
            (identical(other.isProblemSolved, isProblemSolved) ||
                other.isProblemSolved == isProblemSolved) &&
            (identical(other.isLate, isLate) || other.isLate == isLate) &&
            (identical(other.lateMinute, lateMinute) ||
                other.lateMinute == lateMinute) &&
            (identical(other.isOverTime, isOverTime) ||
                other.isOverTime == isOverTime) &&
            (identical(other.overTimeMinute, overTimeMinute) ||
                other.overTimeMinute == overTimeMinute) &&
            (identical(other.paidHour, paidHour) ||
                other.paidHour == paidHour) &&
            (identical(other.isReported, isReported) ||
                other.isReported == isReported) &&
            (identical(other.bonusAmount, bonusAmount) ||
                other.bonusAmount == bonusAmount) &&
            (identical(other.bonusReason, bonusReason) ||
                other.bonusReason == bonusReason) &&
            (identical(other.confirmedStartTime, confirmedStartTime) ||
                other.confirmedStartTime == confirmedStartTime) &&
            (identical(other.confirmedEndTime, confirmedEndTime) ||
                other.confirmedEndTime == confirmedEndTime) &&
            (identical(other.actualStartTime, actualStartTime) ||
                other.actualStartTime == actualStartTime) &&
            (identical(other.actualEndTime, actualEndTime) ||
                other.actualEndTime == actualEndTime) &&
            (identical(other.isValidCheckinLocation, isValidCheckinLocation) ||
                other.isValidCheckinLocation == isValidCheckinLocation) &&
            (identical(
                    other.checkinDistanceFromStore, checkinDistanceFromStore) ||
                other.checkinDistanceFromStore == checkinDistanceFromStore) &&
            (identical(
                    other.isValidCheckoutLocation, isValidCheckoutLocation) ||
                other.isValidCheckoutLocation == isValidCheckoutLocation) &&
            (identical(other.checkoutDistanceFromStore,
                    checkoutDistanceFromStore) ||
                other.checkoutDistanceFromStore == checkoutDistanceFromStore) &&
            (identical(other.salaryType, salaryType) ||
                other.salaryType == salaryType) &&
            (identical(other.salaryAmount, salaryAmount) ||
                other.salaryAmount == salaryAmount) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.problemType, problemType) ||
                other.problemType == problemType) &&
            (identical(other.reportReason, reportReason) ||
                other.reportReason == reportReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        shiftRequestId,
        employee,
        shift,
        requestDate,
        isApproved,
        hasProblem,
        isProblemSolved,
        isLate,
        lateMinute,
        isOverTime,
        overTimeMinute,
        paidHour,
        isReported,
        bonusAmount,
        bonusReason,
        confirmedStartTime,
        confirmedEndTime,
        actualStartTime,
        actualEndTime,
        isValidCheckinLocation,
        checkinDistanceFromStore,
        isValidCheckoutLocation,
        checkoutDistanceFromStore,
        salaryType,
        salaryAmount,
        const DeepCollectionEquality().hash(_tags),
        problemType,
        reportReason,
        createdAt,
        approvedAt
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
      {@JsonKey(name: 'shift_request_id') required final String shiftRequestId,
      required final EmployeeInfo employee,
      required final Shift shift,
      @JsonKey(name: 'request_date') required final String requestDate,
      @JsonKey(name: 'is_approved') required final bool isApproved,
      @JsonKey(name: 'is_problem') required final bool hasProblem,
      @JsonKey(name: 'is_problem_solved', defaultValue: false)
      required final bool isProblemSolved,
      @JsonKey(name: 'is_late', defaultValue: false) required final bool isLate,
      @JsonKey(name: 'late_minute', defaultValue: 0)
      required final int lateMinute,
      @JsonKey(name: 'is_over_time', defaultValue: false)
      required final bool isOverTime,
      @JsonKey(name: 'over_time_minute', defaultValue: 0)
      required final int overTimeMinute,
      @JsonKey(name: 'paid_hour', defaultValue: 0.0)
      required final double paidHour,
      @JsonKey(name: 'is_reported', defaultValue: false)
      required final bool isReported,
      @JsonKey(name: 'bonus_amount') final double? bonusAmount,
      @JsonKey(name: 'bonus_reason') final String? bonusReason,
      @JsonKey(name: 'confirm_start_time') final DateTime? confirmedStartTime,
      @JsonKey(name: 'confirm_end_time') final DateTime? confirmedEndTime,
      @JsonKey(name: 'actual_start') final DateTime? actualStartTime,
      @JsonKey(name: 'actual_end') final DateTime? actualEndTime,
      @JsonKey(name: 'is_valid_checkin_location')
      final bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      final double? checkinDistanceFromStore,
      @JsonKey(name: 'is_valid_checkout_location')
      final bool? isValidCheckoutLocation,
      @JsonKey(name: 'checkout_distance_from_store')
      final double? checkoutDistanceFromStore,
      @JsonKey(name: 'salary_type') final String? salaryType,
      @JsonKey(name: 'salary_amount') final String? salaryAmount,
      @JsonKey(name: 'notice_tag', defaultValue: <Tag>[])
      required final List<Tag> tags,
      @JsonKey(name: 'problem_type') final String? problemType,
      @JsonKey(name: 'report_reason') final String? reportReason,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'approved_at')
      final DateTime? approvedAt}) = _$ShiftCardImpl;
  const _ShiftCard._() : super._();

  factory _ShiftCard.fromJson(Map<String, dynamic> json) =
      _$ShiftCardImpl.fromJson;

  /// The shift request ID
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;

  /// Employee information
  @override
  EmployeeInfo get employee;

  /// Shift information
  @override
  Shift get shift;

  /// The date of the shift request (yyyy-MM-dd format)
  @override
  @JsonKey(name: 'request_date')
  String get requestDate;

  /// Whether the shift is approved
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;

  /// Whether there's a problem with this shift
  @override
  @JsonKey(name: 'is_problem')
  bool get hasProblem;

  /// Whether the problem has been solved
  @override
  @JsonKey(name: 'is_problem_solved', defaultValue: false)
  bool get isProblemSolved;

  /// Whether the employee was late
  @override
  @JsonKey(name: 'is_late', defaultValue: false)
  bool get isLate;

  /// Late duration in minutes
  @override
  @JsonKey(name: 'late_minute', defaultValue: 0)
  int get lateMinute;

  /// Whether the employee worked overtime
  @override
  @JsonKey(name: 'is_over_time', defaultValue: false)
  bool get isOverTime;

  /// Overtime duration in minutes
  @override
  @JsonKey(name: 'over_time_minute', defaultValue: 0)
  int get overTimeMinute;

  /// Paid hours for this shift
  @override
  @JsonKey(name: 'paid_hour', defaultValue: 0.0)
  double get paidHour;

  /// Whether this shift has been reported
  @override
  @JsonKey(name: 'is_reported', defaultValue: false)
  bool get isReported;

  /// Bonus amount (if any)
  @override
  @JsonKey(name: 'bonus_amount')
  double? get bonusAmount;

  /// Reason for bonus (if any)
  @override
  @JsonKey(name: 'bonus_reason')
  String? get bonusReason;

  /// Confirmed start time (manager-confirmed start time)
  @override
  @JsonKey(name: 'confirm_start_time')
  DateTime? get confirmedStartTime;

  /// Confirmed end time (manager-confirmed end time)
  @override
  @JsonKey(name: 'confirm_end_time')
  DateTime? get confirmedEndTime;

  /// Actual start time (employee's actual check-in time from device)
  @override
  @JsonKey(name: 'actual_start')
  DateTime? get actualStartTime;

  /// Actual end time (employee's actual check-out time from device)
  @override
  @JsonKey(name: 'actual_end')
  DateTime? get actualEndTime;

  /// Check-in location validity
  @override
  @JsonKey(name: 'is_valid_checkin_location')
  bool? get isValidCheckinLocation;

  /// Check-in distance from store in meters
  @override
  @JsonKey(name: 'checkin_distance_from_store')
  double? get checkinDistanceFromStore;

  /// Check-out location validity
  @override
  @JsonKey(name: 'is_valid_checkout_location')
  bool? get isValidCheckoutLocation;

  /// Check-out distance from store in meters
  @override
  @JsonKey(name: 'checkout_distance_from_store')
  double? get checkoutDistanceFromStore;

  /// Salary type ('hourly' or 'monthly')
  @override
  @JsonKey(name: 'salary_type')
  String? get salaryType;

  /// Salary amount (hourly rate or monthly salary)
  @override
  @JsonKey(name: 'salary_amount')
  String? get salaryAmount;

  /// List of tags associated with this shift card
  @override
  @JsonKey(name: 'notice_tag', defaultValue: <Tag>[])
  List<Tag> get tags;

  /// Problem type (e.g., "late", "early_checkout", etc.)
  @override
  @JsonKey(name: 'problem_type')
  String? get problemType;

  /// Report reason if this shift was reported
  @override
  @JsonKey(name: 'report_reason')
  String? get reportReason;

  /// When the request was created (optional, not returned by RPC)
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// When the request was approved (if approved)
  @override
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt;

  /// Create a copy of ShiftCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftCardImplCopyWith<_$ShiftCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
