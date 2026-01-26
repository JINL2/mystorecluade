// lib/features/cash_ending/data/datasources/location_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote Data Source for Locations
///
/// This is the ONLY place where Supabase client is used for location operations.
/// Handles all database queries for locations.
/// Returns raw JSON data (Map<String, dynamic>).
///
/// NOTE: Store data is available from AppState (loaded at app startup via
/// get_user_companies_with_salary RPC). Use appState.user['companies'][n]['stores']
/// instead of making a separate network call.
class LocationRemoteDataSource {
  final SupabaseClient _client;

  LocationRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Get locations by type using RPC
  ///
  /// [companyId] - Company identifier
  /// [locationType] - 'cash', 'bank', or 'vault'
  /// [storeId] - Optional store filter ('headquarter' or null for HQ)
  ///
  /// Returns list of location records
  Future<List<Map<String, dynamic>>> getLocationsByType({
    required String companyId,
    required String locationType,
    String? storeId,
  }) async {
    // Handle headquarter case - convert 'headquarter' to null
    final storeIdValue = (storeId == null || storeId == 'headquarter')
        ? null
        : storeId;

    final response = await _client.rpc<List<dynamic>>(
      'get_cash_locations_v2',
      params: {
        'p_company_id': companyId,
        'p_location_type': locationType,
        'p_store_id': storeIdValue,
      },
    );

    return List<Map<String, dynamic>>.from(response);
  }
}
