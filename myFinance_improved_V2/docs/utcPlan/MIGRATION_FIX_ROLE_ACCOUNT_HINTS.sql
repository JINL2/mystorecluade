-- ================================================================
-- MIGRATION: Fix AI Ontology Hints for Role & Account Queries
-- Date: 2025-12-16
-- Purpose: 4개 실패 쿼리 수정
--   1. "직원 역할별 인원수" - users.role_type 없음
--   2. "가장 큰 지출 항목" - accounts.name 없음 (account_name 사용)
--   3. "파트타임 직원 급여" - roles.user_id 없음 (user_roles JOIN 필요)
--   4. "재고 부족 상품" - products 테이블 미등록 (별도 처리)
-- ================================================================

-- ================================================================
-- PART 1: ontology_columns 힌트 강화
-- ================================================================

-- 1. roles.role_type - users.role_type does NOT exist
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Role type (admin/manager/employee). ⛔ users.role_type does NOT exist! Must JOIN: users → user_roles → roles. Or use v_user_role_info view!'
WHERE table_name = 'roles' AND column_name = 'role_type';

-- 2. user_roles.user_id - JOIN pattern
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ FK → users.user_id. For role-based user query: users u JOIN user_roles ur ON u.user_id = ur.user_id JOIN roles r ON ur.role_id = r.role_id'
WHERE table_name = 'user_roles' AND column_name = 'user_id';

-- 3. user_roles.role_id - how to access role_type
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ FK → roles.role_id. To get role_type: JOIN roles r ON user_roles.role_id = r.role_id'
WHERE table_name = 'user_roles' AND column_name = 'role_id';

-- 4. accounts.account_name - name column does NOT exist
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Account name (e.g. Sales, Salary Expense, Cash). ⛔ accounts.name does NOT exist! Must use account_name!'
WHERE table_name = 'accounts' AND column_name = 'account_name';

-- 5. users.name deprecated
UPDATE ontology_columns
SET ai_usage_hint = '⛔⛔ DEPRECATED! users.name does NOT exist! Use CONCAT(first_name, '' '', last_name) AS full_name. Or use v_user_role_info.full_name!'
WHERE table_name = 'users' AND column_name = 'name';

-- 6. users.role_type - DOES NOT EXIST! (AI keeps trying to use this)
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('users', 'role_type', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! users has NO role_type column! Use v_user_role_info.role_type or JOIN: users → user_roles → roles.role_type')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- 7. accounts.name - DOES NOT EXIST! (should use account_name)
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('accounts', 'name', 'text', true, true,
        '⛔⛔ DOES NOT EXIST! Use account_name instead!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- 8. roles.user_id - DOES NOT EXIST! (need user_roles table)
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('roles', 'user_id', 'uuid', true, true,
        '⛔⛔ DOES NOT EXIST! roles has NO user_id! Use user_roles table: JOIN user_roles ur ON roles.role_id = ur.role_id')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 1.5: journal_lines 컬럼 힌트 수정
-- ================================================================

-- CRITICAL: journal_entry_id does NOT exist! Insert as deprecated
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'journal_entry_id', 'uuid', true, true,
        '⛔⛔ DOES NOT EXIST! Use journal_id instead. JOIN: jl.journal_id = je.journal_id')
ON CONFLICT (table_name, column_name)
DO UPDATE SET is_deprecated = true, ai_usage_hint = EXCLUDED.ai_usage_hint;

-- Update embedding text for journal_entry_id (already exists)
UPDATE ontology_embeddings
SET text_content = 'journal_lines.journal_entry_id: ⛔⛔ DOES NOT EXIST! Use journal_id instead. JOIN: jl.journal_id = je.journal_id'
WHERE table_name = 'journal_lines' AND column_name = 'journal_entry_id';

-- journal_lines.journal_id - correct FK column
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ FK → journal_entries.journal_id. ⛔ journal_entry_id does NOT exist! Use journal_id. For company_id filter: JOIN journal_entries je ON jl.journal_id = je.journal_id WHERE je.company_id = $company_id'
WHERE table_name = 'journal_lines' AND column_name = 'journal_id';

-- journal_lines.debit - correct amount column
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Debit amount. ⛔ debit_amount does NOT exist! Use debit. Net amount = (debit - credit)'
WHERE table_name = 'journal_lines' AND column_name = 'debit';

-- journal_lines.credit - correct amount column
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ Credit amount. ⛔ credit_amount does NOT exist! Use credit. Net amount = (debit - credit)'
WHERE table_name = 'journal_lines' AND column_name = 'credit';

-- Add hint that company_id does NOT exist in journal_lines
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'company_id', 'uuid', true, true,
        '⛔⛔ DOES NOT EXIST! journal_lines has NO company_id. Must JOIN journal_entries: JOIN journal_entries je ON jl.journal_id = je.journal_id WHERE je.company_id = $company_id')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint, is_deprecated = true;

-- ================================================================
-- PART 2: v_user_role_info 뷰 컬럼 등록
-- ================================================================

-- v_user_role_info.role_type - Use this view, no complex JOIN needed!
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint)
VALUES ('v_user_role_info', 'role_type', 'text', true,
        '⭐⭐ Role type. Use this view - no complex JOIN needed! Best for role-based aggregation.')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- v_user_role_info.full_name
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint)
VALUES ('v_user_role_info', 'full_name', 'text', true,
        '⭐ User full name (first_name + last_name). No users JOIN needed!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- v_user_role_info.role_name
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint)
VALUES ('v_user_role_info', 'role_name', 'text', true,
        '⭐ Role name. No roles JOIN needed!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- v_user_role_info.company_id
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint)
VALUES ('v_user_role_info', 'company_id', 'uuid', true,
        '⭐ Company filter. Always add WHERE company_id = $company_id!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- v_user_role_info.is_deleted
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint)
VALUES ('v_user_role_info', 'is_deleted', 'boolean', true,
        '⭐ Soft delete flag. Add WHERE is_deleted = false!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 3: ontology_relationships 힌트 강화
-- ================================================================

-- user_roles → roles relationship - recommend using view
UPDATE ontology_relationships
SET ai_usage_hint = '⭐⭐ For role-based user queries, use v_user_role_info view instead! No complex JOIN needed. Contains role_type, full_name, role_name.'
WHERE from_table = 'user_roles' AND to_table = 'roles';

-- ================================================================
-- PART 4: ontology_concepts 역할 개념 추가
-- 컬럼: concept_name, concept_category, definition_ko, mapped_table,
--       mapped_column, calculation_rule, ai_usage_hint, example_values
-- ================================================================

-- Employee role concept
INSERT INTO ontology_concepts (concept_name, concept_category, definition_ko, mapped_table, mapped_column, ai_usage_hint, example_values)
VALUES (
  'employee_role',
  'HR',
  'Employee role type classification (admin, manager, employee, etc.)',
  'v_user_role_info',
  'role_type',
  '⭐⭐ Role count query: SELECT role_type, COUNT(*) FROM v_user_role_info WHERE company_id = $company_id AND is_deleted = false GROUP BY role_type. ⛔ users.role_type does NOT exist!',
  '{"examples": ["admin", "manager", "employee"], "synonyms": ["role", "role type", "employee type", "staff role", "역할별", "역할 유형", "직원 역할"]}'::jsonb
)
ON CONFLICT (concept_name)
DO UPDATE SET
  mapped_table = EXCLUDED.mapped_table,
  mapped_column = EXCLUDED.mapped_column,
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  example_values = EXCLUDED.example_values;

-- Expense category concept
INSERT INTO ontology_concepts (concept_name, concept_category, definition_ko, mapped_table, mapped_column, ai_usage_hint, example_values)
VALUES (
  'expense_category',
  'Accounting',
  'Expense account classification and aggregation',
  'accounts',
  'account_name',
  '⭐⭐ Expense analysis: SELECT a.account_name, SUM(jl.debit_amount) FROM accounts a JOIN journal_lines jl ON a.account_id = jl.account_id WHERE a.account_type = ''expense'' GROUP BY a.account_name. ⛔ accounts.name does NOT exist! Use account_name!',
  '{"examples": ["Salary Expense", "Rent", "Utilities"], "synonyms": ["expense", "cost", "spending", "largest expense", "지출", "비용", "지출 항목"]}'::jsonb
)
ON CONFLICT (concept_name)
DO UPDATE SET
  mapped_table = EXCLUDED.mapped_table,
  mapped_column = EXCLUDED.mapped_column,
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  example_values = EXCLUDED.example_values;

-- ================================================================
-- PART 4.5: Update critical constraints (THIS IS WHAT AI ACTUALLY READS!)
-- ================================================================

-- Update users_table_limited_columns constraint to include role_type
UPDATE v_ontology_graph_nodes
SET metadata = jsonb_set(
  metadata,
  '{ai_usage_hint}',
  '"## ⛔ users 테이블 사용 주의!\n\n### ❌ 존재하지 않는 컬럼들\n- users.role_type ❌ (없음! → v_user_role_info.role_type 사용)\n- users.user_name ❌ (없음!)\n- users.company_id ❌ (없음!)\n- users.store_id ❌ (없음!)\n- users.name ❌ (없음!)\n\n### ✅ 실제 존재하는 컬럼\n- user_id\n- first_name\n- last_name\n- email\n\n### 🎯 역할 조회시: v_user_role_info 사용!\n```sql\n-- 역할별 직원 수\nSELECT role_type, COUNT(*) \nFROM v_user_role_info\nWHERE company_id = $cid AND is_deleted = false\nGROUP BY role_type\n```"'
)
WHERE node_name = 'users_table_limited_columns';

-- Add new constraint for roles table
INSERT INTO ontology_constraints (
  constraint_name,
  constraint_type,
  applies_to_table,
  validation_rule,
  severity,
  ai_usage_hint
) VALUES (
  'roles_table_no_user_id',
  'TABLE_USAGE',
  'roles',
  'roles.user_id does NOT exist',
  'critical',
  '## ⛔ roles 테이블 주의!\n\n### ❌ 존재하지 않는 컬럼\n- roles.user_id ❌ (없음!)\n\n### ✅ 올바른 방법\n역할별 사용자 조회:\n```sql\n-- v_user_role_info 사용 (권장!)\nSELECT role_type, full_name\nFROM v_user_role_info\nWHERE company_id = $cid\n\n-- 또는 user_roles JOIN\nSELECT r.role_type, u.first_name\nFROM roles r\nJOIN user_roles ur ON r.role_id = ur.role_id\nJOIN users u ON ur.user_id = u.user_id\nWHERE r.company_id = $cid\n```'
) ON CONFLICT (constraint_name) DO UPDATE SET
  ai_usage_hint = EXCLUDED.ai_usage_hint;

-- Add constraint for accounts table
INSERT INTO ontology_constraints (
  constraint_name,
  constraint_type,
  applies_to_table,
  validation_rule,
  severity,
  ai_usage_hint
) VALUES (
  'accounts_use_account_name',
  'TABLE_USAGE',
  'accounts',
  'accounts.name does NOT exist, use account_name',
  'critical',
  '## ⛔ accounts 테이블 주의!\n\n### ❌ 존재하지 않는 컬럼\n- accounts.name ❌ (없음!)\n\n### ✅ 올바른 컬럼\n- account_name ✅\n\n### 예시\n```sql\nSELECT a.account_name, SUM(jl.debit)\nFROM accounts a\nJOIN journal_lines jl ON a.account_id = jl.account_id\nGROUP BY a.account_name\n```'
) ON CONFLICT (constraint_name) DO UPDATE SET
  ai_usage_hint = EXCLUDED.ai_usage_hint;

-- Add constraint for journal_lines table
INSERT INTO ontology_constraints (
  constraint_name,
  constraint_type,
  applies_to_table,
  validation_rule,
  severity,
  ai_usage_hint
) VALUES (
  'journal_lines_no_company_id',
  'TABLE_USAGE',
  'journal_lines',
  'journal_lines.company_id does NOT exist',
  'critical',
  '## ⛔ journal_lines 테이블 주의!\n\n### ❌ 존재하지 않는 컬럼\n- journal_lines.company_id ❌\n- journal_lines.journal_entry_id ❌ (journal_id 사용!)\n- journal_lines.debit_amount ❌ (debit 사용!)\n- journal_lines.credit_amount ❌ (credit 사용!)\n\n### ✅ company_id 필터링 방법\n```sql\nSELECT jl.*\nFROM journal_lines jl\nJOIN journal_entries je ON jl.journal_id = je.journal_id\nWHERE je.company_id = $cid\n```'
) ON CONFLICT (constraint_name) DO UPDATE SET
  ai_usage_hint = EXCLUDED.ai_usage_hint;

-- ================================================================
-- PART 5: 확인 쿼리
-- ================================================================

SELECT '=== Updated ontology_columns (roles, user_roles, accounts, users) ===' as info;
SELECT table_name, column_name, ai_usage_hint
FROM ontology_columns
WHERE (table_name = 'roles' AND column_name = 'role_type')
   OR (table_name = 'user_roles' AND column_name IN ('user_id', 'role_id'))
   OR (table_name = 'accounts' AND column_name = 'account_name')
   OR (table_name = 'users' AND column_name = 'name')
ORDER BY table_name, column_name;

SELECT '=== Updated ontology_columns (journal_lines) ===' as info;
SELECT table_name, column_name, ai_usage_hint
FROM ontology_columns
WHERE table_name = 'journal_lines'
  AND column_name IN ('journal_id', 'debit', 'credit', 'company_id')
ORDER BY column_name;

SELECT '=== Updated ontology_columns (v_user_role_info) ===' as info;
SELECT table_name, column_name, ai_usage_hint
FROM ontology_columns
WHERE table_name = 'v_user_role_info'
ORDER BY column_name;

SELECT '=== Updated ontology_relationships ===' as info;
SELECT from_table, to_table, ai_usage_hint
FROM ontology_relationships
WHERE from_table = 'user_roles' AND to_table = 'roles';

SELECT '=== Updated ontology_concepts ===' as info;
SELECT concept_name, mapped_table, mapped_column, ai_usage_hint
FROM ontology_concepts
WHERE concept_name IN ('employee_role', 'expense_category');

SELECT '=== Verify journal_entry_id deprecated ===' as info;
SELECT table_name, column_name, is_deprecated, ai_usage_hint
FROM ontology_columns
WHERE table_name = 'journal_lines' AND column_name = 'journal_entry_id';
