# Debt Control RPC Function - Detailed API Specification

## 🔴 IMPORTANT: RPC Function Details

### Function Name
```
get_all_debt_data
```

### Full RPC Call Syntax
```dart
final response = await supabase.rpc(
  'get_all_debt_data',
  params: {
    'p_company_id': 'your-company-uuid-here',
  },
);
```

## 📥 Request Parameters

| Parameter | Type | Required | Example | Description |
|-----------|------|----------|---------|-------------|
| `p_company_id` | UUID String | ✅ Yes | `'7a2545e0-e112-4b0c-9c59-221a530c4602'` | The UUID of the company to fetch debt data for |

### Example Request
```dart
// Actual working example with test company
final response = await supabase.rpc(
  'get_all_debt_data',
  params: {
    'p_company_id': '7a2545e0-e112-4b0c-9c59-221a530c4602', // test1 company
  },
);
```

## 📤 Response Structure

### Response Type
```dart
List<Map<String, dynamic>>
```

### Single Record Structure
Each record in the response list contains:

```json
{
  "counterparty_id": "c18be9ce-3aa9-4fcc-afb3-2494f5152fef",
  "counterparty_name": "ABC Corporation",
  "is_internal": false,
  "store_id": "d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff",
  "store_name": "Main Store",
  "receivable_amount": "3813811.00",
  "payable_amount": "33496335.00",
  "net_amount": "-29682524.00",
  "last_activity": "2025-08-24",
  "transaction_count": 15
}
```

### Field Descriptions

| Field | Type | Nullable | Description | Example |
|-------|------|----------|-------------|---------|
| `counterparty_id` | String (UUID) | No | Unique identifier of the counterparty | `"c18be9ce-3aa9-4fcc-afb3-2494f5152fef"` |
| `counterparty_name` | String | No | Name of the counterparty company | `"ABC Corporation"` |
| `is_internal` | Boolean | No | Whether this is an internal/group company | `true` or `false` |
| `store_id` | String (UUID) | Yes | ID of the store (null for company-level) | `"d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff"` or `null` |
| `store_name` | String | Yes | Name of the store | `"Main Store"` or `null` |
| `receivable_amount` | String (Numeric) | No | Total amount to be received | `"3813811.00"` |
| `payable_amount` | String (Numeric) | No | Total amount to be paid | `"33496335.00"` |
| `net_amount` | String (Numeric) | No | Net position (receivable - payable) | `"-29682524.00"` |
| `last_activity` | String (Date) | Yes | Last transaction date (YYYY-MM-DD) | `"2025-08-24"` or `null` |
| `transaction_count` | Integer | No | Number of transactions with this counterparty | `15` |

## 📊 Example Response Data

### Full Response Example
```json
[
  {
    "counterparty_id": "c18be9ce-3aa9-4fcc-afb3-2494f5152fef",
    "counterparty_name": "태스트용카운터컴퍼니",
    "is_internal": true,
    "store_id": "d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff",
    "store_name": "test1",
    "receivable_amount": "3813811.00",
    "payable_amount": "-33496335.00",
    "net_amount": "37310146.00",
    "last_activity": "2025-08-24",
    "transaction_count": 15
  },
  {
    "counterparty_id": "6a8bf676-24a7-4512-a3e8-e2c84a1628a1",
    "counterparty_name": "External Supplier Co",
    "is_internal": false,
    "store_id": "d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff",
    "store_name": "test1",
    "receivable_amount": "0",
    "payable_amount": "231514.00",
    "net_amount": "-231514.00",
    "last_activity": "2025-08-24",
    "transaction_count": 1
  },
  {
    "counterparty_id": "11111111-1111-1111-1111-111111111111",
    "counterparty_name": "Internal Company A",
    "is_internal": true,
    "store_id": null,
    "store_name": null,
    "receivable_amount": "1000000.00",
    "payable_amount": "0",
    "net_amount": "1000000.00",
    "last_activity": "2025-07-22",
    "transaction_count": 1
  }
]
```

## 🔄 Complete Flutter Implementation

### Step 1: Make the RPC Call
```dart
Future<List<Map<String, dynamic>>> fetchDebtData(String companyId) async {
  try {
    // Make the RPC call
    final response = await supabase.rpc(
      'get_all_debt_data',
      params: {
        'p_company_id': companyId,
      },
    );
    
    // Response is already a List
    if (response == null) {
      return [];
    }
    
    // Cast to proper type
    return List<Map<String, dynamic>>.from(response);
    
  } catch (e) {
    print('Error fetching debt data: $e');
    throw e;
  }
}
```

### Step 2: Parse the Response
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
      counterpartyId: json['counterparty_id'] as String,
      counterpartyName: json['counterparty_name'] as String,
      isInternal: json['is_internal'] as bool,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      // Convert string numbers to double
      receivableAmount: double.parse(json['receivable_amount'].toString()),
      payableAmount: double.parse(json['payable_amount'].toString()),
      netAmount: double.parse(json['net_amount'].toString()),
      // Parse date if not null
      lastActivity: json['last_activity'] != null 
        ? DateTime.parse(json['last_activity']) 
        : null,
      transactionCount: json['transaction_count'] as int,
    );
  }
}
```

### Step 3: Use in Your App
```dart
class DebtService {
  final SupabaseClient supabase;
  
  DebtService(this.supabase);
  
  Future<List<DebtRecord>> getCompanyDebtData(String companyId) async {
    try {
      // 1. Call RPC function
      final response = await supabase.rpc(
        'get_all_debt_data',
        params: {
          'p_company_id': companyId,
        },
      );
      
      // 2. Handle null/empty response
      if (response == null || response.isEmpty) {
        print('No debt records found for company: $companyId');
        return [];
      }
      
      // 3. Parse each record
      final List<DebtRecord> records = [];
      for (var jsonRecord in response) {
        try {
          records.add(DebtRecord.fromJson(jsonRecord));
        } catch (e) {
          print('Error parsing record: $e');
          print('Problematic record: $jsonRecord');
          // Continue with other records
        }
      }
      
      // 4. Sort by absolute net amount (largest debts first)
      records.sort((a, b) => b.netAmount.abs().compareTo(a.netAmount.abs()));
      
      return records;
      
    } catch (e) {
      print('RPC Error: $e');
      throw Exception('Failed to fetch debt data: $e');
    }
  }
}
```

## 🧪 Testing the RPC Function

### Direct Test in Flutter
```dart
void testRPCFunction() async {
  final supabase = Supabase.instance.client;
  
  print('Testing get_all_debt_data RPC function...');
  
  try {
    // Use test company ID
    const testCompanyId = '7a2545e0-e112-4b0c-9c59-221a530c4602';
    
    print('Calling RPC with company_id: $testCompanyId');
    
    final response = await supabase.rpc(
      'get_all_debt_data',
      params: {
        'p_company_id': testCompanyId,
      },
    );
    
    print('Raw response type: ${response.runtimeType}');
    print('Response is null: ${response == null}');
    
    if (response != null) {
      final list = response as List;
      print('Number of records: ${list.length}');
      
      if (list.isNotEmpty) {
        print('\nFirst record:');
        final first = list[0];
        first.forEach((key, value) {
          print('  $key: $value (${value.runtimeType})');
        });
        
        // Test parsing
        final record = DebtRecord.fromJson(first);
        print('\nParsed successfully:');
        print('  Counterparty: ${record.counterpartyName}');
        print('  Is Internal: ${record.isInternal}');
        print('  Net Amount: ${record.netAmount}');
        print('  Receivable: ${record.receivableAmount}');
        print('  Payable: ${record.payableAmount}');
      }
    }
  } catch (e) {
    print('Error: $e');
    print('Stack trace: ${StackTrace.current}');
  }
}
```

## ⚠️ Important Notes

### 1. Numeric Values
- All monetary amounts are returned as **strings** from PostgreSQL
- You must use `double.parse()` or `num.parse()` to convert them
- Example: `"3813811.00"` → `3813811.00`

### 2. Null Handling
- `store_id` and `store_name` can be null for company-level entries
- `last_activity` can be null if no transactions exist
- Always check for null before using these fields

### 3. Data Filtering
The RPC function returns ALL debt records for the company. You need to filter locally:

```dart
// Filter for internal companies only
final internalDebts = records.where((r) => r.isInternal).toList();

// Filter for specific store
final storeDebts = records.where((r) => r.storeId == 'store-uuid').toList();

// Filter for net payables only
final payables = records.where((r) => r.netAmount < 0).toList();

// Filter for net receivables only
final receivables = records.where((r) => r.netAmount > 0).toList();
```

### 4. Aggregation
If you need company-wide view (all stores combined):

```dart
Map<String, DebtRecord> aggregateByCounterparty(List<DebtRecord> records) {
  final Map<String, DebtRecord> aggregated = {};
  
  for (final record in records) {
    final key = record.counterpartyId;
    
    if (aggregated.containsKey(key)) {
      // Combine with existing
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
  
  return aggregated;
}
```

## 🔥 Common Issues and Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Empty response `[]` | No debt records for company | Check if company has journal entries with debt accounts |
| `null` response | Invalid company ID | Verify company_id exists in companies table |
| Parsing error | Unexpected data type | Check console for actual response structure |
| Negative receivable amounts | Data quality issue | Take absolute value or investigate journal entries |

## 📱 Complete Working Example

```dart
// Full working example
class DebtControlScreen extends StatefulWidget {
  final String companyId;
  
  const DebtControlScreen({required this.companyId});
  
  @override
  _DebtControlScreenState createState() => _DebtControlScreenState();
}

class _DebtControlScreenState extends State<DebtControlScreen> {
  List<DebtRecord> _debtRecords = [];
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadDebtData();
  }
  
  Future<void> _loadDebtData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final response = await Supabase.instance.client.rpc(
        'get_all_debt_data',
        params: {
          'p_company_id': widget.companyId,
        },
      );
      
      if (response == null) {
        setState(() {
          _debtRecords = [];
          _isLoading = false;
        });
        return;
      }
      
      final records = (response as List)
          .map((json) => DebtRecord.fromJson(json))
          .toList();
      
      setState(() {
        _debtRecords = records;
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    
    if (_debtRecords.isEmpty) {
      return Center(child: Text('No debt records found'));
    }
    
    return ListView.builder(
      itemCount: _debtRecords.length,
      itemBuilder: (context, index) {
        final record = _debtRecords[index];
        return ListTile(
          title: Text(record.counterpartyName),
          subtitle: Text('Net: ${record.netAmount}'),
          trailing: record.isInternal 
            ? Chip(label: Text('Internal'))
            : null,
        );
      },
    );
  }
}
```

This is the complete RPC specification with all the details you need to implement the debt control system in Flutter!