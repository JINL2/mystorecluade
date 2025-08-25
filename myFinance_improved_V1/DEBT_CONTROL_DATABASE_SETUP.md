# Debt Control Database Setup Guide

## 🚨 **Current Issue**
The debt control page is throwing errors because the required database functions don't exist in your Supabase database.

## ✅ **Solution**

### Step 1: Run the Database Setup Script

Execute the following SQL scripts in your Supabase SQL Editor in this order:

1. **First, add the feature to the navigation menu:**
```sql
-- Run the content of: sql/add_debt_control_feature.sql
```

2. **Then, create all required database functions:**
```sql
-- Run the content of: sql/create_debt_control_functions.sql
```

### Step 2: Verify Installation

After running the scripts, verify the functions were created:

```sql
SELECT 
  routine_name,
  routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name IN (
    'get_debt_kpi_metrics',
    'get_debt_aging_analysis', 
    'get_prioritized_debts',
    'get_debt_critical_alerts'
  )
ORDER BY routine_name;
```

You should see 4 functions listed.

### Step 3: Check Table Structure

Verify the debts_receivable table has all required columns:

```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'debts_receivable'
ORDER BY ordinal_position;
```

## 📊 **What the Functions Do**

### 1. `get_debt_kpi_metrics`
- Returns key performance indicators
- Calculates net position, collection rates, critical counts
- Provides overview metrics for the dashboard

### 2. `get_debt_aging_analysis`
- Groups debts into aging buckets (current, 30, 60, 90+ days)
- Used for the aging visualization chart

### 3. `get_prioritized_debts`
- Returns risk-scored list of debts
- Prioritizes by urgency and amount
- Supports filtering by viewpoint and type

### 4. `get_debt_critical_alerts`
- Generates alerts for critical situations
- Tracks overdue items, recent payments, disputes
- Provides proactive notifications

## 🔍 **Testing the Functions**

Test each function individually:

```sql
-- Test KPI metrics
SELECT get_debt_kpi_metrics(
  'YOUR_COMPANY_ID', 
  NULL, 
  'company'
);

-- Test aging analysis
SELECT get_debt_aging_analysis(
  'YOUR_COMPANY_ID',
  NULL,
  'company'  
);

-- Test prioritized debts
SELECT get_prioritized_debts(
  'YOUR_COMPANY_ID',
  NULL,
  'company',
  'all',
  50,
  0
);

-- Test critical alerts
SELECT get_debt_critical_alerts(
  'YOUR_COMPANY_ID',
  NULL
);
```

Replace `YOUR_COMPANY_ID` with an actual company ID from your database.

## 🎯 **Sample Data (Optional)**

If you want to test with sample data, uncomment the sample data section at the end of `create_debt_control_functions.sql` or run:

```sql
-- Insert sample receivable debts
INSERT INTO debts_receivable (
  debt_id,
  company_id,
  store_id,
  counterparty_id,
  amount,
  currency,
  due_date,
  debt_type,
  payment_status,
  description,
  created_at
)
SELECT 
  gen_random_uuid(),
  (SELECT company_id FROM companies LIMIT 1),
  (SELECT store_id FROM stores LIMIT 1),
  (SELECT counterparty_id FROM counterparties WHERE company_id = (SELECT company_id FROM companies LIMIT 1) LIMIT 1),
  (random() * 5000000)::numeric(15,2),
  'VND',
  NOW() - (random() * 120 || ' days')::interval,
  'receivable',
  CASE 
    WHEN random() < 0.3 THEN 'paid'
    WHEN random() < 0.6 THEN 'pending'
    ELSE 'overdue'
  END,
  'Test debt for demo',
  NOW()
FROM generate_series(1, 10);
```

## ⚠️ **Important Notes**

1. **Database Columns**: The script automatically adds any missing columns to the `debts_receivable` table
2. **Permissions**: The script grants execute permissions to authenticated users
3. **Currency**: Default currency is set to 'VND' - change if needed
4. **Fallback**: The app has fallback calculations when functions don't exist, but features will be limited

## 🚀 **After Setup**

Once the database is set up:
1. Refresh your app
2. Navigate to the Debt Control page
3. The page should load without errors
4. You'll see empty states if no debt data exists

## 📝 **Next Steps**

1. **Add Real Data**: Start adding actual debt records through your app
2. **Customize Functions**: Modify the SQL functions to match your business logic
3. **Add Trends**: Implement historical data tracking for trend calculations
4. **Configure Alerts**: Customize alert thresholds and types

## 🐛 **Troubleshooting**

If you still see errors after running the scripts:

1. **Clear browser cache**: Force refresh the page
2. **Check Supabase logs**: Look for any SQL errors
3. **Verify permissions**: Ensure your user role has proper access
4. **Test functions manually**: Use the SQL test queries above

The debt control page should now work properly! 🎉