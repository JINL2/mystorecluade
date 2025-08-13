# 🎯 Feature Example: Complete Transaction Feature

This example shows all files needed to implement a complete "Transaction" feature following our architecture.

## 📁 Complete File Structure for Transaction Feature

```
myFinance_improved/
├── lib/
│   ├── domain/                          # Business Logic Layer
│   │   ├── entities/
│   │   │   └── transaction.dart         # Transaction entity
│   │   ├── repositories/
│   │   │   └── transaction_repository.dart  # Repository interface
│   │   └── usecases/
│   │       └── transaction/
│   │           ├── get_transactions_usecase.dart
│   │           ├── create_transaction_usecase.dart
│   │           ├── update_transaction_usecase.dart
│   │           └── delete_transaction_usecase.dart
│   │
│   ├── data/                            # Data Layer
│   │   ├── models/
│   │   │   └── transaction_model.dart   # API model with JSON
│   │   ├── datasources/
│   │   │   └── remote/
│   │   │       └── transaction_api.dart # API endpoints
│   │   └── repositories/
│   │       └── transaction_repository_impl.dart  # Implementation
│   │
│   └── presentation/                    # UI Layer
│       ├── providers/
│       │   └── transaction_provider.dart # All transaction state
│       ├── pages/
│       │   └── transaction/
│       │       ├── transaction_history_page.dart
│       │       ├── transaction_detail_page.dart
│       │       ├── transaction_create_page.dart
│       │       └── transaction_filter_sheet.dart
│       └── widgets/
│           └── specific/
│               ├── transaction_list_item.dart
│               ├── transaction_summary_card.dart
│               ├── transaction_filter_chip.dart
│               └── transaction_amount_input.dart
```

## 📄 File Contents Overview

### 1️⃣ Domain Layer (Business Logic)

#### Entity
```dart
// lib/domain/entities/transaction.dart
class Transaction {
  final String id;
  final double amount;
  final String description;
  final String category;
  final DateTime date;
  final TransactionType type;
  final String? attachmentUrl;
  final Map<String, dynamic>? metadata;
  
  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    required this.type,
    this.attachmentUrl,
    this.metadata,
  });
}

enum TransactionType { income, expense, transfer }
```

#### Repository Interface
```dart
// lib/domain/repositories/transaction_repository.dart
abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  });
  
  Future<Transaction> getTransactionById(String id);
  
  Future<Transaction> createTransaction(Transaction transaction);
  
  Future<Transaction> updateTransaction(Transaction transaction);
  
  Future<void> deleteTransaction(String id);
  
  Stream<List<Transaction>> watchTransactions();
}
```

### 2️⃣ Data Layer (API/Database)

#### API Model
```dart
// lib/data/models/transaction_model.dart
@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required double amount,
    required String description,
    required String category,
    required DateTime date,
    required String type,
    String? attachmentUrl,
    Map<String, dynamic>? metadata,
  }) = _TransactionModel;
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  
  // Convert to domain entity
  Transaction toEntity() => Transaction(
    id: id,
    amount: amount,
    description: description,
    category: category,
    date: date,
    type: TransactionType.values.firstWhere((e) => e.name == type),
    attachmentUrl: attachmentUrl,
    metadata: metadata,
  );
  
  // Create from domain entity
  factory TransactionModel.fromEntity(Transaction entity) => TransactionModel(
    id: entity.id,
    amount: entity.amount,
    description: entity.description,
    category: entity.category,
    date: entity.date,
    type: entity.type.name,
    attachmentUrl: entity.attachmentUrl,
    metadata: entity.metadata,
  );
}
```

### 3️⃣ Presentation Layer (UI)

#### State Management
```dart
// lib/presentation/providers/transaction_provider.dart

// Main transaction list
@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<Transaction>> build() async {
    final repository = ref.watch(transactionRepositoryProvider);
    return repository.getTransactions();
  }
  
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
  
  Future<void> createTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.createTransaction(transaction);
      return repository.getTransactions();
    });
  }
}

// Filter state
@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  TransactionFilterData build() => const TransactionFilterData();
  
  void updateDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }
  
  void updateType(TransactionType? type) {
    state = state.copyWith(type: type);
  }
  
  void updateCategory(String? category) {
    state = state.copyWith(category: category);
  }
  
  void clearFilters() {
    state = const TransactionFilterData();
  }
}

@freezed
class TransactionFilterData with _$TransactionFilterData {
  const factory TransactionFilterData({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? category,
  }) = _TransactionFilterData;
}

// Search state
@riverpod
class TransactionSearch extends _$TransactionSearch {
  @override
  String build() => '';
  
  void updateQuery(String query) => state = query;
}

// Computed: Filtered and searched transactions
@riverpod
List<Transaction> filteredTransactions(FilteredTransactionsRef ref) {
  final transactions = ref.watch(transactionListProvider).valueOrNull ?? [];
  final filter = ref.watch(transactionFilterProvider);
  final searchQuery = ref.watch(transactionSearchProvider);
  
  return transactions.where((transaction) {
    // Apply date filter
    if (filter.startDate != null && transaction.date.isBefore(filter.startDate!)) {
      return false;
    }
    if (filter.endDate != null && transaction.date.isAfter(filter.endDate!)) {
      return false;
    }
    
    // Apply type filter
    if (filter.type != null && transaction.type != filter.type) {
      return false;
    }
    
    // Apply category filter
    if (filter.category != null && transaction.category != filter.category) {
      return false;
    }
    
    // Apply search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      return transaction.description.toLowerCase().contains(query) ||
             transaction.category.toLowerCase().contains(query);
    }
    
    return true;
  }).toList();
}

// Statistics
@riverpod
TransactionStatistics transactionStatistics(TransactionStatisticsRef ref) {
  final transactions = ref.watch(filteredTransactionsProvider);
  
  double totalIncome = 0;
  double totalExpense = 0;
  
  for (final transaction in transactions) {
    if (transaction.type == TransactionType.income) {
      totalIncome += transaction.amount;
    } else if (transaction.type == TransactionType.expense) {
      totalExpense += transaction.amount;
    }
  }
  
  return TransactionStatistics(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    balance: totalIncome - totalExpense,
    transactionCount: transactions.length,
  );
}

// Single transaction detail
@riverpod
Future<Transaction?> transactionDetail(
  TransactionDetailRef ref,
  String transactionId,
) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactionById(transactionId);
}
```

## 🔄 State Flow Diagram

```
┌─────────────────┐
│   User Action   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Page Widget    │ ◄──── Watches providers
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ State Provider  │ ◄──── Manages state
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Use Case      │ ◄──── Business logic
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Repository     │ ◄──── Data operations
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   API/Database  │ ◄──── External data
└─────────────────┘
```

## 📱 Page Implementation Pattern

```dart
// lib/presentation/pages/transaction/transaction_history_page.dart
class TransactionHistoryPage extends ConsumerWidget {
  const TransactionHistoryPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state
    final transactionsAsync = ref.watch(transactionListProvider);
    final statistics = ref.watch(transactionStatisticsProvider);
    
    return Scaffold(
      appBar: _buildAppBar(context, ref),
      body: Column(
        children: [
          // Summary card
          TransactionSummaryCard(statistics: statistics),
          
          // Filter chips
          _buildFilterChips(context, ref),
          
          // Transaction list
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) => _buildList(context, ref, transactions),
              loading: () => const AppLoading(),
              error: (error, stack) => AppError(
                message: error.toString(),
                onRetry: () => ref.refresh(transactionListProvider),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: TossFloatingActionButton(
        icon: Icons.add,
        onPressed: () => _navigateToCreate(context),
      ),
    );
  }
}
```

## 🧩 Widget Organization

### Common Widgets (Reusable across features)
```
widgets/common/
├── app_loading.dart        # Generic loading state
├── app_error.dart          # Generic error state
├── app_empty.dart          # Generic empty state
├── app_scaffold.dart       # Common scaffold setup
└── app_refresh_indicator.dart
```

### Toss Components (Design system)
```
widgets/toss/
├── toss_button.dart        # All button variants
├── toss_card.dart          # Card with animations
├── toss_input.dart         # Text input variants
├── toss_bottom_sheet.dart  # Bottom sheet component
└── toss_chip.dart          # Chip component
```

### Feature-Specific Widgets
```
widgets/specific/
├── transaction_list_item.dart    # List item widget
├── transaction_summary_card.dart # Summary statistics
├── transaction_filter_chip.dart  # Filter UI
├── transaction_amount_input.dart # Amount input
└── transaction_category_selector.dart
```

## ✅ Feature Implementation Checklist

- [ ] **Domain Layer**
  - [ ] Define entity with all properties
  - [ ] Create repository interface
  - [ ] Implement use cases for each operation

- [ ] **Data Layer**
  - [ ] Create model with JSON serialization
  - [ ] Implement API client
  - [ ] Implement repository
  - [ ] Handle error cases

- [ ] **Presentation Layer**
  - [ ] Create state providers
  - [ ] Implement list page
  - [ ] Implement detail page
  - [ ] Implement create/edit page
  - [ ] Create specific widgets
  - [ ] Add routes

- [ ] **Testing**
  - [ ] Unit tests for providers
  - [ ] Unit tests for use cases
  - [ ] Widget tests for pages
  - [ ] Integration tests

- [ ] **Documentation**
  - [ ] API documentation
  - [ ] State flow documentation
  - [ ] Component documentation

## 🎨 UI/UX Patterns

### List Page Features
1. Pull-to-refresh
2. Infinite scroll (pagination)
3. Search bar
4. Filter options
5. Sort options
6. Empty state
7. Error state
8. Loading state

### Detail Page Features
1. Hero animation from list
2. Action buttons
3. Related information
4. Share functionality
5. Edit/Delete options

### Form Page Features
1. Input validation
2. Error messages
3. Loading state during submission
4. Success feedback
5. Unsaved changes warning

---

Use this as a template when implementing new features! 🚀