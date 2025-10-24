// Presentation State: Inventory Page State
// Manages UI state for inventory management page using Freezed

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/inventory_metadata.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/value_objects/pagination_params.dart';

part 'inventory_page_state.freezed.dart';

@freezed
class InventoryPageState with _$InventoryPageState {
  const factory InventoryPageState({
    // Products list
    @Default([]) List<Product> products,

    // Loading states
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,

    // Error state
    String? error,

    // Pagination
    @Default(PaginationResult(
      page: 1,
      limit: 10,
      total: 0,
      totalPages: 1,
      hasNext: false,
      hasPrevious: false,
    )) PaginationResult pagination,

    // Filters
    String? searchQuery,
    String? selectedCategoryId,
    String? selectedBrandId,
    String? selectedStockStatus,

    // Sorting
    String? sortBy,
    String? sortDirection,

    // Currency info
    Currency? currency,
  }) = _InventoryPageState;


  const InventoryPageState._();

  // Helper getters
  bool get hasFilters =>
      searchQuery != null ||
      selectedCategoryId != null ||
      selectedBrandId != null ||
      selectedStockStatus != null;

  int get activeFilterCount {
    int count = 0;
    if (searchQuery != null && searchQuery!.isNotEmpty) count++;
    if (selectedCategoryId != null) count++;
    if (selectedBrandId != null) count++;
    if (selectedStockStatus != null) count++;
    return count;
  }

  bool get hasError => error != null;
  bool get hasProducts => products.isNotEmpty;
  bool get isEmpty => !isLoading && products.isEmpty;
  bool get canLoadMore => pagination.hasNext && !isLoadingMore;
}
