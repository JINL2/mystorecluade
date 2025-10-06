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
      
      // Use direct table query like production (not RPC)
      // Handle null store_id for headquarter
      final storeIdValue = selectedStoreId == 'headquarter' ? null : selectedStoreId;
      
      var query = Supabase.instance.client
          .from('cash_locations')
          .select('*')  // Get all fields including currency_id
          .eq('company_id', companyId)
          .eq('location_type', locationType)
          .eq('is_deleted', false);
      
      // Add store_id filter only if not null
      if (storeIdValue != null) {
        query = query.eq('store_id', storeIdValue);
      } else {
        query = query.isFilter('store_id', null);
      }
      
      final response = await query.order('location_name');
      
      if (response.isEmpty) {
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
      
      // Direct response from database - no need for complex filtering
      final List<Map<String, dynamic>> locationsList = List<Map<String, dynamic>>.from(response);
      
      // Return appropriate response based on location type
      final result = <String, dynamic>{};
      
      if (locationType == 'cash') {
        result['cashLocations'] = locationsList;
        result['isLoadingCashLocations'] = false;
        result['selectedLocationId'] = null;
      } else if (locationType == 'bank') {
        result['bankLocations'] = locationsList;
        result['isLoadingBankLocations'] = false;
        result['selectedBankLocationId'] = null;
      } else if (locationType == 'vault') {
        result['vaultLocations'] = locationsList;
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