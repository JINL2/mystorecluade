-- Add Smart Debt Control feature to the features table
-- This will make it available in the homepage navigation

-- First, let's check if the feature already exists and insert if it doesn't
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
  (SELECT category_id FROM categories WHERE category_name = 'Finance' LIMIT 1), -- Assumes there's a Finance category
  'debtControl',
  'account_balance_wallet', -- Icon name for debt management
  'Smart debt management with AI-driven insights and risk prioritization',
  true, -- Show on main page
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

-- Add permissions for the debt control feature to all existing roles
-- This ensures users can access the feature based on their role permissions

-- Insert permissions for Owner role (full access)
INSERT INTO role_permissions (
  role_id,
  feature_id,
  can_access,
  created_at
) 
SELECT 
  r.role_id,
  'debt_control',
  true,
  NOW()
FROM roles r 
WHERE r.role_name = 'Owner'
ON CONFLICT (role_id, feature_id) DO UPDATE SET
  can_access = EXCLUDED.can_access,
  updated_at = NOW();

-- Insert permissions for Manager role (full access)
INSERT INTO role_permissions (
  role_id,
  feature_id,
  can_access,
  created_at
) 
SELECT 
  r.role_id,
  'debt_control',
  true,
  NOW()
FROM roles r 
WHERE r.role_name = 'Manager'
ON CONFLICT (role_id, feature_id) DO UPDATE SET
  can_access = EXCLUDED.can_access,
  updated_at = NOW();

-- Insert permissions for Accountant role (full access to financial features)
INSERT INTO role_permissions (
  role_id,
  feature_id,
  can_access,
  created_at
) 
SELECT 
  r.role_id,
  'debt_control',
  true,
  NOW()
FROM roles r 
WHERE r.role_name = 'Accountant'
ON CONFLICT (role_id, feature_id) DO UPDATE SET
  can_access = EXCLUDED.can_access,
  updated_at = NOW();

-- Insert permissions for Employee role (read-only access)
INSERT INTO role_permissions (
  role_id,
  feature_id,
  can_access,
  created_at
) 
SELECT 
  r.role_id,
  'debt_control',
  true, -- Allow access but with limited functionality in the app
  NOW()
FROM roles r 
WHERE r.role_name = 'Employee'
ON CONFLICT (role_id, feature_id) DO UPDATE SET
  can_access = EXCLUDED.can_access,
  updated_at = NOW();

-- Optional: Add to a default category if Finance category doesn't exist
INSERT INTO categories (
  category_id,
  category_name,
  created_at
) VALUES (
  'finance',
  'Finance',
  NOW()
) 
ON CONFLICT (category_id) DO NOTHING;

-- Update the feature to use the finance category if no category was found initially
UPDATE features 
SET category_id = 'finance' 
WHERE feature_id = 'debt_control' 
  AND category_id IS NULL;

-- Verify the insertion
SELECT 
  f.feature_id,
  f.feature_name,
  f.route,
  f.icon,
  f.description,
  f.is_show_main,
  c.category_name
FROM features f
LEFT JOIN categories c ON f.category_id = c.category_id
WHERE f.feature_id = 'debt_control';

-- Show permissions for the new feature
SELECT 
  r.role_name,
  rp.can_access,
  f.feature_name
FROM role_permissions rp
JOIN roles r ON rp.role_id = r.role_id
JOIN features f ON rp.feature_id = f.feature_id
WHERE f.feature_id = 'debt_control'
ORDER BY r.role_name;