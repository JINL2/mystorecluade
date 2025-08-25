import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Cash real service provider
final cashRealServiceProvider = Provider<CashRealService>((ref) {
  return CashRealService();
});

// Cash real data provider
final cashRealProvider = FutureProvider.family<List<CashRealEntry>, CashRealParams>((ref, params) async {
  final service = ref.read(cashRealServiceProvider);
  return service.getCashReal(
    companyId: params.companyId,
    storeId: params.storeId,
    locationType: params.locationType,
    offset: params.offset,
    limit: params.limit,
  );
});

class CashRealService {
  final _supabase = Supabase.instance.client;

  /// Get cash real entries using RPC
  Future<List<CashRealEntry>> getCashReal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      // Debug: print('Fetching cash real for company: $companyId, store: $storeId, offset: $offset, limit: $limit');
      
      final response = await _supabase.rpc(
        'get_cash_real',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );
      
      // Debug: print('Cash real response: ${response?.length ?? 0} entries');
      
      if (response == null) return [];
      
      return (response as List)
          .map((json) => CashRealEntry.fromJson(json))
          .toList();
    } catch (e) {
      // Debug: print('Error fetching cash real: $e');
      return [];
    }
  }
}

// Models
class CashRealEntry {
  final String createdAt;
  final String recordDate;
  final String locationId;
  final String locationName;
  final String locationType;
  final double totalAmount;
  final List<CurrencySummary> currencySummary;

  CashRealEntry({
    required this.createdAt,
    required this.recordDate,
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.totalAmount,
    required this.currencySummary,
  });

  factory CashRealEntry.fromJson(Map<String, dynamic> json) {
    return CashRealEntry(
      createdAt: json['created_at'] ?? '',
      recordDate: json['record_date'] ?? '',
      locationId: json['location_id'] ?? '',
      locationName: json['location_name'] ?? '',
      locationType: json['location_type'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      currencySummary: (json['currency_summary'] as List? ?? [])
          .map((cs) => CurrencySummary.fromJson(cs))
          .toList(),
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
  
  // Helper method to get primary currency symbol
  String getCurrencySymbol() {
    if (currencySummary.isNotEmpty) {
      return currencySummary.first.symbol;
    }
    return '';
  }
  
  // Helper to determine transaction type based on some logic
  String getTransactionType() {
    // This could be enhanced based on business logic
    // For now, we'll use simple categorization
    if (totalAmount == 0) {
      return 'Error';
    } else if (totalAmount < 0) {
      return 'Shortage';
    } else {
      return 'Cash';
    }
  }
}

class CurrencySummary {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double totalValue;
  final List<Denomination> denominations;

  CurrencySummary({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.totalValue,
    required this.denominations,
  });

  factory CurrencySummary.fromJson(Map<String, dynamic> json) {
    return CurrencySummary(
      currencyId: json['currency_id'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      currencyName: json['currency_name'] ?? '',
      symbol: json['symbol'] ?? '',
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      denominations: (json['denominations'] as List? ?? [])
          .map((d) => Denomination.fromJson(d))
          .toList(),
    );
  }
}

class Denomination {
  final double denominationValue;
  final int quantity;
  final double subtotal;

  Denomination({
    required this.denominationValue,
    required this.quantity,
    required this.subtotal,
  });

  factory Denomination.fromJson(Map<String, dynamic> json) {
    return Denomination(
      denominationValue: (json['denomination_value'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// Display model for the UI
class CashRealDisplay {
  final String date;
  final String time;
  final String title;
  final String locationName;
  final double amount;
  final CashRealEntry realEntry;

  CashRealDisplay({
    required this.date,
    required this.time,
    required this.title,
    required this.locationName,
    required this.amount,
    required this.realEntry,
  });
}

// Parameters for the provider
class CashRealParams {
  final String companyId;
  final String storeId;
  final String locationType;
  final int offset;
  final int limit;

  CashRealParams({
    required this.companyId,
    required this.storeId,
    required this.locationType,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashRealParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          locationType == other.locationType &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      locationType.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}