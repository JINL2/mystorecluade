import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/entities/inventory_metadata.dart';

part 'inventory_metadata_provider.g.dart';

/// Provider to fetch inventory metadata including brands, categories, etc.
///
/// Uses @riverpod for automatic code generation and better type safety.
/// Returns AsyncValue<InventoryMetadata?> for loading/error states.
@riverpod
class InventoryMetadataNotifier extends _$InventoryMetadataNotifier {
  @override
  Future<InventoryMetadata?> build() async {
    // Initial load - returns null if not loaded yet
    return null;
  }

  /// Load inventory metadata
  Future<void> loadMetadata() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        throw Exception('Please select a company and store first');
      }

      final repository = ref.read(inventoryMetadataRepositoryProvider);
      final metadata = await repository.getInventoryMetadata(
        companyId: companyId,
        storeId: storeId,
      );

      return metadata;
    });
  }

  /// Refresh metadata
  Future<void> refresh() async {
    await loadMetadata();
  }
}

/// Extension on AsyncValue<InventoryMetadata?> for convenience methods
extension InventoryMetadataAsyncValueExtension on AsyncValue<InventoryMetadata?> {
  /// Get brand names for display (with "All" prepended)
  List<String> get brandNames {
    final metadata = valueOrNull;
    if (metadata == null || metadata.brands.isEmpty) {
      return ['All'];
    }
    return ['All', ...metadata.brands.map((b) => b.brandName)];
  }

  /// Get brands with product count > 0
  List<BrandMetadata> get activeBrands {
    final metadata = valueOrNull;
    if (metadata == null) return [];
    return metadata.brands.where((b) => b.productCount > 0).toList();
  }
}
