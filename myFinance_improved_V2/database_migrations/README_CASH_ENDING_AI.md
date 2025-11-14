# Cash Ending AI Chat Configuration

## 📋 Overview

This directory contains SQL migrations to configure the **Cash Ending** feature for the `ai-chat` Edge Function.

**Key Concept:** The `ai-chat` Edge Function is a **generic AI assistant**. It adapts its behavior based on configurations in the `features` table. We don't modify the Edge Function code—we just add data to the database.

---

## 🗂️ Files

| File | Description |
|------|-------------|
| `01_update_cash_ending_feature.sql` | Updates `features` table with Cash Ending configuration |
| `02_add_cash_ending_table_metadata.sql` | Adds column-level metadata for all Cash Ending tables |
| `03_add_cash_ending_business_rules.sql` | Adds table-level business logic and fraud detection rules |

---

## 🚀 How to Apply Migrations

### Option 1: Supabase Dashboard (Recommended)

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Navigate to **SQL Editor**
4. Copy and paste each SQL file **in order** (01, 02, 03)
5. Run each script

### Option 2: Supabase CLI

```bash
# Apply migrations in order
supabase db push

# Or manually execute each file
psql $DATABASE_URL -f 01_update_cash_ending_feature.sql
psql $DATABASE_URL -f 02_add_cash_ending_table_metadata.sql
psql $DATABASE_URL -f 03_add_cash_ending_business_rules.sql
```

---

## 📊 What Gets Configured

### 1. Features Table Update

**Feature ID:** `582171a8-6a92-42e7-99ed-f8233169a652`

**Primary Tables:**
- `cash_control` - Daily cash ending control records
- `cash_amount_stock_flow` - Historical cash flow
- `bank_amount` - Bank account balances
- `vault_amount_line` - Vault transactions
- `cash_locations` - Cash storage locations
- `currency_denominations` - Denomination master data
- `cashier_amount_lines` - Denomination count details
- `v_bank_amount` - Bank balance view
- `v_cash_location` - Cash location view
- `view_cashier_real_latest_total` - Latest cash totals
- `cash_locations_with_total_amount` - Locations with balances

**Tables Requiring Store Filter:**
- `cash_control`
- `cash_amount_stock_flow`
- `bank_amount`
- `vault_amount_line`
- `cashier_amount_lines`

**Store Filter Column:** `store_id`

**Custom System Prompt:** Specialized prompt for cash management analysis

**Sample Questions:** 6 Korean sample questions for testing

---

### 2. Table Metadata (Column-Level)

For each table, we define:

- **Column Name:** Actual database column
- **Meaning:** Business meaning of the column
- **Calculation Formula:** How the value is calculated (if applicable)
- **Normal Range:** Expected value range
- **Business Rules:** Business logic constraints
- **Fraud Detection Rules:** JSONB rules for anomaly detection
- **Severity:** `critical`, `high`, `medium` (for fraud detection)

**Example:**
```sql
table_name: cash_control
column_name: actual_amount
meaning: Total actual cash amount counted
calculation_formula: SUM of all denominations * quantities from cashier_amount_lines
normal_range: >= 0
business_rules: Cannot be negative. Should align with daily sales minus deposits.
fraud_detection_rules: {"type": "negative_amount", "check": "actual_amount < 0", ...}
severity: critical
```

**Total Columns Documented:** 60+ columns across 7 tables

---

### 3. Table Business Rules (Table-Level)

For each major table, we define:

- **Description:** What the table represents
- **Workflow:** Step-by-step business process
- **Calculation Logic:** Key formulas and relationships
- **Fraud Rules:** Detailed fraud detection patterns with SQL examples

**Fraud Detection Patterns Include:**
- Missing records (gaps in daily cash endings)
- Negative amounts (critical errors)
- Balance calculation mismatches
- Unusual patterns (sudden large changes)
- Data integrity issues (orphaned records, duplicates)

**Total Business Rules:** 5 comprehensive rule sets

---

## 🔄 How AI Chat Uses This Data

### Workflow When User Asks a Question:

```
1. Flutter app sends request to ai-chat Edge Function
   {
     question: "오늘 현금 마감 현황은?",
     company_id: "xxx",
     store_id: "yyy",
     feature_id: "582171a8-6a92-42e7-99ed-f8233169a652", // Cash Ending
     current_date: "2025-01-14",
     timezone: "Asia/Seoul"
   }

2. Edge Function loads feature configuration
   - Reads from features table using feature_id
   - Gets primary_tables, tables_require_store_filter, custom_system_prompt

3. AI receives specialized system prompt
   - Knows it's a "Cash Management Expert"
   - Understands cash ending business context

4. AI calls tools to understand data:

   a) get_table_schema('cash_control')
      → Returns: column names, data types

   b) get_column_meanings('cash_control')
      → Returns: column meanings, business rules, fraud rules

   c) resolve_context()
      → Returns: All stores for the company

   d) query_database("SELECT * FROM cash_control WHERE ...")
      → Edge Function automatically adds: store_id IN (...)
      → Because cash_control is in tables_require_store_filter

   e) detect_anomalies('cash_control', 'all')
      → Returns: Fraud detection rules for the table

5. AI analyzes results and returns answer to user
```

---

## 🎯 Key Features

### Automatic Store Filtering

If a table is in `tables_require_store_filter`, the Edge Function **automatically adds** a `WHERE store_id IN (...)` clause to queries.

**Example:**

```sql
-- AI generates this query:
SELECT * FROM cash_control WHERE record_date = '2025-01-14'

-- Edge Function transforms it to:
SELECT * FROM cash_control
WHERE store_id IN ('store1', 'store2')  -- Auto-added!
AND record_date = '2025-01-14'
```

This ensures **data isolation** between stores.

---

### Fraud Detection

AI can call `detect_anomalies()` tool to run fraud detection queries based on rules in `table_metadata`:

```javascript
detect_anomalies('cash_control', 'negative_amount')
```

Edge Function looks up `fraud_detection_rules` for `cash_control` and constructs appropriate SQL.

---

## 📱 Flutter Integration

### How to Call AI Chat from Flutter

```dart
// In your Cash Ending page
final response = await supabase.functions.invoke(
  'ai-chat',
  body: {
    'question': userQuestion,  // User's question in Korean or English
    'company_id': currentCompanyId,
    'store_id': currentStoreId,  // Optional, depends on user's view
    'feature_id': '582171a8-6a92-42e7-99ed-f8233169a652',  // Cash Ending
    'current_date': DateTime.now().toIso8601String(),
    'timezone': 'Asia/Seoul',
    'session_id': sessionId,  // Optional, for conversation history
  },
);

final answer = response.data['answer'];
```

### Session Management

- **session_id:** Optional UUID to maintain conversation history
- AI remembers last 6 messages in a session
- Useful for follow-up questions

---

## 🧪 Testing

### Manual Testing via Supabase Dashboard

1. Go to **Edge Functions** → `ai-chat`
2. Use the **Invoke** tab
3. Send test request:

```json
{
  "question": "오늘 현금 마감 현황 보여줘",
  "company_id": "your-company-id",
  "store_id": "your-store-id",
  "feature_id": "582171a8-6a92-42e7-99ed-f8233169a652",
  "current_date": "2025-01-14T10:00:00Z",
  "timezone": "Asia/Seoul"
}
```

### Sample Questions to Test

1. "오늘 현금 마감 현황 보여줘" (Today's cash ending status)
2. "이번 달 은행 입출금 내역은?" (This month's bank transactions)
3. "금고 잔액 불일치 케이스 찾아줘" (Find vault balance discrepancies)
4. "이번 주 현금 흐름 분석해줘" (Analyze this week's cash flow)
5. "특정 지점의 화폐 재고 현황" (Currency inventory for a specific store)
6. "어제와 오늘 은행 잔액 비교" (Compare yesterday and today's bank balance)

---

## 📚 Database Schema Reference

### Main Tables

#### cash_control
Daily cash ending control records
- Primary Key: `control_id`
- Links to: `cash_locations`, `stores`, `users`
- Child records: `cashier_amount_lines`

#### cashier_amount_lines
Individual denomination counts
- Primary Key: `line_id`
- Links to: `cash_control`, `currency_denominations`

#### bank_amount
Bank account balance snapshots
- Primary Key: `bank_amount_id`
- Links to: `cash_locations` (type=bank)

#### vault_amount_line
Vault deposit/withdrawal transactions
- Primary Key: `vault_amount_id`
- Links to: `cash_locations` (type=vault)
- Uses debit/credit accounting

#### cash_amount_stock_flow
Historical cash flow audit trail
- Primary Key: `flow_id`
- Immutable records
- Tracks balance_before → flow_amount → balance_after

---

## 🔧 Maintenance

### Adding New Fraud Detection Rules

1. Update `table_metadata` for the specific column:

```sql
UPDATE table_metadata
SET fraud_detection_rules = '{
  "type": "your_rule_type",
  "check": "SQL_CONDITION",
  "message": "Error message"
}'::jsonb
WHERE table_name = 'cash_control'
AND column_name = 'actual_amount';
```

2. AI will automatically use the new rule when calling `detect_anomalies()`

### Adding New Tables

1. Add table name to `features.primary_tables`
2. If store filtering needed, add to `features.tables_require_store_filter`
3. Add column metadata to `table_metadata`
4. Add business rules to `table_business_rules`

### Updating System Prompt

```sql
UPDATE features
SET custom_system_prompt = 'Your new prompt...'
WHERE feature_id = '582171a8-6a92-42e7-99ed-f8233169a652';
```

---

## 🛡️ Security Notes

- **RLS (Row Level Security):** Ensure RLS policies are enabled on all tables
- **Service Role Key:** Edge Function uses service role key (bypasses RLS)
- **Store Filtering:** Automatically enforced by Edge Function configuration
- **User Context:** Always pass `company_id` and `store_id` from authenticated user

---

## 🐛 Troubleshooting

### AI doesn't understand the question
- Check `custom_system_prompt` is comprehensive
- Add more examples in prompt
- Check `sample_questions` for inspiration

### AI returns wrong data
- Verify `table_metadata` column meanings are accurate
- Check `business_rules` explain calculations correctly
- Test queries manually first

### Store filtering not working
- Confirm table is in `tables_require_store_filter`
- Check `store_filter_column` is correct (usually 'store_id')
- Verify `resolve_context()` returns correct stores

### Query errors
- Check column names match actual database schema
- Use `get_table_schema()` tool to verify
- Look at Edge Function logs in Supabase dashboard

---

## 📖 Related Documentation

- [Edge Function Code](../../supabase/functions/ai-chat/index.ts)
- [Features Table Schema](../../docs/database_schema.md#features)
- [Cash Ending Flutter Code](../../lib/features/cash_ending/)
- [AI Chat Architecture](../../docs/ai_chat_architecture.md)

---

## ✅ Verification Checklist

After running migrations:

- [ ] Feature configuration updated (check `features` table)
- [ ] 60+ column metadata entries created (check `table_metadata`)
- [ ] 5 business rule entries created (check `table_business_rules`)
- [ ] Test AI chat with sample question
- [ ] Verify store filtering works correctly
- [ ] Check fraud detection returns results

---

## 💡 Tips

1. **Start Simple:** Test with basic questions first ("오늘 현금 마감 현황은?")
2. **Use Session ID:** For multi-turn conversations, use consistent session_id
3. **Monitor Logs:** Check Supabase Edge Function logs for debugging
4. **Iterate Prompts:** Refine `custom_system_prompt` based on AI responses
5. **Document Patterns:** Add more fraud patterns as you discover them

---

## 📞 Support

If you encounter issues:
1. Check Edge Function logs in Supabase dashboard
2. Verify all migrations ran successfully
3. Test SQL queries manually in SQL Editor
4. Check feature_id is correct in Flutter code

---

**Generated:** 2025-01-14
**Author:** Claude Code
**Version:** 1.0
