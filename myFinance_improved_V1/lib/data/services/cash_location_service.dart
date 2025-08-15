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
      final response = await _supabase
          .from('v_cash_location')
          .select('*')
          .or('and(store_id.eq.$storeId,company_id.eq.$companyId),and(store_id.is.null,company_id.eq.$companyId)')
          .order('location_type')
          .order('location_name');
      
      return (response as List)
          .map((json) => CashLocation.fromJson(json))
          .toList();
    } catch (e) {
      return [];
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
  });

  factory CashLocation.fromJson(Map<String, dynamic> json) {
    return CashLocation(
      locationId: json['location_id'] as String? ?? '',
      locationName: json['location_name'] as String? ?? '',
      locationType: json['location_type'] as String? ?? '',
      totalJournalCashAmount: (json['total_journal_cash_amount'] as num?)?.toDouble() ?? 0.0,
      totalRealCashAmount: (json['total_real_cash_amount'] as num?)?.toDouble() ?? 0.0,
      cashDifference: (json['cash_difference'] as num?)?.toDouble() ?? 0.0,
      companyId: json['company_id'] as String? ?? '',
      storeId: json['store_id'] as String?,
      currencySymbol: json['primary_currency_symbol'] as String? ?? '₩',
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