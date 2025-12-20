// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'close_session_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CloseSessionResponse {
  String get sessionId => throw _privateConstructorUsedError;
  String get sessionName => throw _privateConstructorUsedError;
  String get sessionType => throw _privateConstructorUsedError;
  String get closedAt => throw _privateConstructorUsedError;

  /// Create a copy of CloseSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CloseSessionResponseCopyWith<CloseSessionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CloseSessionResponseCopyWith<$Res> {
  factory $CloseSessionResponseCopyWith(CloseSessionResponse value,
          $Res Function(CloseSessionResponse) then) =
      _$CloseSessionResponseCopyWithImpl<$Res, CloseSessionResponse>;
  @useResult
  $Res call(
      {String sessionId,
      String sessionName,
      String sessionType,
      String closedAt});
}

/// @nodoc
class _$CloseSessionResponseCopyWithImpl<$Res,
        $Val extends CloseSessionResponse>
    implements $CloseSessionResponseCopyWith<$Res> {
  _$CloseSessionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CloseSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = null,
    Object? sessionType = null,
    Object? closedAt = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionName: null == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      closedAt: null == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CloseSessionResponseImplCopyWith<$Res>
    implements $CloseSessionResponseCopyWith<$Res> {
  factory _$$CloseSessionResponseImplCopyWith(_$CloseSessionResponseImpl value,
          $Res Function(_$CloseSessionResponseImpl) then) =
      __$$CloseSessionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String sessionName,
      String sessionType,
      String closedAt});
}

/// @nodoc
class __$$CloseSessionResponseImplCopyWithImpl<$Res>
    extends _$CloseSessionResponseCopyWithImpl<$Res, _$CloseSessionResponseImpl>
    implements _$$CloseSessionResponseImplCopyWith<$Res> {
  __$$CloseSessionResponseImplCopyWithImpl(_$CloseSessionResponseImpl _value,
      $Res Function(_$CloseSessionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CloseSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionName = null,
    Object? sessionType = null,
    Object? closedAt = null,
  }) {
    return _then(_$CloseSessionResponseImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionName: null == sessionName
          ? _value.sessionName
          : sessionName // ignore: cast_nullable_to_non_nullable
              as String,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      closedAt: null == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CloseSessionResponseImpl implements _CloseSessionResponse {
  const _$CloseSessionResponseImpl(
      {required this.sessionId,
      required this.sessionName,
      required this.sessionType,
      required this.closedAt});

  @override
  final String sessionId;
  @override
  final String sessionName;
  @override
  final String sessionType;
  @override
  final String closedAt;

  @override
  String toString() {
    return 'CloseSessionResponse(sessionId: $sessionId, sessionName: $sessionName, sessionType: $sessionType, closedAt: $closedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CloseSessionResponseImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sessionId, sessionName, sessionType, closedAt);

  /// Create a copy of CloseSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CloseSessionResponseImplCopyWith<_$CloseSessionResponseImpl>
      get copyWith =>
          __$$CloseSessionResponseImplCopyWithImpl<_$CloseSessionResponseImpl>(
              this, _$identity);
}

abstract class _CloseSessionResponse implements CloseSessionResponse {
  const factory _CloseSessionResponse(
      {required final String sessionId,
      required final String sessionName,
      required final String sessionType,
      required final String closedAt}) = _$CloseSessionResponseImpl;

  @override
  String get sessionId;
  @override
  String get sessionName;
  @override
  String get sessionType;
  @override
  String get closedAt;

  /// Create a copy of CloseSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CloseSessionResponseImplCopyWith<_$CloseSessionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
