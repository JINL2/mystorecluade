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
    // 2025 Best Practice: Start with isLoading=true to show loading on first frame
    // This prevents flash of empty content before data loads
    @Default(true) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    @Default('') String searchQuery,
    @Default(SortOption.nameAsc) SortOption sortOption,
    @Default(1) int currentPage,
    @Default(15) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasNextPage,
  }) = _SalesProductState;

  const SalesProductState._();

  /// Check if more pages can be loaded
  bool get canLoadMore => hasNextPage && !isLoadingMore;
}
