// Presentation State: Inventory Metadata State
// Manages inventory metadata (categories, brands, etc.) using Freezed

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/inventory_metadata.dart';

part 'inventory_metadata_state.freezed.dart';

@freezed
class InventoryMetadataState with _$InventoryMetadataState {
  const factory InventoryMetadataState({
    InventoryMetadata? metadata,
    @Default(false) bool isLoading,
    String? error,
  }) = _InventoryMetadataState;

  const InventoryMetadataState._();

  // Helper getters
  bool get hasMetadata => metadata != null;
  bool get hasError => error != null;
  bool get isEmpty => !isLoading && metadata == null;

  // Quick access to common metadata
  List<Category> get categories => metadata?.categories ?? [];
  List<Brand> get brands => metadata?.brands ?? [];
  Currency? get currency => metadata?.currency;
  InventoryStats? get stats => metadata?.stats;
  List<String> get units => metadata?.units ?? [];
}
