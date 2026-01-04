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
  @JsonKey(name: 'shift_date')
  String get shiftDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId =>
      throw _privateConstructorUsedError; // User information
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage =>
      throw _privateConstructorUsedError; // Shift information
  @JsonKey(name: 'shift_name')
  String? get shiftName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_time')
  @ShiftTimeConverter()
  ShiftTime? get shiftTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_start_time')
  String? get shiftStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_end_time')
  String? get shiftEndTime =>
      throw _privateConstructorUsedError; // Approval status
  @JsonKey(name: 'is_approved')
  bool get isApproved =>
      throw _privateConstructorUsedError; // Salary information
  @JsonKey(name: 'paid_hour')
  double get paidHour => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_type')
  String? get salaryType => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_amount')
  String? get salaryAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_pay')
  String? get basePay => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pay_with_bonus')
  String? get totalPayWithBonus => throw _privateConstructorUsedError;
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
      throw _privateConstructorUsedError; // Manager memos (jsonb array)
  @JsonKey(name: 'manager_memo')
  List<ManagerMemoDto> get managerMemos =>
      throw _privateConstructorUsedError; // problem_details: Single Source of Truth for all problem info
  @JsonKey(name: 'problem_details')
  ProblemDetailsDto? get problemDetails =>
      throw _privateConstructorUsedError; // Location distances (values only, not validation booleans)
  @JsonKey(name: 'checkin_distance_from_store')
  double get checkinDistanceFromStore => throw _privateConstructorUsedError;
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
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'shift_time') @ShiftTimeConverter() ShiftTime? shiftTime,
      @JsonKey(name: 'shift_start_time') String? shiftStartTime,
      @JsonKey(name: 'shift_end_time') String? shiftEndTime,
      @JsonKey(name: 'is_approved') bool isApproved,
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
      @JsonKey(name: 'manager_memo') List<ManagerMemoDto> managerMemos,
      @JsonKey(name: 'problem_details') ProblemDetailsDto? problemDetails,
      @JsonKey(name: 'checkin_distance_from_store')
      double checkinDistanceFromStore,
      @JsonKey(name: 'checkout_distance_from_store')
      double checkoutDistanceFromStore,
      @JsonKey(name: 'store_name') String? storeName});

  $ProblemDetailsDtoCopyWith<$Res>? get problemDetails;
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
    Object? userId = null,
    Object? userName = null,
    Object? profileImage = freezed,
    Object? shiftName = freezed,
    Object? shiftTime = freezed,
    Object? shiftStartTime = freezed,
    Object? shiftEndTime = freezed,
    Object? isApproved = null,
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
    Object? managerMemos = null,
    Object? problemDetails = freezed,
    Object? checkinDistanceFromStore = null,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
      shiftStartTime: freezed == shiftStartTime
          ? _value.shiftStartTime
          : shiftStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftEndTime: freezed == shiftEndTime
          ? _value.shiftEndTime
          : shiftEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
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
      managerMemos: null == managerMemos
          ? _value.managerMemos
          : managerMemos // ignore: cast_nullable_to_non_nullable
              as List<ManagerMemoDto>,
      problemDetails: freezed == problemDetails
          ? _value.problemDetails
          : problemDetails // ignore: cast_nullable_to_non_nullable
              as ProblemDetailsDto?,
      checkinDistanceFromStore: null == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double,
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

  /// Create a copy of ShiftCardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProblemDetailsDtoCopyWith<$Res>? get problemDetails {
    if (_value.problemDetails == null) {
      return null;
    }

    return $ProblemDetailsDtoCopyWith<$Res>(_value.problemDetails!, (value) {
      return _then(_value.copyWith(problemDetails: value) as $Val);
    });
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
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'shift_time') @ShiftTimeConverter() ShiftTime? shiftTime,
      @JsonKey(name: 'shift_start_time') String? shiftStartTime,
      @JsonKey(name: 'shift_end_time') String? shiftEndTime,
      @JsonKey(name: 'is_approved') bool isApproved,
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
      @JsonKey(name: 'manager_memo') List<ManagerMemoDto> managerMemos,
      @JsonKey(name: 'problem_details') ProblemDetailsDto? problemDetails,
      @JsonKey(name: 'checkin_distance_from_store')
      double checkinDistanceFromStore,
      @JsonKey(name: 'checkout_distance_from_store')
      double checkoutDistanceFromStore,
      @JsonKey(name: 'store_name') String? storeName});

  @override
  $ProblemDetailsDtoCopyWith<$Res>? get problemDetails;
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
    Object? userId = null,
    Object? userName = null,
    Object? profileImage = freezed,
    Object? shiftName = freezed,
    Object? shiftTime = freezed,
    Object? shiftStartTime = freezed,
    Object? shiftEndTime = freezed,
    Object? isApproved = null,
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
    Object? managerMemos = null,
    Object? problemDetails = freezed,
    Object? checkinDistanceFromStore = null,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
      shiftStartTime: freezed == shiftStartTime
          ? _value.shiftStartTime
          : shiftStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftEndTime: freezed == shiftEndTime
          ? _value.shiftEndTime
          : shiftEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
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
      managerMemos: null == managerMemos
          ? _value._managerMemos
          : managerMemos // ignore: cast_nullable_to_non_nullable
              as List<ManagerMemoDto>,
      problemDetails: freezed == problemDetails
          ? _value.problemDetails
          : problemDetails // ignore: cast_nullable_to_non_nullable
              as ProblemDetailsDto?,
      checkinDistanceFromStore: null == checkinDistanceFromStore
          ? _value.checkinDistanceFromStore
          : checkinDistanceFromStore // ignore: cast_nullable_to_non_nullable
              as double,
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
      @JsonKey(name: 'user_id') this.userId = '',
      @JsonKey(name: 'user_name') this.userName = '',
      @JsonKey(name: 'profile_image') this.profileImage,
      @JsonKey(name: 'shift_name') this.shiftName,
      @JsonKey(name: 'shift_time') @ShiftTimeConverter() this.shiftTime,
      @JsonKey(name: 'shift_start_time') this.shiftStartTime,
      @JsonKey(name: 'shift_end_time') this.shiftEndTime,
      @JsonKey(name: 'is_approved') this.isApproved = false,
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
      @JsonKey(name: 'manager_memo')
      final List<ManagerMemoDto> managerMemos = const [],
      @JsonKey(name: 'problem_details') this.problemDetails,
      @JsonKey(name: 'checkin_distance_from_store')
      this.checkinDistanceFromStore = 0.0,
      @JsonKey(name: 'checkout_distance_from_store')
      this.checkoutDistanceFromStore = 0.0,
      @JsonKey(name: 'store_name') this.storeName})
      : _noticeTags = noticeTags,
        _managerMemos = managerMemos;

  factory _$ShiftCardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftCardDtoImplFromJson(json);

// Core identification
  @override
  @JsonKey(name: 'shift_date')
  final String shiftDate;
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;
// User information
  @override
  @JsonKey(name: 'user_id')
  final String userId;
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
  @override
  @JsonKey(name: 'shift_start_time')
  final String? shiftStartTime;
  @override
  @JsonKey(name: 'shift_end_time')
  final String? shiftEndTime;
// Approval status
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
// Salary information
  @override
  @JsonKey(name: 'paid_hour')
  final double paidHour;
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

// Manager memos (jsonb array)
  final List<ManagerMemoDto> _managerMemos;
// Manager memos (jsonb array)
  @override
  @JsonKey(name: 'manager_memo')
  List<ManagerMemoDto> get managerMemos {
    if (_managerMemos is EqualUnmodifiableListView) return _managerMemos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_managerMemos);
  }

// problem_details: Single Source of Truth for all problem info
  @override
  @JsonKey(name: 'problem_details')
  final ProblemDetailsDto? problemDetails;
// Location distances (values only, not validation booleans)
  @override
  @JsonKey(name: 'checkin_distance_from_store')
  final double checkinDistanceFromStore;
  @override
  @JsonKey(name: 'checkout_distance_from_store')
  final double checkoutDistanceFromStore;
// Store information
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;

  @override
  String toString() {
    return 'ShiftCardDto(shiftDate: $shiftDate, shiftRequestId: $shiftRequestId, userId: $userId, userName: $userName, profileImage: $profileImage, shiftName: $shiftName, shiftTime: $shiftTime, shiftStartTime: $shiftStartTime, shiftEndTime: $shiftEndTime, isApproved: $isApproved, paidHour: $paidHour, salaryType: $salaryType, salaryAmount: $salaryAmount, basePay: $basePay, totalPayWithBonus: $totalPayWithBonus, bonusAmount: $bonusAmount, actualStart: $actualStart, actualEnd: $actualEnd, confirmStartTime: $confirmStartTime, confirmEndTime: $confirmEndTime, noticeTags: $noticeTags, managerMemos: $managerMemos, problemDetails: $problemDetails, checkinDistanceFromStore: $checkinDistanceFromStore, checkoutDistanceFromStore: $checkoutDistanceFromStore, storeName: $storeName)';
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
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.shiftTime, shiftTime) ||
                other.shiftTime == shiftTime) &&
            (identical(other.shiftStartTime, shiftStartTime) ||
                other.shiftStartTime == shiftStartTime) &&
            (identical(other.shiftEndTime, shiftEndTime) ||
                other.shiftEndTime == shiftEndTime) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
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
            const DeepCollectionEquality()
                .equals(other._managerMemos, _managerMemos) &&
            (identical(other.problemDetails, problemDetails) ||
                other.problemDetails == problemDetails) &&
            (identical(
                    other.checkinDistanceFromStore, checkinDistanceFromStore) ||
                other.checkinDistanceFromStore == checkinDistanceFromStore) &&
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
        userId,
        userName,
        profileImage,
        shiftName,
        shiftTime,
        shiftStartTime,
        shiftEndTime,
        isApproved,
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
        const DeepCollectionEquality().hash(_managerMemos),
        problemDetails,
        checkinDistanceFromStore,
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
      @JsonKey(name: 'user_id') final String userId,
      @JsonKey(name: 'user_name') final String userName,
      @JsonKey(name: 'profile_image') final String? profileImage,
      @JsonKey(name: 'shift_name') final String? shiftName,
      @JsonKey(name: 'shift_time')
      @ShiftTimeConverter()
      final ShiftTime? shiftTime,
      @JsonKey(name: 'shift_start_time') final String? shiftStartTime,
      @JsonKey(name: 'shift_end_time') final String? shiftEndTime,
      @JsonKey(name: 'is_approved') final bool isApproved,
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
      @JsonKey(name: 'manager_memo') final List<ManagerMemoDto> managerMemos,
      @JsonKey(name: 'problem_details') final ProblemDetailsDto? problemDetails,
      @JsonKey(name: 'checkin_distance_from_store')
      final double checkinDistanceFromStore,
      @JsonKey(name: 'checkout_distance_from_store')
      final double checkoutDistanceFromStore,
      @JsonKey(name: 'store_name')
      final String? storeName}) = _$ShiftCardDtoImpl;

  factory _ShiftCardDto.fromJson(Map<String, dynamic> json) =
      _$ShiftCardDtoImpl.fromJson;

// Core identification
  @override
  @JsonKey(name: 'shift_date')
  String get shiftDate;
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId; // User information
  @override
  @JsonKey(name: 'user_id')
  String get userId;
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
  ShiftTime? get shiftTime;
  @override
  @JsonKey(name: 'shift_start_time')
  String? get shiftStartTime;
  @override
  @JsonKey(name: 'shift_end_time')
  String? get shiftEndTime; // Approval status
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved; // Salary information
  @override
  @JsonKey(name: 'paid_hour')
  double get paidHour;
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
  String? get totalPayWithBonus;
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
  List<TagDto> get noticeTags; // Manager memos (jsonb array)
  @override
  @JsonKey(name: 'manager_memo')
  List<ManagerMemoDto>
      get managerMemos; // problem_details: Single Source of Truth for all problem info
  @override
  @JsonKey(name: 'problem_details')
  ProblemDetailsDto?
      get problemDetails; // Location distances (values only, not validation booleans)
  @override
  @JsonKey(name: 'checkin_distance_from_store')
  double get checkinDistanceFromStore;
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

ManagerMemoDto _$ManagerMemoDtoFromJson(Map<String, dynamic> json) {
  return _ManagerMemoDto.fromJson(json);
}

/// @nodoc
mixin _$ManagerMemoDto {
  @JsonKey(name: 'type')
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'content')
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;

  /// Serializes this ManagerMemoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerMemoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerMemoDtoCopyWith<ManagerMemoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerMemoDtoCopyWith<$Res> {
  factory $ManagerMemoDtoCopyWith(
          ManagerMemoDto value, $Res Function(ManagerMemoDto) then) =
      _$ManagerMemoDtoCopyWithImpl<$Res, ManagerMemoDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String? type,
      @JsonKey(name: 'content') String? content,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'created_by') String? createdBy});
}

/// @nodoc
class _$ManagerMemoDtoCopyWithImpl<$Res, $Val extends ManagerMemoDto>
    implements $ManagerMemoDtoCopyWith<$Res> {
  _$ManagerMemoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerMemoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerMemoDtoImplCopyWith<$Res>
    implements $ManagerMemoDtoCopyWith<$Res> {
  factory _$$ManagerMemoDtoImplCopyWith(_$ManagerMemoDtoImpl value,
          $Res Function(_$ManagerMemoDtoImpl) then) =
      __$$ManagerMemoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String? type,
      @JsonKey(name: 'content') String? content,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'created_by') String? createdBy});
}

/// @nodoc
class __$$ManagerMemoDtoImplCopyWithImpl<$Res>
    extends _$ManagerMemoDtoCopyWithImpl<$Res, _$ManagerMemoDtoImpl>
    implements _$$ManagerMemoDtoImplCopyWith<$Res> {
  __$$ManagerMemoDtoImplCopyWithImpl(
      _$ManagerMemoDtoImpl _value, $Res Function(_$ManagerMemoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerMemoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$ManagerMemoDtoImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerMemoDtoImpl implements _ManagerMemoDto {
  const _$ManagerMemoDtoImpl(
      {@JsonKey(name: 'type') this.type,
      @JsonKey(name: 'content') this.content,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'created_by') this.createdBy});

  factory _$ManagerMemoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerMemoDtoImplFromJson(json);

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
  String toString() {
    return 'ManagerMemoDto(type: $type, content: $content, createdAt: $createdAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerMemoDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, content, createdAt, createdBy);

  /// Create a copy of ManagerMemoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerMemoDtoImplCopyWith<_$ManagerMemoDtoImpl> get copyWith =>
      __$$ManagerMemoDtoImplCopyWithImpl<_$ManagerMemoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerMemoDtoImplToJson(
      this,
    );
  }
}

abstract class _ManagerMemoDto implements ManagerMemoDto {
  const factory _ManagerMemoDto(
          {@JsonKey(name: 'type') final String? type,
          @JsonKey(name: 'content') final String? content,
          @JsonKey(name: 'created_at') final String? createdAt,
          @JsonKey(name: 'created_by') final String? createdBy}) =
      _$ManagerMemoDtoImpl;

  factory _ManagerMemoDto.fromJson(Map<String, dynamic> json) =
      _$ManagerMemoDtoImpl.fromJson;

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

  /// Create a copy of ManagerMemoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerMemoDtoImplCopyWith<_$ManagerMemoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProblemDetailsDto _$ProblemDetailsDtoFromJson(Map<String, dynamic> json) {
  return _ProblemDetailsDto.fromJson(json);
}

/// @nodoc
mixin _$ProblemDetailsDto {
  @JsonKey(name: 'has_late')
  bool get hasLate => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_overtime')
  bool get hasOvertime => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_reported')
  bool get hasReported => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_no_checkout')
  bool get hasNoCheckout => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_absence')
  bool get hasAbsence => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_early_leave')
  bool get hasEarlyLeave => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_location_issue')
  bool get hasLocationIssue => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_payroll_late')
  bool get hasPayrollLate => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_payroll_overtime')
  bool get hasPayrollOvertime => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_payroll_early_leave')
  bool get hasPayrollEarlyLeave => throw _privateConstructorUsedError;
  @JsonKey(name: 'problem_count')
  int get problemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_solved')
  bool get isSolved => throw _privateConstructorUsedError;
  @JsonKey(name: 'detected_at')
  String? get detectedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'problems')
  List<ProblemItemDto> get problems => throw _privateConstructorUsedError;

  /// Serializes this ProblemDetailsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProblemDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProblemDetailsDtoCopyWith<ProblemDetailsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProblemDetailsDtoCopyWith<$Res> {
  factory $ProblemDetailsDtoCopyWith(
          ProblemDetailsDto value, $Res Function(ProblemDetailsDto) then) =
      _$ProblemDetailsDtoCopyWithImpl<$Res, ProblemDetailsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'has_late') bool hasLate,
      @JsonKey(name: 'has_overtime') bool hasOvertime,
      @JsonKey(name: 'has_reported') bool hasReported,
      @JsonKey(name: 'has_no_checkout') bool hasNoCheckout,
      @JsonKey(name: 'has_absence') bool hasAbsence,
      @JsonKey(name: 'has_early_leave') bool hasEarlyLeave,
      @JsonKey(name: 'has_location_issue') bool hasLocationIssue,
      @JsonKey(name: 'has_payroll_late') bool hasPayrollLate,
      @JsonKey(name: 'has_payroll_overtime') bool hasPayrollOvertime,
      @JsonKey(name: 'has_payroll_early_leave') bool hasPayrollEarlyLeave,
      @JsonKey(name: 'problem_count') int problemCount,
      @JsonKey(name: 'is_solved') bool isSolved,
      @JsonKey(name: 'detected_at') String? detectedAt,
      @JsonKey(name: 'problems') List<ProblemItemDto> problems});
}

/// @nodoc
class _$ProblemDetailsDtoCopyWithImpl<$Res, $Val extends ProblemDetailsDto>
    implements $ProblemDetailsDtoCopyWith<$Res> {
  _$ProblemDetailsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProblemDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasLate = null,
    Object? hasOvertime = null,
    Object? hasReported = null,
    Object? hasNoCheckout = null,
    Object? hasAbsence = null,
    Object? hasEarlyLeave = null,
    Object? hasLocationIssue = null,
    Object? hasPayrollLate = null,
    Object? hasPayrollOvertime = null,
    Object? hasPayrollEarlyLeave = null,
    Object? problemCount = null,
    Object? isSolved = null,
    Object? detectedAt = freezed,
    Object? problems = null,
  }) {
    return _then(_value.copyWith(
      hasLate: null == hasLate
          ? _value.hasLate
          : hasLate // ignore: cast_nullable_to_non_nullable
              as bool,
      hasOvertime: null == hasOvertime
          ? _value.hasOvertime
          : hasOvertime // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReported: null == hasReported
          ? _value.hasReported
          : hasReported // ignore: cast_nullable_to_non_nullable
              as bool,
      hasNoCheckout: null == hasNoCheckout
          ? _value.hasNoCheckout
          : hasNoCheckout // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAbsence: null == hasAbsence
          ? _value.hasAbsence
          : hasAbsence // ignore: cast_nullable_to_non_nullable
              as bool,
      hasEarlyLeave: null == hasEarlyLeave
          ? _value.hasEarlyLeave
          : hasEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocationIssue: null == hasLocationIssue
          ? _value.hasLocationIssue
          : hasLocationIssue // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPayrollLate: null == hasPayrollLate
          ? _value.hasPayrollLate
          : hasPayrollLate // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPayrollOvertime: null == hasPayrollOvertime
          ? _value.hasPayrollOvertime
          : hasPayrollOvertime // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPayrollEarlyLeave: null == hasPayrollEarlyLeave
          ? _value.hasPayrollEarlyLeave
          : hasPayrollEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      problemCount: null == problemCount
          ? _value.problemCount
          : problemCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSolved: null == isSolved
          ? _value.isSolved
          : isSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      detectedAt: freezed == detectedAt
          ? _value.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      problems: null == problems
          ? _value.problems
          : problems // ignore: cast_nullable_to_non_nullable
              as List<ProblemItemDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProblemDetailsDtoImplCopyWith<$Res>
    implements $ProblemDetailsDtoCopyWith<$Res> {
  factory _$$ProblemDetailsDtoImplCopyWith(_$ProblemDetailsDtoImpl value,
          $Res Function(_$ProblemDetailsDtoImpl) then) =
      __$$ProblemDetailsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'has_late') bool hasLate,
      @JsonKey(name: 'has_overtime') bool hasOvertime,
      @JsonKey(name: 'has_reported') bool hasReported,
      @JsonKey(name: 'has_no_checkout') bool hasNoCheckout,
      @JsonKey(name: 'has_absence') bool hasAbsence,
      @JsonKey(name: 'has_early_leave') bool hasEarlyLeave,
      @JsonKey(name: 'has_location_issue') bool hasLocationIssue,
      @JsonKey(name: 'has_payroll_late') bool hasPayrollLate,
      @JsonKey(name: 'has_payroll_overtime') bool hasPayrollOvertime,
      @JsonKey(name: 'has_payroll_early_leave') bool hasPayrollEarlyLeave,
      @JsonKey(name: 'problem_count') int problemCount,
      @JsonKey(name: 'is_solved') bool isSolved,
      @JsonKey(name: 'detected_at') String? detectedAt,
      @JsonKey(name: 'problems') List<ProblemItemDto> problems});
}

/// @nodoc
class __$$ProblemDetailsDtoImplCopyWithImpl<$Res>
    extends _$ProblemDetailsDtoCopyWithImpl<$Res, _$ProblemDetailsDtoImpl>
    implements _$$ProblemDetailsDtoImplCopyWith<$Res> {
  __$$ProblemDetailsDtoImplCopyWithImpl(_$ProblemDetailsDtoImpl _value,
      $Res Function(_$ProblemDetailsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProblemDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasLate = null,
    Object? hasOvertime = null,
    Object? hasReported = null,
    Object? hasNoCheckout = null,
    Object? hasAbsence = null,
    Object? hasEarlyLeave = null,
    Object? hasLocationIssue = null,
    Object? hasPayrollLate = null,
    Object? hasPayrollOvertime = null,
    Object? hasPayrollEarlyLeave = null,
    Object? problemCount = null,
    Object? isSolved = null,
    Object? detectedAt = freezed,
    Object? problems = null,
  }) {
    return _then(_$ProblemDetailsDtoImpl(
      hasLate: null == hasLate
          ? _value.hasLate
          : hasLate // ignore: cast_nullable_to_non_nullable
              as bool,
      hasOvertime: null == hasOvertime
          ? _value.hasOvertime
          : hasOvertime // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReported: null == hasReported
          ? _value.hasReported
          : hasReported // ignore: cast_nullable_to_non_nullable
              as bool,
      hasNoCheckout: null == hasNoCheckout
          ? _value.hasNoCheckout
          : hasNoCheckout // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAbsence: null == hasAbsence
          ? _value.hasAbsence
          : hasAbsence // ignore: cast_nullable_to_non_nullable
              as bool,
      hasEarlyLeave: null == hasEarlyLeave
          ? _value.hasEarlyLeave
          : hasEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocationIssue: null == hasLocationIssue
          ? _value.hasLocationIssue
          : hasLocationIssue // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPayrollLate: null == hasPayrollLate
          ? _value.hasPayrollLate
          : hasPayrollLate // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPayrollOvertime: null == hasPayrollOvertime
          ? _value.hasPayrollOvertime
          : hasPayrollOvertime // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPayrollEarlyLeave: null == hasPayrollEarlyLeave
          ? _value.hasPayrollEarlyLeave
          : hasPayrollEarlyLeave // ignore: cast_nullable_to_non_nullable
              as bool,
      problemCount: null == problemCount
          ? _value.problemCount
          : problemCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSolved: null == isSolved
          ? _value.isSolved
          : isSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      detectedAt: freezed == detectedAt
          ? _value.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      problems: null == problems
          ? _value._problems
          : problems // ignore: cast_nullable_to_non_nullable
              as List<ProblemItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProblemDetailsDtoImpl implements _ProblemDetailsDto {
  const _$ProblemDetailsDtoImpl(
      {@JsonKey(name: 'has_late') this.hasLate = false,
      @JsonKey(name: 'has_overtime') this.hasOvertime = false,
      @JsonKey(name: 'has_reported') this.hasReported = false,
      @JsonKey(name: 'has_no_checkout') this.hasNoCheckout = false,
      @JsonKey(name: 'has_absence') this.hasAbsence = false,
      @JsonKey(name: 'has_early_leave') this.hasEarlyLeave = false,
      @JsonKey(name: 'has_location_issue') this.hasLocationIssue = false,
      @JsonKey(name: 'has_payroll_late') this.hasPayrollLate = false,
      @JsonKey(name: 'has_payroll_overtime') this.hasPayrollOvertime = false,
      @JsonKey(name: 'has_payroll_early_leave')
      this.hasPayrollEarlyLeave = false,
      @JsonKey(name: 'problem_count') this.problemCount = 0,
      @JsonKey(name: 'is_solved') this.isSolved = false,
      @JsonKey(name: 'detected_at') this.detectedAt,
      @JsonKey(name: 'problems')
      final List<ProblemItemDto> problems = const []})
      : _problems = problems;

  factory _$ProblemDetailsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProblemDetailsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'has_late')
  final bool hasLate;
  @override
  @JsonKey(name: 'has_overtime')
  final bool hasOvertime;
  @override
  @JsonKey(name: 'has_reported')
  final bool hasReported;
  @override
  @JsonKey(name: 'has_no_checkout')
  final bool hasNoCheckout;
  @override
  @JsonKey(name: 'has_absence')
  final bool hasAbsence;
  @override
  @JsonKey(name: 'has_early_leave')
  final bool hasEarlyLeave;
  @override
  @JsonKey(name: 'has_location_issue')
  final bool hasLocationIssue;
  @override
  @JsonKey(name: 'has_payroll_late')
  final bool hasPayrollLate;
  @override
  @JsonKey(name: 'has_payroll_overtime')
  final bool hasPayrollOvertime;
  @override
  @JsonKey(name: 'has_payroll_early_leave')
  final bool hasPayrollEarlyLeave;
  @override
  @JsonKey(name: 'problem_count')
  final int problemCount;
  @override
  @JsonKey(name: 'is_solved')
  final bool isSolved;
  @override
  @JsonKey(name: 'detected_at')
  final String? detectedAt;
  final List<ProblemItemDto> _problems;
  @override
  @JsonKey(name: 'problems')
  List<ProblemItemDto> get problems {
    if (_problems is EqualUnmodifiableListView) return _problems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_problems);
  }

  @override
  String toString() {
    return 'ProblemDetailsDto(hasLate: $hasLate, hasOvertime: $hasOvertime, hasReported: $hasReported, hasNoCheckout: $hasNoCheckout, hasAbsence: $hasAbsence, hasEarlyLeave: $hasEarlyLeave, hasLocationIssue: $hasLocationIssue, hasPayrollLate: $hasPayrollLate, hasPayrollOvertime: $hasPayrollOvertime, hasPayrollEarlyLeave: $hasPayrollEarlyLeave, problemCount: $problemCount, isSolved: $isSolved, detectedAt: $detectedAt, problems: $problems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProblemDetailsDtoImpl &&
            (identical(other.hasLate, hasLate) || other.hasLate == hasLate) &&
            (identical(other.hasOvertime, hasOvertime) ||
                other.hasOvertime == hasOvertime) &&
            (identical(other.hasReported, hasReported) ||
                other.hasReported == hasReported) &&
            (identical(other.hasNoCheckout, hasNoCheckout) ||
                other.hasNoCheckout == hasNoCheckout) &&
            (identical(other.hasAbsence, hasAbsence) ||
                other.hasAbsence == hasAbsence) &&
            (identical(other.hasEarlyLeave, hasEarlyLeave) ||
                other.hasEarlyLeave == hasEarlyLeave) &&
            (identical(other.hasLocationIssue, hasLocationIssue) ||
                other.hasLocationIssue == hasLocationIssue) &&
            (identical(other.hasPayrollLate, hasPayrollLate) ||
                other.hasPayrollLate == hasPayrollLate) &&
            (identical(other.hasPayrollOvertime, hasPayrollOvertime) ||
                other.hasPayrollOvertime == hasPayrollOvertime) &&
            (identical(other.hasPayrollEarlyLeave, hasPayrollEarlyLeave) ||
                other.hasPayrollEarlyLeave == hasPayrollEarlyLeave) &&
            (identical(other.problemCount, problemCount) ||
                other.problemCount == problemCount) &&
            (identical(other.isSolved, isSolved) ||
                other.isSolved == isSolved) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt) &&
            const DeepCollectionEquality().equals(other._problems, _problems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hasLate,
      hasOvertime,
      hasReported,
      hasNoCheckout,
      hasAbsence,
      hasEarlyLeave,
      hasLocationIssue,
      hasPayrollLate,
      hasPayrollOvertime,
      hasPayrollEarlyLeave,
      problemCount,
      isSolved,
      detectedAt,
      const DeepCollectionEquality().hash(_problems));

  /// Create a copy of ProblemDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProblemDetailsDtoImplCopyWith<_$ProblemDetailsDtoImpl> get copyWith =>
      __$$ProblemDetailsDtoImplCopyWithImpl<_$ProblemDetailsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProblemDetailsDtoImplToJson(
      this,
    );
  }
}

abstract class _ProblemDetailsDto implements ProblemDetailsDto {
  const factory _ProblemDetailsDto(
      {@JsonKey(name: 'has_late') final bool hasLate,
      @JsonKey(name: 'has_overtime') final bool hasOvertime,
      @JsonKey(name: 'has_reported') final bool hasReported,
      @JsonKey(name: 'has_no_checkout') final bool hasNoCheckout,
      @JsonKey(name: 'has_absence') final bool hasAbsence,
      @JsonKey(name: 'has_early_leave') final bool hasEarlyLeave,
      @JsonKey(name: 'has_location_issue') final bool hasLocationIssue,
      @JsonKey(name: 'has_payroll_late') final bool hasPayrollLate,
      @JsonKey(name: 'has_payroll_overtime') final bool hasPayrollOvertime,
      @JsonKey(name: 'has_payroll_early_leave') final bool hasPayrollEarlyLeave,
      @JsonKey(name: 'problem_count') final int problemCount,
      @JsonKey(name: 'is_solved') final bool isSolved,
      @JsonKey(name: 'detected_at') final String? detectedAt,
      @JsonKey(name: 'problems')
      final List<ProblemItemDto> problems}) = _$ProblemDetailsDtoImpl;

  factory _ProblemDetailsDto.fromJson(Map<String, dynamic> json) =
      _$ProblemDetailsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'has_late')
  bool get hasLate;
  @override
  @JsonKey(name: 'has_overtime')
  bool get hasOvertime;
  @override
  @JsonKey(name: 'has_reported')
  bool get hasReported;
  @override
  @JsonKey(name: 'has_no_checkout')
  bool get hasNoCheckout;
  @override
  @JsonKey(name: 'has_absence')
  bool get hasAbsence;
  @override
  @JsonKey(name: 'has_early_leave')
  bool get hasEarlyLeave;
  @override
  @JsonKey(name: 'has_location_issue')
  bool get hasLocationIssue;
  @override
  @JsonKey(name: 'has_payroll_late')
  bool get hasPayrollLate;
  @override
  @JsonKey(name: 'has_payroll_overtime')
  bool get hasPayrollOvertime;
  @override
  @JsonKey(name: 'has_payroll_early_leave')
  bool get hasPayrollEarlyLeave;
  @override
  @JsonKey(name: 'problem_count')
  int get problemCount;
  @override
  @JsonKey(name: 'is_solved')
  bool get isSolved;
  @override
  @JsonKey(name: 'detected_at')
  String? get detectedAt;
  @override
  @JsonKey(name: 'problems')
  List<ProblemItemDto> get problems;

  /// Create a copy of ProblemDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProblemDetailsDtoImplCopyWith<_$ProblemDetailsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProblemItemDto _$ProblemItemDtoFromJson(Map<String, dynamic> json) {
  return _ProblemItemDto.fromJson(json);
}

/// @nodoc
mixin _$ProblemItemDto {
  @JsonKey(name: 'type')
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_minutes')
  int? get actualMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'payroll_minutes')
  int? get payrollMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_payroll_adjusted')
  bool get isPayrollAdjusted =>
      throw _privateConstructorUsedError; // For reported type
  @JsonKey(name: 'reason')
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'reported_at')
  String? get reportedAt => throw _privateConstructorUsedError;
  // null = pending, true = approved, false = rejected
  @JsonKey(name: 'is_report_solved')
  bool? get isReportSolved => throw _privateConstructorUsedError;

  /// Serializes this ProblemItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProblemItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProblemItemDtoCopyWith<ProblemItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProblemItemDtoCopyWith<$Res> {
  factory $ProblemItemDtoCopyWith(
          ProblemItemDto value, $Res Function(ProblemItemDto) then) =
      _$ProblemItemDtoCopyWithImpl<$Res, ProblemItemDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String? type,
      @JsonKey(name: 'actual_minutes') int? actualMinutes,
      @JsonKey(name: 'payroll_minutes') int? payrollMinutes,
      @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted,
      @JsonKey(name: 'reason') String? reason,
      @JsonKey(name: 'reported_at') String? reportedAt,
      @JsonKey(name: 'is_report_solved') bool? isReportSolved});
}

/// @nodoc
class _$ProblemItemDtoCopyWithImpl<$Res, $Val extends ProblemItemDto>
    implements $ProblemItemDtoCopyWith<$Res> {
  _$ProblemItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProblemItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? actualMinutes = freezed,
    Object? payrollMinutes = freezed,
    Object? isPayrollAdjusted = null,
    Object? reason = freezed,
    Object? reportedAt = freezed,
    Object? isReportSolved = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      actualMinutes: freezed == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      payrollMinutes: freezed == payrollMinutes
          ? _value.payrollMinutes
          : payrollMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isPayrollAdjusted: null == isPayrollAdjusted
          ? _value.isPayrollAdjusted
          : isPayrollAdjusted // ignore: cast_nullable_to_non_nullable
              as bool,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      reportedAt: freezed == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isReportSolved: freezed == isReportSolved
          ? _value.isReportSolved
          : isReportSolved // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProblemItemDtoImplCopyWith<$Res>
    implements $ProblemItemDtoCopyWith<$Res> {
  factory _$$ProblemItemDtoImplCopyWith(_$ProblemItemDtoImpl value,
          $Res Function(_$ProblemItemDtoImpl) then) =
      __$$ProblemItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String? type,
      @JsonKey(name: 'actual_minutes') int? actualMinutes,
      @JsonKey(name: 'payroll_minutes') int? payrollMinutes,
      @JsonKey(name: 'is_payroll_adjusted') bool isPayrollAdjusted,
      @JsonKey(name: 'reason') String? reason,
      @JsonKey(name: 'reported_at') String? reportedAt,
      @JsonKey(name: 'is_report_solved') bool? isReportSolved});
}

/// @nodoc
class __$$ProblemItemDtoImplCopyWithImpl<$Res>
    extends _$ProblemItemDtoCopyWithImpl<$Res, _$ProblemItemDtoImpl>
    implements _$$ProblemItemDtoImplCopyWith<$Res> {
  __$$ProblemItemDtoImplCopyWithImpl(
      _$ProblemItemDtoImpl _value, $Res Function(_$ProblemItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProblemItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? actualMinutes = freezed,
    Object? payrollMinutes = freezed,
    Object? isPayrollAdjusted = null,
    Object? reason = freezed,
    Object? reportedAt = freezed,
    Object? isReportSolved = freezed,
  }) {
    return _then(_$ProblemItemDtoImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      actualMinutes: freezed == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      payrollMinutes: freezed == payrollMinutes
          ? _value.payrollMinutes
          : payrollMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isPayrollAdjusted: null == isPayrollAdjusted
          ? _value.isPayrollAdjusted
          : isPayrollAdjusted // ignore: cast_nullable_to_non_nullable
              as bool,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      reportedAt: freezed == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isReportSolved: freezed == isReportSolved
          ? _value.isReportSolved
          : isReportSolved // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProblemItemDtoImpl implements _ProblemItemDto {
  const _$ProblemItemDtoImpl(
      {@JsonKey(name: 'type') this.type,
      @JsonKey(name: 'actual_minutes') this.actualMinutes,
      @JsonKey(name: 'payroll_minutes') this.payrollMinutes,
      @JsonKey(name: 'is_payroll_adjusted') this.isPayrollAdjusted = false,
      @JsonKey(name: 'reason') this.reason,
      @JsonKey(name: 'reported_at') this.reportedAt,
      @JsonKey(name: 'is_report_solved') this.isReportSolved});

  factory _$ProblemItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProblemItemDtoImplFromJson(json);

  @override
  @JsonKey(name: 'type')
  final String? type;
  @override
  @JsonKey(name: 'actual_minutes')
  final int? actualMinutes;
  @override
  @JsonKey(name: 'payroll_minutes')
  final int? payrollMinutes;
  @override
  @JsonKey(name: 'is_payroll_adjusted')
  final bool isPayrollAdjusted;
// For reported type
  @override
  @JsonKey(name: 'reason')
  final String? reason;
  @override
  @JsonKey(name: 'reported_at')
  final String? reportedAt;
  @override
  @JsonKey(name: 'is_report_solved')
  final bool? isReportSolved;

  @override
  String toString() {
    return 'ProblemItemDto(type: $type, actualMinutes: $actualMinutes, payrollMinutes: $payrollMinutes, isPayrollAdjusted: $isPayrollAdjusted, reason: $reason, reportedAt: $reportedAt, isReportSolved: $isReportSolved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProblemItemDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.actualMinutes, actualMinutes) ||
                other.actualMinutes == actualMinutes) &&
            (identical(other.payrollMinutes, payrollMinutes) ||
                other.payrollMinutes == payrollMinutes) &&
            (identical(other.isPayrollAdjusted, isPayrollAdjusted) ||
                other.isPayrollAdjusted == isPayrollAdjusted) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.reportedAt, reportedAt) ||
                other.reportedAt == reportedAt) &&
            (identical(other.isReportSolved, isReportSolved) ||
                other.isReportSolved == isReportSolved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, actualMinutes,
      payrollMinutes, isPayrollAdjusted, reason, reportedAt, isReportSolved);

  /// Create a copy of ProblemItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProblemItemDtoImplCopyWith<_$ProblemItemDtoImpl> get copyWith =>
      __$$ProblemItemDtoImplCopyWithImpl<_$ProblemItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProblemItemDtoImplToJson(
      this,
    );
  }
}

abstract class _ProblemItemDto implements ProblemItemDto {
  const factory _ProblemItemDto(
          {@JsonKey(name: 'type') final String? type,
          @JsonKey(name: 'actual_minutes') final int? actualMinutes,
          @JsonKey(name: 'payroll_minutes') final int? payrollMinutes,
          @JsonKey(name: 'is_payroll_adjusted') final bool isPayrollAdjusted,
          @JsonKey(name: 'reason') final String? reason,
          @JsonKey(name: 'reported_at') final String? reportedAt,
          @JsonKey(name: 'is_report_solved') final bool? isReportSolved}) =
      _$ProblemItemDtoImpl;

  factory _ProblemItemDto.fromJson(Map<String, dynamic> json) =
      _$ProblemItemDtoImpl.fromJson;

  @override
  @JsonKey(name: 'type')
  String? get type;
  @override
  @JsonKey(name: 'actual_minutes')
  int? get actualMinutes;
  @override
  @JsonKey(name: 'payroll_minutes')
  int? get payrollMinutes;
  @override
  @JsonKey(name: 'is_payroll_adjusted')
  bool get isPayrollAdjusted; // For reported type
  @override
  @JsonKey(name: 'reason')
  String? get reason;
  @override
  @JsonKey(name: 'reported_at')
  String? get reportedAt;
  @override
  @JsonKey(name: 'is_report_solved')
  bool? get isReportSolved;

  /// Create a copy of ProblemItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProblemItemDtoImplCopyWith<_$ProblemItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
