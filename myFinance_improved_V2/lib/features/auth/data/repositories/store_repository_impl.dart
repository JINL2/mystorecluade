// lib/features/auth/data/repositories/store_repository_impl.dart

import '../../domain/entities/store_entity.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/supabase_store_datasource.dart';
import '../models/store_model.dart';
import 'base_repository.dart';

/// Store Repository Implementation
///
/// 📜 계약 이행자 - Domain Repository Interface를 구현
///
/// 책임:
/// - Domain 계약 준수
/// - DataSource 호출
/// - Model ↔ Entity 변환 (operational settings 포함!)
/// - Exception 처리 및 변환
class StoreRepositoryImpl extends BaseRepository implements StoreRepository {
  final StoreDataSource _dataSource;

  StoreRepositoryImpl(this._dataSource);

  @override
  Future<Store> create(Store store) {
    return execute(() async {
      // Convert Entity to Model
      final model = StoreModel.fromEntity(store);

      // Call DataSource with operational settings
      final createdModel = await _dataSource.createStore(model.toInsertMap());

      // Convert Model back to Entity
      return createdModel.toEntity();
    });
  }

  @override
  Future<Store?> findById(String storeId) {
    return executeNullable(() async {
      final model = await _dataSource.getStoreById(storeId);
      return model?.toEntity();
    });
  }

  @override
  Future<List<Store>> findByCompany(String companyId) {
    return execute(() async {
      final models = await _dataSource.getStoresByCompanyId(companyId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<bool> codeExists({
    required String companyId,
    required String storeCode,
  }) {
    return execute(() async {
      return await _dataSource.isStoreCodeExists(
        companyId: companyId,
        storeCode: storeCode,
      );
    });
  }

  @override
  Future<Store> update(Store store) {
    return execute(() async {
      final model = StoreModel.fromEntity(store);

      final updateData = {
        'store_name': store.name,
        'store_code': store.storeCode,
        'store_address': store.address,
        'store_phone': store.phone,
        'huddle_time': store.huddleTimeMinutes,
        'payment_time': store.paymentTimeDays,
        'allowed_distance': store.allowedDistanceMeters?.toInt(),
      };

      final updatedModel = await _dataSource.updateStore(
        store.id,
        updateData,
      );

      return updatedModel.toEntity();
    });
  }

  @override
  Future<void> delete(String storeId) {
    return execute(() async {
      await _dataSource.deleteStore(storeId);
    });
  }
}
