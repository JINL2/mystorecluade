-- Setup RLS Policies for user_salaries table
-- Run this in your Supabase SQL editor to ensure proper permissions

-- Enable RLS on user_salaries table
ALTER TABLE user_salaries ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Allow users to view company salaries" ON user_salaries;
DROP POLICY IF EXISTS "Allow users to update company salaries" ON user_salaries;

-- Create policy to allow users to view salaries in their company
CREATE POLICY "Allow users to view company salaries" ON user_salaries
  FOR SELECT
  TO authenticated
  USING (
    company_id IN (
      SELECT company_id FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role_name IN ('admin', 'manager', 'owner', 'Employee')
    )
  );

-- Create policy to allow users to update salaries in their company
CREATE POLICY "Allow users to update company salaries" ON user_salaries
  FOR UPDATE
  TO authenticated
  USING (
    company_id IN (
      SELECT company_id FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role_name IN ('admin', 'manager', 'owner')
    )
  );

-- Also ensure currency_types table can be read
ALTER TABLE currency_types ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow read access to currency_types" ON currency_types;

CREATE POLICY "Allow read access to currency_types" ON currency_types
  FOR SELECT
  TO authenticated
  USING (is_active = true);

-- Test the policies by checking what data is accessible
SELECT 'Testing currency access:' as test;
SELECT * FROM currency_types WHERE is_active = true;

SELECT 'Testing salary access:' as test;
SELECT id, user_id, salary_amount, salary_type, currency_id FROM user_salaries LIMIT 3;