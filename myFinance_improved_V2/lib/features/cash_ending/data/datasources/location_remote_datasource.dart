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

  /// Get locations by type
  ///
  /// [companyId] - Company identifier
  /// [locationType] - 'cash', 'bank', or 'vault'
  /// [storeId] - Optional store filter ('headquarter' or null for HQ)
  ///
  /// Returns list of location records
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getLocationsByType({
    required String companyId,
    required String locationType,
    String? storeId,
  }) async {
    // Handle headquarter case - convert 'headquarter' to null
    final storeIdValue = (storeId == null || storeId == 'headquarter')
        ? null
        : storeId;

    var query = _client
        .from('cash_locations')
        .select('*')
        .eq('company_id', companyId)
        .eq('location_type', locationType)
        .eq('is_deleted', false);

    // Add store_id filter
    if (storeIdValue != null) {
      query = query.eq('store_id', storeIdValue);
    } else {
      query = query.isFilter('store_id', null);
    }

    final response = await query.order('location_name');

    return List<Map<String, dynamic>>.from(response);
  }
}
