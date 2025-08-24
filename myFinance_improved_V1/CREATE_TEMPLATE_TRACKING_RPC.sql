-- =====================================================
-- CREATE TEMPLATE TRACKING RPC FUNCTION
-- Run this in Supabase SQL Editor
-- =====================================================

-- First, check if the table exists
CREATE TABLE IF NOT EXISTS transaction_templates_preferences (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID DEFAULT auth.uid() NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL,
  template_id UUID NOT NULL,
  template_name VARCHAR(255) NOT NULL,
  template_type VARCHAR(100),
  usage_type VARCHAR(50) DEFAULT 'used',
  used_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  metadata JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_template_preferences_user_company 
  ON transaction_templates_preferences(user_id, company_id);
CREATE INDEX IF NOT EXISTS idx_template_preferences_template 
  ON transaction_templates_preferences(template_id);
CREATE INDEX IF NOT EXISTS idx_template_preferences_used_at 
  ON transaction_templates_preferences(used_at DESC);

-- Create the RPC function to log template usage
CREATE OR REPLACE FUNCTION log_template_usage(
  p_template_id UUID,
  p_template_name TEXT,
  p_company_id UUID,
  p_template_type TEXT DEFAULT NULL,
  p_usage_type TEXT DEFAULT 'used',
  p_metadata JSONB DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Insert the template usage record
  INSERT INTO transaction_templates_preferences (
    user_id,
    company_id,
    template_id,
    template_name,
    template_type,
    usage_type,
    metadata,
    used_at
  ) VALUES (
    auth.uid(),
    p_company_id,
    p_template_id,
    p_template_name,
    p_template_type,
    p_usage_type,
    p_metadata,
    NOW()
  );
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION log_template_usage TO authenticated;

-- Create the RPC function to get quick access templates
CREATE OR REPLACE FUNCTION get_user_quick_access_templates(
  p_user_id UUID,
  p_company_id UUID,
  p_limit INTEGER DEFAULT 5
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result JSON;
BEGIN
  SELECT JSON_AGG(template_data ORDER BY usage_score DESC, last_used DESC)
  INTO result
  FROM (
    SELECT 
      template_id,
      template_name,
      template_type,
      COUNT(*) AS usage_count,
      MAX(used_at) AS last_used,
      -- Calculate usage score with recency bonus
      COUNT(*) + 
      CASE 
        WHEN MAX(used_at) > NOW() - INTERVAL '7 days' THEN 10
        WHEN MAX(used_at) > NOW() - INTERVAL '30 days' THEN 5
        WHEN MAX(used_at) > NOW() - INTERVAL '90 days' THEN 2
        ELSE 0
      END AS usage_score
    FROM transaction_templates_preferences
    WHERE 
      user_id = p_user_id 
      AND company_id = p_company_id
      AND used_at > NOW() - INTERVAL '180 days'
    GROUP BY template_id, template_name, template_type
    LIMIT p_limit
  ) AS template_data;
  
  RETURN COALESCE(result, '[]'::JSON);
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_user_quick_access_templates TO authenticated;

-- Enable Row Level Security
ALTER TABLE transaction_templates_preferences ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can insert their own template preferences"
  ON transaction_templates_preferences
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own template preferences"
  ON transaction_templates_preferences
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own template preferences"
  ON transaction_templates_preferences
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own template preferences"
  ON transaction_templates_preferences
  FOR DELETE
  USING (auth.uid() = user_id);

-- Test the function (replace with actual values)
-- SELECT log_template_usage(
--   'template-id-here'::UUID,
--   'Template Name',
--   'company-id-here'::UUID,
--   'transaction',
--   'selected',
--   '{"context": "test"}'::JSONB
-- );

-- Check if data is being inserted
-- SELECT * FROM transaction_templates_preferences 
-- WHERE user_id = auth.uid() 
-- ORDER BY used_at DESC 
-- LIMIT 10;