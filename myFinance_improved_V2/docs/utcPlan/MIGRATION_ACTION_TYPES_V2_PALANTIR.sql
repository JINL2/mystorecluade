-- ================================================================
-- MIGRATION: ontology_action_types V2 - Palantir Style
-- Date: 2025-12-16
--
-- 변경사항:
--   기존: Action → Table (직접)
--   신규: Action → Entity → Table (Palantir 스타일)
--
-- 핵심: target_entity를 통해 ontology_entities와 연결
--       Entity가 table_name을 가지고 있으므로 간접 참조
--
-- RUN THIS IN SUPABASE DASHBOARD SQL EDITOR!
-- ================================================================

-- ================================================================
-- PART 1: Add target_entity column to ontology_action_types
-- ================================================================

-- Add target_entity column if not exists
ALTER TABLE ontology_action_types
ADD COLUMN IF NOT EXISTS target_entity TEXT;

-- Add comment
COMMENT ON COLUMN ontology_action_types.target_entity IS
'⭐⭐ Palantir-style: FK → ontology_entities.entity_name. Action이 조작하는 Entity (Object Type). Entity → Table 매핑은 ontology_entities에서 관리.';

-- Create index
CREATE INDEX IF NOT EXISTS idx_action_types_entity ON ontology_action_types(target_entity);

-- ================================================================
-- PART 2: Update existing actions with target_entity
-- ontology_entities에 있는 entity_name 사용
-- ================================================================

-- HR Actions - Shift
UPDATE ontology_action_types SET target_entity = 'Shift'
WHERE action_name IN ('check_in', 'check_out', 'request_shift', 'approve_shift', 'reject_shift');

-- Finance Actions - Transaction
UPDATE ontology_action_types SET target_entity = 'JournalEntry'
WHERE action_name IN ('create_transaction', 'post_transaction', 'delete_transaction');

-- Cash Actions - CashEntry
UPDATE ontology_action_types SET target_entity = 'CashEntry'
WHERE action_name IN ('cash_in', 'cash_out', 'recount_cash');

-- Debt Actions
UPDATE ontology_action_types SET target_entity = 'Debt'
WHERE action_name = 'create_debt';

UPDATE ontology_action_types SET target_entity = 'Payment'
WHERE action_name = 'record_payment';

-- ================================================================
-- PART 3: Add relationship: ontology_action_types → ontology_entities
-- ================================================================

INSERT INTO ontology_relationships (
  from_table, to_table, relationship_type, from_column, to_column, ai_usage_hint
) VALUES
('ontology_action_types', 'ontology_entities', 'many_to_one', 'target_entity', 'entity_name',
 '⭐⭐⭐ Palantir-style Path! Action → Entity → Table. Action.target_entity로 Entity를 찾고, Entity.table_name으로 실제 테이블을 찾는다.')
ON CONFLICT DO NOTHING;

-- ================================================================
-- PART 4: Update ontology_columns for target_entity
-- ================================================================

INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, ai_usage_hint) VALUES
('ontology_action_types', 'target_entity', 'text', true,
 '⭐⭐⭐ Palantir-style: Action이 조작하는 Entity (Object Type).
 Path: Action.target_entity → ontology_entities.entity_name → entity.table_name
 예: check_in.target_entity = "Shift" → Shift.table_name = "shift_requests"')
ON CONFLICT (table_name, column_name) DO UPDATE SET ai_usage_hint = EXCLUDED.ai_usage_hint;

-- Update target_table hint (now secondary to target_entity)
UPDATE ontology_columns
SET ai_usage_hint = '⚠️ Legacy: 직접 테이블 참조. Palantir-style은 target_entity 사용 권장. target_entity가 있으면 ontology_entities를 통해 table_name을 찾아라.'
WHERE table_name = 'ontology_action_types' AND column_name = 'target_table';

-- ================================================================
-- PART 5: Update action_query_pattern constraint
-- ================================================================

UPDATE ontology_constraints
SET ai_usage_hint = '## 🎯 Action 조회 패턴 (Palantir Style)

### 핵심 구조 (Action → Entity → Table)
```
User → Role → Feature → Action → Entity → Table
                          ↓         ↓
                    target_entity  table_name
```

### Path 탐색 예시
```sql
-- Action → Entity → Table 찾기
SELECT
  a.action_name,           -- "check_in"
  a.target_entity,         -- "Shift"
  e.table_name,            -- "shift_requests"
  e.primary_key_column     -- "shift_request_id"
FROM ontology_action_types a
JOIN ontology_entities e ON a.target_entity = e.entity_name
WHERE a.action_name = ''check_in'';
```

### ✅ "오늘 체크인한 사람" 질문 처리
```sql
-- Step 1: Action → Entity → Table 찾기
SELECT e.table_name, e.display_name_column
FROM ontology_action_types a
JOIN ontology_entities e ON a.target_entity = e.entity_name
WHERE a.action_name = ''check_in'';
-- 결과: shift_requests, NULL (View 사용: v_shift_request_ai)

-- Step 2: 실제 데이터 조회
SELECT full_name, check_in_time
FROM v_shift_request_ai
WHERE company_id = $cid
  AND DATE(check_in_time AT TIME ZONE $tz) = CURRENT_DATE
  AND check_in_time IS NOT NULL;
```

### ✅ Entity 관련 모든 Action 찾기
```sql
SELECT action_name, action_name_ko, actor_type, required_roles
FROM ontology_action_types
WHERE target_entity = ''Shift'';
-- 결과: check_in, check_out, request_shift, approve_shift, reject_shift
```

### ✅ 특정 Table에 영향 미치는 Action 찾기 (Palantir-style)
```sql
SELECT a.action_name, a.target_entity, e.table_name
FROM ontology_action_types a
JOIN ontology_entities e ON a.target_entity = e.entity_name
WHERE e.table_name = ''shift_requests''
   OR ''shift_requests'' = ANY(a.affects_tables);
```'
WHERE constraint_name = 'action_query_pattern';

-- ================================================================
-- PART 6: Add new Path documentation in ontology_concepts
-- ================================================================

INSERT INTO ontology_concepts (concept_name, concept_category, mapped_table, mapped_column, ai_usage_hint, example_values)
VALUES
('palantir_path', 'system', 'ontology_action_types', 'target_entity',
 '⭐⭐⭐ Palantir-style Path Traversal:

 1. 질문에서 Action 추출 (동의어 → action_name)
 2. Action → Entity 찾기 (ontology_action_types.target_entity)
 3. Entity → Table 찾기 (ontology_entities.table_name)
 4. Table 컬럼/제약 조회 (ontology_columns, ontology_constraints)
 5. SQL 생성

 예시:
 "오늘 체크인한 사람"
 → check_in (action)
 → Shift (entity)
 → v_shift_request_ai (view)',
 '["Action → Entity → Table", "check_in → Shift → shift_requests"]')
ON CONFLICT (concept_name) DO UPDATE SET
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  example_values = EXCLUDED.example_values;

-- ================================================================
-- PART 7: Add missing entities if needed
-- ================================================================

-- Check if Payment entity exists, if not add it
INSERT INTO ontology_entities (entity_name, table_name, entity_type, primary_key_column, ai_usage_hint)
VALUES ('Payment', 'debt_payments', 'data', 'payment_id',
        '⭐ 채권/채무 결제 기록. record_payment Action의 대상.')
ON CONFLICT (entity_name) DO NOTHING;

-- Check if Debt entity exists, if not add it
INSERT INTO ontology_entities (entity_name, table_name, entity_type, primary_key_column, ai_usage_hint)
VALUES ('Debt', 'debts_receivable', 'data', 'debt_id',
        '⭐ 채권/채무. direction으로 receivable/payable 구분.')
ON CONFLICT (entity_name) DO NOTHING;

-- ================================================================
-- PART 8: Verification
-- ================================================================

SELECT '=== ontology_action_types with target_entity ===' as info;
SELECT
  a.action_name,
  a.target_entity,
  e.table_name as entity_table,
  a.target_table as legacy_table,
  CASE WHEN a.target_entity IS NOT NULL AND e.table_name IS NOT NULL
       THEN '✅ Palantir-style'
       ELSE '⚠️ Legacy'
  END as style
FROM ontology_action_types a
LEFT JOIN ontology_entities e ON a.target_entity = e.entity_name
WHERE a.is_active = true
ORDER BY a.action_category, a.action_name;

SELECT '=== Path verification ===' as info;
SELECT
  'check_in' as action,
  a.target_entity,
  e.table_name,
  e.primary_key_column
FROM ontology_action_types a
JOIN ontology_entities e ON a.target_entity = e.entity_name
WHERE a.action_name = 'check_in';

SELECT '=== Entity → Actions mapping ===' as info;
SELECT
  e.entity_name,
  e.table_name,
  ARRAY_AGG(a.action_name ORDER BY a.action_name) as actions
FROM ontology_entities e
LEFT JOIN ontology_action_types a ON e.entity_name = a.target_entity
WHERE a.action_name IS NOT NULL
GROUP BY e.entity_name, e.table_name
ORDER BY e.entity_name;
