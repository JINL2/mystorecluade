# Transaction History Page Design

## Purpose
The Transaction History page allows users to view, search, filter, and analyze all financial transactions across their business. It provides insights into cash flow patterns and enables quick transaction entry.

## User Needs
- **Complete Overview**: See all transactions in one place
- **Easy Filtering**: Filter by type, date, amount, store
- **Quick Search**: Find specific transactions
- **Trend Analysis**: Understand spending patterns
- **Fast Entry**: Add new transactions easily

## Page Structure

### 1. Header with Summary
```dart
// Sticky header with monthly summary
SliverAppBar(
  expandedHeight: 200,
  floating: false,
  pinned: true,
  flexibleSpace: FlexibleSpaceBar(
    background: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TossColors.primary, TossColors.primary.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Month selector
              GestureDetector(
                onTap: () => showMonthPicker(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('March 2024', style: TossTextStyles.h2.white),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
              SizedBox(height: 20),
              
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Income',
                      amount: monthlyIncome,
                      color: TossColors.success,
                      icon: Icons.trending_up,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Expense',
                      amount: monthlyExpense,
                      color: TossColors.error,
                      icon: Icons.trending_down,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ),
)
```

### 2. Filter & Search Bar
```dart
// Persistent filter section
Container(
  color: TossColors.white,
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      // Search bar
      TossTextField(
        controller: searchController,
        hintText: 'Search transactions...',
        prefixIcon: Icon(Icons.search, color: TossColors.gray400),
        suffixIcon: searchController.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => searchController.clear(),
            )
          : null,
      ),
      SizedBox(height: 12),
      
      // Filter chips
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TossFilterChip(
              label: 'All Types',
              selected: selectedType == null,
              onTap: () => clearTypeFilter(),
              trailing: Icon(Icons.arrow_drop_down, size: 16),
            ),
            SizedBox(width: 8),
            TossFilterChip(
              label: dateRangeLabel,
              selected: dateRange != null,
              onTap: () => showDateRangePicker(),
            ),
            SizedBox(width: 8),
            TossFilterChip(
              label: 'All Stores',
              selected: selectedStore == null,
              onTap: () => showStoreFilter(),
            ),
            SizedBox(width: 8),
            if (hasActiveFilters)
              TossTextButton(
                text: 'Clear All',
                onPressed: clearAllFilters,
              ),
          ],
        ),
      ),
    ],
  ),
)
```

### 3. Transaction List
```dart
// Grouped by date
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      final group = transactionGroups[index];
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Text(
                  formatDateHeader(group.date),
                  style: TossTextStyles.body.bold,
                ),
                Spacer(),
                Text(
                  formatCurrency(group.dayTotal),
                  style: TossTextStyles.caption,
                ),
              ],
            ),
          ),
          
          // Transactions for this date
          ...group.transactions.map((transaction) => 
            _TransactionItem(transaction: transaction)
          ),
        ],
      );
    },
    childCount: transactionGroups.length,
  ),
)

// Individual transaction item
class _TransactionItem extends StatelessWidget {
  final Transaction transaction;
  
  @override
  Widget build(BuildContext context) {
    return TossListItem(
      onTap: () => showTransactionDetail(transaction),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _getIconBackground(transaction.category),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _getCategoryIcon(transaction.category),
          color: _getIconColor(transaction.category),
          size: 24,
        ),
      ),
      title: transaction.description,
      subtitle: '${transaction.category} • ${transaction.storeName}',
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${transaction.isIncome ? '+' : '-'}${formatCurrency(transaction.amount)}',
            style: TossTextStyles.body.bold.copyWith(
              color: transaction.isIncome ? TossColors.success : TossColors.black,
            ),
          ),
          Text(
            transaction.paymentMethod,
            style: TossTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
```

### 4. Empty & Loading States
```dart
// Empty state
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.receipt_long_outlined,
        size: 64,
        color: TossColors.gray300,
      ),
      SizedBox(height: 16),
      Text(
        'No transactions found',
        style: TossTextStyles.h3,
      ),
      SizedBox(height: 8),
      Text(
        searchController.text.isNotEmpty
          ? 'Try adjusting your search or filters'
          : 'Add your first transaction to get started',
        style: TossTextStyles.body.gray,
        textAlign: TextAlign.center,
      ),
      if (searchController.text.isEmpty) ...[
        SizedBox(height: 24),
        TossPrimaryButton(
          text: 'Add Transaction',
          onPressed: () => showAddTransactionSheet(),
          size: TossButtonSize.medium,
        ),
      ],
    ],
  ),
)
```

### 5. Floating Action Button
```dart
// Quick add transaction
FloatingActionButton(
  onPressed: () => showAddTransactionSheet(),
  backgroundColor: TossColors.primary,
  child: Icon(Icons.add),
)
```

## Add Transaction Bottom Sheet

```dart
TossBottomSheet.show(
  context: context,
  isScrollControlled: true,
  title: 'New Transaction',
  content: StatefulBuilder(
    builder: (context, setState) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Type selector
        TossSegmentedControl(
          value: transactionType,
          onChanged: (type) => setState(() => transactionType = type),
          children: {
            TransactionType.income: Text('Income'),
            TransactionType.expense: Text('Expense'),
          },
        ),
        SizedBox(height: 24),
        
        // Amount input
        TossAmountInput(
          controller: amountController,
          label: 'Amount',
          currency: '₩',
          autofocus: true,
        ),
        SizedBox(height: 20),
        
        // Category selector
        TossListTile(
          title: 'Category',
          subtitle: selectedCategory?.name ?? 'Select category',
          trailing: Icon(Icons.chevron_right),
          onTap: () async {
            final category = await showCategorySelector(
              context,
              type: transactionType,
            );
            if (category != null) {
              setState(() => selectedCategory = category);
            }
          },
        ),
        Divider(),
        
        // Description
        TossTextField(
          controller: descriptionController,
          label: 'Description',
          hintText: 'What was this transaction for?',
        ),
        SizedBox(height: 20),
        
        // Date selector
        TossListTile(
          title: 'Date',
          subtitle: formatDate(selectedDate),
          trailing: Icon(Icons.calendar_today, size: 20),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now().subtract(Duration(days: 365)),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => selectedDate = date);
            }
          },
        ),
        Divider(),
        
        // Payment method
        TossDropdown(
          label: 'Payment Method',
          value: paymentMethod,
          items: ['Cash', 'Card', 'Bank Transfer'],
          onChanged: (method) => setState(() => paymentMethod = method),
        ),
        SizedBox(height: 32),
        
        // Submit button
        TossPrimaryButton(
          text: 'Add Transaction',
          onPressed: isValid ? submitTransaction : null,
          isLoading: isSubmitting,
        ),
      ],
    ),
  ),
)
```

## Filter Bottom Sheet

```dart
// Advanced filtering options
TossBottomSheet.show(
  context: context,
  title: 'Filter Transactions',
  content: Column(
    children: [
      // Transaction type
      TossSection(
        title: 'Type',
        child: Column(
          children: [
            TossRadioListTile(
              title: 'All transactions',
              value: null,
              groupValue: filterType,
              onChanged: (value) => setState(() => filterType = value),
            ),
            TossRadioListTile(
              title: 'Income only',
              value: TransactionType.income,
              groupValue: filterType,
              onChanged: (value) => setState(() => filterType = value),
            ),
            TossRadioListTile(
              title: 'Expenses only',
              value: TransactionType.expense,
              groupValue: filterType,
              onChanged: (value) => setState(() => filterType = value),
            ),
          ],
        ),
      ),
      
      // Amount range
      TossSection(
        title: 'Amount Range',
        child: Row(
          children: [
            Expanded(
              child: TossTextField(
                controller: minAmountController,
                label: 'Min',
                keyboardType: TextInputType.number,
                prefixText: '₩',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TossTextField(
                controller: maxAmountController,
                label: 'Max',
                keyboardType: TextInputType.number,
                prefixText: '₩',
              ),
            ),
          ],
        ),
      ),
      
      // Categories
      TossSection(
        title: 'Categories',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) => 
            TossChip(
              label: category.name,
              selected: selectedCategories.contains(category),
              onTap: () => toggleCategory(category),
            ),
          ).toList(),
        ),
      ),
    ],
  ),
  actions: [
    TossTextButton(
      text: 'Reset',
      onPressed: resetFilters,
    ),
    TossPrimaryButton(
      text: 'Apply Filters',
      onPressed: applyFilters,
    ),
  ],
)
```

## State Management

```dart
@riverpod
class TransactionHistory extends _$TransactionHistory {
  @override
  Future<List<Transaction>> build() async {
    final repository = ref.watch(transactionRepositoryProvider);
    final filters = ref.watch(transactionFiltersProvider);
    final searchQuery = ref.watch(transactionSearchProvider);
    
    return repository.getTransactions(
      filters: filters,
      searchQuery: searchQuery,
    );
  }
}

@riverpod
class TransactionFilters extends _$TransactionFilters {
  @override
  TransactionFilterState build() => TransactionFilterState();
  
  void updateType(TransactionType? type) {
    state = state.copyWith(type: type);
  }
  
  void updateDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }
}

@riverpod
class TransactionSearch extends _$TransactionSearch {
  @override
  String build() => '';
  
  void updateQuery(String query) {
    state = query;
  }
}
```

## Performance Optimizations

- Virtualized list rendering
- Debounced search (300ms)
- Lazy loading with pagination
- Cached filter results
- Optimistic UI updates

## Analytics Events

- `transaction_history_viewed`
- `transaction_searched`
- `transaction_filtered`
- `transaction_added`
- `transaction_detail_viewed`

## Gestures & Interactions

- Pull to refresh
- Swipe to delete (with confirmation)
- Long press for multi-select
- Pinch to zoom (amount text)