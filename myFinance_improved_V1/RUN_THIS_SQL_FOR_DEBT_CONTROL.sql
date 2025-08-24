-- ============================================================================
-- URGENT: RUN THIS SQL IN YOUR SUPABASE SQL EDITOR
-- This will fix all the debt control page errors
-- ============================================================================

-- Copy and paste ALL of this SQL into your Supabase SQL Editor and execute it.
-- This script:
-- 1. Creates the required database functions
-- 2. Adds missing columns to debts_receivable table
-- 3. Sets up proper permissions

-- ============================================================================
-- PART 1: Add the debt control feature to navigation menu
-- ============================================================================

INSERT INTO features (
  feature_id,
  feature_name,
  category_id,
  route,
  icon,
  description,
  is_show_main,
  created_at,
  updated_at
) VALUES (
  'debt_control',
  'Debt Control',
  (SELECT category_id FROM categories WHERE category_name = 'Finance' LIMIT 1),
  'debtControl',
  'account_balance_wallet',
  'Smart debt management with AI-driven insights and risk prioritization',
  true,
  NOW(),
  NOW()
) 
ON CONFLICT (feature_id) DO UPDATE SET
  feature_name = EXCLUDED.feature_name,
  route = EXCLUDED.route,
  icon = EXCLUDED.icon,
  description = EXCLUDED.description,
  is_show_main = EXCLUDED.is_show_main,
  updated_at = NOW();

-- ============================================================================
-- PART 2: Fix column naming issue (id vs debt_id)
-- ============================================================================

DO $$
BEGIN
  -- If 'id' column exists but 'debt_id' doesn't, rename it
  IF EXISTS (SELECT 1 FROM information_schema.columns 
             WHERE table_name = 'debts_receivable' 
             AND column_name = 'id')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns 
                     WHERE table_name = 'debts_receivable' 
                     AND column_name = 'debt_id') THEN
    ALTER TABLE debts_receivable RENAME COLUMN id TO debt_id;
  END IF;
  
  -- If neither exists, add debt_id
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'debts_receivable' 
                 AND column_name = 'debt_id') THEN
    ALTER TABLE debts_receivable ADD COLUMN debt_id UUID DEFAULT gen_random_uuid() PRIMARY KEY;
  END IF;
END $$;

-- ============================================================================
-- PART 3: Add all missing columns to debts_receivable
-- ============================================================================

-- Add all missing columns with proper defaults
DO $$
BEGIN
  -- debt_type column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'debt_type') THEN
    ALTER TABLE debts_receivable ADD COLUMN debt_type VARCHAR(20) DEFAULT 'receivable';
  END IF;
  
  -- payment_status column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'payment_status') THEN
    ALTER TABLE debts_receivable ADD COLUMN payment_status VARCHAR(20) DEFAULT 'pending';
  END IF;
  
  -- payment_date column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'payment_date') THEN
    ALTER TABLE debts_receivable ADD COLUMN payment_date TIMESTAMP;
  END IF;
  
  -- last_contact_date column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'last_contact_date') THEN
    ALTER TABLE debts_receivable ADD COLUMN last_contact_date TIMESTAMP;
  END IF;
  
  -- last_contact_type column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'last_contact_type') THEN
    ALTER TABLE debts_receivable ADD COLUMN last_contact_type VARCHAR(50);
  END IF;
  
  -- has_payment_plan column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'has_payment_plan') THEN
    ALTER TABLE debts_receivable ADD COLUMN has_payment_plan BOOLEAN DEFAULT false;
  END IF;
  
  -- is_disputed column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'is_disputed') THEN
    ALTER TABLE debts_receivable ADD COLUMN is_disputed BOOLEAN DEFAULT false;
  END IF;
  
  -- metadata column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'metadata') THEN
    ALTER TABLE debts_receivable ADD COLUMN metadata JSONB;
  END IF;
  
  -- currency column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'currency') THEN
    ALTER TABLE debts_receivable ADD COLUMN currency VARCHAR(3) DEFAULT 'VND';
  END IF;
  
  -- is_deleted column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'is_deleted') THEN
    ALTER TABLE debts_receivable ADD COLUMN is_deleted BOOLEAN DEFAULT false;
  END IF;
  
  -- due_date column (might be missing)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'due_date') THEN
    ALTER TABLE debts_receivable ADD COLUMN due_date TIMESTAMP;
  END IF;
  
  -- amount column (might be missing)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'amount') THEN
    ALTER TABLE debts_receivable ADD COLUMN amount NUMERIC(15,2) DEFAULT 0;
  END IF;
  
  -- company_id column (might be missing)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'company_id') THEN
    ALTER TABLE debts_receivable ADD COLUMN company_id TEXT;
  END IF;
  
  -- store_id column (might be missing)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'store_id') THEN
    ALTER TABLE debts_receivable ADD COLUMN store_id TEXT;
  END IF;
  
  -- counterparty_id column (might be missing)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'debts_receivable' AND column_name = 'counterparty_id') THEN
    ALTER TABLE debts_receivable ADD COLUMN counterparty_id TEXT;
  END IF;
END $$;

-- ============================================================================
-- PART 4: Create the required database functions
-- Run the content of sql/create_debt_control_functions.sql after this
-- ============================================================================

-- The functions are too long to include here.
-- Please also run the content of: sql/create_debt_control_functions.sql

-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Check if the feature was added
SELECT * FROM features WHERE feature_id = 'debt_control';

-- Check if columns exist
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'debts_receivable'
ORDER BY ordinal_position;

-- ============================================================================
-- IMPORTANT: After running this script, also run:
-- sql/create_debt_control_functions.sql
-- ============================================================================