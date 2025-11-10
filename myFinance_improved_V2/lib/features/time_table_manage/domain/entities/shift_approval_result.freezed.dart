// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_approval_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftApprovalResult _$ShiftApprovalResultFromJson(Map<String, dynamic> json) {
  return _ShiftApprovalResult.fromJson(json);
}

/// @nodoc
mixin _$ShiftApprovalResult {
  /// The shift request ID that was processed
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;

  /// New approval status (true = approved, false = not approved/pending)
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;

  /// When the approval status was changed
  @JsonKey(name: 'approved_at')
  DateTime get approvedAt => throw _privateConstructorUsedError;

  /// User ID who performed the approval action
  @JsonKey(name: 'approved_by')
  String? get approvedBy => throw _privateConstructorUsedError;

  /// The updated shift request entity after approval
  @JsonKey(name: 'updated_request')
  ShiftRequest get updatedRequest => throw _privateConstructorUsedError;

  /// Optional message about the approval result
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this ShiftApprovalResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftApprovalResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftApprovalResultCopyWith<ShiftApprovalResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftApprovalResultCopyWith<$Res> {
  factory $ShiftApprovalResultCopyWith(
          ShiftApprovalResult value, $Res Function(ShiftApprovalResult) then) =
      _$ShiftApprovalResultCopyWithImpl<$Res, ShiftApprovalResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'approved_at') DateTime approvedAt,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'updated_request') ShiftRequest updatedRequest,
      String? message});

  $ShiftRequestCopyWith<$Res> get updatedRequest;
}

/// @nodoc
class _$ShiftApprovalResultCopyWithImpl<$Res, $Val extends ShiftApprovalResult>
    implements $ShiftApprovalResultCopyWith<$Res> {
  _$ShiftApprovalResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftApprovalResult
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
              as DateTime,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
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

  /// Create a copy of ShiftApprovalResult
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
abstract class _$$ShiftApprovalResultImplCopyWith<$Res>
    implements $ShiftApprovalResultCopyWith<$Res> {
  factory _$$ShiftApprovalResultImplCopyWith(_$ShiftApprovalResultImpl value,
          $Res Function(_$ShiftApprovalResultImpl) then) =
      __$$ShiftApprovalResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'approved_at') DateTime approvedAt,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'updated_request') ShiftRequest updatedRequest,
      String? message});

  @override
  $ShiftRequestCopyWith<$Res> get updatedRequest;
}

/// @nodoc
class __$$ShiftApprovalResultImplCopyWithImpl<$Res>
    extends _$ShiftApprovalResultCopyWithImpl<$Res, _$ShiftApprovalResultImpl>
    implements _$$ShiftApprovalResultImplCopyWith<$Res> {
  __$$ShiftApprovalResultImplCopyWithImpl(_$ShiftApprovalResultImpl _value,
      $Res Function(_$ShiftApprovalResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftApprovalResult
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
    return _then(_$ShiftApprovalResultImpl(
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
              as DateTime,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$ShiftApprovalResultImpl extends _ShiftApprovalResult {
  const _$ShiftApprovalResultImpl(
      {@JsonKey(name: 'shift_request_id') required this.shiftRequestId,
      @JsonKey(name: 'is_approved') required this.isApproved,
      @JsonKey(name: 'approved_at') required this.approvedAt,
      @JsonKey(name: 'approved_by') this.approvedBy,
      @JsonKey(name: 'updated_request') required this.updatedRequest,
      this.message})
      : super._();

  factory _$ShiftApprovalResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftApprovalResultImplFromJson(json);

  /// The shift request ID that was processed
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;

  /// New approval status (true = approved, false = not approved/pending)
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;

  /// When the approval status was changed
  @override
  @JsonKey(name: 'approved_at')
  final DateTime approvedAt;

  /// User ID who performed the approval action
  @override
  @JsonKey(name: 'approved_by')
  final String? approvedBy;

  /// The updated shift request entity after approval
  @override
  @JsonKey(name: 'updated_request')
  final ShiftRequest updatedRequest;

  /// Optional message about the approval result
  @override
  final String? message;

  @override
  String toString() {
    return 'ShiftApprovalResult(shiftRequestId: $shiftRequestId, isApproved: $isApproved, approvedAt: $approvedAt, approvedBy: $approvedBy, updatedRequest: $updatedRequest, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftApprovalResultImpl &&
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

  /// Create a copy of ShiftApprovalResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftApprovalResultImplCopyWith<_$ShiftApprovalResultImpl> get copyWith =>
      __$$ShiftApprovalResultImplCopyWithImpl<_$ShiftApprovalResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftApprovalResultImplToJson(
      this,
    );
  }
}

abstract class _ShiftApprovalResult extends ShiftApprovalResult {
  const factory _ShiftApprovalResult(
      {@JsonKey(name: 'shift_request_id') required final String shiftRequestId,
      @JsonKey(name: 'is_approved') required final bool isApproved,
      @JsonKey(name: 'approved_at') required final DateTime approvedAt,
      @JsonKey(name: 'approved_by') final String? approvedBy,
      @JsonKey(name: 'updated_request')
      required final ShiftRequest updatedRequest,
      final String? message}) = _$ShiftApprovalResultImpl;
  const _ShiftApprovalResult._() : super._();

  factory _ShiftApprovalResult.fromJson(Map<String, dynamic> json) =
      _$ShiftApprovalResultImpl.fromJson;

  /// The shift request ID that was processed
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;

  /// New approval status (true = approved, false = not approved/pending)
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;

  /// When the approval status was changed
  @override
  @JsonKey(name: 'approved_at')
  DateTime get approvedAt;

  /// User ID who performed the approval action
  @override
  @JsonKey(name: 'approved_by')
  String? get approvedBy;

  /// The updated shift request entity after approval
  @override
  @JsonKey(name: 'updated_request')
  ShiftRequest get updatedRequest;

  /// Optional message about the approval result
  @override
  String? get message;

  /// Create a copy of ShiftApprovalResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftApprovalResultImplCopyWith<_$ShiftApprovalResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
