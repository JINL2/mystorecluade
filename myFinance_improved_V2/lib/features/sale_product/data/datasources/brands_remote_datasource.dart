import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for brands
class BrandsRemoteDataSource {
  final SupabaseClient _client;

  BrandsRemoteDataSource(this._client);

  /// Get all active brands for a company
  Future<List<Map<String, dynamic>>> getBrands({
    required String companyId,
  }) async {
    final response = await _client
        .from('inventory_brands')
        .select('brand_id, brand_name')
        .eq('company_id', companyId)
        .eq('is_active', true)
        .order('brand_name');

    return (response as List).cast<Map<String, dynamic>>();
  }
}
