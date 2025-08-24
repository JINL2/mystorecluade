-- Test script to verify get_user_quick_access_features function

-- First, let's test the function with a sample user_id and company_id
-- Replace these values with actual IDs from your database
SELECT get_user_quick_access_features(
    'your-user-id-here'::UUID,  -- Replace with actual user UUID
    'your-company-id-here'      -- Replace with actual company ID
) as quick_access_features;

-- Check if the function exists
SELECT proname, proargnames, prosrc
FROM pg_proc
WHERE proname = 'get_user_quick_access_features';

-- Check if top_features_by_user view exists
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_name = 'top_features_by_user';

-- Check user_preferences table structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'user_preferences'
ORDER BY ordinal_position;

-- Check features table structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'features'
WHERE table_name = 'features'
ORDER BY ordinal_position;

-- Sample features that should be available (check what features exist)
SELECT feature_id, feature_name, route, is_show_main, icon_key, category_id
FROM features
WHERE is_show_main = true
AND route IS NOT NULL
AND route != ''
ORDER BY feature_name
LIMIT 10;