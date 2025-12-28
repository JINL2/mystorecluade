-- Fix ALL duplicate user_companies records
-- Found 57 duplicate records across multiple users/companies
--
-- ROOT CAUSE ANALYSIS:
-- 1. DB trigger 'set_user_company' automatically inserts into user_companies when a company is created
-- 2. Flutter app code (company_remote_datasource.dart) was ALSO manually inserting into user_companies
-- 3. Result: Double insert within ~0.2-0.5 seconds for each company creation
--
-- FIX APPLIED:
-- - Removed manual INSERT from Flutter app code (company_remote_datasource.dart)
-- - Clean up ALL existing duplicates
-- - Added unique constraint to prevent future duplicates

-- 1. Delete ALL duplicate records (keep only the oldest one for each user_id + company_id)
-- This uses a CTE to identify duplicates and delete all but the first created record
DELETE FROM user_companies
WHERE user_company_id IN (
    SELECT user_company_id
    FROM (
        SELECT
            user_company_id,
            ROW_NUMBER() OVER (
                PARTITION BY user_id, company_id
                ORDER BY created_at ASC
            ) as rn
        FROM user_companies
        WHERE is_deleted = false
    ) ranked
    WHERE rn > 1  -- Delete all except the first (oldest) record
);

-- 2. Add unique constraint to prevent this in the future
-- Only applies to active records (is_deleted = false)
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_companies_unique_active
ON user_companies (user_id, company_id)
WHERE is_deleted = false;

-- 3. Comment explaining the constraint
COMMENT ON INDEX idx_user_companies_unique_active IS
'Ensures a user can only belong to a company once (when not deleted). Allows soft-deleted records to exist alongside active ones. Added 2025-12-28 to fix duplicate record bug.';
