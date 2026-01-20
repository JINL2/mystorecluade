// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_products.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaginatedProducts {
  /// 상품 목록
  List<InventoryProduct> get items => throw _privateConstructorUsedError;

  /// 전체 개수
  int get totalCount => throw _privateConstructorUsedError;

  /// 현재 페이지 (0-indexed)
  int get page => throw _privateConstructorUsedError;

  /// 페이지 크기
  int get pageSize => throw _privateConstructorUsedError;

  /// 더 있는지
  bool get hasMore => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedProducts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedProductsCopyWith<PaginatedProducts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedProductsCopyWith<$Res> {
  factory $PaginatedProductsCopyWith(
          PaginatedProducts value, $Res Function(PaginatedProducts) then) =
      _$PaginatedProductsCopyWithImpl<$Res, PaginatedProducts>;
  @useResult
  $Res call(
      {List<InventoryProduct> items,
      int totalCount,
      int page,
      int pageSize,
      bool hasMore});
}

/// @nodoc
class _$PaginatedProductsCopyWithImpl<$Res, $Val extends PaginatedProducts>
    implements $PaginatedProductsCopyWith<$Res> {
  _$PaginatedProductsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedProducts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalCount = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<InventoryProduct>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedProductsImplCopyWith<$Res>
    implements $PaginatedProductsCopyWith<$Res> {
  factory _$$PaginatedProductsImplCopyWith(_$PaginatedProductsImpl value,
          $Res Function(_$PaginatedProductsImpl) then) =
      __$$PaginatedProductsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<InventoryProduct> items,
      int totalCount,
      int page,
      int pageSize,
      bool hasMore});
}

/// @nodoc
class __$$PaginatedProductsImplCopyWithImpl<$Res>
    extends _$PaginatedProductsCopyWithImpl<$Res, _$PaginatedProductsImpl>
    implements _$$PaginatedProductsImplCopyWith<$Res> {
  __$$PaginatedProductsImplCopyWithImpl(_$PaginatedProductsImpl _value,
      $Res Function(_$PaginatedProductsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedProducts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalCount = null,
    Object? page = null,
    Object? pageSize = null,
    Object? hasMore = null,
  }) {
    return _then(_$PaginatedProductsImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<InventoryProduct>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PaginatedProductsImpl extends _PaginatedProducts {
  const _$PaginatedProductsImpl(
      {required final List<InventoryProduct> items,
      required this.totalCount,
      required this.page,
      required this.pageSize,
      required this.hasMore})
      : _items = items,
        super._();

  /// 상품 목록
  final List<InventoryProduct> _items;

  /// 상품 목록
  @override
  List<InventoryProduct> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// 전체 개수
  @override
  final int totalCount;

  /// 현재 페이지 (0-indexed)
  @override
  final int page;

  /// 페이지 크기
  @override
  final int pageSize;

  /// 더 있는지
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'PaginatedProducts(items: $items, totalCount: $totalCount, page: $page, pageSize: $pageSize, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedProductsImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      totalCount,
      page,
      pageSize,
      hasMore);

  /// Create a copy of PaginatedProducts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedProductsImplCopyWith<_$PaginatedProductsImpl> get copyWith =>
      __$$PaginatedProductsImplCopyWithImpl<_$PaginatedProductsImpl>(
          this, _$identity);
}

abstract class _PaginatedProducts extends PaginatedProducts {
  const factory _PaginatedProducts(
      {required final List<InventoryProduct> items,
      required final int totalCount,
      required final int page,
      required final int pageSize,
      required final bool hasMore}) = _$PaginatedProductsImpl;
  const _PaginatedProducts._() : super._();

  /// 상품 목록
  @override
  List<InventoryProduct> get items;

  /// 전체 개수
  @override
  int get totalCount;

  /// 현재 페이지 (0-indexed)
  @override
  int get page;

  /// 페이지 크기
  @override
  int get pageSize;

  /// 더 있는지
  @override
  bool get hasMore;

  /// Create a copy of PaginatedProducts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedProductsImplCopyWith<_$PaginatedProductsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
