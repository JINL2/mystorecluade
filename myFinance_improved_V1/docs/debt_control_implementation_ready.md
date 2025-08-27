# Debt Control Implementation Guide - v2.0 (Final)

## 🎯 Overview

This guide implements the Debt Control feature using the new v2 RPC function that returns BOTH Company and Store perspectives in a single call.

### Key Values (Verified)
- **Company View**: ₫67,770,748 (sum of all stores)
- **Store View (test1)**: ₫34,044,202 (single store only)

---

## ✅ RPC Function: `get_debt_control_data_v2`

### Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `p_company_id` | UUID | ✅ | - | Company ID |
| `p_store_id` | UUID | ❌ | NULL | Store ID for store perspective |
| `p_filter` | VARCHAR | ❌ | 'all' | 'all', 'internal', 'external' |
| `p_show_all` | BOOLEAN | ❌ | FALSE | Show zero-balance counterparties |

### Response Structure
```json
{
  "company": {
    "metadata": { /* company perspective metadata */ },
    "summary": { /* company totals */ },
    "store_aggregates": [ /* breakdown by store */ ],
    "records": [ /* counterparty records */ ]
  },
  "store": {
    "metadata": { /* store perspective metadata */ },
    "summary": { /* store totals */ },
    "store_aggregates": [], // Always empty for store view
    "records": [ /* counterparty records for this store */ ]
  },
  "metadata": {
    "version": "2.0",
    "generated_at": "2025-08-26T...",
    "has_both_perspectives": true
  }
}
```

---

## 📱 Flutter Implementation

### 1. Data Models
Create `lib/models/debt_control_v2_models.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// Main V2 Response Model
class DebtControlV2Response {
  final DebtPerspectiveData? company;
  final DebtPerspectiveData? store;
  final DebtV2Metadata metadata;

  DebtControlV2Response({
    this.company,
    this.store,
    required this.metadata,
  });

  factory DebtControlV2Response.fromJson(Map<String, dynamic> json) {
    return DebtControlV2Response(
      company: json['company'] != null 
        ? DebtPerspectiveData.fromJson(json['company'] as Map<String, dynamic>)
        : null,
      store: json['store'] != null 
        ? DebtPerspectiveData.fromJson(json['store'] as Map<String, dynamic>)
        : null,
      metadata: DebtV2Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }
  
  // Helper to get current perspective based on UI state
  DebtPerspectiveData? getPerspective(bool isCompanyView) {
    return isCompanyView ? company : store;
  }
}

// Perspective Data Model
class DebtPerspectiveData {
  final DebtMetadata metadata;
  final DebtSummary summary;
  final List<StoreAggregate> storeAggregates;
  final List<DebtRecord> records;

  DebtPerspectiveData({
    required this.metadata,
    required this.summary,
    required this.storeAggregates,
    required this.records,
  });

  factory DebtPerspectiveData.fromJson(Map<String, dynamic> json) {
    return DebtPerspectiveData(
      metadata: DebtMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      summary: DebtSummary.fromJson(json['summary'] as Map<String, dynamic>),
      storeAggregates: (json['store_aggregates'] as List? ?? [])
          .map((e) => StoreAggregate.fromJson(e as Map<String, dynamic>))
          .toList(),
      records: (json['records'] as List? ?? [])
          .map((e) => DebtRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// V2 Root Metadata
class DebtV2Metadata {
  final String version;
  final DateTime generatedAt;
  final bool hasBothPerspectives;

  DebtV2Metadata({
    required this.version,
    required this.generatedAt,
    required this.hasBothPerspectives,
  });

  factory DebtV2Metadata.fromJson(Map<String, dynamic> json) {
    return DebtV2Metadata(
      version: json['version'] as String,
      generatedAt: DateTime.parse(json['generated_at'] as String),
      hasBothPerspectives: json['has_both_perspectives'] as bool,
    );
  }
}

// Perspective Metadata
class DebtMetadata {
  final String companyId;
  final String? storeId;
  final String? storeName;
  final String perspective;
  final String filter;
  final DateTime generatedAt;
  final String currency;

  DebtMetadata({
    required this.companyId,
    this.storeId,
    this.storeName,
    required this.perspective,
    required this.filter,
    required this.generatedAt,
    required this.currency,
  });

  factory DebtMetadata.fromJson(Map<String, dynamic> json) {
    return DebtMetadata(
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      perspective: json['perspective'] as String,
      filter: json['filter'] as String,
      generatedAt: DateTime.parse(json['generated_at'] as String),
      currency: json['currency'] as String,
    );
  }
  
  bool get isCompanyPerspective => perspective == 'company';
  bool get isStorePerspective => perspective == 'store';
  
  String get displayTitle {
    if (isStorePerspective && storeName != null) {
      return storeName!;
    }
    return isCompanyPerspective ? 'Company Overview' : 'Store View';
  }
  
  String get displaySubtitle {
    return isCompanyPerspective
      ? 'Company-wide view (all stores aggregated)'
      : 'Store-specific view';
  }
}

// Summary Model
class DebtSummary {
  final double totalReceivable;
  final double totalPayable;
  final double netPosition;
  final double internalReceivable;
  final double internalPayable;
  final double externalReceivable;
  final double externalPayable;
  final int counterpartyCount;
  final int transactionCount;

  DebtSummary({
    required this.totalReceivable,
    required this.totalPayable,
    required this.netPosition,
    required this.internalReceivable,
    required this.internalPayable,
    required this.externalReceivable,
    required this.externalPayable,
    required this.counterpartyCount,
    required this.transactionCount,
  });

  factory DebtSummary.fromJson(Map<String, dynamic> json) {
    return DebtSummary(
      totalReceivable: (json['total_receivable'] as num? ?? 0).toDouble(),
      totalPayable: (json['total_payable'] as num? ?? 0).toDouble(),
      netPosition: (json['net_position'] as num? ?? 0).toDouble(),
      internalReceivable: (json['internal_receivable'] as num? ?? 0).toDouble(),
      internalPayable: (json['internal_payable'] as num? ?? 0).toDouble(),
      externalReceivable: (json['external_receivable'] as num? ?? 0).toDouble(),
      externalPayable: (json['external_payable'] as num? ?? 0).toDouble(),
      counterpartyCount: json['counterparty_count'] as int? ?? 0,
      transactionCount: json['transaction_count'] as int? ?? 0,
    );
  }
  
  double get internalNet => internalReceivable - internalPayable;
  double get externalNet => externalReceivable - externalPayable;
  bool get isNetReceivable => netPosition > 0;
  
  String get netPositionFormatted => _formatCurrency(netPosition);
  String get netPositionStatus => isNetReceivable ? 'Net Receivable' : 'Net Payable';
  
  String formatCompact(double value) {
    final absValue = value.abs();
    String result;
    if (absValue >= 1000000000) {
      result = '₫${(absValue / 1000000000).toStringAsFixed(1)}B';
    } else if (absValue >= 1000000) {
      result = '₫${(absValue / 1000000).toStringAsFixed(1)}M';
    } else if (absValue >= 1000) {
      result = '₫${(absValue / 1000).toStringAsFixed(1)}K';
    } else {
      result = '₫${absValue.toStringAsFixed(0)}';
    }
    return value < 0 ? '-$result' : result;
  }
  
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    return formatter.format(amount.abs());
  }
}

// Store Aggregate Model
class StoreAggregate {
  final String storeId;
  final String storeName;
  final double receivable;
  final double payable;
  final double netPosition;
  final int counterpartyCount;

  StoreAggregate({
    required this.storeId,
    required this.storeName,
    required this.receivable,
    required this.payable,
    required this.netPosition,
    required this.counterpartyCount,
  });

  factory StoreAggregate.fromJson(Map<String, dynamic> json) {
    return StoreAggregate(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      receivable: (json['receivable'] as num? ?? 0).toDouble(),
      payable: (json['payable'] as num? ?? 0).toDouble(),
      netPosition: (json['net_position'] as num? ?? 0).toDouble(),
      counterpartyCount: json['counterparty_count'] as int? ?? 0,
    );
  }
  
  String get netPositionCompact {
    final absAmount = netPosition.abs();
    if (absAmount >= 1000000) {
      return '${(absAmount / 1000000).toStringAsFixed(1)}M';
    } else if (absAmount >= 1000) {
      return '${(absAmount / 1000).toStringAsFixed(1)}K';
    }
    return absAmount.toStringAsFixed(0);
  }
}

// Debt Record Model
class DebtRecord {
  final String counterpartyId;
  final String counterpartyName;
  final bool isInternal;
  final double receivableAmount;
  final double payableAmount;
  final double netAmount;
  final DateTime? lastActivity;
  final int transactionCount;

  DebtRecord({
    required this.counterpartyId,
    required this.counterpartyName,
    required this.isInternal,
    required this.receivableAmount,
    required this.payableAmount,
    required this.netAmount,
    this.lastActivity,
    required this.transactionCount,
  });

  factory DebtRecord.fromJson(Map<String, dynamic> json) {
    return DebtRecord(
      counterpartyId: json['counterparty_id'] as String,
      counterpartyName: json['counterparty_name'] as String,
      isInternal: json['is_internal'] as bool,
      receivableAmount: (json['receivable_amount'] as num? ?? 0).toDouble(),
      payableAmount: (json['payable_amount'] as num? ?? 0).toDouble(),
      netAmount: (json['net_amount'] as num? ?? 0).toDouble(),
      lastActivity: json['last_activity'] != null 
        ? DateTime.parse(json['last_activity'] as String)
        : null,
      transactionCount: json['transaction_count'] as int? ?? 0,
    );
  }
  
  bool get isNetPayable => netAmount < 0;
  String get statusText => netAmount >= 0 ? 'They owe us' : 'We owe them';
  
  String get lastActivityText {
    if (lastActivity == null) return 'No recent activity';
    
    final now = DateTime.now();
    final difference = now.difference(lastActivity!);
    
    if (difference.inDays == 0) {
      return 'Last activity today';
    } else if (difference.inDays == 1) {
      return 'Last activity yesterday';
    } else if (difference.inDays < 7) {
      return 'Last activity ${difference.inDays}d ago';
    } else {
      return 'Last activity ${(difference.inDays / 7).floor()}w ago';
    }
  }
  
  String get netAmountFormatted {
    final formatter = NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    return formatter.format(netAmount.abs());
  }
}
```

### 2. Repository
Create `lib/repositories/debt_control_v2_repository.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_control_v2_models.dart';

class DebtControlV2Repository {
  final SupabaseClient _client;

  DebtControlV2Repository(this._client);

  /// Fetches both company and store perspectives in one call
  Future<DebtControlV2Response> getDebtControlData({
    required String companyId,
    String? storeId,
    String filter = 'all',
    bool showAll = false,
  }) async {
    try {
      // Validate filter
      if (!['all', 'internal', 'external'].contains(filter)) {
        throw ArgumentError('Invalid filter: $filter');
      }
      
      final response = await _client.rpc(
        'get_debt_control_data_v2',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_filter': filter,
          'p_show_all': showAll,
        },
      );

      if (response == null) {
        throw Exception('No response from server');
      }

      return DebtControlV2Response.fromJson(response as Map<String, dynamic>);
      
    } catch (e) {
      print('DebtControlV2Repository Error: $e');
      throw Exception('Failed to fetch debt control data: $e');
    }
  }
}
```

### 3. Providers and UI
[Previous content continues as shown above...]

---

## ✅ Testing

```dart
void testV2Function() async {
  final supabase = Supabase.instance.client;
  
  // Single call gets BOTH perspectives
  final response = await supabase.rpc(
    'get_debt_control_data_v2',
    params: {
      'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
      'p_store_id': 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
      'p_filter': 'all',
      'p_show_all': false,
    },
  );
  
  // Access company data
  final companyData = response['company'];
  print('Company Net Position: ${companyData['summary']['net_position']}');
  // Should print: 67770748.00
  
  // Access store data
  final storeData = response['store'];
  print('Store Net Position: ${storeData['summary']['net_position']}');
  // Should print: 34044202.00
  
  // Store aggregates (company view only)
  final storeAggregates = companyData['store_aggregates'];
  for (var store in storeAggregates) {
    print('${store['store_name']}: ${store['net_position']}');
  }
  // Should print:
  // test1: 34044202.00
  // test3: 32726546.00
}
```

---

## 🎯 Key Differences: v1 vs v2

| Feature | v1 (removed) | v2 (current) |
|---------|--------------|--------------|
| **Function Name** | `get_debt_control_data` | `get_debt_control_data_v2` |
| **Call Pattern** | One perspective per call | Both perspectives in one call |
| **Perspective Parameter** | Required (`p_perspective`) | Not needed (returns both) |
| **Response** | Single perspective object | Nested `company` and `store` objects |
| **Store ID** | Required for store view only | Optional (if provided, returns both views) |
| **Show All** | Not supported | Supported via `p_show_all` |
| **Performance** | Two calls for both views | Single call for both views |

---

## 📊 Expected Results

### Company Perspective
- **Net Position**: ₫67,770,748
- **Store Breakdown**:
  - test1: ₫34,044,202
  - test3: ₫32,726,546

### Store Perspective (test1)
- **Net Position**: ₫34,044,202
- **Records**: Only counterparties for this store

---

## 🔍 Filter Behavior

| Filter | `company` object | `store` object |
|--------|------------------|----------------|
| `all` | All counterparties across all stores | All counterparties for specific store |
| `internal` | Internal only, all stores | Internal only, specific store |
| `external` | External only, all stores | External only, specific store |

---

## 🚀 Migration from v1 to v2

If migrating from v1:

1. **Update RPC call**: Change function name to `get_debt_control_data_v2`
2. **Remove perspective parameter**: No longer needed
3. **Update response handling**: Access `response.company` or `response.store`
4. **Single call optimization**: No need to call twice for both views

### Before (v1):
```dart
// Need two separate calls
final companyData = await supabase.rpc('get_debt_control_data', 
  params: {'p_perspective': 'company', ...});
final storeData = await supabase.rpc('get_debt_control_data', 
  params: {'p_perspective': 'store', ...});
```

### After (v2):
```dart
// Single call gets both
final response = await supabase.rpc('get_debt_control_data_v2', 
  params: {'p_company_id': id, 'p_store_id': storeId, ...});
final companyData = response['company'];
final storeData = response['store'];
```

---

## 🎨 UI Implementation Notes

### Tab Switching
- No need to refetch data when switching tabs
- Both perspectives already loaded
- Instant tab switching

### Performance Benefits
- 50% reduction in API calls
- Faster initial load
- Reduced network traffic
- Better user experience

### State Management
```dart
// Single provider for both views
final debtDataProvider = FutureProvider<DebtControlV2Response>((ref) {
  // One call gets everything
  return repository.getDebtControlData(...);
});

// Switch views without refetching
final perspective = ref.watch(perspectiveProvider);
final data = debtData.getPerspective(perspective == 'company');
```

---

## ✅ Checklist for Implementation

- [ ] Remove old v1 function references
- [ ] Update to v2 function name
- [ ] Update response handling for nested structure
- [ ] Test company perspective (should show ₫67.7M)
- [ ] Test store perspective (should show ₫34.0M)
- [ ] Verify store aggregates in company view
- [ ] Test filters (all/internal/external)
- [ ] Update UI to handle both perspectives
- [ ] Remove unnecessary API calls

---

*Version: 2.0 Final*
*RPC Function: `get_debt_control_data_v2`*
*Last Updated: 2025-08-26*