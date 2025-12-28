# UI/UX Refactoring Master Plan

> **Project:** myFinance_improved_V2
> **Created:** 2025-12-26
> **Version:** 1.0.0
> **Status:** Planning Phase

---

## Executive Summary

This document outlines a safe, phased approach to refactor the UI/UX codebase following 2025 Flutter best practices. The plan focuses on:
- Consolidating duplicate widgets
- Splitting God Files (>500 lines)
- Creating reusable page templates
- Standardizing the design system

**Estimated Duration:** 6-8 weeks
**Risk Level:** Medium (with safety measures: Low)

---

## Table of Contents

1. [Current State Analysis](#1-current-state-analysis)
2. [Refactoring Goals](#2-refactoring-goals)
3. [Phase 1: Audit & Safety Net](#phase-1-audit--safety-net-week-1)
4. [Phase 2: Design System Consolidation](#phase-2-design-system-consolidation-week-2)
5. [Phase 3: Widget Consolidation](#phase-3-widget-consolidation-week-2-3)
6. [Phase 4: God File Splitting](#phase-4-god-file-splitting-week-3-5)
7. [Phase 5: Page Templates](#phase-5-page-templates-week-5-6)
8. [Phase 6: Feature Migration](#phase-6-feature-migration-week-6-7)
9. [Phase 7: Cleanup & Validation](#phase-7-cleanup--validation-week-8)
10. [Safety Guidelines](#safety-guidelines)
11. [Success Metrics](#success-metrics)

---

## 1. Current State Analysis

### 1.1 Codebase Overview

| Metric | Count | Status |
|--------|-------|--------|
| Total Features | 27 | Good modularization |
| Shared Widgets | 85 files | Some duplication |
| Theme Files | 19 files | Well organized |
| God Files (>800 lines) | 24 files | Needs attention |
| God Files (>1500 lines) | 8 files | Critical |

### 1.2 God Files Requiring Split (Priority Order)

| File | Lines | Priority | Complexity |
|------|-------|----------|------------|
| `design_library/.../theme_library_page.dart` | 2,751 | P0 | High |
| `delegate_role/.../role_management_sheet.dart` | 2,005 | P0 | High |
| `my_page/.../subscription_page.dart` | 1,967 | P0 | High |
| `session/.../session_receiving_review_page.dart` | 1,793 | P1 | High |
| `cash_transaction/.../transfer_entry_sheet.dart` | 1,789 | P1 | High |
| `inventory_management/.../edit_product_page.dart` | 1,706 | P1 | Medium |
| `inventory_management/.../add_product_page.dart` | 1,646 | P1 | Medium |
| `session/.../session_history_detail_page.dart` | 1,643 | P1 | High |
| `session/.../session_review_page.dart` | 1,607 | P2 | High |
| `cash_location/.../account_detail_page.dart` | 1,343 | P2 | Medium |
| `sales_invoice/.../invoice_detail_page.dart` | 1,303 | P2 | Medium |
| `cash_transaction/.../cash_transaction_page.dart` | 1,277 | P2 | Medium |
| `sales_invoice/.../sales_invoice_page.dart` | 1,228 | P2 | Medium |
| `cash_ending/.../cash_ending_completion_page.dart` | 1,215 | P2 | Medium |
| `auth/.../create_business_page.dart` | 1,211 | P3 | Medium |
| `session/.../session_count_detail_page.dart` | 1,136 | P3 | Medium |
| `inventory_management/.../inventory_management_page.dart` | 1,093 | P3 | Medium |
| `my_page/.../edit_profile_page.dart` | 1,081 | P3 | Low |

### 1.3 Duplicate Widget Patterns

#### Buttons (Need Consolidation)
```
lib/shared/widgets/toss/
├── toss_button.dart           (267 lines) - Base button
├── toss_button_1.dart         (550 lines) - Extended button
├── toss_primary_button.dart   (26 lines)  - Legacy alias
├── toss_secondary_button.dart (26 lines)  - Legacy alias
├── toss_icon_button.dart      (300 lines) - Icon button
├── toss_hover_circle_button.dart          - Hover effect button
├── toggle_button.dart         (98 lines)  - Toggle variant
└── debounced_button.dart                  - Debounced variant
```

**Action:** Merge into single `TossButton` with variants

#### Cards (Need Consolidation)
```
lib/shared/widgets/toss/
├── toss_card.dart             (90 lines)  - Base card
├── toss_card_safe.dart        (175 lines) - Safe area card
├── toss_expandable_card.dart  (265 lines) - Expandable
├── toss_white_card.dart       (35 lines)  - White variant
├── toss_today_shift_card.dart (749 lines) - Domain-specific
└── toss_week_shift_card.dart  (170 lines) - Domain-specific
```

**Action:** Keep base cards, move domain-specific to features

### 1.4 Shared Widgets Inventory (85 files)

#### Atoms (Base Components)
- Buttons: 6 files
- Inputs: 4 files (toss_text_field, toss_search_field, toss_enhanced_text_field, toss_quantity_input)
- Display: 3 files (toss_badge, toss_chip, category_chip)
- Navigation: 2 files (toss_week_navigation, toss_month_navigation)

#### Molecules (Composite Components)
- Cards: 6 files
- List Items: 2 files (toss_list_tile)
- Pickers: 5 files (date, time, calendar, week, month)
- Modals: 4 files (toss_modal, toss_bottom_sheet, selection_bottom_sheet)

#### Organisms (Complex Components)
- Selectors: 4 files (account, counterparty, cash_location, base)
- Dialogs: 4 files (confirm, success_error, info, calendar_bottom_sheet)
- Action Bars: 2 files (toss_smart_action_bar, keyboard_toolbar)

#### Domain-Specific (Should Move to Features)
- AI Chat: 10 files
- Shift Cards: 2 files

---

## 2. Refactoring Goals

### 2.1 Primary Goals
1. **Reduce widget duplication** by 60%
2. **Split all God Files** to <500 lines each
3. **Create 3 page templates** for consistent layouts
4. **Achieve 100% design token usage** (no hardcoded values)

### 2.2 Secondary Goals
1. Improve code discoverability with atomic design structure
2. Add barrel exports for cleaner imports
3. Document all shared widgets
4. Create widget showcase in design_library

### 2.3 Non-Goals (Out of Scope)
- Business logic refactoring
- State management changes
- Backend/API changes
- New feature development

---

## Phase 1: Audit & Safety Net (Week 1)

### 1.1 Create Documentation

**Files to Create:**
```
lib/shared/widgets/
├── WIDGET_INVENTORY.md      # List all widgets with usage counts
├── DEPRECATION_SCHEDULE.md  # Widgets to be deprecated
└── MIGRATION_GUIDE.md       # How to migrate to new widgets
```

### 1.2 Git Strategy

```bash
# Create main refactoring branch
git checkout -b refactor/ui-design-system-2025

# Create checkpoint branches after each phase
git checkout -b checkpoint/phase-1-complete
git checkout -b checkpoint/phase-2-complete
# ... etc
```

### 1.3 Widget Usage Audit

Run this script to generate usage report:

```bash
#!/bin/bash
# save as: scripts/widget_audit.sh

WIDGETS=(
  "TossButton"
  "TossButton1"
  "TossCard"
  "TossTextField"
  "TossChip"
  "TossBadge"
  "TossListTile"
  "TossModal"
  "TossBottomSheet"
)

echo "# Widget Usage Report" > WIDGET_USAGE.md
echo "Generated: $(date)" >> WIDGET_USAGE.md
echo "" >> WIDGET_USAGE.md

for widget in "${WIDGETS[@]}"; do
  count=$(grep -rln "$widget(" lib/features/ --include="*.dart" | wc -l)
  echo "- $widget: $count usages" >> WIDGET_USAGE.md
done
```

### 1.4 Create Widget Tests

**Priority widgets to test:**
```dart
// test/shared/widgets/toss_button_test.dart
void main() {
  group('TossButton', () {
    testWidgets('renders with text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossButton(
              text: 'Test',
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading=true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossButton(
              text: 'Test',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('is disabled when isEnabled=false', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TossButton(
              text: 'Test',
              isEnabled: false,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Test'));
      expect(tapped, isFalse);
    });
  });
}
```

### 1.5 Deliverables Checklist

- [ ] WIDGET_INVENTORY.md created
- [ ] DEPRECATION_SCHEDULE.md created
- [ ] Widget usage report generated
- [ ] Git refactoring branch created
- [ ] Tests for top 10 most-used widgets
- [ ] Screenshots of current UI (for comparison)

---

## Phase 2: Design System Consolidation (Week 2)

### 2.1 Verify Design Token Coverage

Current tokens (already exist):
```
lib/shared/themes/
├── toss_colors.dart         ✓
├── toss_spacing.dart        ✓
├── toss_text_styles.dart    ✓
├── toss_animations.dart     ✓
├── toss_shadows.dart        ✓
├── toss_border_radius.dart  ✓
└── toss_design_system.dart  ✓ (master reference)
```

### 2.2 Create Component Style Classes

```dart
// lib/shared/themes/component_styles/index.dart
export 'button_styles.dart';
export 'card_styles.dart';
export 'input_styles.dart';
export 'dialog_styles.dart';
```

```dart
// lib/shared/themes/component_styles/button_styles.dart
import '../index.dart';

/// Centralized button styles for consistency
class TossButtonStyles {
  TossButtonStyles._();

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(
    horizontal: TossSpacing.space4,
    vertical: TossSpacing.space3,
  );

  static final BorderRadius defaultRadius = BorderRadius.circular(
    TossBorderRadius.md,
  );

  // Primary Button
  static const primaryBackground = TossColors.primary;
  static const primaryText = TossColors.white;

  // Secondary Button
  static const secondaryBackground = TossColors.gray100;
  static const secondaryText = TossColors.gray900;

  // Outlined Button
  static const outlinedBackground = TossColors.transparent;
  static const outlinedBorder = TossColors.gray300;
  static const outlinedText = TossColors.gray700;

  // Disabled State
  static const disabledBackground = TossColors.gray200;
  static const disabledText = TossColors.gray400;
}
```

### 2.3 Deliverables Checklist

- [ ] component_styles/ folder created
- [ ] button_styles.dart implemented
- [ ] card_styles.dart implemented
- [ ] input_styles.dart implemented
- [ ] All hardcoded colors identified and replaced

---

## Phase 3: Widget Consolidation (Week 2-3)

### 3.1 Button Consolidation

**Current State:**
```
toss_button.dart      → TossButton (basic, 2 variants)
toss_button_1.dart    → TossButton1 (extended, 5 variants)
toss_primary_button.dart   → Legacy alias
toss_secondary_button.dart → Legacy alias
```

**Target State:**
```dart
// lib/shared/widgets/atoms/buttons/toss_button.dart

enum TossButtonVariant {
  primary,    // Blue background, white text
  secondary,  // Gray background, dark text
  outlined,   // Transparent with border
  outlinedGray, // Gray border variant
  text,       // Text only, no background
  danger,     // Red for destructive actions
}

enum TossButtonSize {
  small,   // 32px height
  medium,  // 40px height (default)
  large,   // 48px height
}

class TossButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TossButtonVariant variant;
  final TossButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final bool fullWidth;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  // Optional style overrides (for edge cases only)
  final TossButtonStyle? style;

  const TossButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = TossButtonVariant.primary,
    this.size = TossButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.fullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.style,
  });

  // Factory constructors for common use cases
  const factory TossButton.primary({...}) = _PrimaryTossButton;
  const factory TossButton.secondary({...}) = _SecondaryTossButton;
  const factory TossButton.outlined({...}) = _OutlinedTossButton;
  const factory TossButton.text({...}) = _TextTossButton;
  const factory TossButton.danger({...}) = _DangerTossButton;
  const factory TossButton.icon({...}) = _IconTossButton;
}
```

### 3.2 Migration Steps for Buttons

```dart
// Step 1: Create unified TossButton (new file)
// lib/shared/widgets/atoms/buttons/toss_button_unified.dart

// Step 2: Add deprecation warnings to old files
// lib/shared/widgets/toss/toss_button.dart
@Deprecated('Use TossButton from atoms/buttons instead. Will be removed in v2.0')
class TossButton extends StatefulWidget { ... }

// Step 3: Create compatibility typedef
// lib/shared/widgets/toss/toss_button.dart
@Deprecated('Use TossButton from atoms/buttons')
typedef TossButton = TossButtonUnified;

// Step 4: Update imports feature by feature
// OLD: import 'package:myfinance/shared/widgets/toss/toss_button.dart';
// NEW: import 'package:myfinance/shared/widgets/atoms/buttons/toss_button.dart';
```

### 3.3 Card Consolidation

**Keep in shared/widgets:**
- `toss_card.dart` → Base card
- `toss_expandable_card.dart` → Expandable variant

**Move to features:**
- `toss_today_shift_card.dart` → `features/attendance/presentation/widgets/`
- `toss_week_shift_card.dart` → `features/attendance/presentation/widgets/`

### 3.4 Deliverables Checklist

- [ ] TossButton unified with all variants
- [ ] TossButton1 deprecated
- [ ] Legacy button files deprecated
- [ ] Domain-specific cards moved to features
- [ ] All imports updated
- [ ] Tests pass

---

## Phase 4: God File Splitting (Week 3-5)

### 4.1 Splitting Strategy

For each God File, follow this pattern:

```
BEFORE: edit_product_page.dart (1,706 lines)

AFTER:
edit_product_page/
├── edit_product_page.dart          (~150 lines) - Main scaffold, orchestration
├── edit_product_controller.dart    (~200 lines) - Business logic, state
├── widgets/
│   ├── product_image_section.dart  (~200 lines)
│   ├── product_basic_info_form.dart(~250 lines)
│   ├── product_pricing_form.dart   (~200 lines)
│   ├── product_inventory_form.dart (~200 lines)
│   ├── product_category_picker.dart(~150 lines)
│   └── product_action_buttons.dart (~100 lines)
└── index.dart                      - Barrel export
```

### 4.2 P0 Files (Week 3)

#### 4.2.1 theme_library_page.dart (2,751 lines)

```
design_library/presentation/pages/
├── theme_library_page.dart         (~100 lines) - Tab scaffold
├── sections/
│   ├── colors_section.dart         (~200 lines)
│   ├── typography_section.dart     (~200 lines)
│   ├── spacing_section.dart        (~200 lines)
│   ├── buttons_section.dart        (~300 lines)
│   ├── cards_section.dart          (~250 lines)
│   ├── inputs_section.dart         (~300 lines)
│   ├── dialogs_section.dart        (~250 lines)
│   ├── icons_section.dart          (~200 lines)
│   └── animations_section.dart     (~200 lines)
└── widgets/
    ├── section_header.dart         (~50 lines)
    ├── color_swatch.dart           (~80 lines)
    └── component_preview.dart      (~100 lines)
```

#### 4.2.2 role_management_sheet.dart (2,005 lines)

```
delegate_role/presentation/widgets/
├── role_management_sheet.dart      (~150 lines) - Main sheet
├── role_management_controller.dart (~300 lines) - Logic
├── sections/
│   ├── role_header_section.dart    (~150 lines)
│   ├── permission_list_section.dart(~400 lines)
│   ├── member_list_section.dart    (~300 lines)
│   └── role_actions_section.dart   (~150 lines)
└── widgets/
    ├── permission_toggle.dart      (~100 lines)
    ├── member_avatar_row.dart      (~100 lines)
    └── role_card.dart              (~150 lines)
```

#### 4.2.3 subscription_page.dart (1,967 lines)

```
my_page/presentation/pages/
├── subscription_page.dart          (~150 lines)
├── subscription_controller.dart    (~250 lines)
├── sections/
│   ├── current_plan_section.dart   (~200 lines)
│   ├── plan_comparison_section.dart(~400 lines)
│   ├── billing_history_section.dart(~250 lines)
│   └── payment_method_section.dart (~200 lines)
└── widgets/
    ├── plan_card.dart              (~200 lines)
    ├── feature_row.dart            (~80 lines)
    └── invoice_tile.dart           (~100 lines)
```

### 4.3 P1 Files (Week 4)

| File | Target Structure |
|------|------------------|
| session_receiving_review_page.dart | 6 section files + widgets |
| transfer_entry_sheet.dart | 5 section files + controller |
| edit_product_page.dart | 6 widget files + controller |
| add_product_page.dart | (similar to edit_product) |
| session_history_detail_page.dart | 5 section files |

### 4.4 P2 Files (Week 5)

| File | Target Structure |
|------|------------------|
| session_review_page.dart | 4 sections |
| account_detail_page.dart | 5 sections |
| invoice_detail_page.dart | 4 sections |
| cash_transaction_page.dart | 4 sections |
| sales_invoice_page.dart | 4 sections |
| cash_ending_completion_page.dart | 5 sections |

### 4.5 Splitting Template

```dart
// ORIGINAL: some_complex_page.dart (1500+ lines)

// STEP 1: Identify logical sections
// - Header/Hero section
// - Form section(s)
// - List section(s)
// - Action section

// STEP 2: Create folder structure
// some_complex_page/
// ├── some_complex_page.dart
// ├── some_complex_controller.dart (if stateful logic)
// ├── sections/
// │   ├── header_section.dart
// │   ├── form_section.dart
// │   └── action_section.dart
// └── widgets/
//     └── (small reusable widgets)

// STEP 3: Main page becomes orchestrator
class SomeComplexPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TossScaffold(
      appBar: TossAppBar(title: 'Page Title'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HeaderSection()),
          SliverToBoxAdapter(child: FormSection()),
          SliverFillRemaining(child: ActionSection()),
        ],
      ),
    );
  }
}

// STEP 4: Each section is self-contained
class HeaderSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only the logic for this section
    return Container(...);
  }
}
```

### 4.6 Deliverables Checklist

- [ ] P0 files split (3 files)
- [ ] P1 files split (5 files)
- [ ] P2 files split (6 files)
- [ ] All files under 500 lines
- [ ] Tests updated and passing
- [ ] No regression in functionality

---

## Phase 5: Page Templates (Week 5-6)

### 5.1 Identify Common Patterns

Based on analysis, 3 main patterns emerge:

#### Pattern A: List Page (60% of pages)
```
┌────────────────────────┐
│ AppBar + Actions       │
├────────────────────────┤
│ Search Field           │
├────────────────────────┤
│ Filter Chips           │
├────────────────────────┤
│                        │
│ Scrollable List        │
│ (with pull-refresh)    │
│                        │
├────────────────────────┤
│ FAB                    │
└────────────────────────┘
```

#### Pattern B: Detail Page (25% of pages)
```
┌────────────────────────┐
│ AppBar + Actions       │
├────────────────────────┤
│ Hero Section           │
├────────────────────────┤
│ Tab Bar (optional)     │
├────────────────────────┤
│                        │
│ Content Sections       │
│ (scrollable)           │
│                        │
├────────────────────────┤
│ Bottom Action Bar      │
└────────────────────────┘
```

#### Pattern C: Form Page (15% of pages)
```
┌────────────────────────┐
│ AppBar (with close)    │
├────────────────────────┤
│                        │
│ Form Fields            │
│ (scrollable)           │
│                        │
├────────────────────────┤
│ Submit Button          │
└────────────────────────┘
```

### 5.2 Template Implementations

```dart
// lib/shared/widgets/templates/toss_list_page.dart

class TossListPage<T> extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  // Search
  final bool showSearch;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;

  // Filters
  final List<Widget>? filterChips;

  // List
  final AsyncValue<List<T>> items;
  final Widget Function(T item, int index) itemBuilder;
  final Widget? separator;

  // Empty/Error states
  final Widget? emptyWidget;
  final Widget Function(Object error)? errorBuilder;

  // Actions
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;

  const TossListPage({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.actions,
    this.leading,
    this.showSearch = false,
    this.searchHint,
    this.onSearchChanged,
    this.filterChips,
    this.separator,
    this.emptyWidget,
    this.errorBuilder,
    this.floatingActionButton,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: TossAppBar(
        title: title,
        leading: leading,
        actions: actions,
      ),
      body: Column(
        children: [
          if (showSearch)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.paddingMD),
              child: TossSearchField(
                hint: searchHint ?? 'Search...',
                onChanged: onSearchChanged,
              ),
            ),
          if (filterChips != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.paddingMD,
              ),
              child: Row(
                children: filterChips!
                    .map((chip) => Padding(
                          padding: const EdgeInsets.only(right: TossSpacing.space2),
                          child: chip,
                        ))
                    .toList(),
              ),
            ),
          Expanded(
            child: items.when(
              loading: () => const TossLoadingView(),
              error: (error, _) => errorBuilder?.call(error) ??
                  TossErrorView(message: error.toString()),
              data: (data) {
                if (data.isEmpty) {
                  return emptyWidget ?? const TossEmptyView();
                }
                return RefreshIndicator(
                  onRefresh: onRefresh ?? () async {},
                  child: ListView.separated(
                    padding: const EdgeInsets.all(TossSpacing.paddingMD),
                    itemCount: data.length,
                    separatorBuilder: (_, __) =>
                        separator ?? const SizedBox(height: TossSpacing.space2),
                    itemBuilder: (context, index) =>
                        itemBuilder(data[index], index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
```

```dart
// lib/shared/widgets/templates/toss_detail_page.dart

class TossDetailPage extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? heroSection;
  final List<Tab>? tabs;
  final List<Widget>? tabViews;
  final List<Widget> sections;
  final Widget? bottomActionBar;

  const TossDetailPage({
    super.key,
    required this.title,
    required this.sections,
    this.actions,
    this.heroSection,
    this.tabs,
    this.tabViews,
    this.bottomActionBar,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = CustomScrollView(
      slivers: [
        if (heroSection != null)
          SliverToBoxAdapter(child: heroSection!),
        ...sections.map((section) => SliverToBoxAdapter(child: section)),
        // Add bottom padding for action bar
        if (bottomActionBar != null)
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );

    if (tabs != null && tabViews != null) {
      body = DefaultTabController(
        length: tabs!.length,
        child: Column(
          children: [
            if (heroSection != null) heroSection!,
            TabBar(tabs: tabs!),
            Expanded(child: TabBarView(children: tabViews!)),
          ],
        ),
      );
    }

    return TossScaffold(
      appBar: TossAppBar(title: title, actions: actions),
      body: body,
      bottomNavigationBar: bottomActionBar,
    );
  }
}
```

```dart
// lib/shared/widgets/templates/toss_form_page.dart

class TossFormPage extends StatelessWidget {
  final String title;
  final GlobalKey<FormState>? formKey;
  final List<Widget> fields;
  final Widget submitButton;
  final VoidCallback? onClose;
  final bool showCloseConfirmation;
  final String closeConfirmationMessage;

  const TossFormPage({
    super.key,
    required this.title,
    required this.fields,
    required this.submitButton,
    this.formKey,
    this.onClose,
    this.showCloseConfirmation = true,
    this.closeConfirmationMessage = 'Discard changes?',
  });

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: TossAppBar(
        title: title,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            if (showCloseConfirmation) {
              final confirm = await TossConfirmDialog.show(
                context,
                message: closeConfirmationMessage,
              );
              if (confirm == true) {
                onClose?.call() ?? Navigator.of(context).pop();
              }
            } else {
              onClose?.call() ?? Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          children: [
            ...fields.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space3),
              child: field,
            )),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          child: submitButton,
        ),
      ),
    );
  }
}
```

### 5.3 Deliverables Checklist

- [ ] TossListPage template created
- [ ] TossDetailPage template created
- [ ] TossFormPage template created
- [ ] Templates documented in design_library
- [ ] 2-3 existing pages migrated to templates (as examples)

---

## Phase 6: Feature Migration (Week 6-7)

### 6.1 Migration Order (By Risk Level)

| Order | Feature | Risk | Files | Reason |
|-------|---------|------|-------|--------|
| 1 | design_library | Low | 1 | Showcase page, safe to experiment |
| 2 | notifications | Low | 2 | Simple, isolated |
| 3 | employee_setting | Low | 15 | Medium complexity |
| 4 | my_page | Medium | 19 | User-facing but non-critical |
| 5 | inventory_management | Medium | 29 | Important but well-tested |
| 6 | journal_input | Medium | 8 | Core but small |
| 7 | counter_party | Medium | 20 | Business critical |
| 8 | session | High | 26 | Complex, many pages |
| 9 | cash_transaction | High | 11 | Financial operations |
| 10 | sales_invoice | High | 40 | High usage |
| 11 | cash_ending | High | 41 | Financial reconciliation |
| 12 | attendance | High | 84 | Very complex |
| 13 | time_table_manage | High | 95+ | Largest module |

### 6.2 Per-Feature Migration Checklist

```markdown
## Feature: [feature_name] Migration

### Pre-Migration
- [ ] Document current widget usage (grep for all shared widgets)
- [ ] Take screenshots of all pages
- [ ] Create feature branch: `refactor/[feature_name]-widgets`
- [ ] Verify existing tests pass

### Widget Updates
- [ ] Replace deprecated TossButton → TossButton (unified)
- [ ] Replace TossButton1 → TossButton (unified)
- [ ] Replace TossCard → TossCard (if changed)
- [ ] Apply page templates where applicable
- [ ] Update all imports to new paths

### Post-Migration
- [ ] Run all tests
- [ ] Visual comparison with screenshots
- [ ] Test on iPhone SE (small screen)
- [ ] Test on iPad (large screen)
- [ ] Test light/dark mode
- [ ] Code review
- [ ] Merge to refactor branch
```

### 6.3 Example Migration: inventory_management

```dart
// BEFORE: inventory_management_page.dart
import 'package:myfinance/shared/widgets/toss/toss_button_1.dart';
import 'package:myfinance/shared/widgets/toss/toss_card.dart';
// ... 1000+ lines of mixed UI and logic

// AFTER: inventory_management_page.dart
import 'package:myfinance/shared/widgets/index.dart';

class InventoryManagementPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return TossListPage<Product>(
      title: 'Inventory',
      showSearch: true,
      onSearchChanged: (query) => ref.read(searchQueryProvider.notifier).state = query,
      filterChips: [
        TossChip(label: 'All', selected: true, onTap: () {}),
        TossChip(label: 'Low Stock', onTap: () {}),
        TossChip(label: 'Out of Stock', onTap: () {}),
      ],
      items: products,
      itemBuilder: (product, index) => ProductListTile(product: product),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/inventory/add'),
        child: const Icon(Icons.add),
      ),
      onRefresh: () => ref.refresh(productsProvider.future),
    );
  }
}
```

### 6.4 Deliverables Checklist

- [ ] Features 1-4 migrated (Low risk)
- [ ] Features 5-7 migrated (Medium risk)
- [ ] Features 8-10 migrated (High risk)
- [ ] Features 11-13 migrated (Complex)
- [ ] All tests passing
- [ ] No regressions reported

---

## Phase 7: Cleanup & Validation (Week 8)

### 7.1 Remove Deprecated Code

```bash
# Step 1: Verify no deprecated usages remain
grep -rn "@Deprecated" lib/shared/widgets/
grep -rn "TossButton1" lib/features/
grep -rn "toss_button_1.dart" lib/

# Step 2: Delete deprecated files (only if count = 0)
rm lib/shared/widgets/toss/toss_button_1.dart
rm lib/shared/widgets/toss/toss_primary_button.dart
rm lib/shared/widgets/toss/toss_secondary_button.dart

# Step 3: Update barrel exports
# Edit lib/shared/widgets/index.dart
```

### 7.2 Final File Structure

```
lib/shared/widgets/
├── index.dart                    # Main barrel export
│
├── atoms/                        # Smallest units
│   ├── index.dart
│   ├── buttons/
│   │   ├── toss_button.dart      # Unified button
│   │   └── toss_icon_button.dart
│   ├── inputs/
│   │   ├── toss_text_field.dart
│   │   ├── toss_search_field.dart
│   │   └── toss_quantity_input.dart
│   └── display/
│       ├── toss_badge.dart
│       ├── toss_chip.dart
│       └── toss_avatar.dart
│
├── molecules/                    # Combinations
│   ├── index.dart
│   ├── cards/
│   │   ├── toss_card.dart
│   │   └── toss_expandable_card.dart
│   ├── list_items/
│   │   └── toss_list_tile.dart
│   └── form_fields/
│       └── labeled_text_field.dart
│
├── organisms/                    # Complex components
│   ├── index.dart
│   ├── selectors/
│   │   ├── account_selector.dart
│   │   ├── counterparty_selector.dart
│   │   └── cash_location_selector.dart
│   ├── pickers/
│   │   ├── date_picker.dart
│   │   ├── time_picker.dart
│   │   └── calendar_picker.dart
│   └── dialogs/
│       ├── confirm_dialog.dart
│       ├── success_error_dialog.dart
│       └── info_dialog.dart
│
├── templates/                    # Page layouts
│   ├── index.dart
│   ├── toss_list_page.dart
│   ├── toss_detail_page.dart
│   └── toss_form_page.dart
│
└── common/                       # Utilities & scaffolds
    ├── toss_scaffold.dart
    ├── toss_app_bar.dart
    ├── toss_loading_view.dart
    ├── toss_empty_view.dart
    └── toss_error_view.dart
```

### 7.3 Final Validation Checklist

#### Code Quality
- [ ] `flutter analyze` passes with no errors
- [ ] `dart fix --apply` applied
- [ ] No deprecated widget usages remain
- [ ] All God Files under 500 lines
- [ ] All tests pass (unit + widget + integration)

#### Visual Quality
- [ ] Test on iPhone SE (375px width)
- [ ] Test on iPhone 15 Pro Max (430px width)
- [ ] Test on iPad (768px+ width)
- [ ] Test light mode
- [ ] Test dark mode
- [ ] Compare with original screenshots

#### Performance
- [ ] No jank in scrolling (60fps)
- [ ] Animations smooth
- [ ] No memory leaks (DevTools check)
- [ ] Build size not increased significantly

#### Documentation
- [ ] WIDGET_INVENTORY.md updated
- [ ] All deprecated items removed from docs
- [ ] CHANGELOG.md updated
- [ ] Design library updated with all widgets

### 7.4 Deliverables Checklist

- [ ] All deprecated files deleted
- [ ] Final folder structure applied
- [ ] Barrel exports updated
- [ ] All validations passed
- [ ] Documentation updated
- [ ] Merged to main branch

---

## Safety Guidelines

### Never Break These Rules

| Rule | Why |
|------|-----|
| Create branch before any change | Easy rollback |
| Never delete before deprecating | Gradual migration |
| One feature at a time | Isolate failures |
| Tests before refactoring | Catch regressions |
| Screenshot before/after | Visual regression |
| Commit after each widget | Granular history |
| Keep old imports working | Don't break builds |

### Rollback Procedure

```bash
# If something goes wrong:

# 1. Identify the last good commit
git log --oneline -20

# 2. Create a recovery branch
git checkout -b recovery/from-[commit-hash]

# 3. Reset to last good state
git reset --hard [good-commit-hash]

# 4. Force update if needed (with team communication!)
git push --force-with-lease
```

### Emergency Contacts

- Lead Developer: [Contact]
- Design System Owner: [Contact]
- QA Lead: [Contact]

---

## Success Metrics

### Quantitative Goals

| Metric | Current | Target | Measurement |
|--------|---------|--------|-------------|
| Widget files | 85 | 60 | File count |
| Duplicate widgets | 8 | 0 | Manual count |
| God Files (>500 lines) | 24 | 0 | wc -l analysis |
| Avg file size | ~300 lines | <250 lines | Analysis script |
| Test coverage | TBD% | +10% | Coverage tool |

### Qualitative Goals

- [ ] Developers can find widgets easily
- [ ] New pages use templates
- [ ] Design system is documented
- [ ] No hardcoded colors/spacing
- [ ] Consistent look and feel

---

## Appendix

### A. Widget Audit Script

```bash
#!/bin/bash
# scripts/audit_widgets.sh

echo "=== Widget Audit Report ===" > audit_report.md
echo "Generated: $(date)" >> audit_report.md
echo "" >> audit_report.md

# Count files by type
echo "## File Counts" >> audit_report.md
echo "" >> audit_report.md

atoms=$(find lib/shared/widgets/atoms -name "*.dart" 2>/dev/null | wc -l)
molecules=$(find lib/shared/widgets/molecules -name "*.dart" 2>/dev/null | wc -l)
organisms=$(find lib/shared/widgets/organisms -name "*.dart" 2>/dev/null | wc -l)
templates=$(find lib/shared/widgets/templates -name "*.dart" 2>/dev/null | wc -l)

echo "- Atoms: $atoms" >> audit_report.md
echo "- Molecules: $molecules" >> audit_report.md
echo "- Organisms: $organisms" >> audit_report.md
echo "- Templates: $templates" >> audit_report.md
echo "" >> audit_report.md

# Find large files
echo "## Large Files (>300 lines)" >> audit_report.md
find lib/shared/widgets -name "*.dart" -exec wc -l {} \; | awk '$1 > 300 {print "- " $2 ": " $1 " lines"}' >> audit_report.md

cat audit_report.md
```

### B. Migration Script Template

```bash
#!/bin/bash
# scripts/migrate_feature.sh

FEATURE=$1

if [ -z "$FEATURE" ]; then
  echo "Usage: ./migrate_feature.sh <feature_name>"
  exit 1
fi

echo "Migrating feature: $FEATURE"

# 1. Create branch
git checkout -b "refactor/$FEATURE-widgets"

# 2. Find all widget usages
echo "Widget usages in $FEATURE:"
grep -rln "TossButton\|TossCard\|TossChip" "lib/features/$FEATURE" --include="*.dart"

# 3. Run tests
echo "Running tests..."
flutter test "test/features/$FEATURE" --reporter expanded

echo "Migration prep complete. Manual updates needed."
```

### C. File Size Check Script

```bash
#!/bin/bash
# scripts/check_file_sizes.sh

MAX_LINES=500

echo "Files exceeding $MAX_LINES lines:"
find lib -name "*.dart" \
  ! -name "*.freezed.dart" \
  ! -name "*.g.dart" \
  -exec wc -l {} \; | awk -v max="$MAX_LINES" '$1 > max {print $2 ": " $1 " lines"}'
```

---

## Changelog

| Date | Version | Changes |
|------|---------|---------|
| 2025-12-26 | 1.0.0 | Initial plan created |

---

**Document Owner:** Development Team
**Last Updated:** 2025-12-26
**Next Review:** After Phase 1 completion
