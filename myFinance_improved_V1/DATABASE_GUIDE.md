# Database Connection & Operations Guide
## MyFinance Flutter App with Supabase

## Table of Contents
1. [Initial Setup](#initial-setup)
2. [Authentication](#authentication)
3. [Basic CRUD Operations](#basic-crud-operations)
4. [RPC Functions](#rpc-functions)
5. [Real-time Subscriptions](#real-time-subscriptions)
6. [Company-Specific Operations](#company-specific-operations)
7. [Preference Tracking System](#preference-tracking-system)
8. [Error Handling](#error-handling)
9. [Best Practices](#best-practices)

---

## Initial Setup

### 1. Install Dependencies
```yaml
# pubspec.yaml
dependencies:
  supabase_flutter: ^2.3.0
  flutter_riverpod: ^2.4.0
```

### 2. Initialize Supabase
```dart
// main.dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(MyApp());
}
```

### 3. Get Supabase Client Instance
```dart
final supabase = Supabase.instance.client;
```

---

## Authentication

### Sign In
```dart
// Email/Password Login
final response = await supabase.auth.signInWithPassword(
  email: 'user@example.com',
  password: 'password123',
);

// Get current user
final user = supabase.auth.currentUser;
final userId = user?.id;
```

### Sign Out
```dart
await supabase.auth.signOut();
```

---

## Basic CRUD Operations

### SELECT - Reading Data

#### Simple Select
```dart
// Get all records from a table
final data = await supabase
  .from('features')
  .select();

// Get specific columns
final data = await supabase
  .from('features')
  .select('feature_id, feature_name, icon');
```

#### With Filters
```dart
// Single condition
final data = await supabase
  .from('accounts')
  .select()
  .eq('company_id', companyId);

// Multiple conditions
final data = await supabase
  .from('transactions')
  .select()
  .eq('company_id', companyId)
  .eq('store_id', storeId)
  .gte('transaction_date', startDate)
  .lte('transaction_date', endDate);

// Using IN operator
final data = await supabase
  .from('users')
  .select()
  .in('role_id', ['admin', 'manager', 'owner']);

// Text search
final data = await supabase
  .from('products')
  .select()
  .ilike('product_name', '%search_term%');
```

#### With Ordering and Limits
```dart
// Order by and limit
final data = await supabase
  .from('transactions')
  .select()
  .eq('company_id', companyId)
  .order('created_at', ascending: false)
  .limit(10);

// Pagination
final data = await supabase
  .from('transactions')
  .select()
  .range(0, 9); // First 10 records
```

#### With Joins (Foreign Tables)
```dart
// Join related tables
final data = await supabase
  .from('user_stores')
  .select('''
    *,
    stores!inner(
      store_id,
      store_name,
      store_address
    ),
    users!inner(
      user_id,
      user_first_name,
      user_last_name
    )
  ''')
  .eq('company_id', companyId);
```

### INSERT - Creating Data

#### Single Insert
```dart
// Insert single record
final response = await supabase
  .from('accounts')
  .insert({
    'account_name': 'Cash Account',
    'account_type': 'asset',
    'company_id': companyId,
    'created_by': userId,
  })
  .select()
  .single();

// Get the inserted record
final insertedAccount = response;
```

#### Multiple Inserts
```dart
// Insert multiple records
final response = await supabase
  .from('transaction_items')
  .insert([
    {
      'transaction_id': transactionId,
      'account_id': accountId1,
      'debit': 1000,
      'credit': 0,
    },
    {
      'transaction_id': transactionId,
      'account_id': accountId2,
      'debit': 0,
      'credit': 1000,
    },
  ])
  .select();
```

### UPDATE - Modifying Data

#### Update with Conditions
```dart
// Update single field
final response = await supabase
  .from('accounts')
  .update({'is_active': false})
  .eq('account_id', accountId)
  .select()
  .single();

// Update multiple fields
final response = await supabase
  .from('users')
  .update({
    'user_first_name': 'John',
    'user_last_name': 'Doe',
    'updated_at': DateTime.now().toIso8601String(),
  })
  .eq('user_id', userId)
  .select();
```

### DELETE - Removing Data

```dart
// Delete with condition
await supabase
  .from('temporary_data')
  .delete()
  .eq('session_id', sessionId);

// Soft delete (if you have is_deleted field)
await supabase
  .from('accounts')
  .update({
    'is_deleted': true,
    'deleted_at': DateTime.now().toIso8601String(),
  })
  .eq('account_id', accountId);
```

### UPSERT - Insert or Update

```dart
// Upsert (Insert if not exists, update if exists)
final response = await supabase
  .from('user_settings')
  .upsert({
    'user_id': userId,
    'setting_key': 'theme',
    'setting_value': 'dark',
  }, onConflict: 'user_id,setting_key')
  .select();
```

---

## RPC Functions

### Calling RPC Functions Without Parameters
```dart
// Simple RPC call
final response = await supabase.rpc('get_system_status');
```

### Calling RPC Functions With Parameters

#### Feature Click Tracking (with company_id)
```dart
// Track feature click with company context
await supabase.rpc('log_feature_click', params: {
  'p_feature_id': featureId,
  'p_feature_name': featureName,
  'p_company_id': companyId,
  'p_category_id': categoryId,
});
```

#### Get User Companies and Stores
```dart
// Get user's companies with stores
final userData = await supabase.rpc(
  'get_user_companies_and_stores',
  params: {'p_user_id': userId}
);

// Access the data
final companies = userData['companies'] as List;
final companyCount = userData['company_count'];
```

#### Get Categories with Features
```dart
// Get all categories with their features
final categories = await supabase.rpc('get_categories_with_features_v2');

// Process the results
for (final category in categories) {
  final categoryId = category['category_id'];
  final categoryName = category['category_name'];
  final features = category['features'] as List;
  
  for (final feature in features) {
    final featureId = feature['feature_id'];
    final featureName = feature['feature_name'];
    final route = feature['route'];
  }
}
```

#### Get Quick Access Features
```dart
// Get user's frequently used features for a company
final quickFeatures = await supabase.rpc(
  'get_user_quick_access_features',
  params: {
    'p_user_id': userId,
    'p_company_id': companyId,
  }
);

// Process the features
if (quickFeatures != null && quickFeatures is List) {
  for (final feature in quickFeatures) {
    final featureId = feature['feature_id'];
    final featureName = feature['feature_name'];
    final clickCount = feature['click_count'];
    final lastClicked = feature['last_clicked'];
  }
}
```

#### Account Usage Tracking
```dart
// Log account usage
await supabase.rpc('log_account_usage', params: {
  'p_account_id': accountId,
  'p_account_name': accountName,
  'p_company_id': companyId,
  'p_account_type': 'expense',
  'p_usage_type': 'clicked',
  'p_metadata': jsonEncode({'amount': 1000, 'currency': 'USD'}),
});
```

#### Template Usage Tracking
```dart
// Log template usage
await supabase.rpc('log_template_usage', params: {
  'p_template_id': templateId,
  'p_template_name': templateName,
  'p_company_id': companyId,
  'p_template_type': 'expense',
  'p_usage_type': 'used',
  'p_metadata': jsonEncode({'modified': false}),
});
```

#### Get Financial Quick Access
```dart
// Get both accounts and templates quick access
final financialQuickAccess = await supabase.rpc(
  'get_user_financial_quick_access',
  params: {
    'p_user_id': userId,
    'p_company_id': companyId,
    'p_account_limit': 6,
    'p_template_limit': 5,
  }
);

// Access the data
final quickAccounts = financialQuickAccess['quick_accounts'] as List;
final quickTemplates = financialQuickAccess['quick_templates'] as List;
final generatedAt = financialQuickAccess['generated_at'];
```

---

## Real-time Subscriptions

### Subscribe to Table Changes
```dart
// Subscribe to all changes in a table
final subscription = supabase
  .channel('public:transactions')
  .onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'transactions',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'company_id',
      value: companyId,
    ),
    callback: (payload) {
      print('Change received: ${payload.eventType}');
      print('New data: ${payload.newRecord}');
      print('Old data: ${payload.oldRecord}');
      
      // Handle the change
      if (payload.eventType == PostgresChangeEvent.insert) {
        // Handle new record
      } else if (payload.eventType == PostgresChangeEvent.update) {
        // Handle updated record
      } else if (payload.eventType == PostgresChangeEvent.delete) {
        // Handle deleted record
      }
    },
  )
  .subscribe();

// Unsubscribe when done
await subscription.unsubscribe();
```

### Subscribe to Specific Events
```dart
// Listen only to INSERT events
final subscription = supabase
  .channel('new-notifications')
  .onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'notifications',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'user_id',
      value: userId,
    ),
    callback: (payload) {
      final notification = payload.newRecord;
      // Show notification to user
    },
  )
  .subscribe();
```

---

## Company-Specific Operations

### Always Include company_id Filter
```dart
// IMPORTANT: Always filter by company_id for multi-tenant data
final accounts = await supabase
  .from('accounts')
  .select()
  .eq('company_id', companyId)
  .eq('is_deleted', false)
  .order('account_name');

final transactions = await supabase
  .from('transactions')
  .select()
  .eq('company_id', companyId)
  .eq('store_id', storeId)
  .order('transaction_date', ascending: false);
```

### Get Current Company from App State
```dart
// Using Riverpod
final appState = ref.read(appStateProvider);
final companyId = appState.companyChoosen;
final storeId = appState.storeChoosen;

// Validate before using
if (companyId.isEmpty) {
  throw Exception('No company selected');
}
```

---

## Preference Tracking System

### Track Feature Clicks
```dart
class FeatureTracker {
  final SupabaseClient supabase;
  final String companyId;
  
  FeatureTracker(this.supabase, this.companyId);
  
  Future<void> trackFeatureClick({
    required String featureId,
    required String featureName,
    required String categoryId,
  }) async {
    try {
      await supabase.rpc('log_feature_click', params: {
        'p_feature_id': featureId,
        'p_feature_name': featureName,
        'p_company_id': companyId,
        'p_category_id': categoryId,
      });
    } catch (e) {
      // Don't disrupt user experience
      print('Failed to track click: $e');
    }
  }
}
```

### Track Account Usage
```dart
class AccountTracker {
  final SupabaseClient supabase;
  final String companyId;
  
  AccountTracker(this.supabase, this.companyId);
  
  Future<void> trackAccountUsage({
    required String accountId,
    required String accountName,
    String? accountType,
    String usageType = 'clicked',
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await supabase.rpc('log_account_usage', params: {
        'p_account_id': accountId,
        'p_account_name': accountName,
        'p_company_id': companyId,
        'p_account_type': accountType,
        'p_usage_type': usageType,
        'p_metadata': metadata != null ? jsonEncode(metadata) : '{}',
      });
    } catch (e) {
      print('Failed to track account usage: $e');
    }
  }
}
```

---

## Error Handling

### Comprehensive Error Handling
```dart
Future<List<dynamic>> fetchDataSafely() async {
  try {
    final response = await supabase
      .from('table_name')
      .select()
      .eq('company_id', companyId);
    
    return response as List<dynamic>;
    
  } on PostgrestException catch (e) {
    // Database errors
    print('Database error: ${e.message}');
    print('Error code: ${e.code}');
    print('Details: ${e.details}');
    
    // Handle specific error codes
    if (e.code == '23505') {
      // Unique violation
      throw Exception('This record already exists');
    } else if (e.code == '23503') {
      // Foreign key violation
      throw Exception('Related record not found');
    }
    
    throw Exception('Database operation failed: ${e.message}');
    
  } on AuthException catch (e) {
    // Authentication errors
    print('Auth error: ${e.message}');
    throw Exception('Authentication failed: ${e.message}');
    
  } catch (e) {
    // Other errors
    print('Unexpected error: $e');
    throw Exception('An unexpected error occurred');
  }
}
```

### Retry Logic
```dart
Future<T> retryOperation<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempts = 0;
  
  while (attempts < maxAttempts) {
    try {
      return await operation();
    } catch (e) {
      attempts++;
      
      if (attempts >= maxAttempts) {
        throw e;
      }
      
      await Future.delayed(delay * attempts);
    }
  }
  
  throw Exception('Operation failed after $maxAttempts attempts');
}

// Usage
final data = await retryOperation(() async {
  return await supabase
    .from('critical_data')
    .select()
    .eq('company_id', companyId);
});
```

---

## Best Practices

### 1. Use Repository Pattern
```dart
abstract class AccountRepository {
  Future<List<Account>> getAccounts(String companyId);
  Future<Account> createAccount(Account account);
  Future<Account> updateAccount(Account account);
  Future<void> deleteAccount(String accountId);
}

class SupabaseAccountRepository implements AccountRepository {
  final SupabaseClient _client;
  
  SupabaseAccountRepository(this._client);
  
  @override
  Future<List<Account>> getAccounts(String companyId) async {
    final response = await _client
      .from('accounts')
      .select()
      .eq('company_id', companyId)
      .eq('is_deleted', false)
      .order('account_name');
    
    return (response as List)
      .map((json) => Account.fromJson(json))
      .toList();
  }
  
  // Implement other methods...
}
```

### 2. Use Providers for State Management
```dart
// Define providers
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return SupabaseAccountRepository(Supabase.instance.client);
});

final accountsProvider = FutureProvider.family<List<Account>, String>(
  (ref, companyId) async {
    final repository = ref.watch(accountRepositoryProvider);
    return repository.getAccounts(companyId);
  },
);

// Use in widgets
class AccountListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyId = ref.watch(selectedCompanyProvider);
    final accountsAsync = ref.watch(accountsProvider(companyId));
    
    return accountsAsync.when(
      data: (accounts) => ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(accounts[index].name),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 3. Cache Frequently Used Data
```dart
class CachedDataService {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _cacheTime = {};
  static const Duration _cacheDuration = Duration(minutes: 5);
  
  static Future<T> getCachedOrFetch<T>(
    String key,
    Future<T> Function() fetcher,
  ) async {
    // Check cache
    if (_cache.containsKey(key)) {
      final cacheAge = DateTime.now().difference(_cacheTime[key]!);
      if (cacheAge < _cacheDuration) {
        return _cache[key] as T;
      }
    }
    
    // Fetch fresh data
    final data = await fetcher();
    
    // Update cache
    _cache[key] = data;
    _cacheTime[key] = DateTime.now();
    
    return data;
  }
  
  static void clearCache([String? key]) {
    if (key != null) {
      _cache.remove(key);
      _cacheTime.remove(key);
    } else {
      _cache.clear();
      _cacheTime.clear();
    }
  }
}
```

### 4. Batch Operations
```dart
// Instead of multiple individual inserts
for (final item in items) {
  await supabase.from('items').insert(item); // DON'T DO THIS
}

// Use batch insert
await supabase.from('items').insert(items); // DO THIS
```

### 5. Use Transactions for Related Operations
```dart
// Use RPC functions for transactions
await supabase.rpc('create_invoice_with_items', params: {
  'p_invoice_data': jsonEncode(invoiceData),
  'p_items_data': jsonEncode(itemsData),
});
```

### 6. Always Handle Loading States
```dart
class DataWidget extends StatefulWidget {
  @override
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  bool _isLoading = false;
  String? _error;
  List<dynamic>? _data;
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final data = await supabase
        .from('table')
        .select();
      
      setState(() {
        _data = data;
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
      return CircularProgressIndicator();
    }
    
    if (_error != null) {
      return Text('Error: $_error');
    }
    
    if (_data == null || _data!.isEmpty) {
      return Text('No data available');
    }
    
    return ListView.builder(
      itemCount: _data!.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_data![index]['name']),
        );
      },
    );
  }
}
```

---

## Common Queries Reference

### Get User's Role in Company
```dart
final userData = await supabase.rpc(
  'get_user_companies_and_stores',
  params: {'p_user_id': userId}
);

final companies = userData['companies'] as List;
final company = companies.firstWhere(
  (c) => c['company_id'] == companyId,
);
final role = company['role'];
final permissions = role['permissions'] as List;
```

### Check Permission
```dart
bool hasPermission(String featureId, List<dynamic> permissions) {
  return permissions.contains(featureId);
}
```

### Get Filtered Features by Permission
```dart
final categories = await supabase.rpc('get_categories_with_features_v2');

final filteredCategories = categories.where((category) {
  final features = category['features'] as List;
  final allowedFeatures = features.where((feature) {
    return permissions.contains(feature['feature_id']);
  }).toList();
  
  return allowedFeatures.isNotEmpty;
}).toList();
```

---

## Testing Database Operations

### Mock Supabase Client
```dart
class MockSupabaseClient {
  Future<List<Map<String, dynamic>>> mockSelect() async {
    return [
      {'id': '1', 'name': 'Test 1'},
      {'id': '2', 'name': 'Test 2'},
    ];
  }
  
  Future<Map<String, dynamic>> mockInsert(Map<String, dynamic> data) async {
    return {...data, 'id': 'generated-id'};
  }
}
```

### Integration Testing
```dart
void main() {
  late SupabaseClient supabase;
  
  setUpAll(() async {
    await Supabase.initialize(
      url: 'TEST_SUPABASE_URL',
      anonKey: 'TEST_ANON_KEY',
    );
    supabase = Supabase.instance.client;
  });
  
  test('Should fetch accounts', () async {
    final accounts = await supabase
      .from('accounts')
      .select()
      .eq('company_id', 'test-company-id');
    
    expect(accounts, isNotEmpty);
  });
}
```

---

## Debugging Tips

### Enable Logging
```dart
// Log all database operations
supabase.auth.onAuthStateChange.listen((data) {
  print('Auth state changed: ${data.event}');
  print('Session: ${data.session}');
});
```

### Check RLS Policies
```dart
// If getting empty results, check if RLS is blocking
// Temporarily disable RLS in Supabase dashboard for testing
// Remember to re-enable in production!
```

### Monitor Network Requests
```dart
// Use Flutter DevTools Network tab
// Or add interceptors
import 'package:dio/dio.dart';

final dio = Dio();
dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
));
```

---

## Security Considerations

1. **Never expose service_role key in client apps**
2. **Always use RLS policies**
3. **Validate data on both client and server**
4. **Use prepared statements (Supabase handles this)**
5. **Implement rate limiting**
6. **Log security events**
7. **Use HTTPS only**
8. **Implement proper session management**

---

## Performance Optimization

1. **Use select() with specific columns**
2. **Implement pagination for large datasets**
3. **Cache frequently accessed data**
4. **Use database indexes (configured in Supabase)**
5. **Batch operations when possible**
6. **Use real-time subscriptions sparingly**
7. **Implement debouncing for search**
8. **Use connection pooling (handled by Supabase)**

---

## Resources

- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Flutter Riverpod](https://riverpod.dev/)
- [Supabase Dashboard](https://app.supabase.com/)
