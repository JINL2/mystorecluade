// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InventoryPageState {
// Products list
  List<Product> get products =>
      throw _privateConstructorUsedError; // Loading states
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError; // Error state
  String? get error => throw _privateConstructorUsedError; // Pagination
  PaginationResult get pagination =>
      throw _privateConstructorUsedError; // Filters
  String? get searchQuery => throw _privateConstructorUsedError;
  String? get selectedCategoryId => throw _privateConstructorUsedError;
  String? get selectedBrandId => throw _privateConstructorUsedError;
  String? get selectedStockStatus =>
      throw _privateConstructorUsedError; // Sorting
  String? get sortBy => throw _privateConstructorUsedError;
  String? get sortDirection =>
      throw _privateConstructorUsedError; // Currency info
  Currency? get currency => throw _privateConstructorUsedError;

  /// Create a copy of InventoryPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryPageStateCopyWith<InventoryPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryPageStateCopyWith<$Res> {
  factory $InventoryPageStateCopyWith(
          InventoryPageState value, $Res Function(InventoryPageState) then) =
      _$InventoryPageStateCopyWithImpl<$Res, InventoryPageState>;
  @useResult
  $Res call(
      {List<Product> products,
      bool isLoading,
      bool isLoadingMore,
      String? error,
      PaginationResult pagination,
      String? searchQuery,
      String? selectedCategoryId,
      String? selectedBrandId,
      String? selectedStockStatus,
      String? sortBy,
      String? sortDirection,
      Currency? currency});
}

/// @nodoc
class _$InventoryPageStateCopyWithImpl<$Res, $Val extends InventoryPageState>
    implements $InventoryPageStateCopyWith<$Res> {
  _$InventoryPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
    Object? pagination = null,
    Object? searchQuery = freezed,
    Object? selectedCategoryId = freezed,
    Object? selectedBrandId = freezed,
    Object? selectedStockStatus = freezed,
    Object? sortBy = freezed,
    Object? sortDirection = freezed,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
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
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationResult,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCategoryId: freezed == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedBrandId: freezed == selectedBrandId
          ? _value.selectedBrandId
          : selectedBrandId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStockStatus: freezed == selectedStockStatus
          ? _value.selectedStockStatus
          : selectedStockStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortDirection: freezed == sortDirection
          ? _value.sortDirection
          : sortDirection // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryPageStateImplCopyWith<$Res>
    implements $InventoryPageStateCopyWith<$Res> {
  factory _$$InventoryPageStateImplCopyWith(_$InventoryPageStateImpl value,
          $Res Function(_$InventoryPageStateImpl) then) =
      __$$InventoryPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Product> products,
      bool isLoading,
      bool isLoadingMore,
      String? error,
      PaginationResult pagination,
      String? searchQuery,
      String? selectedCategoryId,
      String? selectedBrandId,
      String? selectedStockStatus,
      String? sortBy,
      String? sortDirection,
      Currency? currency});
}

/// @nodoc
class __$$InventoryPageStateImplCopyWithImpl<$Res>
    extends _$InventoryPageStateCopyWithImpl<$Res, _$InventoryPageStateImpl>
    implements _$$InventoryPageStateImplCopyWith<$Res> {
  __$$InventoryPageStateImplCopyWithImpl(_$InventoryPageStateImpl _value,
      $Res Function(_$InventoryPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
    Object? pagination = null,
    Object? searchQuery = freezed,
    Object? selectedCategoryId = freezed,
    Object? selectedBrandId = freezed,
    Object? selectedStockStatus = freezed,
    Object? sortBy = freezed,
    Object? sortDirection = freezed,
    Object? currency = freezed,
  }) {
    return _then(_$InventoryPageStateImpl(
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
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
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationResult,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCategoryId: freezed == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedBrandId: freezed == selectedBrandId
          ? _value.selectedBrandId
          : selectedBrandId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedStockStatus: freezed == selectedStockStatus
          ? _value.selectedStockStatus
          : selectedStockStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortDirection: freezed == sortDirection
          ? _value.sortDirection
          : sortDirection // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency?,
    ));
  }
}

/// @nodoc

class _$InventoryPageStateImpl extends _InventoryPageState {
  const _$InventoryPageStateImpl(
      {final List<Product> products = const [],
      this.isLoading = false,
      this.isLoadingMore = false,
      this.error,
      this.pagination = const PaginationResult(
          page: 1,
          limit: 10,
          total: 0,
          totalPages: 1,
          hasNext: false,
          hasPrevious: false),
      this.searchQuery,
      this.selectedCategoryId,
      this.selectedBrandId,
      this.selectedStockStatus,
      this.sortBy,
      this.sortDirection,
      this.currency})
      : _products = products,
        super._();

// Products list
  final List<Product> _products;
// Products list
  @override
  @JsonKey()
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

// Loading states
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
// Error state
  @override
  final String? error;
// Pagination
  @override
  @JsonKey()
  final PaginationResult pagination;
// Filters
  @override
  final String? searchQuery;
  @override
  final String? selectedCategoryId;
  @override
  final String? selectedBrandId;
  @override
  final String? selectedStockStatus;
// Sorting
  @override
  final String? sortBy;
  @override
  final String? sortDirection;
// Currency info
  @override
  final Currency? currency;

  @override
  String toString() {
    return 'InventoryPageState(products: $products, isLoading: $isLoading, isLoadingMore: $isLoadingMore, error: $error, pagination: $pagination, searchQuery: $searchQuery, selectedCategoryId: $selectedCategoryId, selectedBrandId: $selectedBrandId, selectedStockStatus: $selectedStockStatus, sortBy: $sortBy, sortDirection: $sortDirection, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryPageStateImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.selectedBrandId, selectedBrandId) ||
                other.selectedBrandId == selectedBrandId) &&
            (identical(other.selectedStockStatus, selectedStockStatus) ||
                other.selectedStockStatus == selectedStockStatus) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortDirection, sortDirection) ||
                other.sortDirection == sortDirection) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      isLoading,
      isLoadingMore,
      error,
      pagination,
      searchQuery,
      selectedCategoryId,
      selectedBrandId,
      selectedStockStatus,
      sortBy,
      sortDirection,
      currency);

  /// Create a copy of InventoryPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryPageStateImplCopyWith<_$InventoryPageStateImpl> get copyWith =>
      __$$InventoryPageStateImplCopyWithImpl<_$InventoryPageStateImpl>(
          this, _$identity);
}

abstract class _InventoryPageState extends InventoryPageState {
  const factory _InventoryPageState(
      {final List<Product> products,
      final bool isLoading,
      final bool isLoadingMore,
      final String? error,
      final PaginationResult pagination,
      final String? searchQuery,
      final String? selectedCategoryId,
      final String? selectedBrandId,
      final String? selectedStockStatus,
      final String? sortBy,
      final String? sortDirection,
      final Currency? currency}) = _$InventoryPageStateImpl;
  const _InventoryPageState._() : super._();

// Products list
  @override
  List<Product> get products; // Loading states
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore; // Error state
  @override
  String? get error; // Pagination
  @override
  PaginationResult get pagination; // Filters
  @override
  String? get searchQuery;
  @override
  String? get selectedCategoryId;
  @override
  String? get selectedBrandId;
  @override
  String? get selectedStockStatus; // Sorting
  @override
  String? get sortBy;
  @override
  String? get sortDirection; // Currency info
  @override
  Currency? get currency;

  /// Create a copy of InventoryPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryPageStateImplCopyWith<_$InventoryPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
