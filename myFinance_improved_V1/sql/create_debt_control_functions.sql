-- ============================================================================
-- Debt Control Database Functions
-- Creates all required functions for the smart debt control page
-- ============================================================================

-- Drop existing functions if they exist (for clean installation)
DROP FUNCTION IF EXISTS public.get_debt_kpi_metrics CASCADE;
DROP FUNCTION IF EXISTS public.get_debt_aging_analysis CASCADE;
DROP FUNCTION IF EXISTS public.get_prioritized_debts CASCADE;
DROP FUNCTION IF EXISTS public.get_debt_critical_alerts CASCADE;

-- ============================================================================
-- 1. KPI Metrics Function
-- Returns key performance indicators for debt management
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_debt_kpi_metrics(
  p_company_id TEXT,
  p_store_id TEXT DEFAULT NULL,
  p_viewpoint TEXT DEFAULT 'company'
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
  v_result JSON;
BEGIN
  WITH debt_stats AS (
    SELECT
      COALESCE(SUM(CASE WHEN dr.debt_type = 'receivable' THEN dr.amount ELSE 0 END), 0) AS total_receivable,
      COALESCE(SUM(CASE WHEN dr.debt_type = 'payable' THEN dr.amount ELSE 0 END), 0) AS total_payable,
      COUNT(DISTINCT dr.debt_id) AS transaction_count,
      -- Calculate average days outstanding for receivables
      COALESCE(
        AVG(
          CASE 
            WHEN dr.debt_type = 'receivable' AND dr.payment_status != 'paid' 
            THEN EXTRACT(DAY FROM (NOW() - dr.due_date))
            ELSE NULL 
          END
        ), 0
      ) AS avg_days_outstanding,
      -- Count critical items (overdue > 90 days)
      COUNT(
        CASE 
          WHEN dr.debt_type = 'receivable' 
            AND dr.payment_status != 'paid'
            AND dr.due_date < NOW() - INTERVAL '90 days' 
          THEN 1 
          ELSE NULL 
        END
      ) AS critical_count
    FROM debts_receivable dr
    WHERE dr.company_id = p_company_id
      AND (p_store_id IS NULL OR dr.store_id = p_store_id)
      AND dr.is_deleted = false
  ),
  collection_stats AS (
    -- Calculate collection rate (payments received in last 30 days vs total receivables)
    SELECT
      CASE 
        WHEN SUM(dr.amount) > 0 THEN
          (SUM(CASE WHEN dr.payment_status = 'paid' AND dr.payment_date > NOW() - INTERVAL '30 days' THEN dr.amount ELSE 0 END) / SUM(dr.amount)) * 100
        ELSE 0
      END AS collection_rate
    FROM debts_receivable dr
    WHERE dr.company_id = p_company_id
      AND (p_store_id IS NULL OR dr.store_id = p_store_id)
      AND dr.debt_type = 'receivable'
      AND dr.is_deleted = false
  )
  SELECT json_build_object(
    'netPosition', ds.total_receivable - ds.total_payable,
    'netPositionTrend', 0.0, -- Placeholder for trend calculation
    'avgDaysOutstanding', ROUND(ds.avg_days_outstanding),
    'agingTrend', 0.0, -- Placeholder for trend calculation
    'collectionRate', COALESCE(cs.collection_rate, 0),
    'collectionTrend', 0.0, -- Placeholder for trend calculation
    'criticalCount', ds.critical_count,
    'criticalTrend', 0.0, -- Placeholder for trend calculation
    'totalReceivable', ds.total_receivable,
    'totalPayable', ds.total_payable,
    'transactionCount', ds.transaction_count
  ) INTO v_result
  FROM debt_stats ds, collection_stats cs;
  
  RETURN v_result;
END;
$$;

-- ============================================================================
-- 2. Aging Analysis Function
-- Returns debt aging buckets for visualization
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_debt_aging_analysis(
  p_company_id TEXT,
  p_store_id TEXT DEFAULT NULL,
  p_viewpoint TEXT DEFAULT 'company'
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
  v_result JSON;
BEGIN
  WITH aging_buckets AS (
    SELECT
      COALESCE(SUM(CASE 
        WHEN dr.due_date >= NOW() OR dr.payment_status = 'paid' THEN dr.amount 
        ELSE 0 
      END), 0) AS current,
      COALESCE(SUM(CASE 
        WHEN dr.due_date < NOW() 
          AND dr.due_date >= NOW() - INTERVAL '30 days'
          AND dr.payment_status != 'paid' 
        THEN dr.amount 
        ELSE 0 
      END), 0) AS overdue30,
      COALESCE(SUM(CASE 
        WHEN dr.due_date < NOW() - INTERVAL '30 days' 
          AND dr.due_date >= NOW() - INTERVAL '60 days'
          AND dr.payment_status != 'paid' 
        THEN dr.amount 
        ELSE 0 
      END), 0) AS overdue60,
      COALESCE(SUM(CASE 
        WHEN dr.due_date < NOW() - INTERVAL '60 days'
          AND dr.payment_status != 'paid' 
        THEN dr.amount 
        ELSE 0 
      END), 0) AS overdue90
    FROM debts_receivable dr
    WHERE dr.company_id = p_company_id
      AND (p_store_id IS NULL OR dr.store_id = p_store_id)
      AND dr.debt_type = 'receivable'
      AND dr.is_deleted = false
  )
  SELECT json_build_object(
    'current', ab.current,
    'overdue30', ab.overdue30,
    'overdue60', ab.overdue60,
    'overdue90', ab.overdue90,
    'trend', '[]'::json -- Empty array for trend data (can be populated later)
  ) INTO v_result
  FROM aging_buckets ab;
  
  RETURN v_result;
END;
$$;

-- ============================================================================
-- 3. Prioritized Debts Function
-- Returns risk-prioritized list of debts with scoring
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_prioritized_debts(
  p_company_id TEXT,
  p_store_id TEXT DEFAULT NULL,
  p_viewpoint TEXT DEFAULT 'company',
  p_filter TEXT DEFAULT 'all',
  p_limit INT DEFAULT 100,
  p_offset INT DEFAULT 0
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
  v_result JSON;
BEGIN
  WITH prioritized_list AS (
    SELECT
      dr.debt_id AS id,
      dr.counterparty_id,
      cp.name AS counterparty_name,
      CASE 
        WHEN cp.is_internal THEN 'internal'
        WHEN cp.counterparty_type = 'customer' THEN 'customer'
        WHEN cp.counterparty_type = 'vendor' THEN 'vendor'
        ELSE 'other'
      END AS counterparty_type,
      dr.amount,
      dr.currency,
      dr.due_date,
      CASE 
        WHEN dr.payment_status = 'paid' THEN 0
        WHEN dr.due_date >= NOW() THEN 0
        ELSE EXTRACT(DAY FROM (NOW() - dr.due_date))
      END AS days_overdue,
      -- Risk category based on days overdue
      CASE
        WHEN dr.payment_status = 'paid' THEN 'current'
        WHEN dr.due_date >= NOW() THEN 'current'
        WHEN dr.due_date >= NOW() - INTERVAL '30 days' THEN 'watch'
        WHEN dr.due_date >= NOW() - INTERVAL '60 days' THEN 'attention'
        ELSE 'critical'
      END AS risk_category,
      -- Priority score (0-100, higher = more urgent)
      CASE
        WHEN dr.payment_status = 'paid' THEN 0
        WHEN dr.due_date >= NOW() THEN 10
        WHEN dr.due_date >= NOW() - INTERVAL '30 days' THEN 40
        WHEN dr.due_date >= NOW() - INTERVAL '60 days' THEN 70
        ELSE 100
      END AS priority_score,
      dr.last_contact_date,
      dr.last_contact_type,
      dr.payment_status,
      '[]'::json AS suggested_actions,
      '[]'::json AS recent_transactions,
      COALESCE(dr.has_payment_plan, false) AS has_payment_plan,
      COALESCE(dr.is_disputed, false) AS is_disputed,
      dr.metadata
    FROM debts_receivable dr
    LEFT JOIN counterparties cp ON dr.counterparty_id = cp.counterparty_id
    WHERE dr.company_id = p_company_id
      AND (p_store_id IS NULL OR dr.store_id = p_store_id)
      AND dr.is_deleted = false
      AND (
        p_filter = 'all' OR
        (p_filter = 'group' AND cp.is_internal = true) OR
        (p_filter = 'external' AND cp.is_internal = false)
      )
    ORDER BY priority_score DESC, dr.amount DESC
    LIMIT p_limit
    OFFSET p_offset
  )
  SELECT json_agg(
    json_build_object(
      'id', pl.id,
      'counterpartyId', pl.counterparty_id,
      'counterpartyName', pl.counterparty_name,
      'counterpartyType', pl.counterparty_type,
      'amount', pl.amount,
      'currency', pl.currency,
      'dueDate', pl.due_date,
      'daysOverdue', pl.days_overdue,
      'riskCategory', pl.risk_category,
      'priorityScore', pl.priority_score,
      'lastContactDate', pl.last_contact_date,
      'lastContactType', pl.last_contact_type,
      'paymentStatus', pl.payment_status,
      'suggestedActions', pl.suggested_actions,
      'recentTransactions', pl.recent_transactions,
      'hasPaymentPlan', pl.has_payment_plan,
      'isDisputed', pl.is_disputed,
      'metadata', pl.metadata
    )
  ) INTO v_result
  FROM prioritized_list pl;
  
  RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- ============================================================================
-- 4. Critical Alerts Function (Alternative approach)
-- Since the query is failing, let's create a simpler version
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_debt_critical_alerts(
  p_company_id TEXT,
  p_store_id TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
  v_result JSON;
BEGIN
  WITH alerts AS (
    -- Critical overdue debts
    SELECT 
      'overdue_critical' AS type,
      'Critical debts overdue > 90 days' AS message,
      COUNT(*) AS count,
      'critical' AS severity
    FROM debts_receivable
    WHERE company_id = p_company_id
      AND (p_store_id IS NULL OR store_id = p_store_id)
      AND debt_type = 'receivable'
      AND payment_status != 'paid'
      AND due_date < NOW() - INTERVAL '90 days'
      AND is_deleted = false
    HAVING COUNT(*) > 0
    
    UNION ALL
    
    -- Recent payments received
    SELECT 
      'payment_received' AS type,
      'Payments received in last 7 days' AS message,
      COUNT(*) AS count,
      'info' AS severity
    FROM debts_receivable
    WHERE company_id = p_company_id
      AND (p_store_id IS NULL OR store_id = p_store_id)
      AND debt_type = 'receivable'
      AND payment_status = 'paid'
      AND payment_date > NOW() - INTERVAL '7 days'
      AND is_deleted = false
    HAVING COUNT(*) > 0
    
    UNION ALL
    
    -- Disputed items
    SELECT 
      'dispute_pending' AS type,
      'Disputed items requiring attention' AS message,
      COUNT(*) AS count,
      'warning' AS severity
    FROM debts_receivable
    WHERE company_id = p_company_id
      AND (p_store_id IS NULL OR store_id = p_store_id)
      AND is_disputed = true
      AND payment_status != 'paid'
      AND is_deleted = false
    HAVING COUNT(*) > 0
  )
  SELECT json_agg(
    json_build_object(
      'id', md5(a.type || a.message)::text,
      'type', a.type,
      'message', a.message,
      'count', a.count,
      'severity', a.severity,
      'isRead', false,
      'createdAt', NOW()
    )
  ) INTO v_result
  FROM alerts a;
  
  RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- ============================================================================
-- 5. Add missing columns to debts_receivable if they don't exist
-- ============================================================================

-- First check if the table uses 'id' or 'debt_id' as primary key
DO $$
BEGIN
  -- If 'id' column exists but 'debt_id' doesn't, rename it
  IF EXISTS (SELECT 1 FROM information_schema.columns 
             WHERE table_name = 'debts_receivable' 
             AND column_name = 'id')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns 
                     WHERE table_name = 'debts_receivable' 
                     AND column_name = 'debt_id') THEN
    -- Add debt_id as an alias or rename the column
    ALTER TABLE debts_receivable RENAME COLUMN id TO debt_id;
  END IF;
END $$;

-- Add debt_type column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'debt_type') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN debt_type VARCHAR(20) DEFAULT 'receivable' 
    CHECK (debt_type IN ('receivable', 'payable'));
  END IF;
END $$;

-- Add payment_status column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'payment_status') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN payment_status VARCHAR(20) DEFAULT 'pending'
    CHECK (payment_status IN ('pending', 'partial', 'paid', 'overdue'));
  END IF;
END $$;

-- Add payment_date column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'payment_date') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN payment_date TIMESTAMP;
  END IF;
END $$;

-- Add last_contact_date column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'last_contact_date') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN last_contact_date TIMESTAMP;
  END IF;
END $$;

-- Add last_contact_type column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'last_contact_type') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN last_contact_type VARCHAR(50);
  END IF;
END $$;

-- Add has_payment_plan column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'has_payment_plan') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN has_payment_plan BOOLEAN DEFAULT false;
  END IF;
END $$;

-- Add is_disputed column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'is_disputed') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN is_disputed BOOLEAN DEFAULT false;
  END IF;
END $$;

-- Add metadata column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'metadata') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN metadata JSONB;
  END IF;
END $$;

-- Add currency column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'currency') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN currency VARCHAR(3) DEFAULT 'VND';
  END IF;
END $$;

-- Add is_deleted column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'is_deleted') THEN
    ALTER TABLE debts_receivable 
    ADD COLUMN is_deleted BOOLEAN DEFAULT false;
  END IF;
END $$;

-- ============================================================================
-- 6. Grant permissions
-- ============================================================================
GRANT EXECUTE ON FUNCTION public.get_debt_kpi_metrics TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_debt_aging_analysis TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_prioritized_debts TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_debt_critical_alerts TO authenticated;

-- ============================================================================
-- 7. Create sample test data (optional - remove in production)
-- ============================================================================
-- Uncomment the following to insert sample data for testing

/*
INSERT INTO debts_receivable (
  debt_id, company_id, store_id, counterparty_id, 
  amount, currency, due_date, debt_type, payment_status,
  description, created_at
)
SELECT 
  gen_random_uuid(),
  (SELECT company_id FROM companies LIMIT 1),
  (SELECT store_id FROM stores LIMIT 1),
  cp.counterparty_id,
  (random() * 10000000)::numeric(15,2),
  'VND',
  NOW() - (random() * 180 || ' days')::interval,
  CASE WHEN random() > 0.5 THEN 'receivable' ELSE 'payable' END,
  CASE 
    WHEN random() < 0.3 THEN 'paid'
    WHEN random() < 0.6 THEN 'pending'
    WHEN random() < 0.8 THEN 'partial'
    ELSE 'overdue'
  END,
  'Sample debt for testing',
  NOW()
FROM counterparties cp
LIMIT 20
ON CONFLICT DO NOTHING;
*/

-- ============================================================================
-- Verification Query
-- Run this to check if functions were created successfully
-- ============================================================================
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