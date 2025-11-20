// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_approval_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftApprovalResultDto _$ShiftApprovalResultDtoFromJson(
    Map<String, dynamic> json) {
  return _ShiftApprovalResultDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftApprovalResultDto {
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  String get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  String? get approvedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_request')
  ShiftRequestDto get updatedRequest => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this ShiftApprovalResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftApprovalResultDtoCopyWith<ShiftApprovalResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftApprovalResultDtoCopyWith<$Res> {
  factory $ShiftApprovalResultDtoCopyWith(ShiftApprovalResultDto value,
          $Res Function(ShiftApprovalResultDto) then) =
      _$ShiftApprovalResultDtoCopyWithImpl<$Res, ShiftApprovalResultDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'approved_at') String approvedAt,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'updated_request') ShiftRequestDto updatedRequest,
      @JsonKey(name: 'message') String? message});

  $ShiftRequestDtoCopyWith<$Res> get updatedRequest;
}

/// @nodoc
class _$ShiftApprovalResultDtoCopyWithImpl<$Res,
        $Val extends ShiftApprovalResultDto>
    implements $ShiftApprovalResultDtoCopyWith<$Res> {
  _$ShiftApprovalResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? isApproved = null,
    Object? approvedAt = null,
    Object? approvedBy = freezed,
    Object? updatedRequest = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      approvedAt: null == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedRequest: null == updatedRequest
          ? _value.updatedRequest
          : updatedRequest // ignore: cast_nullable_to_non_nullable
              as ShiftRequestDto,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ShiftApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftRequestDtoCopyWith<$Res> get updatedRequest {
    return $ShiftRequestDtoCopyWith<$Res>(_value.updatedRequest, (value) {
      return _then(_value.copyWith(updatedRequest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShiftApprovalResultDtoImplCopyWith<$Res>
    implements $ShiftApprovalResultDtoCopyWith<$Res> {
  factory _$$ShiftApprovalResultDtoImplCopyWith(
          _$ShiftApprovalResultDtoImpl value,
          $Res Function(_$ShiftApprovalResultDtoImpl) then) =
      __$$ShiftApprovalResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'approved_at') String approvedAt,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'updated_request') ShiftRequestDto updatedRequest,
      @JsonKey(name: 'message') String? message});

  @override
  $ShiftRequestDtoCopyWith<$Res> get updatedRequest;
}

/// @nodoc
class __$$ShiftApprovalResultDtoImplCopyWithImpl<$Res>
    extends _$ShiftApprovalResultDtoCopyWithImpl<$Res,
        _$ShiftApprovalResultDtoImpl>
    implements _$$ShiftApprovalResultDtoImplCopyWith<$Res> {
  __$$ShiftApprovalResultDtoImplCopyWithImpl(
      _$ShiftApprovalResultDtoImpl _value,
      $Res Function(_$ShiftApprovalResultDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? isApproved = null,
    Object? approvedAt = null,
    Object? approvedBy = freezed,
    Object? updatedRequest = null,
    Object? message = freezed,
  }) {
    return _then(_$ShiftApprovalResultDtoImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      approvedAt: null == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedRequest: null == updatedRequest
          ? _value.updatedRequest
          : updatedRequest // ignore: cast_nullable_to_non_nullable
              as ShiftRequestDto,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftApprovalResultDtoImpl implements _ShiftApprovalResultDto {
  const _$ShiftApprovalResultDtoImpl(
      {@JsonKey(name: 'shift_request_id') this.shiftRequestId = '',
      @JsonKey(name: 'is_approved') this.isApproved = false,
      @JsonKey(name: 'approved_at') this.approvedAt = '',
      @JsonKey(name: 'approved_by') this.approvedBy,
      @JsonKey(name: 'updated_request') required this.updatedRequest,
      @JsonKey(name: 'message') this.message});

  factory _$ShiftApprovalResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftApprovalResultDtoImplFromJson(json);

  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'approved_at')
  final String approvedAt;
  @override
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  @override
  @JsonKey(name: 'updated_request')
  final ShiftRequestDto updatedRequest;
  @override
  @JsonKey(name: 'message')
  final String? message;

  @override
  String toString() {
    return 'ShiftApprovalResultDto(shiftRequestId: $shiftRequestId, isApproved: $isApproved, approvedAt: $approvedAt, approvedBy: $approvedBy, updatedRequest: $updatedRequest, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftApprovalResultDtoImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.updatedRequest, updatedRequest) ||
                other.updatedRequest == updatedRequest) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, shiftRequestId, isApproved,
      approvedAt, approvedBy, updatedRequest, message);

  /// Create a copy of ShiftApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftApprovalResultDtoImplCopyWith<_$ShiftApprovalResultDtoImpl>
      get copyWith => __$$ShiftApprovalResultDtoImplCopyWithImpl<
          _$ShiftApprovalResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftApprovalResultDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftApprovalResultDto implements ShiftApprovalResultDto {
  const factory _ShiftApprovalResultDto(
          {@JsonKey(name: 'shift_request_id') final String shiftRequestId,
          @JsonKey(name: 'is_approved') final bool isApproved,
          @JsonKey(name: 'approved_at') final String approvedAt,
          @JsonKey(name: 'approved_by') final String? approvedBy,
          @JsonKey(name: 'updated_request')
          required final ShiftRequestDto updatedRequest,
          @JsonKey(name: 'message') final String? message}) =
      _$ShiftApprovalResultDtoImpl;

  factory _ShiftApprovalResultDto.fromJson(Map<String, dynamic> json) =
      _$ShiftApprovalResultDtoImpl.fromJson;

  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'approved_at')
  String get approvedAt;
  @override
  @JsonKey(name: 'approved_by')
  String? get approvedBy;
  @override
  @JsonKey(name: 'updated_request')
  ShiftRequestDto get updatedRequest;
  @override
  @JsonKey(name: 'message')
  String? get message;

  /// Create a copy of ShiftApprovalResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftApprovalResultDtoImplCopyWith<_$ShiftApprovalResultDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
