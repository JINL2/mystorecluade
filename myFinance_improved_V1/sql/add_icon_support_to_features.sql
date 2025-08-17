-- Add icon support to features table
-- This migration adds icon_key and icon_url columns to support flexible icon management

-- Add icon columns if they don't exist
ALTER TABLE features 
ADD COLUMN IF NOT EXISTS icon_key TEXT,
ADD COLUMN IF NOT EXISTS icon_url TEXT;

-- Add comments for documentation
COMMENT ON COLUMN features.icon_key IS 'Key mapping to local app icons (e.g., dashboard, attendance, reports)';
COMMENT ON COLUMN features.icon_url IS 'Optional URL for custom/remote icons (overrides icon_key if provided)';

-- Update existing features with default icon keys
UPDATE features SET icon_key = 
  CASE 
    WHEN LOWER(name) LIKE '%dashboard%' THEN 'dashboard'
    WHEN LOWER(name) LIKE '%attendance%' THEN 'attendance'
    WHEN LOWER(name) LIKE '%inventory%' THEN 'inventory'
    WHEN LOWER(name) LIKE '%transaction%' THEN 'transactions'
    WHEN LOWER(name) LIKE '%report%' THEN 'reports'
    WHEN LOWER(name) LIKE '%employee%' THEN 'employees'
    WHEN LOWER(name) LIKE '%setting%' THEN 'settings'
    WHEN LOWER(name) LIKE '%analytic%' THEN 'analytics'
    ELSE 'dashboard'
  END
WHERE icon_key IS NULL;

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_features_icon_key ON features(icon_key);

-- Sample data for testing
/*
INSERT INTO features (name, route, icon_key, is_active) VALUES
  ('Dashboard', '/dashboard', 'dashboard', true),
  ('Attendance', '/attendance', 'attendance', true),
  ('Inventory', '/inventory', 'inventory', true),
  ('Transactions', '/transactions', 'transactions', true),
  ('Reports', '/reports', 'reports', true),
  ('Employee Settings', '/employeeSettings', 'employees', true),
  ('Settings', '/settings', 'settings', true)
ON CONFLICT (route) DO UPDATE 
SET icon_key = EXCLUDED.icon_key;
*/