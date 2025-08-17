# Business Logic Widgets - Selectors

This folder contains widgets that handle **business logic** and **RPC calls**.

## 📁 Folder Structure

```
widgets/
├── toss/                    # 🎨 DESIGN WIDGETS (Pure UI)
│   ├── toss_button.dart           # Button components
│   ├── toss_text_field.dart       # Input components  
│   ├── toss_dropdown.dart         # Generic dropdown
│   ├── toss_bottom_sheet.dart     # Modal containers
│   └── ...                       # Other pure UI components
│
├── specific/selectors/      # 🔧 BUSINESS LOGIC WIDGETS
│   ├── toss_account_selector.dart      # Accounts RPC + UI
│   ├── toss_cash_location_selector.dart # Cash locations RPC + UI
│   ├── toss_counterparty_selector.dart # Counterparties RPC + UI
│   └── ...                            # Other data-driven selectors
│
└── common/                  # 🔄 SHARED UTILITIES
    ├── toss_app_bar.dart          # App-specific components
    └── ...                       # Other shared components
```

## 🎯 Widget Classification

### Design Widgets (`/toss/`)
- **Purpose**: Pure UI components, no business logic
- **Characteristics**: 
  - No RPC calls
  - No data fetching
  - Reusable across any project
  - Take data as props
- **Examples**: Buttons, text fields, modals, cards

### Business Logic Widgets (`/specific/selectors/`)
- **Purpose**: Domain-specific components with data management
- **Characteristics**:
  - Make RPC calls to Supabase
  - Use Riverpod for state management
  - myFinance-specific business logic
  - Return data via callbacks
- **Examples**: Account selectors, cash location selectors, counterparty selectors

## 🚀 Autonomous Selector Components

The new autonomous selectors are truly reusable and independent:

### `autonomous_account_selector.dart`
- **Single**: `AutonomousAccountSelector` 
- **Multi**: `AutonomousMultiAccountSelector`
- **Features**: Account type filtering (asset, liability, income, expense, equity)
- **RPC**: Uses `get_accounts` function via `currentAccountsProvider`

### `autonomous_cash_location_selector.dart`
- **Single**: `AutonomousCashLocationSelector`
- **Features**: Company/Store scope tabs, location type filtering
- **RPC**: Uses `get_cash_locations` function via `currentCashLocationsProvider`

### `autonomous_counterparty_selector.dart`
- **Single**: `AutonomousCounterpartySelector`
- **Multi**: `AutonomousMultiCounterpartySelector`
- **Features**: Type filtering (customer, vendor, supplier), internal/external filtering
- **RPC**: Uses `get_counterparties` function via `currentCounterpartiesProvider`

### Base Components
- **`toss_base_selector.dart`**: Reusable UI components (`TossSingleSelector`, `TossMultiSelector`)
- **`autonomous_selector_examples.dart`**: Usage examples and demos

## 🔄 Migration Pattern

**Before** (Mixed approach):
```dart
// ❌ toss/toss_cash_location_selector.dart
// Business logic mixed with design
```

**After** (Separated approach):
```dart
// ✅ specific/selectors/toss_cash_location_selector.dart
// Business logic + RPC calls

// ✅ toss/toss_base_selector.dart  
// Pure UI component for any selector
```

## 🎨 Design System Philosophy

**Toss Design System** = Pure UI components that can be used in any app
**myFinance Selectors** = Business logic components specific to our finance app

This separation ensures:
- ♻️ **Reusability**: Design components work in any project
- 🧪 **Testability**: Business logic can be tested independently  
- 🔧 **Maintainability**: Clear separation of concerns
- 📦 **Modularity**: Can extract Toss design system to separate package