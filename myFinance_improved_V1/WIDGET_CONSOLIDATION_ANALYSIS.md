# Widget Consolidation & Removal Analysis
Generated on: Thu Sep  4 15:42:47 +07 2025

## Widget Functionality Groups

## Consolidation Opportunities

### 1. Button Consolidation
**Similar Widgets:**
- TossPrimaryButton (68 uses)
- TossSecondaryButton (29 uses)
- TossIconButton (2 uses)
- TossToggleButton (3 uses)
- TossFloatingActionButton (0 uses) - REMOVE

**Analysis:** All button widgets share similar APIs (text, onPressed, isLoading, isEnabled)
**Recommendation:** Create unified TossButton with variant prop
**Impact:** 102 total uses to migrate

### 2. Text Input Consolidation
**Similar Widgets:**
- TossTextField (66 uses)
- TossEnhancedTextField (11 uses) - adds keyboard toolbar
- TossSearchField (17 uses) - adds debouncing & clear button
- TossNumberInput (1 use) - number-specific input

**Analysis:** All are text inputs with overlapping features
**Recommendation:** Merge into TossTextField with type parameter
**Impact:** 95 total uses to migrate

### 3. Bottom Sheet Duplication
**Duplicate Implementations:**
- common/toss_bottom_sheet.dart (25 uses) - static helper
- toss/toss_bottom_sheet.dart (27 uses) - widget

**Analysis:** One is helper class, one is widget - can be combined
**Recommendation:** Single file with both static methods and widget class
**Impact:** 52 total uses to update imports

### 4. Empty/Error State Consolidation
**Similar Widgets:**
- TossEmptyView (13 uses)
- TossEmptyStateCard (7 uses)
- TossErrorView (5 uses)
- TossErrorDialog (7 uses)

**Analysis:** All show state messages with icons
**Recommendation:** Create TossStateView with type parameter
**Impact:** 32 total uses to migrate

### 5. Selector Widget Standardization
**Similar Widgets:**
- AutonomousAccountSelector (0 uses) - REMOVE
- AutonomousCashLocationSelector (11 uses)
- AutonomousCounterpartySelector (7 uses)
- EnhancedAccountSelector (4 uses)
- EnhancedMultiAccountSelector (1 use)
- TossBaseSelector (10 uses)

**Analysis:** All follow similar selector patterns
**Recommendation:** Create generic TossSelector<T> with type configuration
**Impact:** 33 total uses to migrate

## Never Used Widgets (0 Uses) - SAFE TO REMOVE

| Widget | Category | Action |
|--------|----------|--------|
| AppIcon | common | DELETE |
| CompanyStoreBottomDrawer | common | DELETE |
| TossBottomDrawer | common | DELETE |
| TossFloatingActionButton | common | DELETE |
| TossLocationBar | common | DELETE |
| TossNotificationIcon | common | DELETE |
| TossProfileAvatar | common | DELETE |
| TossSortDropdown | common | DELETE |
| TossTypeSelector | common | DELETE |
| MyFinanceAuthHeader | auth | DELETE |
| AutonomousAccountSelector | selectors | DELETE |

## Low Use Widgets (1-4 Uses) - REPLACEMENT CANDIDATES

| Widget | Uses | Replace With | Reason |
|--------|------|--------------|--------|
| TossNumberInput | 1 | TossTextField | Merge as input type |
| TossCurrencyChip | 1 | TossChip | Same functionality |
| TossCheckbox | 1 | Flutter Checkbox | Low customization |
| TossSimpleWheelDatePicker | 1 | Platform picker | Low usage |
| SmartToastNotification | 1 | SnackBar | Standard pattern |
| EnhancedMultiAccountSelector | 1 | TossSelector | Standardize |
| TossToggleButton | 3 | TossButton | Merge as variant |
| TossIconButton | 2 | TossButton | Merge as variant |
| TossModal | 2 | Dialog | Standard widget |
| TossEnhancedModal | 2 | Dialog | Standard widget |

## Summary Statistics

- **Total Widgets:** 57
- **Removable (0 uses):** 11 widgets
- **Replaceable (1-4 uses):** 10 widgets
- **Consolidatable Groups:** 5 major groups
- **Potential Reduction:** 57 → ~25-30 widgets (50% reduction)

## Prioritized Action Plan

### Phase 1: Quick Wins (1 day)
1. **Delete 11 unused widgets** - Zero risk
2. **Fix TossBottomSheet duplication** - High impact (52 uses)

### Phase 2: Low-Risk Replacements (2-3 days)
1. Replace TossNumberInput → TossTextField (1 use)
2. Replace TossCurrencyChip → TossChip (1 use)
3. Replace TossCheckbox → Flutter Checkbox (1 use)
4. Replace SmartToastNotification → SnackBar (1 use)

### Phase 3: Button System Unification (3-4 days)
1. Create unified TossButton component
2. Migrate TossPrimaryButton (68 uses)
3. Migrate TossSecondaryButton (29 uses)
4. Migrate TossIconButton (2 uses)
5. Migrate TossToggleButton (3 uses)

### Phase 4: Text Field Unification (3-4 days)
1. Enhance TossTextField with all features
2. Migrate TossEnhancedTextField (11 uses)
3. Migrate TossSearchField (17 uses)
4. Migrate TossNumberInput (1 use)

### Phase 5: State View Consolidation (2-3 days)
1. Create unified TossStateView
2. Migrate empty/error views (32 uses)

### Phase 6: Selector Standardization (4-5 days)
1. Create generic TossSelector<T>
2. Migrate all selector variants (33 uses)

