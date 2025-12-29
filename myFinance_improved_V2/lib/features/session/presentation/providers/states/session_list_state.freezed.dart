// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionListState {
  List<SessionListItem> get sessions => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String get sessionType => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Create a copy of SessionListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionListStateCopyWith<SessionListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionListStateCopyWith<$Res> {
  factory $SessionListStateCopyWith(
          SessionListState value, $Res Function(SessionListState) then) =
      _$SessionListStateCopyWithImpl<$Res, SessionListState>;
  @useResult
  $Res call(
      {List<SessionListItem> sessions,
      bool isLoading,
      String? error,
      String sessionType,
      int totalCount,
      bool hasMore});
}

/// @nodoc
class _$SessionListStateCopyWithImpl<$Res, $Val extends SessionListState>
    implements $SessionListStateCopyWith<$Res> {
  _$SessionListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? sessionType = null,
    Object? totalCount = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      sessions: null == sessions
          ? _value.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionListItem>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionListStateImplCopyWith<$Res>
    implements $SessionListStateCopyWith<$Res> {
  factory _$$SessionListStateImplCopyWith(_$SessionListStateImpl value,
          $Res Function(_$SessionListStateImpl) then) =
      __$$SessionListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SessionListItem> sessions,
      bool isLoading,
      String? error,
      String sessionType,
      int totalCount,
      bool hasMore});
}

/// @nodoc
class __$$SessionListStateImplCopyWithImpl<$Res>
    extends _$SessionListStateCopyWithImpl<$Res, _$SessionListStateImpl>
    implements _$$SessionListStateImplCopyWith<$Res> {
  __$$SessionListStateImplCopyWithImpl(_$SessionListStateImpl _value,
      $Res Function(_$SessionListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? sessionType = null,
    Object? totalCount = null,
    Object? hasMore = null,
  }) {
    return _then(_$SessionListStateImpl(
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionListItem>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SessionListStateImpl extends _SessionListState {
  const _$SessionListStateImpl(
      {final List<SessionListItem> sessions = const [],
      this.isLoading = false,
      this.error,
      required this.sessionType,
      this.totalCount = 0,
      this.hasMore = false})
      : _sessions = sessions,
        super._();

  final List<SessionListItem> _sessions;
  @override
  @JsonKey()
  List<SessionListItem> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final String sessionType;
  @override
  @JsonKey()
  final int totalCount;
  @override
  @JsonKey()
  final bool hasMore;

  @override
  String toString() {
    return 'SessionListState(sessions: $sessions, isLoading: $isLoading, error: $error, sessionType: $sessionType, totalCount: $totalCount, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionListStateImpl &&
            const DeepCollectionEquality().equals(other._sessions, _sessions) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sessions),
      isLoading,
      error,
      sessionType,
      totalCount,
      hasMore);

  /// Create a copy of SessionListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionListStateImplCopyWith<_$SessionListStateImpl> get copyWith =>
      __$$SessionListStateImplCopyWithImpl<_$SessionListStateImpl>(
          this, _$identity);
}

abstract class _SessionListState extends SessionListState {
  const factory _SessionListState(
      {final List<SessionListItem> sessions,
      final bool isLoading,
      final String? error,
      required final String sessionType,
      final int totalCount,
      final bool hasMore}) = _$SessionListStateImpl;
  const _SessionListState._() : super._();

  @override
  List<SessionListItem> get sessions;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String get sessionType;
  @override
  int get totalCount;
  @override
  bool get hasMore;

  /// Create a copy of SessionListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionListStateImplCopyWith<_$SessionListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
