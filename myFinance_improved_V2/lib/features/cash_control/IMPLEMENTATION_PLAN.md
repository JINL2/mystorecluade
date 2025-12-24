# Cash Control - Clean Architecture Implementation Plan

## DB 테이블 구조 (실제 컬럼명 그대로)

### accounts
```
account_id (uuid), account_name (text), account_code (varchar),
account_type (text), expense_nature (text), category_tag (text), debt_tag (text)
```

### counterparties
```
counterparty_id (uuid), company_id (uuid), name (text), type (text),
is_internal (bool), linked_company_id (uuid)
```

### cash_locations
```
cash_location_id (uuid), company_id (uuid), store_id (uuid),
location_name (text), location_type (text)
```

### journal_entries
```
journal_id (uuid), company_id (uuid), store_id (uuid), entry_date (date),
currency_id (uuid), description (text), counterparty_id (uuid),
created_by (uuid), created_at (timestamp)
```

---

## RPC Functions

| Action | RPC | Params |
|--------|-----|--------|
| Get accounts | `get_user_quick_access_accounts` | p_user_id, p_company_id, p_limit |
| Create journal | `insert_journal_with_everything_utc` | p_base_amount, p_company_id, p_created_by, p_description, p_entry_date_utc, p_lines, p_counterparty_id, p_if_cash_location_id, p_store_id |
| Create debt | `create_debt_record` | p_debt_info, p_company_id, p_store_id, p_journal_id, p_account_id, p_amount, p_entry_date |

---

## 폴더 구조

```
cash_control/
├── domain/
│   ├── entities/
│   │   └── cash_control_enums.dart  ✅ 이미 있음
│   └── repositories/
│       └── cash_control_repository.dart  (interface)
├── data/
│   ├── datasources/
│   │   └── cash_control_datasource.dart
│   ├── models/
│   │   └── cash_control_models.dart  (DTOs)
│   └── repositories/
│       └── cash_control_repository_impl.dart
└── presentation/  ✅ 이미 있음
    └── providers/
        └── cash_control_providers.dart
```

---

## Phase 1: Domain Layer

### domain/repositories/cash_control_repository.dart
```dart
abstract class CashControlRepository {
  /// Expense accounts (account_type = 'expense')
  Future<List<Map<String, dynamic>>> getExpenseAccounts({
    required String companyId,
    required String userId,
  });

  /// Counterparties for debt
  Future<List<Map<String, dynamic>>> getCounterparties({
    required String companyId,
  });

  /// Cash locations for store
  Future<List<Map<String, dynamic>>> getCashLocations({
    required String storeId,
  });

  /// Stores in company
  Future<List<Map<String, dynamic>>> getStores({
    required String companyId,
  });

  /// Create expense journal
  Future<String> createExpenseEntry({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String cashLocationId,
    required String expenseAccountId,
    required double amount,
    required DateTime entryDate,
    String? memo,
  });

  /// Create debt journal
  Future<String> createDebtEntry({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String cashLocationId,
    required String counterpartyId,
    required String debtAccountId,
    required double amount,
    required DateTime entryDate,
    required bool isReceivable,
    required bool isIncreasing,
    String? memo,
  });

  /// Create transfer journal
  Future<String> createTransferEntry({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String fromCashLocationId,
    required String toCashLocationId,
    required double amount,
    required DateTime entryDate,
    String? counterpartyId,  // for inter-company
    String? memo,
  });
}
```

---

## Phase 2: Data Layer

### data/datasources/cash_control_datasource.dart
```dart
class CashControlDataSource {
  final SupabaseClient _supabase;

  CashControlDataSource(this._supabase);

  Future<List<Map<String, dynamic>>> fetchExpenseAccounts({
    required String companyId,
    required String userId,
  }) async {
    final response = await _supabase.rpc(
      'get_user_quick_access_accounts',
      params: {
        'p_user_id': userId,
        'p_company_id': companyId,
        'p_limit': 20,
      },
    );
    return List<Map<String, dynamic>>.from(response ?? []);
  }

  Future<List<Map<String, dynamic>>> fetchCounterparties({
    required String companyId,
  }) async {
    final response = await _supabase
        .from('counterparties')
        .select('counterparty_id, name, type, is_internal, linked_company_id')
        .eq('company_id', companyId)
        .eq('is_deleted', false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchCashLocations({
    required String storeId,
  }) async {
    final response = await _supabase
        .from('cash_locations')
        .select('cash_location_id, location_name, location_type')
        .eq('store_id', storeId)
        .or('is_deleted.is.null,is_deleted.eq.false');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<String> createJournal({
    required Map<String, dynamic> params,
  }) async {
    final journalId = await _supabase.rpc(
      'insert_journal_with_everything_utc',
      params: params,
    );
    return journalId.toString();
  }
}
```

### data/repositories/cash_control_repository_impl.dart
```dart
class CashControlRepositoryImpl implements CashControlRepository {
  final CashControlDataSource _dataSource;

  CashControlRepositoryImpl(this._dataSource);

  @override
  Future<List<Map<String, dynamic>>> getExpenseAccounts({
    required String companyId,
    required String userId,
  }) {
    return _dataSource.fetchExpenseAccounts(
      companyId: companyId,
      userId: userId,
    );
  }

  @override
  Future<String> createExpenseEntry({
    required String companyId,
    required String? storeId,
    required String createdBy,
    required String cashLocationId,
    required String expenseAccountId,
    required double amount,
    required DateTime entryDate,
    String? memo,
  }) {
    return _dataSource.createJournal(params: {
      'p_base_amount': amount,
      'p_company_id': companyId,
      'p_created_by': createdBy,
      'p_description': memo ?? 'Expense',
      'p_entry_date_utc': entryDate.toUtc().toIso8601String(),
      'p_if_cash_location_id': cashLocationId,
      'p_store_id': storeId,
      'p_lines': [
        {'account_id': expenseAccountId, 'debit': amount, 'credit': 0},
        // cash account from location - need to get
      ],
    });
  }

  // ... other methods
}
```

---

## Phase 3: Providers

### presentation/providers/cash_control_providers.dart
```dart
@riverpod
CashControlDataSource cashControlDataSource(Ref ref) {
  return CashControlDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
CashControlRepository cashControlRepository(Ref ref) {
  return CashControlRepositoryImpl(ref.watch(cashControlDataSourceProvider));
}
```

---

## Implementation Order

1. [ ] `domain/repositories/cash_control_repository.dart`
2. [ ] `data/datasources/cash_control_datasource.dart`
3. [ ] `data/repositories/cash_control_repository_impl.dart`
4. [ ] `presentation/providers/cash_control_providers.dart`
5. [ ] Connect to existing sheets
6. [ ] Run `dart run build_runner build`

---

## Architecture Checklist

- [ ] Domain에 Supabase import 없음
- [ ] Domain에 Flutter import 없음
- [ ] Repository interface는 domain에
- [ ] Repository impl은 data에
- [ ] DataSource는 data에
- [ ] Provider는 presentation에
