-- Migration: Add UTC and local time columns to shift_requests
-- Phase 1: Preparation for global timezone support
-- Date: 2025-11-24
--
-- Purpose: Add new columns to support both UTC time (for global consistency)
--          and local time (for shift validation against store_shifts.start_time)
--
-- Strategy: Two-column approach
-- - *_utc columns: Store time in UTC with timezone info (timestamptz)
-- - *_local columns: Store time in company's local timezone (time only)
--
-- This allows:
-- 1. Global consistency (UTC storage)
-- 2. Shift validation (local time comparison)
-- 3. Backward compatibility (old columns remain during transition)

BEGIN;

-- ============================================================================
-- Step 1: Add new columns to shift_requests
-- ============================================================================

-- Add UTC timestamp columns (timestamptz for global support)
ALTER TABLE shift_requests
ADD COLUMN IF NOT EXISTS actual_start_time_utc timestamptz,
ADD COLUMN IF NOT EXISTS actual_end_time_utc timestamptz,
ADD COLUMN IF NOT EXISTS start_time_utc timestamptz,
ADD COLUMN IF NOT EXISTS end_time_utc timestamptz,
ADD COLUMN IF NOT EXISTS confirm_start_time_utc timestamptz,
ADD COLUMN IF NOT EXISTS confirm_end_time_utc timestamptz;

-- Add local time columns (time for shift validation)
ALTER TABLE shift_requests
ADD COLUMN IF NOT EXISTS actual_start_time_local time,
ADD COLUMN IF NOT EXISTS actual_end_time_local time,
ADD COLUMN IF NOT EXISTS start_time_local time,
ADD COLUMN IF NOT EXISTS end_time_local time,
ADD COLUMN IF NOT EXISTS confirm_start_time_local time,
ADD COLUMN IF NOT EXISTS confirm_end_time_local time;

-- ============================================================================
-- Step 2: Add indexes for performance
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_shift_requests_actual_start_time_utc
ON shift_requests(actual_start_time_utc);

CREATE INDEX IF NOT EXISTS idx_shift_requests_actual_end_time_utc
ON shift_requests(actual_end_time_utc);

CREATE INDEX IF NOT EXISTS idx_shift_requests_start_time_utc
ON shift_requests(start_time_utc);

CREATE INDEX IF NOT EXISTS idx_shift_requests_end_time_utc
ON shift_requests(end_time_utc);

-- ============================================================================
-- Step 3: Add comments for documentation
-- ============================================================================

COMMENT ON COLUMN shift_requests.actual_start_time_utc IS
'Actual check-in time in UTC (new column for global support). Use this for data storage and international consistency.';

COMMENT ON COLUMN shift_requests.actual_start_time_local IS
'Actual check-in time in company local timezone (for shift validation). Automatically calculated from actual_start_time_utc by trigger.';

COMMENT ON COLUMN shift_requests.actual_end_time_utc IS
'Actual check-out time in UTC (new column for global support). Use this for data storage and international consistency.';

COMMENT ON COLUMN shift_requests.actual_end_time_local IS
'Actual check-out time in company local timezone (for shift validation). Automatically calculated from actual_end_time_utc by trigger.';

COMMENT ON COLUMN shift_requests.start_time_utc IS
'Scheduled start time in UTC (new column). Automatically calculated when shift is created.';

COMMENT ON COLUMN shift_requests.start_time_local IS
'Scheduled start time in local timezone. Automatically calculated from start_time_utc by trigger.';

COMMENT ON COLUMN shift_requests.end_time_utc IS
'Scheduled end time in UTC (new column). Automatically calculated when shift is created.';

COMMENT ON COLUMN shift_requests.end_time_local IS
'Scheduled end time in local timezone. Automatically calculated from end_time_utc by trigger.';

COMMENT ON COLUMN shift_requests.confirm_start_time_utc IS
'Manager-confirmed start time in UTC (new column).';

COMMENT ON COLUMN shift_requests.confirm_start_time_local IS
'Manager-confirmed start time in local timezone. Automatically calculated from confirm_start_time_utc by trigger.';

COMMENT ON COLUMN shift_requests.confirm_end_time_utc IS
'Manager-confirmed end time in UTC (new column).';

COMMENT ON COLUMN shift_requests.confirm_end_time_local IS
'Manager-confirmed end time in local timezone. Automatically calculated from confirm_end_time_utc by trigger.';

-- ============================================================================
-- Step 4: Mark old columns as deprecated
-- ============================================================================

COMMENT ON COLUMN shift_requests.actual_start_time IS
'DEPRECATED: Use actual_start_time_utc instead. This column will be maintained during transition period for backward compatibility. Will be removed in future version.';

COMMENT ON COLUMN shift_requests.actual_end_time IS
'DEPRECATED: Use actual_end_time_utc instead. This column will be maintained during transition period for backward compatibility. Will be removed in future version.';

COMMENT ON COLUMN shift_requests.start_time IS
'DEPRECATED: Use start_time_utc instead. This column will be maintained during transition period for backward compatibility. Will be removed in future version.';

COMMENT ON COLUMN shift_requests.end_time IS
'DEPRECATED: Use end_time_utc instead. This column will be maintained during transition period for backward compatibility. Will be removed in future version.';

COMMENT ON COLUMN shift_requests.confirm_start_time IS
'DEPRECATED: Use confirm_start_time_utc instead. This column will be maintained during transition period for backward compatibility. Will be removed in future version.';

COMMENT ON COLUMN shift_requests.confirm_end_time IS
'DEPRECATED: Use confirm_end_time_utc instead. This column will be maintained during transition period for backward compatibility. Will be removed in future version.';

COMMIT;

-- ============================================================================
-- Verification queries
-- ============================================================================

-- Check that columns were added successfully
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_name = 'shift_requests'
  AND column_name LIKE '%_utc' OR column_name LIKE '%_local'
ORDER BY column_name;

-- Count records that will need migration
SELECT
  COUNT(*) as total_records,
  COUNT(actual_start_time) as has_actual_start,
  COUNT(actual_end_time) as has_actual_end,
  COUNT(actual_start_time_utc) as has_new_actual_start,
  COUNT(actual_end_time_utc) as has_new_actual_end
FROM shift_requests;
