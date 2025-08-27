# Debt Control System - Advanced RPC Specification with Perspectives

## 🎯 Function Overview

The `get_debt_control_data` function provides comprehensive debt information with support for:
- **Two Perspectives**: Company-wide view or Store-specific view
- **Three Filters**: All, Internal companies only, or External companies only
- **Complete Metadata**: Includes filter state and perspective in response
- **Store Aggregates**: Summary by store when in company perspective

## 📡 RPC Function Details

### Function Name
```
get_debt_control_data
```

### Parameters Matrix

| Parameter | Type | Required | Default | Options | Description |
|-----------|------|----------|---------|---------|-------------|
| `p_company_id` | UUID | ✅ Yes | - | Valid company UUID | The company to fetch debt data for |
| `p_store_id` | UUID | ❌ No | NULL | Valid store UUID or NULL | Required for store perspective, optional for company |
| `p_perspective` | VARCHAR | ❌ No | 'company' | 'company', 'store' | The viewing perspective |
| `p_filter` | VARCHAR | ❌ No | 'all' | 'all', 'internal', 'external' | Filter for counterparty type |

## 📊 Perspective & Filter Combinations

### Matrix of Valid Calls

| Perspective | Store ID | Filter | Use Case |
|------------|----------|--------|----------|
| `company` | NULL | `all` | View all company debts across all stores |
| `company` | NULL | `internal` | View only internal/group company debts |
| `company` | NULL | `external` | View only external company debts |
| `store` | UUID | `all` | View all debts for specific store |
| `store` | UUID | `internal` | View internal debts for specific store |
| `store` | UUID | `external` | View external debts for specific store |

## 🔄 Request Examples

### 1. Company Perspective - All Counterparties
```dart
final response = await supabase.rpc(
  'get_debt_control_data',
  params: {
    'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
    'p_store_id': null,
    'p_perspective': 'company',
    'p_filter': 'all'
  }
);
```

### 2. Store Perspective - Internal Only
```dart
final response = await supabase.rpc(
  'get_debt_control_data',
  params: {
    'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
    'p_store_id': 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
    'p_perspective': 'store',
    'p_filter': 'internal'
  }
);
```

### 3. Company Perspective - External Only
```dart
final response = await supabase.rpc(
  'get_debt_control_data',
  params: {
    'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
    'p_store_id': null,
    'p_perspective': 'company',
    'p_filter': 'external'
  }
);
```

## 📤 Response Structure

### Complete Response Format
```json
{
  "metadata": {
    "company_id": "7a2545e0-e112-4b0c-9c59-221a530c4602",
    "store_id": null,
    "perspective": "company",
    "filter": "all",
    "generated_at": "2025-08-25T18:28:23.621981+00:00",
    "currency": "₫"
  },
  "summary": {
    "total_receivable": 4201490,
    "total_payable": -17585044,
    "net_position": 21786534,
    "internal_receivable": 4392490,
    "internal_payable": -27816558,
    "external_receivable": -191000,
    "external_payable": 10231514,
    "counterparty_count": 4,
    "transaction_count": 28
  },
  "store_aggregates": [
    {
      "store_id": "d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff",
      "store_name": "test1",
      "receivable": 4082279,
      "payable": -29961923,
      "net_position": 34044202,
      "counterparty_count": 3
    }
  ],
  "records": [
    {
      "counterparty_id": "c18be9ce-3aa9-4fcc-afb3-2494f5152fef",
      "counterparty_name": "ABC Corporation",
      "is_internal": true,
      "store_id": null,
      "store_name": null,
      "receivable_amount": 3813811,
      "payable_amount": -33496335,
      "net_amount": 37310146,
      "last_activity": "2025-08-24",
      "transaction_count": 15
    }
  ]
}
```

## 🏗️ Flutter Data Models

### 1. Complete Response Model
```dart
class DebtControlResponse {
  final DebtMetadata metadata;
  final DebtSummary summary;
  final List<StoreAggregate> storeAggregates;
  final List<DebtRecord> records;

  DebtControlResponse({
    required this.metadata,
    required this.summary,
    required this.storeAggregates,
    required this.records,
  });

  factory DebtControlResponse.fromJson(Map<String, dynamic> json) {
    return DebtControlResponse(
      metadata: DebtMetadata.fromJson(json['metadata']),
      summary: DebtSummary.fromJson(json['summary']),
      storeAggregates: (json['store_aggregates'] as List)
          .map((e) => StoreAggregate.fromJson(e))
          .toList(),
      records: (json['records'] as List)
          .map((e) => DebtRecord.fromJson(e))
          .toList(),
    );
  }
}
```

### 2. Metadata Model
```dart
class DebtMetadata {
  final String companyId;
  final String? storeId;
  final String perspective;
  final String filter;
  final DateTime generatedAt;
  final String currency;

  DebtMetadata({
    required this.companyId,
    this.storeId,
    required this.perspective,
    required this.filter,
    required this.generatedAt,
    required this.currency,
  });

  factory DebtMetadata.fromJson(Map<String, dynamic> json) {
    return DebtMetadata(
      companyId: json['company_id'],
      storeId: json['store_id'],
      perspective: json['perspective'],
      filter: json['filter'],
      generatedAt: DateTime.parse(json['generated_at']),
      currency: json['currency'],
    );
  }
  
  bool get isCompanyPerspective => perspective == 'company';
  bool get isStorePerspective => perspective == 'store';
  bool get isAllFilter => filter == 'all';
  bool get isInternalFilter => filter == 'internal';
  bool get isExternalFilter => filter == 'external';
}
```

### 3. Summary Model
```dart
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
      totalReceivable: (json['total_receivable'] ?? 0).toDouble(),
      totalPayable: (json['total_payable'] ?? 0).toDouble(),
      netPosition: (json['net_position'] ?? 0).toDouble(),
      internalReceivable: (json['internal_receivable'] ?? 0).toDouble(),
      internalPayable: (json['internal_payable'] ?? 0).toDouble(),
      externalReceivable: (json['external_receivable'] ?? 0).toDouble(),
      externalPayable: (json['external_payable'] ?? 0).toDouble(),
      counterpartyCount: json['counterparty_count'] ?? 0,
      transactionCount: json['transaction_count'] ?? 0,
    );
  }
  
  double get internalNet => internalReceivable - internalPayable;
  double get externalNet => externalReceivable - externalPayable;
  bool get isNetReceivable => netPosition > 0;
  bool get isNetPayable => netPosition < 0;
}
```

### 4. Store Aggregate Model
```dart
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
      storeId: json['store_id'],
      storeName: json['store_name'],
      receivable: (json['receivable'] ?? 0).toDouble(),
      payable: (json['payable'] ?? 0).toDouble(),
      netPosition: (json['net_position'] ?? 0).toDouble(),
      counterpartyCount: json['counterparty_count'] ?? 0,
    );
  }
}
```

### 5. Debt Record Model
```dart
class DebtRecord {
  final String counterpartyId;
  final String counterpartyName;
  final bool isInternal;
  final String? storeId;
  final String? storeName;
  final double receivableAmount;
  final double payableAmount;
  final double netAmount;
  final DateTime? lastActivity;
  final int transactionCount;

  DebtRecord({
    required this.counterpartyId,
    required this.counterpartyName,
    required this.isInternal,
    this.storeId,
    this.storeName,
    required this.receivableAmount,
    required this.payableAmount,
    required this.netAmount,
    this.lastActivity,
    required this.transactionCount,
  });

  factory DebtRecord.fromJson(Map<String, dynamic> json) {
    return DebtRecord(
      counterpartyId: json['counterparty_id'],
      counterpartyName: json['counterparty_name'],
      isInternal: json['is_internal'],
      storeId: json['store_id'],
      storeName: json['store_name'],
      receivableAmount: (json['receivable_amount'] ?? 0).toDouble(),
      payableAmount: (json['payable_amount'] ?? 0).toDouble(),
      netAmount: (json['net_amount'] ?? 0).toDouble(),
      lastActivity: json['last_activity'] != null 
        ? DateTime.parse(json['last_activity']) 
        : null,
      transactionCount: json['transaction_count'] ?? 0,
    );
  }
  
  bool get isNetPayable => netAmount < 0;
  double get absoluteNetAmount => netAmount.abs();
}
```

## 🎮 Repository Implementation

```dart
class DebtControlRepository {
  final SupabaseClient _client;

  DebtControlRepository(this._client);

  /// Fetch debt control data with full control over perspective and filter
  Future<DebtControlResponse> getDebtControlData({
    required String companyId,
    String? storeId,
    String perspective = 'company',
    String filter = 'all',
  }) async {
    try {
      // Validate perspective
      if (!['company', 'store'].contains(perspective)) {
        throw ArgumentError('Invalid perspective: $perspective');
      }
      
      // Validate filter
      if (!['all', 'internal', 'external'].contains(filter)) {
        throw ArgumentError('Invalid filter: $filter');
      }
      
      // Store perspective requires store_id
      if (perspective == 'store' && storeId == null) {
        throw ArgumentError('Store ID is required for store perspective');
      }
      
      final response = await _client.rpc(
        'get_debt_control_data',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_perspective': perspective,
          'p_filter': filter,
        },
      );

      if (response == null) {
        throw Exception('No response from server');
      }

      return DebtControlResponse.fromJson(response);
      
    } catch (e) {
      throw Exception('Failed to fetch debt control data: $e');
    }
  }

  /// Convenience method for company perspective
  Future<DebtControlResponse> getCompanyDebtData({
    required String companyId,
    String filter = 'all',
  }) async {
    return getDebtControlData(
      companyId: companyId,
      perspective: 'company',
      filter: filter,
    );
  }

  /// Convenience method for store perspective
  Future<DebtControlResponse> getStoreDebtData({
    required String companyId,
    required String storeId,
    String filter = 'all',
  }) async {
    return getDebtControlData(
      companyId: companyId,
      storeId: storeId,
      perspective: 'store',
      filter: filter,
    );
  }
}
```

## 🎨 Provider Implementation (Riverpod)

```dart
// Perspective state
enum DebtPerspective { company, store }

final debtPerspectiveProvider = StateProvider<DebtPerspective>((ref) {
  return DebtPerspective.company;
});

// Filter state
enum DebtFilter { all, internal, external }

final debtFilterProvider = StateProvider<DebtFilter>((ref) {
  return DebtFilter.all;
});

// Current store for store perspective
final selectedStoreIdProvider = StateProvider<String?>((ref) {
  // Get from app state or user selection
  return null;
});

// Main debt data provider
final debtControlProvider = FutureProvider<DebtControlResponse>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final repository = DebtControlRepository(client);
  
  final perspective = ref.watch(debtPerspectiveProvider);
  final filter = ref.watch(debtFilterProvider);
  final storeId = ref.watch(selectedStoreIdProvider);
  final companyId = ref.watch(currentCompanyIdProvider);
  
  return repository.getDebtControlData(
    companyId: companyId,
    storeId: perspective == DebtPerspective.store ? storeId : null,
    perspective: perspective.name,
    filter: filter.name,
  );
});

// Computed provider for UI display
final debtDisplayInfoProvider = Provider<DebtDisplayInfo>((ref) {
  final debtAsync = ref.watch(debtControlProvider);
  
  return debtAsync.when(
    data: (response) => DebtDisplayInfo(
      perspectiveName: response.metadata.isCompanyPerspective 
        ? 'Company-wide view (all stores aggregated)'
        : 'Store view (${response.metadata.storeId})',
      filterName: _getFilterDisplayName(response.metadata.filter),
      counterpartyCount: response.summary.counterpartyCount,
      netPosition: response.summary.netPosition,
      isLoading: false,
    ),
    loading: () => DebtDisplayInfo.loading(),
    error: (_, __) => DebtDisplayInfo.error(),
  );
});

String _getFilterDisplayName(String filter) {
  switch (filter) {
    case 'internal':
      return 'My Group';
    case 'external':
      return 'External';
    default:
      return 'All Companies';
  }
}
```

## 📱 UI Implementation

```dart
class DebtControlPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perspective = ref.watch(debtPerspectiveProvider);
    final filter = ref.watch(debtFilterProvider);
    final debtDataAsync = ref.watch(debtControlProvider);

    return Scaffold(
      body: Column(
        children: [
          // Perspective Tabs
          Row(
            children: [
              Expanded(
                child: TabButton(
                  title: 'Company',
                  isActive: perspective == DebtPerspective.company,
                  onTap: () {
                    ref.read(debtPerspectiveProvider.notifier).state = 
                      DebtPerspective.company;
                  },
                ),
              ),
              Expanded(
                child: TabButton(
                  title: 'Store',
                  isActive: perspective == DebtPerspective.store,
                  onTap: () {
                    // Ensure store is selected
                    final storeId = ref.read(selectedStoreIdProvider);
                    if (storeId == null) {
                      // Show store selection dialog
                      _showStoreSelectionDialog(context, ref);
                    } else {
                      ref.read(debtPerspectiveProvider.notifier).state = 
                        DebtPerspective.store;
                    }
                  },
                ),
              ),
            ],
          ),
          
          // Filter Chips
          Row(
            children: [
              FilterChip(
                label: 'All',
                isSelected: filter == DebtFilter.all,
                onTap: () {
                  ref.read(debtFilterProvider.notifier).state = DebtFilter.all;
                },
              ),
              FilterChip(
                label: 'My Group',
                isSelected: filter == DebtFilter.internal,
                onTap: () {
                  ref.read(debtFilterProvider.notifier).state = DebtFilter.internal;
                },
              ),
              FilterChip(
                label: 'External',
                isSelected: filter == DebtFilter.external,
                onTap: () {
                  ref.read(debtFilterProvider.notifier).state = DebtFilter.external;
                },
              ),
            ],
          ),
          
          // Data Display
          Expanded(
            child: debtDataAsync.when(
              data: (response) => DebtDataView(response: response),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorView(error: error),
            ),
          ),
        ],
      ),
    );
  }
}

class DebtDataView extends StatelessWidget {
  final DebtControlResponse response;

  const DebtDataView({required this.response});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Summary Card
        SliverToBoxAdapter(
          child: DebtSummaryCard(
            metadata: response.metadata,
            summary: response.summary,
          ),
        ),
        
        // Store Aggregates (only in company perspective)
        if (response.metadata.isCompanyPerspective && 
            response.storeAggregates.isNotEmpty)
          SliverToBoxAdapter(
            child: StoreAggregatesSection(
              stores: response.storeAggregates,
            ),
          ),
        
        // Counterparty Records
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final record = response.records[index];
              return DebtRecordCard(record: record);
            },
            childCount: response.records.length,
          ),
        ),
      ],
    );
  }
}
```

## 🧪 Testing

```dart
void testDebtControlFunction() async {
  final supabase = Supabase.instance.client;
  
  // Test 1: Company perspective with all filter
  print('Test 1: Company perspective - All');
  var response = await supabase.rpc(
    'get_debt_control_data',
    params: {
      'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
      'p_perspective': 'company',
      'p_filter': 'all',
    },
  );
  print('Metadata: ${response['metadata']}');
  print('Summary: ${response['summary']}');
  print('Store Aggregates: ${response['store_aggregates'].length}');
  print('Records: ${response['records'].length}');
  
  // Test 2: Store perspective with internal filter
  print('\nTest 2: Store perspective - Internal only');
  response = await supabase.rpc(
    'get_debt_control_data',
    params: {
      'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602',
      'p_store_id': 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',
      'p_perspective': 'store',
      'p_filter': 'internal',
    },
  );
  print('Metadata: ${response['metadata']}');
  print('Summary: ${response['summary']}');
  print('Records: ${response['records'].length}');
  
  // Test 3: Parse into models
  print('\nTest 3: Model parsing');
  final debtResponse = DebtControlResponse.fromJson(response);
  print('Perspective: ${debtResponse.metadata.perspective}');
  print('Filter: ${debtResponse.metadata.filter}');
  print('Net Position: ${debtResponse.summary.netPosition}');
  print('Counter parties: ${debtResponse.summary.counterpartyCount}');
}
```

## 📊 Response Differences by Perspective

### Company Perspective Response
- **metadata.store_id**: Always `null`
- **store_aggregates**: Contains array of store summaries
- **records.store_id**: Always `null` (aggregated across stores)
- **records.store_name**: Always `null`

### Store Perspective Response
- **metadata.store_id**: Contains the selected store UUID
- **store_aggregates**: Always empty array `[]`
- **records.store_id**: Contains the store UUID
- **records.store_name**: Contains the store name

## 🔍 Filter Behavior

| Filter | Behavior |
|--------|----------|
| `all` | Returns all counterparties regardless of type |
| `internal` | Returns only counterparties where `is_internal = true` |
| `external` | Returns only counterparties where `is_internal = false` |

## ⚡ Performance Notes

1. **Single RPC Call**: All filtering and aggregation happens in the database
2. **No Client-Side Filtering**: The function returns exactly what you need
3. **Optimized Queries**: Uses temporary tables for efficient processing
4. **JSON Response**: Complete structured response in one call

## 🎯 Key Advantages

1. **Complete Context**: Metadata tells you exactly what view/filter is active
2. **Store Aggregates**: Company view includes store-by-store breakdown
3. **Consistent Structure**: Same response format for all combinations
4. **Server-Side Processing**: All heavy lifting done in database
5. **Type Safety**: Strongly typed models in Flutter

---

*Version: 2.0.0*
*Last Updated: 2025-08-26*