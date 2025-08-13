# 📄 Page Setup Guide

A step-by-step guide for creating new pages and features in the MyFinance app, following our Toss-style architecture.

## 🎯 Quick Reference

When creating a new feature/page, here's where files go:

```
Feature: Transaction History
├── 📂 domain/entities/          → transaction.dart (Business entity)
├── 📂 data/models/              → transaction_model.dart (API model)
├── 📂 presentation/providers/   → transaction_provider.dart (State)
├── 📂 presentation/pages/       → transaction_history_page.dart (Screen)
└── 📂 presentation/widgets/     → transaction specific widgets
    ├── 📂 toss/                → Reusable Toss components
    └── 📂 specific/             → Feature-specific widgets
```

## 📚 Complete Page Creation Workflow

### Step 1: Plan Your Feature

Before creating files, answer these questions:
- What data does this page need? (entities)
- Where does the data come from? (API/local)
- What state needs to be managed? (providers)
- What UI components are needed? (widgets)

### Step 2: Create Domain Entity (if needed)

**Location**: `lib/domain/entities/`

```dart
// lib/domain/entities/transaction.dart
class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;
  
  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
  });
}

enum TransactionType { income, expense, transfer }
```

### Step 3: Create Data Model (if fetching from API)

**Location**: `lib/data/models/`

```dart
// lib/data/models/transaction_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required double amount,
    required String description,
    required DateTime date,
    required String type,
  }) = _TransactionModel;
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  
  // Convert to domain entity
  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      description: description,
      date: date,
      type: TransactionType.values.firstWhere((e) => e.name == type),
    );
  }
}
```

### Step 4: Create State Provider

**Location**: `lib/presentation/providers/`

```dart
// lib/presentation/providers/transaction_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction.dart';

// Page-specific state
@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<Transaction>> build() async {
    // Fetch transactions from repository
    final repository = ref.watch(transactionRepositoryProvider);
    return repository.getTransactions();
  }
  
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
  
  Future<void> addTransaction(Transaction transaction) async {
    final repository = ref.read(transactionRepositoryProvider);
    await repository.createTransaction(transaction);
    ref.invalidateSelf();
  }
}

// Filter state for this page
@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  TransactionFilterState build() => TransactionFilterState.all;
}

enum TransactionFilterState { all, income, expense }

// Search query state
@riverpod
class TransactionSearchQuery extends _$TransactionSearchQuery {
  @override
  String build() => '';
  
  void updateQuery(String query) => state = query;
}

// Computed provider for filtered transactions
@riverpod
List<Transaction> filteredTransactions(FilteredTransactionsRef ref) {
  final transactions = ref.watch(transactionListProvider).valueOrNull ?? [];
  final filter = ref.watch(transactionFilterProvider);
  final searchQuery = ref.watch(transactionSearchQueryProvider);
  
  return transactions.where((transaction) {
    // Apply filter
    if (filter != TransactionFilterState.all) {
      final filterType = filter == TransactionFilterState.income 
          ? TransactionType.income 
          : TransactionType.expense;
      if (transaction.type != filterType) return false;
    }
    
    // Apply search
    if (searchQuery.isNotEmpty) {
      return transaction.description
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }
    
    return true;
  }).toList();
}
```

### Step 5: Create the Page

**Location**: `lib/presentation/pages/transaction/`

```dart
// lib/presentation/pages/transaction/transaction_history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/specific/transaction_list_item.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/app_error.dart';

class TransactionHistoryPage extends ConsumerWidget {
  const TransactionHistoryPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) => _buildTransactionList(transactions),
        loading: () => const AppLoading(),
        error: (error, stack) => AppError(
          message: error.toString(),
          onRetry: () => ref.refresh(transactionListProvider),
        ),
      ),
    );
  }
  
  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return _buildEmptyState();
    }
    
    return RefreshIndicator(
      onRefresh: () => ref.read(transactionListProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(TossSpacing.space5),
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space3),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionListItem(
            transaction: transaction,
            onTap: () => _navigateToDetail(context, transaction),
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: TossColors.gray300,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'No transactions yet',
            style: TossTextStyles.h3,
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Your transactions will appear here',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    // Show filter bottom sheet
  }
  
  void _navigateToDetail(BuildContext context, Transaction transaction) {
    // Navigate to detail page
  }
}
```

### Step 6: Create Feature-Specific Widgets

**Location**: `lib/presentation/widgets/specific/`

```dart
// lib/presentation/widgets/specific/transaction_list_item.dart
import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../domain/entities/transaction.dart';
import '../toss/toss_card.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  
  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? TossColors.profit : TossColors.gray900;
    final amountSign = isIncome ? '+' : '-';
    
    return TossCard(
      onTap: onTap,
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForType(transaction.type),
              size: 24,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  _formatDate(transaction.date),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          
          // Amount
          Text(
            '$amountSign\$${transaction.amount.toStringAsFixed(2)}',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Icons.arrow_downward;
      case TransactionType.expense:
        return Icons.arrow_upward;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }
  
  String _formatDate(DateTime date) {
    // Format date logic
    return '${date.day}/${date.month}';
  }
}
```

### Step 7: Add Route

**Location**: `lib/presentation/app/app_router.dart`

```dart
// Add to your routes
GoRoute(
  path: '/transactions',
  name: 'transactions',
  builder: (context, state) => const TransactionHistoryPage(),
  routes: [
    GoRoute(
      path: ':id',
      name: 'transaction-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TransactionDetailPage(transactionId: id);
      },
    ),
  ],
),
```

## 📁 File Organization Rules

### 1. Pages (`presentation/pages/`)
```
pages/
├── auth/                   # Authentication pages
│   ├── login_page.dart
│   └── register_page.dart
├── transaction/            # Transaction feature
│   ├── transaction_history_page.dart
│   ├── transaction_detail_page.dart
│   └── transaction_create_page.dart
└── home/                   # Home feature
    └── home_page.dart
```

### 2. Widgets (`presentation/widgets/`)
```
widgets/
├── common/                 # Shared across features
│   ├── app_loading.dart   # Generic loading
│   ├── app_error.dart     # Generic error
│   └── app_empty.dart     # Generic empty state
├── toss/                   # Toss design system
│   ├── toss_button.dart
│   ├── toss_card.dart
│   └── toss_input.dart
└── specific/               # Feature-specific
    ├── transaction_list_item.dart
    ├── transaction_filter.dart
    └── balance_card.dart
```

### 3. State Management (`presentation/providers/`)
```
providers/
├── app_provider.dart       # Global app state
├── auth_provider.dart      # Authentication state
├── theme_provider.dart     # Theme state
└── transaction_provider.dart # Feature state
```

### 4. Common Components Location Guide

| Component Type | Location | Example |
|----------------|----------|---------|
| **Toss Components** | `widgets/toss/` | TossButton, TossCard |
| **Loading States** | `widgets/common/` | AppLoading, Shimmer |
| **Error States** | `widgets/common/` | AppError, ErrorBoundary |
| **Empty States** | `widgets/common/` | AppEmpty, NoData |
| **Form Components** | `widgets/common/` | AppTextField, AppDropdown |
| **Feature Widgets** | `widgets/specific/` | TransactionItem, UserAvatar |
| **Layout Components** | `widgets/common/` | AppScaffold, AppDrawer |

## 🔄 State Management Patterns

### Global State (App-wide)
```dart
// lib/presentation/providers/app_provider.dart
@riverpod
class AppState extends _$AppState {
  @override
  AppStateData build() => AppStateData();
}

// Examples:
// - Current user
// - Selected company
// - App settings
// - Theme preferences
```

### Feature State (Page-specific)
```dart
// lib/presentation/providers/[feature]_provider.dart
@riverpod
class FeatureState extends _$FeatureState {
  @override
  FeatureData build() => FeatureData();
}

// Examples:
// - Transaction list
// - Filter settings
// - Search queries
// - Pagination state
```

### Computed State
```dart
// Derived from other states
@riverpod
ComputedData computedState(ComputedStateRef ref) {
  final state1 = ref.watch(provider1);
  final state2 = ref.watch(provider2);
  
  return ComputedData(
    // Compute from state1 and state2
  );
}
```

## ✅ Page Creation Checklist

When creating a new page, ensure you:

- [ ] **Domain Layer**
  - [ ] Create entity if needed
  - [ ] Define repository interface
  - [ ] Create use cases

- [ ] **Data Layer**
  - [ ] Create model for API
  - [ ] Implement repository
  - [ ] Add API endpoints

- [ ] **Presentation Layer**
  - [ ] Create page widget
  - [ ] Create state provider
  - [ ] Create specific widgets
  - [ ] Add route to router

- [ ] **Testing**
  - [ ] Unit tests for providers
  - [ ] Widget tests for page
  - [ ] Integration tests for flow

- [ ] **Documentation**
  - [ ] Add inline documentation
  - [ ] Update component docs
  - [ ] Add to navigation

## 🎯 Common Patterns

### 1. List Page Pattern
```dart
class FeatureListPage extends ConsumerWidget {
  // 1. Watch filtered/sorted data
  // 2. Show loading/error/empty states
  // 3. Implement pull-to-refresh
  // 4. Add search/filter
  // 5. Navigate to detail
}
```

### 2. Detail Page Pattern
```dart
class FeatureDetailPage extends ConsumerWidget {
  // 1. Fetch single item by ID
  // 2. Show loading state
  // 3. Display item details
  // 4. Add actions (edit, delete)
  // 5. Handle errors
}
```

### 3. Form Page Pattern
```dart
class FeatureFormPage extends ConsumerStatefulWidget {
  // 1. Create form key
  // 2. Add text controllers
  // 3. Implement validation
  // 4. Handle submission
  // 5. Show success/error
}
```

## 💡 Best Practices

1. **Keep Pages Simple**: Pages should only orchestrate, not contain business logic
2. **Reuse Components**: Check `widgets/toss/` before creating new components
3. **State in Providers**: All state management in providers, not in widgets
4. **Type Safety**: Use proper types, avoid `dynamic`
5. **Error Handling**: Always handle loading, error, and empty states
6. **Accessibility**: Include semantic labels and proper contrast
7. **Performance**: Use `const` constructors where possible

## 🚫 Common Mistakes to Avoid

1. ❌ Putting business logic in widgets
2. ❌ Creating duplicate components
3. ❌ Managing state in StatefulWidget when provider would be better
4. ❌ Forgetting error states
5. ❌ Hard-coding strings (use constants)
6. ❌ Ignoring null safety
7. ❌ Not following naming conventions

## 📝 Naming Conventions

### Files
- **Pages**: `feature_action_page.dart` (e.g., `transaction_history_page.dart`)
- **Widgets**: `descriptive_name_widget.dart` (e.g., `transaction_list_item.dart`)
- **Providers**: `feature_provider.dart` (e.g., `transaction_provider.dart`)
- **Models**: `entity_model.dart` (e.g., `transaction_model.dart`)

### Classes
- **Pages**: `FeatureActionPage` (e.g., `TransactionHistoryPage`)
- **Widgets**: `DescriptiveName` (e.g., `TransactionListItem`)
- **Providers**: `FeatureState` (e.g., `TransactionListState`)
- **Models**: `EntityModel` (e.g., `TransactionModel`)

---

Ready to create your first page? Start with Step 1 and work through the checklist! 🚀