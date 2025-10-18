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
  /// Uses v_cash_location view to get cash amounts for cash location page
  Future<List<CashLocation>> getAllCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {
      // For cash location page, we need to use the view to get calculated amounts
      // Query v_cash_location view directly to get cash amounts
      final response = await _supabase
          .from('v_cash_location')
          .select('*')
          .eq('store_id', storeId)
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .order('location_type')
          .order('location_name');
      
      return (response as List)
          .map((json) => CashLocation.fromJson(json))
          .toList();
    } catch (e) {
      // Re-throw the error so it can be handled by the UI
      throw Exception('Failed to load cash locations: ${e.toString()}');
    }
  }
  
  /// Get cash locations using RPC for selectors
  /// This method is for cash location selectors in forms
  Future<List<CashLocationRPCResponse>> getCashLocationsForSelector({
    required String companyId,
  }) async {
    try {
      // Call the RPC with only the company ID
      final response = await _supabase.rpc(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
        },
      );
      
      // Parse the RPC response and filter for security
      return (response as List)
          .map((json) => CashLocationRPCResponse.fromJson(json))
          .where((location) => 
            !location.isDeleted && 
            (location.additionalData['company_id'] == companyId),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load cash locations: ${e.toString()}');
    }
  }
}

// Models

// RPC Response Model - matches the structure from get_cash_locations RPC
class CashLocationRPCResponse {
  final String id;
  final String name;
  final String type;
  final String? storeId;
  final bool isCompanyWide;
  final bool isDeleted;
  final String? currencyCode;
  final String? bankAccount;
  final String? bankName;
  final String? locationInfo;
  final int transactionCount;
  final Map<String, dynamic> additionalData;

  CashLocationRPCResponse({
    required this.id,
    required this.name,
    required this.type,
    this.storeId,
    required this.isCompanyWide,
    required this.isDeleted,
    this.currencyCode,
    this.bankAccount,
    this.bankName,
    this.locationInfo,
    required this.transactionCount,
    required this.additionalData,
  });

  factory CashLocationRPCResponse.fromJson(Map<String, dynamic> json) {
    return CashLocationRPCResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      storeId: json['storeId'] as String?,
      isCompanyWide: json['isCompanyWide'] as bool,
      isDeleted: json['isDeleted'] as bool,
      currencyCode: json['currencyCode'] as String?,
      bankAccount: json['bankAccount'] as String?,
      bankName: json['bankName'] as String?,
      locationInfo: json['locationInfo'] as String?,
      transactionCount: json['transactionCount'] as int? ?? 0,
      additionalData: json['additionalData'] as Map<String, dynamic>? ?? {},
    );
  }

  // Convert RPC response to CashLocation model for backward compatibility
  CashLocation toCashLocation() {
    // Use additionalData for cash amounts if available, otherwise default to 0
    final additionalData = this.additionalData;
    
    return CashLocation(
      locationId: id,
      locationName: name,
      locationType: type,
      totalJournalCashAmount: (additionalData['total_journal_cash_amount'] as num?)?.toDouble() ?? 0.0,
      totalRealCashAmount: (additionalData['total_real_cash_amount'] as num?)?.toDouble() ?? 0.0,
      cashDifference: (additionalData['cash_difference'] as num?)?.toDouble() ?? 0.0,
      companyId: additionalData['company_id'] as String? ?? '',
      storeId: storeId,
      currencySymbol: currencyCode ?? '',
      isDeleted: isDeleted,
    );
  }
}

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