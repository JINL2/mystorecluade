import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cash_location_model.dart';
import '../../../providers/app_state_provider.dart';

// Filter state provider
final cashLocationFilterProvider = StateProvider<CashLocationFilter>((ref) {
  return const CashLocationFilter();
});

// Selected cash location for details view
final selectedCashLocationProvider = StateProvider<CashLocationModel?>((ref) {
  return null;
});

// Cash locations list provider with real-time updates
final cashLocationsProvider = StreamProvider<List<CashLocationModel>>((ref) async* {
  final supabase = Supabase.instance.client;
  final appState = ref.watch(appStateProvider);
  final filter = ref.watch(cashLocationFilterProvider);
  
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  
  if (companyId.isEmpty) {
    yield [];
    return;
  }
  
  // For complex filtering with streams, we need to use a different approach
  // Build the base stream and apply filters in the map function
  final baseStream = supabase
      .from('cash_locations')
      .stream(primaryKey: ['cash_location_id'])
      .eq('company_id', companyId);
  
  yield* baseStream.map((data) {
    // Apply all filters on the client side
    var filteredData = data.toList();
    
    // Filter by store
    if (storeId.isNotEmpty && filter.storeId == null) {
      filteredData = filteredData.where((item) => item['store_id'] == storeId).toList();
    } else if (filter.storeId != null) {
      filteredData = filteredData.where((item) => item['store_id'] == filter.storeId).toList();
    }
    
    // Filter by type
    if (filter.locationType != null) {
      filteredData = filteredData.where((item) => item['location_type'] == filter.locationType).toList();
    }
    
    // Filter out deleted items
    if (!filter.showInactive) {
      filteredData = filteredData.where((item) => item['deleted_at'] == null).toList();
    }
    
    // Apply search filter
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      filteredData = filteredData.where((item) {
        final name = (item['location_name'] as String? ?? '').toLowerCase();
        final bankName = (item['bank_name'] as String? ?? '').toLowerCase();
        final bankAccount = (item['bank_account'] as String? ?? '').toLowerCase();
        return name.contains(query) || bankName.contains(query) || bankAccount.contains(query);
      }).toList();
    }
    
    // Sort by location name
    filteredData.sort((a, b) => 
      (a['location_name'] as String).compareTo(b['location_name'] as String)
    );
    
    return filteredData.map((json) => CashLocationModel.fromJson(json)).toList();
  });
});

// Cash location summary provider
final cashLocationSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final supabase = Supabase.instance.client;
  final appState = ref.watch(appStateProvider);
  
  final companyId = appState.companyChoosen;
  if (companyId.isEmpty) {
    return {
      'total': 0,
      'active': 0,
      'byType': {'cash': 0, 'bank': 0, 'vault': 0},
    };
  }
  
  try {
    // Get all locations for the company
    final allLocations = await supabase
        .from('cash_locations')
        .select('cash_location_id, location_type, deleted_at')
        .eq('company_id', companyId);
    
    // Calculate counts from the fetched data
    final totalCount = (allLocations as List).length;
    final activeCount = allLocations.where((item) => item['deleted_at'] == null).length;
    
    // Count by type (active only)
    final byType = <String, int>{'cash': 0, 'bank': 0, 'vault': 0};
    for (final item in allLocations) {
      if (item['deleted_at'] == null) {
        final type = item['location_type'] as String;
        byType[type] = (byType[type] ?? 0) + 1;
      }
    }
    
    return {
      'total': totalCount,
      'active': activeCount,
      'byType': byType,
    };
  } catch (e) {
    throw Exception('Failed to load cash location summary: $e');
  }
});

// Provider for creating new cash location
final createCashLocationProvider = Provider((ref) {
  final supabase = Supabase.instance.client;
  final appState = ref.watch(appStateProvider);
  
  return (CashLocationModel location) async {
    final companyId = appState.companyChoosen;
    if (companyId.isEmpty) {
      throw Exception('No company selected');
    }
    
    try {
      final response = await supabase
          .from('cash_locations')
          .insert({
            'company_id': companyId,
            'store_id': location.storeId,
            'location_name': location.locationName,
            'location_type': location.locationType,
            'location_info': location.locationInfo,
            'currency_code': location.currencyCode,
            'bank_account': location.bankAccount,
            'bank_name': location.bankName,
          })
          .select()
          .single();
      
      return CashLocationModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create cash location: $e');
    }
  };
});

// Provider for updating cash location
final updateCashLocationProvider = Provider((ref) {
  final supabase = Supabase.instance.client;
  
  return (CashLocationModel location) async {
    try {
      final response = await supabase
          .from('cash_locations')
          .update({
            'location_name': location.locationName,
            'location_type': location.locationType,
            'location_info': location.locationInfo,
            'currency_code': location.currencyCode,
            'bank_account': location.bankAccount,
            'bank_name': location.bankName,
          })
          .eq('cash_location_id', location.id)
          .select()
          .single();
      
      return CashLocationModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update cash location: $e');
    }
  };
});

// Provider for soft deleting cash location
final deleteCashLocationProvider = Provider((ref) {
  final supabase = Supabase.instance.client;
  
  return (String locationId) async {
    try {
      await supabase
          .from('cash_locations')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('cash_location_id', locationId);
    } catch (e) {
      throw Exception('Failed to delete cash location: $e');
    }
  };
});