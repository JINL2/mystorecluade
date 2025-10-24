// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_creation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvoiceCreationState {
  ProductListResult? get productData => throw _privateConstructorUsedError;
  Map<String, int> get selectedProducts => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceCreationStateCopyWith<InvoiceCreationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCreationStateCopyWith<$Res> {
  factory $InvoiceCreationStateCopyWith(InvoiceCreationState value,
          $Res Function(InvoiceCreationState) then) =
      _$InvoiceCreationStateCopyWithImpl<$Res, InvoiceCreationState>;
  @useResult
  $Res call(
      {ProductListResult? productData,
      Map<String, int> selectedProducts,
      bool isLoading,
      String? error,
      String searchQuery});
}

/// @nodoc
class _$InvoiceCreationStateCopyWithImpl<$Res,
        $Val extends InvoiceCreationState>
    implements $InvoiceCreationStateCopyWith<$Res> {
  _$InvoiceCreationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productData = freezed,
    Object? selectedProducts = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
  }) {
    return _then(_value.copyWith(
      productData: freezed == productData
          ? _value.productData
          : productData // ignore: cast_nullable_to_non_nullable
              as ProductListResult?,
      selectedProducts: null == selectedProducts
          ? _value.selectedProducts
          : selectedProducts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceCreationStateImplCopyWith<$Res>
    implements $InvoiceCreationStateCopyWith<$Res> {
  factory _$$InvoiceCreationStateImplCopyWith(_$InvoiceCreationStateImpl value,
          $Res Function(_$InvoiceCreationStateImpl) then) =
      __$$InvoiceCreationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ProductListResult? productData,
      Map<String, int> selectedProducts,
      bool isLoading,
      String? error,
      String searchQuery});
}

/// @nodoc
class __$$InvoiceCreationStateImplCopyWithImpl<$Res>
    extends _$InvoiceCreationStateCopyWithImpl<$Res, _$InvoiceCreationStateImpl>
    implements _$$InvoiceCreationStateImplCopyWith<$Res> {
  __$$InvoiceCreationStateImplCopyWithImpl(_$InvoiceCreationStateImpl _value,
      $Res Function(_$InvoiceCreationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InvoiceCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productData = freezed,
    Object? selectedProducts = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
  }) {
    return _then(_$InvoiceCreationStateImpl(
      productData: freezed == productData
          ? _value.productData
          : productData // ignore: cast_nullable_to_non_nullable
              as ProductListResult?,
      selectedProducts: null == selectedProducts
          ? _value._selectedProducts
          : selectedProducts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InvoiceCreationStateImpl extends _InvoiceCreationState {
  const _$InvoiceCreationStateImpl(
      {this.productData,
      final Map<String, int> selectedProducts = const {},
      this.isLoading = false,
      this.error,
      this.searchQuery = ''})
      : _selectedProducts = selectedProducts,
        super._();

  @override
  final ProductListResult? productData;
  final Map<String, int> _selectedProducts;
  @override
  @JsonKey()
  Map<String, int> get selectedProducts {
    if (_selectedProducts is EqualUnmodifiableMapView) return _selectedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selectedProducts);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final String searchQuery;

  @override
  String toString() {
    return 'InvoiceCreationState(productData: $productData, selectedProducts: $selectedProducts, isLoading: $isLoading, error: $error, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceCreationStateImpl &&
            (identical(other.productData, productData) ||
                other.productData == productData) &&
            const DeepCollectionEquality()
                .equals(other._selectedProducts, _selectedProducts) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productData,
      const DeepCollectionEquality().hash(_selectedProducts),
      isLoading,
      error,
      searchQuery);

  /// Create a copy of InvoiceCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceCreationStateImplCopyWith<_$InvoiceCreationStateImpl>
      get copyWith =>
          __$$InvoiceCreationStateImplCopyWithImpl<_$InvoiceCreationStateImpl>(
              this, _$identity);
}

abstract class _InvoiceCreationState extends InvoiceCreationState {
  const factory _InvoiceCreationState(
      {final ProductListResult? productData,
      final Map<String, int> selectedProducts,
      final bool isLoading,
      final String? error,
      final String searchQuery}) = _$InvoiceCreationStateImpl;
  const _InvoiceCreationState._() : super._();

  @override
  ProductListResult? get productData;
  @override
  Map<String, int> get selectedProducts;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String get searchQuery;

  /// Create a copy of InvoiceCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceCreationStateImplCopyWith<_$InvoiceCreationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
