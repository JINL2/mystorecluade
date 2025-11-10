// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_input_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CardInputResult _$CardInputResultFromJson(Map<String, dynamic> json) {
  return _CardInputResult.fromJson(json);
}

/// @nodoc
mixin _$CardInputResult {
  /// The shift request ID that was updated
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;

  /// Confirmed start time (actual start time)
  @JsonKey(name: 'confirmed_start_time')
  DateTime get confirmedStartTime => throw _privateConstructorUsedError;

  /// Confirmed end time (actual end time)
  @JsonKey(name: 'confirmed_end_time')
  DateTime get confirmedEndTime => throw _privateConstructorUsedError;

  /// Whether the employee was late
  @JsonKey(name: 'is_late')
  bool get isLate => throw _privateConstructorUsedError;

  /// Whether any problem was solved
  @JsonKey(name: 'is_problem_solved')
  bool get isProblemSolved => throw _privateConstructorUsedError;

  /// The new tag that was created (if any)
  @JsonKey(name: 'new_tag')
  Tag? get newTag => throw _privateConstructorUsedError;

  /// The updated shift request entity after input
  @JsonKey(name: 'updated_request')
  ShiftRequest get updatedRequest => throw _privateConstructorUsedError;

  /// Optional message about the result
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this CardInputResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CardInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardInputResultCopyWith<CardInputResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardInputResultCopyWith<$Res> {
  factory $CardInputResultCopyWith(
          CardInputResult value, $Res Function(CardInputResult) then) =
      _$CardInputResultCopyWithImpl<$Res, CardInputResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'confirmed_start_time') DateTime confirmedStartTime,
      @JsonKey(name: 'confirmed_end_time') DateTime confirmedEndTime,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'is_problem_solved') bool isProblemSolved,
      @JsonKey(name: 'new_tag') Tag? newTag,
      @JsonKey(name: 'updated_request') ShiftRequest updatedRequest,
      String? message});

  $TagCopyWith<$Res>? get newTag;
  $ShiftRequestCopyWith<$Res> get updatedRequest;
}

/// @nodoc
class _$CardInputResultCopyWithImpl<$Res, $Val extends CardInputResult>
    implements $CardInputResultCopyWith<$Res> {
  _$CardInputResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardInputResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? confirmedStartTime = null,
    Object? confirmedEndTime = null,
    Object? isLate = null,
    Object? isProblemSolved = null,
    Object? newTag = freezed,
    Object? updatedRequest = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      confirmedStartTime: null == confirmedStartTime
          ? _value.confirmedStartTime
          : confirmedStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedEndTime: null == confirmedEndTime
          ? _value.confirmedEndTime
          : confirmedEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
              as Tag?,
      updatedRequest: null == updatedRequest
          ? _value.updatedRequest
          : updatedRequest // ignore: cast_nullable_to_non_nullable
              as ShiftRequest,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of CardInputResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TagCopyWith<$Res>? get newTag {
    if (_value.newTag == null) {
      return null;
    }

    return $TagCopyWith<$Res>(_value.newTag!, (value) {
      return _then(_value.copyWith(newTag: value) as $Val);
    });
  }

  /// Create a copy of CardInputResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftRequestCopyWith<$Res> get updatedRequest {
    return $ShiftRequestCopyWith<$Res>(_value.updatedRequest, (value) {
      return _then(_value.copyWith(updatedRequest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CardInputResultImplCopyWith<$Res>
    implements $CardInputResultCopyWith<$Res> {
  factory _$$CardInputResultImplCopyWith(_$CardInputResultImpl value,
          $Res Function(_$CardInputResultImpl) then) =
      __$$CardInputResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'confirmed_start_time') DateTime confirmedStartTime,
      @JsonKey(name: 'confirmed_end_time') DateTime confirmedEndTime,
      @JsonKey(name: 'is_late') bool isLate,
      @JsonKey(name: 'is_problem_solved') bool isProblemSolved,
      @JsonKey(name: 'new_tag') Tag? newTag,
      @JsonKey(name: 'updated_request') ShiftRequest updatedRequest,
      String? message});

  @override
  $TagCopyWith<$Res>? get newTag;
  @override
  $ShiftRequestCopyWith<$Res> get updatedRequest;
}

/// @nodoc
class __$$CardInputResultImplCopyWithImpl<$Res>
    extends _$CardInputResultCopyWithImpl<$Res, _$CardInputResultImpl>
    implements _$$CardInputResultImplCopyWith<$Res> {
  __$$CardInputResultImplCopyWithImpl(
      _$CardInputResultImpl _value, $Res Function(_$CardInputResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of CardInputResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? confirmedStartTime = null,
    Object? confirmedEndTime = null,
    Object? isLate = null,
    Object? isProblemSolved = null,
    Object? newTag = freezed,
    Object? updatedRequest = null,
    Object? message = freezed,
  }) {
    return _then(_$CardInputResultImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      confirmedStartTime: null == confirmedStartTime
          ? _value.confirmedStartTime
          : confirmedStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedEndTime: null == confirmedEndTime
          ? _value.confirmedEndTime
          : confirmedEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
              as Tag?,
      updatedRequest: null == updatedRequest
          ? _value.updatedRequest
          : updatedRequest // ignore: cast_nullable_to_non_nullable
              as ShiftRequest,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CardInputResultImpl extends _CardInputResult {
  const _$CardInputResultImpl(
      {@JsonKey(name: 'shift_request_id') required this.shiftRequestId,
      @JsonKey(name: 'confirmed_start_time') required this.confirmedStartTime,
      @JsonKey(name: 'confirmed_end_time') required this.confirmedEndTime,
      @JsonKey(name: 'is_late') required this.isLate,
      @JsonKey(name: 'is_problem_solved') required this.isProblemSolved,
      @JsonKey(name: 'new_tag') this.newTag,
      @JsonKey(name: 'updated_request') required this.updatedRequest,
      this.message})
      : super._();

  factory _$CardInputResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardInputResultImplFromJson(json);

  /// The shift request ID that was updated
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;

  /// Confirmed start time (actual start time)
  @override
  @JsonKey(name: 'confirmed_start_time')
  final DateTime confirmedStartTime;

  /// Confirmed end time (actual end time)
  @override
  @JsonKey(name: 'confirmed_end_time')
  final DateTime confirmedEndTime;

  /// Whether the employee was late
  @override
  @JsonKey(name: 'is_late')
  final bool isLate;

  /// Whether any problem was solved
  @override
  @JsonKey(name: 'is_problem_solved')
  final bool isProblemSolved;

  /// The new tag that was created (if any)
  @override
  @JsonKey(name: 'new_tag')
  final Tag? newTag;

  /// The updated shift request entity after input
  @override
  @JsonKey(name: 'updated_request')
  final ShiftRequest updatedRequest;

  /// Optional message about the result
  @override
  final String? message;

  @override
  String toString() {
    return 'CardInputResult(shiftRequestId: $shiftRequestId, confirmedStartTime: $confirmedStartTime, confirmedEndTime: $confirmedEndTime, isLate: $isLate, isProblemSolved: $isProblemSolved, newTag: $newTag, updatedRequest: $updatedRequest, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardInputResultImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.confirmedStartTime, confirmedStartTime) ||
                other.confirmedStartTime == confirmedStartTime) &&
            (identical(other.confirmedEndTime, confirmedEndTime) ||
                other.confirmedEndTime == confirmedEndTime) &&
            (identical(other.isLate, isLate) || other.isLate == isLate) &&
            (identical(other.isProblemSolved, isProblemSolved) ||
                other.isProblemSolved == isProblemSolved) &&
            (identical(other.newTag, newTag) || other.newTag == newTag) &&
            (identical(other.updatedRequest, updatedRequest) ||
                other.updatedRequest == updatedRequest) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      shiftRequestId,
      confirmedStartTime,
      confirmedEndTime,
      isLate,
      isProblemSolved,
      newTag,
      updatedRequest,
      message);

  /// Create a copy of CardInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardInputResultImplCopyWith<_$CardInputResultImpl> get copyWith =>
      __$$CardInputResultImplCopyWithImpl<_$CardInputResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardInputResultImplToJson(
      this,
    );
  }
}

abstract class _CardInputResult extends CardInputResult {
  const factory _CardInputResult(
      {@JsonKey(name: 'shift_request_id') required final String shiftRequestId,
      @JsonKey(name: 'confirmed_start_time')
      required final DateTime confirmedStartTime,
      @JsonKey(name: 'confirmed_end_time')
      required final DateTime confirmedEndTime,
      @JsonKey(name: 'is_late') required final bool isLate,
      @JsonKey(name: 'is_problem_solved') required final bool isProblemSolved,
      @JsonKey(name: 'new_tag') final Tag? newTag,
      @JsonKey(name: 'updated_request')
      required final ShiftRequest updatedRequest,
      final String? message}) = _$CardInputResultImpl;
  const _CardInputResult._() : super._();

  factory _CardInputResult.fromJson(Map<String, dynamic> json) =
      _$CardInputResultImpl.fromJson;

  /// The shift request ID that was updated
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;

  /// Confirmed start time (actual start time)
  @override
  @JsonKey(name: 'confirmed_start_time')
  DateTime get confirmedStartTime;

  /// Confirmed end time (actual end time)
  @override
  @JsonKey(name: 'confirmed_end_time')
  DateTime get confirmedEndTime;

  /// Whether the employee was late
  @override
  @JsonKey(name: 'is_late')
  bool get isLate;

  /// Whether any problem was solved
  @override
  @JsonKey(name: 'is_problem_solved')
  bool get isProblemSolved;

  /// The new tag that was created (if any)
  @override
  @JsonKey(name: 'new_tag')
  Tag? get newTag;

  /// The updated shift request entity after input
  @override
  @JsonKey(name: 'updated_request')
  ShiftRequest get updatedRequest;

  /// Optional message about the result
  @override
  String? get message;

  /// Create a copy of CardInputResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardInputResultImplCopyWith<_$CardInputResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
