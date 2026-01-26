// lib/features/cash_ending/data/repositories/location_repository_impl.dart

import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';
import '../models/freezed/location_dto.dart';
import 'base_repository.dart';

/// Repository Implementation for Locations (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping using BaseRepository.
///
/// NOTE: Store data is available from AppState (loaded at app startup via
/// get_user_companies_with_salary RPC). Use appState.user['companies'][n]['stores']
/// instead of making a separate network call.
class LocationRepositoryImpl extends BaseRepository
    implements LocationRepository {
  final LocationRemoteDataSource _remoteDataSource;

  LocationRepositoryImpl({
    LocationRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? LocationRemoteDataSource();

  @override
  Future<List<Location>> getLocationsByType({
    required String companyId,
    required String locationType,
    String? storeId,
  }) async {
    return executeWithErrorHandling(
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

        // Convert JSON to DTOs then to entities
        return data
            .map((json) => LocationDto.fromJson(json).toEntity())
            .toList();
      },
      operationName: 'getLocationsByType',
    );
  }
}
