import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Vault real service provider
final vaultRealServiceProvider = Provider<VaultRealService>((ref) {
  return VaultRealService();
});

// Vault real data provider
final vaultRealProvider = FutureProvider.family<List<VaultRealEntry>, VaultRealParams>((ref, params) async {
  final service = ref.read(vaultRealServiceProvider);
  return service.getVaultReal(
    companyId: params.companyId,
    storeId: params.storeId,
    offset: params.offset,
    limit: params.limit,
  );
});

class VaultRealService {
  final _supabase = Supabase.instance.client;

  /// Get vault real entries using RPC
  Future<List<VaultRealEntry>> getVaultReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      // Debug: print('Fetching vault real for company: $companyId, store: $storeId, offset: $offset, limit: $limit');
      
      final response = await _supabase.rpc(
        'get_vault_real',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );
      
      // Debug: print('Vault real response: ${response?.length ?? 0} entries');
      
      if (response == null) return [];
      
      // Filter to only include vault type entries
      final vaultEntries = (response as List)
          .where((json) => json['location_type'] == 'vault')
          .map((json) => VaultRealEntry.fromJson(json))
          .toList();
      
      return vaultEntries;
    } catch (e) {
      // Debug: print('Error fetching vault real: $e');
      return [];
    }
  }
}

// Models
class VaultRealEntry {
  final String recordDate;
  final String locationId;
  final String locationName;
  final String locationType;
  final List<VaultCurrencySummary> currencySummary;

  VaultRealEntry({
    required this.recordDate,
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.currencySummary,
  });

  factory VaultRealEntry.fromJson(Map<String, dynamic> json) {
    return VaultRealEntry(
      recordDate: json['record_date'] ?? '',
      locationId: json['location_id'] ?? '',
      locationName: json['location_name'] ?? '',
      locationType: json['location_type'] ?? '',
      currencySummary: (json['currency_summary'] as List? ?? [])
          .map((cs) => VaultCurrencySummary.fromJson(cs))
          .toList(),
    );
  }
  
  // Helper method to get primary currency symbol
  String getCurrencySymbol() {
    if (currencySummary.isNotEmpty) {
      return currencySummary.first.symbol;
    }
    return '';
  }
  
  // Helper method to get total value across all currencies
  double getTotalValue() {
    return currencySummary.fold(0.0, (sum, currency) => sum + currency.totalValue);
  }
  
  // Helper to determine transaction type based on value
  String getTransactionType() {
    final total = getTotalValue();
    if (total < 0) {
      return 'Outflow';
    } else if (total > 0) {
      return 'Inflow';
    } else {
      return 'No Change';
    }
  }
}

class VaultCurrencySummary {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double totalValue;
  final List<VaultDenomination> denominations;

  VaultCurrencySummary({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.totalValue,
    required this.denominations,
  });

  factory VaultCurrencySummary.fromJson(Map<String, dynamic> json) {
    return VaultCurrencySummary(
      currencyId: json['currency_id'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      currencyName: json['currency_name'] ?? '',
      symbol: json['symbol'] ?? '',
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      denominations: (json['denominations'] as List? ?? [])
          .map((d) => VaultDenomination.fromJson(d))
          .toList(),
    );
  }
}

class VaultDenomination {
  final double denominationValue;
  final int dailyChange;
  final int runningQuantity;
  final double runningTotal;

  VaultDenomination({
    required this.denominationValue,
    required this.dailyChange,
    required this.runningQuantity,
    required this.runningTotal,
  });

  factory VaultDenomination.fromJson(Map<String, dynamic> json) {
    return VaultDenomination(
      denominationValue: (json['denomination_value'] as num?)?.toDouble() ?? 0.0,
      dailyChange: json['daily_change'] ?? 0,
      runningQuantity: json['running_quantity'] ?? 0,
      runningTotal: (json['running_total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// Display model for the UI
class VaultRealDisplay {
  final String date;
  final String title;
  final String locationName;
  final double amount;
  final String currencySymbol;
  final VaultRealEntry realEntry;

  VaultRealDisplay({
    required this.date,
    required this.title,
    required this.locationName,
    required this.amount,
    required this.currencySymbol,
    required this.realEntry,
  });
}

// Parameters for the provider
class VaultRealParams {
  final String companyId;
  final String storeId;
  final int offset;
  final int limit;

  VaultRealParams({
    required this.companyId,
    required this.storeId,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaultRealParams &&
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