import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/app_state_provider.dart';

/// Location service for loading store and location data from Supabase
/// FROM PRODUCTION LINES 364-394, 418-525
class LocationService {
  final WidgetRef? ref;

  LocationService({this.ref});

  /// Load stores from Supabase
  /// FROM PRODUCTION LINES 364-394
  Future<Map<String, dynamic>> loadStores() async {
    // Get companyId from AppState like production
    final appState = ref?.read(appStateProvider);
    final companyId = appState?.companyChoosen ?? '';
    try {
      if (companyId.isEmpty) {
        return {
          'stores': [],
          'isLoadingStores': false,
        };
      }
      
      final response = await Supabase.instance.client
          .from('stores')
          .select('store_id, store_name, store_code')
          .eq('company_id', companyId)
          .order('store_name');
      
      return {
        'stores': List<Map<String, dynamic>>.from(response),
        'isLoadingStores': false,
      };
    } catch (e) {
      // Error loading stores: $e
      return {
        'stores': [],
        'isLoadingStores': false,
      };
    }
  }

  /// Fetch locations for the selected store and type
  /// locationType parameter allows filtering by 'cash', 'bank', or 'vault'
  /// FROM PRODUCTION LINES 418-525
  Future<Map<String, dynamic>> fetchLocations(
    String locationType, {
    String? selectedStoreId,
  }) async {
    // Get companyId from AppState like production
    final appState = ref?.read(appStateProvider);
    final companyId = appState?.companyChoosen ?? '';
    // For headquarter (null store_id) or regular store
    try {
      final loadingStates = {
        'isLoadingCashLocations': locationType == 'cash',
        'isLoadingBankLocations': locationType == 'bank',
        'isLoadingVaultLocations': locationType == 'vault',
      };
      
      if (companyId.isEmpty) {
        return {
          'cashLocations': locationType == 'cash' ? [] : null,
          'bankLocations': locationType == 'bank' ? [] : null,
          'vaultLocations': locationType == 'vault' ? [] : null,
          'isLoadingCashLocations': false,
          'isLoadingBankLocations': false,
          'isLoadingVaultLocations': false,
        };
      }
      
      // Build the query based on whether it's headquarter or a regular store
      List<Map<String, dynamic>> response;
      
      // Use RPC to get all cash locations for the company
      final rpcResponse = await Supabase.instance.client.rpc(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
        },
      );
      
      if (rpcResponse == null) {
        return {
          'success': false,
          'message': 'No cash locations found for this company',
          'data': [],
        };
      }
      
      // Filter client-side based on store and location type
      List<Map<String, dynamic>> filteredLocations = [];
      
      if (selectedStoreId == 'headquarter') {
        // For headquarter, show company-wide locations of specified type
        filteredLocations = (rpcResponse as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .where((location) => 
              location['isCompanyWide'] == true &&
              location['type']?.toString().toLowerCase() == locationType.toLowerCase() &&
              location['isDeleted'] != true
            )
            .toList();
      } else if (selectedStoreId != null && selectedStoreId.isNotEmpty) {
        // For regular store, show store-specific + company-wide locations of specified type
        filteredLocations = (rpcResponse as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .where((location) => 
              (location['storeId'] == selectedStoreId || location['isCompanyWide'] == true) &&
              location['type']?.toString().toLowerCase() == locationType.toLowerCase() &&
              location['isDeleted'] != true
            )
            .toList();
      } else {
        // No store selected - return empty results
        filteredLocations = [];
      }
      
      // Sort by location name
      filteredLocations.sort((a, b) => 
        (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString())
      );
      
      // Convert RPC response format to expected format
      response = filteredLocations.map((location) => {
        'cash_location_id': location['id'],
        'location_name': location['name'],
        'location_type': location['type'],
        'company_id': location['companyId'] ?? location['additionalData']?['company_id'],
        'store_id': location['storeId'],
        'is_deleted': location['isDeleted'],
        'currency_code': location['currencyCode'],
        'bank_account': location['bankAccount'],
        'bank_name': location['bankName'],
        'location_info': location['locationInfo'],
        'is_company_wide': location['isCompanyWide'],
      }).toList();
      
      // Handle case where no store is selected but we still need to return structure
      if (selectedStoreId == null || selectedStoreId.isEmpty) {
        return {
          'cashLocations': locationType == 'cash' ? [] : null,
          'bankLocations': locationType == 'bank' ? [] : null,
          'vaultLocations': locationType == 'vault' ? [] : null,
          'isLoadingCashLocations': false,
          'isLoadingBankLocations': false,
          'isLoadingVaultLocations': false,
          'selectedLocationId': null,
          'selectedBankLocationId': null,
          'selectedVaultLocationId': null,
        };
      }
      
      // Return appropriate response based on location type
      final result = <String, dynamic>{};
      
      if (locationType == 'cash') {
        result['cashLocations'] = List<Map<String, dynamic>>.from(response);
        result['isLoadingCashLocations'] = false;
        result['selectedLocationId'] = null;
      } else if (locationType == 'bank') {
        result['bankLocations'] = List<Map<String, dynamic>>.from(response);
        result['isLoadingBankLocations'] = false;
        result['selectedBankLocationId'] = null;
      } else if (locationType == 'vault') {
        result['vaultLocations'] = List<Map<String, dynamic>>.from(response);
        result['isLoadingVaultLocations'] = false;
        result['selectedVaultLocationId'] = null;
      }
      
      return result;
      
      // Cash locations loaded successfully
    } catch (e) {
      // Error fetching locations: $e
      return {
        'cashLocations': locationType == 'cash' ? [] : null,
        'bankLocations': locationType == 'bank' ? [] : null,
        'vaultLocations': locationType == 'vault' ? [] : null,
        'isLoadingCashLocations': false,
        'isLoadingBankLocations': false,
        'isLoadingVaultLocations': false,
      };
    }
  }
}