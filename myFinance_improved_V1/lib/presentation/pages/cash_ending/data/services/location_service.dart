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
      
      // Use RPC to get all cash locations for the company
      final rpcResponse = await Supabase.instance.client.rpc(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
        },
      );
      
      if (rpcResponse == null) {
        // No locations found
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
      
      // Filter the response based on store selection and location type
      List<Map<String, dynamic>> filteredLocations = [];
      
      if (selectedStoreId == 'headquarter') {
        // For headquarter, filter for company-wide locations or null storeId
        filteredLocations = (rpcResponse as List).where((location) {
          // Check if location matches the type and is either company-wide or has null storeId
          return location['type'] == locationType &&
                 !location['isDeleted'] &&
                 (location['isCompanyWide'] == true || location['storeId'] == null);
        }).map((location) => {
          // Map RPC response fields to expected structure
          'cash_location_id': location['id'],
          'location_name': location['name'],
          'location_type': location['type'],
          'store_id': location['storeId'],
          'is_deleted': location['isDeleted'],
          'currency_code': location['currencyCode'],
          'bank_account': location['bankAccount'],
          'bank_name': location['bankName'],
          'location_info': location['locationInfo'],
        }).toList();
      } else if (selectedStoreId != null && selectedStoreId.isNotEmpty) {
        // For regular store, filter by storeId or company-wide locations
        filteredLocations = (rpcResponse as List).where((location) {
          // Check if location matches the type and belongs to this store or is company-wide
          return location['type'] == locationType &&
                 !location['isDeleted'] &&
                 (location['storeId'] == selectedStoreId || location['isCompanyWide'] == true);
        }).map((location) => {
          // Map RPC response fields to expected structure
          'cash_location_id': location['id'],
          'location_name': location['name'],
          'location_type': location['type'],
          'store_id': location['storeId'],
          'is_deleted': location['isDeleted'],
          'currency_code': location['currencyCode'],
          'bank_account': location['bankAccount'],
          'bank_name': location['bankName'],
          'location_info': location['locationInfo'],
        }).toList();
      } else {
        // No store selected
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
      
      // Sort the filtered locations by name
      filteredLocations.sort((a, b) => 
        (a['location_name'] as String).compareTo(b['location_name'] as String));
      
      final List<Map<String, dynamic>> response = filteredLocations;
      
      // Return appropriate response based on location type
      final result = <String, dynamic>{};
      
      if (locationType == 'cash') {
        result['cashLocations'] = response;
        result['isLoadingCashLocations'] = false;
        result['selectedLocationId'] = null;
      } else if (locationType == 'bank') {
        result['bankLocations'] = response;
        result['isLoadingBankLocations'] = false;
        result['selectedBankLocationId'] = null;
      } else if (locationType == 'vault') {
        result['vaultLocations'] = response;
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