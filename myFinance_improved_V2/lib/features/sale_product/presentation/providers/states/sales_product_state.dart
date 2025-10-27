import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/sales_product.dart';
import '../../../domain/value_objects/sort_option.dart';

part 'sales_product_state.freezed.dart';

/// Sales Product Page State - UI state for sales product page
///
/// Manages product list, loading state, error handling, and search/sort.
@freezed
class SalesProductState with _$SalesProductState {
  const factory SalesProductState({
    @Default([]) List<SalesProduct> products,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    @Default('') String searchQuery,
    @Default(SortOption.nameAsc) SortOption sortOption,
    @Default(1) int currentPage,
    @Default(false) bool hasNextPage,
  }) = _SalesProductState;
}

/// Cart State - UI state for shopping cart
///
/// Simple cart management without business logic.
@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default(false) bool isProcessing,
    String? errorMessage,
  }) = _CartState;
}
