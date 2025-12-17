-- ================================================================
-- MIGRATION: Fix "문제" (Problem) Definition in Ontology - COMPLETE
-- Date: 2025-12-17
--
-- 문제 발견:
--   AI가 "문제가 있는 직원"을 조회할 때:
--   ❌ is_reported_v2 = true 사용 → 9명 (직원 수동 보고만)
--   ✅ problem_count > 0 사용해야 함 → 20명 (실제 문제)
--
-- 원인:
--   ontology에 "문제 = problem_count > 0" 정의가 없음
--   is_reported_v2 설명이 불명확함
--
-- 수정 범위:
--   1. ontology_concepts - problem 개념 추가
--   2. ontology_synonyms - 문제 관련 동의어 추가
--   3. ontology_columns - is_reported_v2, problem_details_v2 힌트 수정
--   4. ontology_constraints - problem_query_pattern 추가
--   5. ontology_embeddings - 관련 임베딩 업데이트 ⭐
--
-- RUN THIS IN SUPABASE DASHBOARD SQL EDITOR!
-- ================================================================

-- ================================================================
-- PART 1: ontology_concepts에 "problem" 개념 추가/업데이트
-- AI가 "문제", "이슈", "지각", "조퇴" 등 검색시 올바른 필터 사용
-- ================================================================

INSERT INTO ontology_concepts (concept_name, concept_category, mapped_table, mapped_column, ai_usage_hint, example_values)
VALUES
('problem', 'hr', 'v_shift_request_ai', 'problem_details_v2',
 '⭐⭐⭐ [중요] 문제/이슈/지각/조퇴/초과근무 판단 기준:

## 🔴 핵심 구분 (AI 필독!)
| 조건 | 의미 | 예상 결과 |
|------|------|----------|
| `(problem_details_v2->>''problem_count'')::int > 0` | 실제 문제가 있음 | 많음 (시스템 감지) |
| `is_reported_v2 = true` | 직원이 "보고" 버튼 누름 | 적음 (수동 보고만) |

## ✅ "문제 있는 직원/시프트" 조회 (올바른 방법)
```sql
SELECT full_name, problem_details_v2
FROM v_shift_request_ai
WHERE company_id = $cid
  AND (problem_details_v2->>''problem_count'')::int > 0
```

## ✅ 특정 유형 문제 조회
```sql
-- 지각한 직원
WHERE problem_details_v2->>''has_late'' = ''true''

-- 조퇴한 직원
WHERE problem_details_v2->>''has_early_leave'' = ''true''

-- 초과근무한 직원
WHERE problem_details_v2->>''has_overtime'' = ''true''
```

## ❌ 틀린 패턴 (절대 사용 금지!)
```sql
-- is_reported_v2는 "문제가 있다"가 아님!
WHERE is_reported_v2 = true  -- ❌ 직원 수동 보고만 포함
```',
 '["(problem_details_v2->>''problem_count'')::int > 0 = 문제 있음", "is_reported_v2 = 직원 수동 보고만", "has_late = 지각", "has_early_leave = 조퇴"]')
ON CONFLICT (concept_name) DO UPDATE SET
  concept_category = EXCLUDED.concept_category,
  mapped_table = EXCLUDED.mapped_table,
  mapped_column = EXCLUDED.mapped_column,
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  example_values = EXCLUDED.example_values;

-- ================================================================
-- PART 2: ontology_synonyms에 "문제" 관련 동의어 추가
-- 테이블 구조: synonym_id, concept_id, synonym_text, language_code, synonym_type, search_weight
-- concept_id는 PART 1에서 생성된 problem concept의 ID 사용
-- ================================================================

-- 먼저 problem concept의 ID를 가져와서 동의어 추가
DO $$
DECLARE
  v_concept_id uuid;
BEGIN
  -- problem concept의 ID 가져오기
  SELECT concept_id INTO v_concept_id FROM ontology_concepts WHERE concept_name = 'problem';

  -- 동의어 추가 (concept_id 사용)
  -- unique constraint: (concept_id, synonym_text, language_code)
  INSERT INTO ontology_synonyms (synonym_id, concept_id, synonym_text, language_code, synonym_type, search_weight, is_active)
  VALUES
    (gen_random_uuid(), v_concept_id, '문제', 'ko', 'alias', 1.0, true),
    (gen_random_uuid(), v_concept_id, '이슈', 'ko', 'alias', 0.9, true),
    (gen_random_uuid(), v_concept_id, '문제가 있는', 'ko', 'alias', 1.0, true),
    (gen_random_uuid(), v_concept_id, '문제있는', 'ko', 'alias', 1.0, true),
    (gen_random_uuid(), v_concept_id, 'problem', 'en', 'alias', 1.0, true),
    (gen_random_uuid(), v_concept_id, 'issue', 'en', 'alias', 0.9, true),
    (gen_random_uuid(), v_concept_id, 'has problem', 'en', 'alias', 1.0, true)
  ON CONFLICT (concept_id, synonym_text, language_code) DO UPDATE SET
    search_weight = EXCLUDED.search_weight,
    is_active = EXCLUDED.is_active,
    updated_at = NOW();
END $$;

-- ================================================================
-- PART 3: ontology_columns - is_reported_v2 힌트 수정
-- "문제가 있다"가 아님을 명확히!
-- ================================================================

UPDATE ontology_columns
SET ai_usage_hint = '⚠️ [주의] 이것은 "문제가 있다"가 아닙니다!

## is_reported_v2의 의미
- true = 직원이 수동으로 "문제 보고" 버튼을 눌러서 보고함
- 전체 문제의 극소수만 해당 (대부분 직원이 보고 안 함)

## ❌ 틀린 사용
```sql
-- "문제가 있는 직원" 찾을 때 이거 쓰면 안 됨!
WHERE is_reported_v2 = true  -- ❌ 직원 수동 보고만
```

## ✅ "문제가 있는 직원" 찾으려면
```sql
WHERE (problem_details_v2->>''problem_count'')::int > 0
```

## is_reported_v2 = true 용도
- "직원이 직접 보고한 건" 찾을 때만 사용
- report_reason_v2 와 함께 사용하여 보고 사유 확인'
WHERE table_name = 'v_shift_request_ai' AND column_name = 'is_reported_v2';

-- ================================================================
-- PART 4: ontology_columns - problem_details_v2 힌트 보강
-- problem_count > 0 = 문제 있음 명확히 추가
-- ================================================================

UPDATE ontology_columns
SET ai_usage_hint = '## problem_details_v2 JSON 구조

### 🔴 핵심: "문제가 있다" 판단 기준
```sql
-- ✅ 문제가 있는 시프트/직원 찾기
WHERE (problem_details_v2->>''problem_count'')::int > 0

-- ❌ is_reported_v2 = true는 "문제가 있다"가 아님! (직원 수동 보고만)
```

### ⚠️ 중요: JSONB 필드 접근법
이 컬럼은 JSONB입니다. 필드에 직접 접근하려면 반드시 ->> 연산자 사용!

### ❌ 잘못된 사용 (에러 발생!)
WHERE has_early_leave = true   -- 컬럼이 아님!
WHERE has_late = true          -- 컬럼이 아님!

### ✅ 올바른 사용
WHERE problem_details_v2->>''has_early_leave'' = ''true''
WHERE problem_details_v2->>''has_late'' = ''true''
WHERE problem_details_v2->>''has_absence'' = ''true''
WHERE problem_details_v2->>''has_overtime'' = ''true''

### 주요 필드
- **problem_count**: 총 문제 수 (이게 > 0이면 문제 있음!)
- has_late: 지각 여부
- has_overtime: 초과근무 여부
- has_early_leave: 조퇴 여부
- has_absence: 결근 여부
- has_no_checkout: 미퇴근 여부
- has_payroll_late: 급여 차감 지각
- has_payroll_overtime: 급여 추가 초과근무

### problems 배열에서 분 추출
```sql
(SELECT (elem->>''actual_minutes'')::numeric
 FROM jsonb_array_elements(problem_details_v2->''problems'') elem
 WHERE elem->>''type'' = ''late'' LIMIT 1) as late_minutes
```'
WHERE table_name = 'v_shift_request_ai' AND column_name = 'problem_details_v2';

-- ================================================================
-- PART 5: ontology_columns - is_problem_solved_v2 힌트 보강
-- ================================================================

UPDATE ontology_columns
SET ai_usage_hint = '## is_problem_solved_v2 의미
- true = 문제가 해결됨 (매니저가 처리 완료)
- false = 문제가 아직 미해결

## 사용 시나리오
```sql
-- 미해결 문제가 있는 시프트
WHERE (problem_details_v2->>''problem_count'')::int > 0
  AND is_problem_solved_v2 = false

-- 해결된 문제 이력
WHERE (problem_details_v2->>''problem_count'')::int > 0
  AND is_problem_solved_v2 = true
```

## ⚠️ 주의
- 이 컬럼 자체로 "문제가 있다"를 판단하면 안 됨
- 문제 여부는 problem_count > 0으로 판단!'
WHERE table_name = 'v_shift_request_ai' AND column_name = 'is_problem_solved_v2';

-- ================================================================
-- PART 6: ontology_constraints에 문제 조회 패턴 추가
-- ================================================================

INSERT INTO ontology_constraints (
  constraint_name,
  constraint_type,
  applies_to_table,
  validation_rule,
  severity,
  ai_usage_hint
) VALUES (
  'problem_query_pattern',
  'QUERY_PATTERN',
  'v_shift_request_ai',
  'Use problem_count > 0 for problem detection, NOT is_reported_v2',
  'critical',
  '## 🔴 문제 조회 패턴 (Critical!)

### 핵심 원칙
| 질문 | 사용할 조건 | 사용하면 안 되는 조건 |
|------|------------|---------------------|
| "문제 있는 직원" | `(problem_details_v2->>''problem_count'')::int > 0` | `is_reported_v2 = true` ❌ |
| "지각한 직원" | `problem_details_v2->>''has_late'' = ''true''` | - |
| "직원이 보고한 건" | `is_reported_v2 = true` | - |

### ✅ "이번 달 문제 있는 직원 목록"
```sql
SELECT DISTINCT full_name,
       (problem_details_v2->>''problem_count'')::int as problem_count
FROM v_shift_request_ai
WHERE company_id = $cid
  AND start_time_utc >= DATE_TRUNC(''month'', NOW())
  AND (problem_details_v2->>''problem_count'')::int > 0
ORDER BY problem_count DESC
```

### ✅ "문제 유형별 집계"
```sql
SELECT full_name,
       COUNT(*) FILTER (WHERE problem_details_v2->>''has_late'' = ''true'') as late_count,
       COUNT(*) FILTER (WHERE problem_details_v2->>''has_early_leave'' = ''true'') as early_leave_count,
       COUNT(*) FILTER (WHERE problem_details_v2->>''has_overtime'' = ''true'') as overtime_count
FROM v_shift_request_ai
WHERE company_id = $cid
  AND (problem_details_v2->>''problem_count'')::int > 0
GROUP BY full_name
```

### ⚠️ is_reported_v2 vs problem_count 차이
- `is_reported_v2 = true`: 직원이 "보고" 버튼 눌렀음 (극소수)
- `problem_count > 0`: 시스템이 감지한 실제 문제 (대다수)'
) ON CONFLICT (constraint_name) DO UPDATE SET
  ai_usage_hint = EXCLUDED.ai_usage_hint,
  severity = EXCLUDED.severity;

-- ================================================================
-- PART 7: ontology_embeddings 업데이트 ⭐⭐⭐
-- 기존 잘못된 임베딩 수정 + 새 임베딩 추가
-- source_id는 NOT NULL이므로 concept_id 사용
-- ================================================================

-- 7-1. is_reported_v2 컬럼 임베딩 수정
UPDATE ontology_embeddings
SET text_content = 'v_shift_request_ai.is_reported_v2: ⚠️ [주의] 이것은 "문제가 있다"가 아닙니다!

## is_reported_v2의 의미
- true = 직원이 수동으로 "문제 보고" 버튼을 눌러서 보고함
- 전체 문제의 극소수만 해당

## ❌ "문제 있는 직원" 찾을 때 이거 쓰면 안 됨!
WHERE is_reported_v2 = true  -- ❌ 직원 수동 보고만

## ✅ "문제가 있는 직원" 찾으려면
WHERE (problem_details_v2->>''problem_count'')::int > 0'
WHERE source_type = 'column'
  AND table_name = 'v_shift_request_ai'
  AND column_name = 'is_reported_v2';

-- 7-2. problem_unsolved 개념 임베딩 수정
UPDATE ontology_embeddings
SET text_content = 'problem_unsolved: 미해결 문제 조회

## ✅ 미해결 문제가 있는 시프트
```sql
WHERE (problem_details_v2->>''problem_count'')::int > 0
  AND is_problem_solved_v2 = false
```

## ⚠️ 주의
- is_problem_solved_v2 = false만으로 "문제 있음" 판단 ❌
- 반드시 problem_count > 0 조건 필요!'
WHERE source_type = 'concept'
  AND text_content LIKE 'problem_unsolved%';

-- 7-3: problem concept 임베딩 UPSERT (unique: source_type, source_id)
-- 한 concept에 하나의 embedding만 가능하므로 INSERT ON CONFLICT 사용
DO $$
DECLARE
  v_concept_id uuid;
BEGIN
  -- problem concept의 ID 가져오기
  SELECT concept_id INTO v_concept_id FROM ontology_concepts WHERE concept_name = 'problem';

  -- concept 임베딩 UPSERT (INSERT or UPDATE)
  INSERT INTO ontology_embeddings (
    embedding_id, source_type, source_id, text_content, concept_id, table_name, column_name, search_weight, is_active
  ) VALUES (
    gen_random_uuid(),
    'concept',
    v_concept_id,
    'problem: 문제/이슈 판단 기준

## 🔴 핵심 (AI 필독!)
| 조건 | 의미 | 결과 수 |
|------|------|---------|
| (problem_details_v2->>''problem_count'')::int > 0 | 실제 문제 있음 | 많음 |
| is_reported_v2 = true | 직원 수동 보고만 | 적음 |

## ✅ "문제 있는 직원" 조회
```sql
SELECT full_name, problem_details_v2
FROM v_shift_request_ai
WHERE company_id = $cid
  AND (problem_details_v2->>''problem_count'')::int > 0
```

## ❌ 틀린 패턴
is_reported_v2 = true는 "문제가 있다"가 아님!

## 문제 유형별 조회
```sql
-- 지각: WHERE problem_details_v2->>''has_late'' = ''true''
-- 조퇴: WHERE problem_details_v2->>''has_early_leave'' = ''true''
-- 초과근무: WHERE problem_details_v2->>''has_overtime'' = ''true''
```

## is_reported_v2 vs problem_count
- is_reported_v2 = true: 직원이 수동 보고한 건만 (극소수)
- problem_count > 0: 시스템 감지 실제 문제 (대다수)',
    v_concept_id,
    'v_shift_request_ai',
    'problem_details_v2',
    100,
    true
  )
  ON CONFLICT (source_type, source_id) DO UPDATE SET
    text_content = EXCLUDED.text_content,
    table_name = EXCLUDED.table_name,
    column_name = EXCLUDED.column_name,
    search_weight = EXCLUDED.search_weight,
    updated_at = NOW();

END $$;

-- 7-4: 동의어별 임베딩 추가 (각 synonym_id를 source_id로 사용)
DO $$
DECLARE
  v_synonym RECORD;
BEGIN
  -- problem concept에 연결된 각 동의어에 대해 임베딩 생성
  FOR v_synonym IN
    SELECT s.synonym_id, s.synonym_text
    FROM ontology_synonyms s
    JOIN ontology_concepts c ON s.concept_id = c.concept_id
    WHERE c.concept_name = 'problem'
  LOOP
    INSERT INTO ontology_embeddings (
      embedding_id, source_type, source_id, text_content, search_weight, is_active
    ) VALUES (
      gen_random_uuid(),
      'synonym',
      v_synonym.synonym_id,
      v_synonym.synonym_text || ' → problem: (problem_details_v2->>''problem_count'')::int > 0. 문제 = problem_count > 0, NOT is_reported_v2!',
      100,
      true
    )
    ON CONFLICT (source_type, source_id) DO UPDATE SET
      text_content = EXCLUDED.text_content,
      search_weight = EXCLUDED.search_weight,
      updated_at = NOW();
  END LOOP;
END $$;

-- 7-9. problem_details_v2 컬럼 임베딩 업데이트 (있다면)
UPDATE ontology_embeddings
SET text_content = 'v_shift_request_ai.problem_details_v2: JSONB 문제 상세 정보

## 🔴 핵심: "문제가 있다" 판단
```sql
WHERE (problem_details_v2->>''problem_count'')::int > 0
```

## ⚠️ is_reported_v2 = true는 "문제가 있다"가 아님!
- is_reported_v2: 직원 수동 보고만 (적음)
- problem_count > 0: 실제 문제 (많음)

## JSONB 필드 접근
```sql
-- ❌ 잘못된 사용
WHERE has_late = true  -- 에러!

-- ✅ 올바른 사용
WHERE problem_details_v2->>''has_late'' = ''true''
```

## 주요 필드
- problem_count: 총 문제 수 ⭐
- has_late: 지각
- has_overtime: 초과근무
- has_early_leave: 조퇴
- has_absence: 결근
- has_no_checkout: 미퇴근'
WHERE source_type = 'column'
  AND table_name = 'v_shift_request_ai'
  AND column_name = 'problem_details_v2';

-- 7-10. PROBLEM_TYPE_RULES 업데이트
UPDATE ontology_embeddings
SET text_content = 'PROBLEM_TYPE_RULES: 문제 유형 조회 규칙

## 🔴 핵심: "문제가 있다" = problem_count > 0

### ⚠️ is_reported_v2 ≠ 문제가 있다!
- is_reported_v2 = true: 직원 수동 보고만 (극소수)
- problem_count > 0: 실제 문제 (전체)

### 진짜 문제 조회 SQL
```sql
WHERE (problem_details_v2->>''problem_count'')::int > 0
```

### 문제 유형별 조회
| 문제유형 | 조건 |
|---------|------|
| 지각 | has_late = ''true'' |
| 조퇴 | has_early_leave = ''true'' |
| 야근 | has_overtime = ''true'' |
| 결근 | has_absence = ''true'' |
| 미퇴근 | has_no_checkout = ''true'' |

### 급여 영향 문제만 (has_payroll_XXX)
```sql
WHERE (
  problem_details_v2->>''has_payroll_late'' = ''true''
  OR problem_details_v2->>''has_payroll_early_leave'' = ''true''
  OR problem_details_v2->>''has_payroll_overtime'' = ''true''
)
```

### is_reported_solved_v2 의미
- NULL: 직원이 리포트 안 함
- FALSE: 리포트했지만 매니저 미확인
- TRUE: 매니저 확인 완료'
WHERE source_type = 'concept'
  AND text_content LIKE 'PROBLEM_TYPE_RULES%';

-- ================================================================
-- PART 9: Verification
-- ================================================================

SELECT '=== ontology_concepts: problem ===' as info;
SELECT concept_name, LEFT(ai_usage_hint, 200) as hint_preview
FROM ontology_concepts
WHERE concept_name = 'problem';

SELECT '=== ontology_synonyms: 문제 관련 ===' as info;
SELECT s.synonym_text, s.language_code, c.concept_name, s.search_weight
FROM ontology_synonyms s
JOIN ontology_concepts c ON s.concept_id = c.concept_id
WHERE c.concept_name = 'problem'
ORDER BY s.language_code, s.search_weight DESC;

SELECT '=== ontology_columns: 문제 관련 컬럼 ===' as info;
SELECT column_name, LEFT(ai_usage_hint, 150) as hint_preview
FROM ontology_columns
WHERE table_name = 'v_shift_request_ai'
  AND column_name IN ('is_reported_v2', 'problem_details_v2', 'is_problem_solved_v2')
ORDER BY column_name;

SELECT '=== ontology_constraints: problem_query_pattern ===' as info;
SELECT constraint_name, severity, LEFT(ai_usage_hint, 150) as hint_preview
FROM ontology_constraints
WHERE constraint_name = 'problem_query_pattern';

SELECT '=== ontology_embeddings: problem 관련 ===' as info;
SELECT source_type, LEFT(text_content, 100) as content_preview
FROM ontology_embeddings
WHERE text_content ILIKE '%problem_count%'
   OR text_content ILIKE '%is_reported_v2%'
ORDER BY source_type, text_content
LIMIT 15;

SELECT '=== 수정 완료 요약 ===' as info;
SELECT
  (SELECT COUNT(*) FROM ontology_concepts WHERE concept_name = 'problem') as concepts_added,
  (SELECT COUNT(*) FROM ontology_synonyms s
   JOIN ontology_concepts c ON s.concept_id = c.concept_id
   WHERE c.concept_name = 'problem') as synonyms_added,
  (SELECT COUNT(*) FROM ontology_constraints WHERE constraint_name = 'problem_query_pattern') as constraints_added,
  (SELECT COUNT(*) FROM ontology_embeddings WHERE text_content ILIKE '%problem_count%') as embeddings_with_problem_count;
