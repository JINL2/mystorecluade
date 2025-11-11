-- Migration: Auto-create user profile on auth signup
-- Purpose: Ensures data integrity between auth.users and public.users
-- Created: 2025-11-11

-- ============================================================================
-- Function: handle_new_user
-- ============================================================================
-- Automatically creates a user profile in public.users when a new user signs up
-- This prevents data inconsistency where auth account exists but profile doesn't

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  -- Insert new user profile
  INSERT INTO public.users (
    user_id,
    email,
    first_name,
    last_name,
    created_at,
    updated_at,
    preferred_timezone,
    is_email_verified
  )
  VALUES (
    new.id,                                          -- Auth user ID
    new.email,                                       -- Email from auth
    new.raw_user_meta_data->>'first_name',          -- From signup metadata
    new.raw_user_meta_data->>'last_name',           -- From signup metadata
    now(),                                           -- Creation timestamp
    now(),                                           -- Update timestamp
    COALESCE(
      new.raw_user_meta_data->>'timezone',
      'Asia/Ho_Chi_Minh'                            -- Default timezone for Vietnam
    ),
    new.email_confirmed_at IS NOT NULL               -- Email verification status
  )
  ON CONFLICT (user_id) DO UPDATE SET
    email = EXCLUDED.email,
    is_email_verified = EXCLUDED.is_email_verified,
    updated_at = now();

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- Trigger: on_auth_user_created
-- ============================================================================
-- Fires after user signup in auth.users

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================================================
-- Verification Query
-- ============================================================================
-- Run this to verify the trigger works:
--
-- SELECT trigger_name, event_manipulation, event_object_table
-- FROM information_schema.triggers
-- WHERE trigger_name = 'on_auth_user_created';

-- ============================================================================
-- Rollback (if needed)
-- ============================================================================
-- DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
-- DROP FUNCTION IF EXISTS public.handle_new_user();
