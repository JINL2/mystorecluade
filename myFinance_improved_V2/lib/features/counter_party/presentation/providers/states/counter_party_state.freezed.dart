// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_party_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CounterPartyPageState {
  List<CounterParty> get counterParties => throw _privateConstructorUsedError;
  CounterPartyStats? get stats => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  CounterPartyFilter get filter => throw _privateConstructorUsedError;
  DateTime? get lastFetchedAt => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyPageStateCopyWith<CounterPartyPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyPageStateCopyWith<$Res> {
  factory $CounterPartyPageStateCopyWith(CounterPartyPageState value,
          $Res Function(CounterPartyPageState) then) =
      _$CounterPartyPageStateCopyWithImpl<$Res, CounterPartyPageState>;
  @useResult
  $Res call(
      {List<CounterParty> counterParties,
      CounterPartyStats? stats,
      bool isLoading,
      bool isRefreshing,
      String? errorMessage,
      String searchQuery,
      CounterPartyFilter filter,
      DateTime? lastFetchedAt});

  $CounterPartyStatsCopyWith<$Res>? get stats;
  $CounterPartyFilterCopyWith<$Res> get filter;
}

/// @nodoc
class _$CounterPartyPageStateCopyWithImpl<$Res,
        $Val extends CounterPartyPageState>
    implements $CounterPartyPageStateCopyWith<$Res> {
  _$CounterPartyPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterParties = null,
    Object? stats = freezed,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? searchQuery = null,
    Object? filter = null,
    Object? lastFetchedAt = freezed,
  }) {
    return _then(_value.copyWith(
      counterParties: null == counterParties
          ? _value.counterParties
          : counterParties // ignore: cast_nullable_to_non_nullable
              as List<CounterParty>,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as CounterPartyStats?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as CounterPartyFilter,
      lastFetchedAt: freezed == lastFetchedAt
          ? _value.lastFetchedAt
          : lastFetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of CounterPartyPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CounterPartyStatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $CounterPartyStatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  /// Create a copy of CounterPartyPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CounterPartyFilterCopyWith<$Res> get filter {
    return $CounterPartyFilterCopyWith<$Res>(_value.filter, (value) {
      return _then(_value.copyWith(filter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CounterPartyPageStateImplCopyWith<$Res>
    implements $CounterPartyPageStateCopyWith<$Res> {
  factory _$$CounterPartyPageStateImplCopyWith(
          _$CounterPartyPageStateImpl value,
          $Res Function(_$CounterPartyPageStateImpl) then) =
      __$$CounterPartyPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CounterParty> counterParties,
      CounterPartyStats? stats,
      bool isLoading,
      bool isRefreshing,
      String? errorMessage,
      String searchQuery,
      CounterPartyFilter filter,
      DateTime? lastFetchedAt});

  @override
  $CounterPartyStatsCopyWith<$Res>? get stats;
  @override
  $CounterPartyFilterCopyWith<$Res> get filter;
}

/// @nodoc
class __$$CounterPartyPageStateImplCopyWithImpl<$Res>
    extends _$CounterPartyPageStateCopyWithImpl<$Res,
        _$CounterPartyPageStateImpl>
    implements _$$CounterPartyPageStateImplCopyWith<$Res> {
  __$$CounterPartyPageStateImplCopyWithImpl(_$CounterPartyPageStateImpl _value,
      $Res Function(_$CounterPartyPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterParties = null,
    Object? stats = freezed,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? searchQuery = null,
    Object? filter = null,
    Object? lastFetchedAt = freezed,
  }) {
    return _then(_$CounterPartyPageStateImpl(
      counterParties: null == counterParties
          ? _value._counterParties
          : counterParties // ignore: cast_nullable_to_non_nullable
              as List<CounterParty>,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as CounterPartyStats?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as CounterPartyFilter,
      lastFetchedAt: freezed == lastFetchedAt
          ? _value.lastFetchedAt
          : lastFetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CounterPartyPageStateImpl extends _CounterPartyPageState {
  const _$CounterPartyPageStateImpl(
      {final List<CounterParty> counterParties = const [],
      this.stats,
      this.isLoading = false,
      this.isRefreshing = false,
      this.errorMessage,
      this.searchQuery = '',
      this.filter = const CounterPartyFilter(),
      this.lastFetchedAt})
      : _counterParties = counterParties,
        super._();

  final List<CounterParty> _counterParties;
  @override
  @JsonKey()
  List<CounterParty> get counterParties {
    if (_counterParties is EqualUnmodifiableListView) return _counterParties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_counterParties);
  }

  @override
  final CounterPartyStats? stats;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final CounterPartyFilter filter;
  @override
  final DateTime? lastFetchedAt;

  @override
  String toString() {
    return 'CounterPartyPageState(counterParties: $counterParties, stats: $stats, isLoading: $isLoading, isRefreshing: $isRefreshing, errorMessage: $errorMessage, searchQuery: $searchQuery, filter: $filter, lastFetchedAt: $lastFetchedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyPageStateImpl &&
            const DeepCollectionEquality()
                .equals(other._counterParties, _counterParties) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.lastFetchedAt, lastFetchedAt) ||
                other.lastFetchedAt == lastFetchedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_counterParties),
      stats,
      isLoading,
      isRefreshing,
      errorMessage,
      searchQuery,
      filter,
      lastFetchedAt);

  /// Create a copy of CounterPartyPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyPageStateImplCopyWith<_$CounterPartyPageStateImpl>
      get copyWith => __$$CounterPartyPageStateImplCopyWithImpl<
          _$CounterPartyPageStateImpl>(this, _$identity);
}

abstract class _CounterPartyPageState extends CounterPartyPageState {
  const factory _CounterPartyPageState(
      {final List<CounterParty> counterParties,
      final CounterPartyStats? stats,
      final bool isLoading,
      final bool isRefreshing,
      final String? errorMessage,
      final String searchQuery,
      final CounterPartyFilter filter,
      final DateTime? lastFetchedAt}) = _$CounterPartyPageStateImpl;
  const _CounterPartyPageState._() : super._();

  @override
  List<CounterParty> get counterParties;
  @override
  CounterPartyStats? get stats;
  @override
  bool get isLoading;
  @override
  bool get isRefreshing;
  @override
  String? get errorMessage;
  @override
  String get searchQuery;
  @override
  CounterPartyFilter get filter;
  @override
  DateTime? get lastFetchedAt;

  /// Create a copy of CounterPartyPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyPageStateImplCopyWith<_$CounterPartyPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CounterPartyFormState {
  int get currentStep => throw _privateConstructorUsedError;
  int get totalSteps => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  bool get isValidating => throw _privateConstructorUsedError;
  CounterParty? get editingCounterParty => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<String, String> get fieldErrors => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyFormStateCopyWith<CounterPartyFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyFormStateCopyWith<$Res> {
  factory $CounterPartyFormStateCopyWith(CounterPartyFormState value,
          $Res Function(CounterPartyFormState) then) =
      _$CounterPartyFormStateCopyWithImpl<$Res, CounterPartyFormState>;
  @useResult
  $Res call(
      {int currentStep,
      int totalSteps,
      bool isSubmitting,
      bool isValidating,
      CounterParty? editingCounterParty,
      String? errorMessage,
      Map<String, String> fieldErrors,
      bool isSuccess});

  $CounterPartyCopyWith<$Res>? get editingCounterParty;
}

/// @nodoc
class _$CounterPartyFormStateCopyWithImpl<$Res,
        $Val extends CounterPartyFormState>
    implements $CounterPartyFormStateCopyWith<$Res> {
  _$CounterPartyFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? totalSteps = null,
    Object? isSubmitting = null,
    Object? isValidating = null,
    Object? editingCounterParty = freezed,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? isSuccess = null,
  }) {
    return _then(_value.copyWith(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _value.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      editingCounterParty: freezed == editingCounterParty
          ? _value.editingCounterParty
          : editingCounterParty // ignore: cast_nullable_to_non_nullable
              as CounterParty?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value.fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of CounterPartyFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CounterPartyCopyWith<$Res>? get editingCounterParty {
    if (_value.editingCounterParty == null) {
      return null;
    }

    return $CounterPartyCopyWith<$Res>(_value.editingCounterParty!, (value) {
      return _then(_value.copyWith(editingCounterParty: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CounterPartyFormStateImplCopyWith<$Res>
    implements $CounterPartyFormStateCopyWith<$Res> {
  factory _$$CounterPartyFormStateImplCopyWith(
          _$CounterPartyFormStateImpl value,
          $Res Function(_$CounterPartyFormStateImpl) then) =
      __$$CounterPartyFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentStep,
      int totalSteps,
      bool isSubmitting,
      bool isValidating,
      CounterParty? editingCounterParty,
      String? errorMessage,
      Map<String, String> fieldErrors,
      bool isSuccess});

  @override
  $CounterPartyCopyWith<$Res>? get editingCounterParty;
}

/// @nodoc
class __$$CounterPartyFormStateImplCopyWithImpl<$Res>
    extends _$CounterPartyFormStateCopyWithImpl<$Res,
        _$CounterPartyFormStateImpl>
    implements _$$CounterPartyFormStateImplCopyWith<$Res> {
  __$$CounterPartyFormStateImplCopyWithImpl(_$CounterPartyFormStateImpl _value,
      $Res Function(_$CounterPartyFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? totalSteps = null,
    Object? isSubmitting = null,
    Object? isValidating = null,
    Object? editingCounterParty = freezed,
    Object? errorMessage = freezed,
    Object? fieldErrors = null,
    Object? isSuccess = null,
  }) {
    return _then(_$CounterPartyFormStateImpl(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _value.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      editingCounterParty: freezed == editingCounterParty
          ? _value.editingCounterParty
          : editingCounterParty // ignore: cast_nullable_to_non_nullable
              as CounterParty?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CounterPartyFormStateImpl extends _CounterPartyFormState {
  const _$CounterPartyFormStateImpl(
      {this.currentStep = 0,
      this.totalSteps = 3,
      this.isSubmitting = false,
      this.isValidating = false,
      this.editingCounterParty,
      this.errorMessage,
      final Map<String, String> fieldErrors = const {},
      this.isSuccess = false})
      : _fieldErrors = fieldErrors,
        super._();

  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final int totalSteps;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final bool isValidating;
  @override
  final CounterParty? editingCounterParty;
  @override
  final String? errorMessage;
  final Map<String, String> _fieldErrors;
  @override
  @JsonKey()
  Map<String, String> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  @override
  @JsonKey()
  final bool isSuccess;

  @override
  String toString() {
    return 'CounterPartyFormState(currentStep: $currentStep, totalSteps: $totalSteps, isSubmitting: $isSubmitting, isValidating: $isValidating, editingCounterParty: $editingCounterParty, errorMessage: $errorMessage, fieldErrors: $fieldErrors, isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyFormStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.isValidating, isValidating) ||
                other.isValidating == isValidating) &&
            (identical(other.editingCounterParty, editingCounterParty) ||
                other.editingCounterParty == editingCounterParty) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentStep,
      totalSteps,
      isSubmitting,
      isValidating,
      editingCounterParty,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors),
      isSuccess);

  /// Create a copy of CounterPartyFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyFormStateImplCopyWith<_$CounterPartyFormStateImpl>
      get copyWith => __$$CounterPartyFormStateImplCopyWithImpl<
          _$CounterPartyFormStateImpl>(this, _$identity);
}

abstract class _CounterPartyFormState extends CounterPartyFormState {
  const factory _CounterPartyFormState(
      {final int currentStep,
      final int totalSteps,
      final bool isSubmitting,
      final bool isValidating,
      final CounterParty? editingCounterParty,
      final String? errorMessage,
      final Map<String, String> fieldErrors,
      final bool isSuccess}) = _$CounterPartyFormStateImpl;
  const _CounterPartyFormState._() : super._();

  @override
  int get currentStep;
  @override
  int get totalSteps;
  @override
  bool get isSubmitting;
  @override
  bool get isValidating;
  @override
  CounterParty? get editingCounterParty;
  @override
  String? get errorMessage;
  @override
  Map<String, String> get fieldErrors;
  @override
  bool get isSuccess;

  /// Create a copy of CounterPartyFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyFormStateImplCopyWith<_$CounterPartyFormStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CounterPartyListState {
  String? get selectedCounterPartyId => throw _privateConstructorUsedError;
  Set<String> get expandedItems => throw _privateConstructorUsedError;
  bool get isSelectionMode => throw _privateConstructorUsedError;
  Set<String> get selectedItems => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyListStateCopyWith<CounterPartyListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyListStateCopyWith<$Res> {
  factory $CounterPartyListStateCopyWith(CounterPartyListState value,
          $Res Function(CounterPartyListState) then) =
      _$CounterPartyListStateCopyWithImpl<$Res, CounterPartyListState>;
  @useResult
  $Res call(
      {String? selectedCounterPartyId,
      Set<String> expandedItems,
      bool isSelectionMode,
      Set<String> selectedItems});
}

/// @nodoc
class _$CounterPartyListStateCopyWithImpl<$Res,
        $Val extends CounterPartyListState>
    implements $CounterPartyListStateCopyWith<$Res> {
  _$CounterPartyListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCounterPartyId = freezed,
    Object? expandedItems = null,
    Object? isSelectionMode = null,
    Object? selectedItems = null,
  }) {
    return _then(_value.copyWith(
      selectedCounterPartyId: freezed == selectedCounterPartyId
          ? _value.selectedCounterPartyId
          : selectedCounterPartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      expandedItems: null == expandedItems
          ? _value.expandedItems
          : expandedItems // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedItems: null == selectedItems
          ? _value.selectedItems
          : selectedItems // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterPartyListStateImplCopyWith<$Res>
    implements $CounterPartyListStateCopyWith<$Res> {
  factory _$$CounterPartyListStateImplCopyWith(
          _$CounterPartyListStateImpl value,
          $Res Function(_$CounterPartyListStateImpl) then) =
      __$$CounterPartyListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? selectedCounterPartyId,
      Set<String> expandedItems,
      bool isSelectionMode,
      Set<String> selectedItems});
}

/// @nodoc
class __$$CounterPartyListStateImplCopyWithImpl<$Res>
    extends _$CounterPartyListStateCopyWithImpl<$Res,
        _$CounterPartyListStateImpl>
    implements _$$CounterPartyListStateImplCopyWith<$Res> {
  __$$CounterPartyListStateImplCopyWithImpl(_$CounterPartyListStateImpl _value,
      $Res Function(_$CounterPartyListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCounterPartyId = freezed,
    Object? expandedItems = null,
    Object? isSelectionMode = null,
    Object? selectedItems = null,
  }) {
    return _then(_$CounterPartyListStateImpl(
      selectedCounterPartyId: freezed == selectedCounterPartyId
          ? _value.selectedCounterPartyId
          : selectedCounterPartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      expandedItems: null == expandedItems
          ? _value._expandedItems
          : expandedItems // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedItems: null == selectedItems
          ? _value._selectedItems
          : selectedItems // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$CounterPartyListStateImpl extends _CounterPartyListState {
  const _$CounterPartyListStateImpl(
      {this.selectedCounterPartyId,
      final Set<String> expandedItems = const {},
      this.isSelectionMode = false,
      final Set<String> selectedItems = const {}})
      : _expandedItems = expandedItems,
        _selectedItems = selectedItems,
        super._();

  @override
  final String? selectedCounterPartyId;
  final Set<String> _expandedItems;
  @override
  @JsonKey()
  Set<String> get expandedItems {
    if (_expandedItems is EqualUnmodifiableSetView) return _expandedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_expandedItems);
  }

  @override
  @JsonKey()
  final bool isSelectionMode;
  final Set<String> _selectedItems;
  @override
  @JsonKey()
  Set<String> get selectedItems {
    if (_selectedItems is EqualUnmodifiableSetView) return _selectedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedItems);
  }

  @override
  String toString() {
    return 'CounterPartyListState(selectedCounterPartyId: $selectedCounterPartyId, expandedItems: $expandedItems, isSelectionMode: $isSelectionMode, selectedItems: $selectedItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyListStateImpl &&
            (identical(other.selectedCounterPartyId, selectedCounterPartyId) ||
                other.selectedCounterPartyId == selectedCounterPartyId) &&
            const DeepCollectionEquality()
                .equals(other._expandedItems, _expandedItems) &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedItems, _selectedItems));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedCounterPartyId,
      const DeepCollectionEquality().hash(_expandedItems),
      isSelectionMode,
      const DeepCollectionEquality().hash(_selectedItems));

  /// Create a copy of CounterPartyListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyListStateImplCopyWith<_$CounterPartyListStateImpl>
      get copyWith => __$$CounterPartyListStateImplCopyWithImpl<
          _$CounterPartyListStateImpl>(this, _$identity);
}

abstract class _CounterPartyListState extends CounterPartyListState {
  const factory _CounterPartyListState(
      {final String? selectedCounterPartyId,
      final Set<String> expandedItems,
      final bool isSelectionMode,
      final Set<String> selectedItems}) = _$CounterPartyListStateImpl;
  const _CounterPartyListState._() : super._();

  @override
  String? get selectedCounterPartyId;
  @override
  Set<String> get expandedItems;
  @override
  bool get isSelectionMode;
  @override
  Set<String> get selectedItems;

  /// Create a copy of CounterPartyListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyListStateImplCopyWith<_$CounterPartyListStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
