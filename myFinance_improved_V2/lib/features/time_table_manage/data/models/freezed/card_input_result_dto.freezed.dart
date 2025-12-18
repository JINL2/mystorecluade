// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_input_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CardInputResultDto {
  /// Shift request ID that was updated
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;

  /// Confirmed start time (HH:mm format in UTC)
  @JsonKey(name: 'confirm_start_time')
  String get confirmStartTime => throw _privateConstructorUsedError;

  /// Confirmed end time (HH:mm format in UTC)
  @JsonKey(name: 'confirm_end_time')
  String get confirmEndTime => throw _privateConstructorUsedError;

  /// Whether employee was late
  @JsonKey(name: 'is_late')
  bool get isLate => throw _privateConstructorUsedError;

  /// Whether any problem was resolved
  @JsonKey(name: 'is_problem_solved')
  bool get isProblemSolved => throw _privateConstructorUsedError;

  /// Newly created tag (if any)
  @JsonKey(name: 'new_tag')
  TagDto? get newTag => throw _privateConstructorUsedError;

  /// Full updated shift card data
  /// Note: RPC returns all shift fields at root level, not nested
  @JsonKey(name: 'shift_data')
  ShiftCardDto? get shiftData => throw _privateConstructorUsedError;

  /// Optional success/error message
  @JsonKey(name: 'message')
  String? get message => throw _privateConstructorUsedError;

  /// Shift date based on start_time_utc (YYYY-MM-DD) - actual work date
  @JsonKey(name: 'shift_date')
  String get shiftDate => throw _privateConstructorUsedError;

  /// Create a copy of CardInputResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardInputResultDtoCopyWith<CardInputResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardInputResultDtoCopyWith<$Res> {
  factory $CardInputResultDtoCopyWith(
          CardInputResultDto value, $Res Function(CardInputResultDto) then) =
      _$CardInputResultDtoCopyWithImpl<$Res, CardInputResultDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'confirm_start_time') String confirmStartTime,
      @JsonKey(name: 'confirm_end_time') String confirmEndTime,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'is_problem_solved') bool isProblemSolved,
      @JsonKey(name: 'new_tag') TagDto? newTag,
      @JsonKey(name: 'shift_data') ShiftCardDto? shiftData,
      @JsonKey(name: 'message') String? message,
      @JsonKey(name: 'shift_date') String shiftDate});

  $TagDtoCopyWith<$Res>? get newTag;
  $ShiftCardDtoCopyWith<$Res>? get shiftData;
}

/// @nodoc
class _$CardInputResultDtoCopyWithImpl<$Res, $Val extends CardInputResultDto>
    implements $CardInputResultDtoCopyWith<$Res> {
  _$CardInputResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardInputResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? confirmStartTime = null,
    Object? confirmEndTime = null,
    Object? isLate = null,
    Object? isProblemSolved = null,
    Object? newTag = freezed,
    Object? shiftData = freezed,
    Object? message = freezed,
    Object? shiftDate = null,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      confirmStartTime: null == confirmStartTime
          ? _value.confirmStartTime
          : confirmStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      confirmEndTime: null == confirmEndTime
          ? _value.confirmEndTime
          : confirmEndTime // ignore: cast_nullable_to_non_nullable
              as String,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblemSolved: null == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      newTag: freezed == newTag
          ? _value.newTag
          : newTag // ignore: cast_nullable_to_non_nullable
              as TagDto?,
      shiftData: freezed == shiftData
          ? _value.shiftData
          : shiftData // ignore: cast_nullable_to_non_nullable
              as ShiftCardDto?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of CardInputResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TagDtoCopyWith<$Res>? get newTag {
    if (_value.newTag == null) {
      return null;
    }

    return $TagDtoCopyWith<$Res>(_value.newTag!, (value) {
      return _then(_value.copyWith(newTag: value) as $Val);
    });
  }

  /// Create a copy of CardInputResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftCardDtoCopyWith<$Res>? get shiftData {
    if (_value.shiftData == null) {
      return null;
    }

    return $ShiftCardDtoCopyWith<$Res>(_value.shiftData!, (value) {
      return _then(_value.copyWith(shiftData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CardInputResultDtoImplCopyWith<$Res>
    implements $CardInputResultDtoCopyWith<$Res> {
  factory _$$CardInputResultDtoImplCopyWith(_$CardInputResultDtoImpl value,
          $Res Function(_$CardInputResultDtoImpl) then) =
      __$$CardInputResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'confirm_start_time') String confirmStartTime,
      @JsonKey(name: 'confirm_end_time') String confirmEndTime,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'is_problem_solved') bool isProblemSolved,
      @JsonKey(name: 'new_tag') TagDto? newTag,
      @JsonKey(name: 'shift_data') ShiftCardDto? shiftData,
      @JsonKey(name: 'message') String? message,
      @JsonKey(name: 'shift_date') String shiftDate});

  @override
  $TagDtoCopyWith<$Res>? get newTag;
  @override
  $ShiftCardDtoCopyWith<$Res>? get shiftData;
}

/// @nodoc
class __$$CardInputResultDtoImplCopyWithImpl<$Res>
    extends _$CardInputResultDtoCopyWithImpl<$Res, _$CardInputResultDtoImpl>
    implements _$$CardInputResultDtoImplCopyWith<$Res> {
  __$$CardInputResultDtoImplCopyWithImpl(_$CardInputResultDtoImpl _value,
      $Res Function(_$CardInputResultDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CardInputResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? confirmStartTime = null,
    Object? confirmEndTime = null,
    Object? isLate = null,
    Object? isProblemSolved = null,
    Object? newTag = freezed,
    Object? shiftData = freezed,
    Object? message = freezed,
    Object? shiftDate = null,
  }) {
    return _then(_$CardInputResultDtoImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      confirmStartTime: null == confirmStartTime
          ? _value.confirmStartTime
          : confirmStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      confirmEndTime: null == confirmEndTime
          ? _value.confirmEndTime
          : confirmEndTime // ignore: cast_nullable_to_non_nullable
              as String,
      isLate: null == isLate
          ? _value.isLate
          : isLate // ignore: cast_nullable_to_non_nullable
              as bool,
      isProblemSolved: null == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool,
      newTag: freezed == newTag
          ? _value.newTag
          : newTag // ignore: cast_nullable_to_non_nullable
              as TagDto?,
      shiftData: freezed == shiftData
          ? _value.shiftData
          : shiftData // ignore: cast_nullable_to_non_nullable
              as ShiftCardDto?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CardInputResultDtoImpl implements _CardInputResultDto {
  const _$CardInputResultDtoImpl(
      {@JsonKey(name: 'shift_request_id') this.shiftRequestId = '',
      @JsonKey(name: 'confirm_start_time') this.confirmStartTime = '',
      @JsonKey(name: 'confirm_end_time') this.confirmEndTime = '',
      @JsonKey(name: 'is_late') this.isLate = false,
      @JsonKey(name: 'is_problem_solved') this.isProblemSolved = false,
      @JsonKey(name: 'new_tag') this.newTag,
      @JsonKey(name: 'shift_data') this.shiftData,
      @JsonKey(name: 'message') this.message,
      @JsonKey(name: 'shift_date') this.shiftDate = ''});

  /// Shift request ID that was updated
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;

  /// Confirmed start time (HH:mm format in UTC)
  @override
  @JsonKey(name: 'confirm_start_time')
  final String confirmStartTime;

  /// Confirmed end time (HH:mm format in UTC)
  @override
  @JsonKey(name: 'confirm_end_time')
  final String confirmEndTime;

  /// Whether employee was late
  @override
  @JsonKey(name: 'is_late')
  final bool isLate;

  /// Whether any problem was resolved
  @override
  @JsonKey(name: 'is_problem_solved')
  final bool isProblemSolved;

  /// Newly created tag (if any)
  @override
  @JsonKey(name: 'new_tag')
  final TagDto? newTag;

  /// Full updated shift card data
  /// Note: RPC returns all shift fields at root level, not nested
  @override
  @JsonKey(name: 'shift_data')
  final ShiftCardDto? shiftData;

  /// Optional success/error message
  @override
  @JsonKey(name: 'message')
  final String? message;

  /// Shift date based on start_time_utc (YYYY-MM-DD) - actual work date
  @override
  @JsonKey(name: 'shift_date')
  final String shiftDate;

  @override
  String toString() {
    return 'CardInputResultDto(shiftRequestId: $shiftRequestId, confirmStartTime: $confirmStartTime, confirmEndTime: $confirmEndTime, isLate: $isLate, isProblemSolved: $isProblemSolved, newTag: $newTag, shiftData: $shiftData, message: $message, shiftDate: $shiftDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardInputResultDtoImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.confirmStartTime, confirmStartTime) ||
                other.confirmStartTime == confirmStartTime) &&
            (identical(other.confirmEndTime, confirmEndTime) ||
                other.confirmEndTime == confirmEndTime) &&
            (identical(other.isLate, isLate) || other.isLate == isLate) &&
            (identical(other.isProblemSolved, isProblemSolved) ||
                other.isProblemSolved == isProblemSolved) &&
            (identical(other.newTag, newTag) || other.newTag == newTag) &&
            (identical(other.shiftData, shiftData) ||
                other.shiftData == shiftData) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.shiftDate, shiftDate) ||
                other.shiftDate == shiftDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shiftRequestId,
      confirmStartTime,
      confirmEndTime,
      isLate,
      isProblemSolved,
      newTag,
      shiftData,
      message,
      shiftDate);

  /// Create a copy of CardInputResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardInputResultDtoImplCopyWith<_$CardInputResultDtoImpl> get copyWith =>
      __$$CardInputResultDtoImplCopyWithImpl<_$CardInputResultDtoImpl>(
          this, _$identity);
}

abstract class _CardInputResultDto implements CardInputResultDto {
  const factory _CardInputResultDto(
          {@JsonKey(name: 'shift_request_id') final String shiftRequestId,
          @JsonKey(name: 'confirm_start_time') final String confirmStartTime,
          @JsonKey(name: 'confirm_end_time') final String confirmEndTime,
          @JsonKey(name: 'is_late') final bool isLate,
          @JsonKey(name: 'is_problem_solved') final bool isProblemSolved,
          @JsonKey(name: 'new_tag') final TagDto? newTag,
          @JsonKey(name: 'shift_data') final ShiftCardDto? shiftData,
          @JsonKey(name: 'message') final String? message,
          @JsonKey(name: 'shift_date') final String shiftDate}) =
      _$CardInputResultDtoImpl;

  /// Shift request ID that was updated
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;

  /// Confirmed start time (HH:mm format in UTC)
  @override
  @JsonKey(name: 'confirm_start_time')
  String get confirmStartTime;

  /// Confirmed end time (HH:mm format in UTC)
  @override
  @JsonKey(name: 'confirm_end_time')
  String get confirmEndTime;

  /// Whether employee was late
  @override
  @JsonKey(name: 'is_late')
  bool get isLate;

  /// Whether any problem was resolved
  @override
  @JsonKey(name: 'is_problem_solved')
  bool get isProblemSolved;

  /// Newly created tag (if any)
  @override
  @JsonKey(name: 'new_tag')
  TagDto? get newTag;

  /// Full updated shift card data
  /// Note: RPC returns all shift fields at root level, not nested
  @override
  @JsonKey(name: 'shift_data')
  ShiftCardDto? get shiftData;

  /// Optional success/error message
  @override
  @JsonKey(name: 'message')
  String? get message;

  /// Shift date based on start_time_utc (YYYY-MM-DD) - actual work date
  @override
  @JsonKey(name: 'shift_date')
  String get shiftDate;

  /// Create a copy of CardInputResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardInputResultDtoImplCopyWith<_$CardInputResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
