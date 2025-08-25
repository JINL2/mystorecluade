import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Cash location service provider
final cashLocationServiceProvider = Provider<CashLocationService>((ref) {
  return CashLocationService();
});

// All cash locations provider (fetch once, filter client-side)
final allCashLocationsProvider = FutureProvider.family<List<CashLocation>, CashLocationQueryParams>((ref, params) async {
  final service = ref.read(cashLocationServiceProvider);
  return service.getAllCashLocations(
    companyId: params.companyId,
    storeId: params.storeId,
  );
});

class CashLocationService {
  final _supabase = Supabase.instance.client;

  /// Get all cash locations (all types) for client-side filtering
  Future<List<CashLocation>> getAllCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {
      // Priority logic: if store_id exists in record, match it; otherwise use company_id
      // This gets locations that either:
      // 1. Have store_id = storeId (priority)
      // 2. Have store_id = null AND company_id = companyId (fallback)
      // Filter out soft-deleted records
      // Debug logging (uncomment for debugging)
      // print('Fetching cash locations for companyId: $companyId, storeId: $storeId');
      
      final response = await _supabase
          .from('v_cash_location')
          .select('*')
          .or('and(store_id.eq.$storeId,company_id.eq.$companyId),and(store_id.is.null,company_id.eq.$companyId)')
          .eq('is_deleted', false)
          .order('location_type')
          .order('location_name');
      
      // Debug logging (uncomment for debugging)
      // print('Response from v_cash_location: ${response.length} records');
      // if (response.isNotEmpty) {
      //   print('First record keys: ${response[0].keys.toList()}');
      //   print('First record: ${response[0]}');
      // }
      
      return (response as List)
          .map((json) => CashLocation.fromJson(json))
          .toList();
    } catch (e) {
      // Debug: print('Error fetching cash locations: $e');
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