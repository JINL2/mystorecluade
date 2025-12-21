import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_control_models.dart';

/// Optimized Debt Control Repository V2
/// Fetches both perspectives in a single call and caches them
class DebtControlRepositoryV2 {
  final SupabaseClient _client;
  
  // Cache for both perspectives
  Map<String, dynamic>? _cachedCompanyData;
  Map<String, dynamic>? _cachedStoreData;
  DateTime? _lastFetchTime;
  String? _cachedCompanyId;
  String? _cachedStoreId;
  String? _cachedFilter;
  bool? _cachedShowAll;

  DebtControlRepositoryV2(this._client);

  /// Fetch both perspectives at once - more efficient
  Future<void> fetchAllData({
    required String companyId,
    String? storeId,
    String filter = 'all',
    bool showAll = false,
  }) async {
    // Check cache validity (5 minutes)
    if (_isCacheValid(companyId, storeId, filter, showAll)) {
      return; // Use cached data
    }

    try {
      final response = await _client.rpc(
        'get_debt_control_data_v2',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_filter': filter,
          'p_show_all': showAll,
        },
      );

      if (response != null) {
        final data = response as Map<String, dynamic>;
        
        // Cache both perspectives
        _cachedCompanyData = data['company'] as Map<String, dynamic>?;
        _cachedStoreData = data['store'] as Map<String, dynamic>?;
        _lastFetchTime = DateTime.now();
        _cachedCompanyId = companyId;
        _cachedStoreId = storeId;
        _cachedFilter = filter;
        _cachedShowAll = showAll;
      }
    } catch (e) {
      print('Error fetching debt control data v2: $e');
      throw Exception('Failed to fetch debt control data: $e');
    }
  }

  /// Get company perspective data from cache
  Future<DebtControlResponse> getCompanyData({
    required String companyId,
    String filter = 'all',
    bool showAll = false,
  }) async {
    // Ensure data is fetched
    await fetchAllData(
      companyId: companyId,
      filter: filter,
      showAll: showAll,
    );

    if (_cachedCompanyData == null) {
      throw Exception('No company data available');
    }

    return DebtControlResponse.fromJson(_cachedCompanyData!);
  }

  /// Get store perspective data from cache
  Future<DebtControlResponse> getStoreData({
    required String companyId,
    required String storeId,
    String filter = 'all',
    bool showAll = false,
  }) async {
    // Ensure data is fetched
    await fetchAllData(
      companyId: companyId,
      storeId: storeId,
      filter: filter,
      showAll: showAll,
    );

    if (_cachedStoreData == null) {
      throw Exception('No store data available');
    }

    return DebtControlResponse.fromJson(_cachedStoreData!);
  }

  /// Get data for specific perspective without refetch if cached
  DebtControlResponse? getCachedData(String perspective) {
    if (perspective == 'company' && _cachedCompanyData != null) {
      return DebtControlResponse.fromJson(_cachedCompanyData!);
    } else if (perspective == 'store' && _cachedStoreData != null) {
      return DebtControlResponse.fromJson(_cachedStoreData!);
    }
    return null;
  }

  /// Check if cache is valid
  bool _isCacheValid(String companyId, String? storeId, String filter, bool showAll) {
    if (_cachedCompanyData == null || _lastFetchTime == null) {
      return false;
    }

    // Check if parameters match
    if (_cachedCompanyId != companyId ||
        _cachedStoreId != storeId ||
        _cachedFilter != filter ||
        _cachedShowAll != showAll) {
      return false;
    }

    // Check if cache is fresh (5 minutes)
    return DateTime.now().difference(_lastFetchTime!).inMinutes < 5;
  }

  /// Clear cache to force refresh
  void clearCache() {
    _cachedCompanyData = null;
    _cachedStoreData = null;
    _lastFetchTime = null;
    _cachedCompanyId = null;
    _cachedStoreId = null;
    _cachedFilter = null;
    _cachedShowAll = null;
  }

  /// Force refresh data
  Future<void> refreshData({
    required String companyId,
    String? storeId,
    String filter = 'all',
    bool showAll = false,
  }) async {
    clearCache();
    await fetchAllData(
      companyId: companyId,
      storeId: storeId,
      filter: filter,
      showAll: showAll,
    );
  }
}