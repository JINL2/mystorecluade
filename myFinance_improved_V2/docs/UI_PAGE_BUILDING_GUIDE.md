# MyFinance UI Page Building Guide

> A simple guide for building consistent pages in the MyFinance app.

## Reference Features

Use these 2 features as your main reference when building new pages:

| Feature | Path | Best For |
|---------|------|----------|
| **cash_ending** | `lib/features/cash_ending` | Tabbed pages, form inputs, denomination grids |
| **time_table_manage** | `lib/features/time_table_manage` | Complex state, multiple providers, list/detail patterns |

---

## 1. Folder Structure

When creating a new feature, use this exact structure:

```
lib/features/your_feature/
├── core/
│   └── constants.dart          # Feature constants & enums
├── data/
│   ├── datasources/            # API calls (Supabase)
│   ├── models/freezed/         # DTOs with JSON serialization
│   └── repositories/           # Repository implementations
├── domain/
│   ├── entities/               # Business objects (no JSON)
│   ├── repositories/           # Repository interfaces
│   └── usecases/               # Business logic
├── di/
│   └── injection.dart          # Riverpod providers
└── presentation/
    ├── pages/                  # Full screens
    ├── providers/              # State management
    └── widgets/                # UI components
```

---

## 2. Theme Tokens (MUST USE)

### Colors - The "Simple 4" Gray System
```dart
import 'package:myfinance_improved/shared/themes/index.dart';

// ============ THE 4 CORE GRAYS (Source of Truth) ============
TossColors.borderGray       // #F5F6F7 - BORDERS & DIVIDERS ONLY ⚠️
TossColors.lightGray        // #F1F3F5 - Backgrounds, fills, disabled
TossColors.darkGray         // #6B7785 - Secondary text, icons
TossColors.charcoal         // #212529 - Main text (primary)

// ============ LEGACY MAPPINGS (Use these in code) ============
// Backgrounds
TossColors.background       // White - PAGE background (default)
TossColors.surface          // White - cards, sheets, containers
TossColors.gray100          // ⚠️ BORDER ONLY - NOT for backgrounds!
TossColors.gray200          // #F1F3F5 - use ONLY for specific elements (disabled, fills)

// Text
TossColors.textPrimary      // #212529 Charcoal - main text
TossColors.textSecondary    // #6B7785 Dark gray - secondary text
TossColors.gray600          // #6B7785 Dark gray - icons, placeholders

// Primary colors
TossColors.primary          // Blue (#0A66FF) - CTAs, links
TossColors.error            // Red - errors, destructive
TossColors.success          // Green - success states

// Financial
TossColors.profit           // #064E3B Dark green - readable on white
TossColors.loss             // Red - readable on white
```

**⚠️ CRITICAL: Background Colors**
```dart
// Page background = WHITE (default, no need to set)
// Cards/containers on page = WHITE (TossColors.surface)

// ❌ WRONG - Don't use gray as common background
Container(color: TossColors.gray100)  // NO! Borders only
Container(color: TossColors.gray200)  // NO! Not for general backgrounds

// ✅ CORRECT - White backgrounds
Scaffold(backgroundColor: TossColors.background)  // White page
Container(color: TossColors.surface)              // White card/container

// Gray only for specific cases:
// - Disabled states
// - Input field fills
// - Skeleton loading
// - Dividers (gray100 for borders)
```

### Typography
```dart
// Headings
TossTextStyles.h1           // 28px bold - big numbers
TossTextStyles.h2           // 24px bold - page titles
TossTextStyles.h3           // 20px semibold - section titles
TossTextStyles.h4           // 18px semibold - card titles

// Body text
TossTextStyles.titleMedium  // 16px semibold - list item titles
TossTextStyles.body         // 14px regular - default text
TossTextStyles.caption      // 12px regular - secondary info
TossTextStyles.small        // 12px regular - labels

// Numbers (monospace)
TossTextStyles.amount       // 20px - currency amounts
TossTextStyles.amountLarge  // 24px - large amounts
TossTextStyles.amountSmall  // 14px - small amounts
```

### Spacing (4px grid)
```dart
TossSpacing.space1   // 4px  - tight
TossSpacing.space2   // 8px  - small gaps
TossSpacing.space3   // 12px - medium gaps
TossSpacing.space4   // 16px - default padding ⭐
TossSpacing.space5   // 20px - section spacing
TossSpacing.space6   // 24px - large spacing

// Semantic names
TossSpacing.paddingMD  // 16px - card padding
TossSpacing.paddingLG  // 20px - section padding
TossSpacing.paddingXL  // 24px - page padding
```

### Border Radius
```dart
TossBorderRadius.xs     // 4px  - small elements
TossBorderRadius.sm     // 6px  - chips, badges
TossBorderRadius.md     // 8px  - buttons, inputs
TossBorderRadius.lg     // 12px - cards, section bars
TossBorderRadius.xl     // 16px - most common ⭐ (modals, containers)
TossBorderRadius.xxl    // 20px - bottom sheets
TossBorderRadius.full   // 999px - circular
```

### Animations
```dart
TossAnimations.fast     // 150ms - button press, chip select
TossAnimations.normal   // 200ms - general transitions ⭐
TossAnimations.medium   // 250ms - page navigation, sheets

TossAnimations.standard // easeInOutCubic - default curve
TossAnimations.enter    // easeOutCubic - entrance
TossAnimations.exit     // easeInCubic - exit
```

---

## 3. Available Widgets

### Buttons
```dart
// Primary action (blue filled)
TossButton.primary(
  text: 'Save',
  onPressed: () {},
)

// Secondary action (gray filled)
TossButton.secondary(text: 'Cancel', onPressed: () {})

// Outlined button
TossButton.outlined(text: 'Edit', onPressed: () {})

// Destructive action (red)
TossButton.destructive(text: 'Delete', onPressed: () {})

// Text button (no background)
TossButton.textButton(text: 'Skip', onPressed: () {})

// Pill button (small, rounded)
TossButton.pill(text: 'Approve', onPressed: () {})

// With loading state
TossButton.primary(
  text: 'Save',
  isLoading: isSaving,
  onPressed: () {},
)
```

### Inputs
```dart
// Text field
TossTextField(
  label: 'Name',
  controller: _nameController,
  hintText: 'Enter name',
  errorText: hasError ? 'Required' : null,
)

// Search field
TossSearchField(
  controller: _searchController,
  hintText: 'Search products...',
  onChanged: (value) {},
)

// Quantity input (+/- buttons)
TossQuantityInput(
  value: quantity,
  onChanged: (newValue) {},
  min: 0,
  max: 100,
)
```

### Dropdowns & Selection (Bottom Sheet Pattern)
```dart
// Option 1: TriggerBottomSheetCommon - Complete trigger + sheet combo
TriggerBottomSheetCommon<String>(
  label: 'Store',
  value: selectedStoreId,
  items: stores.map((s) => SelectionItem(
    id: s.id,
    title: s.name,
  )).toList(),
  onChanged: (value) => setState(() => selectedStoreId = value),
)

// Option 2: TriggerBottomSheetCommon with custom builder
TriggerBottomSheetCommon<String>(
  label: 'Account',
  value: selectedAccountId,
  displayText: selectedAccount?.name,
  showSearch: true,
  itemCount: accounts.length,
  itemBuilder: (context, index, isSelected, onSelect) {
    final account = accounts[index];
    return AccountTile(
      account: account,
      isSelected: isSelected,
      onTap: () => onSelect(account.id),
    );
  },
  onChanged: (value) => setState(() => selectedAccountId = value),
)

// Option 3: Manual SelectionBottomSheetCommon (for custom triggers)
SelectionBottomSheetCommon.show(
  context: context,
  title: 'Select Location',
  showSearch: true,
  itemCount: locations.length,
  itemBuilder: (context, index) => SelectionListItem(
    item: SelectionItem(id: locations[index].id, title: locations[index].name),
    isSelected: locations[index].id == selectedId,
    onTap: () {
      setState(() => selectedId = locations[index].id);
      Navigator.pop(context);
    },
  ),
)
```

### Navigation
```dart
// App bar
TossAppBar(
  title: 'Page Title',
  actions: [
    TossButton.textButton(text: 'Save', onPressed: () {}),
  ],
)

// Tab bar (for page-level tabs with TabBarView)
TossTabBar(
  tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
  controller: _tabController,
)
```

### Section Tabs (In-Page Section Switching)
```dart
// TossSectionBar - For switching sections WITHIN a page
// Use this instead of building custom tab toggles

// Common style (full width, gray bg, white indicator)
TossSectionBar(
  tabs: ['P&L', 'B/S', 'Trend'],
  onTabChanged: (index) => setState(() => _selectedSection = index),
)

// Compact style (inline, smaller) - most common ⭐
TossSectionBar.compact(
  tabs: ['Store', 'Company'],
  initialIndex: 0,
  onTabChanged: (index) {},
)

// With TabBarView content
TossSectionBarView(
  tabs: ['Overview', 'Details', 'History'],
  children: [
    OverviewSection(),
    DetailsSection(),
    HistorySection(),
  ],
)
```

### Cards & Containers
```dart
// Basic card with tap
TossCard(
  onTap: () {},
  child: Column(...),
)

// Expandable card
TossExpandableCard(
  title: 'Section Title',
  initiallyExpanded: false,
  children: [...],
)

// Info card (display only)
InfoCard(
  title: 'Total',
  value: '100,000',
)
```

### Display Components
```dart
// Info row (label: value)
InfoRow(
  label: 'Customer',
  value: 'John Doe',
)

// Info row with change indicator
InfoRow.withChange(
  label: 'Balance',
  oldValue: '50,000',
  newValue: '75,000',
)

// Badge
TossBadge(
  text: 'New',
  color: TossColors.primary,
)

// Chip
TossChip(
  label: 'USD',
  selected: isSelected,
  onTap: () {},
)
```

### Feedback States
```dart
// Loading view (full page)
TossLoadingView()

// Loading view (inline)
TossLoadingView.inline()

// Empty state
TossEmptyView(
  message: 'No items found',
  icon: Icons.inbox_outlined,
)

// Error state
TossErrorView(
  message: 'Failed to load data',
  onRetry: () {},
)

// Skeleton loading
Skeletonizer(
  enabled: isLoading,
  child: YourWidget(),
)
```

### Dialogs & Sheets
```dart
// Confirm dialog
TossConfirmCancelDialog.show(
  context: context,
  title: 'Confirm Action',
  message: 'Are you sure?',
  onConfirm: () {},
)

// Delete confirmation
TossConfirmCancelDialog.delete(
  context: context,
  itemName: 'this item',
  onDelete: () {},
)

// Bottom sheet
TossBottomSheet.show(
  context: context,
  title: 'Select Option',
  child: YourContent(),
)

// Selection bottom sheet
SelectionBottomSheetCommon.show(
  context: context,
  title: 'Select Item',
  itemCount: items.length,
  itemBuilder: (context, index) => SelectionListItem(
    item: items[index],
    isSelected: items[index].id == selectedId,
    onTap: () {},
  ),
)
```

### Selectors (Autonomous - includes state management)
```dart
// Account selector
AccountSelector(
  companyId: companyId,
  selectedAccountId: selectedId,
  onAccountSelected: (account) {},
)

// Cash location selector
CashLocationSelector(
  companyId: companyId,
  storeId: storeId,
  locationType: LocationType.cash,
  onLocationSelected: (location) {},
)
```

---

## 4. Page Templates

### Basic Page Structure
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class MyFeaturePage extends ConsumerStatefulWidget {
  const MyFeaturePage({super.key});

  @override
  ConsumerState<MyFeaturePage> createState() => _MyFeaturePageState();
}

class _MyFeaturePageState extends ConsumerState<MyFeaturePage> {
  @override
  void initState() {
    super.initState();
    // Load initial data after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Load data via provider
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myFeatureProvider);

    return TossScaffold(
      appBar: TossAppBar(
        title: 'My Feature',
        actions: [
          TossButton.textButton(
            text: 'Save',
            onPressed: state.canSave ? _onSave : null,
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(MyFeatureState state) {
    // Loading state
    if (state.isLoading) {
      return const TossLoadingView();
    }

    // Error state
    if (state.hasError) {
      return TossErrorView(
        message: state.errorMessage,
        onRetry: _loadData,
      );
    }

    // Empty state
    if (state.items.isEmpty) {
      return const TossEmptyView(
        message: 'No items found',
      );
    }

    // Content
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection1(),
          const SizedBox(height: TossSpacing.space4),  // 16px between sections
          _buildSection2(),
        ],
      ),
    );
  }
}
```

### Page with Tabs
```dart
class MyTabbedPage extends ConsumerStatefulWidget {
  const MyTabbedPage({super.key});

  @override
  ConsumerState<MyTabbedPage> createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends ConsumerState<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: TossAppBar(
        title: 'My Feature',
        bottom: TossTabBar(
          tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tab1Widget(),
          Tab2Widget(),
          Tab3Widget(),
        ],
      ),
    );
  }
}
```

### List Page
```dart
Widget _buildList(List<Item> items) {
  return ListView.separated(
    padding: const EdgeInsets.all(TossSpacing.paddingMD),
    itemCount: items.length,
    separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space3),
    itemBuilder: (context, index) {
      final item = items[index];
      return TossCard(
        onTap: () => _onItemTap(item),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: TossTextStyles.titleMedium),
              const SizedBox(height: TossSpacing.space1),
              Text(item.subtitle, style: TossTextStyles.caption),
            ],
          ),
        ),
      );
    },
  );
}
```

### Detail Page
```dart
Widget _buildDetailContent(Item item) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(TossSpacing.paddingMD),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Text(item.title, style: TossTextStyles.h3),
        const SizedBox(height: TossSpacing.space4),  // 16px

        // Info section
        Container(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),  // 16px - most common
          ),
          child: Column(
            children: [
              InfoRow(label: 'Status', value: item.status),
              const Divider(height: TossSpacing.space4),
              InfoRow(label: 'Created', value: item.createdAt),
              const Divider(height: TossSpacing.space4),
              InfoRow(label: 'Amount', value: item.amount),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),  // 16px between sections

        // Action buttons
        TossButton.primary(
          text: 'Edit',
          onPressed: () {},
        ),
      ],
    ),
  );
}
```

---

## 5. State Management Pattern

### Provider Setup (di/injection.dart)
```dart
// DataSource
final myFeatureDataSourceProvider = Provider<MyFeatureDataSource>((ref) {
  return MyFeatureRemoteDataSource(ref.watch(supabaseClientProvider));
});

// Repository
final myFeatureRepositoryProvider = Provider<MyFeatureRepository>((ref) {
  return MyFeatureRepositoryImpl(ref.watch(myFeatureDataSourceProvider));
});

// UseCase
final getItemsUseCaseProvider = Provider<GetItemsUseCase>((ref) {
  return GetItemsUseCase(ref.watch(myFeatureRepositoryProvider));
});

// StateNotifier
final myFeatureProvider = StateNotifierProvider<MyFeatureNotifier, MyFeatureState>((ref) {
  return MyFeatureNotifier(
    getItemsUseCase: ref.watch(getItemsUseCaseProvider),
  );
});
```

### State Class (Freezed)
```dart
@freezed
class MyFeatureState with _$MyFeatureState {
  const factory MyFeatureState({
    @Default([]) List<Item> items,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? errorMessage,
    String? selectedItemId,
  }) = _MyFeatureState;

  const MyFeatureState._();

  // Computed getters
  bool get hasError => errorMessage != null;
  bool get canSave => !isLoading && !isSaving && items.isNotEmpty;
  Item? get selectedItem => items.firstWhereOrNull((i) => i.id == selectedItemId);
}
```

### Notifier Class
```dart
class MyFeatureNotifier extends StateNotifier<MyFeatureState> {
  final GetItemsUseCase _getItemsUseCase;

  MyFeatureNotifier({required GetItemsUseCase getItemsUseCase})
      : _getItemsUseCase = getItemsUseCase,
        super(const MyFeatureState());

  Future<void> loadItems(String companyId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final items = await _getItemsUseCase.execute(companyId);
      state = state.copyWith(isLoading: false, items: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectItem(String itemId) {
    state = state.copyWith(selectedItemId: itemId);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
```

---

## 6. Naming Conventions

### Files
| Type | Pattern | Example |
|------|---------|---------|
| Page | `feature_name_page.dart` | `cash_ending_page.dart` |
| Widget | `descriptive_name.dart` | `currency_selector.dart` |
| Provider | `feature_provider.dart` | `cash_ending_provider.dart` |
| State | `feature_state.dart` | `cash_ending_state.dart` |
| Notifier | `feature_notifier.dart` | `cash_ending_notifier.dart` |
| Entity | `entity_name.dart` | `cash_ending.dart` |
| DTO | `entity_dto.dart` | `cash_ending_dto.dart` |
| UseCase | `action_usecase.dart` | `save_cash_ending_usecase.dart` |

### Classes
| Type | Pattern | Example |
|------|---------|---------|
| Page | `FeatureNamePage` | `CashEndingPage` |
| State | `FeatureNameState` | `CashEndingState` |
| Notifier | `FeatureNameNotifier` | `CashEndingNotifier` |
| Entity | `EntityName` | `CashEnding` |
| DTO | `EntityNameDto` | `CashEndingDto` |
| UseCase | `ActionEntityUseCase` | `SaveCashEndingUseCase` |

### Variables
```dart
// IDs - use full word "Id"
userId, companyId, storeId, locationId

// Selected items
selectedStoreId, selectedCurrencyIds

// Loading states
isLoading, isLoadingItems, isSaving

// Lists
items, currencies, locations

// Callbacks
onPressed, onChanged, onSelected, onTap
```

---

## 7. Common Patterns

### Loading with Cached Data (Toss Style)
```dart
// Show cached data while loading new data
Widget build(BuildContext context) {
  final asyncData = ref.watch(dataProvider);

  return asyncData.when(
    data: (data) => _buildContent(data),
    loading: () => previousData != null
        ? Stack(
            children: [
              _buildContent(previousData!),
              const _ShimmerOverlay(),
            ],
          )
        : const TossLoadingView(),
    error: (e, _) => TossErrorView(message: e.toString()),
  );
}
```

### Pull to Refresh
```dart
TossRefreshIndicator(
  onRefresh: () => ref.read(myProvider.notifier).refresh(),
  child: ListView(...),
)
```

### Form Validation
```dart
// In state
bool get isFormValid =>
    name.isNotEmpty &&
    amount > 0 &&
    selectedLocationId != null;

// In button
TossButton.primary(
  text: 'Save',
  onPressed: state.isFormValid ? _onSave : null,
)
```

### Confirmation Before Action
```dart
Future<void> _onDelete() async {
  final confirmed = await TossConfirmCancelDialog.delete(
    context: context,
    itemName: 'this record',
  );

  if (confirmed == true) {
    await ref.read(myProvider.notifier).delete(itemId);
  }
}
```

### Toast Messages
```dart
// Success
TossToast.show(context, message: 'Saved successfully');

// Error
TossToast.show(context, message: 'Failed to save', isError: true);
```

---

## 8. Do's and Don'ts

### DO ✅
- Use theme tokens (TossColors, TossSpacing, etc.) for all styling
- Use shared widgets (TossButton, TossCard, etc.) instead of raw Flutter widgets
- Load data in `initState` with `addPostFrameCallback`
- Handle loading, error, and empty states
- Use Freezed for immutable state classes
- Use UseCases for business logic
- Keep widgets small and focused
- Use `TossSpacing.space4` (16px) between sections

### DON'T ❌
- Don't hardcode colors (use `TossColors.primary`, not `Color(0xFF0A66FF)`)
- Don't hardcode spacing (use `TossSpacing.space4`, not `16.0`)
- Don't use `setState` for complex state (use Riverpod)
- Don't put business logic in widgets
- Don't create new widget variants if one exists in shared/widgets
- Don't skip error handling
- Don't use `print()` for debugging (use logger)
- **Don't use `.copyWith()` on text styles, colors, or spacing** ⚠️

### ⚠️ CRITICAL: Do NOT Overwrite Theme Styles
```dart
// ❌ WRONG - Don't use copyWith to override theme styles
Text(
  'Title',
  style: TossTextStyles.titleMedium.copyWith(
    color: TossColors.textPrimary,  // Already set in theme!
    fontWeight: FontWeight.w600,     // Already set in theme!
  ),
)

// ✅ CORRECT - Use the style directly
Text('Title', style: TossTextStyles.titleMedium)

// ✅ CORRECT - If you need a different style, pick the right one
Text('Title', style: TossTextStyles.h3)        // For section titles
Text('Title', style: TossTextStyles.body)      // For body text
Text('Title', style: TossTextStyles.caption)   // For secondary text
```

### Section Spacing Rule
```dart
// ✅ CORRECT - Use space4 (16px) between sections
Column(
  children: [
    _buildSection1(),
    const SizedBox(height: TossSpacing.space4),  // 16px between sections
    _buildSection2(),
    const SizedBox(height: TossSpacing.space4),  // 16px between sections
    _buildSection3(),
  ],
)

// ❌ WRONG - Don't use space5 (20px) or inconsistent spacing
Column(
  children: [
    _buildSection1(),
    const SizedBox(height: TossSpacing.space5),  // Wrong!
    _buildSection2(),
    const SizedBox(height: 24),                   // Wrong! Hardcoded
    _buildSection3(),
  ],
)
```

### Style Rules
```dart
// ✅ CORRECT
Container(
  padding: const EdgeInsets.all(TossSpacing.paddingMD),
  decoration: BoxDecoration(
    color: TossColors.surface,
    borderRadius: BorderRadius.circular(TossBorderRadius.xl),  // 16px - most common
  ),
)

// ❌ WRONG
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## 9. Quick Reference Card

### Most Used Tokens
| Purpose | Token |
|---------|-------|
| Page padding | `TossSpacing.paddingMD` (16px) |
| Card padding | `TossSpacing.paddingMD` (16px) |
| Item spacing | `TossSpacing.space3` (12px) |
| **Section spacing** | `TossSpacing.space4` (16px) ⭐ |
| Container radius | `TossBorderRadius.xl` (16px) ⭐ most common |
| Card radius | `TossBorderRadius.lg` (12px) |
| Button radius | `TossBorderRadius.md` (8px) |
| Primary color | `TossColors.primary` |
| Page background | `TossColors.background` (white) |
| Card/Container bg | `TossColors.surface` (white) |
| Borders/Dividers | `TossColors.gray100` or `TossColors.borderGray` |
| Main text | `TossColors.textPrimary` (charcoal) |
| Secondary text | `TossColors.textSecondary` (darkGray) |
| Title style | `TossTextStyles.titleMedium` |
| Body style | `TossTextStyles.body` |
| Caption style | `TossTextStyles.caption` |

### Widget Checklist
Before creating a new widget, check if these exist:
- [ ] Button → `TossButton.*`
- [ ] Text field → `TossTextField`
- [ ] Dropdown/Select → `TriggerBottomSheetCommon` or `SelectionBottomSheetCommon`
- [ ] Section tabs → `TossSectionBar` or `TossSectionBar.compact`
- [ ] Card → `TossCard`
- [ ] Dialog → `TossConfirmCancelDialog`
- [ ] Bottom sheet → `TossBottomSheet`
- [ ] Loading → `TossLoadingView`
- [ ] Empty → `TossEmptyView`
- [ ] Error → `TossErrorView`

---

## 10. Example: Building a Simple List Page

```dart
// lib/features/my_list/presentation/pages/my_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../providers/my_list_provider.dart';

class MyListPage extends ConsumerStatefulWidget {
  const MyListPage({super.key});

  @override
  ConsumerState<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends ConsumerState<MyListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myListProvider.notifier).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myListProvider);

    return TossScaffold(
      appBar: TossAppBar(title: 'My List'),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(MyListState state) {
    if (state.isLoading) return const TossLoadingView();
    if (state.hasError) return TossErrorView(message: state.errorMessage!);
    if (state.items.isEmpty) return const TossEmptyView(message: 'No items');

    return TossRefreshIndicator(
      onRefresh: () => ref.read(myListProvider.notifier).loadItems(),
      child: ListView.separated(
        padding: const EdgeInsets.all(TossSpacing.paddingMD),
        itemCount: state.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space3),
        itemBuilder: (context, index) => _buildItem(state.items[index]),
      ),
    );
  }

  Widget _buildItem(Item item) {
    return TossCard(
      onTap: () => _onItemTap(item),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.paddingMD),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: TossTextStyles.titleMedium),
                  const SizedBox(height: TossSpacing.space1),
                  Text(item.subtitle, style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                  )),
                ],
              ),
            ),
            Text(item.amount, style: TossTextStyles.amount),
          ],
        ),
      ),
    );
  }

  void _onItemTap(Item item) {
    // Navigate to detail
  }
}
```

---

## 11. Reference Feature Patterns

### From `cash_ending` Feature

**Page Structure (Tabbed):**
```dart
class CashEndingPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<CashEndingPage> createState() => _CashEndingPageState();
}

class _CashEndingPageState extends ConsumerState<CashEndingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load data after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cashEndingProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar(
        title: 'Page Title',
        backgroundColor: TossColors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: TossTabBar(
            tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
            controller: _tabController,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tab1Widget(key: _tab1Key),
          Tab2Widget(key: _tab2Key),
          Tab3Widget(key: _tab3Key),
        ],
      ),
    );
  }
}
```

**Key Patterns:**
- GlobalKey for accessing child tab state
- Handler classes for save operations
- BaseTabNotifier for shared tab logic

### From `time_table_manage` Feature

**Data Loading (Parallel Refresh):**
```dart
void _forceRefreshAllData() {
  if (selectedStoreId == null) return;

  // 1. Invalidate all providers
  ref.invalidate(provider1(selectedStoreId!));
  ref.invalidate(provider2(selectedStoreId!));
  ref.invalidate(provider3(selectedStoreId!));

  // 2. Trigger FutureProviders
  ref.read(provider1(selectedStoreId!));
  ref.read(provider2(selectedStoreId!));

  // 3. Run StateNotifiers in parallel
  Future.wait([
    fetchData1(forceRefresh: true),
    fetchData2(forceRefresh: true),
    fetchData3(forceRefresh: true),
  ]);
}
```

**Smart Loading State:**
```dart
// Show skeleton only for initial load (no cached data)
final hasCachedData = state.dataByMonth.isNotEmpty;
final isInitialLoading = state.isLoading && !hasCachedData;

if (isInitialLoading) {
  return TossDetailSkeleton();
}

// Keep cached data visible during refresh
return _buildContent(state.data);
```

**Mixin Pattern for Complex Logic:**
```dart
class _MyPageState extends ConsumerState<MyPage>
    with DateHelpersMixin, ApprovalHandlerMixin {
  // Inherits helper methods from mixins
  // Keeps widget focused on UI
}
```

**UseCase Pattern:**
```dart
// Inject usecase via provider
final findCurrentItemUseCase = ref.watch(findCurrentItemUseCaseProvider);
final currentItem = findCurrentItemUseCase(allItems);
```

---

## 12. Summary Checklist

Before submitting a new page, verify:

- [ ] Follows folder structure (domain/data/presentation)
- [ ] Uses TossColors, TossSpacing, TossTextStyles (no hardcoded values)
- [ ] Uses TossBorderRadius.xl (16px) for containers
- [ ] Uses TossSpacing.space4 (16px) between sections
- [ ] Background is WHITE (TossColors.background/surface)
- [ ] No `.copyWith()` on theme styles
- [ ] Uses shared widgets (TossButton, TossCard, SelectionBottomSheetCommon, etc.)
- [ ] Loads data in initState with addPostFrameCallback
- [ ] Handles loading, error, and empty states
- [ ] Uses Riverpod + Freezed for state management
- [ ] Business logic in UseCases, not widgets

---

**Last Updated:** January 2025
**Reference Features:**
- `/lib/features/cash_ending` - Tabbed pages, form patterns
- `/lib/features/time_table_manage` - Complex state, list/detail patterns
