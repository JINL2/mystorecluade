import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/inventory_metadata_datasource.dart';

/// Provider for InventoryMetadataDataSource
final inventoryMetadataDataSourceProvider =
    Provider<InventoryMetadataDataSource>((ref) {
  return InventoryMetadataDataSource(Supabase.instance.client);
});

/// Provider to fetch inventory metadata including brands, categories, etc.
final inventoryMetadataProvider =
    StateNotifierProvider<InventoryMetadataNotifier, InventoryMetadataState>(
        (ref) {
  final dataSource = ref.watch(inventoryMetadataDataSourceProvider);
  return InventoryMetadataNotifier(ref, dataSource);
});

/// State for inventory metadata
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
  final InventoryMetadataDataSource _dataSource;

  InventoryMetadataNotifier(this.ref, this._dataSource)
      : super(const InventoryMetadataState());

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

      final metadata = await _dataSource.getInventoryMetadata(
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
