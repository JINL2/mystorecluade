-- ================================================================
-- MIGRATION: Fix Failed Columns (4 Issues)
-- Date: 2025-12-16
-- Purpose: AI SQL 테스트 실패 원인 수정
-- ================================================================

-- ================================================================
-- FIX 1: debts_receivable.entry_date_utc → issue_date_utc
-- Error: column dr.entry_date_utc does not exist
-- ================================================================
UPDATE ontology_columns
SET column_name = 'issue_date_utc',
    ai_usage_hint = '⭐ 미수금 등록일 (UTC). ⛔ entry_date_utc 없음!'
WHERE table_name = 'debts_receivable'
  AND column_name = 'entry_date_utc';

-- ================================================================
-- FIX 2: journal_lines.company_id 문제
-- Error: column journal_lines.company_id does not exist
-- Solution: journal_lines에는 company_id가 없음.
--           journal_entries를 JOIN해서 company_id 가져와야 함
-- ================================================================

-- 먼저 잘못된 컬럼 레코드가 있으면 삭제
DELETE FROM ontology_columns
WHERE table_name = 'journal_lines' AND column_name = 'company_id';

-- journal_entries 테이블에 company_id 힌트 강화
UPDATE ontology_columns
SET ai_usage_hint = '⭐⭐ 필터 필수! journal_lines에는 company_id 없음. 반드시 journal_entries JOIN 필요!'
WHERE table_name = 'journal_entries' AND column_name = 'company_id';

-- journal_lines 테이블에 journal_entry_id 힌트 추가/업데이트
INSERT INTO ontology_columns (table_name, column_name, data_type, is_active, is_deprecated, ai_usage_hint)
VALUES ('journal_lines', 'journal_entry_id', 'uuid', true, false,
        '⭐⭐ journal_entries와 JOIN 키. company_id 필터는 journal_entries에서!')
ON CONFLICT (table_name, column_name)
DO UPDATE SET ai_usage_hint = '⭐⭐ journal_entries와 JOIN 키. company_id 필터는 journal_entries에서!';

-- ================================================================
-- 확인 쿼리
-- ================================================================
SELECT '=== debts_receivable columns ===' as info;
SELECT table_name, column_name, ai_usage_hint
FROM ontology_columns
WHERE table_name = 'debts_receivable'
ORDER BY column_name;

SELECT '=== journal_entries & journal_lines company_id ===' as info;
SELECT table_name, column_name, ai_usage_hint
FROM ontology_columns
WHERE (table_name = 'journal_entries' AND column_name = 'company_id')
   OR (table_name = 'journal_lines' AND column_name IN ('company_id', 'journal_entry_id'))
ORDER BY table_name, column_name;
