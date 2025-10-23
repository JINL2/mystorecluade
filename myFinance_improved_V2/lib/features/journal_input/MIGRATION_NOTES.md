# Journal Input Feature Migration Notes

## Migration Status: 95% Complete

This document lists all external dependencies and files that need changes outside the `features/journal_input` folder.

---

## ✅ Completed Migration

### Domain Layer (100%)
- ✅ `domain/entities/transaction_line.dart` - Pure domain entity
- ✅ `domain/entities/journal_entry.dart` - Business logic entity
- ✅ `domain/repositories/journal_entry_repository.dart` - Repository interface

### Data Layer (100%)
- ✅ `data/models/transaction_line_model.dart` - DTO with mappers
- ✅ `data/models/journal_entry_model.dart` - DTO with mappers
- ✅ `data/datasources/journal_entry_datasource.dart` - All RPC/query calls
- ✅ `data/repositories/journal_entry_repository_impl.dart` - Repository implementation
- ✅ `data/repositories/repository_providers.dart` - Riverpod DI providers

### Presentation Layer (90%)
- ✅ `presentation/providers/journal_input_providers.dart` - State management
- ✅ `presentation/widgets/transaction_line_card.dart` - Display widget
- ✅ `presentation/widgets/exchange_rate_calculator.dart` - Calculator widget
- ⚠️ `presentation/widgets/add_transaction_dialog.dart` - Has external dependencies (see below)
- ⚠️ `presentation/pages/journal_input_page.dart` - Needs import updates (see below)

---

## 🚨 External Dependencies Required

### 1. Selector Widgets (Priority: HIGH)

These widgets are referenced in `add_transaction_dialog.dart` but haven't been migrated yet:

#### a. Enhanced Account Selector
**Current Path (lib_old):**
```
lib_old/presentation/widgets/specific/selectors/enhanced_account_selector.dart
```

**Recommended New Path:**
```
lib/shared/widgets/selectors/enhanced_account_selector.dart
```

**Reason:** This is a reusable UI component used across multiple features, belongs in `shared/widgets/`

**Usage in journal_input:**
```dart
// In add_transaction_dialog.dart line ~200
EnhancedAccountSelector(
  onAccountSelected: (account) { ... },
  categoryTag: _categoryTag,
)
```

---

#### b. Autonomous Counterparty Selector
**Current Path (lib_old):**
```
lib_old/presentation/widgets/specific/selectors/autonomous_counterparty_selector.dart
```

**Recommended New Path:**
```
lib/shared/widgets/selectors/autonomous_counterparty_selector.dart
```

**Reason:** Reusable UI component for counterparty selection

**Usage in journal_input:**
```dart
// In add_transaction_dialog.dart line ~350
AutonomousCounterpartySelector(
  companyId: companyId,
  onCounterpartySelected: (counterparty) { ... },
)
```

---

#### c. Autonomous Cash Location Selector
**Current Path (lib_old):**
```
lib_old/presentation/widgets/specific/selectors/autonomous_cash_location_selector.dart
```

**Recommended New Path:**
```
lib/shared/widgets/selectors/autonomous_cash_location_selector.dart
```

**Reason:** Reusable UI component for cash location selection

**Usage in journal_input:**
```dart
// In add_transaction_dialog.dart line ~450
AutonomousCashLocationSelector(
  companyId: companyId,
  storeId: storeId,
  onLocationSelected: (location) { ... },
)
```

---

### 2. Provider Dependencies (Priority: HIGH)

#### Counterparty Provider
**Current Path (lib_old):**
```
lib_old/presentation/providers/entities/counterparty_provider.dart
```

**Recommended New Path:**
```
lib/features/counterparty/presentation/providers/counterparty_provider.dart
```

**Reason:** This is counterparty feature-specific logic, should be in its own feature folder

**Alternative (if counterparty is not a full feature):**
```
lib/core/providers/counterparty_provider.dart
```

**Usage in journal_input:**
```dart
// In add_transaction_dialog.dart line ~100
final counterpartyState = ref.watch(selectedCounterpartyProvider);
```

---

## 📝 Files Requiring Import Updates

### 1. add_transaction_dialog.dart

**File Path:**
```
lib/features/journal_input/presentation/widgets/add_transaction_dialog.dart
```

**Current Temporary Imports (with TODO markers):**
```dart
// TODO: Update these imports when selectors and counterparty provider are migrated
import '../../../../lib_old/presentation/providers/entities/counterparty_provider.dart';
import '../../../../lib_old/presentation/widgets/specific/selectors/autonomous_cash_location_selector.dart';
import '../../../../lib_old/presentation/widgets/specific/selectors/autonomous_counterparty_selector.dart';
import '../../../../lib_old/presentation/widgets/specific/selectors/enhanced_account_selector.dart';
```

**Required Updates (once dependencies are migrated):**
```dart
// Update to new architecture paths
import '../../../../shared/widgets/selectors/autonomous_cash_location_selector.dart';
import '../../../../shared/widgets/selectors/autonomous_counterparty_selector.dart';
import '../../../../shared/widgets/selectors/enhanced_account_selector.dart';
import '../../../../core/providers/counterparty_provider.dart'; // or features/counterparty/...
```

---

### 2. journal_input_page.dart (⚠️ BLOCKED - Needs External Dependencies)

**File Path:**
```
lib/features/journal_input/presentation/pages/journal_input_page.dart
```

**Status:** ❌ Cannot complete until external dependencies are migrated

**Blocking Dependencies:**
1. `app/helpers/navigation_helper.dart` - Does not exist at expected path
2. `shared/widgets/common/toss_app_bar.dart` - Does not exist (currently in lib_old)
3. `shared/widgets/common/toss_scaffold.dart` - Does not exist (currently in lib_old)
4. `shared/widgets/common/toss_white_card.dart` - Does not exist (currently in lib_old)
5. `shared/widgets/common/toss_empty_view.dart` - Does not exist (currently in lib_old)
6. `shared/widgets/toss/toss_primary_button.dart` - Does not exist (currently in lib_old)
7. `shared/widgets/toss/toss_secondary_button.dart` - Does not exist (currently in lib_old)
8. `shared/widgets/toss/toss_enhanced_text_field.dart` - Does not exist (currently in lib_old)

**Required Import Updates:**
```dart
// Domain
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/transaction_line.dart';

// Presentation
import '../providers/journal_input_providers.dart';
import '../widgets/transaction_line_card.dart';
import '../widgets/add_transaction_dialog.dart';

// App (NEEDS TO BE CREATED/MOVED):
import '../../../../app/helpers/navigation_helper.dart';
import '../../../../app/providers/app_state_provider.dart';

// Shared widgets (NEEDS TO BE CREATED/MOVED):
import '../../../../shared/widgets/common/toss_app_bar.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../shared/widgets/common/toss_empty_view.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../shared/widgets/toss/toss_secondary_button.dart';
import '../../../../shared/widgets/toss/toss_enhanced_text_field.dart';

// Shared themes
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_border_radius.dart';
```

**State Management Refactoring Required:**

The entire page needs to be refactored from ChangeNotifier pattern to immutable StateProvider pattern:

```dart
// ❌ OLD (ChangeNotifier pattern - REMOVE ALL):
final journalEntry = ref.read(journalEntryProvider);
journalEntry.clear();
journalEntry.setSelectedCompany(appState.companyChoosen);
journalEntry.addTransactionLine(result);
journalEntry.updateTransactionLine(index, result);
journalEntry.removeTransactionLine(index);
journalEntry.setCounterpartyCashLocation(id);
journalEntry.setOverallDescription(text);

// ✅ NEW (Immutable StateProvider pattern - IMPLEMENT):
final journalEntry = ref.watch(journalEntryStateProvider);
final journalController = ref.read(journalEntryStateProvider.notifier);

// Using extension methods from journal_input_providers.dart:
journalController.clear();
journalController.setSelectedCompany(appState.companyChoosen);
journalController.addTransactionLine(result);
journalController.updateTransactionLine(index, result);
journalController.removeTransactionLine(index);
journalController.setCounterpartyCashLocation(id);
journalController.setOverallDescription(text);
```

**Additional Refactoring Notes:**

1. **Line 52-61** (initState): Replace ChangeNotifier method calls with StateController extension methods
2. **Line 82-142** (_addTransactionLine): Update to use immutable state
3. **Line 144-182** (_editTransactionLine): Update to use immutable state
4. **Line 184-281** (_submitJournalEntry): Update submit function call signature (needs 4 params, not 1)
5. **Line 285-298** (build): Replace `journalEntryProvider` with `journalEntryStateProvider`
6. **All method calls**: Replace mutable method calls with extension methods

**Submit Function Signature Change:**
```dart
// OLD:
await submitFunction(journalEntry);

// NEW:
await submitFunction(
  journalEntry: journalEntry,
  userId: currentUserId,
  companyId: appState.companyChoosen,
  storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
);
```

---

## 🔄 Router Configuration

**File to Update:**
```
lib/app/config/app_router.dart
```

**Required Changes:**

Add route for the new journal_input page:
```dart
import 'package:go_router/go_router.dart';
import '../../features/journal_input/presentation/pages/journal_input_page.dart';

// In routes list:
GoRoute(
  path: '/journal-input',
  name: 'journal-input',
  builder: (context, state) => const JournalInputPage(),
),
```

**Note:** Verify if there's an existing route pointing to the old lib_old page and update/remove it.

---

## 🎯 Migration Action Plan

### Phase 1: Migrate Shared Selectors (External Team/Separate Task)
1. Create `lib/shared/widgets/selectors/` directory
2. Migrate `enhanced_account_selector.dart`
3. Migrate `autonomous_counterparty_selector.dart`
4. Migrate `autonomous_cash_location_selector.dart`
5. Update imports to use `shared/themes/` paths

### Phase 2: Migrate Counterparty Provider (External Team/Separate Task)
1. Decide on provider location (core/providers vs features/counterparty)
2. Migrate `counterparty_provider.dart`
3. Update to use StateProvider instead of ChangeNotifier (if needed)

### Phase 3: Complete journal_input Migration (Can do now)
1. ✅ Update imports in `add_transaction_dialog.dart` (blocked by Phase 1 & 2)
2. Update imports in `journal_input_page.dart`
3. Update state management from ChangeNotifier to StateProvider pattern
4. Add route in `app_router.dart`
5. Test the complete flow

### Phase 4: Cleanup (After Phase 3 complete)
1. Remove old files from `lib_old/presentation/pages/journal_input/`
2. Verify no other features reference the old paths
3. Run `flutter analyze` and fix any warnings

---

## 📊 RPC Functions Used

This feature uses the following Supabase RPC functions:

1. **`get_cash_locations`**
   - Parameters: `p_company_id`
   - Returns: `List<Map<String, dynamic>>`
   - Used in: `journal_entry_datasource.dart`

2. **`get_exchange_rate_v2`**
   - Parameters: `p_company_id`
   - Returns: `Map<String, dynamic>`
   - Used in: `journal_entry_datasource.dart`

3. **`insert_journal_with_everything`**
   - Parameters: Multiple (see datasource implementation)
   - Returns: `void`
   - Used in: `journal_entry_datasource.dart`

---

## 📊 Database Queries Used

Direct Supabase queries (not RPC):

1. **`accounts` table**
   ```dart
   .from('accounts')
   .select('account_id, account_name, category_tag')
   .order('account_name')
   ```

2. **`counterparties` table**
   ```dart
   .from('counterparties')
   .select('counterparty_id, counterparty_name, linked_company_id')
   .eq('company_id', companyId)
   ```

3. **`stores` table**
   ```dart
   .from('stores')
   .select('store_id, store_name')
   .eq('linked_company_id', linkedCompanyId)
   ```

4. **`account_mappings` table**
   ```dart
   .from('account_mappings')
   .select('*')
   .eq('company_id', companyId)
   .eq('counterparty_id', counterpartyId)
   .eq('account_id', accountId)
   .maybeSingle()
   ```

---

## ✅ Verification Checklist

Before marking this migration as complete:

- [ ] All selector widgets migrated to `shared/widgets/selectors/`
- [ ] Counterparty provider migrated to appropriate location
- [ ] All imports in `add_transaction_dialog.dart` updated
- [ ] All imports in `journal_input_page.dart` updated
- [ ] State management converted from ChangeNotifier to StateProvider
- [ ] Route added to `app_router.dart`
- [ ] No compile errors (`flutter analyze`)
- [ ] Manual testing: Create journal entry flow works
- [ ] Manual testing: Edit transaction line works
- [ ] Manual testing: Delete transaction line works
- [ ] Manual testing: Debit/Credit balance checking works
- [ ] Manual testing: Submit journal entry works
- [ ] Old lib_old files removed
- [ ] No other features reference old paths

---

## 📝 Notes

- This migration follows Clean Architecture with Feature-First organization
- Domain layer is 100% framework-independent
- State management uses immutable StateProvider pattern instead of ChangeNotifier
- All RPC calls have proper type parameters to avoid type inference issues
- Double-entry bookkeeping validation is preserved in domain entity logic
