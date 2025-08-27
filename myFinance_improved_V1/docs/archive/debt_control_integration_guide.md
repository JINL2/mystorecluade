# Debt Control System - Flutter Integration Guide

## 📋 Overview
This guide provides complete instructions for integrating the Debt Control system into your Flutter application. The system tracks and manages company debts (receivables and payables) with support for multiple companies, stores, and filtering options.

## 🏗️ Architecture

```
Flutter App → Supabase RPC → get_all_debt_data() → Aggregated Debt Data
```

## 🔌 Supabase RPC Function

### Function Name
```dart
'get_all_debt_data'
```

### Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `p_company_id` | UUID | Yes | The company ID to fetch debt data for |

### Example Call
```dart
final response = await supabase.rpc(
  'get_all_debt_data',
  params: {
    'p_company_id': companyId,
  },
);
```

## 📊 Response Data Structure

### Raw Response Format
```dart
List<Map<String, dynamic>>
```

### Individual Record Structure
```dart
{
  "counterparty_id": "uuid-string",        // Unique ID of the counterparty
  "counterparty_name": "Company Name",     // Name of the counterparty
  "is_internal": true/false,               // Whether it's an internal company
  "store_id": "uuid-string" or null,       // Store ID (null for company-level)
  "store_name": "Store Name" or null,      // Store name
  "receivable_amount": 1234567.89,         // Amount to be received
  "payable_amount": 987654.32,             // Amount to be paid
  "net_amount": 246913.57,                 // Net position (receivable - payable)
  "last_activity": "2025-08-26",           // Last transaction date
  "transaction_count": 15                   // Number of transactions
}
```

## 🎯 Implementation Steps

### 1. Create Data Models

```dart
// lib/models/debt_record.dart

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
      counterpartyId: json['counterparty_id'] as String,
      counterpartyName: json['counterparty_name'] as String,
      isInternal: json['is_internal'] as bool,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      receivableAmount: (json['receivable_amount'] as num).toDouble(),
      payableAmount: (json['payable_amount'] as num).toDouble(),
      netAmount: (json['net_amount'] as num).toDouble(),
      lastActivity: json['last_activity'] != null 
        ? DateTime.parse(json['last_activity']) 
        : null,
      transactionCount: json['transaction_count'] as int,
    );
  }

  // Helper method to determine if this is a net payable or receivable
  bool get isNetPayable => netAmount < 0;
  
  // Helper method to get absolute net amount for display
  double get absoluteNetAmount => netAmount.abs();
}
```

### 2. Create Summary Model

```dart
// lib/models/debt_summary.dart

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
  final List<StoreAggregate> storeAggregates;

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
    this.storeAggregates = const [],
  });

  factory DebtSummary.fromRecords(List<DebtRecord> records) {
    double totalReceivable = 0;
    double totalPayable = 0;
    double internalReceivable = 0;
    double internalPayable = 0;
    double externalReceivable = 0;
    double externalPayable = 0;
    int transactionCount = 0;
    
    // Store aggregation map
    final storeMap = <String, StoreAggregate>{};

    for (final record in records) {
      totalReceivable += record.receivableAmount;
      totalPayable += record.payableAmount;
      transactionCount += record.transactionCount;

      if (record.isInternal) {
        internalReceivable += record.receivableAmount;
        internalPayable += record.payableAmount;
      } else {
        externalReceivable += record.receivableAmount;
        externalPayable += record.payableAmount;
      }

      // Aggregate by store
      if (record.storeId != null) {
        final storeId = record.storeId!;
        if (storeMap.containsKey(storeId)) {
          storeMap[storeId]!.addRecord(record);
        } else {
          storeMap[storeId] = StoreAggregate(
            storeId: storeId,
            storeName: record.storeName ?? 'Unknown',
            receivable: record.receivableAmount,
            payable: record.payableAmount,
            counterpartyCount: 1,
          );
        }
      }
    }

    return DebtSummary(
      totalReceivable: totalReceivable,
      totalPayable: totalPayable,
      netPosition: totalReceivable - totalPayable,
      internalReceivable: internalReceivable,
      internalPayable: internalPayable,
      externalReceivable: externalReceivable,
      externalPayable: externalPayable,
      counterpartyCount: records.length,
      transactionCount: transactionCount,
      storeAggregates: storeMap.values.toList()
        ..sort((a, b) => b.netPosition.abs().compareTo(a.netPosition.abs())),
    );
  }
}

class StoreAggregate {
  final String storeId;
  final String storeName;
  double receivable;
  double payable;
  int counterpartyCount;

  StoreAggregate({
    required this.storeId,
    required this.storeName,
    required this.receivable,
    required this.payable,
    required this.counterpartyCount,
  });

  double get netPosition => receivable - payable;

  void addRecord(DebtRecord record) {
    receivable += record.receivableAmount;
    payable += record.payableAmount;
    counterpartyCount++;
  }
}
```

### 3. Create Repository

```dart
// lib/repositories/debt_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class DebtRepository {
  final SupabaseClient _client;

  DebtRepository(this._client);

  /// Fetch all debt data for a company
  Future<List<DebtRecord>> getAllDebtData(String companyId) async {
    try {
      final response = await _client.rpc(
        'get_all_debt_data',
        params: {
          'p_company_id': companyId,
        },
      );

      if (response == null) {
        return [];
      }

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((json) => DebtRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch debt data: $e');
    }
  }

  /// Fetch debt data with local filtering
  Future<List<DebtRecord>> getFilteredDebtData({
    required String companyId,
    String? storeId,
    DebtFilter filter = DebtFilter.all,
  }) async {
    final allRecords = await getAllDebtData(companyId);
    
    return allRecords.where((record) {
      // Filter by store if specified
      if (storeId != null && record.storeId != storeId) {
        return false;
      }
      
      // Filter by type
      switch (filter) {
        case DebtFilter.internal:
          return record.isInternal;
        case DebtFilter.external:
          return !record.isInternal;
        case DebtFilter.all:
          return true;
      }
    }).toList()
      ..sort((a, b) => b.netAmount.abs().compareTo(a.netAmount.abs()));
  }

  /// Get aggregated debt data by counterparty (company view)
  Future<List<DebtRecord>> getAggregatedDebtData({
    required String companyId,
    DebtFilter filter = DebtFilter.all,
  }) async {
    final allRecords = await getAllDebtData(companyId);
    
    // Filter first
    final filtered = allRecords.where((record) {
      switch (filter) {
        case DebtFilter.internal:
          return record.isInternal;
        case DebtFilter.external:
          return !record.isInternal;
        case DebtFilter.all:
          return true;
      }
    }).toList();

    // Aggregate by counterparty
    final Map<String, DebtRecord> aggregated = {};
    
    for (final record in filtered) {
      final key = record.counterpartyId;
      
      if (aggregated.containsKey(key)) {
        final existing = aggregated[key]!;
        aggregated[key] = DebtRecord(
          counterpartyId: existing.counterpartyId,
          counterpartyName: existing.counterpartyName,
          isInternal: existing.isInternal,
          storeId: null, // Aggregated view has no single store
          storeName: null,
          receivableAmount: existing.receivableAmount + record.receivableAmount,
          payableAmount: existing.payableAmount + record.payableAmount,
          netAmount: existing.netAmount + record.netAmount,
          lastActivity: _getLatestDate(existing.lastActivity, record.lastActivity),
          transactionCount: existing.transactionCount + record.transactionCount,
        );
      } else {
        aggregated[key] = record;
      }
    }

    return aggregated.values.toList()
      ..sort((a, b) => b.netAmount.abs().compareTo(a.netAmount.abs()));
  }

  DateTime? _getLatestDate(DateTime? date1, DateTime? date2) {
    if (date1 == null) return date2;
    if (date2 == null) return date1;
    return date1.isAfter(date2) ? date1 : date2;
  }
}

enum DebtFilter { all, internal, external }
```

### 4. Create Provider (Using Riverpod)

```dart
// lib/providers/debt_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Debt repository provider
final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DebtRepository(client);
});

// Current viewpoint provider (company or store)
enum DebtViewpoint { company, store }

final debtViewpointProvider = StateProvider<DebtViewpoint>((ref) {
  return DebtViewpoint.company;
});

// Current filter provider
final debtFilterProvider = StateProvider<DebtFilter>((ref) {
  return DebtFilter.all;
});

// Current store ID provider (for store view)
final currentStoreIdProvider = StateProvider<String?>((ref) {
  // Get from app state or user preferences
  return null;
});

// Debt data provider
final debtDataProvider = FutureProvider<List<DebtRecord>>((ref) async {
  final repository = ref.watch(debtRepositoryProvider);
  final viewpoint = ref.watch(debtViewpointProvider);
  final filter = ref.watch(debtFilterProvider);
  final storeId = ref.watch(currentStoreIdProvider);
  
  // Assume you have a way to get current company ID
  final companyId = ref.watch(currentCompanyIdProvider);
  
  if (viewpoint == DebtViewpoint.company) {
    return repository.getAggregatedDebtData(
      companyId: companyId,
      filter: filter,
    );
  } else {
    return repository.getFilteredDebtData(
      companyId: companyId,
      storeId: storeId,
      filter: filter,
    );
  }
});

// Debt summary provider
final debtSummaryProvider = Provider<DebtSummary?>((ref) {
  final debtDataAsync = ref.watch(debtDataProvider);
  
  return debtDataAsync.when(
    data: (records) => DebtSummary.fromRecords(records),
    loading: () => null,
    error: (_, __) => null,
  );
});
```

### 5. Create UI Widget

```dart
// lib/widgets/debt_control_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DebtControlPage extends ConsumerWidget {
  const DebtControlPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewpoint = ref.watch(debtViewpointProvider);
    final filter = ref.watch(debtFilterProvider);
    final debtDataAsync = ref.watch(debtDataProvider);
    final summary = ref.watch(debtSummaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Debt Control'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    title: 'Company',
                    isActive: viewpoint == DebtViewpoint.company,
                    onTap: () {
                      ref.read(debtViewpointProvider.notifier).state = 
                        DebtViewpoint.company;
                    },
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    title: 'Store',
                    isActive: viewpoint == DebtViewpoint.store,
                    onTap: () {
                      ref.read(debtViewpointProvider.notifier).state = 
                        DebtViewpoint.store;
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Summary Card
          if (summary != null)
            _SummaryCard(summary: summary, viewpoint: viewpoint),
          
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Companies',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: filter == DebtFilter.all,
                      onTap: () {
                        ref.read(debtFilterProvider.notifier).state = 
                          DebtFilter.all;
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'My Group',
                      isSelected: filter == DebtFilter.internal,
                      onTap: () {
                        ref.read(debtFilterProvider.notifier).state = 
                          DebtFilter.internal;
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'External',
                      isSelected: filter == DebtFilter.external,
                      onTap: () {
                        ref.read(debtFilterProvider.notifier).state = 
                          DebtFilter.external;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Debt List
          Expanded(
            child: debtDataAsync.when(
              data: (records) => _DebtList(records: records),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final DebtSummary summary;
  final DebtViewpoint viewpoint;

  const _SummaryCard({
    required this.summary,
    required this.viewpoint,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007AFF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewpoint == DebtViewpoint.company 
                        ? 'Company-wide view'
                        : 'Store view',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      viewpoint == DebtViewpoint.company
                        ? '(all stores aggregated)'
                        : '(single store)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${summary.counterpartyCount} counterparties',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Net Position',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            formatter.format(summary.netPosition),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            summary.netPosition >= 0 ? 'Net Receivable' : 'Net Payable',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.business,
                  title: 'Internal',
                  amount: summary.internalReceivable - summary.internalPayable,
                  receivable: summary.internalReceivable,
                  payable: summary.internalPayable,
                  formatter: formatter,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.public,
                  title: 'External',
                  amount: summary.externalReceivable - summary.externalPayable,
                  receivable: summary.externalReceivable,
                  payable: summary.externalPayable,
                  formatter: formatter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final double amount;
  final double receivable;
  final double payable;
  final NumberFormat formatter;

  const _SummaryItem({
    required this.icon,
    required this.title,
    required this.amount,
    required this.receivable,
    required this.payable,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatter.format(amount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R: ${formatter.format(receivable)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              Text(
                'P: ${formatter.format(payable)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _DebtList extends StatelessWidget {
  final List<DebtRecord> records;

  const _DebtList({required this.records});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₫', decimalDigits: 0);
    final dateFormatter = DateFormat('yyyy-MM-dd');

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final isNegative = record.netAmount < 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Navigate to detail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DebtDetailPage(
                    counterpartyId: record.counterpartyId,
                    counterpartyName: record.counterpartyName,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              record.counterpartyName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (record.isInternal) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Internal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        formatter.format(record.netAmount.abs()),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isNegative ? Colors.red : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Receivable: ${formatter.format(record.receivableAmount)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Payable: ${formatter.format(record.payableAmount)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions: ${record.transactionCount}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (record.lastActivity != null)
                        Text(
                          'Last: ${dateFormatter.format(record.lastActivity!)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                  if (record.storeName != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        record.storeName!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```

## 🔄 Data Flow Example

```dart
// 1. User selects company view with internal filter
ref.read(debtViewpointProvider.notifier).state = DebtViewpoint.company;
ref.read(debtFilterProvider.notifier).state = DebtFilter.internal;

// 2. Provider automatically fetches data
// debtDataProvider calls repository.getAggregatedDebtData()

// 3. Repository calls Supabase
await supabase.rpc('get_all_debt_data', params: {'p_company_id': companyId});

// 4. Data is filtered and aggregated
// Returns list of DebtRecord objects

// 5. UI updates automatically via Riverpod
```

## 🎨 UI Components

### Summary Card
- Displays total receivables and payables
- Shows net position (positive = net receivable, negative = net payable)
- Breaks down by internal vs external companies
- Shows counterparty count

### Filter Options
- **All**: Shows all counterparties
- **My Group**: Shows only internal companies (is_internal = true)
- **External**: Shows only external companies (is_internal = false)

### View Modes
- **Company View**: Aggregates all stores for each counterparty
- **Store View**: Shows data for a specific store only

## 📱 Usage Example

```dart
// In your main app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://atkekzwgukdvucqntryo.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
  );
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// In your app routing
MaterialPageRoute(
  builder: (context) => const DebtControlPage(),
)
```

## 🧪 Testing

```dart
// Test the RPC function directly
void testDebtDataFetch() async {
  final supabase = Supabase.instance.client;
  
  try {
    final response = await supabase.rpc(
      'get_all_debt_data',
      params: {
        'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602', // test1 company
      },
    );
    
    print('Response: $response');
    print('Record count: ${(response as List).length}');
    
    if (response.isNotEmpty) {
      final firstRecord = response[0];
      print('First record: $firstRecord');
      print('Counterparty: ${firstRecord['counterparty_name']}');
      print('Net amount: ${firstRecord['net_amount']}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

## 🚨 Error Handling

```dart
class DebtRepository {
  Future<List<DebtRecord>> getAllDebtData(String companyId) async {
    try {
      final response = await _client.rpc(
        'get_all_debt_data',
        params: {'p_company_id': companyId},
      );
      
      // Handle null response
      if (response == null) {
        debugPrint('No debt data found for company: $companyId');
        return [];
      }
      
      // Validate response type
      if (response is! List) {
        throw FormatException('Invalid response format: expected List, got ${response.runtimeType}');
      }
      
      // Parse with error handling for each record
      final List<DebtRecord> records = [];
      for (var i = 0; i < response.length; i++) {
        try {
          records.add(DebtRecord.fromJson(response[i] as Map<String, dynamic>));
        } catch (e) {
          debugPrint('Error parsing record $i: $e');
          // Continue with other records
        }
      }
      
      return records;
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      debugPrint('Supabase error: ${e.message}');
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      // Handle general errors
      debugPrint('Unexpected error: $e');
      throw Exception('Failed to fetch debt data: $e');
    }
  }
}
```

## 📊 Performance Optimization

### Caching Strategy
```dart
// Add caching to repository
class DebtRepository {
  final SupabaseClient _client;
  final Duration _cacheExpiry = const Duration(minutes: 5);
  
  Map<String, CachedData<List<DebtRecord>>> _cache = {};
  
  Future<List<DebtRecord>> getAllDebtData(String companyId, {bool forceRefresh = false}) async {
    final cacheKey = 'debt_$companyId';
    
    // Check cache
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      final cached = _cache[cacheKey]!;
      if (cached.isValid) {
        return cached.data;
      }
    }
    
    // Fetch fresh data
    final data = await _fetchDebtData(companyId);
    
    // Update cache
    _cache[cacheKey] = CachedData(
      data: data,
      timestamp: DateTime.now(),
      expiry: _cacheExpiry,
    );
    
    return data;
  }
}

class CachedData<T> {
  final T data;
  final DateTime timestamp;
  final Duration expiry;
  
  CachedData({
    required this.data,
    required this.timestamp,
    required this.expiry,
  });
  
  bool get isValid => DateTime.now().difference(timestamp) < expiry;
}
```

### Pagination for Large Datasets
```dart
// If you have many counterparties, implement pagination
Future<PaginatedDebtData> getPaginatedDebtData({
  required String companyId,
  int limit = 20,
  int offset = 0,
}) async {
  final allData = await getAllDebtData(companyId);
  
  // Sort by net amount (largest first)
  allData.sort((a, b) => b.netAmount.abs().compareTo(a.netAmount.abs()));
  
  // Apply pagination
  final paginatedData = allData.skip(offset).take(limit).toList();
  
  return PaginatedDebtData(
    records: paginatedData,
    totalCount: allData.length,
    hasMore: offset + limit < allData.length,
  );
}
```

## 🔗 Related Functions

If you need more detailed transaction data, you can use these additional RPC functions:

```dart
// Get detailed transactions for a counterparty
final transactions = await supabase.rpc(
  'get_debt_transactions_v3',
  params: {
    'p_company_id': companyId,
    'p_counterparty_id': counterpartyId,
    'p_start_date': startDate,
    'p_end_date': endDate,
  },
);

// Get monthly summary
final monthlySummary = await supabase.rpc(
  'get_monthly_summary',
  params: {
    'p_company_id': companyId,
    'p_counterparty_id': counterpartyId,
  },
);
```

## 📝 Notes

1. **Data Freshness**: The data is real-time from your journal entries. Consider implementing refresh indicators.

2. **Permissions**: Ensure users have proper permissions to view debt data for their company.

3. **Currency**: All amounts are in the base currency of the company (Vietnamese Dong in examples).

4. **Null Safety**: The code examples use null-safety. Ensure your Flutter project has null-safety enabled.

5. **State Management**: Examples use Riverpod, but you can adapt to your preferred state management solution (Provider, Bloc, GetX, etc.).

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Empty response | Check if company_id is valid and has journal entries |
| Permission denied | Ensure user is authenticated and has access to the company |
| Slow loading | Consider implementing pagination or caching |
| Data mismatch | Verify that journal entries have proper debt_tag values in accounts |

## 📚 Additional Resources

- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Intl Package](https://pub.dev/packages/intl)

---

*Last Updated: 2025-08-26*
*Version: 1.0.0*