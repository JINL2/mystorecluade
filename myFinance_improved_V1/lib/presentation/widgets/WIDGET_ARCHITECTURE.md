# 🏗️ Widget Architecture - Design vs Business Logic

## 📁 Folder Structure

```
lib/presentation/widgets/
├── 🎨 toss/                         # DESIGN WIDGETS (Pure UI)
│   ├── toss_button.dart                   # ✅ Pure UI - buttons
│   ├── toss_text_field.dart               # ✅ Pure UI - inputs
│   ├── toss_dropdown.dart                 # ✅ Pure UI - generic dropdown
│   ├── toss_bottom_sheet.dart             # ✅ Pure UI - modals
│   ├── toss_card.dart                     # ✅ Pure UI - containers
│   ├── toss_checkbox.dart                 # ✅ Pure UI - form controls
│   ├── toss_chip.dart                     # ✅ Pure UI - chips
│   ├── toss_icon_button.dart              # ✅ Pure UI - icon buttons
│   ├── toss_list_tile.dart                # ✅ Pure UI - list items
│   ├── toss_loading_overlay.dart          # ✅ Pure UI - loading states
│   ├── toss_multi_select_dropdown.dart    # ✅ Pure UI - generic multi-select
│   ├── toss_primary_button.dart           # ✅ Pure UI - primary button
│   ├── toss_refresh_indicator.dart        # ✅ Pure UI - refresh control
│   ├── toss_search_field.dart             # ✅ Pure UI - search input
│   ├── toss_secondary_button.dart         # ✅ Pure UI - secondary button
│   └── toss_text_field.dart               # ✅ Pure UI - text input
│
├── 🔧 specific/selectors/           # BUSINESS LOGIC WIDGETS  
│   ├── toss_account_selector.dart         # 🔌 RPC: get_accounts
│   ├── toss_account_multi_selector.dart   # 🔌 RPC: get_accounts
│   ├── toss_cash_location_selector.dart   # 🔌 RPC: get_cash_locations
│   ├── toss_counter_party_selector.dart   # 🔌 RPC: get_counterparties
│   └── toss_entity_selector.dart          # 🔌 RPC: Base selector logic
│
└── 🔄 common/                       # SHARED UTILITIES
    ├── feature_grid_item.dart             # App-specific components
    ├── toss_app_bar.dart                  # App navigation
    ├── toss_empty_view.dart               # Empty states
    ├── toss_error_view.dart               # Error states
    ├── toss_loading_view.dart             # Loading states
    └── toss_scaffold.dart                 # App layout
```

## 🎯 Widget Classification Rules

### ✅ Design Widgets (`/toss/`)
**Characteristics:**
- 🎨 **Pure UI**: No business logic, no RPC calls
- ♻️ **Reusable**: Can be used in any Flutter project
- 📦 **Data Props**: Take data as parameters
- 🚫 **No State Management**: No Riverpod providers
- 🧪 **Easy Testing**: UI-only testing

**Examples:**
```dart
// ✅ Design Widget
TossButton(
  text: 'Save',
  onPressed: () => save(),
)

// ✅ Design Widget  
TossDropdown<String>(
  items: ['Option 1', 'Option 2'],
  onChanged: (value) => handleChange(value),
)
```

### 🔧 Business Logic Widgets (`/specific/selectors/`)
**Characteristics:**
- 🔌 **RPC Calls**: Direct Supabase function calls
- 🗄️ **State Management**: Use Riverpod providers
- 🏢 **Domain-Specific**: myFinance business logic
- 📞 **Callbacks**: Return data via callbacks
- 🧩 **Complex Logic**: Filtering, caching, error handling

**Examples:**
```dart
// 🔧 Business Logic Widget
TossAccountSelector(
  selectedValues: accountIds,
  onChanged: (List<String>? ids) {
    // Handle account selection
    updateFilter(accountIds: ids);
  },
)

// 🔧 Business Logic Widget
TossCashLocationSelector(
  selectedValue: locationId,
  scope: TransactionScope.store,
  onChanged: (String? id) {
    // Handle location selection
    updateFilter(cashLocationId: id);
  },
)
```

## 🔄 Migration Benefits

### Before (❌ Mixed Architecture)
```dart
// ❌ Business logic mixed with UI in /toss/ folder
toss/toss_cash_location_selector_enhanced.dart
// - Hard to reuse
// - Tight coupling  
// - Complex testing
```

### After (✅ Separated Architecture)
```dart
// ✅ Pure UI design component
toss/toss_base_selector.dart

// ✅ Business logic component
specific/selectors/toss_cash_location_selector.dart
// - Easy to reuse
// - Clear separation
// - Simple testing
```

## 🎨 Design System Philosophy

### Toss Design System = Universal Components
- Can be extracted to separate package
- Used across multiple projects  
- No domain-specific logic
- Pure Flutter/UI components

### myFinance Selectors = App-Specific Components
- Contain business rules
- Use myFinance database
- Handle app-specific workflows
- Integrate with app state management

## 🔌 RPC Integration Pattern

Each business logic widget follows this pattern:

```dart
// 1. Dedicated RPC function
get_accounts(p_company_id UUID, p_store_id UUID)

// 2. Riverpod provider
@riverpod
Future<List<AccountData>> currentAccounts(ref) async {
  return ref.watch(accountListProvider(companyId, storeId).future);
}

// 3. Widget with callback
TossAccountSelector(
  onChanged: (List<String>? accountIds) {
    // Send data back to parent
  },
)
```

## 🧪 Testing Strategy

### Design Widgets
```dart
testWidgets('TossButton shows text and handles tap', (tester) async {
  bool tapped = false;
  await tester.pumpWidget(
    TossButton(text: 'Test', onPressed: () => tapped = true)
  );
  
  expect(find.text('Test'), findsOneWidget);
  await tester.tap(find.byType(TossButton));
  expect(tapped, isTrue);
});
```

### Business Logic Widgets  
```dart
testWidgets('TossAccountSelector loads accounts', (tester) async {
  // Mock RPC response
  when(mockSupabase.rpc('get_accounts')).thenReturn([...]);
  
  await tester.pumpWidget(
    ProviderScope(child: TossAccountSelector())
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  await tester.pumpAndSettle();
  expect(find.text('Account 1'), findsOneWidget);
});
```

## 🚀 Next Steps

1. **✅ Completed**: Reorganized widgets into proper folders
2. **🔄 In Progress**: Create dedicated RPC functions  
3. **📋 Planned**: Implement Riverpod providers
4. **📋 Planned**: Update components to use new architecture
5. **📋 Planned**: Test autonomous functionality