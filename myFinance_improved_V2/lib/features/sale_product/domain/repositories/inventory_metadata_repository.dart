import '../entities/inventory_metadata.dart';

/// Repository interface for inventory metadata
abstract class InventoryMetadataRepository {
  /// Get inventory metadata for a company and store
  Future<InventoryMetadata> getInventoryMetadata({
    required String companyId,
    required String storeId,
  });
}
