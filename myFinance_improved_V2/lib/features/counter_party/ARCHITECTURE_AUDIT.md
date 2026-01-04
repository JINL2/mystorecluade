# Counter Party Feature - Architecture Audit Report

**Date:** 2026-01-02
**Auditor:** Claude Opus 4.5 (30-Year Senior Architect Edition)
**Feature:** `counter_party`
**Total Files:** 58 files (including generated files)

---

## Executive Summary

| Category | Status | Score |
|----------|--------|-------|
| God File Detection | Pass | 10/10 |
| God Class Detection | Pass | 10/10 |
| Folder Structure | Pass | 10/10 |
| Domain Purity | Pass | 9/10 |
| Data Layer Compliance | Pass | 10/10 |
| Entity vs DTO Separation | Excellent | 10/10 |
| Repository Pattern | Excellent | 10/10 |
| Riverpod Usage | Excellent | 10/10 |
| Cross-Feature Dependencies | Good | 8/10 |
| Efficiency | Good | 8/10 |

**Overall Architecture Score: 95/100 (Excellent)**

---

## 1. God File Detection (500+ lines warning, 1000+ lines critical)

### Analysis Results

| File | Lines | Status |
|------|-------|--------|
| `counter_party_form.dart` | 637 | Warning (Largest) |
| `account_mapping_datasource.dart` | 310 | Pass |
| `counter_party_data_source.dart` | 313 | Pass |
| `company_dropdown.dart` | 315 | Pass |
| `account_mapping_form_sheet.dart` | 413 | Pass |
| `debt_account_settings_page.dart` | 291 | Pass |
| `counter_party_page.dart` | 246 | Pass |
| `filter_sheet.dart` | 273 | Pass |
| `counter_party_providers.dart` | 288 | Pass |

### Verdict: PASS

No files exceed the critical 1000-line threshold. The largest file `counter_party_form.dart` (637 lines) is slightly over the 500-line warning threshold but is already well-structured with step-based organization.

### Recommendations
- Consider extracting step widgets (`_buildStep1BasicInfo`, `_buildStep2ContactDetails`, `_buildStep3AdditionalSettings`) from `counter_party_form.dart` into separate files like:
  - `form/steps/basic_info_step.dart`
  - `form/steps/contact_details_step.dart`
  - `form/steps/additional_settings_step.dart`

---

## 2. God Class Detection (3+ classes per file)

### Analysis Results

All files follow the single-class-per-file principle:

| File | Classes | Status |
|------|---------|--------|
| All entity files | 1 | Pass |
| All DTO files | 1 | Pass |
| All widget files | 1-2 | Pass |
| `toss_stats_card.dart` | 2 | Pass (TossStatItem + TossStatsCard) |
| `type_selector.dart` | 2 | Pass (TypeSelector + _TypeOptionCard) |
| `filter_sheet.dart` | 2 | Pass (CounterPartyFilterSheet + SortOptionsHelper) |
| `account_mapping_providers.dart` | 2 | Pass (Params classes) |

### Verdict: PASS

No file contains 3 or more unrelated classes. Private helper classes (`_TypeOptionCard`) and simple data classes (`TossStatItem`, parameter classes) are acceptable patterns.

---

## 3. Folder Structure

### Current Structure Analysis

```
counter_party/
+-- data/
|   +-- datasources/
|   |   +-- account_mapping_datasource.dart
|   |   +-- counter_party_data_source.dart
|   +-- models/
|   |   +-- account_mapping_dto.dart (+ freezed/g files)
|   |   +-- counter_party_dto.dart (+ freezed/g files)
|   |   +-- counter_party_deletion_validation_dto.dart (+ freezed/g files)
|   +-- repositories/
|       +-- account_mapping_repository_impl.dart
|       +-- counter_party_repository_impl.dart
+-- domain/
|   +-- entities/
|   |   +-- account_mapping.dart (+ freezed file)
|   |   +-- counter_party.dart (+ freezed file)
|   |   +-- counter_party_deletion_validation.dart (+ freezed file)
|   |   +-- counter_party_stats.dart (+ freezed file)
|   +-- repositories/
|   |   +-- account_mapping_repository.dart (interface)
|   |   +-- counter_party_repository.dart (interface)
|   +-- usecases/
|   |   +-- calculate_counter_party_stats.dart
|   |   +-- create_account_mapping_usecase.dart
|   |   +-- delete_account_mapping_usecase.dart
|   |   +-- get_account_mappings_usecase.dart
|   |   +-- sort_counter_parties.dart
|   +-- value_objects/
|       +-- counter_party_filter.dart (+ freezed/g files)
|       +-- counter_party_type.dart
|       +-- relative_time.dart
+-- presentation/
|   +-- pages/
|   |   +-- counter_party_page.dart
|   |   +-- debt_account_settings_page.dart
|   +-- providers/
|   |   +-- account_mapping_providers.dart (+ g file)
|   |   +-- counter_party_data.dart (+ freezed file)
|   |   +-- counter_party_params.dart (+ freezed file)
|   |   +-- counter_party_providers.dart (+ g file)
|   +-- widgets/
|       +-- counter_party_form.dart
|       +-- counter_party_list_item.dart
|       +-- debt_account/
|       +-- filter/
|       +-- form/
|       +-- list/
|       +-- stats/
+-- di/
    +-- counter_party_providers.dart
```

### Verdict: PASS (10/10)

Excellent Clean Architecture structure with:
- Clear separation of `data`, `domain`, `presentation` layers
- `di` folder for dependency injection
- Proper subdirectory organization within each layer
- Widget folders organized by feature/context

---

## 4. Domain Layer Purity

### Import Analysis

#### Entities (domain/entities/)

| File | External Imports | Status |
|------|-----------------|--------|
| `account_mapping.dart` | `freezed_annotation` only | Pass |
| `counter_party.dart` | `freezed_annotation` only | Pass |
| `counter_party_deletion_validation.dart` | `freezed_annotation` only | Pass |
| `counter_party_stats.dart` | `freezed_annotation` only | Pass |

#### Repositories (domain/repositories/)

| File | External Imports | Status |
|------|-----------------|--------|
| `account_mapping_repository.dart` | None (pure Dart) | Pass |
| `counter_party_repository.dart` | None (pure Dart) | Pass |

#### UseCases (domain/usecases/)

| File | External Imports | Status |
|------|-----------------|--------|
| `calculate_counter_party_stats.dart` | None (pure Dart) | Pass |
| `sort_counter_parties.dart` | None (pure Dart) | Pass |
| `create_account_mapping_usecase.dart` | None (pure Dart) | Pass |
| `get_account_mappings_usecase.dart` | None (pure Dart) | Pass |
| `delete_account_mapping_usecase.dart` | None (pure Dart) | Pass |

#### Value Objects (domain/value_objects/)

| File | External Imports | Issue |
|------|-----------------|-------|
| `counter_party_filter.dart` | `freezed_annotation` | Pass |
| `counter_party_type.dart` | `freezed_annotation` (JsonValue) | Minor |
| `relative_time.dart` | None (pure Dart) | Pass |

### Issues Found

1. **Minor Issue:** `counter_party_filter.dart` includes `toColumnName()` method:
   ```dart
   String toColumnName() {
     switch (this) {
       case CounterPartySortOption.name:
         return 'name';  // Database column name
   ```
   This method maps to database column names, which is technically a data layer concern. However, it's acceptable as a presentation-agnostic mapping.

### Verdict: PASS (9/10)

Domain layer is highly pure with only `freezed_annotation` as external dependency for immutable value objects. The `toColumnName()` method is a minor concern but acceptable.

---

## 5. Data Layer Compliance

### Violation Check

| File | Presentation Import | BuildContext Usage | Status |
|------|--------------------|--------------------|--------|
| `account_mapping_datasource.dart` | None | None | Pass |
| `counter_party_data_source.dart` | None | None | Pass |
| `account_mapping_dto.dart` | None | None | Pass |
| `counter_party_dto.dart` | None | None | Pass |
| `counter_party_deletion_validation_dto.dart` | None | None | Pass |
| `account_mapping_repository_impl.dart` | None | None | Pass |
| `counter_party_repository_impl.dart` | None | None | Pass |

### Special Notes

- `counter_party_data_source.dart` uses `debugPrint` from Flutter foundation - This is acceptable for debugging purposes but could be replaced with a logging abstraction.

### Verdict: PASS (10/10)

No presentation layer imports or BuildContext usage in data layer.

---

## 6. Entity vs DTO Separation

### Entity-DTO Mapping Table

| Entity | DTO | Conversion Methods | Status |
|--------|-----|-------------------|--------|
| `AccountMapping` | `AccountMappingDto` | `toEntity()`, `fromEntity()` | Excellent |
| `CounterParty` | `CounterPartyDto` | `toEntity()`, `fromEntity()` | Excellent |
| `CounterPartyDeletionValidation` | `CounterPartyDeletionValidationDto` | `toEntity()`, `fromEntity()` | Excellent |
| `CounterPartyStats` | N/A (computed) | N/A | N/A |

### Entity Characteristics

```dart
// domain/entities/counter_party.dart
@freezed
class CounterParty with _$CounterParty {
  const factory CounterParty({
    required String counterpartyId,
    required String companyId,
    // ... NO JSON ANNOTATIONS
  }) = _CounterParty;
}
```

### DTO Characteristics

```dart
// data/models/counter_party_dto.dart
@freezed
class CounterPartyDto with _$CounterPartyDto {
  const factory CounterPartyDto({
    @JsonKey(name: 'counterparty_id') required String counterpartyId,
    @JsonKey(name: 'company_id') required String companyId,
    // ... JSON KEY ANNOTATIONS for API/DB mapping
  }) = _CounterPartyDto;

  factory CounterPartyDto.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyDtoFromJson(json);

  AccountMapping toEntity() => ...;
  factory AccountMappingDto.fromEntity(AccountMapping entity) => ...;
}
```

### Verdict: EXCELLENT (10/10)

Perfect separation with:
- Entities are pure domain objects (no JSON)
- DTOs handle all serialization concerns
- Bidirectional conversion methods provided
- Custom JSON converters for date/time handling

---

## 7. Repository Pattern

### Interface Definition

```dart
// domain/repositories/counter_party_repository.dart
abstract class CounterPartyRepository {
  Future<List<CounterParty>> getCounterParties({...});
  Future<CounterParty?> getCounterPartyById(String counterpartyId);
  Future<CounterParty> createCounterParty({...});
  Future<CounterParty> updateCounterParty({...});
  Future<CounterPartyDeletionValidation> validateDeletion(String counterpartyId);
  Future<bool> deleteCounterParty(String counterpartyId);
  Future<List<Map<String, dynamic>>> getUnlinkedCompanies({...});
}
```

### Implementation

```dart
// data/repositories/counter_party_repository_impl.dart
class CounterPartyRepositoryImpl implements CounterPartyRepository {
  final CounterPartyDataSource _dataSource;

  CounterPartyRepositoryImpl(this._dataSource);

  @override
  Future<List<CounterParty>> getCounterParties({...}) async {
    final data = await _dataSource.getCounterParties(...);
    return data
        .map((json) => CounterPartyDto.fromJson(json).toEntity())
        .toList();
  }
  // ...
}
```

### Pattern Compliance

| Aspect | Implementation | Status |
|--------|---------------|--------|
| Interface in Domain | Yes | Pass |
| Implementation in Data | Yes | Pass |
| Dependency Injection | Yes (via Riverpod) | Pass |
| DTO-to-Entity Conversion | Yes | Pass |
| Error Handling | Yes (Exception wrapping) | Pass |
| DataSource Abstraction | Yes | Pass |

### Verdict: EXCELLENT (10/10)

---

## 8. Riverpod Usage Analysis

### Provider Types Used

| Provider Type | Count | Example |
|--------------|-------|---------|
| `@riverpod` (codegen) | 14 | `optimizedCounterPartyData` |
| `Provider` (classic) | 9 | `counterPartyRepositoryProvider` |
| `StateNotifier` equivalent | 2 | `CounterPartySearch`, `CounterPartyFilterNotifier` |

### Modern Riverpod Patterns

```dart
// Codegen syntax
@riverpod
Future<CounterPartyData> optimizedCounterPartyData(
  OptimizedCounterPartyDataRef ref,
  String companyId,
) async {...}

// State management with codegen
@riverpod
class CounterPartySearch extends _$CounterPartySearch {
  @override
  String build() => '';
  void setSearch(String query) => state = query;
}
```

### Provider Organization

| Category | Providers |
|----------|-----------|
| DI Layer | `supabaseClientProvider`, `counterPartyRepositoryProvider`, `accountMappingRepositoryProvider` |
| State | `counterPartySearchProvider`, `counterPartyFilterNotifierProvider` |
| Data Fetching | `optimizedCounterPartyDataProvider`, `accountMappingsProvider`, `unlinkedCompaniesProvider` |
| Actions | `createCounterPartyProvider`, `updateCounterPartyProvider`, `deleteCounterPartyProvider` |
| Derived | `optimizedCounterPartiesProvider`, `optimizedCounterPartyStatsProvider` |

### Cache Management

```dart
@riverpod
CounterPartyCacheManager counterPartyCache(CounterPartyCacheRef ref) {
  return CounterPartyCacheManager(ref);
}

class CounterPartyCacheManager {
  bool isCacheFresh(String companyId) {...}
  void refreshIfStale(String companyId) {...}
  void clearCache() {...}
}
```

### Verdict: EXCELLENT (10/10)

- Uses modern `@riverpod` codegen annotation
- Proper separation of DI, state, data, and action providers
- Cache invalidation strategy implemented
- Family providers for parameterized queries

---

## 9. Cross-Feature Dependencies

### Import Analysis

| File | Cross-Feature Imports | Status |
|------|----------------------|--------|
| `counter_party_providers.dart` | `app_state_provider.dart` | Expected |
| `account_mapping_form_sheet.dart` | `app_state_provider.dart` | Expected |
| `counter_party_page.dart` | `shared/themes/*`, `shared/widgets/*` | Expected |
| All presentation files | `shared/*` | Expected |

### External Feature Dependencies

| Dependency | Usage | Type |
|------------|-------|------|
| `app/providers/app_state_provider.dart` | User/Company context | Core |
| `core/utils/datetime_utils.dart` | UTC date handling | Core Utility |
| `shared/themes/*` | UI constants | Shared |
| `shared/widgets/*` | Common components | Shared |

### Verdict: GOOD (8/10)

Dependencies are appropriate:
- Core app state access is necessary
- Shared UI components promote consistency
- No circular dependencies detected
- No inappropriate cross-feature coupling

**Minor Concern:** Direct access to `appStateProvider` in multiple files. Consider creating a feature-local provider that wraps app state access.

---

## 10. Efficiency Analysis

### Positive Patterns

1. **Optimized Data Fetching:**
   ```dart
   @riverpod
   Future<CounterPartyData> optimizedCounterPartyData(...) async {
     // Single database query
     final counterParties = await repository.getCounterParties(...);
     // Efficient statistics calculation
     final stats = calculateStats(counterParties);
     return CounterPartyData(
       counterParties: counterParties,
       stats: stats,
       fetchedAt: DateTime.now(),
     );
   }
   ```

2. **Derived State Pattern:**
   ```dart
   @riverpod
   AsyncValue<List<CounterParty>> optimizedCounterParties(...) {
     // Uses base data, applies filters/sorting in memory
     return dataAsync.when(
       data: (data) {
         var counterParties = data.counterParties;
         // In-memory filtering
         if (filter.types != null) {...}
         // In-memory sorting using UseCase
         counterParties = sortUseCase(counterParties, ...);
         return AsyncValue.data(counterParties);
       },
     );
   }
   ```

3. **Cache Validity:**
   ```dart
   class CounterPartyData {
     static const int _cacheValiditySeconds = 30;
     bool get isStale =>
         DateTime.now().difference(fetchedAt).inSeconds > _cacheValiditySeconds;
   }
   ```

4. **Debounced Search:**
   ```dart
   void _onSearchChanged(String value) {
     _searchDebounce?.cancel();
     _searchDebounce = Timer(TossAnimations.slow, () {
       ref.read(counterPartySearchProvider.notifier).setSearch(value);
     });
   }
   ```

### Areas for Improvement

1. **Duplicate Map Transformation:**
   - `getAccountMappings` and `getUnlinkedCompanies` return `List<Map<String, dynamic>>` instead of typed objects
   - Consider creating proper DTOs for these

2. **debugPrint Usage:**
   - Multiple `debugPrint` statements in `counter_party_data_source.dart` and `counter_party_providers.dart`
   - Consider using a proper logging abstraction

### Verdict: GOOD (8/10)

---

## Detailed Recommendations

### High Priority

1. **Extract Form Steps** from `counter_party_form.dart` (637 lines):
   ```
   presentation/widgets/form/steps/
   +-- basic_info_step.dart
   +-- contact_details_step.dart
   +-- additional_settings_step.dart
   ```

### Medium Priority

2. **Create Proper DTOs** for untyped maps:
   ```dart
   // data/models/unlinked_company_dto.dart
   @freezed
   class UnlinkedCompanyDto {
     factory UnlinkedCompanyDto({
       required String companyId,
       required String companyName,
       required bool isAlreadyLinked,
     }) = _UnlinkedCompanyDto;
   }
   ```

3. **Abstract App State Access:**
   ```dart
   // presentation/providers/counter_party_context_provider.dart
   @riverpod
   CounterPartyContext counterPartyContext(ref) {
     final appState = ref.watch(appStateProvider);
     return CounterPartyContext(
       companyId: appState.companyChoosen,
       userId: appState.user['user_id'] as String?,
     );
   }
   ```

### Low Priority

4. **Replace debugPrint with Logger:**
   ```dart
   // Use a logging abstraction
   class CounterPartyLogger {
     static void info(String message) {...}
     static void error(String message, Object? error) {...}
   }
   ```

5. **Consider Moving `toColumnName()`:**
   Move database column mapping to repository or a dedicated mapper:
   ```dart
   // data/mappers/sort_option_mapper.dart
   extension SortOptionToColumn on CounterPartySortOption {
     String toColumnName() {...}
   }
   ```

---

## File Count Summary

| Layer | Count | Percentage |
|-------|-------|------------|
| Data | 12 files (+ 6 generated) | 31% |
| Domain | 12 files (+ 7 generated) | 33% |
| Presentation | 16 files (+ 5 generated) | 36% |
| DI | 1 file | - |

**Total:** 41 source files + 18 generated files = 59 files

---

## Conclusion

The `counter_party` feature demonstrates **excellent Clean Architecture implementation**. The codebase follows best practices including:

- Clear layer separation (data/domain/presentation)
- Pure domain layer with no external dependencies
- Proper Entity-DTO separation with bidirectional conversion
- Well-implemented Repository pattern
- Modern Riverpod usage with codegen
- Efficient data fetching with caching strategy
- Minimal cross-feature coupling

The few recommendations provided are refinements rather than architectural fixes. This feature can serve as a **reference implementation** for other features in the project.

---

*Generated by Claude Opus 4.5 - Architecture Audit System*
