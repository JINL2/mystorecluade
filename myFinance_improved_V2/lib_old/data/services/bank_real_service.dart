import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Bank real service provider
final bankRealServiceProvider = Provider<BankRealService>((ref) {
  return BankRealService();
});

// Bank real data provider
final bankRealProvider = FutureProvider.family<List<BankRealEntry>, BankRealParams>((ref, params) async {
  final service = ref.read(bankRealServiceProvider);
  return service.getBankReal(
    companyId: params.companyId,
    storeId: params.storeId,
    offset: params.offset,
    limit: params.limit,
  );
});

class BankRealService {
  final _supabase = Supabase.instance.client;

  /// Get bank real entries using RPC
  Future<List<BankRealEntry>> getBankReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      // Debug: print('Fetching bank real for company: $companyId, store: $storeId, offset: $offset, limit: $limit');
      
      final response = await _supabase.rpc(
        'get_bank_real',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );
      
      // Debug: print('Bank real response: ${response?.length ?? 0} entries');
      
      if (response == null) return [];
      
      return (response as List)
          .map((json) => BankRealEntry.fromJson(json))
          .toList();
    } catch (e) {
      // Debug: print('Error fetching bank real: $e');
      return [];
    }
  }
}

// Models
class BankRealEntry {
  final String bankAmountId;
  final String createdAt;
  final String recordDate;
  final String locationId;
  final String locationName;
  final String locationType;
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double totalAmount;

  BankRealEntry({
    required this.bankAmountId,
    required this.createdAt,
    required this.recordDate,
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.totalAmount,
  });

  factory BankRealEntry.fromJson(Map<String, dynamic> json) {
    return BankRealEntry(
      bankAmountId: json['bank_amount_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      recordDate: json['record_date'] ?? '',
      locationId: json['location_id'] ?? '',
      locationName: json['location_name'] ?? '',
      locationType: json['location_type'] ?? '',
      currencyId: json['currency_id'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      currencyName: json['currency_name'] ?? '',
      symbol: json['symbol'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
  
  // Helper method to get formatted time from created_at
  String getFormattedTime() {
    try {
      final dateTime = DateTime.parse(createdAt);
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return '';
    }
  }
}

// Display model for the UI
class BankRealDisplay {
  final String date;
  final String time;
  final String title;
  final String locationName;
  final double amount;
  final String currencySymbol;
  final BankRealEntry realEntry;

  BankRealDisplay({
    required this.date,
    required this.time,
    required this.title,
    required this.locationName,
    required this.amount,
    required this.currencySymbol,
    required this.realEntry,
  });
}

// Parameters for the provider
class BankRealParams {
  final String companyId;
  final String storeId;
  final int offset;
  final int limit;

  BankRealParams({
    required this.companyId,
    required this.storeId,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankRealParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}