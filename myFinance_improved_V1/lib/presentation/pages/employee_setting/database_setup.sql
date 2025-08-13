-- Employee Setting Database Setup
-- Run this in your Supabase SQL editor

-- 1. Create currency_types table if it doesn't exist
CREATE TABLE IF NOT EXISTS currency_types (
  currency_id TEXT PRIMARY KEY,
  currency_name TEXT NOT NULL,
  symbol TEXT NOT NULL,
  decimal_places INTEGER DEFAULT 2,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Insert default currency data (matching actual Supabase data)
INSERT INTO currency_types (currency_id, currency_name, symbol) 
VALUES 
  ('USD', 'US Dollar', '$'),
  ('EUR', 'Euro', '€'),
  ('VND', 'Vietnamese Dong', '₫'),
  ('KRW', 'Korean Won', '₩')
ON CONFLICT (currency_id) DO NOTHING;

-- 3. Create user_salaries table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_salaries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,
  company_id UUID NOT NULL,
  salary_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  salary_type TEXT CHECK (salary_type IN ('monthly', 'hourly')) NOT NULL DEFAULT 'monthly',
  currency_id TEXT REFERENCES currency_types(currency_id) DEFAULT 'USD',
  effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Create user_roles table if it doesn't exist  
CREATE TABLE IF NOT EXISTS user_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,
  company_id UUID NOT NULL,
  role_name TEXT NOT NULL DEFAULT 'Employee',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Create enhanced tables for better employee management
CREATE TABLE IF NOT EXISTS employee_details (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,
  employee_id TEXT,
  department TEXT DEFAULT 'General',
  hire_date DATE,
  work_location TEXT DEFAULT 'Office',
  employment_type TEXT DEFAULT 'Full-time',
  employment_status TEXT DEFAULT 'Active',
  manager_id UUID,
  cost_center TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE TABLE IF NOT EXISTS employee_performance (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,
  performance_rating TEXT,
  last_review_date DATE,
  next_review_date DATE,
  review_notes TEXT,
  previous_salary DECIMAL(12,2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Create the enhanced v_user_salary view
CREATE OR REPLACE VIEW v_user_salary AS
SELECT 
  us.id as salary_id,
  u.id as user_id,
  COALESCE(u.raw_user_meta_data->>'full_name', u.email, 'Unknown User') as full_name,
  u.email,
  u.raw_user_meta_data->>'profile_image' as profile_image,
  COALESCE(ur.role_name, 'Employee') as role_name,
  ur.company_id,
  NULL as store_id, -- Add store_id if you have stores table
  COALESCE(us.salary_amount, 0) as salary_amount,
  COALESCE(us.salary_type, 'monthly') as salary_type,
  COALESCE(us.currency_id, 'USD') as currency_id,
  COALESCE(ct.currency_name, 'US Dollar') as currency_name,
  COALESCE(ct.symbol, '$') as symbol,
  us.effective_date,
  COALESCE(us.is_active, true) as is_active,
  us.updated_at,
  
  -- Enhanced fields from employee_details
  ed.employee_id,
  COALESCE(ed.department, 'General') as department,
  ed.hire_date,
  COALESCE(ed.work_location, 'Office') as work_location,
  COALESCE(ed.employment_type, 'Full-time') as employment_type,
  COALESCE(ed.employment_status, 'Active') as employment_status,
  ed.cost_center,
  manager.raw_user_meta_data->>'full_name' as manager_name,
  
  -- Performance fields
  ep.performance_rating,
  ep.last_review_date,
  ep.next_review_date,
  ep.previous_salary
  
FROM auth.users u
LEFT JOIN user_roles ur ON u.id = ur.user_id AND ur.is_active = true
LEFT JOIN user_salaries us ON u.id = us.user_id AND us.is_active = true
LEFT JOIN currency_types ct ON us.currency_id = ct.currency_id
LEFT JOIN employee_details ed ON u.id = ed.user_id
LEFT JOIN employee_performance ep ON u.id = ep.user_id
LEFT JOIN auth.users manager ON ed.manager_id = manager.id
WHERE u.email IS NOT NULL;

-- 6. Create RPC function for updating salaries
CREATE OR REPLACE FUNCTION update_user_salary(
  p_salary_id UUID,
  p_salary_amount DECIMAL,
  p_salary_type TEXT,
  p_currency_id TEXT,
  p_user_id UUID DEFAULT NULL
) RETURNS JSON AS $$
DECLARE
  v_result JSON;
BEGIN
  -- Update salary
  UPDATE user_salaries
  SET 
    salary_amount = p_salary_amount,
    salary_type = p_salary_type,
    currency_id = p_currency_id,
    updated_at = NOW()
  WHERE id = p_salary_id
  RETURNING to_json(user_salaries.*) INTO v_result;
  
  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Insert sample data for testing (optional)
-- First, let's create a sample user salary record
-- You'll need to replace 'your-user-id' and 'your-company-id' with actual values

/*
-- Sample data - uncomment and modify these with real IDs
INSERT INTO user_roles (user_id, company_id, role_name) 
VALUES 
  ('your-user-id', 'your-company-id', 'Manager')
ON CONFLICT DO NOTHING;

INSERT INTO user_salaries (user_id, company_id, salary_amount, salary_type, currency_id) 
VALUES 
  ('your-user-id', 'your-company-id', 50000.00, 'monthly', 'USD')
ON CONFLICT DO NOTHING;
*/

-- 8. Set up Row Level Security (RLS) policies
ALTER TABLE currency_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_salaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- Allow read access to currency_types for authenticated users
CREATE POLICY "Allow read access to currency_types" ON currency_types
  FOR SELECT
  TO authenticated
  USING (true);

-- Allow users to view salaries for their company
CREATE POLICY "Allow users to view company salaries" ON user_salaries
  FOR SELECT
  TO authenticated
  USING (
    company_id IN (
      SELECT company_id FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role_name IN ('admin', 'manager', 'owner')
    )
  );

-- Allow users to update salaries in their company  
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

-- Allow users to view roles for their company
CREATE POLICY "Allow users to view company roles" ON user_roles
  FOR SELECT
  TO authenticated
  USING (
    company_id IN (
      SELECT company_id FROM user_roles 
      WHERE user_id = auth.uid() 
      AND role_name IN ('admin', 'manager', 'owner')
    ) OR user_id = auth.uid()
  );

-- 9. Insert sample employee details and performance data for testing
/*
-- Sample employee details - uncomment and modify with real user IDs
INSERT INTO employee_details (user_id, employee_id, department, hire_date, work_location, employment_type, employment_status) VALUES
  ('your-user-id-1', 'EMP001', 'Engineering', '2023-01-15', 'Remote', 'Full-time', 'Active'),
  ('your-user-id-2', 'EMP002', 'Marketing', '2022-06-01', 'Office', 'Full-time', 'Active'),
  ('your-user-id-3', 'EMP003', 'Sales', '2023-03-20', 'Hybrid', 'Full-time', 'Active')
ON CONFLICT (user_id) DO UPDATE SET
  employee_id = EXCLUDED.employee_id,
  department = EXCLUDED.department,
  hire_date = EXCLUDED.hire_date,
  work_location = EXCLUDED.work_location,
  employment_type = EXCLUDED.employment_type,
  employment_status = EXCLUDED.employment_status;

-- Sample performance data
INSERT INTO employee_performance (user_id, performance_rating, last_review_date, next_review_date, previous_salary) VALUES
  ('your-user-id-1', 'A+', '2023-12-15', '2024-12-15', 45000.00),
  ('your-user-id-2', 'A', '2023-11-01', '2024-11-01', 35000.00),
  ('your-user-id-3', 'B', '2023-10-20', '2024-10-20', 40000.00)
ON CONFLICT (user_id) DO UPDATE SET
  performance_rating = EXCLUDED.performance_rating,
  last_review_date = EXCLUDED.last_review_date,
  next_review_date = EXCLUDED.next_review_date,
  previous_salary = EXCLUDED.previous_salary;
*/

-- Test the enhanced view
SELECT * FROM v_user_salary LIMIT 5;