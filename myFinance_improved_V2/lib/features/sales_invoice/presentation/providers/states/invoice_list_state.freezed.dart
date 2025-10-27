// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvoiceListState {
  List<Invoice> get invoices => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  InvoicePageResult? get response => throw _privateConstructorUsedError;
  InvoicePeriod get selectedPeriod => throw _privateConstructorUsedError;
  InvoiceSortOption get sortBy => throw _privateConstructorUsedError;
  bool get sortAscending => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceListStateCopyWith<InvoiceListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceListStateCopyWith<$Res> {
  factory $InvoiceListStateCopyWith(
          InvoiceListState value, $Res Function(InvoiceListState) then) =
      _$InvoiceListStateCopyWithImpl<$Res, InvoiceListState>;
  @useResult
  $Res call(
      {List<Invoice> invoices,
      bool isLoading,
      String? error,
      InvoicePageResult? response,
      InvoicePeriod selectedPeriod,
      InvoiceSortOption sortBy,
      bool sortAscending,
      String searchQuery,
      int currentPage});
}

/// @nodoc
class _$InvoiceListStateCopyWithImpl<$Res, $Val extends InvoiceListState>
    implements $InvoiceListStateCopyWith<$Res> {
  _$InvoiceListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoices = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? response = freezed,
    Object? selectedPeriod = null,
    Object? sortBy = null,
    Object? sortAscending = null,
    Object? searchQuery = null,
    Object? currentPage = null,
  }) {
    return _then(_value.copyWith(
      invoices: null == invoices
          ? _value.invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<Invoice>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as InvoicePageResult?,
      selectedPeriod: null == selectedPeriod
          ? _value.selectedPeriod
          : selectedPeriod // ignore: cast_nullable_to_non_nullable
              as InvoicePeriod,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as InvoiceSortOption,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceListStateImplCopyWith<$Res>
    implements $InvoiceListStateCopyWith<$Res> {
  factory _$$InvoiceListStateImplCopyWith(_$InvoiceListStateImpl value,
          $Res Function(_$InvoiceListStateImpl) then) =
      __$$InvoiceListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Invoice> invoices,
      bool isLoading,
      String? error,
      InvoicePageResult? response,
      InvoicePeriod selectedPeriod,
      InvoiceSortOption sortBy,
      bool sortAscending,
      String searchQuery,
      int currentPage});
}

/// @nodoc
class __$$InvoiceListStateImplCopyWithImpl<$Res>
    extends _$InvoiceListStateCopyWithImpl<$Res, _$InvoiceListStateImpl>
    implements _$$InvoiceListStateImplCopyWith<$Res> {
  __$$InvoiceListStateImplCopyWithImpl(_$InvoiceListStateImpl _value,
      $Res Function(_$InvoiceListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoices = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? response = freezed,
    Object? selectedPeriod = null,
    Object? sortBy = null,
    Object? sortAscending = null,
    Object? searchQuery = null,
    Object? currentPage = null,
  }) {
    return _then(_$InvoiceListStateImpl(
      invoices: null == invoices
          ? _value._invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<Invoice>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as InvoicePageResult?,
      selectedPeriod: null == selectedPeriod
          ? _value.selectedPeriod
          : selectedPeriod // ignore: cast_nullable_to_non_nullable
              as InvoicePeriod,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as InvoiceSortOption,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$InvoiceListStateImpl extends _InvoiceListState {
  const _$InvoiceListStateImpl(
      {final List<Invoice> invoices = const [],
      this.isLoading = false,
      this.error,
      this.response,
      this.selectedPeriod = InvoicePeriod.allTime,
      this.sortBy = InvoiceSortOption.date,
      this.sortAscending = false,
      this.searchQuery = '',
      this.currentPage = 1})
      : _invoices = invoices,
        super._();

  final List<Invoice> _invoices;
  @override
  @JsonKey()
  List<Invoice> get invoices {
    if (_invoices is EqualUnmodifiableListView) return _invoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoices);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final InvoicePageResult? response;
  @override
  @JsonKey()
  final InvoicePeriod selectedPeriod;
  @override
  @JsonKey()
  final InvoiceSortOption sortBy;
  @override
  @JsonKey()
  final bool sortAscending;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final int currentPage;

  @override
  String toString() {
    return 'InvoiceListState(invoices: $invoices, isLoading: $isLoading, error: $error, response: $response, selectedPeriod: $selectedPeriod, sortBy: $sortBy, sortAscending: $sortAscending, searchQuery: $searchQuery, currentPage: $currentPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceListStateImpl &&
            const DeepCollectionEquality().equals(other._invoices, _invoices) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.selectedPeriod, selectedPeriod) ||
                other.selectedPeriod == selectedPeriod) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_invoices),
      isLoading,
      error,
      response,
      selectedPeriod,
      sortBy,
      sortAscending,
      searchQuery,
      currentPage);

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceListStateImplCopyWith<_$InvoiceListStateImpl> get copyWith =>
      __$$InvoiceListStateImplCopyWithImpl<_$InvoiceListStateImpl>(
          this, _$identity);
}

abstract class _InvoiceListState extends InvoiceListState {
  const factory _InvoiceListState(
      {final List<Invoice> invoices,
      final bool isLoading,
      final String? error,
      final InvoicePageResult? response,
      final InvoicePeriod selectedPeriod,
      final InvoiceSortOption sortBy,
      final bool sortAscending,
      final String searchQuery,
      final int currentPage}) = _$InvoiceListStateImpl;
  const _InvoiceListState._() : super._();

  @override
  List<Invoice> get invoices;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  InvoicePageResult? get response;
  @override
  InvoicePeriod get selectedPeriod;
  @override
  InvoiceSortOption get sortBy;
  @override
  bool get sortAscending;
  @override
  String get searchQuery;
  @override
  int get currentPage;

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceListStateImplCopyWith<_$InvoiceListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
