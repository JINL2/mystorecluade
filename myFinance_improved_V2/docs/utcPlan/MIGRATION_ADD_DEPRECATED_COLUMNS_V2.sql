-- ================================================================
-- MIGRATION: Add newly discovered deprecated columns
-- Date: 2025-12-16
-- Issue: AI using non-existent columns causing SQL errors
-- Run in Supabase Dashboard SQL Editor!
-- ================================================================

-- ================================================================
-- PART 1: journal_lines 컬럼
-- ================================================================

-- 1. journal_lines.amount - DOES NOT EXIST!
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'amount', 'numeric', true, true,
        '⛔⛔ DOES NOT EXIST! journal_lines has NO amount column! Use debit and credit columns. Revenue = SUM(credit), Expense = SUM(debit), Net = SUM(debit) - SUM(credit)')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- 2. journal_lines.credit_amount - DOES NOT EXIST!
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'credit_amount', 'numeric', true, true,
        '⛔⛔ DOES NOT EXIST! Use credit instead!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- 3. journal_lines.debit_amount - DOES NOT EXIST!
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'debit_amount', 'numeric', true, true,
        '⛔⛔ DOES NOT EXIST! Use debit instead!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 2: stores 컬럼
-- ================================================================

-- 4. stores.name - DOES NOT EXIST!
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('stores', 'name', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! stores has NO name column! Use store_name instead!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- 5. stores.location - DOES NOT EXIST!
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('stores', 'location', 'point', true, true,
        '⛔⛔ DOES NOT EXIST! stores has NO location column! Use store_location instead!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 3: v_user_role_info 컬럼 - role_type DOES NOT EXIST!
-- v_user_role_info has: role_name (NOT role_type!)
-- ================================================================

-- 6. v_user_role_info.role_type - DOES NOT EXIST!
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('v_user_role_info', 'role_type', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! v_user_role_info has NO role_type column! Use role_name instead! Available columns: user_id, role_id, role_name, company_id, full_name, email')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- Update the existing v_user_role_info.role_name hint to clarify
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Role name (admin/manager/employee). ⛔ role_type does NOT exist in this view! Use role_name!'
WHERE table_name = 'v_user_role_info' AND column_name = 'role_name';

-- If role_name doesn't exist, add it
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('v_user_role_info', 'role_name', 'varchar', true, false,
        '⭐⭐ Role name (admin/manager/employee). ⛔ role_type does NOT exist in this view! Use role_name!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint, is_deprecated = false;

-- ================================================================
-- PART 4: roles 테이블 - role_type 확인
-- ================================================================

-- Check if roles table has role_type and update hint
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Role type (admin/manager/employee). For user roles, use v_user_role_info.role_name or JOIN: users → user_roles → roles.role_type'
WHERE table_name = 'roles' AND column_name = 'role_type';

-- ================================================================
-- PART 5: Strengthen correct column hints
-- ================================================================

-- Update stores.store_name hint
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Store name. ⛔ stores.name does NOT exist! Must use store_name!'
WHERE table_name = 'stores' AND column_name = 'store_name';

-- Update journal_lines.debit hint
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Debit amount. ⛔ amount, debit_amount do NOT exist! Use debit. For revenue: SUM(credit). For expense: SUM(debit). Net = SUM(debit) - SUM(credit)'
WHERE table_name = 'journal_lines' AND column_name = 'debit';

-- Update journal_lines.credit hint
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Credit amount. ⛔ amount, credit_amount do NOT exist! Use credit. For revenue: SUM(credit). For expense: SUM(debit). Net = SUM(debit) - SUM(credit)'
WHERE table_name = 'journal_lines' AND column_name = 'credit';

-- ================================================================
-- PART 6: Add constraint for stores table
-- ================================================================

INSERT INTO ontology_constraints (
  constraint_name,
  constraint_type,
  applies_to_table,
  validation_rule,
  severity,
  ai_usage_hint
) VALUES (
  'stores_use_store_name',
  'TABLE_USAGE',
  'stores',
  'stores.name does NOT exist, use store_name',
  'critical',
  '## ⛔ stores 테이블 주의!

### ❌ 존재하지 않는 컬럼
- stores.name ❌ (없음!)
- stores.location ❌ (없음!)

### ✅ 올바른 컬럼
- store_name ✅
- store_location ✅

### 예시
```sql
SELECT s.store_name FROM stores s  -- ✅
SELECT s.name FROM stores s        -- ❌ 에러!
```'
) ON CONFLICT (constraint_name) DO UPDATE SET
  ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 7: Add constraint for journal_lines amount columns
-- ================================================================

-- Update existing journal_lines constraint to include amount
UPDATE ontology_constraints
SET ai_usage_hint = '## ⛔ journal_lines 테이블 주의!

### ❌ 존재하지 않는 컬럼
- journal_lines.company_id ❌
- journal_lines.journal_entry_id ❌ (journal_id 사용!)
- journal_lines.amount ❌ (debit/credit 사용!)
- journal_lines.debit_amount ❌ (debit 사용!)
- journal_lines.credit_amount ❌ (credit 사용!)

### ✅ 매출/비용 계산
```sql
-- 매출 (Revenue): credit 합계
SELECT SUM(jl.credit) FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
WHERE a.account_type = ''income''

-- 비용 (Expense): debit 합계
SELECT SUM(jl.debit) FROM journal_lines jl
JOIN accounts a ON jl.account_id = a.account_id
WHERE a.account_type = ''expense''
```

### ✅ company_id 필터링 방법
```sql
SELECT jl.*
FROM journal_lines jl
JOIN journal_entries je ON jl.journal_id = je.journal_id
WHERE je.company_id = $cid
```'
WHERE constraint_name = 'journal_lines_no_company_id';

-- ================================================================
-- VERIFICATION
-- ================================================================

SELECT '=== Newly added deprecated columns ===' as info;
SELECT table_name, column_name, ai_usage_hint
FROM ontology_columns
WHERE is_deprecated = true
  AND (
    (table_name = 'journal_lines' AND column_name IN ('amount', 'credit_amount', 'debit_amount'))
    OR (table_name = 'stores' AND column_name IN ('name', 'location'))
    OR (table_name = 'v_user_role_info' AND column_name = 'role_type')
  )
ORDER BY table_name, column_name;

SELECT '=== Total deprecated columns count ===' as info;
SELECT COUNT(*) as total_deprecated
FROM ontology_columns
WHERE is_deprecated = true AND is_active = true;
