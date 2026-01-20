// lib/features/cash_ending/data/datasources/location_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote Data Source for Locations and Stores
///
/// This is the ONLY place where Supabase client is used for location operations.
/// Handles all database queries for stores and locations.
/// Returns raw JSON data (Map<String, dynamic>).
class LocationRemoteDataSource {
  final SupabaseClient _client;

  LocationRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Get all stores for a company
  ///
  /// Returns list of store records
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getStores(String companyId) async {
    final response = await _client
        .from('stores')
        .select('store_id, store_name, store_code')
        .eq('company_id', companyId)
        .order('store_name');

    return List<Map<String, dynamic>>.from(response);
  }

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
