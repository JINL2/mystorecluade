-- Fix FCM Token Table RLS Policies
-- Run this in Supabase SQL Editor to fix permission issues

-- First, check if the table exists
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'user_fcm_tokens'
) as table_exists;

-- Check current RLS status
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public' 
AND tablename = 'user_fcm_tokens';

-- Enable RLS on the table (if not already enabled)
ALTER TABLE public.user_fcm_tokens ENABLE ROW LEVEL SECURITY;

-- Drop existing policies (if any) to start fresh
DROP POLICY IF EXISTS "Users can view their own fcm tokens" ON public.user_fcm_tokens;
DROP POLICY IF EXISTS "Users can insert their own fcm tokens" ON public.user_fcm_tokens;
DROP POLICY IF EXISTS "Users can update their own fcm tokens" ON public.user_fcm_tokens;
DROP POLICY IF EXISTS "Users can delete their own fcm tokens" ON public.user_fcm_tokens;

-- Create comprehensive RLS policies
-- 1. Users can view their own tokens
CREATE POLICY "Users can view their own fcm tokens"
ON public.user_fcm_tokens
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- 2. Users can insert their own tokens
CREATE POLICY "Users can insert their own fcm tokens"
ON public.user_fcm_tokens
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- 3. Users can update their own tokens
CREATE POLICY "Users can update their own fcm tokens"
ON public.user_fcm_tokens
FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- 4. Users can delete their own tokens
CREATE POLICY "Users can delete their own fcm tokens"
ON public.user_fcm_tokens
FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

-- Verify the policies were created
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public' 
AND tablename = 'user_fcm_tokens'
ORDER BY policyname;

-- Test query to see if authenticated users can access the table
-- This will show the current user's tokens (if any)
SELECT 
    id,
    user_id,
    platform,
    is_active,
    created_at,
    updated_at
FROM public.user_fcm_tokens
WHERE user_id = auth.uid()
LIMIT 5;

-- Check if all required columns exist
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'user_fcm_tokens'
ORDER BY ordinal_position;

-- If any columns are missing, add them:
-- (Uncomment and run these if needed)

-- Add missing columns if they don't exist
/*
ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS id UUID DEFAULT gen_random_uuid() PRIMARY KEY;

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS token TEXT NOT NULL;

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS platform VARCHAR(20);

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS device_id VARCHAR(255);

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS device_model VARCHAR(255);

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS app_version VARCHAR(50);

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

ALTER TABLE public.user_fcm_tokens 
ADD COLUMN IF NOT EXISTS last_used_at TIMESTAMPTZ DEFAULT NOW();
*/

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_user_id 
ON public.user_fcm_tokens(user_id);

CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_active 
ON public.user_fcm_tokens(user_id, is_active) 
WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_platform 
ON public.user_fcm_tokens(user_id, platform);

-- Grant necessary permissions
GRANT ALL ON public.user_fcm_tokens TO authenticated;
GRANT USAGE ON SEQUENCE user_fcm_tokens_id_seq TO authenticated;

-- Final verification
SELECT 
    'Table exists' as check_item,
    EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'user_fcm_tokens'
    ) as status
UNION ALL
SELECT 
    'RLS enabled' as check_item,
    rowsecurity as status
FROM pg_tables
WHERE schemaname = 'public' 
AND tablename = 'user_fcm_tokens'
UNION ALL
SELECT 
    'Policies exist' as check_item,
    COUNT(*) > 0 as status
FROM pg_policies
WHERE schemaname = 'public' 
AND tablename = 'user_fcm_tokens';

-- Success message
SELECT 'RLS policies have been configured successfully!' as message;