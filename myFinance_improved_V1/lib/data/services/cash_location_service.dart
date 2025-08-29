import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Cash location service provider
final cashLocationServiceProvider = Provider<CashLocationService>((ref) {
  return CashLocationService();
});

// All cash locations provider (fetch once, filter client-side)
// Changed to autoDispose to ensure fresh data on navigation
final allCashLocationsProvider = FutureProvider.family.autoDispose<List<CashLocation>, CashLocationQueryParams>((ref, params) async {
  final service = ref.read(cashLocationServiceProvider);
  return service.getAllCashLocations(
    companyId: params.companyId,
    storeId: params.storeId,
  );
});

class CashLocationService {
  final _supabase = Supabase.instance.client;

  /// Get all cash locations (all types) for client-side filtering
  /// Now uses RPC for better real-time data synchronization
  Future<List<CashLocation>> getAllCashLocations({
    required String companyId,
    required String storeId,
    bool useRpc = true, // Option to use RPC vs direct query
  }) async {
    try {
      // Debug logging
      print('Fetching cash locations - companyId: $companyId, storeId: $storeId, useRpc: $useRpc');
      
      List<dynamic> response;
      
      if (useRpc) {
        // Use RPC function for real-time data with proper calculations
        response = await _supabase.rpc(
          'get_cash_locations_with_totals',
          params: {
            'p_company_id': companyId,
            'p_store_id': storeId,
          },
        ).catchError((error) async {
          // Fallback to direct query if RPC doesn't exist
          print('RPC fallback: $error - Using direct query instead');
          return await _supabase
              .from('v_cash_location')
              .select('*')
              .eq('store_id', storeId)
              .eq('company_id', companyId)
              .eq('is_deleted', false)
              .order('location_type')
              .order('location_name');
        });
      } else {
        // Direct query from view
        response = await _supabase
            .from('v_cash_location')
            .select('*')
            .eq('store_id', storeId)
            .eq('company_id', companyId)
            .eq('is_deleted', false)
            .order('location_type')
            .order('location_name');
      }
      
      // Debug logging
      print('Response received: ${response.length} records');
      
      return (response as List)
          .map((json) => CashLocation.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching cash locations: $e');
      // Re-throw the error so it can be handled by the UI
      throw Exception('Failed to load cash locations: ${e.toString()}');
    }
  }
}

// Models
class CashLocation {
  final String locationId;
  final String locationName;
  final String locationType;
  final double totalJournalCashAmount;
  final double totalRealCashAmount;
  final double cashDifference;
  final String companyId;
  final String? storeId;
  final String currencySymbol;
  final bool isDeleted;

  CashLocation({
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.totalJournalCashAmount,
    required this.totalRealCashAmount,
    required this.cashDifference,
    required this.companyId,
    required this.currencySymbol,
    this.storeId,
    this.isDeleted = false,
  });

  factory CashLocation.fromJson(Map<String, dynamic> json) {
    // Check both possible field names for location ID
    final locationId = json['cash_location_id'] as String? ?? 
                      json['location_id'] as String? ?? '';
    
    // Debug logging (uncomment for debugging)
    // if (locationId.isEmpty) {
    //   print('Warning: Empty location ID in CashLocation.fromJson. JSON keys: ${json.keys.toList()}');
    // }
    
    return CashLocation(
      locationId: locationId,
      locationName: json['location_name'] as String? ?? '',
      locationType: json['location_type'] as String? ?? '',
      totalJournalCashAmount: (json['total_journal_cash_amount'] as num?)?.toDouble() ?? 0.0,
      totalRealCashAmount: (json['total_real_cash_amount'] as num?)?.toDouble() ?? 0.0,
      cashDifference: (json['cash_difference'] as num?)?.toDouble() ?? 0.0,
      companyId: json['company_id'] as String? ?? '',
      storeId: json['store_id'] as String?,
      currencySymbol: json['primary_currency_symbol'] as String? ?? '',
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }
}

// Parameters for the provider
class CashLocationQueryParams {
  final String companyId;
  final String storeId;

  CashLocationQueryParams({
    required this.companyId,
    required this.storeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashLocationQueryParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId;

  @override
  int get hashCode => companyId.hashCode ^ storeId.hashCode;
}