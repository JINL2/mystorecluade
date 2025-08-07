# Cash Balance Page Design

## Purpose
The Cash Balance page provides users with a real-time overview of their cash positions across different stores, recent cash movements, and quick access to record new transactions.

## User Needs
- **Quick Overview**: See total cash balance at a glance
- **Store Breakdown**: View cash by individual stores
- **Recent Activity**: Track recent cash movements
- **Easy Recording**: Quick access to add new cash transactions
- **Trend Analysis**: Understand cash flow patterns

## Page Structure

### 1. Header Section
```dart
// Sticky header with balance overview
Container(
  color: TossColors.primary,
  child: SafeArea(
    bottom: false,
    child: Column(
      children: [
        // Navigation bar
        Row(
          children: [
            IconButton(icon: Icons.arrow_back),
            Text('Cash Balance', style: TossTextStyles.h3.white),
            Spacer(),
            IconButton(icon: Icons.sync), // Refresh
          ],
        ),
        
        // Total balance display
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Total Cash Balance', style: TossTextStyles.caption.white),
              SizedBox(height: 8),
              AnimatedCounter(
                value: totalBalance,
                style: TossTextStyles.display.white,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, color: TossColors.success, size: 16),
                  SizedBox(width: 4),
                  Text('+2.5% from last month', 
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.success
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
)
```

### 2. Store Cards Section
```dart
// Scrollable list of store cash positions
ListView.separated(
  padding: EdgeInsets.all(20),
  itemCount: stores.length,
  separatorBuilder: (_, __) => SizedBox(height: 12),
  itemBuilder: (context, index) {
    final store = stores[index];
    return TossCard(
      onTap: () => navigateToStoreDetail(store),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Store icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.store, color: TossColors.primary),
            ),
            SizedBox(width: 16),
            
            // Store info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.name, style: TossTextStyles.body.bold),
                  SizedBox(height: 4),
                  Text('${store.transactionCount} transactions today',
                    style: TossTextStyles.caption,
                  ),
                ],
              ),
            ),
            
            // Balance
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(store.balance),
                  style: TossTextStyles.h3,
                ),
                if (store.changePercent != 0)
                  Text(
                    '${store.changePercent > 0 ? '+' : ''}${store.changePercent}%',
                    style: TossTextStyles.caption.copyWith(
                      color: store.changePercent > 0 
                        ? TossColors.success 
                        : TossColors.error,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  },
)
```

### 3. Recent Transactions Section
```dart
// Quick view of recent cash movements
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text('Recent Transactions', style: TossTextStyles.h3),
          Spacer(),
          TextButton(
            onPressed: () => navigateToTransactionHistory(),
            child: Text('See All', style: TossTextStyles.body.primary),
          ),
        ],
      ),
    ),
    
    // Transaction list
    ...recentTransactions.map((transaction) => TossListItem(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: transaction.isIncome 
            ? TossColors.success.withOpacity(0.1)
            : TossColors.gray100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          transaction.isIncome 
            ? Icons.arrow_downward 
            : Icons.arrow_upward,
          color: transaction.isIncome 
            ? TossColors.success 
            : TossColors.gray700,
          size: 20,
        ),
      ),
      title: transaction.description,
      subtitle: transaction.formattedTime,
      trailing: Text(
        '${transaction.isIncome ? '+' : '-'}${formatCurrency(transaction.amount)}',
        style: TossTextStyles.body.bold.copyWith(
          color: transaction.isIncome ? TossColors.success : TossColors.black,
        ),
      ),
      onTap: () => showTransactionDetail(transaction),
    )),
  ],
)
```

### 4. Floating Action Button
```dart
// Primary action to record cash movement
Positioned(
  bottom: 20 + MediaQuery.of(context).padding.bottom,
  right: 20,
  child: FloatingActionButton.extended(
    onPressed: () => showCashMovementBottomSheet(),
    backgroundColor: TossColors.primary,
    icon: Icon(Icons.add),
    label: Text('Record Cash'),
    elevation: 4,
  ),
)
```

## Bottom Sheet Design (Record Cash Movement)

```dart
TossBottomSheet.show(
  context: context,
  title: 'Record Cash Movement',
  content: Column(
    children: [
      // Movement type selector
      Row(
        children: [
          Expanded(
            child: TossSegmentedButton(
              selected: movementType,
              options: ['Cash In', 'Cash Out'],
              onChanged: (type) => setState(() => movementType = type),
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
      
      // Amount input
      TossAmountInput(
        controller: amountController,
        label: movementType == 'Cash In' 
          ? 'How much received?' 
          : 'How much paid?',
        currency: '₩',
      ),
      SizedBox(height: 20),
      
      // Store selector
      TossDropdown(
        label: 'Store',
        value: selectedStore,
        items: stores,
        onChanged: (store) => setState(() => selectedStore = store),
      ),
      SizedBox(height: 20),
      
      // Description
      TossTextField(
        label: 'Description',
        controller: descriptionController,
        hintText: 'e.g., Customer payment, Supply purchase',
      ),
      SizedBox(height: 32),
      
      // Submit button
      TossPrimaryButton(
        text: 'Record Movement',
        onPressed: isValid ? submitCashMovement : null,
        isLoading: isSubmitting,
      ),
    ],
  ),
)
```

## State Management

```dart
// Provider setup for cash balance
@riverpod
class CashBalance extends _$CashBalance {
  @override
  Future<CashBalanceData> build() async {
    final repository = ref.watch(cashRepositoryProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    
    if (selectedCompany == null) {
      throw Exception('No company selected');
    }
    
    return repository.getCashBalance(selectedCompany.id);
  }
  
  Future<void> recordMovement(CashMovement movement) async {
    final repository = ref.read(cashRepositoryProvider);
    await repository.recordCashMovement(movement);
    ref.invalidateSelf(); // Refresh data
  }
}

// Recent transactions provider
@riverpod
Future<List<Transaction>> recentCashTransactions(
  RecentCashTransactionsRef ref,
) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  return repository.getRecentTransactions(
    companyId: selectedCompany?.id,
    type: TransactionType.cash,
    limit: 5,
  );
}
```

## Loading States

```dart
// Skeleton loading for store cards
Shimmer.fromColors(
  baseColor: TossColors.gray100,
  highlightColor: TossColors.gray50,
  child: Column(
    children: List.generate(3, (index) => Container(
      height: 80,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    )),
  ),
)
```

## Error Handling

```dart
// Error state widget
TossErrorView(
  title: 'Unable to load cash balance',
  message: 'Please check your connection and try again',
  onRetry: () => ref.refresh(cashBalanceProvider),
)
```

## Analytics Events

- `cash_balance_viewed` - Page view
- `cash_movement_recorded` - New transaction
- `store_cash_detail_viewed` - Store card tap
- `cash_balance_refreshed` - Manual refresh

## Accessibility

- Screen reader labels for all amounts
- Touch targets minimum 48x48
- High contrast mode support
- Keyboard navigation for web

## Performance Considerations

- Lazy load transaction history
- Cache balance data for offline viewing
- Optimistic updates for cash movements
- Debounce sync button