# 🔄 RPC Migration Plan: Legacy → Universal Multi-Currency (SINGLE ENTRY)

**Date**: 2025-11-23 (Updated)
**Goal**: Migrate from Legacy RPC to Universal `insert_amount_multi_currency` RPC
**Status**: 🔄 RPC Redesigned - Ready for Deployment
**Version**: V4 (Single Entry with Base Currency Conversion)

---

## ⚠️ CRITICAL ARCHITECTURE CHANGE

**Previous Design (WRONG)**: Created separate entry for each currency
**New Design (CORRECT)**: Create SINGLE entry per transaction with base currency conversion

### Key Changes:
1. ✅ **Single Entry**: One `cash_amount_entries` record per transaction (not per currency)
2. ✅ **Base Currency**: All amounts converted to base currency for `balance_before`/`balance_after`
3. ✅ **Multi-Currency Storage**: Original currency details stored in `denomination_summary` JSONB
4. ✅ **Exchange Rates**: Rates used for conversion stored in `exchange_rates` JSONB
5. ✅ **Denomination Lines**: All currencies' denominations linked to single `entry_id`

---

## 📊 Current State (Legacy RPC Usage)

### Cash Tab
- **Current RPC**: `insert_cashier_amount_lines`
- **Type**: Legacy
- **Workflow**: Multi-currency → Trigger → `cash_amount_stock_flow`
- **Problem**: ❌ No Entry created, `entry_id = NULL`
- **Data Location**: `cash_amount_stock_flow` (Legacy table)

### Vault Tab
- **Current RPC**: `vault_amount_insert_v3`
- **Type**: V3 (Single currency per call)
- **Workflow**: Single currency → Entry created → `vault_amount_line`
- **Problem**: ✅ Entry created, but single currency only
- **Data Location**: `cash_amount_entries` ✅ + `vault_amount_line`

### Bank Tab
- **Current RPC**: `bank_amount_insert_v2`
- **Type**: V2 (Single currency per call)
- **Workflow**: Single currency → NO Entry → `bank_amount`
- **Problem**: ❌ No Entry created (V2는 Legacy)
- **Data Location**: `bank_amount` (No entry_id link)

---

## 🎯 Target State (New Universal RPC)

### Universal RPC: `insert_amount_multi_currency`

**One RPC for ALL types!**

```sql
CREATE OR REPLACE FUNCTION insert_amount_multi_currency(
  p_entry_type VARCHAR(20),      -- 'cash', 'vault', or 'bank'
  p_company_id UUID,
  p_location_id UUID,
  p_record_date DATE,
  p_created_by UUID,
  p_store_id UUID DEFAULT NULL,
  p_description TEXT DEFAULT NULL,
  p_currencies JSONB DEFAULT '[]'::JSONB
)
```

**Features**:
- ✅ Multi-currency support (한번에 여러 통화 처리)
- ✅ Entry-based workflow (**SINGLE** `cash_amount_entries` per transaction)
- ✅ Base Currency Conversion (모든 통화를 베이스 커런시로 환전)
- ✅ JSONB Storage (원본 통화 정보는 `denomination_summary`에 저장)
- ✅ Legacy Fallback (기존 데이터 자동 포함)
- ✅ Type-specific logic (Cash/Vault/Bank 각각 다른 처리)
- ✅ Vault Multi-Currency (Vault도 여러 통화 동시 처리)

---

## 📋 RPC Comparison Table

| Feature | Legacy RPCs | Universal RPC V4 |
|---------|------------|---------------|
| **Cash** | `insert_cashier_amount_lines` | `insert_amount_multi_currency` |
| **Vault** | `vault_amount_insert_v3` | `insert_amount_multi_currency` |
| **Bank** | `bank_amount_insert_v2` | `insert_amount_multi_currency` |
| **Multi-Currency** | ✅ Cash only | ✅ All types (Cash/Vault/Bank) |
| **Entry Creation** | ❌ Cash, Bank / ✅ Vault (per currency) | ✅ All types (**SINGLE** entry) |
| **Base Currency** | ❌ No conversion | ✅ Auto conversion |
| **Balance Tracking** | ❌ Separate table | ✅ In Entry (base currency) |
| **JSONB Storage** | ❌ No | ✅ `denomination_summary`, `exchange_rates` |
| **Legacy Support** | N/A | ✅ Fallback |

---

## 🔄 Migration Strategy

### Phase 1: Deploy New RPC ⏳
**File**: `INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql` ✅ Created

**Action**:
1. Deploy to Supabase SQL Editor
2. Verify function exists:
```sql
SELECT routine_name, pg_get_function_arguments(p.oid)
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname = 'insert_amount_multi_currency';
```

**Status**: ⏳ Waiting for user deployment

**Important Notes**:
- ✅ RPC supports multi-currency (Cash/Vault/Bank)
- ✅ Creates SINGLE entry with base currency conversion
- ✅ Stores original currency data in JSONB fields
- ✅ Vault supports IN/OUT/RECOUNT transaction types
- ⚠️ TODO: Implement actual base currency lookup logic (currently uses first currency as fallback)
- ⚠️ TODO: Implement actual exchange rate lookup (currently defaults to 1.0)

---

### Phase 2: Update Flutter Code (Clean Architecture)

#### 2.1 Data Layer

**Files to Update**:

##### A. Constants (`lib/features/cash_ending/core/constants.dart`)

**Before**:
```dart
class CashEndingConstants {
  static const String rpcInsertCashierAmount = 'insert_cashier_amount_lines';
  static const String rpcInsertVaultAmount = 'vault_amount_insert_v3';
  static const String rpcInsertBankAmount = 'bank_amount_insert_v2';
}
```

**After**:
```dart
class CashEndingConstants {
  // ✅ Universal RPC (모든 타입 사용)
  static const String rpcInsertAmountMultiCurrency = 'insert_amount_multi_currency';

  // Legacy RPCs (Deprecated - for reference only)
  @Deprecated('Use rpcInsertAmountMultiCurrency instead')
  static const String rpcInsertCashierAmount = 'insert_cashier_amount_lines';
  @Deprecated('Use rpcInsertAmountMultiCurrency instead')
  static const String rpcInsertVaultAmount = 'vault_amount_insert_v3';
  @Deprecated('Use rpcInsertAmountMultiCurrency instead')
  static const String rpcInsertBankAmount = 'bank_amount_insert_v2';
}
```

---

##### B. DTOs

**Cash DTO** (`lib/features/cash_ending/data/models/freezed/cash_ending_dto.dart`)

**Current `toRpcParams()`**:
```dart
Map<String, dynamic> toRpcParams() {
  return {
    'p_company_id': companyId,
    'p_location_id': locationId,
    'p_currencies': currencies.map(...).toList(),
    'p_record_date': ...,
    'p_created_by': ...,
    // Legacy format
  };
}
```

**New `toRpcParams()`**:
```dart
Map<String, dynamic> toRpcParams() {
  return {
    'p_entry_type': 'cash',  // ✅ NEW
    'p_company_id': companyId,
    'p_location_id': locationId,
    'p_record_date': DateTimeUtils.toDateOnly(recordDate),
    'p_created_by': userId,
    'p_store_id': storeId,
    'p_description': 'Cash ending',
    'p_currencies': currencies.map((currency) => {
      'currency_id': currency.currencyId,
      'denominations': currency.denominations.map((d) => {
        'denomination_id': d.denominationId,
        'quantity': d.quantity,  // ✅ Stock method
      }).toList(),
    }).toList(),
  };
}
```

---

**Vault DTO** (`lib/features/cash_ending/data/models/freezed/vault_transaction_dto.dart`)

**Current**:
```dart
// Single currency only
Map<String, dynamic> toRpcParams() {
  return {
    'p_company_id': companyId,
    'p_location_id': locationId,
    'p_currency_id': currencyId,  // Single
    'p_denominations': [...],
  };
}
```

**New** (Support Multi-Currency + Transaction Type):
```dart
Map<String, dynamic> toRpcParams({
  required String transactionType,  // 'in', 'out', 'recount'
}) {
  return {
    'p_entry_type': 'vault',  // ✅ NEW
    'p_company_id': companyId,
    'p_location_id': locationId,
    'p_record_date': DateTimeUtils.toDateOnly(recordDate),
    'p_created_by': userId,
    'p_store_id': storeId,
    'p_description': 'Vault $transactionType',
    'p_currencies': [{
      'currency_id': currencyId,
      'denominations': denominations.map((denom) {
        // ✅ Different format based on transaction type
        if (transactionType == 'recount') {
          return {
            'denomination_id': denom.denominationId,
            'quantity': denom.quantity,  // Stock
          };
        } else {
          return {
            'denomination_id': denom.denominationId,
            'debit': transactionType == 'in' ? (denom.quantity * denom.value) : null,
            'credit': transactionType == 'out' ? (denom.quantity * denom.value) : null,
          };
        }
      }).toList(),
    }],
  };
}
```

---

**Bank DTO** (`lib/features/cash_ending/data/models/freezed/bank_balance_dto.dart`)

**New `toRpcParams()`**:
```dart
Map<String, dynamic> toRpcParams() {
  return {
    'p_entry_type': 'bank',  // ✅ NEW
    'p_company_id': companyId,
    'p_location_id': locationId,
    'p_record_date': DateTimeUtils.toDateOnly(recordDate),
    'p_created_by': userId,
    'p_store_id': storeId,
    'p_description': 'Bank balance',
    'p_currencies': [{
      'currency_id': currencyId,
      'total_amount': totalAmount,  // ✅ No denominations
    }],
  };
}
```

---

##### C. Remote DataSources

**Cash DataSource** (`lib/features/cash_ending/data/datasources/cash_ending_remote_datasource.dart`)

**Before**:
```dart
await _client.rpc(
  CashEndingConstants.rpcInsertCashierAmount,
  params: params,
);
```

**After**:
```dart
await _client.rpc(
  CashEndingConstants.rpcInsertAmountMultiCurrency,
  params: params,
);
```

**Vault DataSource** (`lib/features/cash_ending/data/datasources/vault_remote_datasource.dart`)

**Before**:
```dart
await _client.rpc(
  CashEndingConstants.rpcInsertVaultAmount,
  params: params,
);
```

**After**:
```dart
final response = await _client.rpc(
  CashEndingConstants.rpcInsertAmountMultiCurrency,
  params: params,
);
return response;  // ✅ Return response for entry_id
```

**Bank DataSource** (`lib/features/cash_ending/data/datasources/bank_remote_datasource.dart`)

**Same pattern as above**

---

#### 2.2 Domain Layer

**No changes needed!** ✅

- Entities remain the same
- Repositories remain the same
- Use cases remain the same

Clean Architecture의 장점: Domain은 Data Layer 변경에 영향 받지 않음!

---

#### 2.3 Presentation Layer

**Vault Tab** (`lib/features/cash_ending/presentation/widgets/tabs/vault_tab.dart`)

**Transaction Type 전달**:

```dart
// IN button clicked
await vaultTabNotifier.submitVaultTransaction(
  transactionType: 'in',  // ✅ NEW
);

// OUT button clicked
await vaultTabNotifier.submitVaultTransaction(
  transactionType: 'out',  // ✅ NEW
);

// RECOUNT button clicked
await vaultTabNotifier.submitVaultTransaction(
  transactionType: 'recount',  // ✅ NEW
);
```

**Provider/Notifier** (`lib/features/cash_ending/presentation/providers/vault_tab_notifier.dart`)

```dart
Future<void> submitVaultTransaction({
  required String transactionType,  // ✅ NEW
}) async {
  // ... existing code

  final dto = VaultTransactionDto.fromEntity(transaction);
  final params = dto.toRpcParams(transactionType: transactionType);  // ✅ NEW

  await _repository.saveVaultTransaction(params);
}
```

---

## 📝 Input Data Format (Multi-Currency Examples)

### 1. Cash (Stock) - Multi-Currency
```json
{
  "p_entry_type": "cash",
  "p_company_id": "company-uuid",
  "p_location_id": "location-uuid",
  "p_record_date": "2025-11-23",
  "p_created_by": "user-uuid",
  "p_currencies": [
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "500k-uuid", "quantity": 10},
        {"denomination_id": "200k-uuid", "quantity": 5}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "100-usd-uuid", "quantity": 2}
      ]
    }
  ]
}
```
**Result**:
- Single entry with `balance_after` = (VND total + USD total × exchange_rate)
- `denomination_summary` JSONB stores both VND and USD details
- `cashier_amount_lines` created for both currencies

### 2. Vault - IN (Flow - Debit) - Multi-Currency
```json
{
  "p_entry_type": "vault",
  "p_vault_transaction_type": "in",
  "p_company_id": "company-uuid",
  "p_location_id": "vault-location-uuid",
  "p_record_date": "2025-11-23",
  "p_created_by": "user-uuid",
  "p_currencies": [
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "500k-uuid", "debit": 5000000}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "100-usd-uuid", "debit": 200}
      ]
    }
  ]
}
```
**Result**: Single entry with combined total in base currency

### 3. Vault - OUT (Flow - Credit) - Multi-Currency
```json
{
  "p_entry_type": "vault",
  "p_vault_transaction_type": "out",
  "p_company_id": "company-uuid",
  "p_location_id": "vault-location-uuid",
  "p_record_date": "2025-11-23",
  "p_created_by": "user-uuid",
  "p_currencies": [
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "200k-uuid", "credit": 2000000}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "50-usd-uuid", "credit": 100}
      ]
    }
  ]
}
```
**Result**: Single entry with combined withdrawal in base currency (negative)

### 4. Vault - RECOUNT (Stock → Adjustment) - Multi-Currency
```json
{
  "p_entry_type": "vault",
  "p_vault_transaction_type": "recount",
  "p_company_id": "company-uuid",
  "p_location_id": "vault-location-uuid",
  "p_record_date": "2025-11-23",
  "p_created_by": "user-uuid",
  "p_currencies": [
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "500k-uuid", "quantity": 12},
        {"denomination_id": "200k-uuid", "quantity": 8}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "100-usd-uuid", "quantity": 3}
      ]
    }
  ]
}
```
**Result**:
- Calculates system stock vs actual stock for each denomination
- Creates adjustment entry (debit if surplus, credit if shortage)
- Single entry with total adjustment in base currency

### 5. Bank (Amount) - Multi-Currency
```json
{
  "p_entry_type": "bank",
  "p_company_id": "company-uuid",
  "p_location_id": "bank-location-uuid",
  "p_record_date": "2025-11-23",
  "p_created_by": "user-uuid",
  "p_currencies": [
    {
      "currency_id": "vnd-uuid",
      "total_amount": 50000000
    },
    {
      "currency_id": "usd-uuid",
      "total_amount": 1000
    }
  ]
}
```
**Result**:
- Single entry with combined total in base currency
- `bank_amount` records created for each currency
- No denominations (bank uses total_amount only)

---

## 🎯 Expected Results

### Database Tables After Migration

**cash_amount_entries** (SINGLE entry per transaction):
```
entry_id    | entry_type | currency_id | balance_before | balance_after | denomination_summary (JSONB)
uuid-cash-1 | cash       | vnd-uuid    | 0              | 6000000       | [{"currency_id": "vnd", "amount": 6000000, ...}, {"currency_id": "usd", "amount": 200, ...}]
uuid-vault-1| vault      | vnd-uuid    | 5000000        | 10000000      | [{"currency_id": "vnd", "amount": 5000000, ...}, {"currency_id": "usd", "amount": 200, ...}]
uuid-bank-1 | bank       | vnd-uuid    | 0              | 51000000      | [{"currency_id": "vnd", "amount": 50000000, ...}, {"currency_id": "usd", "amount": 1000, ...}]
```
**Key Change**: Single entry with base currency balance, multi-currency details in JSONB

**cashier_amount_lines** (Cash only - multiple currencies):
```
line_id  | entry_id      | denomination_id | quantity
uuid-1   | uuid-cash-1   | vnd-500k-uuid   | 10        ← VND
uuid-2   | uuid-cash-1   | vnd-200k-uuid   | 5         ← VND
uuid-3   | uuid-cash-1   | usd-100-uuid    | 2         ← USD (same entry_id!)
```

**vault_amount_line** (Vault only - multiple currencies):
```
line_id  | entry_id      | denomination_id | debit   | credit | transaction_type
uuid-1   | uuid-vault-1  | vnd-500k-uuid   | 5000000 | NULL   | normal         ← VND
uuid-2   | uuid-vault-1  | usd-100-uuid    | 200     | NULL   | normal         ← USD (same entry_id!)
```

**bank_amount** (Bank only - multiple currencies):
```
bank_amount_id | entry_id     | currency_id | total_amount
uuid-1         | uuid-bank-1  | vnd-uuid    | 50000000     ← VND
uuid-2         | uuid-bank-1  | usd-uuid    | 1000         ← USD (same entry_id!)
```

---

## ✅ Migration Checklist

### Phase 1: Database
- [ ] Deploy `INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql` to Supabase
- [ ] Verify function exists in database
- [ ] Implement base currency lookup logic (TODO in RPC)
- [ ] Implement exchange rate lookup logic (TODO in RPC)
- [ ] Test RPC with sample multi-currency data

### Phase 2: Flutter - Data Layer
- [ ] Update `constants.dart` (add new RPC constant)
- [ ] Update `cash_ending_dto.dart` (`toRpcParams()`)
- [ ] Update `vault_transaction_dto.dart` (`toRpcParams()` with transactionType)
- [ ] Update `bank_balance_dto.dart` (`toRpcParams()`)
- [ ] Update `cash_ending_remote_datasource.dart` (use new RPC)
- [ ] Update `vault_remote_datasource.dart` (use new RPC)
- [ ] Update `bank_remote_datasource.dart` (use new RPC)

### Phase 3: Flutter - Presentation Layer
- [ ] Update `vault_tab.dart` (pass transactionType based on button)
- [ ] Update `vault_tab_notifier.dart` (accept transactionType parameter)
- [ ] Update `cash_tab.dart` (if needed)
- [ ] Update `bank_tab.dart` (if needed)

### Phase 4: Testing
- [ ] Test Cash Tab (multi-currency)
- [ ] Test Vault Tab - IN
- [ ] Test Vault Tab - OUT
- [ ] Test Vault Tab - RECOUNT
- [ ] Test Bank Tab
- [ ] Verify `cash_amount_entries` has data for all types
- [ ] Verify Balance Summary still works

### Phase 5: Cleanup
- [ ] Remove deprecated constants (after verification)
- [ ] Update documentation
- [ ] Create migration notes

---

## 🚨 Rollback Plan

If issues occur:

1. **Immediate Rollback**: Change constants back to legacy RPCs
```dart
static const String rpcInsertCashierAmount = 'insert_cashier_amount_lines';
```

2. **Legacy RPCs remain available**: No deletion, just deprecation

3. **Data remains intact**: New RPC creates entries, but legacy data still accessible via fallback

---

## 📊 Success Criteria

✅ All tabs can submit with multiple currencies
✅ `cash_amount_entries` table populated for all types
✅ Balance tracking works correctly
✅ Legacy data included in balance calculations
✅ No errors during submission
✅ Balance Summary shows correct data

---

**Next Step**: User deploys RPC to Supabase, then we update Flutter code! 🚀
