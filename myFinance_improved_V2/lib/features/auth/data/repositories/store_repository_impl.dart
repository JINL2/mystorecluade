// lib/features/auth/data/repositories/store_repository_impl.dart

import '../../domain/entities/store_entity.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/supabase_store_datasource.dart';
import '../../../../core/data/base_repository.dart';

/// Store Repository Implementation
///
/// 📜 Responsibilities:
/// - Implements Domain Repository Interface (StoreRepository)
/// - Delegates data operations to StoreDataSource
/// - Applies consistent error handling via BaseRepository
///
/// ✅ Improvements:
/// - Uses core BaseRepository for standardized error handling
/// - Clear operation names for debugging
/// - No Model → Entity conversion (Freezed handles it)
class StoreRepositoryImpl extends BaseRepository implements StoreRepository {
  final StoreDataSource _dataSource;

  StoreRepositoryImpl(this._dataSource);

  @override
  Future<Store> create(Store store) {
    return executeWithErrorHandling(
      () => _dataSource.createStore(store.toInsertMap()),
      operationName: 'create store',
    );
  }

  @override
  Future<Store?> findById(String storeId) {
    return executeFetch(
      () => _dataSource.getStoreById(storeId),
      operationName: 'store by ID',
    );
  }

  @override
  Future<List<Store>> findByCompany(String companyId) {
    return executeFetch(
      () => _dataSource.getStoresByCompanyId(companyId),
      operationName: 'stores by company',
    );
  }

  @override
  Future<bool> codeExists({
    required String companyId,
    required String storeCode,
  }) {
    return executeFetch(
      () => _dataSource.isStoreCodeExists(
        companyId: companyId,
        storeCode: storeCode,
      ),
      operationName: 'check store code existence',
    );
  }

  @override
  Future<Store> update(Store store) {
    return executeWithErrorHandling(
      () async {
        final updateData = {
          'store_name': store.name,
          'store_code': store.storeCode,
          'store_address': store.address,
          'store_phone': store.phone,
          'huddle_time': store.huddleTimeMinutes,
          'payment_time': store.paymentTimeDays,
          'allowed_distance': store.allowedDistanceMeters?.toInt(),
        };

        return await _dataSource.updateStore(store.id, updateData);
      },
      operationName: 'update store',
    );
  }

  @override
  Future<void> delete(String storeId) {
    return executeWithErrorHandling(
      () => _dataSource.deleteStore(storeId),
      operationName: 'delete store',
    );
  }
}
