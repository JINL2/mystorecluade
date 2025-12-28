-- ============================================================
-- Migration: Fix duplicate user_stores and user_salaries
-- Date: 2025-12-28
-- Purpose: Clean up duplicates and add unique constraints
--
-- IMPORTANT: Run this in Supabase Dashboard SQL Editor
-- ============================================================

-- ============================================================
-- PART 1: Fix user_stores duplicates (3 sets found)
-- ============================================================

-- Delete duplicate user_stores records (keep only the oldest one)
DELETE FROM user_stores
WHERE user_store_id IN (
    SELECT user_store_id
    FROM (
        SELECT
            user_store_id,
            ROW_NUMBER() OVER (
                PARTITION BY user_id, store_id
                ORDER BY created_at ASC
            ) as rn
        FROM user_stores
        WHERE is_deleted = false
    ) ranked
    WHERE rn > 1
);

-- Add unique constraint to prevent future duplicates
-- Uses partial index: only active (non-deleted) records must be unique
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_stores_unique_active
ON user_stores (user_id, store_id)
WHERE is_deleted = false;

-- ============================================================
-- PART 2: Fix user_salaries duplicates (10 sets found)
-- ============================================================

-- Delete duplicate user_salaries records (keep only the oldest one)
DELETE FROM user_salaries
WHERE salary_id IN (
    SELECT salary_id
    FROM (
        SELECT
            salary_id,
            ROW_NUMBER() OVER (
                PARTITION BY user_id, company_id
                ORDER BY created_at ASC
            ) as rn
        FROM user_salaries
    ) ranked
    WHERE rn > 1
);

-- Add unique constraint to prevent future duplicates
-- Note: user_salaries doesn't have is_deleted column
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_salaries_unique
ON user_salaries (user_id, company_id);

-- ============================================================
-- VERIFICATION: Run after migration to confirm success
-- ============================================================
-- SELECT 'user_stores' as table_name, COUNT(*) as duplicate_sets
-- FROM (
--     SELECT user_id, store_id
--     FROM user_stores
--     WHERE is_deleted = false
--     GROUP BY user_id, store_id
--     HAVING COUNT(*) > 1
-- ) t
-- UNION ALL
-- SELECT 'user_salaries' as table_name, COUNT(*) as duplicate_sets
-- FROM (
--     SELECT user_id, company_id
--     FROM user_salaries
--     GROUP BY user_id, company_id
--     HAVING COUNT(*) > 1
-- ) t;
