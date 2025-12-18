// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShiftPageState {
  List<StoreShift> get shifts => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  int get selectedTabIndex => throw _privateConstructorUsedError;

  /// Create a copy of ShiftPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftPageStateCopyWith<ShiftPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftPageStateCopyWith<$Res> {
  factory $ShiftPageStateCopyWith(
          ShiftPageState value, $Res Function(ShiftPageState) then) =
      _$ShiftPageStateCopyWithImpl<$Res, ShiftPageState>;
  @useResult
  $Res call(
      {List<StoreShift> shifts,
      bool isLoading,
      bool isRefreshing,
      String? errorMessage,
      String? searchQuery,
      int selectedTabIndex});
}

/// @nodoc
class _$ShiftPageStateCopyWithImpl<$Res, $Val extends ShiftPageState>
    implements $ShiftPageStateCopyWith<$Res> {
  _$ShiftPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shifts = null,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? searchQuery = freezed,
    Object? selectedTabIndex = null,
  }) {
    return _then(_value.copyWith(
      shifts: null == shifts
          ? _value.shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<StoreShift>,
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
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTabIndex: null == selectedTabIndex
          ? _value.selectedTabIndex
          : selectedTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftPageStateImplCopyWith<$Res>
    implements $ShiftPageStateCopyWith<$Res> {
  factory _$$ShiftPageStateImplCopyWith(_$ShiftPageStateImpl value,
          $Res Function(_$ShiftPageStateImpl) then) =
      __$$ShiftPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<StoreShift> shifts,
      bool isLoading,
      bool isRefreshing,
      String? errorMessage,
      String? searchQuery,
      int selectedTabIndex});
}

/// @nodoc
class __$$ShiftPageStateImplCopyWithImpl<$Res>
    extends _$ShiftPageStateCopyWithImpl<$Res, _$ShiftPageStateImpl>
    implements _$$ShiftPageStateImplCopyWith<$Res> {
  __$$ShiftPageStateImplCopyWithImpl(
      _$ShiftPageStateImpl _value, $Res Function(_$ShiftPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shifts = null,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? searchQuery = freezed,
    Object? selectedTabIndex = null,
  }) {
    return _then(_$ShiftPageStateImpl(
      shifts: null == shifts
          ? _value._shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<StoreShift>,
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
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTabIndex: null == selectedTabIndex
          ? _value.selectedTabIndex
          : selectedTabIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ShiftPageStateImpl implements _ShiftPageState {
  const _$ShiftPageStateImpl(
      {final List<StoreShift> shifts = const [],
      this.isLoading = false,
      this.isRefreshing = false,
      this.errorMessage,
      this.searchQuery,
      this.selectedTabIndex = 0})
      : _shifts = shifts;

  final List<StoreShift> _shifts;
  @override
  @JsonKey()
  List<StoreShift> get shifts {
    if (_shifts is EqualUnmodifiableListView) return _shifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shifts);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  final String? errorMessage;
  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final int selectedTabIndex;

  @override
  String toString() {
    return 'ShiftPageState(shifts: $shifts, isLoading: $isLoading, isRefreshing: $isRefreshing, errorMessage: $errorMessage, searchQuery: $searchQuery, selectedTabIndex: $selectedTabIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftPageStateImpl &&
            const DeepCollectionEquality().equals(other._shifts, _shifts) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedTabIndex, selectedTabIndex) ||
                other.selectedTabIndex == selectedTabIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_shifts),
      isLoading,
      isRefreshing,
      errorMessage,
      searchQuery,
      selectedTabIndex);

  /// Create a copy of ShiftPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftPageStateImplCopyWith<_$ShiftPageStateImpl> get copyWith =>
      __$$ShiftPageStateImplCopyWithImpl<_$ShiftPageStateImpl>(
          this, _$identity);
}

abstract class _ShiftPageState implements ShiftPageState {
  const factory _ShiftPageState(
      {final List<StoreShift> shifts,
      final bool isLoading,
      final bool isRefreshing,
      final String? errorMessage,
      final String? searchQuery,
      final int selectedTabIndex}) = _$ShiftPageStateImpl;

  @override
  List<StoreShift> get shifts;
  @override
  bool get isLoading;
  @override
  bool get isRefreshing;
  @override
  String? get errorMessage;
  @override
  String? get searchQuery;
  @override
  int get selectedTabIndex;

  /// Create a copy of ShiftPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftPageStateImplCopyWith<_$ShiftPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShiftFilterState {
  String get searchText => throw _privateConstructorUsedError;
  String get timeFilter =>
      throw _privateConstructorUsedError; // all, morning, afternoon, evening, night
  bool get showActiveOnly => throw _privateConstructorUsedError;

  /// Create a copy of ShiftFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftFilterStateCopyWith<ShiftFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftFilterStateCopyWith<$Res> {
  factory $ShiftFilterStateCopyWith(
          ShiftFilterState value, $Res Function(ShiftFilterState) then) =
      _$ShiftFilterStateCopyWithImpl<$Res, ShiftFilterState>;
  @useResult
  $Res call({String searchText, String timeFilter, bool showActiveOnly});
}

/// @nodoc
class _$ShiftFilterStateCopyWithImpl<$Res, $Val extends ShiftFilterState>
    implements $ShiftFilterStateCopyWith<$Res> {
  _$ShiftFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchText = null,
    Object? timeFilter = null,
    Object? showActiveOnly = null,
  }) {
    return _then(_value.copyWith(
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      timeFilter: null == timeFilter
          ? _value.timeFilter
          : timeFilter // ignore: cast_nullable_to_non_nullable
              as String,
      showActiveOnly: null == showActiveOnly
          ? _value.showActiveOnly
          : showActiveOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftFilterStateImplCopyWith<$Res>
    implements $ShiftFilterStateCopyWith<$Res> {
  factory _$$ShiftFilterStateImplCopyWith(_$ShiftFilterStateImpl value,
          $Res Function(_$ShiftFilterStateImpl) then) =
      __$$ShiftFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String searchText, String timeFilter, bool showActiveOnly});
}

/// @nodoc
class __$$ShiftFilterStateImplCopyWithImpl<$Res>
    extends _$ShiftFilterStateCopyWithImpl<$Res, _$ShiftFilterStateImpl>
    implements _$$ShiftFilterStateImplCopyWith<$Res> {
  __$$ShiftFilterStateImplCopyWithImpl(_$ShiftFilterStateImpl _value,
      $Res Function(_$ShiftFilterStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchText = null,
    Object? timeFilter = null,
    Object? showActiveOnly = null,
  }) {
    return _then(_$ShiftFilterStateImpl(
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      timeFilter: null == timeFilter
          ? _value.timeFilter
          : timeFilter // ignore: cast_nullable_to_non_nullable
              as String,
      showActiveOnly: null == showActiveOnly
          ? _value.showActiveOnly
          : showActiveOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ShiftFilterStateImpl extends _ShiftFilterState {
  const _$ShiftFilterStateImpl(
      {this.searchText = '',
      this.timeFilter = 'all',
      this.showActiveOnly = true})
      : super._();

  @override
  @JsonKey()
  final String searchText;
  @override
  @JsonKey()
  final String timeFilter;
// all, morning, afternoon, evening, night
  @override
  @JsonKey()
  final bool showActiveOnly;

  @override
  String toString() {
    return 'ShiftFilterState(searchText: $searchText, timeFilter: $timeFilter, showActiveOnly: $showActiveOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftFilterStateImpl &&
            (identical(other.searchText, searchText) ||
                other.searchText == searchText) &&
            (identical(other.timeFilter, timeFilter) ||
                other.timeFilter == timeFilter) &&
            (identical(other.showActiveOnly, showActiveOnly) ||
                other.showActiveOnly == showActiveOnly));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, searchText, timeFilter, showActiveOnly);

  /// Create a copy of ShiftFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftFilterStateImplCopyWith<_$ShiftFilterStateImpl> get copyWith =>
      __$$ShiftFilterStateImplCopyWithImpl<_$ShiftFilterStateImpl>(
          this, _$identity);
}

abstract class _ShiftFilterState extends ShiftFilterState {
  const factory _ShiftFilterState(
      {final String searchText,
      final String timeFilter,
      final bool showActiveOnly}) = _$ShiftFilterStateImpl;
  const _ShiftFilterState._() : super._();

  @override
  String get searchText;
  @override
  String get timeFilter; // all, morning, afternoon, evening, night
  @override
  bool get showActiveOnly;

  /// Create a copy of ShiftFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftFilterStateImplCopyWith<_$ShiftFilterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
