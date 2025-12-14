import '../../domain/entities/inventory_metadata.dart';
import '../../domain/repositories/inventory_metadata_repository.dart';
import '../datasources/inventory_metadata_datasource.dart' hide InventoryMetadata,
    BrandMetadata, CategoryMetadata, ProductTypeMetadata, UnitMetadata,
    StatsMetadata, CurrencyMetadata, StoreInfoMetadata;
import '../models/inventory_metadata_model.dart';

/// Implementation of InventoryMetadataRepository
class InventoryMetadataRepositoryImpl implements InventoryMetadataRepository {
  final InventoryMetadataDataSource _dataSource;

  InventoryMetadataRepositoryImpl(this._dataSource);

  @override
  Future<InventoryMetadata> getInventoryMetadata({
    required String companyId,
    required String storeId,
  }) async {
    final response = await _dataSource.getInventoryMetadataRaw(
      companyId: companyId,
      storeId: storeId,
    );

    return InventoryMetadataModel.fromJson(response);
  }
}
