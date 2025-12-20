// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_session_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JoinSessionResponse {
  String get memberId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get joinedAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get createdByName => throw _privateConstructorUsedError;

  /// Create a copy of JoinSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinSessionResponseCopyWith<JoinSessionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinSessionResponseCopyWith<$Res> {
  factory $JoinSessionResponseCopyWith(
          JoinSessionResponse value, $Res Function(JoinSessionResponse) then) =
      _$JoinSessionResponseCopyWithImpl<$Res, JoinSessionResponse>;
  @useResult
  $Res call(
      {String memberId,
      String sessionId,
      String userId,
      String joinedAt,
      String createdBy,
      String createdByName});
}

/// @nodoc
class _$JoinSessionResponseCopyWithImpl<$Res, $Val extends JoinSessionResponse>
    implements $JoinSessionResponseCopyWith<$Res> {
  _$JoinSessionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? sessionId = null,
    Object? userId = null,
    Object? joinedAt = null,
    Object? createdBy = null,
    Object? createdByName = null,
  }) {
    return _then(_value.copyWith(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JoinSessionResponseImplCopyWith<$Res>
    implements $JoinSessionResponseCopyWith<$Res> {
  factory _$$JoinSessionResponseImplCopyWith(_$JoinSessionResponseImpl value,
          $Res Function(_$JoinSessionResponseImpl) then) =
      __$$JoinSessionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String memberId,
      String sessionId,
      String userId,
      String joinedAt,
      String createdBy,
      String createdByName});
}

/// @nodoc
class __$$JoinSessionResponseImplCopyWithImpl<$Res>
    extends _$JoinSessionResponseCopyWithImpl<$Res, _$JoinSessionResponseImpl>
    implements _$$JoinSessionResponseImplCopyWith<$Res> {
  __$$JoinSessionResponseImplCopyWithImpl(_$JoinSessionResponseImpl _value,
      $Res Function(_$JoinSessionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of JoinSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? sessionId = null,
    Object? userId = null,
    Object? joinedAt = null,
    Object? createdBy = null,
    Object? createdByName = null,
  }) {
    return _then(_$JoinSessionResponseImpl(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$JoinSessionResponseImpl implements _JoinSessionResponse {
  const _$JoinSessionResponseImpl(
      {required this.memberId,
      required this.sessionId,
      required this.userId,
      required this.joinedAt,
      required this.createdBy,
      required this.createdByName});

  @override
  final String memberId;
  @override
  final String sessionId;
  @override
  final String userId;
  @override
  final String joinedAt;
  @override
  final String createdBy;
  @override
  final String createdByName;

  @override
  String toString() {
    return 'JoinSessionResponse(memberId: $memberId, sessionId: $sessionId, userId: $userId, joinedAt: $joinedAt, createdBy: $createdBy, createdByName: $createdByName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinSessionResponseImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberId, sessionId, userId,
      joinedAt, createdBy, createdByName);

  /// Create a copy of JoinSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinSessionResponseImplCopyWith<_$JoinSessionResponseImpl> get copyWith =>
      __$$JoinSessionResponseImplCopyWithImpl<_$JoinSessionResponseImpl>(
          this, _$identity);
}

abstract class _JoinSessionResponse implements JoinSessionResponse {
  const factory _JoinSessionResponse(
      {required final String memberId,
      required final String sessionId,
      required final String userId,
      required final String joinedAt,
      required final String createdBy,
      required final String createdByName}) = _$JoinSessionResponseImpl;

  @override
  String get memberId;
  @override
  String get sessionId;
  @override
  String get userId;
  @override
  String get joinedAt;
  @override
  String get createdBy;
  @override
  String get createdByName;

  /// Create a copy of JoinSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinSessionResponseImplCopyWith<_$JoinSessionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
