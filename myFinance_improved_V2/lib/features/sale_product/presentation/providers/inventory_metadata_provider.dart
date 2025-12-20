import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/entities/inventory_metadata.dart';

/// Provider to fetch inventory metadata including brands, categories, etc.
final inventoryMetadataProvider =
    StateNotifierProvider<InventoryMetadataNotifier, InventoryMetadataState>(
        (ref) {
  return InventoryMetadataNotifier(ref);
});

/// State for inventory metadata
/// NOTE: Consider using Freezed for consistency with SalesProductState
class InventoryMetadataState {
  final InventoryMetadata? metadata;
  final bool isLoading;
  final String? errorMessage;

  const InventoryMetadataState({
    this.metadata,
    this.isLoading = false,
    this.errorMessage,
  });

  InventoryMetadataState copyWith({
    InventoryMetadata? metadata,
    bool? isLoading,
    String? errorMessage,
  }) {
    return InventoryMetadataState(
      metadata: metadata ?? this.metadata,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  /// Get brand names for display (with "All" prepended)
  List<String> get brandNames {
    if (metadata == null || metadata!.brands.isEmpty) {
      return ['All'];
    }
    return ['All', ...metadata!.brands.map((b) => b.brandName)];
  }

  /// Get brands with product count > 0
  List<BrandMetadata> get activeBrands {
    if (metadata == null) return [];
    return metadata!.brands.where((b) => b.productCount > 0).toList();
  }
}

/// Notifier for inventory metadata
class InventoryMetadataNotifier extends StateNotifier<InventoryMetadataState> {
  final Ref ref;

  InventoryMetadataNotifier(this.ref) : super(const InventoryMetadataState());

  /// Load inventory metadata
  Future<void> loadMetadata() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please select a company and store first',
        );
        return;
      }

      final repository = ref.read(inventoryMetadataRepositoryProvider);
      final metadata = await repository.getInventoryMetadata(
        companyId: companyId,
        storeId: storeId,
      );

      state = state.copyWith(
        metadata: metadata,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading metadata: $e',
      );
    }
  }

  /// Refresh metadata
  Future<void> refresh() async {
    await loadMetadata();
  }
}
