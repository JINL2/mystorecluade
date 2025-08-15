# Transaction History Page Implementation Plan

## 📋 Overview
Toss-style transaction history page with cash location tracking and intuitive flow visualization.

## 🗄️ Database Structure Analysis

### Key Tables
```yaml
journal_entries:
  - journal_id: Primary transaction record
  - entry_date: Transaction timestamp
  - description: Transaction description
  - counterparty_id: Transaction party reference
  - store_id: Store association
  - currency_id: Currency type
  - base_amount: Transaction amount

journal_lines:
  - line_id: Transaction line item
  - journal_id: Parent transaction
  - account_id: Account reference
  - debit/credit: Amount flow
  - cash_location_id: Physical cash location
  - counterparty_id: Specific party for this line
  - description: Line-specific details

cash_locations:
  - location_name: Display name (e.g., "Main Store Register")
  - location_type: Type of location
  - bank_name: For bank locations

counterparties:
  - name: Party display name
  - type: Party type (vendor/customer/etc)

accounts:
  - account_name: Account display name
  - account_type: Type classification
```

## 🔌 RPC Functions Design

### 1. Get Transaction History
```sql
CREATE OR REPLACE FUNCTION get_transaction_history(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL,
  p_account_id UUID DEFAULT NULL,
  p_cash_location_id UUID DEFAULT NULL,
  p_counterparty_id UUID DEFAULT NULL,
  p_limit INT DEFAULT 50,
  p_offset INT DEFAULT 0
)
RETURNS TABLE(
  journal_id UUID,
  entry_date TIMESTAMP,
  journal_number TEXT,
  description TEXT,
  total_amount NUMERIC,
  currency_code TEXT,
  lines JSONB
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    je.journal_id,
    je.entry_date,
    COALESCE(je.journal_number, 'JRN-' || RIGHT(je.journal_id::TEXT, 6)) as journal_number,
    je.description,
    je.base_amount as total_amount,
    ct.currency_code,
    JSONB_AGG(
      JSONB_BUILD_OBJECT(
        'line_id', jl.line_id,
        'account_name', a.account_name,
        'account_type', a.account_type,
        'debit', jl.debit,
        'credit', jl.credit,
        'amount', COALESCE(jl.debit, 0) - COALESCE(jl.credit, 0),
        'is_debit', jl.debit > 0,
        'description', jl.description,
        'cash_location', CASE 
          WHEN cl.cash_location_id IS NOT NULL THEN
            JSONB_BUILD_OBJECT(
              'id', cl.cash_location_id,
              'name', cl.location_name,
              'type', cl.location_type,
              'bank_name', cl.bank_name
            )
          ELSE NULL
        END,
        'counterparty', CASE
          WHEN cp.counterparty_id IS NOT NULL THEN
            JSONB_BUILD_OBJECT(
              'id', cp.counterparty_id,
              'name', cp.name,
              'type', cp.type
            )
          ELSE NULL
        END
      ) ORDER BY jl.created_at
    ) as lines
  FROM journal_entries je
  JOIN journal_lines jl ON je.journal_id = jl.journal_id
  LEFT JOIN accounts a ON jl.account_id = a.account_id
  LEFT JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
  LEFT JOIN counterparties cp ON jl.counterparty_id = cp.counterparty_id
  LEFT JOIN currency_types ct ON je.currency_id = ct.currency_id
  WHERE je.company_id = p_company_id
    AND je.is_deleted = FALSE
    AND jl.is_deleted = FALSE
    AND (p_store_id IS NULL OR je.store_id = p_store_id)
    AND (p_date_from IS NULL OR je.entry_date >= p_date_from)
    AND (p_date_to IS NULL OR je.entry_date <= p_date_to)
    AND (p_account_id IS NULL OR jl.account_id = p_account_id)
    AND (p_cash_location_id IS NULL OR jl.cash_location_id = p_cash_location_id)
    AND (p_counterparty_id IS NULL OR je.counterparty_id = p_counterparty_id)
  GROUP BY je.journal_id, je.entry_date, je.journal_number, 
           je.description, je.base_amount, ct.currency_code
  ORDER BY je.entry_date DESC, je.created_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;
```

### 2. Get Transaction Summary
```sql
CREATE OR REPLACE FUNCTION get_transaction_summary(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_date_from DATE DEFAULT NULL,
  p_date_to DATE DEFAULT NULL
)
RETURNS TABLE(
  total_debit NUMERIC,
  total_credit NUMERIC,
  net_amount NUMERIC,
  transaction_count INT,
  cash_locations JSONB,
  top_counterparties JSONB
) AS $$
BEGIN
  -- Implementation here
END;
$$ LANGUAGE plpgsql;
```

## 🎨 UI Component Structure

### File Structure
```
lib/presentation/pages/transactions/
├── transaction_history_page.dart
├── widgets/
│   ├── transaction_list_item.dart
│   ├── transaction_detail_sheet.dart
│   ├── transaction_filter_sheet.dart
│   ├── transaction_summary_card.dart
│   └── transaction_empty_state.dart
└── providers/
    └── transaction_history_provider.dart
```

### 1. Main Page Layout
```dart
// transaction_history_page.dart
class TransactionHistoryPage extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: TossAppBar(
        title: 'Transaction History',
        actions: [
          IconButton(icon: Icon(Icons.filter_list), onPressed: _showFilter),
          IconButton(icon: Icon(Icons.search), onPressed: _showSearch),
        ],
      ),
      body: Column(
        children: [
          // Summary Card (optional)
          TransactionSummaryCard(),
          
          // Transaction List
          Expanded(
            child: TransactionList(),
          ),
        ],
      ),
    );
  }
}
```

### 2. Transaction List Item Component
```dart
// widgets/transaction_list_item.dart
class TransactionListItem extends StatelessWidget {
  final TransactionData transaction;
  
  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: () => _showDetail(context),
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header
          _buildDateHeader(),
          
          // Transaction Lines
          ...transaction.lines.map(_buildTransactionLine),
          
          // Divider and Summary
          if (transaction.lines.length > 1) _buildSummary(),
        ],
      ),
    );
  }
  
  Widget _buildTransactionLine(TransactionLine line) {
    final isDebit = line.debit > 0;
    final amount = isDebit ? line.debit : line.credit;
    final color = isDebit ? TossColors.success : TossColors.loss;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDebit ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
              size: 16,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          
          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      line.accountName,
                      style: TossTextStyle.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (line.cashLocation != null) ...[
                      SizedBox(width: TossSpacing.space2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          line.cashLocation!.name,
                          style: TossTextStyle.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (line.counterparty != null)
                  Text(
                    '→ ${line.counterparty!.name}',
                    style: TossTextStyle.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                if (line.description != null)
                  Text(
                    line.description!,
                    style: TossTextStyle.caption.copyWith(
                      color: TossColors.gray400,
                    ),
                  ),
              ],
            ),
          ),
          
          // Amount
          Text(
            '${isDebit ? '+' : '-'}${formatCurrency(amount)}',
            style: TossTextStyle.body.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3. Transaction Detail Sheet
```dart
// widgets/transaction_detail_sheet.dart
class TransactionDetailSheet extends StatelessWidget {
  final TransactionData transaction;
  
  @override
  Widget build(BuildContext context) {
    return TossBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          
          // Debit Section
          _buildDebitSection(),
          
          // Credit Section  
          _buildCreditSection(),
          
          // Metadata
          _buildMetadata(),
          
          // Attachments
          if (transaction.attachments.isNotEmpty)
            _buildAttachments(),
        ],
      ),
    );
  }
}
```

## 🔗 State Management (Riverpod)

### Transaction History Provider
```dart
// providers/transaction_history_provider.dart
@riverpod
class TransactionHistory extends _$TransactionHistory {
  @override
  Future<List<TransactionData>> build() async {
    return _fetchTransactions();
  }
  
  Future<List<TransactionData>> _fetchTransactions({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? accountId,
    String? cashLocationId,
    String? counterpartyId,
  }) async {
    final supabase = ref.read(supabaseProvider);
    final companyId = ref.read(currentCompanyProvider).value?.companyId;
    final storeId = ref.read(currentStoreProvider).value?.storeId;
    
    final response = await supabase.rpc('get_transaction_history', params: {
      'p_company_id': companyId,
      'p_store_id': storeId,
      'p_date_from': dateFrom?.toIso8601String(),
      'p_date_to': dateTo?.toIso8601String(),
      'p_account_id': accountId,
      'p_cash_location_id': cashLocationId,
      'p_counterparty_id': counterpartyId,
    });
    
    return (response as List)
        .map((json) => TransactionData.fromJson(json))
        .toList();
  }
  
  Future<void> applyFilter(TransactionFilter filter) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTransactions(
      dateFrom: filter.dateFrom,
      dateTo: filter.dateTo,
      accountId: filter.accountId,
      cashLocationId: filter.cashLocationId,
      counterpartyId: filter.counterpartyId,
    ));
  }
}
```

## 📱 Data Models

```dart
// models/transaction_data.dart
class TransactionData {
  final String journalId;
  final DateTime entryDate;
  final String journalNumber;
  final String description;
  final double totalAmount;
  final String currencyCode;
  final List<TransactionLine> lines;
  
  TransactionData.fromJson(Map<String, dynamic> json) {
    // Parse JSON
  }
}

class TransactionLine {
  final String lineId;
  final String accountName;
  final String accountType;
  final double? debit;
  final double? credit;
  final double amount;
  final bool isDebit;
  final String? description;
  final CashLocation? cashLocation;
  final Counterparty? counterparty;
}

class CashLocation {
  final String id;
  final String name;
  final String type;
  final String? bankName;
}

class Counterparty {
  final String id;
  final String name;
  final String type;
}
```

## 🎯 Implementation Steps

### Phase 1: Backend Setup (Day 1)
1. ✅ Analyze database structure
2. Create RPC functions in Supabase
3. Test RPC functions with sample data
4. Create data models in Flutter

### Phase 2: UI Components (Day 2)
1. Create transaction list item component
2. Create transaction detail sheet
3. Create filter sheet component
4. Create empty state component

### Phase 3: Integration (Day 3)
1. Implement Riverpod providers
2. Connect UI with data
3. Implement filtering logic
4. Add search functionality

### Phase 4: Polish (Day 4)
1. Add animations and micro-interactions
2. Implement pull-to-refresh
3. Add pagination/infinite scroll
4. Performance optimization

## 🏷️ Key Features

### Must Have
- ✓ Transaction list with date grouping
- ✓ Cash location display
- ✓ Counterparty display
- ✓ Debit/Credit visualization
- ✓ Transaction detail view
- ✓ Basic filtering

### Nice to Have
- Search functionality
- Export to CSV/PDF
- Transaction analytics
- Quick filters (Today, This Week, This Month)
- Transaction categories/tags

## 🎨 Design Specifications

### Colors
```yaml
Debit (Income): TossColors.success (#22C55E)
Credit (Expense): TossColors.loss (#EF4444)
Neutral: TossColors.gray500
Background: TossColors.background
Surface: TossColors.surface
```

### Typography
```yaml
Date Header: TossTextStyle.h3
Account Name: TossTextStyle.body (weight: 600)
Amount: TossTextStyle.body (weight: bold)
Description: TossTextStyle.caption
Location/Party: TossTextStyle.caption (gray500)
```

### Spacing
```yaml
Card Padding: TossSpacing.space4 (16px)
Line Spacing: TossSpacing.space2 (8px)
Icon Margin: TossSpacing.space3 (12px)
```

### Animations
- Card tap: Scale 0.98 with 100ms duration
- List item entrance: Fade + slide from bottom
- Pull to refresh: Toss-style spinner
- Sheet opening: Smooth slide up

## 📊 Performance Considerations

1. **Pagination**: Load 50 transactions at a time
2. **Caching**: Cache last 200 transactions locally
3. **Lazy Loading**: Load details only when needed
4. **Image Optimization**: Lazy load attachment previews
5. **Search Debouncing**: 300ms debounce on search input

## 🔐 Security Considerations

1. **RLS**: Ensure proper Row Level Security on Supabase
2. **Data Validation**: Validate all input parameters
3. **Permission Check**: Verify user has access to view transactions
4. **Sensitive Data**: Mask sensitive account numbers if needed

## 📝 Testing Strategy

1. **Unit Tests**: Data models and business logic
2. **Widget Tests**: Individual UI components
3. **Integration Tests**: Full page flow
4. **Performance Tests**: List scrolling and loading

## 🚀 Deployment Checklist

- [ ] RPC functions deployed to Supabase
- [ ] Database indexes created for performance
- [ ] UI components tested on all screen sizes
- [ ] Dark mode support verified
- [ ] Accessibility features implemented
- [ ] Error handling for network failures
- [ ] Loading states for all async operations
- [ ] Empty states for no data scenarios