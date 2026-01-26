import '../../domain/entities/fixed_asset.dart';
import '../../domain/repositories/fixed_asset_repository.dart';
import '../datasources/fixed_asset_data_source.dart';
import '../models/fixed_asset_model.dart';

/// Fixed Asset Repository Implementation
/// Domain Repository 인터페이스 구현
class FixedAssetRepositoryImpl implements FixedAssetRepository {
  final FixedAssetDataSource _dataSource;

  FixedAssetRepositoryImpl(this._dataSource);

  @override
  Future<List<FixedAsset>> getFixedAssets({
    required String companyId,
    String? storeId,
  }) async {
    try {
      final models = await _dataSource.getFixedAssets(
        companyId: companyId,
        storeId: storeId,
      );

      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch fixed assets: $e');
    }
  }

  @override
  Future<String> createFixedAsset(FixedAsset asset, {required String timezone}) async {
    try {
      if (!asset.isValid) {
        throw Exception('Invalid asset data');
      }

      final model = FixedAssetModel.fromEntity(asset);
      return await _dataSource.createFixedAsset(
        model: model,
        timezone: timezone,
      );
    } catch (e) {
      throw Exception('Failed to create fixed asset: $e');
    }
  }

  @override
  Future<void> updateFixedAsset(FixedAsset asset, {required String timezone}) async {
    try {
      if (asset.assetId == null) {
        throw Exception('Asset ID is required for update');
      }

      if (!asset.isValid) {
        throw Exception('Invalid asset data');
      }

      final model = FixedAssetModel.fromEntity(asset);
      await _dataSource.updateFixedAsset(
        model: model,
        timezone: timezone,
      );
    } catch (e) {
      throw Exception('Failed to update fixed asset: $e');
    }
  }

  @override
  Future<void> deleteFixedAsset({
    required String assetId,
    required String companyId,
    required String timezone,
  }) async {
    try {
      await _dataSource.deleteFixedAsset(
        assetId: assetId,
        companyId: companyId,
        timezone: timezone,
      );
    } catch (e) {
      throw Exception('Failed to delete fixed asset: $e');
    }
  }

  @override
  Future<({String? currencyId, String symbol})> getBaseCurrencyInfo(
    String companyId,
  ) async {
    try {
      return await _dataSource.getBaseCurrencyInfo(companyId);
    } catch (e) {
      return (currencyId: null, symbol: '\$');
    }
  }
}
