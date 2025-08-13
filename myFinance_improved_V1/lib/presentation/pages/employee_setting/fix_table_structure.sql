-- Fix user_salaries table structure to match your actual Supabase table
-- Run this in your Supabase SQL editor

-- Drop the existing table if needed (CAUTION: This will delete all data)
-- DROP TABLE IF EXISTS user_salaries CASCADE;

-- Create the table with salary_id as primary key (matching your actual table)
CREATE TABLE IF NOT EXISTS user_salaries (
  salary_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,
  company_id UUID NOT NULL,
  salary_amount NUMERIC NOT NULL DEFAULT 0,
  salary_type TEXT CHECK (salary_type IN ('monthly', 'hourly')) NOT NULL DEFAULT 'monthly',
  bonus_amount NUMERIC DEFAULT 0,
  account_id UUID,
  edited_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  currency_id TEXT REFERENCES currency_types(currency_id) DEFAULT 'USD'
);

-- Update the view to use the correct column name
CREATE OR REPLACE VIEW v_user_salary AS
SELECT 
  us.salary_id as salary_id,
  u.id as user_id,
  COALESCE(u.raw_user_meta_data->>'full_name', u.email, 'Unknown User') as full_name,
  u.email,
  u.raw_user_meta_data->>'profile_image' as profile_image,
  COALESCE(ur.role_name, 'Employee') as role_name,
  ur.company_id,
  NULL as store_id,
  COALESCE(us.salary_amount, 0) as salary_amount,
  COALESCE(us.salary_type, 'monthly') as salary_type,
  COALESCE(us.currency_id, 'USD') as currency_id,
  COALESCE(ct.currency_name, 'US Dollar') as currency_name,
  COALESCE(ct.symbol, '$') as symbol,
  us.created_at as effective_date,
  true as is_active,
  us.updated_at,
  
  -- Enhanced fields (set to defaults since they don't exist in your table)
  NULL as employee_id,
  'General' as department,
  NULL as hire_date,
  'Office' as work_location,
  'Full-time' as employment_type,
  'Active' as employment_status,
  NULL as cost_center,
  NULL as manager_name,
  
  -- Performance fields
  NULL as performance_rating,
  NULL as last_review_date,
  NULL as next_review_date,
  NULL as previous_salary
  
FROM auth.users u
LEFT JOIN user_roles ur ON u.id = ur.user_id AND ur.is_active = true
LEFT JOIN user_salaries us ON u.id = us.user_id
LEFT JOIN currency_types ct ON us.currency_id = ct.currency_id
WHERE u.email IS NOT NULL;

-- Test the structure
SELECT 'Testing updated table structure:' as test;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'user_salaries' 
ORDER BY ordinal_position;