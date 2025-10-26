// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionHistoryState {
  /// List of transactions
  List<Transaction> get transactions => throw _privateConstructorUsedError;

  /// Loading state for initial fetch
  bool get isLoading => throw _privateConstructorUsedError;

  /// Loading state for loading more transactions (pagination)
  bool get isLoadingMore => throw _privateConstructorUsedError;

  /// Refreshing state
  bool get isRefreshing => throw _privateConstructorUsedError;

  /// Error message if any error occurred
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Whether there are more transactions to load
  bool get hasMore => throw _privateConstructorUsedError;

  /// Current offset for pagination
  int get currentOffset => throw _privateConstructorUsedError;

  /// Page size for pagination
  int get pageSize => throw _privateConstructorUsedError;

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionHistoryStateCopyWith<TransactionHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionHistoryStateCopyWith<$Res> {
  factory $TransactionHistoryStateCopyWith(TransactionHistoryState value,
          $Res Function(TransactionHistoryState) then) =
      _$TransactionHistoryStateCopyWithImpl<$Res, TransactionHistoryState>;
  @useResult
  $Res call(
      {List<Transaction> transactions,
      bool isLoading,
      bool isLoadingMore,
      bool isRefreshing,
      String? errorMessage,
      bool hasMore,
      int currentOffset,
      int pageSize});
}

/// @nodoc
class _$TransactionHistoryStateCopyWithImpl<$Res,
        $Val extends TransactionHistoryState>
    implements $TransactionHistoryStateCopyWith<$Res> {
  _$TransactionHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? hasMore = null,
    Object? currentOffset = null,
    Object? pageSize = null,
  }) {
    return _then(_value.copyWith(
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentOffset: null == currentOffset
          ? _value.currentOffset
          : currentOffset // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionHistoryStateImplCopyWith<$Res>
    implements $TransactionHistoryStateCopyWith<$Res> {
  factory _$$TransactionHistoryStateImplCopyWith(
          _$TransactionHistoryStateImpl value,
          $Res Function(_$TransactionHistoryStateImpl) then) =
      __$$TransactionHistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Transaction> transactions,
      bool isLoading,
      bool isLoadingMore,
      bool isRefreshing,
      String? errorMessage,
      bool hasMore,
      int currentOffset,
      int pageSize});
}

/// @nodoc
class __$$TransactionHistoryStateImplCopyWithImpl<$Res>
    extends _$TransactionHistoryStateCopyWithImpl<$Res,
        _$TransactionHistoryStateImpl>
    implements _$$TransactionHistoryStateImplCopyWith<$Res> {
  __$$TransactionHistoryStateImplCopyWithImpl(
      _$TransactionHistoryStateImpl _value,
      $Res Function(_$TransactionHistoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? hasMore = null,
    Object? currentOffset = null,
    Object? pageSize = null,
  }) {
    return _then(_$TransactionHistoryStateImpl(
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentOffset: null == currentOffset
          ? _value.currentOffset
          : currentOffset // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TransactionHistoryStateImpl extends _TransactionHistoryState {
  const _$TransactionHistoryStateImpl(
      {final List<Transaction> transactions = const [],
      this.isLoading = false,
      this.isLoadingMore = false,
      this.isRefreshing = false,
      this.errorMessage,
      this.hasMore = true,
      this.currentOffset = 0,
      this.pageSize = 20})
      : _transactions = transactions,
        super._();

  /// List of transactions
  final List<Transaction> _transactions;

  /// List of transactions
  @override
  @JsonKey()
  List<Transaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  /// Loading state for initial fetch
  @override
  @JsonKey()
  final bool isLoading;

  /// Loading state for loading more transactions (pagination)
  @override
  @JsonKey()
  final bool isLoadingMore;

  /// Refreshing state
  @override
  @JsonKey()
  final bool isRefreshing;

  /// Error message if any error occurred
  @override
  final String? errorMessage;

  /// Whether there are more transactions to load
  @override
  @JsonKey()
  final bool hasMore;

  /// Current offset for pagination
  @override
  @JsonKey()
  final int currentOffset;

  /// Page size for pagination
  @override
  @JsonKey()
  final int pageSize;

  @override
  String toString() {
    return 'TransactionHistoryState(transactions: $transactions, isLoading: $isLoading, isLoadingMore: $isLoadingMore, isRefreshing: $isRefreshing, errorMessage: $errorMessage, hasMore: $hasMore, currentOffset: $currentOffset, pageSize: $pageSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionHistoryStateImpl &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.currentOffset, currentOffset) ||
                other.currentOffset == currentOffset) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transactions),
      isLoading,
      isLoadingMore,
      isRefreshing,
      errorMessage,
      hasMore,
      currentOffset,
      pageSize);

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionHistoryStateImplCopyWith<_$TransactionHistoryStateImpl>
      get copyWith => __$$TransactionHistoryStateImplCopyWithImpl<
          _$TransactionHistoryStateImpl>(this, _$identity);
}

abstract class _TransactionHistoryState extends TransactionHistoryState {
  const factory _TransactionHistoryState(
      {final List<Transaction> transactions,
      final bool isLoading,
      final bool isLoadingMore,
      final bool isRefreshing,
      final String? errorMessage,
      final bool hasMore,
      final int currentOffset,
      final int pageSize}) = _$TransactionHistoryStateImpl;
  const _TransactionHistoryState._() : super._();

  /// List of transactions
  @override
  List<Transaction> get transactions;

  /// Loading state for initial fetch
  @override
  bool get isLoading;

  /// Loading state for loading more transactions (pagination)
  @override
  bool get isLoadingMore;

  /// Refreshing state
  @override
  bool get isRefreshing;

  /// Error message if any error occurred
  @override
  String? get errorMessage;

  /// Whether there are more transactions to load
  @override
  bool get hasMore;

  /// Current offset for pagination
  @override
  int get currentOffset;

  /// Page size for pagination
  @override
  int get pageSize;

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionHistoryStateImplCopyWith<_$TransactionHistoryStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GroupedTransactionsState {
  Map<String, List<Transaction>> get groupedByDate =>
      throw _privateConstructorUsedError;
  List<String> get sortedDates => throw _privateConstructorUsedError;

  /// Create a copy of GroupedTransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupedTransactionsStateCopyWith<GroupedTransactionsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupedTransactionsStateCopyWith<$Res> {
  factory $GroupedTransactionsStateCopyWith(GroupedTransactionsState value,
          $Res Function(GroupedTransactionsState) then) =
      _$GroupedTransactionsStateCopyWithImpl<$Res, GroupedTransactionsState>;
  @useResult
  $Res call(
      {Map<String, List<Transaction>> groupedByDate, List<String> sortedDates});
}

/// @nodoc
class _$GroupedTransactionsStateCopyWithImpl<$Res,
        $Val extends GroupedTransactionsState>
    implements $GroupedTransactionsStateCopyWith<$Res> {
  _$GroupedTransactionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupedTransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupedByDate = null,
    Object? sortedDates = null,
  }) {
    return _then(_value.copyWith(
      groupedByDate: null == groupedByDate
          ? _value.groupedByDate
          : groupedByDate // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Transaction>>,
      sortedDates: null == sortedDates
          ? _value.sortedDates
          : sortedDates // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupedTransactionsStateImplCopyWith<$Res>
    implements $GroupedTransactionsStateCopyWith<$Res> {
  factory _$$GroupedTransactionsStateImplCopyWith(
          _$GroupedTransactionsStateImpl value,
          $Res Function(_$GroupedTransactionsStateImpl) then) =
      __$$GroupedTransactionsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, List<Transaction>> groupedByDate, List<String> sortedDates});
}

/// @nodoc
class __$$GroupedTransactionsStateImplCopyWithImpl<$Res>
    extends _$GroupedTransactionsStateCopyWithImpl<$Res,
        _$GroupedTransactionsStateImpl>
    implements _$$GroupedTransactionsStateImplCopyWith<$Res> {
  __$$GroupedTransactionsStateImplCopyWithImpl(
      _$GroupedTransactionsStateImpl _value,
      $Res Function(_$GroupedTransactionsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupedTransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupedByDate = null,
    Object? sortedDates = null,
  }) {
    return _then(_$GroupedTransactionsStateImpl(
      groupedByDate: null == groupedByDate
          ? _value._groupedByDate
          : groupedByDate // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Transaction>>,
      sortedDates: null == sortedDates
          ? _value._sortedDates
          : sortedDates // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$GroupedTransactionsStateImpl implements _GroupedTransactionsState {
  const _$GroupedTransactionsStateImpl(
      {final Map<String, List<Transaction>> groupedByDate = const {},
      final List<String> sortedDates = const []})
      : _groupedByDate = groupedByDate,
        _sortedDates = sortedDates;

  final Map<String, List<Transaction>> _groupedByDate;
  @override
  @JsonKey()
  Map<String, List<Transaction>> get groupedByDate {
    if (_groupedByDate is EqualUnmodifiableMapView) return _groupedByDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_groupedByDate);
  }

  final List<String> _sortedDates;
  @override
  @JsonKey()
  List<String> get sortedDates {
    if (_sortedDates is EqualUnmodifiableListView) return _sortedDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sortedDates);
  }

  @override
  String toString() {
    return 'GroupedTransactionsState(groupedByDate: $groupedByDate, sortedDates: $sortedDates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupedTransactionsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._groupedByDate, _groupedByDate) &&
            const DeepCollectionEquality()
                .equals(other._sortedDates, _sortedDates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_groupedByDate),
      const DeepCollectionEquality().hash(_sortedDates));

  /// Create a copy of GroupedTransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupedTransactionsStateImplCopyWith<_$GroupedTransactionsStateImpl>
      get copyWith => __$$GroupedTransactionsStateImplCopyWithImpl<
          _$GroupedTransactionsStateImpl>(this, _$identity);
}

abstract class _GroupedTransactionsState implements GroupedTransactionsState {
  const factory _GroupedTransactionsState(
      {final Map<String, List<Transaction>> groupedByDate,
      final List<String> sortedDates}) = _$GroupedTransactionsStateImpl;

  @override
  Map<String, List<Transaction>> get groupedByDate;
  @override
  List<String> get sortedDates;

  /// Create a copy of GroupedTransactionsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupedTransactionsStateImplCopyWith<_$GroupedTransactionsStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
