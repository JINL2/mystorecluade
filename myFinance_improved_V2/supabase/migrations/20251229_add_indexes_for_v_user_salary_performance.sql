-- =====================================================
-- Performance indexes for v_user_salary view
-- Fixes statement timeout on Team Management page
-- =====================================================

-- 1. shift_requests: index for MAX(created_at) WHERE user_id = ?
-- Existing idx_shift_requests_user_id only has user_id, need created_at DESC for MAX
CREATE INDEX IF NOT EXISTS idx_shift_requests_user_created_at
ON shift_requests (user_id, created_at DESC);

-- 2. journal_entries: index for MAX(created_at) WHERE created_by = ?
-- Existing idx_journal_entries_created_by only has created_by, need created_at DESC for MAX
CREATE INDEX IF NOT EXISTS idx_journal_entries_created_by_created_at
ON journal_entries (created_by, created_at DESC);

-- 3. cash_amount_entries: index for MAX(created_at) WHERE created_by = ?
-- No existing index on created_by at all
CREATE INDEX IF NOT EXISTS idx_cash_amount_entries_created_by_created_at
ON cash_amount_entries (created_by, created_at DESC);

-- 4. user_preferences: index for MAX(clicked_at) WHERE user_id = ? AND company_id = ?
-- Existing idx_user_preferences_user_company doesn't include clicked_at
CREATE INDEX IF NOT EXISTS idx_user_preferences_user_company_clicked_at
ON user_preferences (user_id, company_id, clicked_at DESC);

-- =====================================================
-- Additional indexes for v_user_salary JOIN conditions
-- =====================================================

-- 5. users_bank_account: for the LATERAL join
CREATE INDEX IF NOT EXISTS idx_users_bank_account_user_id
ON users_bank_account (user_id);

-- 6. user_salaries: for the main join on user_id + company_id
CREATE INDEX IF NOT EXISTS idx_user_salaries_user_company
ON user_salaries (user_id, company_id);

-- =====================================================
-- Analyze tables to update statistics
-- =====================================================
ANALYZE shift_requests;
ANALYZE journal_entries;
ANALYZE cash_amount_entries;
ANALYZE user_preferences;
ANALYZE users_bank_account;
ANALYZE user_salaries;
