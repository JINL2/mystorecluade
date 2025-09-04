# Widget Implementation & Migration Plan
Generated on: Thu Sep  4 15:51:21 +07 2025

## 1. NEVER-USED WIDGETS (Safe to Delete)

These widgets have 0 uses and can be deleted immediately:

| Widget | File | Action | Risk |
|--------|------|--------|------|
| AppIcon | common/app_icon.dart | DELETE | None |
| CompanyStoreBottomDrawer | common/company_store_bottom_drawer.dart | DELETE | None |
| TossBottomDrawer | common/toss_bottom_drawer.dart | DELETE | None |
| TossFloatingActionButton | common/toss_floating_action_button.dart | DELETE | None |
| TossLocationBar | common/toss_location_bar.dart | DELETE | None |
| TossNotificationIcon | common/toss_notification_icon.dart | DELETE | None |
| TossProfileAvatar | common/toss_profile_avatar.dart | DELETE | None |
| TossSortDropdown | common/toss_sort_dropdown.dart | DELETE | None |
| TossTypeSelector | common/toss_type_selector.dart | DELETE | None |
| MyFinanceAuthHeader | auth/myfinance_auth_header.dart | DELETE | None |
| AutonomousAccountSelector | selectors/autonomous_account_selector.dart | DELETE | None |

**Deletion Command:**
```bash
cd /Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1
rm lib/presentation/widgets/common/{app_icon,company_store_bottom_drawer,toss_bottom_drawer,toss_floating_action_button,toss_location_bar,toss_notification_icon,toss_profile_avatar,toss_sort_dropdown,toss_type_selector}.dart
rm lib/presentation/widgets/auth/myfinance_auth_header.dart
rm lib/presentation/widgets/specific/selectors/autonomous_account_selector.dart
```

## 2. LOW-USE WIDGETS (1-4 uses) - Replacement Details

### TossNumberInput → TossTextField
**Current Usage: 1 location**
- store_shift/store_shift_page.dart

**Migration Example:**
```dart
// Before:
TossNumberInput(
  controller: controller,
  hintText: '0',
  suffix: 'USD',
)

// After:
TossTextField(
  controller: controller,
  hintText: '0',
  keyboardType: TextInputType.number,
  suffixIcon: Text('USD'),
)
```

### TossCurrencyChip → TossChip
**Current Usage: 1 location**
- cash_ending/cash_ending_page.dart

**Migration Example:**
```dart
// Before:
TossCurrencyChip(
  currencyId: currencyId,
  symbol: symbol,
  name: name,
  isSelected: isSelected,
  onTap: onTap,
)

// After:
TossChip(
  label: '$symbol - $name',
  isSelected: isSelected,
  onTap: onTap,
)
```

### TossCheckbox → Flutter Checkbox
**Current Usage: 1 location (self-referential)**
- Only used in TossCheckboxListTile example code

**Action: DELETE** (no real usage)

### TossIconButton → IconButton
**Current Usage: 2 locations**
- transactions/widgets/transaction_detail_sheet.dart (2 uses)

**Migration Example:**
```dart
// Before:
TossIconButton(
  icon: Icons.copy,
  iconSize: 20,
  tooltip: 'Copy',
  onPressed: () {},
)

// After:
IconButton(
  icon: Icon(Icons.copy, size: 20),
  tooltip: 'Copy',
  onPressed: () {},
)
```

### SmartToastNotification → SnackBar
**Current Usage: 1 location**
- core/notifications/services/notification_display_manager.dart

**Migration Example:**
```dart
// Before:
SmartToastNotification.show(
  context,
  title: 'Title',
  body: 'Message',
)

// After:
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Column(
      children: [
        Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Message'),
      ],
    ),
  ),
)
```

## 3. BUTTON CONSOLIDATION IMPACT

### TossPrimaryButton & TossSecondaryButton Analysis

- **TossPrimaryButton**:       69 uses
- **TossSecondaryButton**:       30 uses

**Key Differences:**
- Both have identical APIs (text, onPressed, isLoading, isEnabled, leadingIcon)
- Only difference is styling (primary vs secondary)

**Migration Strategy:**
```dart
// New unified TossButton
class TossButton extends StatefulWidget {
  final ButtonVariant variant; // primary, secondary, icon, text
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  // ... all existing props
}

// Migration:
TossPrimaryButton(text: 'Save', ...) → TossButton.primary(text: 'Save', ...)
TossSecondaryButton(text: 'Cancel', ...) → TossButton.secondary(text: 'Cancel', ...)
```

## 4. BOTTOM SHEET DUPLICATION FIX

**Two implementations:**
1. common/toss_bottom_sheet.dart - Static helper class
2. toss/toss_bottom_sheet.dart - Widget class

**Solution:** Merge into single file with both functionalities

**Migration:** Update imports only (no API changes)
```bash
# Find and replace imports
find lib -name '*.dart' -exec sed -i 's|widgets/common/toss_bottom_sheet|widgets/toss/toss_bottom_sheet|g' {} +
```

## 5. TEXT FIELD CONSOLIDATION ANALYSIS

### Feature Comparison
| Widget | Uses | Unique Features |
|--------|------|-----------------|
| TossTextField | 66 | Base implementation |
| TossEnhancedTextField | 11 | + keyboard toolbar, done/next buttons |
| TossSearchField | 17 | + debouncing, clear button, search icon |
| TossNumberInput | 1 | + number keyboard, minimal style |

**Consolidation Strategy:**
```dart
TossTextField(
  // Existing props
  controller: controller,
  hintText: 'Enter text',
  
  // New optional props for variants
  variant: TextFieldVariant.search, // standard (default), search, enhanced
  showKeyboardToolbar: true, // from enhanced
  debounceDelay: Duration(milliseconds: 300), // from search
  showClearButton: true, // from search
)
```

## Implementation Timeline

### Day 1: Quick Wins (2-3 hours)
- [ ] Delete 11 unused widgets
- [ ] Fix TossCheckbox (delete - no real usage)
- [ ] Replace TossNumberInput (1 file)
- [ ] Replace TossCurrencyChip (1 file)

### Day 2: Simple Replacements (3-4 hours)
- [ ] Replace TossIconButton with IconButton (1 file, 2 locations)
- [ ] Replace SmartToastNotification with SnackBar (1 file)
- [ ] Fix TossBottomSheet duplication (52 imports to update)

### Week 1: Button Consolidation (2-3 days)
- [ ] Create unified TossButton widget
- [ ] Migrate TossPrimaryButton (68 uses)
- [ ] Migrate TossSecondaryButton (29 uses)
- [ ] Test all button interactions

### Week 2: Text Field Consolidation (2-3 days)
- [ ] Enhance TossTextField with all features
- [ ] Migrate TossEnhancedTextField (11 uses)
- [ ] Migrate TossSearchField (17 uses)
- [ ] Test all form inputs

## Risk Assessment

| Change | Risk | Mitigation |
|--------|------|------------|
| Delete unused widgets | None | No usage found |
| Replace low-use widgets | Low | Only 1-2 files affected each |
| Button consolidation | Medium | Identical APIs, only styling differs |
| Text field consolidation | Medium | Feature additions, backward compatible |
| Bottom sheet fix | Low | Import changes only |

