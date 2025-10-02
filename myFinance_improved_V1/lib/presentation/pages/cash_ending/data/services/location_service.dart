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

      final List<Map<String, dynamic>> response;
      
      if (selectedStoreId == 'headquarter') {
        // For headquarter, filter by null store_id and location_type
        response = await Supabase.instance.client
            .from('cash_locations')
            .select('*')  // Select all columns to see what's available
            .eq('company_id', companyId)
            .isFilter('store_id', null)
            .eq('location_type', locationType)  // Filter by location type (cash/bank/vault)
            .eq('is_deleted', false)  // Only show active locations
            .order('location_name');
      } else if (selectedStoreId != null && selectedStoreId.isNotEmpty) {
        // For regular store, filter by store_id and location_type
        response = await Supabase.instance.client
            .from('cash_locations')
            .select('*')  // Select all columns to see what's available
            .eq('company_id', companyId)
            .eq('store_id', selectedStoreId)
            .eq('location_type', locationType)  // Filter by location type (cash/bank/vault)
            .eq('is_deleted', false)  // Only show active locations
            .order('location_name');
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