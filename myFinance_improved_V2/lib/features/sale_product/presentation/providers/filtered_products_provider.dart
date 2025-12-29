import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sales_product.dart';
import 'sales_product_provider.dart';

/// Filtered products provider
///
/// Returns products in server order (SKU-based from RPC).
/// Only applies local search filter when needed.
final filteredProductsProvider = Provider<List<SalesProduct>>((ref) {
  final salesState = ref.watch(salesProductNotifierProvider);
  final products = salesState.products;
  final searchQuery = salesState.searchQuery;

  // If no search query, return server-ordered products as-is
  if (searchQuery.isEmpty) {
    return products;
  }

  // Apply local search filter only
  final searchLower = searchQuery.toLowerCase();
  return products.where((product) {
    return product.productName.toLowerCase().contains(searchLower) ||
        product.sku.toLowerCase().contains(searchLower);
  }).toList();
});
