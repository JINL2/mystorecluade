# Design System Migration Plan

## Overview
This plan applies your backup design system changes to the new version while keeping the new folder structure.

**Goals:**
- Fewer custom components
- Less hardcoded styles
- More coherent design system
- Keep new version's flat folder structure (no subfolders)

---

## Part 1: Widget Deletions (Remove Redundant Components)

### 1.1 Delete `toss_list_tile.dart` (196 lines)
**Location:** `lib/shared/widgets/toss/toss_list_tile.dart`

**Why:** In your backup, you replaced TossListTile usages with simpler patterns:
- `_buildSettingsTile()` custom method in settings_section.dart
- Direct `InkWell` usage in language_settings_page.dart

**Impact:** Files using TossListTile need migration first (see Part 2)

### 1.2 Delete `toss_modal.dart` (517 lines)
**Location:** `lib/shared/widgets/toss/toss_modal.dart`

**Why:** Your backup consolidated to `TossBottomSheet` only. TossModal duplicates functionality.

**Impact:** Files using TossModal.show() need migration to TossBottomSheet (see Part 2)

### 1.3 Delete `toss_smart_action_bar.dart`
**Location:** `lib/shared/widgets/toss/toss_smart_action_bar.dart`

**Why:** Removed from overlays/index.dart exports in your backup - not part of the consolidated design system.

### 1.4 Delete `toss_enhanced_text_field.dart` (184 lines)
**Location:** `lib/shared/widgets/toss/toss_enhanced_text_field.dart`

**Why:** New file not in backup. Use existing `toss_text_field.dart` instead.

---

## Part 2: File Migrations (Apply Backup Patterns)

### 2.1 settings_section.dart - Remove TossListTile
**File:** `lib/features/my_page/presentation/widgets/settings_section.dart`

**Current:** Uses TossListTile with complex leading containers
```dart
TossListTile(
  title: 'Edit Profile',
  leading: Container(
    width: TossSpacing.space10,
    height: TossSpacing.space10,
    decoration: BoxDecoration(
      color: TossColors.primary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
    ),
    child: const Icon(Icons.person_outline, ...),
  ),
  trailing: const Icon(Icons.chevron_right, ...),
  onTap: onEditProfile,
),
```

**Backup pattern:** Simple `_buildSettingsTile()` helper method
```dart
Widget _buildSettingsTile({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool isDestructive = false,
}) {
  final iconColor = isDestructive ? TossColors.error : TossColors.primary;
  // ... simple InkWell implementation
}
```

**Action:** Replace TossListTile with `_buildSettingsTile()` method from backup

### 2.2 language_settings_page.dart - Remove TossListTile
**File:** `lib/features/my_page/presentation/pages/language_settings_page.dart`

**Action:** Replace any TossListTile usage with simple InkWell pattern from backup

### 2.3 role_management_sheet.dart - TossModal → TossBottomSheet
**File:** `lib/features/delegate_role/presentation/widgets/role_management_sheet.dart`

**Current:** Uses `TossModal.show()`
```dart
return TossModal.show(
  context: context,
  title: roleName,
  subtitle: canEdit ? 'Edit role details and permissions' : 'View role details',
  height: MediaQuery.of(context).size.height * 0.8,
  ...
);
```

**Backup pattern:** Uses `TossBottomSheet.showWithBuilder()`
```dart
return TossBottomSheet.showWithBuilder(
  context: context,
  heightFactor: 0.85,
  builder: (context) => Container(
    decoration: const BoxDecoration(
      color: TossColors.background,
      borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xl)),
    ),
    child: Column(children: [...]),
  ),
);
```

**Action:** Migrate from TossModal to TossBottomSheet pattern

### 2.4 create_session_dialog.dart - Add showSearch
**File:** `lib/features/session/presentation/widgets/create_session_dialog.dart`

**Current:** Missing `showSearch` parameter
```dart
await TossSelectionBottomSheet.show<void>(
  context: context,
  title: 'Select Store',
  items: items,
  selectedId: _selectedStore?.id,
  showSubtitle: false,
  onItemSelected: (item) { ... },
);
```

**Backup pattern:** Has `showSearch: true`
```dart
await TossSelectionBottomSheet.show<void>(
  context: context,
  title: 'Select Store',
  items: items,
  selectedId: _selectedStore?.id,
  showSubtitle: false,
  showSearch: true, // Enable search for large store lists
  onItemSelected: (item) { ... },
);
```

**Action:** Add `showSearch: true` to both store and shipment selectors

---

## Part 3: File Renaming

### 3.1 Rename toss_numberpad_modal.dart → toss_currency_exchange_modal.dart
**Current:** `lib/shared/widgets/toss/keyboard/toss_numberpad_modal.dart`
**Backup name:** `toss_currency_exchange_modal.dart`

**Why:** More descriptive name indicating its purpose for currency/exchange inputs

**Action:**
1. Rename file
2. Rename class `TossNumberpadModal` → `TossCurrencyExchangeModal`
3. Update all imports across the codebase

---

## Part 4: Update Exports (keyboard/index.dart)

### 4.1 Update keyboard/index.dart
**File:** `lib/shared/widgets/toss/keyboard/index.dart`

**Current exports:**
```dart
export '../toss_smart_action_bar.dart';
export 'keyboard_utils.dart';
export 'toss_numberpad_modal.dart';
export 'toss_textfield_keyboard_modal.dart';
```

**Backup exports:**
```dart
export 'keyboard_utils.dart';
export 'toss_currency_exchange_modal.dart';
export 'toss_textfield_keyboard_modal.dart';
```

**Action:**
- Remove `toss_smart_action_bar.dart` export
- Change `toss_numberpad_modal.dart` → `toss_currency_exchange_modal.dart`

---

## Part 5: Search and Fix All Usages

### 5.1 Find all TossListTile usages
```bash
grep -r "TossListTile" lib/features/ --include="*.dart"
```
**Action:** Replace each with simpler pattern (InkWell or custom helper)

### 5.2 Find all TossModal usages
```bash
grep -r "TossModal" lib/features/ --include="*.dart"
```
**Action:** Migrate each to TossBottomSheet

### 5.3 Find all TossSmartActionBar usages
```bash
grep -r "TossSmartActionBar" lib/ --include="*.dart"
```
**Action:** Remove or replace with keyboard toolbar

### 5.4 Find all TossNumberpadModal usages
```bash
grep -r "TossNumberpadModal" lib/ --include="*.dart"
```
**Action:** Update imports after rename

---

## Execution Order

1. **Phase 1 - Migrations** (safe, no deletions yet)
   - [ ] 2.1 Migrate settings_section.dart
   - [ ] 2.2 Migrate language_settings_page.dart
   - [ ] 2.3 Migrate role_management_sheet.dart
   - [ ] 2.4 Add showSearch to create_session_dialog.dart
   - [ ] 5.1 Find and migrate all TossListTile usages
   - [ ] 5.2 Find and migrate all TossModal usages

2. **Phase 2 - Rename**
   - [ ] 3.1 Rename toss_numberpad_modal.dart
   - [ ] 5.4 Update all imports for renamed file

3. **Phase 3 - Deletions** (only after all migrations complete)
   - [ ] 1.1 Delete toss_list_tile.dart
   - [ ] 1.2 Delete toss_modal.dart
   - [ ] 1.3 Delete toss_smart_action_bar.dart
   - [ ] 1.4 Delete toss_enhanced_text_field.dart

4. **Phase 4 - Update Exports**
   - [ ] 4.1 Update keyboard/index.dart

5. **Phase 5 - Verify**
   - [ ] Run `flutter analyze` to check for errors
   - [ ] Run app to verify UI still works

---

## Files Summary

| Action | File | Lines Removed |
|--------|------|---------------|
| DELETE | toss_list_tile.dart | 196 |
| DELETE | toss_modal.dart | 517 |
| DELETE | toss_smart_action_bar.dart | ~150 |
| DELETE | toss_enhanced_text_field.dart | 184 |
| MODIFY | settings_section.dart | Simplify |
| MODIFY | language_settings_page.dart | Simplify |
| MODIFY | role_management_sheet.dart | TossModal→TossBottomSheet |
| MODIFY | create_session_dialog.dart | Add showSearch |
| RENAME | toss_numberpad_modal.dart → toss_currency_exchange_modal.dart | - |
| MODIFY | keyboard/index.dart | Update exports |

**Total reduction:** ~1000+ lines of redundant widget code

---

## Part 6: Style File Changes (Theme System)

### 6.1 Apply backup toss_text_styles.dart
**File:** `lib/shared/themes/toss_text_styles.dart`

**Changes in backup version:**
- Simplified from 20 styles to 14 core styles
- Added usage comments (e.g., "Usage: 1,233 places")
- Clear hierarchy documentation: display → h1-h4 → body variants → labels → caption
- Removed duplicate `headlineLarge` (was alias to h1)
- Better organized style definitions with actual usage counts

**Key differences:**
```dart
// BACKUP (better documented):
/// Body - Default text for all content (14px, regular)
/// Usage: 1,233 places - most used style
static TextStyle get body => GoogleFonts.inter(...)

// CURRENT (less documented):
// Body Large - Body text, descriptions (14px/20px)
static TextStyle get bodyLarge => GoogleFonts.inter(...)
```

**Action:** Replace current file with backup version (simpler, better documented)

---

## Part 7: AI Widget Style Fixes (Remove Hardcoded Colors)

### 7.1 Fix ai_description_box.dart
**File:** `lib/shared/widgets/ai/ai_description_box.dart`

**Current (hardcoded):**
```dart
color: Colors.amber.shade50,
border: Border.all(color: Colors.amber.shade200),
color: Colors.amber.shade600,
color: Colors.amber.shade700,
```

**Backup (uses design tokens):**
```dart
color: TossColors.warningLight,
border: Border.all(color: TossColors.warning.withValues(alpha: 0.3)),
color: TossColors.warning,
```

**Action:** Restore TossColors.warning usage from backup

### 7.2 Fix ai_description_row.dart
**File:** `lib/shared/widgets/ai/ai_description_row.dart`

**Action:** Apply backup version with TossColors tokens

### 7.3 Fix ai_analysis_details_box.dart
**File:** `lib/shared/widgets/ai/ai_analysis_details_box.dart`

**Action:** Apply backup version with TossColors tokens

---

## Part 8: Hardcoded Styles Cleanup (MAJOR)

### 8.1 Hardcoded fontSize → TossTextStyles
**Total: 749 instances across 212 files**

Key files with most hardcoded fontSize:
- `attendance/` - 25+ files (shift cards, calendars, stats)
- `balance_sheet/` - 10+ files (charts, summaries)
- `cash_ending/` - 8+ files (dialogs, inputs)
- `auth/` - 4 files (signup, profile pages)
- `homepage/` - 5+ files (cards, charts)

**Mapping guide:**
| Hardcoded | → | TossTextStyles |
|-----------|---|----------------|
| fontSize: 32 | → | TossTextStyles.display |
| fontSize: 28 | → | TossTextStyles.h1 |
| fontSize: 24 | → | TossTextStyles.h2 |
| fontSize: 20 | → | TossTextStyles.h3 |
| fontSize: 18 | → | TossTextStyles.h4 |
| fontSize: 17 | → | TossTextStyles.titleLarge |
| fontSize: 15 | → | TossTextStyles.titleMedium |
| fontSize: 14 | → | TossTextStyles.body |
| fontSize: 13 | → | TossTextStyles.bodySmall |
| fontSize: 12 | → | TossTextStyles.caption |
| fontSize: 11 | → | TossTextStyles.caption |
| fontSize: 10 | → | TossTextStyles.label |

### 8.2 Hardcoded EdgeInsets → TossSpacing
**Total: 1,178 instances**

**Mapping guide:**
| Hardcoded | → | TossSpacing |
|-----------|---|-------------|
| EdgeInsets.all(4) | → | TossSpacing.space1 |
| EdgeInsets.all(8) | → | TossSpacing.space2 |
| EdgeInsets.all(12) | → | TossSpacing.space3 |
| EdgeInsets.all(16) | → | TossSpacing.space4 |
| EdgeInsets.all(20) | → | TossSpacing.space5 |
| EdgeInsets.all(24) | → | TossSpacing.space6 |
| EdgeInsets.all(32) | → | TossSpacing.space8 |

### 8.3 Hardcoded BorderRadius → TossBorderRadius
**Total: 425 instances**

**Mapping guide:**
| Hardcoded | → | TossBorderRadius |
|-----------|---|------------------|
| BorderRadius.circular(4) | → | TossBorderRadius.xs |
| BorderRadius.circular(8) | → | TossBorderRadius.sm |
| BorderRadius.circular(12) | → | TossBorderRadius.md |
| BorderRadius.circular(16) | → | TossBorderRadius.lg |
| BorderRadius.circular(20) | → | TossBorderRadius.xl |
| BorderRadius.circular(24) | → | TossBorderRadius.xxl |

---

## Part 9: Custom Widgets → Shared Widgets

### 9.1 Raw showModalBottomSheet → TossBottomSheet
**Total: 20+ usages**

Files to migrate:
- `attendance/presentation/modals/shift_details_bottom_sheet.dart`
- `attendance/presentation/pages/shift_detail_page.dart`
- `attendance/presentation/widgets/check_in_out/attendance_content.dart`
- `attendance/presentation/widgets/shift_register/dialogs/store_selector_dialog.dart`
- `homepage/presentation/widgets/homepage/homepage_header.dart`
- `homepage/presentation/widgets/company_store_selector.dart`
- `homepage/presentation/widgets/bottom_sheets/*.dart`
- `homepage/presentation/widgets/company_store_list.dart`

### 9.2 Custom Card widgets → TossCard (evaluate each)
**Total: 26+ custom Card widgets**

Candidates for migration:
- `BalanceCard` → TossCard
- `CashAccountCard` → TossCard
- `EmployeeCard` → TossCard
- `FeatureCard` → TossCard
- `RevenueCard` → TossCard (may need custom)
- `SalaryCard` → TossCard (may need custom)
- `InventoryProductCard` → TossCard
- `TransactionLineCard` → TossCard

**Note:** Some custom cards have complex logic and may need to stay custom. Evaluate each case.

### 9.3 Available Shared Widgets Reference

**Common widgets (use instead of custom):**
- `TossAppBar1` - Standard app bar
- `TossScaffold` - Standard scaffold
- `TossEmptyView` - Empty state
- `TossErrorView` - Error state
- `TossLoadingView` - Loading state
- `TossSectionHeader` - Section headers
- `TossWhiteCard` - Simple white cards
- `TossConfirmCancelDialog` - Confirmation dialogs
- `TossInfoDialog` - Info dialogs
- `TossDialog.success/error` - Success/error dialogs

**Toss widgets:**
- `TossCard` - Standard card
- `TossExpandableCard` - Expandable card
- `TossButton1` - Primary/secondary buttons
- `TossIconButton` - Icon buttons
- `TossTextField` - Text inputs
- `TossDropdown` - Dropdowns
- `TossBottomSheet` - Bottom sheets
- `TossSelectionBottomSheet` - Selection lists
- `TossChip` - Chips/tags
- `TossBadge` - Badges
- `TossTabBar1` - Tab bars

---

## Updated Execution Order

1. **Phase 1 - Theme System**
   - [ ] 6.1 Apply backup toss_text_styles.dart

2. **Phase 2 - Shared Widget Styles**
   - [ ] 7.1 Fix ai_description_box.dart
   - [ ] 7.2 Fix ai_description_row.dart
   - [ ] 7.3 Fix ai_analysis_details_box.dart

3. **Phase 3 - Component Migrations** (from original plan)
   - [ ] 2.1 Migrate settings_section.dart
   - [ ] 2.2 Migrate language_settings_page.dart
   - [ ] 2.3 Migrate role_management_sheet.dart
   - [ ] 2.4 Add showSearch to create_session_dialog.dart

4. **Phase 4 - Search and Fix All Usages**
   - [ ] 5.1 Find and migrate all TossListTile usages
   - [ ] 5.2 Find and migrate all TossModal usages

5. **Phase 5 - Rename**
   - [ ] 3.1 Rename toss_numberpad_modal.dart
   - [ ] 5.4 Update all imports for renamed file

6. **Phase 6 - Deletions** (only after all migrations)
   - [ ] 1.1 Delete toss_list_tile.dart
   - [ ] 1.2 Delete toss_modal.dart
   - [ ] 1.3 Delete toss_smart_action_bar.dart
   - [ ] 1.4 Delete toss_enhanced_text_field.dart

7. **Phase 7 - Update Exports**
   - [ ] 4.1 Update keyboard/index.dart

8. **Phase 8 - Verify**
   - [ ] Run `flutter analyze`
   - [ ] Run app to verify UI

---

## Summary Statistics

| Category | Count | Files | Impact |
|----------|-------|-------|--------|
| Hardcoded fontSize | 749 | 212 | → TossTextStyles |
| Hardcoded EdgeInsets | 1,178 | many | → TossSpacing |
| Hardcoded BorderRadius | 425 | many | → TossBorderRadius |
| Raw showModalBottomSheet | 20+ | 15+ | → TossBottomSheet |
| Custom Card widgets | 26+ | 26+ | → TossCard (evaluate) |
| Widget deletions | 4 | 4 | ~1000 lines removed |

### Total Work Estimate
- **High priority:** Theme + Widget deletions + Component migrations
- **Medium priority:** Hardcoded styles cleanup (can be done incrementally)
- **Low priority:** Custom cards evaluation (evaluate case by case)

---

## Note
This plan keeps the **flat folder structure** of the new version (no subfolders like actions/, inputs/, etc.) while applying your design cleanup principles from the backup.

**DO NOT fix AI widgets** - per user request, focus on feature page custom widgets and hardcoded styles.
