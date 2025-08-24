-- =====================================================
-- TEST TEMPLATE TRACKING
-- Run these queries in Supabase SQL Editor to verify tracking
-- =====================================================

-- 1. Check if the table exists and has data
SELECT COUNT(*) as total_records 
FROM transaction_templates_preferences;

-- 2. View recent template usage (last 7 days)
SELECT 
  template_id,
  template_name,
  template_type,
  usage_type,
  used_at,
  metadata,
  company_id
FROM transaction_templates_preferences
WHERE user_id = auth.uid()
ORDER BY used_at DESC
LIMIT 20;

-- 3. Check template usage frequency
SELECT 
  template_id,
  template_name,
  COUNT(*) as usage_count,
  MAX(used_at) as last_used,
  array_agg(DISTINCT usage_type) as usage_types
FROM transaction_templates_preferences
WHERE user_id = auth.uid()
GROUP BY template_id, template_name
ORDER BY usage_count DESC, last_used DESC;

-- 4. Test the quick access function
SELECT * FROM get_user_quick_access_templates(
  auth.uid(),
  '7a2545e0-e112-4b0c-9c59-221a530c4602'::uuid, -- Replace with your company_id
  10
);

-- 5. Debug: Check if function exists
SELECT 
  proname as function_name,
  pronargs as num_arguments
FROM pg_proc 
WHERE proname IN ('log_template_usage', 'get_user_quick_access_templates');

-- 6. Test manual insert to verify permissions
INSERT INTO transaction_templates_preferences (
  user_id,
  company_id,
  template_id,
  template_name,
  template_type,
  usage_type,
  metadata
) VALUES (
  auth.uid(),
  '7a2545e0-e112-4b0c-9c59-221a530c4602'::uuid, -- Replace with your company_id
  gen_random_uuid(),
  'Test Template',
  'transaction',
  'test',
  '{"test": true}'::jsonb
);

-- 7. Check RLS policies
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE tablename = 'transaction_templates_preferences';