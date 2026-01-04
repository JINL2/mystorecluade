# Balance Sheet Feature Architecture Audit Report

**Audit Date:** 2026-01-02
**Feature Path:** `lib/features/balance_sheet`
**Auditor:** Claude Code (Opus 4.5)

---

## Executive Summary

| Category | Status | Score |
|----------|--------|-------|
| God File Detection | PASS | 10/10 |
| God Class Detection | WARNING | 7/10 |
| Folder Structure | PASS | 10/10 |
| Domain Purity | PASS | 10/10 |
| Data Layer Violations | PASS | 10/10 |
| Entity vs DTO Separation | PASS | 10/10 |
| Repository Pattern | PASS | 9/10 |
| Riverpod Usage | PASS | 9/10 |
| Cross-Feature Dependencies | PASS | 9/10 |
| Efficiency Issues | WARNING | 7/10 |

**Overall Score: 91/100 (A)**

---

## 1. God File Detection (500+ Lines)

### Status: PASS

| File | Lines | Status |
|------|-------|--------|
| `data/models/pnl_summary_dto.freezed.dart` | 979 | GENERATED (OK) |
| `presentation/providers/states/balance_sheet_page_state.freezed.dart` | 976 | GENERATED (OK) |
| `presentation/providers/financial_statements_provider.g.dart` | 941 | GENERATED (OK) |
| `domain/entities/balance_sheet.freezed.dart` | 907 | GENERATED (OK) |
| `data/models/bs_summary_dto.freezed.dart` | 714 | GENERATED (OK) |
| `domain/entities/pnl_summary.freezed.dart` | 675 | GENERATED (OK) |
| `domain/entities/bs_summary.freezed.dart` | 631 | GENERATED (OK) |
| `presentation/providers/balance_sheet_providers.g.dart` | 629 | GENERATED (OK) |
| `domain/entities/income_statement.freezed.dart` | 625 | GENERATED (OK) |
| `presentation/widgets/excel_view_modal.dart` | 461 | OK |
| `presentation/widgets/balance_sheet_input/date_range_selector.dart` | 417 | OK |
| `presentation/widgets/income_statement_display/income_section.dart` | 379 | OK |

**Analysis:**
- No manually written files exceed 500 lines (Critical threshold: 1000 lines)
- All large files are auto-generated (`*.freezed.dart`, `*.g.dart`)
- The largest manual file is `excel_view_modal.dart` at 461 lines - acceptable

**Recommendation:** None required.

---

## 2. God Class Detection (3+ Classes per File)

### Status: WARNING

| File | Classes | Status |
|------|---------|--------|
| `presentation/widgets/balance_sheet_display/balance_section.dart` | 4 | WARNING |
| `presentation/widgets/income_statement_display/key_metrics_summary.dart` | 3 | WARNING |
| `presentation/widgets/balance_sheet_input/date_range_selector.dart` | 3 | WARNING |
| `presentation/widgets/income_statement_display/income_section.dart` | 3 | WARNING |
| `presentation/providers/financial_statements_provider.dart` | 5 | WARNING |

**Detailed Analysis:**

#### `balance_section.dart` (4 classes)
```
- BalanceSection (main widget)
- BalanceSubSection (sub-component)
- AccountItem (leaf component)
- BalanceItem (leaf component)
```
**Verdict:** These are tightly coupled UI components that logically belong together. Private helper widgets are acceptable in the same file.

#### `financial_statements_provider.dart` (5 classes)
```
- FinancialStatementsPageState (state class)
- FinancialStatementsPageNotifier (notifier)
- PnlParams (parameter class)
- BsParams (parameter class)
- TrendParams (parameter class)
```
**Verdict:** Parameter classes are small data classes (30-50 lines each). Consider moving to a separate `params/` folder for better organization.

**Recommendations:**
1. Consider extracting `PnlParams`, `BsParams`, `TrendParams` to `presentation/providers/params/` folder
2. UI widget groupings are acceptable (Flutter convention)

---

## 3. Folder Structure

### Status: PASS

```
balance_sheet/
├── data/                          # Data Layer
│   ├── datasources/
│   │   └── balance_sheet_data_source.dart
│   ├── models/                    # DTOs
│   │   ├── balance_sheet_dto.dart
│   │   ├── bs_summary_dto.dart
│   │   ├── income_statement_dto.dart
│   │   └── pnl_summary_dto.dart
│   └── repositories/              # Repository Implementations
│       ├── balance_sheet_repository_impl.dart
│       └── financial_statements_repository_impl.dart
├── di/                            # Dependency Injection
│   └── balance_sheet_injection.dart
├── domain/                        # Domain Layer
│   ├── entities/                  # Business Entities
│   │   ├── balance_sheet.dart
│   │   ├── balance_verification.dart
│   │   ├── bs_summary.dart
│   │   ├── daily_pnl.dart
│   │   ├── financial_account.dart
│   │   ├── income_statement.dart
│   │   └── pnl_summary.dart
│   ├── repositories/              # Repository Interfaces
│   │   ├── balance_sheet_repository.dart
│   │   └── financial_statements_repository.dart
│   └── value_objects/
│       ├── currency.dart
│       └── date_range.dart
└── presentation/                  # Presentation Layer
    ├── pages/
    │   └── financial_statements_page.dart
    ├── providers/
    │   ├── states/
    │   │   └── balance_sheet_page_state.dart
    │   ├── balance_sheet_providers.dart
    │   └── financial_statements_provider.dart
    └── widgets/
        ├── balance_sheet_display/
        ├── balance_sheet_input/
        ├── components/
        ├── income_statement_display/
        └── trend_tab/
```

**Analysis:**
- Clean Architecture layers properly separated (data/domain/presentation)
- `di/` folder isolates dependency injection
- Proper separation of DTOs in `data/models/` and Entities in `domain/entities/`
- Widget organization is well structured by feature area

---

## 4. Domain Purity

### Status: PASS

**Checks Performed:**
- Flutter UI imports in domain layer: **NONE FOUND**
- Data layer imports in domain: **NONE FOUND**
- Presentation layer imports in domain: **NONE FOUND**
- External package usage (except freezed): **NONE FOUND**

**Domain Layer Files Analysis:**

| File | External Dependencies | Status |
|------|----------------------|--------|
| `entities/pnl_summary.dart` | `freezed_annotation` only | PURE |
| `entities/bs_summary.dart` | `freezed_annotation` only | PURE |
| `entities/balance_sheet.dart` | `freezed_annotation` only | PURE |
| `entities/income_statement.dart` | `freezed_annotation` only | PURE |
| `entities/daily_pnl.dart` | `freezed_annotation` only | PURE |
| `value_objects/currency.dart` | `freezed_annotation` only | PURE |
| `value_objects/date_range.dart` | `freezed_annotation` only | PURE |
| `repositories/*.dart` | Domain entities only | PURE |

**Excellent:** Domain layer maintains perfect purity.

---

## 5. Data Layer Violations

### Status: PASS

**Checks Performed:**
- Presentation imports in data layer: **NONE FOUND**
- BuildContext usage in data layer: **NONE FOUND**
- UI widgets in data layer: **NONE FOUND**

**Data Layer Files:**

| File | Dependencies | Status |
|------|--------------|--------|
| `datasources/balance_sheet_data_source.dart` | `supabase_flutter`, DTOs | CLEAN |
| `repositories/balance_sheet_repository_impl.dart` | DataSource, Domain entities | CLEAN |
| `repositories/financial_statements_repository_impl.dart` | DataSource, Domain entities | CLEAN |
| `models/*.dart` | `freezed_annotation`, Domain entities | CLEAN |

**Note:** DTOs correctly import domain entities for `toEntity()` conversion methods.

---

## 6. Entity vs DTO Separation

### Status: PASS

| Domain Entity | Corresponding DTO | toEntity() Method |
|---------------|-------------------|-------------------|
| `PnlSummary` | `PnlSummaryModel` | YES |
| `PnlDetailRow` | `PnlDetailRowModel` | YES |
| `BsSummary` | `BsSummaryModel` | YES |
| `BsDetailRow` | `BsDetailRowModel` | YES |
| `DailyPnl` | `DailyPnlModel` | YES |
| `BalanceSheet` | `BalanceSheetModel` | YES |
| `IncomeStatement` | `IncomeStatementModel` | YES |

**Characteristics:**

**Entities (Domain Layer):**
```dart
// Example: pnl_summary.dart
@freezed
class PnlSummary with _$PnlSummary {
  // NO @JsonKey annotations
  // NO fromJson factory
  // Business logic methods included
  bool get isProfitable => netIncome > 0;
}
```

**DTOs (Data Layer):**
```dart
// Example: pnl_summary_dto.dart
@freezed
class PnlSummaryModel with _$PnlSummaryModel {
  // HAS @JsonKey annotations for API field mapping
  @JsonKey(name: 'gross_profit') @Default(0) double grossProfit,

  // HAS fromJson factory
  factory PnlSummaryModel.fromJson(Map<String, dynamic> json) => ...

  // HAS toEntity() conversion
  PnlSummary toEntity() => PnlSummary(...);
}
```

**Excellent:** Clear separation between serialization (DTO) and business logic (Entity).

---

## 7. Repository Pattern

### Status: PASS

### Repository Interface (Domain)
```dart
// domain/repositories/financial_statements_repository.dart
abstract class FinancialStatementsRepository {
  Future<PnlSummary> getPnlSummary({...});
  Future<List<PnlDetailRow>> getPnlDetail({...});
  Future<BsSummary> getBsSummary({...});
  Future<List<BsDetailRow>> getBsDetail({...});
  Future<List<DailyPnl>> getDailyPnlTrend({...});
  Future<String> getCurrencySymbol(String companyId);
}
```

### Repository Implementation (Data)
```dart
// data/repositories/financial_statements_repository_impl.dart
class FinancialStatementsRepositoryImpl implements FinancialStatementsRepository {
  final BalanceSheetDataSource _dataSource;

  @override
  Future<PnlSummary> getPnlSummary({...}) async {
    final dto = await _dataSource.getPnlSummary(...);
    return dto.toEntity(); // DTO -> Entity conversion
  }
}
```

### DI Setup
```dart
// di/balance_sheet_injection.dart
final balanceSheetRepositoryProvider = Provider<BalanceSheetRepository>((ref) {
  final dataSource = ref.read(_balanceSheetDataSourceProvider);
  return BalanceSheetRepositoryImpl(dataSource);
});
```

**Analysis:**
- Interfaces define contracts in domain layer
- Implementations hide data source details
- DI properly wires implementations to interfaces
- Presentation layer depends on interfaces, not implementations

**Minor Issue:** Two repository systems exist (`BalanceSheetRepository` and `FinancialStatementsRepository`). Consider consolidating.

---

## 8. Riverpod Usage

### Status: PASS

**Provider Types Used:**

| Type | Usage | Example |
|------|-------|---------|
| `@riverpod` (code generation) | Data providers | `pnlSummaryProvider`, `bsSummaryProvider` |
| `@riverpod class` | State notifiers | `FinancialStatementsPageNotifier` |
| `Provider` (manual) | DI setup | `balanceSheetRepositoryProvider` |

**Riverpod Files:**
- `presentation/providers/balance_sheet_providers.dart` - Page state & data providers
- `presentation/providers/financial_statements_provider.dart` - Financial statements providers
- `di/balance_sheet_injection.dart` - DI providers

**Code Generation:**
```dart
@riverpod
Future<PnlSummary> pnlSummary(Ref ref, PnlParams params) async {
  final repository = ref.read(financialStatementsRepositoryProvider);
  return repository.getPnlSummary(...);
}
```

**Consumer Usage:**
```dart
class PnlTabContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financialStatementsPageNotifierProvider);
    final pnlAsync = ref.watch(pnlSummaryProvider(params));
    ...
  }
}
```

**Analysis:**
- Using modern `@riverpod` annotation for code generation
- Proper separation of data providers and state notifiers
- Parameters passed correctly via provider family pattern

---

## 9. Cross-Feature Dependencies

### Status: PASS

**External Feature Dependencies:**

| Dependency | Used In | Type |
|------------|---------|------|
| `auth/di/auth_providers.dart` | `financial_statements_provider.dart` | DI (supabaseClientProvider) |
| `core/domain/entities/store.dart` | Multiple files | Shared Entity |

**Shared Module Dependencies:**

| Module | Usage Count | Files |
|--------|-------------|-------|
| `shared/themes/*` | 25+ | All presentation widgets |
| `shared/widgets/index.dart` | 8 | Various UI components |

**Analysis:**
- No inappropriate cross-feature dependencies
- Uses `core/` for shared entities (Store)
- Uses `shared/` for UI themes and widgets
- Auth provider access is appropriate for data fetching

**Recommendation:** None required. Dependencies follow proper patterns.

---

## 10. Efficiency Issues

### Status: WARNING

### 10.1 Code Duplication

**Issue: `_formatCurrency` method duplicated across 6+ files**

| File | Method |
|------|--------|
| `balance_section.dart` | `_formatCurrency()` (3 copies) |
| `income_section.dart` | `_formatCurrency()` (3 copies) |
| `key_metrics_summary.dart` | `_formatCurrency()` |
| `excel_view_modal.dart` | Inline formatting |

**Recommendation:** Extract to `shared/utils/currency_formatter.dart`:
```dart
class CurrencyFormatter {
  static String format(dynamic amount, String symbol) {
    if (amount == null) return '$symbol 0';
    final numAmount = (amount is num) ? amount : double.tryParse(amount.toString()) ?? 0;
    final formatter = NumberFormat('#,##0', 'en_US');
    final formatted = formatter.format(numAmount.abs());
    return numAmount < 0 ? '-$symbol$formatted' : '$symbol$formatted';
  }
}
```

### 10.2 Unnecessary Complexity

**Issue: Two parallel repository systems**

```
BalanceSheetRepository (Legacy?)
  - getBalanceSheet()
  - getIncomeStatement()
  - getStores()
  - getCurrency()

FinancialStatementsRepository (New?)
  - getPnlSummary()
  - getPnlDetail()
  - getBsSummary()
  - getBsDetail()
  - getDailyPnlTrend()
  - getCurrencySymbol()
```

**Recommendation:** Consolidate into single `FinancialStatementsRepository` or clearly document the purpose of each.

### 10.3 DataSource Legacy Code

The `BalanceSheetDataSource` contains commented sections:
```dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// LEGACY METHODS (keeping for backward compatibility)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Recommendation:** Create migration plan to remove legacy methods when safe.

---

## Recommendations Summary

### High Priority
1. **Extract `_formatCurrency`** to shared utility class (Code Duplication)

### Medium Priority
2. **Consolidate repository systems** - Merge `BalanceSheetRepository` and `FinancialStatementsRepository` or document their distinct purposes
3. **Extract parameter classes** - Move `PnlParams`, `BsParams`, `TrendParams` to dedicated `params/` folder

### Low Priority
4. **Remove legacy code** - Plan deprecation of legacy DataSource methods
5. **Consider splitting** `financial_statements_provider.dart` (5 classes) into smaller files

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     Presentation Layer                           │
├─────────────────────────────────────────────────────────────────┤
│  Pages          │  Providers                │  Widgets          │
│  - financial_   │  - balance_sheet_         │  - balance_sheet_ │
│    statements_  │    providers.dart         │    display/       │
│    page.dart    │  - financial_statements_  │  - balance_sheet_ │
│                 │    provider.dart          │    input/         │
│                 │  - states/                │  - components/    │
│                 │                           │  - trend_tab/     │
└────────────────────────────┬────────────────────────────────────┘
                             │ depends on
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                        DI Layer                                  │
├─────────────────────────────────────────────────────────────────┤
│  balance_sheet_injection.dart                                   │
│  - Provides: BalanceSheetRepository                             │
│  - Hides: BalanceSheetRepositoryImpl, BalanceSheetDataSource    │
└────────────────────────────┬────────────────────────────────────┘
                             │ exposes interface
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Domain Layer                               │
├─────────────────────────────────────────────────────────────────┤
│  Entities        │  Repositories (Interface)  │  Value Objects  │
│  - PnlSummary    │  - BalanceSheetRepository  │  - Currency     │
│  - BsSummary     │  - FinancialStatements     │  - DateRange    │
│  - BalanceSheet  │    Repository              │                 │
│  - IncomeStmt    │                            │                 │
└────────────────────────────┬────────────────────────────────────┘
                             │ implemented by
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Data Layer                                │
├─────────────────────────────────────────────────────────────────┤
│  Models (DTOs)   │  DataSources               │  Repositories   │
│  - PnlSummary    │  - BalanceSheetDataSource  │  - BalanceSheet │
│    Model         │    (Supabase RPC calls)    │    RepositoryImpl│
│  - BsSummary     │                            │  - Financial    │
│    Model         │                            │    Statements   │
│                  │                            │    RepositoryImpl│
└─────────────────────────────────────────────────────────────────┘
```

---

## Conclusion

The `balance_sheet` feature demonstrates **excellent Clean Architecture implementation** with:

- **Perfect domain layer isolation** - No external dependencies except Freezed
- **Proper DTO/Entity separation** - Clear boundaries between data and domain
- **Well-structured folders** - All three layers properly organized
- **Modern Riverpod usage** - Code generation with `@riverpod`
- **Appropriate dependency injection** - DI folder isolates implementation details

Areas for improvement:
- Code duplication in currency formatting utilities
- Two parallel repository systems need consolidation
- Legacy code in DataSource needs cleanup plan

**Overall Assessment: This is a well-architected feature that follows Flutter Clean Architecture best practices.**
