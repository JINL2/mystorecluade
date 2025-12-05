// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftCardDto _$ShiftCardDtoFromJson(Map<String, dynamic> json) {
  return _ShiftCardDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftCardDto {
// Core identification
// v3: shift_date (actual work date from start_time_utc) instead of request_date
// Made nullable with defaults to handle empty RPC responses
  @JsonKey(name: 'shift_date')
  String get shiftDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId =>
      throw _privateConstructorUsedError; // User information
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage =>
      throw _privateConstructorUsedError; // Shift information
  @JsonKey(name: 'shift_name')
  String? get shiftName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_time')
  @ShiftTimeConverter()
  ShiftTime? get shiftTime =>
      throw _privateConstructorUsedError; // Approval status
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_problem')
  bool get isProblem => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_problem_solved')
  bool get isProblemSolved =>
      throw _privateConstructorUsedError; // Time tracking
  @JsonKey(name: 'is_late')
  bool get isLate => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_minute')
  int get lateMinute => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_over_time')
  bool get isOverTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'over_time_minute')
  int get overTimeMinute => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_hour')
  double get paidHour =>
      throw _privateConstructorUsedError; // Salary information (NEW in RPC)
  @JsonKey(name: 'salary_type')
  String? get salaryType => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_amount')
  String? get salaryAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_pay')
  String? get basePay => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pay_with_bonus')
  String? get totalPayWithBonus =>
      throw _privateConstructorUsedError; // Bonus information
  @JsonKey(name: 'bonus_amount')
  double get bonusAmount =>
      throw _privateConstructorUsedError; // Time records (HH:MM:SS or HH:MM format from RPC)
  @JsonKey(name: 'actual_start')
  String? get actualStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_end')
  String? get actualEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirm_start_time')
  String? get confirmStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirm_end_time')
  String? get confirmEndTime =>
      throw _privateConstructorUsedError; // Tags (jsonb array in RPC)
  @JsonKey(name: 'notice_tag')
  List<TagDto> get noticeTags =>
      throw _privateConstructorUsedError; // Problem details
  @JsonKey(name: 'problem_type')
  String? get problemType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_reported')
  bool get isReported => throw _privateConstructorUsedError;
  @JsonKey(name: 'report_reason')
  String? get reportReason =>
      throw _privateConstructorUsedError; // Location validation (NEW in RPC)
  @JsonKey(name: 'is_valid_checkin_location')
  bool? get isValidCheckinLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkin_distance_from_store')
  double get checkinDistanceFromStore => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_valid_checkout_location')
  bool? get isValidCheckoutLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'checkout_distance_from_store')
  double get checkoutDistanceFromStore =>
      throw _privateConstructorUsedError; // Store information
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;

  /// Serializes this ShiftCardDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftCardDtoCopyWith<ShiftCardDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftCardDtoCopyWith<$Res> {
  factory $ShiftCardDtoCopyWith(
          ShiftCardDto value, $Res Function(ShiftCardDto) then) =
      _$ShiftCardDtoCopyWithImpl<$Res, ShiftCardDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_date') String shiftDate,
      @JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'shift_time') @ShiftTimeConverter() ShiftTime? shiftTime,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'is_problem') bool isProblem,
      @JsonKey(name: 'is_problem_solved') bool isProblemSolved,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'late_minute') int lateMinute,
      @JsonKey(name: 'is_over_time') bool isOverTime,
      @JsonKey(name: 'over_time_minute') int overTimeMinute,
      @JsonKey(name: 'paid_hour') double paidHour,
      @JsonKey(name: 'salary_type') String? salaryType,
      @JsonKey(name: 'salary_amount') String? salaryAmount,
      @JsonKey(name: 'base_pay') String? basePay,
      @JsonKey(name: 'total_pay_with_bonus') String? totalPayWithBonus,
      @JsonKey(name: 'bonus_amount') double bonusAmount,
      @JsonKey(name: 'actual_start') String? actualStart,
      @JsonKey(name: 'actual_end') String? actualEnd,
      @JsonKey(name: 'confirm_start_time') String? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') String? confirmEndTime,
      @JsonKey(name: 'notice_tag') List<TagDto> noticeTags,
      @JsonKey(name: 'problem_type') String? problemType,
      @JsonKey(name: 'is_reported') bool isReported,
      @JsonKey(name: 'report_reason') String? reportReason,
      @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      double checkinDistanceFromStore,
      @JsonKey(name: 'is_valid_checkout_location')
      bool? isValidCheckoutLocation,
      @JsonKey(name: 'checkout_distance_from_store')
      double checkoutDistanceFromStore,
      @JsonKey(name: 'store_name') String? storeName});
}

/// @nodoc
class _$ShiftCardDtoCopyWithImpl<$Res, $Val extends ShiftCardDto>
    implements $ShiftCardDtoCopyWith<$Res> {
  _$ShiftCardDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftDate = null,
    Object? shiftRequestId = null,
    Object? userName = null,
    Object? profileImage = freezed,
    Object? shiftName = freezed,
    Object? shiftTime = freezed,
    Object? isApproved = null,
    Object? isProblem = null,
    Object? isProblemSolved = null,
    Object? isLate = null,
    Object? lateMinute = null,
    Object? isOverTime = null,
    Object? overTimeMinute = null,
    Object? paidHour = null,
    Object? salaryType = freezed,
    Object? salaryAmount = freezed,
    Object? basePay = freezed,
    Object? totalPayWithBonus = freezed,
    Object? bonusAmount = null,
    Object? actualStart = freezed,
    Object? actualEnd = freezed,
    Object? confirmStartTime = freezed,
    Object? confirmEndTime = freezed,
    Object? noticeTags = null,
    Object? problemType = freezed,
    Object? isReported = null,
    Object? reportReason = freezed,
    Object? isValidCheckinLocation = freezed,
    Object? checkinDistanceFromStore = null,
    Object? isValidCheckoutLocation = freezed,
    Object? checkoutDistanceFromStore = null,
    Object? storeName = freezed,
  }) {
    return _then(_value.copyWith(
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftTime: freezed == shiftTime
          ? _value.shiftTime
          : shiftTime // ignore: cast_nullable_to_non_nullable
              as ShiftTime?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblem: null == isProblem
          ? _value.isProblem
          : isProblem // ignore: cast_nullable_to_non_nullable
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
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryAmount: freezed == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      basePay: freezed == basePay
          ? _value.basePay
          : basePay // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPayWithBonus: freezed == totalPayWithBonus
          ? _value.totalPayWithBonus
          : totalPayWithBonus // ignore: cast_nullable_to_non_nullable
              as String?,
      bonusAmount: null == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualStart: freezed == actualStart
          ? _value.actualStart
          : actualStart // ignore: cast_nullable_to_non_nullable
              as String?,
      actualEnd: freezed == actualEnd
          ? _value.actualEnd
          : actualEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmStartTime: freezed == confirmStartTime
          ? _value.confirmStartTime
          : confirmStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmEndTime: freezed == confirmEndTime
          ? _value.confirmEndTime
          : confirmEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      noticeTags: null == noticeTags
          ? _value.noticeTags
          : noticeTags // ignore: cast_nullable_to_non_nullable
              as List<TagDto>,
      problemType: freezed == problemType
          ? _value.problemType
          : problemType // ignore: cast_nullable_to_non_nullable
              as String?,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      reportReason: freezed == reportReason
          ? _value.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String?,
      isValidCheckinLocation: freezed == isValidCheckinLocation
          ? _value.isValidCheckinLocation
          : isValidCheckinLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinDistanceFromStore: null == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double,
      isValidCheckoutLocation: freezed == isValidCheckoutLocation
          ? _value.isValidCheckoutLocation
          : isValidCheckoutLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkoutDistanceFromStore: null == checkoutDistanceFromStore
          ? _value.checkoutDistanceFromStore
          : checkoutDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftCardDtoImplCopyWith<$Res>
    implements $ShiftCardDtoCopyWith<$Res> {
  factory _$$ShiftCardDtoImplCopyWith(
          _$ShiftCardDtoImpl value, $Res Function(_$ShiftCardDtoImpl) then) =
      __$$ShiftCardDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_date') String shiftDate,
      @JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'shift_time') @ShiftTimeConverter() ShiftTime? shiftTime,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'is_problem') bool isProblem,
      @JsonKey(name: 'is_problem_solved') bool isProblemSolved,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'late_minute') int lateMinute,
      @JsonKey(name: 'is_over_time') bool isOverTime,
      @JsonKey(name: 'over_time_minute') int overTimeMinute,
      @JsonKey(name: 'paid_hour') double paidHour,
      @JsonKey(name: 'salary_type') String? salaryType,
      @JsonKey(name: 'salary_amount') String? salaryAmount,
      @JsonKey(name: 'base_pay') String? basePay,
      @JsonKey(name: 'total_pay_with_bonus') String? totalPayWithBonus,
      @JsonKey(name: 'bonus_amount') double bonusAmount,
      @JsonKey(name: 'actual_start') String? actualStart,
      @JsonKey(name: 'actual_end') String? actualEnd,
      @JsonKey(name: 'confirm_start_time') String? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') String? confirmEndTime,
      @JsonKey(name: 'notice_tag') List<TagDto> noticeTags,
      @JsonKey(name: 'problem_type') String? problemType,
      @JsonKey(name: 'is_reported') bool isReported,
      @JsonKey(name: 'report_reason') String? reportReason,
      @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      double checkinDistanceFromStore,
      @JsonKey(name: 'is_valid_checkout_location')
      bool? isValidCheckoutLocation,
      @JsonKey(name: 'checkout_distance_from_store')
      double checkoutDistanceFromStore,
      @JsonKey(name: 'store_name') String? storeName});
}

/// @nodoc
class __$$ShiftCardDtoImplCopyWithImpl<$Res>
    extends _$ShiftCardDtoCopyWithImpl<$Res, _$ShiftCardDtoImpl>
    implements _$$ShiftCardDtoImplCopyWith<$Res> {
  __$$ShiftCardDtoImplCopyWithImpl(
      _$ShiftCardDtoImpl _value, $Res Function(_$ShiftCardDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftDate = null,
    Object? shiftRequestId = null,
    Object? userName = null,
    Object? profileImage = freezed,
    Object? shiftName = freezed,
    Object? shiftTime = freezed,
    Object? isApproved = null,
    Object? isProblem = null,
    Object? isProblemSolved = null,
    Object? isLate = null,
    Object? lateMinute = null,
    Object? isOverTime = null,
    Object? overTimeMinute = null,
    Object? paidHour = null,
    Object? salaryType = freezed,
    Object? salaryAmount = freezed,
    Object? basePay = freezed,
    Object? totalPayWithBonus = freezed,
    Object? bonusAmount = null,
    Object? actualStart = freezed,
    Object? actualEnd = freezed,
    Object? confirmStartTime = freezed,
    Object? confirmEndTime = freezed,
    Object? noticeTags = null,
    Object? problemType = freezed,
    Object? isReported = null,
    Object? reportReason = freezed,
    Object? isValidCheckinLocation = freezed,
    Object? checkinDistanceFromStore = null,
    Object? isValidCheckoutLocation = freezed,
    Object? checkoutDistanceFromStore = null,
    Object? storeName = freezed,
  }) {
    return _then(_$ShiftCardDtoImpl(
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftTime: freezed == shiftTime
          ? _value.shiftTime
          : shiftTime // ignore: cast_nullable_to_non_nullable
              as ShiftTime?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblem: null == isProblem
          ? _value.isProblem
          : isProblem // ignore: cast_nullable_to_non_nullable
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
      salaryType: freezed == salaryType
          ? _value.salaryType
          : salaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      salaryAmount: freezed == salaryAmount
          ? _value.salaryAmount
          : salaryAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      basePay: freezed == basePay
          ? _value.basePay
          : basePay // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPayWithBonus: freezed == totalPayWithBonus
          ? _value.totalPayWithBonus
          : totalPayWithBonus // ignore: cast_nullable_to_non_nullable
              as String?,
      bonusAmount: null == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualStart: freezed == actualStart
          ? _value.actualStart
          : actualStart // ignore: cast_nullable_to_non_nullable
              as String?,
      actualEnd: freezed == actualEnd
          ? _value.actualEnd
          : actualEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmStartTime: freezed == confirmStartTime
          ? _value.confirmStartTime
          : confirmStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmEndTime: freezed == confirmEndTime
          ? _value.confirmEndTime
          : confirmEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      noticeTags: null == noticeTags
          ? _value._noticeTags
          : noticeTags // ignore: cast_nullable_to_non_nullable
              as List<TagDto>,
      problemType: freezed == problemType
          ? _value.problemType
          : problemType // ignore: cast_nullable_to_non_nullable
              as String?,
      isReported: null == isReported
          ? _value.isReported
          : isReported // ignore: cast_nullable_to_non_nullable
              as bool,
      reportReason: freezed == reportReason
          ? _value.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String?,
      isValidCheckinLocation: freezed == isValidCheckinLocation
          ? _value.isValidCheckinLocation
          : isValidCheckinLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkinDistanceFromStore: null == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double,
      isValidCheckoutLocation: freezed == isValidCheckoutLocation
          ? _value.isValidCheckoutLocation
          : isValidCheckoutLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      checkoutDistanceFromStore: null == checkoutDistanceFromStore
          ? _value.checkoutDistanceFromStore
          : checkoutDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftCardDtoImpl implements _ShiftCardDto {
  const _$ShiftCardDtoImpl(
      {@JsonKey(name: 'shift_date') this.shiftDate = '',
      @JsonKey(name: 'shift_request_id') this.shiftRequestId = '',
      @JsonKey(name: 'user_name') this.userName = '',
      @JsonKey(name: 'profile_image') this.profileImage,
      @JsonKey(name: 'shift_name') this.shiftName,
      @JsonKey(name: 'shift_time') @ShiftTimeConverter() this.shiftTime,
      @JsonKey(name: 'is_approved') this.isApproved = false,
      @JsonKey(name: 'is_problem') this.isProblem = false,
      @JsonKey(name: 'is_problem_solved') this.isProblemSolved = false,
      @JsonKey(name: 'is_late') this.isLate = false,
      @JsonKey(name: 'late_minute') this.lateMinute = 0,
      @JsonKey(name: 'is_over_time') this.isOverTime = false,
      @JsonKey(name: 'over_time_minute') this.overTimeMinute = 0,
      @JsonKey(name: 'paid_hour') this.paidHour = 0.0,
      @JsonKey(name: 'salary_type') this.salaryType,
      @JsonKey(name: 'salary_amount') this.salaryAmount,
      @JsonKey(name: 'base_pay') this.basePay,
      @JsonKey(name: 'total_pay_with_bonus') this.totalPayWithBonus,
      @JsonKey(name: 'bonus_amount') this.bonusAmount = 0.0,
      @JsonKey(name: 'actual_start') this.actualStart,
      @JsonKey(name: 'actual_end') this.actualEnd,
      @JsonKey(name: 'confirm_start_time') this.confirmStartTime,
      @JsonKey(name: 'confirm_end_time') this.confirmEndTime,
      @JsonKey(name: 'notice_tag') final List<TagDto> noticeTags = const [],
      @JsonKey(name: 'problem_type') this.problemType,
      @JsonKey(name: 'is_reported') this.isReported = false,
      @JsonKey(name: 'report_reason') this.reportReason,
      @JsonKey(name: 'is_valid_checkin_location') this.isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      this.checkinDistanceFromStore = 0.0,
      @JsonKey(name: 'is_valid_checkout_location') this.isValidCheckoutLocation,
      @JsonKey(name: 'checkout_distance_from_store')
      this.checkoutDistanceFromStore = 0.0,
      @JsonKey(name: 'store_name') this.storeName})
      : _noticeTags = noticeTags;

  factory _$ShiftCardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftCardDtoImplFromJson(json);

// Core identification
// v3: shift_date (actual work date from start_time_utc) instead of request_date
// Made nullable with defaults to handle empty RPC responses
  @override
  @JsonKey(name: 'shift_date')
  final String shiftDate;
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;
// User information
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;
// Shift information
  @override
  @JsonKey(name: 'shift_name')
  final String? shiftName;
  @override
  @JsonKey(name: 'shift_time')
  @ShiftTimeConverter()
  final ShiftTime? shiftTime;
// Approval status
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'is_problem')
  final bool isProblem;
  @override
  @JsonKey(name: 'is_problem_solved')
  final bool isProblemSolved;
// Time tracking
  @override
  @JsonKey(name: 'is_late')
  final bool isLate;
  @override
  @JsonKey(name: 'late_minute')
  final int lateMinute;
  @override
  @JsonKey(name: 'is_over_time')
  final bool isOverTime;
  @override
  @JsonKey(name: 'over_time_minute')
  final int overTimeMinute;
  @override
  @JsonKey(name: 'paid_hour')
  final double paidHour;
// Salary information (NEW in RPC)
  @override
  @JsonKey(name: 'salary_type')
  final String? salaryType;
  @override
  @JsonKey(name: 'salary_amount')
  final String? salaryAmount;
  @override
  @JsonKey(name: 'base_pay')
  final String? basePay;
  @override
  @JsonKey(name: 'total_pay_with_bonus')
  final String? totalPayWithBonus;
// Bonus information
  @override
  @JsonKey(name: 'bonus_amount')
  final double bonusAmount;
// Time records (HH:MM:SS or HH:MM format from RPC)
  @override
  @JsonKey(name: 'actual_start')
  final String? actualStart;
  @override
  @JsonKey(name: 'actual_end')
  final String? actualEnd;
  @override
  @JsonKey(name: 'confirm_start_time')
  final String? confirmStartTime;
  @override
  @JsonKey(name: 'confirm_end_time')
  final String? confirmEndTime;
// Tags (jsonb array in RPC)
  final List<TagDto> _noticeTags;
// Tags (jsonb array in RPC)
  @override
  @JsonKey(name: 'notice_tag')
  List<TagDto> get noticeTags {
    if (_noticeTags is EqualUnmodifiableListView) return _noticeTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_noticeTags);
  }

// Problem details
  @override
  @JsonKey(name: 'problem_type')
  final String? problemType;
  @override
  @JsonKey(name: 'is_reported')
  final bool isReported;
  @override
  @JsonKey(name: 'report_reason')
  final String? reportReason;
// Location validation (NEW in RPC)
  @override
  @JsonKey(name: 'is_valid_checkin_location')
  final bool? isValidCheckinLocation;
  @override
  @JsonKey(name: 'checkin_distance_from_store')
  final double checkinDistanceFromStore;
  @override
  @JsonKey(name: 'is_valid_checkout_location')
  final bool? isValidCheckoutLocation;
  @override
  @JsonKey(name: 'checkout_distance_from_store')
  final double checkoutDistanceFromStore;
// Store information
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;

  @override
  String toString() {
    return 'ShiftCardDto(shiftDate: $shiftDate, shiftRequestId: $shiftRequestId, userName: $userName, profileImage: $profileImage, shiftName: $shiftName, shiftTime: $shiftTime, isApproved: $isApproved, isProblem: $isProblem, isProblemSolved: $isProblemSolved, isLate: $isLate, lateMinute: $lateMinute, isOverTime: $isOverTime, overTimeMinute: $overTimeMinute, paidHour: $paidHour, salaryType: $salaryType, salaryAmount: $salaryAmount, basePay: $basePay, totalPayWithBonus: $totalPayWithBonus, bonusAmount: $bonusAmount, actualStart: $actualStart, actualEnd: $actualEnd, confirmStartTime: $confirmStartTime, confirmEndTime: $confirmEndTime, noticeTags: $noticeTags, problemType: $problemType, isReported: $isReported, reportReason: $reportReason, isValidCheckinLocation: $isValidCheckinLocation, checkinDistanceFromStore: $checkinDistanceFromStore, isValidCheckoutLocation: $isValidCheckoutLocation, checkoutDistanceFromStore: $checkoutDistanceFromStore, storeName: $storeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftCardDtoImpl &&
            (identical(other.shiftDate, shiftDate) ||
                other.shiftDate == shiftDate) &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.shiftTime, shiftTime) ||
                other.shiftTime == shiftTime) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.isProblem, isProblem) ||
                other.isProblem == isProblem) &&
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
            (identical(other.salaryType, salaryType) ||
                other.salaryType == salaryType) &&
            (identical(other.salaryAmount, salaryAmount) ||
                other.salaryAmount == salaryAmount) &&
            (identical(other.basePay, basePay) || other.basePay == basePay) &&
            (identical(other.totalPayWithBonus, totalPayWithBonus) ||
                other.totalPayWithBonus == totalPayWithBonus) &&
            (identical(other.bonusAmount, bonusAmount) ||
                other.bonusAmount == bonusAmount) &&
            (identical(other.actualStart, actualStart) ||
                other.actualStart == actualStart) &&
            (identical(other.actualEnd, actualEnd) ||
                other.actualEnd == actualEnd) &&
            (identical(other.confirmStartTime, confirmStartTime) ||
                other.confirmStartTime == confirmStartTime) &&
            (identical(other.confirmEndTime, confirmEndTime) ||
                other.confirmEndTime == confirmEndTime) &&
            const DeepCollectionEquality()
                .equals(other._noticeTags, _noticeTags) &&
            (identical(other.problemType, problemType) ||
                other.problemType == problemType) &&
            (identical(other.isReported, isReported) ||
                other.isReported == isReported) &&
            (identical(other.reportReason, reportReason) ||
                other.reportReason == reportReason) &&
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
            (identical(other.storeName, storeName) ||
                other.storeName == storeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        shiftDate,
        shiftRequestId,
        userName,
        profileImage,
        shiftName,
        shiftTime,
        isApproved,
        isProblem,
        isProblemSolved,
        isLate,
        lateMinute,
        isOverTime,
        overTimeMinute,
        paidHour,
        salaryType,
        salaryAmount,
        basePay,
        totalPayWithBonus,
        bonusAmount,
        actualStart,
        actualEnd,
        confirmStartTime,
        confirmEndTime,
        const DeepCollectionEquality().hash(_noticeTags),
        problemType,
        isReported,
        reportReason,
        isValidCheckinLocation,
        checkinDistanceFromStore,
        isValidCheckoutLocation,
        checkoutDistanceFromStore,
        storeName
      ]);

  /// Create a copy of ShiftCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftCardDtoImplCopyWith<_$ShiftCardDtoImpl> get copyWith =>
      __$$ShiftCardDtoImplCopyWithImpl<_$ShiftCardDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftCardDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftCardDto implements ShiftCardDto {
  const factory _ShiftCardDto(
      {@JsonKey(name: 'shift_date') final String shiftDate,
      @JsonKey(name: 'shift_request_id') final String shiftRequestId,
      @JsonKey(name: 'user_name') final String userName,
      @JsonKey(name: 'profile_image') final String? profileImage,
      @JsonKey(name: 'shift_name') final String? shiftName,
      @JsonKey(name: 'shift_time')
      @ShiftTimeConverter()
      final ShiftTime? shiftTime,
      @JsonKey(name: 'is_approved') final bool isApproved,
      @JsonKey(name: 'is_problem') final bool isProblem,
      @JsonKey(name: 'is_problem_solved') final bool isProblemSolved,
      @JsonKey(name: 'is_late') final bool isLate,
      @JsonKey(name: 'late_minute') final int lateMinute,
      @JsonKey(name: 'is_over_time') final bool isOverTime,
      @JsonKey(name: 'over_time_minute') final int overTimeMinute,
      @JsonKey(name: 'paid_hour') final double paidHour,
      @JsonKey(name: 'salary_type') final String? salaryType,
      @JsonKey(name: 'salary_amount') final String? salaryAmount,
      @JsonKey(name: 'base_pay') final String? basePay,
      @JsonKey(name: 'total_pay_with_bonus') final String? totalPayWithBonus,
      @JsonKey(name: 'bonus_amount') final double bonusAmount,
      @JsonKey(name: 'actual_start') final String? actualStart,
      @JsonKey(name: 'actual_end') final String? actualEnd,
      @JsonKey(name: 'confirm_start_time') final String? confirmStartTime,
      @JsonKey(name: 'confirm_end_time') final String? confirmEndTime,
      @JsonKey(name: 'notice_tag') final List<TagDto> noticeTags,
      @JsonKey(name: 'problem_type') final String? problemType,
      @JsonKey(name: 'is_reported') final bool isReported,
      @JsonKey(name: 'report_reason') final String? reportReason,
      @JsonKey(name: 'is_valid_checkin_location')
      final bool? isValidCheckinLocation,
      @JsonKey(name: 'checkin_distance_from_store')
      final double checkinDistanceFromStore,
      @JsonKey(name: 'is_valid_checkout_location')
      final bool? isValidCheckoutLocation,
      @JsonKey(name: 'checkout_distance_from_store')
      final double checkoutDistanceFromStore,
      @JsonKey(name: 'store_name')
      final String? storeName}) = _$ShiftCardDtoImpl;

  factory _ShiftCardDto.fromJson(Map<String, dynamic> json) =
      _$ShiftCardDtoImpl.fromJson;

// Core identification
// v3: shift_date (actual work date from start_time_utc) instead of request_date
// Made nullable with defaults to handle empty RPC responses
  @override
  @JsonKey(name: 'shift_date')
  String get shiftDate;
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId; // User information
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage; // Shift information
  @override
  @JsonKey(name: 'shift_name')
  String? get shiftName;
  @override
  @JsonKey(name: 'shift_time')
  @ShiftTimeConverter()
  ShiftTime? get shiftTime; // Approval status
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'is_problem')
  bool get isProblem;
  @override
  @JsonKey(name: 'is_problem_solved')
  bool get isProblemSolved; // Time tracking
  @override
  @JsonKey(name: 'is_late')
  bool get isLate;
  @override
  @JsonKey(name: 'late_minute')
  int get lateMinute;
  @override
  @JsonKey(name: 'is_over_time')
  bool get isOverTime;
  @override
  @JsonKey(name: 'over_time_minute')
  int get overTimeMinute;
  @override
  @JsonKey(name: 'paid_hour')
  double get paidHour; // Salary information (NEW in RPC)
  @override
  @JsonKey(name: 'salary_type')
  String? get salaryType;
  @override
  @JsonKey(name: 'salary_amount')
  String? get salaryAmount;
  @override
  @JsonKey(name: 'base_pay')
  String? get basePay;
  @override
  @JsonKey(name: 'total_pay_with_bonus')
  String? get totalPayWithBonus; // Bonus information
  @override
  @JsonKey(name: 'bonus_amount')
  double get bonusAmount; // Time records (HH:MM:SS or HH:MM format from RPC)
  @override
  @JsonKey(name: 'actual_start')
  String? get actualStart;
  @override
  @JsonKey(name: 'actual_end')
  String? get actualEnd;
  @override
  @JsonKey(name: 'confirm_start_time')
  String? get confirmStartTime;
  @override
  @JsonKey(name: 'confirm_end_time')
  String? get confirmEndTime; // Tags (jsonb array in RPC)
  @override
  @JsonKey(name: 'notice_tag')
  List<TagDto> get noticeTags; // Problem details
  @override
  @JsonKey(name: 'problem_type')
  String? get problemType;
  @override
  @JsonKey(name: 'is_reported')
  bool get isReported;
  @override
  @JsonKey(name: 'report_reason')
  String? get reportReason; // Location validation (NEW in RPC)
  @override
  @JsonKey(name: 'is_valid_checkin_location')
  bool? get isValidCheckinLocation;
  @override
  @JsonKey(name: 'checkin_distance_from_store')
  double get checkinDistanceFromStore;
  @override
  @JsonKey(name: 'is_valid_checkout_location')
  bool? get isValidCheckoutLocation;
  @override
  @JsonKey(name: 'checkout_distance_from_store')
  double get checkoutDistanceFromStore; // Store information
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;

  /// Create a copy of ShiftCardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftCardDtoImplCopyWith<_$ShiftCardDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TagDto _$TagDtoFromJson(Map<String, dynamic> json) {
  return _TagDto.fromJson(json);
}

/// @nodoc
mixin _$TagDto {
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'content')
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by_name')
  String? get createdByName => throw _privateConstructorUsedError;

  /// Serializes this TagDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TagDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TagDtoCopyWith<TagDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagDtoCopyWith<$Res> {
  factory $TagDtoCopyWith(TagDto value, $Res Function(TagDto) then) =
      _$TagDtoCopyWithImpl<$Res, TagDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'type') String? type,
      @JsonKey(name: 'content') String? content,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_by_name') String? createdByName});
}

/// @nodoc
class _$TagDtoCopyWithImpl<$Res, $Val extends TagDto>
    implements $TagDtoCopyWith<$Res> {
  _$TagDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TagDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
    Object? createdByName = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByName: freezed == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagDtoImplCopyWith<$Res> implements $TagDtoCopyWith<$Res> {
  factory _$$TagDtoImplCopyWith(
          _$TagDtoImpl value, $Res Function(_$TagDtoImpl) then) =
      __$$TagDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'type') String? type,
      @JsonKey(name: 'content') String? content,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_by_name') String? createdByName});
}

/// @nodoc
class __$$TagDtoImplCopyWithImpl<$Res>
    extends _$TagDtoCopyWithImpl<$Res, _$TagDtoImpl>
    implements _$$TagDtoImplCopyWith<$Res> {
  __$$TagDtoImplCopyWithImpl(
      _$TagDtoImpl _value, $Res Function(_$TagDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TagDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
    Object? createdByName = freezed,
  }) {
    return _then(_$TagDtoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByName: freezed == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TagDtoImpl implements _TagDto {
  const _$TagDtoImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'type') this.type,
      @JsonKey(name: 'content') this.content,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_by_name') this.createdByName});

  factory _$TagDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'type')
  final String? type;
  @override
  @JsonKey(name: 'content')
  final String? content;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'created_by_name')
  final String? createdByName;

  @override
  String toString() {
    return 'TagDto(id: $id, type: $type, content: $content, createdAt: $createdAt, createdBy: $createdBy, createdByName: $createdByName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, content, createdAt, createdBy, createdByName);

  /// Create a copy of TagDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TagDtoImplCopyWith<_$TagDtoImpl> get copyWith =>
      __$$TagDtoImplCopyWithImpl<_$TagDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagDtoImplToJson(
      this,
    );
  }
}

abstract class _TagDto implements TagDto {
  const factory _TagDto(
          {@JsonKey(name: 'id') final String? id,
          @JsonKey(name: 'type') final String? type,
          @JsonKey(name: 'content') final String? content,
          @JsonKey(name: 'created_at') final String? createdAt,
          @JsonKey(name: 'created_by') final String? createdBy,
          @JsonKey(name: 'created_by_name') final String? createdByName}) =
      _$TagDtoImpl;

  factory _TagDto.fromJson(Map<String, dynamic> json) = _$TagDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'type')
  String? get type;
  @override
  @JsonKey(name: 'content')
  String? get content;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'created_by_name')
  String? get createdByName;

  /// Create a copy of TagDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TagDtoImplCopyWith<_$TagDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
