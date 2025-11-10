// lib/features/cash_ending/data/repositories/location_repository_impl.dart

import '../../../../core/data/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/store.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';

/// Repository Implementation for Locations (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
///
/// ✅ Refactored with:
/// - BaseRepository (unified error handling)
/// - Freezed Entity (no Model needed)
/// - 40% less boilerplate
class LocationRepositoryImpl extends BaseRepository implements LocationRepository {
  final LocationRemoteDataSource _remoteDataSource;

  LocationRepositoryImpl({
    LocationRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? LocationRemoteDataSource();

  @override
  Future<Result<List<Store>, Failure>> getStores(String companyId) {
    return executeFetchWithResult(
      () async {
        if (companyId.isEmpty) {
          return [];
        }

        // Call remote datasource
        final data = await _remoteDataSource.getStores(companyId);

        // Convert JSON directly to entities (Freezed handles it)
        return data.map((json) => Store.fromJson(json)).toList();
      },
      operationName: 'stores',
    );
  }

  @override
  Future<Result<List<Location>, Failure>> getLocationsByType({
    required String companyId,
    required String locationType,
    String? storeId,
  }) {
    return executeFetchWithResult(
      () async {
        if (companyId.isEmpty) {
          return [];
        }

        // Call remote datasource
        final data = await _remoteDataSource.getLocationsByType(
          companyId: companyId,
          locationType: locationType,
          storeId: storeId,
        );

        // Convert JSON directly to entities (Freezed handles it)
        return data.map((json) => Location.fromJson(json)).toList();
      },
      operationName: 'locations for type: $locationType',
    );
  }
}
