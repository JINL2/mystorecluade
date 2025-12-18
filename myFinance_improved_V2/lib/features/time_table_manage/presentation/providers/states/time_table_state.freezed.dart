// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_table_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlyShiftStatusState {
  Map<String, List<MonthlyShiftStatus>> get dataByMonth =>
      throw _privateConstructorUsedError;
  Set<String> get loadedMonths => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyShiftStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyShiftStatusStateCopyWith<MonthlyShiftStatusState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyShiftStatusStateCopyWith<$Res> {
  factory $MonthlyShiftStatusStateCopyWith(MonthlyShiftStatusState value,
          $Res Function(MonthlyShiftStatusState) then) =
      _$MonthlyShiftStatusStateCopyWithImpl<$Res, MonthlyShiftStatusState>;
  @useResult
  $Res call(
      {Map<String, List<MonthlyShiftStatus>> dataByMonth,
      Set<String> loadedMonths,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$MonthlyShiftStatusStateCopyWithImpl<$Res,
        $Val extends MonthlyShiftStatusState>
    implements $MonthlyShiftStatusStateCopyWith<$Res> {
  _$MonthlyShiftStatusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyShiftStatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataByMonth = null,
    Object? loadedMonths = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      dataByMonth: null == dataByMonth
          ? _value.dataByMonth
          : dataByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, List<MonthlyShiftStatus>>,
      loadedMonths: null == loadedMonths
          ? _value.loadedMonths
          : loadedMonths // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyShiftStatusStateImplCopyWith<$Res>
    implements $MonthlyShiftStatusStateCopyWith<$Res> {
  factory _$$MonthlyShiftStatusStateImplCopyWith(
          _$MonthlyShiftStatusStateImpl value,
          $Res Function(_$MonthlyShiftStatusStateImpl) then) =
      __$$MonthlyShiftStatusStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, List<MonthlyShiftStatus>> dataByMonth,
      Set<String> loadedMonths,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$MonthlyShiftStatusStateImplCopyWithImpl<$Res>
    extends _$MonthlyShiftStatusStateCopyWithImpl<$Res,
        _$MonthlyShiftStatusStateImpl>
    implements _$$MonthlyShiftStatusStateImplCopyWith<$Res> {
  __$$MonthlyShiftStatusStateImplCopyWithImpl(
      _$MonthlyShiftStatusStateImpl _value,
      $Res Function(_$MonthlyShiftStatusStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyShiftStatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataByMonth = null,
    Object? loadedMonths = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$MonthlyShiftStatusStateImpl(
      dataByMonth: null == dataByMonth
          ? _value._dataByMonth
          : dataByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, List<MonthlyShiftStatus>>,
      loadedMonths: null == loadedMonths
          ? _value._loadedMonths
          : loadedMonths // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MonthlyShiftStatusStateImpl extends _MonthlyShiftStatusState {
  const _$MonthlyShiftStatusStateImpl(
      {final Map<String, List<MonthlyShiftStatus>> dataByMonth = const {},
      final Set<String> loadedMonths = const {},
      this.isLoading = false,
      this.error})
      : _dataByMonth = dataByMonth,
        _loadedMonths = loadedMonths,
        super._();

  final Map<String, List<MonthlyShiftStatus>> _dataByMonth;
  @override
  @JsonKey()
  Map<String, List<MonthlyShiftStatus>> get dataByMonth {
    if (_dataByMonth is EqualUnmodifiableMapView) return _dataByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dataByMonth);
  }

  final Set<String> _loadedMonths;
  @override
  @JsonKey()
  Set<String> get loadedMonths {
    if (_loadedMonths is EqualUnmodifiableSetView) return _loadedMonths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_loadedMonths);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'MonthlyShiftStatusState(dataByMonth: $dataByMonth, loadedMonths: $loadedMonths, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyShiftStatusStateImpl &&
            const DeepCollectionEquality()
                .equals(other._dataByMonth, _dataByMonth) &&
            const DeepCollectionEquality()
                .equals(other._loadedMonths, _loadedMonths) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_dataByMonth),
      const DeepCollectionEquality().hash(_loadedMonths),
      isLoading,
      error);

  /// Create a copy of MonthlyShiftStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyShiftStatusStateImplCopyWith<_$MonthlyShiftStatusStateImpl>
      get copyWith => __$$MonthlyShiftStatusStateImplCopyWithImpl<
          _$MonthlyShiftStatusStateImpl>(this, _$identity);
}

abstract class _MonthlyShiftStatusState extends MonthlyShiftStatusState {
  const factory _MonthlyShiftStatusState(
      {final Map<String, List<MonthlyShiftStatus>> dataByMonth,
      final Set<String> loadedMonths,
      final bool isLoading,
      final String? error}) = _$MonthlyShiftStatusStateImpl;
  const _MonthlyShiftStatusState._() : super._();

  @override
  Map<String, List<MonthlyShiftStatus>> get dataByMonth;
  @override
  Set<String> get loadedMonths;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of MonthlyShiftStatusState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyShiftStatusStateImplCopyWith<_$MonthlyShiftStatusStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ManagerOverviewState {
  Map<String, ManagerOverview> get dataByMonth =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ManagerOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerOverviewStateCopyWith<ManagerOverviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerOverviewStateCopyWith<$Res> {
  factory $ManagerOverviewStateCopyWith(ManagerOverviewState value,
          $Res Function(ManagerOverviewState) then) =
      _$ManagerOverviewStateCopyWithImpl<$Res, ManagerOverviewState>;
  @useResult
  $Res call(
      {Map<String, ManagerOverview> dataByMonth,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$ManagerOverviewStateCopyWithImpl<$Res,
        $Val extends ManagerOverviewState>
    implements $ManagerOverviewStateCopyWith<$Res> {
  _$ManagerOverviewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataByMonth = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      dataByMonth: null == dataByMonth
          ? _value.dataByMonth
          : dataByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, ManagerOverview>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerOverviewStateImplCopyWith<$Res>
    implements $ManagerOverviewStateCopyWith<$Res> {
  factory _$$ManagerOverviewStateImplCopyWith(_$ManagerOverviewStateImpl value,
          $Res Function(_$ManagerOverviewStateImpl) then) =
      __$$ManagerOverviewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, ManagerOverview> dataByMonth,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$ManagerOverviewStateImplCopyWithImpl<$Res>
    extends _$ManagerOverviewStateCopyWithImpl<$Res, _$ManagerOverviewStateImpl>
    implements _$$ManagerOverviewStateImplCopyWith<$Res> {
  __$$ManagerOverviewStateImplCopyWithImpl(_$ManagerOverviewStateImpl _value,
      $Res Function(_$ManagerOverviewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataByMonth = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$ManagerOverviewStateImpl(
      dataByMonth: null == dataByMonth
          ? _value._dataByMonth
          : dataByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, ManagerOverview>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ManagerOverviewStateImpl implements _ManagerOverviewState {
  const _$ManagerOverviewStateImpl(
      {final Map<String, ManagerOverview> dataByMonth = const {},
      this.isLoading = false,
      this.error})
      : _dataByMonth = dataByMonth;

  final Map<String, ManagerOverview> _dataByMonth;
  @override
  @JsonKey()
  Map<String, ManagerOverview> get dataByMonth {
    if (_dataByMonth is EqualUnmodifiableMapView) return _dataByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dataByMonth);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'ManagerOverviewState(dataByMonth: $dataByMonth, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerOverviewStateImpl &&
            const DeepCollectionEquality()
                .equals(other._dataByMonth, _dataByMonth) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_dataByMonth), isLoading, error);

  /// Create a copy of ManagerOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerOverviewStateImplCopyWith<_$ManagerOverviewStateImpl>
      get copyWith =>
          __$$ManagerOverviewStateImplCopyWithImpl<_$ManagerOverviewStateImpl>(
              this, _$identity);
}

abstract class _ManagerOverviewState implements ManagerOverviewState {
  const factory _ManagerOverviewState(
      {final Map<String, ManagerOverview> dataByMonth,
      final bool isLoading,
      final String? error}) = _$ManagerOverviewStateImpl;

  @override
  Map<String, ManagerOverview> get dataByMonth;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of ManagerOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerOverviewStateImplCopyWith<_$ManagerOverviewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ManagerShiftCardsState {
  Map<String, ManagerShiftCards> get dataByMonth =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ManagerShiftCardsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerShiftCardsStateCopyWith<ManagerShiftCardsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerShiftCardsStateCopyWith<$Res> {
  factory $ManagerShiftCardsStateCopyWith(ManagerShiftCardsState value,
          $Res Function(ManagerShiftCardsState) then) =
      _$ManagerShiftCardsStateCopyWithImpl<$Res, ManagerShiftCardsState>;
  @useResult
  $Res call(
      {Map<String, ManagerShiftCards> dataByMonth,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$ManagerShiftCardsStateCopyWithImpl<$Res,
        $Val extends ManagerShiftCardsState>
    implements $ManagerShiftCardsStateCopyWith<$Res> {
  _$ManagerShiftCardsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerShiftCardsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataByMonth = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      dataByMonth: null == dataByMonth
          ? _value.dataByMonth
          : dataByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, ManagerShiftCards>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerShiftCardsStateImplCopyWith<$Res>
    implements $ManagerShiftCardsStateCopyWith<$Res> {
  factory _$$ManagerShiftCardsStateImplCopyWith(
          _$ManagerShiftCardsStateImpl value,
          $Res Function(_$ManagerShiftCardsStateImpl) then) =
      __$$ManagerShiftCardsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, ManagerShiftCards> dataByMonth,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$ManagerShiftCardsStateImplCopyWithImpl<$Res>
    extends _$ManagerShiftCardsStateCopyWithImpl<$Res,
        _$ManagerShiftCardsStateImpl>
    implements _$$ManagerShiftCardsStateImplCopyWith<$Res> {
  __$$ManagerShiftCardsStateImplCopyWithImpl(
      _$ManagerShiftCardsStateImpl _value,
      $Res Function(_$ManagerShiftCardsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerShiftCardsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataByMonth = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$ManagerShiftCardsStateImpl(
      dataByMonth: null == dataByMonth
          ? _value._dataByMonth
          : dataByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, ManagerShiftCards>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ManagerShiftCardsStateImpl implements _ManagerShiftCardsState {
  const _$ManagerShiftCardsStateImpl(
      {final Map<String, ManagerShiftCards> dataByMonth = const {},
      this.isLoading = false,
      this.error})
      : _dataByMonth = dataByMonth;

  final Map<String, ManagerShiftCards> _dataByMonth;
  @override
  @JsonKey()
  Map<String, ManagerShiftCards> get dataByMonth {
    if (_dataByMonth is EqualUnmodifiableMapView) return _dataByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dataByMonth);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'ManagerShiftCardsState(dataByMonth: $dataByMonth, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerShiftCardsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._dataByMonth, _dataByMonth) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_dataByMonth), isLoading, error);

  /// Create a copy of ManagerShiftCardsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerShiftCardsStateImplCopyWith<_$ManagerShiftCardsStateImpl>
      get copyWith => __$$ManagerShiftCardsStateImplCopyWithImpl<
          _$ManagerShiftCardsStateImpl>(this, _$identity);
}

abstract class _ManagerShiftCardsState implements ManagerShiftCardsState {
  const factory _ManagerShiftCardsState(
      {final Map<String, ManagerShiftCards> dataByMonth,
      final bool isLoading,
      final String? error}) = _$ManagerShiftCardsStateImpl;

  @override
  Map<String, ManagerShiftCards> get dataByMonth;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of ManagerShiftCardsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerShiftCardsStateImplCopyWith<_$ManagerShiftCardsStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SelectedShiftRequestsState {
  Set<String> get selectedIds => throw _privateConstructorUsedError;
  Map<String, bool> get approvalStates => throw _privateConstructorUsedError;
  Map<String, String> get requestIds => throw _privateConstructorUsedError;

  /// Create a copy of SelectedShiftRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectedShiftRequestsStateCopyWith<SelectedShiftRequestsState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedShiftRequestsStateCopyWith<$Res> {
  factory $SelectedShiftRequestsStateCopyWith(SelectedShiftRequestsState value,
          $Res Function(SelectedShiftRequestsState) then) =
      _$SelectedShiftRequestsStateCopyWithImpl<$Res,
          SelectedShiftRequestsState>;
  @useResult
  $Res call(
      {Set<String> selectedIds,
      Map<String, bool> approvalStates,
      Map<String, String> requestIds});
}

/// @nodoc
class _$SelectedShiftRequestsStateCopyWithImpl<$Res,
        $Val extends SelectedShiftRequestsState>
    implements $SelectedShiftRequestsStateCopyWith<$Res> {
  _$SelectedShiftRequestsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectedShiftRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedIds = null,
    Object? approvalStates = null,
    Object? requestIds = null,
  }) {
    return _then(_value.copyWith(
      selectedIds: null == selectedIds
          ? _value.selectedIds
          : selectedIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      approvalStates: null == approvalStates
          ? _value.approvalStates
          : approvalStates // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      requestIds: null == requestIds
          ? _value.requestIds
          : requestIds // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectedShiftRequestsStateImplCopyWith<$Res>
    implements $SelectedShiftRequestsStateCopyWith<$Res> {
  factory _$$SelectedShiftRequestsStateImplCopyWith(
          _$SelectedShiftRequestsStateImpl value,
          $Res Function(_$SelectedShiftRequestsStateImpl) then) =
      __$$SelectedShiftRequestsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<String> selectedIds,
      Map<String, bool> approvalStates,
      Map<String, String> requestIds});
}

/// @nodoc
class __$$SelectedShiftRequestsStateImplCopyWithImpl<$Res>
    extends _$SelectedShiftRequestsStateCopyWithImpl<$Res,
        _$SelectedShiftRequestsStateImpl>
    implements _$$SelectedShiftRequestsStateImplCopyWith<$Res> {
  __$$SelectedShiftRequestsStateImplCopyWithImpl(
      _$SelectedShiftRequestsStateImpl _value,
      $Res Function(_$SelectedShiftRequestsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SelectedShiftRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedIds = null,
    Object? approvalStates = null,
    Object? requestIds = null,
  }) {
    return _then(_$SelectedShiftRequestsStateImpl(
      selectedIds: null == selectedIds
          ? _value._selectedIds
          : selectedIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      approvalStates: null == approvalStates
          ? _value._approvalStates
          : approvalStates // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      requestIds: null == requestIds
          ? _value._requestIds
          : requestIds // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$SelectedShiftRequestsStateImpl implements _SelectedShiftRequestsState {
  const _$SelectedShiftRequestsStateImpl(
      {final Set<String> selectedIds = const {},
      final Map<String, bool> approvalStates = const {},
      final Map<String, String> requestIds = const {}})
      : _selectedIds = selectedIds,
        _approvalStates = approvalStates,
        _requestIds = requestIds;

  final Set<String> _selectedIds;
  @override
  @JsonKey()
  Set<String> get selectedIds {
    if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedIds);
  }

  final Map<String, bool> _approvalStates;
  @override
  @JsonKey()
  Map<String, bool> get approvalStates {
    if (_approvalStates is EqualUnmodifiableMapView) return _approvalStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_approvalStates);
  }

  final Map<String, String> _requestIds;
  @override
  @JsonKey()
  Map<String, String> get requestIds {
    if (_requestIds is EqualUnmodifiableMapView) return _requestIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_requestIds);
  }

  @override
  String toString() {
    return 'SelectedShiftRequestsState(selectedIds: $selectedIds, approvalStates: $approvalStates, requestIds: $requestIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedShiftRequestsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._selectedIds, _selectedIds) &&
            const DeepCollectionEquality()
                .equals(other._approvalStates, _approvalStates) &&
            const DeepCollectionEquality()
                .equals(other._requestIds, _requestIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_selectedIds),
      const DeepCollectionEquality().hash(_approvalStates),
      const DeepCollectionEquality().hash(_requestIds));

  /// Create a copy of SelectedShiftRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedShiftRequestsStateImplCopyWith<_$SelectedShiftRequestsStateImpl>
      get copyWith => __$$SelectedShiftRequestsStateImplCopyWithImpl<
          _$SelectedShiftRequestsStateImpl>(this, _$identity);
}

abstract class _SelectedShiftRequestsState
    implements SelectedShiftRequestsState {
  const factory _SelectedShiftRequestsState(
      {final Set<String> selectedIds,
      final Map<String, bool> approvalStates,
      final Map<String, String> requestIds}) = _$SelectedShiftRequestsStateImpl;

  @override
  Set<String> get selectedIds;
  @override
  Map<String, bool> get approvalStates;
  @override
  Map<String, String> get requestIds;

  /// Create a copy of SelectedShiftRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectedShiftRequestsStateImplCopyWith<_$SelectedShiftRequestsStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
