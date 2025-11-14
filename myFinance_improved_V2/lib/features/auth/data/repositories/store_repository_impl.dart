// lib/features/auth/data/repositories/store_repository_impl.dart

import '../../domain/entities/store_entity.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/supabase_store_datasource.dart';
import '../models/freezed/store_dto_mapper.dart';
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
      // Convert Entity to insert map (without ID)
      final insertMap = store.toInsertMap();

      // Call DataSource with operational settings
      final createdDto = await _dataSource.createStore(insertMap);

      // Convert DTO back to Entity
      return createdDto.toEntity();
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
      final updateData = {
        'store_name': store.name,
        'store_code': store.storeCode,
        'store_address': store.address,
        'store_phone': store.phone,
        'huddle_time': store.huddleTimeMinutes,
        'payment_time': store.paymentTimeDays,
        'allowed_distance': store.allowedDistanceMeters?.toInt(),
      };

      final updatedDto = await _dataSource.updateStore(
        store.id,
        updateData,
      );

      return updatedDto.toEntity();
    });
  }

  @override
  Future<void> delete(String storeId) {
    return execute(() async {
      await _dataSource.deleteStore(storeId);
    });
  }
}
