// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionHistoryState {
  List<SessionHistoryItem> get sessions => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  int get currentOffset => throw _privateConstructorUsedError;
  SessionHistoryFilterState get filter => throw _privateConstructorUsedError;

  /// Create a copy of SessionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHistoryStateCopyWith<SessionHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHistoryStateCopyWith<$Res> {
  factory $SessionHistoryStateCopyWith(
          SessionHistoryState value, $Res Function(SessionHistoryState) then) =
      _$SessionHistoryStateCopyWithImpl<$Res, SessionHistoryState>;
  @useResult
  $Res call(
      {List<SessionHistoryItem> sessions,
      bool isLoading,
      bool isLoadingMore,
      String? error,
      int totalCount,
      bool hasMore,
      int currentOffset,
      SessionHistoryFilterState filter});
}

/// @nodoc
class _$SessionHistoryStateCopyWithImpl<$Res, $Val extends SessionHistoryState>
    implements $SessionHistoryStateCopyWith<$Res> {
  _$SessionHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
    Object? totalCount = null,
    Object? hasMore = null,
    Object? currentOffset = null,
    Object? filter = null,
  }) {
    return _then(_value.copyWith(
      sessions: null == sessions
          ? _value.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryItem>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentOffset: null == currentOffset
          ? _value.currentOffset
          : currentOffset // ignore: cast_nullable_to_non_nullable
              as int,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as SessionHistoryFilterState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionHistoryStateImplCopyWith<$Res>
    implements $SessionHistoryStateCopyWith<$Res> {
  factory _$$SessionHistoryStateImplCopyWith(_$SessionHistoryStateImpl value,
          $Res Function(_$SessionHistoryStateImpl) then) =
      __$$SessionHistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SessionHistoryItem> sessions,
      bool isLoading,
      bool isLoadingMore,
      String? error,
      int totalCount,
      bool hasMore,
      int currentOffset,
      SessionHistoryFilterState filter});
}

/// @nodoc
class __$$SessionHistoryStateImplCopyWithImpl<$Res>
    extends _$SessionHistoryStateCopyWithImpl<$Res, _$SessionHistoryStateImpl>
    implements _$$SessionHistoryStateImplCopyWith<$Res> {
  __$$SessionHistoryStateImplCopyWithImpl(_$SessionHistoryStateImpl _value,
      $Res Function(_$SessionHistoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
    Object? totalCount = null,
    Object? hasMore = null,
    Object? currentOffset = null,
    Object? filter = null,
  }) {
    return _then(_$SessionHistoryStateImpl(
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryItem>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentOffset: null == currentOffset
          ? _value.currentOffset
          : currentOffset // ignore: cast_nullable_to_non_nullable
              as int,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as SessionHistoryFilterState,
    ));
  }
}

/// @nodoc

class _$SessionHistoryStateImpl extends _SessionHistoryState {
  const _$SessionHistoryStateImpl(
      {final List<SessionHistoryItem> sessions = const [],
      this.isLoading = false,
      this.isLoadingMore = false,
      this.error,
      this.totalCount = 0,
      this.hasMore = false,
      this.currentOffset = 0,
      required this.filter})
      : _sessions = sessions,
        super._();

  final List<SessionHistoryItem> _sessions;
  @override
  @JsonKey()
  List<SessionHistoryItem> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  final String? error;
  @override
  @JsonKey()
  final int totalCount;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final int currentOffset;
  @override
  final SessionHistoryFilterState filter;

  @override
  String toString() {
    return 'SessionHistoryState(sessions: $sessions, isLoading: $isLoading, isLoadingMore: $isLoadingMore, error: $error, totalCount: $totalCount, hasMore: $hasMore, currentOffset: $currentOffset, filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHistoryStateImpl &&
            const DeepCollectionEquality().equals(other._sessions, _sessions) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.currentOffset, currentOffset) ||
                other.currentOffset == currentOffset) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sessions),
      isLoading,
      isLoadingMore,
      error,
      totalCount,
      hasMore,
      currentOffset,
      filter);

  /// Create a copy of SessionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHistoryStateImplCopyWith<_$SessionHistoryStateImpl> get copyWith =>
      __$$SessionHistoryStateImplCopyWithImpl<_$SessionHistoryStateImpl>(
          this, _$identity);
}

abstract class _SessionHistoryState extends SessionHistoryState {
  const factory _SessionHistoryState(
          {final List<SessionHistoryItem> sessions,
          final bool isLoading,
          final bool isLoadingMore,
          final String? error,
          final int totalCount,
          final bool hasMore,
          final int currentOffset,
          required final SessionHistoryFilterState filter}) =
      _$SessionHistoryStateImpl;
  const _SessionHistoryState._() : super._();

  @override
  List<SessionHistoryItem> get sessions;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  String? get error;
  @override
  int get totalCount;
  @override
  bool get hasMore;
  @override
  int get currentOffset;
  @override
  SessionHistoryFilterState get filter;

  /// Create a copy of SessionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHistoryStateImplCopyWith<_$SessionHistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
