import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sales_product.dart';
import 'sales_product_provider.dart';
import 'use_case_providers.dart';

/// Filtered and sorted products provider
///
/// Automatically recomputes only when dependencies change:
/// - products list
/// - search query
/// - sort option
final filteredProductsProvider = Provider<List<SalesProduct>>((ref) {
  final salesState = ref.watch(salesProductProvider);
  final filterUseCase = ref.watch(filterProductsUseCaseProvider);

  // This computation is memoized - only runs when dependencies change
  return filterUseCase.execute(
    products: salesState.products,
    searchQuery: salesState.searchQuery,
    sortOption: salesState.sortOption,
  );
});
