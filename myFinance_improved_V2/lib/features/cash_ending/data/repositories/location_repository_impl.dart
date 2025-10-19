// lib/features/cash_ending/data/repositories/location_repository_impl.dart

import '../../domain/entities/location.dart';
import '../../domain/entities/store.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/exceptions/cash_ending_exception.dart';
import '../datasources/location_remote_datasource.dart';
import '../models/location_model.dart';
import '../models/store_model.dart';

/// Repository Implementation for Locations (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping.
class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remoteDataSource;

  LocationRepositoryImpl({
    LocationRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? LocationRemoteDataSource();

  @override
  Future<List<Store>> getStores(String companyId) async {
    try {
      if (companyId.isEmpty) {
        return [];
      }

      // Call remote datasource
      final data = await _remoteDataSource.getStores(companyId);

      // Convert JSON to models then to entities
      return data.map((json) => StoreModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      throw FetchFailedException(
        'Failed to fetch stores',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Location>> getLocationsByType({
    required String companyId,
    required String locationType,
    String? storeId,
  }) async {
    try {
      if (companyId.isEmpty) {
        return [];
      }

      // Call remote datasource
      final data = await _remoteDataSource.getLocationsByType(
        companyId: companyId,
        locationType: locationType,
        storeId: storeId,
      );

      // Convert JSON to models then to entities
      return data.map((json) => LocationModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      throw FetchFailedException(
        'Failed to fetch locations for type: $locationType',
        originalError: e,
      );
    }
  }
}
