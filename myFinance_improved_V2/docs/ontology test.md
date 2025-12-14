# 🧪 AI SQL Generator 테스트 워크플로우 가이드

## 📋 개요

이 문서는 LuxApp AI SQL Generator (`ai-respond-user` Edge Function)의 테스트 방법을 설명합니다.

### 테스트 목적
1. AI가 생성하는 SQL이 올바른 테이블/뷰를 사용하는지 검증
2. deprecated 컬럼 사용 여부 확인
3. 하드코딩된 값(timezone, 연도 등) 검출
4. SQL 실행 성공률 측정

---

## 🏗️ 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                      테스트 흐름                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   [테스터]                                                   │
│      │                                                      │
│      │ 1. INSERT 질문                                        │
│      ▼                                                      │
│   ┌──────────────────┐                                      │
│   │ ai_test_queue    │  ◀── 질문 저장                        │
│   └────────┬─────────┘                                      │
│            │                                                │
│            │ 2. 트리거 자동 실행                              │
│            ▼                                                │
│   ┌──────────────────┐     HTTP POST      ┌──────────────┐  │
│   │ pg_net 트리거     │ ────────────────▶ │ai-respond-user│  │
│   └──────────────────┘                    └──────┬───────┘  │
│                                                  │          │
│                                                  │ 3. 결과   │
│                                                  ▼          │
│   [테스터]                                  ┌──────────────┐ │
│      │                                     │ ai_sql_logs  │ │
│      │ 4. SELECT 결과 확인                  └──────────────┘ │
│      ▼                                                      │
│   결과 분석 및 리포트                                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 빠른 시작 (5분)

### Step 1: 테스트 질문 INSERT

```sql
-- 단일 질문 테스트
INSERT INTO ai_test_queue (session_id, question) 
VALUES ('my-test-001', '오늘 지각한 직원 누구야?');

-- 여러 질문 한번에 테스트
INSERT INTO ai_test_queue (session_id, question) VALUES
('my-test-002', '이번 달 초과근무 총 시간'),
('my-test-003', '매장별 인건비'),
('my-test-004', '지각률 가장 높은 직원 TOP 5');
```

### Step 2: 결과 확인 (10~30초 후)

```sql
SELECT 
  session_id,
  question,
  success,
  row_count,
  error_message
FROM ai_sql_logs 
WHERE session_id LIKE 'my-test-%'
ORDER BY created_at DESC;
```

### Step 3: 품질 체크

```sql
SELECT 
  session_id,
  question,
  success,
  -- 핵심 품질 지표
  CASE WHEN generated_sql ILIKE '%v_shift_request_ai%' THEN '✅' ELSE '❌' END AS "AI뷰 사용",
  CASE WHEN generated_sql ILIKE '%problem_details_v2%' THEN '✅' ELSE '➖' END AS "JSONB 사용",
  CASE WHEN generated_sql ILIKE '%SELECT timezone FROM companies%' THEN '✅' ELSE '➖' END AS "동적TZ",
  CASE WHEN generated_sql ILIKE '%is_late_v2%' OR generated_sql ILIKE '%is_extratime_v2%' THEN '❌' ELSE '✅' END AS "deprecated 없음"
FROM ai_sql_logs 
WHERE session_id LIKE 'my-test-%'
ORDER BY session_id;
```

---

## 📝 상세 테스트 방법

### 방법 1: 개별 질문 테스트 (권장)

가장 간단한 방법입니다. `ai_test_queue` 테이블에 INSERT하면 트리거가 자동으로 Edge Function을 호출합니다.

```sql
-- 테스트 질문 추가
INSERT INTO ai_test_queue (session_id, question) 
VALUES 
  ('test-2024-001', '오늘 출근한 직원 몇 명이야?');

-- 10~30초 후 결과 확인
SELECT * FROM ai_sql_logs WHERE session_id = 'test-2024-001';
```

#### session_id 네이밍 규칙 (권장)

```
{카테고리}-{날짜}-{번호}

예시:
- basic-1214-001      : 기본 질문 테스트
- hard-1214-001       : 어려운 질문 테스트
- payroll-1214-001    : 급여 관련 테스트
- regression-1214-001 : 회귀 테스트
```

### 방법 2: 배치 테스트

여러 질문을 한번에 테스트할 때 사용합니다.

```sql
-- 20개 질문 배치 테스트
INSERT INTO ai_test_queue (session_id, question) VALUES
-- 기본 질문
('batch-001-01', '오늘 출근한 직원'),
('batch-001-02', '이번 주 지각자'),
('batch-001-03', '이번 달 급여 총액'),
-- 문제 유형별
('batch-001-04', '지각한 직원 목록'),
('batch-001-05', '초과근무한 직원'),
('batch-001-06', '조퇴한 직원'),
('batch-001-07', '결근자 현황'),
-- 복잡한 질문
('batch-001-08', '지각도 하고 야근도 한 직원'),
('batch-001-09', '지난달 대비 이번달 지각률'),
('batch-001-10', '매장별 가장 많이 야근한 직원');

-- 배치 결과 요약
SELECT 
  COUNT(*) as total,
  SUM(CASE WHEN success THEN 1 ELSE 0 END) as success_count,
  ROUND(AVG(CASE WHEN success THEN 1.0 ELSE 0.0 END) * 100, 1) as success_rate
FROM ai_sql_logs 
WHERE session_id LIKE 'batch-001-%';
```

### 방법 3: 기존 테스트 케이스 활용

`ontology_test_cases` 테이블에 저장된 테스트 케이스를 활용합니다.

```sql
-- 활성화된 테스트 케이스 목록 확인
SELECT test_id, question_ko, domain, tags 
FROM ontology_test_cases 
WHERE is_active = true
ORDER BY test_id;

-- 특정 도메인 테스트 케이스를 큐에 추가
INSERT INTO ai_test_queue (session_id, question)
SELECT 
  'domain-shift-' || test_id,
  question_ko
FROM ontology_test_cases 
WHERE is_active = true AND domain = 'shift';
```

---

## 📊 결과 분석 쿼리

### 1. 기본 결과 확인

```sql
SELECT 
  session_id,
  question,
  success,
  row_count,
  ROUND(execution_time_ms / 1000.0, 2) as exec_sec,
  LEFT(error_message, 50) as error_short
FROM ai_sql_logs 
WHERE session_id LIKE 'my-test-%'
ORDER BY created_at DESC;
```

### 2. 품질 점수 계산

```sql
WITH quality AS (
  SELECT 
    session_id,
    question,
    success,
    -- 각 항목별 점수 (20점씩)
    CASE WHEN generated_sql ILIKE '%v_shift_request_ai%' THEN 20 ELSE 0 END as ai_view_score,
    CASE WHEN generated_sql NOT ILIKE '%is_late_v2%' 
         AND generated_sql NOT ILIKE '%is_extratime_v2%' THEN 20 ELSE 0 END as no_deprecated_score,
    CASE WHEN generated_sql NOT ILIKE '%''Asia/Ho_Chi_Minh''%' THEN 20 ELSE 0 END as no_hardcode_tz_score,
    CASE WHEN generated_sql ILIKE '%SELECT timezone FROM companies%' THEN 20 ELSE 0 END as dynamic_tz_score,
    CASE WHEN success THEN 20 ELSE 0 END as execution_score
  FROM ai_sql_logs 
  WHERE session_id LIKE 'my-test-%'
)
SELECT 
  session_id,
  question,
  ai_view_score + no_deprecated_score + no_hardcode_tz_score + dynamic_tz_score + execution_score as total_score,
  CASE 
    WHEN ai_view_score + no_deprecated_score + no_hardcode_tz_score + dynamic_tz_score + execution_score >= 80 THEN '🟢 PASS'
    WHEN ai_view_score + no_deprecated_score + no_hardcode_tz_score + dynamic_tz_score + execution_score >= 60 THEN '🟡 WARN'
    ELSE '🔴 FAIL'
  END as grade
FROM quality
ORDER BY total_score DESC;
```

### 3. 전체 통계 요약

```sql
WITH stats AS (
  SELECT 
    COUNT(*) as total,
    SUM(CASE WHEN success THEN 1 ELSE 0 END) as success_cnt,
    SUM(CASE WHEN generated_sql ILIKE '%v_shift_request_ai%' THEN 1 ELSE 0 END) as ai_view_cnt,
    SUM(CASE WHEN generated_sql ILIKE '%problem_details_v2%' THEN 1 ELSE 0 END) as jsonb_cnt,
    SUM(CASE WHEN generated_sql ILIKE '%is_late_v2%' OR generated_sql ILIKE '%is_extratime_v2%' THEN 1 ELSE 0 END) as deprecated_cnt,
    SUM(CASE WHEN generated_sql ILIKE '%''Asia/Ho_Chi_Minh''%' THEN 1 ELSE 0 END) as hardcode_tz_cnt,
    SUM(CASE WHEN generated_sql ILIKE '%SELECT timezone FROM companies%' THEN 1 ELSE 0 END) as dynamic_tz_cnt
  FROM ai_sql_logs 
  WHERE session_id LIKE 'my-test-%'
)
SELECT 
  '총 테스트' as metric, total || '개' as value FROM stats
UNION ALL SELECT '실행 성공률', ROUND(success_cnt * 100.0 / NULLIF(total, 0), 1) || '%' FROM stats
UNION ALL SELECT '---', '---'
UNION ALL SELECT '✅ AI뷰 사용률', ROUND(ai_view_cnt * 100.0 / NULLIF(total, 0), 1) || '%' FROM stats
UNION ALL SELECT '✅ JSONB 사용률', ROUND(jsonb_cnt * 100.0 / NULLIF(total, 0), 1) || '%' FROM stats
UNION ALL SELECT '❌ deprecated 사용', deprecated_cnt || '건' FROM stats
UNION ALL SELECT '❌ TZ 하드코딩', hardcode_tz_cnt || '건' FROM stats
UNION ALL SELECT '✅ 동적 TZ 사용률', ROUND(dynamic_tz_cnt * 100.0 / NULLIF(total, 0), 1) || '%' FROM stats;
```

### 4. 실패 원인 분석

```sql
SELECT 
  CASE 
    WHEN error_message ILIKE '%timezone(character varying, interval)%' THEN 'INTERVAL AT TIME ZONE 문법 오류'
    WHEN error_message ILIKE '%syntax error%' THEN 'SQL 문법 오류'
    WHEN error_message ILIKE '%column%does not exist%' THEN '존재하지 않는 컬럼'
    WHEN error_message ILIKE '%relation%does not exist%' THEN '존재하지 않는 테이블'
    WHEN error_message ILIKE '%window function%' THEN '윈도우 함수 오류'
    ELSE '기타'
  END as error_type,
  COUNT(*) as count,
  ARRAY_AGG(DISTINCT LEFT(question, 30)) as sample_questions
FROM ai_sql_logs 
WHERE session_id LIKE 'my-test-%' 
  AND success = false
GROUP BY 1
ORDER BY count DESC;
```

### 5. 생성된 SQL 상세 보기

```sql
SELECT 
  session_id,
  question,
  generated_sql
FROM ai_sql_logs 
WHERE session_id = 'my-test-001';
```

---

## ✅ 품질 기준

### 필수 통과 항목 (0점이면 FAIL)

| 항목 | 체크 방법 | 기준 |
|------|----------|------|
| AI 뷰 사용 | `v_shift_request_ai` 포함 | 시프트 관련 질문에서 반드시 사용 |
| deprecated 컬럼 배제 | `is_late_v2`, `is_extratime_v2` 미포함 | 절대 사용 금지 |
| TZ 하드코딩 배제 | `'Asia/Ho_Chi_Minh'` 미포함 | 절대 사용 금지 |

### 권장 항목

| 항목 | 체크 방법 | 비고 |
|------|----------|------|
| JSONB 사용 | `problem_details_v2` 포함 | 지각/초과근무 등 문제 유형 질문에서 |
| 동적 TZ 사용 | `SELECT timezone FROM companies` 포함 | 시간 관련 질문에서 |
| SQL 실행 성공 | `success = true` | 80% 이상 권장 |

### 점수 기준

| 점수 | 등급 | 의미 |
|------|------|------|
| 80-100 | 🟢 PASS | 우수 |
| 60-79 | 🟡 WARN | 개선 필요 |
| 0-59 | 🔴 FAIL | 문제 있음 |

---

## 🔧 문제 해결

### 질문 INSERT 후 결과가 안 보일 때

1. **10~30초 대기**: Edge Function 실행에 시간이 걸립니다.
2. **트리거 확인**:
```sql
SELECT * FROM ai_test_queue WHERE session_id = 'your-session-id';
-- status가 'sent'인지 확인
```
3. **Edge Function 로그 확인**: Supabase Dashboard > Edge Functions > ai-respond-user > Logs

### deprecated 컬럼이 사용되고 있을 때

1. 온톨로지 테이블 확인:
```sql
SELECT * FROM ontology_columns 
WHERE column_name IN ('is_late_v2', 'is_extratime_v2', 'late_minutes_v2');
```
2. `v_shift_request_ai` 뷰에서 해당 컬럼 제거 필요

### 하드코딩된 timezone이 발견될 때

1. 온톨로지 concepts 확인:
```sql
SELECT concept_name, ai_usage_hint 
FROM ontology_concepts 
WHERE ai_usage_hint ILIKE '%Asia/Ho_Chi_Minh%';
```
2. 동적 timezone으로 수정:
```sql
UPDATE ontology_concepts
SET ai_usage_hint = REPLACE(ai_usage_hint, '''Asia/Ho_Chi_Minh''', 
    '(SELECT timezone FROM companies WHERE company_id = $company_id)')
WHERE ai_usage_hint ILIKE '%Asia/Ho_Chi_Minh%';
```

---

## 📁 관련 테이블 구조

### ai_test_queue (테스트 입력)

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | UUID | PK |
| session_id | TEXT | 테스트 식별자 (필수) |
| question | TEXT | 테스트 질문 (필수) |
| company_id | UUID | 기본값: ebd66ba7-... |
| user_id | UUID | 기본값: 0d2e61ad-... |
| status | TEXT | pending → sent |
| created_at | TIMESTAMPTZ | 생성 시각 |
| sent_at | TIMESTAMPTZ | 전송 시각 |

### ai_sql_logs (테스트 결과)

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | UUID | PK |
| session_id | TEXT | 테스트 식별자 |
| question | TEXT | 질문 |
| generated_sql | TEXT | AI가 생성한 SQL |
| success | BOOLEAN | 실행 성공 여부 |
| row_count | INTEGER | 결과 행 수 |
| error_message | TEXT | 에러 메시지 (실패 시) |
| execution_time_ms | INTEGER | 실행 시간 (ms) |
| created_at | TIMESTAMPTZ | 생성 시각 |

---

## 🏷️ 도메인별 테스트 가이드

현재 시스템은 여러 도메인을 지원합니다. 각 도메인별로 테스트 방법이 다릅니다.

### 도메인 현황

| 도메인 | 엔티티 수 | 주요 테이블 |
|--------|----------|------------|
| 재무/회계 | 11개 | accounts, journal_entries, cash_amount_entries, v_cash_location |
| 근태/시프트 | 4개 | v_shift_request_ai, store_shifts |
| 직원/사용자 | 6개 | users, user_salaries |
| 재고 | 2개 | current_stock, products |

---

### 💰 재무/회계 도메인 테스트

#### 테스트 질문 예시

```sql
INSERT INTO ai_test_queue (session_id, question) VALUES
-- 현금 관련
('finance-01', '오늘 금고 잔액 얼마야?'),
('finance-02', '이번 달 현금 입출금 내역'),
('finance-03', '캐셔별 시재 현황'),
-- 회계 관련
('finance-04', '이번 달 매출 총액'),
('finance-05', '비용 항목별 지출 내역'),
('finance-06', '계정과목별 잔액'),
-- 복잡한 질문
('finance-07', '지난달 대비 매출 증감'),
('finance-08', '매장별 수익성 비교'),
('finance-09', '현금 흐름 이상 감지');
```

#### 품질 체크 기준

```sql
SELECT 
  session_id,
  question,
  success,
  -- 재무 도메인 체크 항목
  CASE WHEN generated_sql ILIKE '%journal_entries%' 
       OR generated_sql ILIKE '%cash_amount_entries%'
       OR generated_sql ILIKE '%v_cash_location%'
       OR generated_sql ILIKE '%accounts%' 
       THEN '✅' ELSE '➖' END AS "재무테이블 사용",
  -- deprecated 체크 (재무 도메인용)
  CASE WHEN generated_sql ILIKE '%old_balance%' 
       OR generated_sql ILIKE '%legacy_amount%' 
       THEN '❌' ELSE '✅' END AS "deprecated 없음",
  -- 동적 TZ (공통)
  CASE WHEN generated_sql ILIKE '%SELECT timezone FROM companies%' THEN '✅' ELSE '➖' END AS "동적TZ"
FROM ai_sql_logs 
WHERE session_id LIKE 'finance-%'
ORDER BY session_id;
```

#### 재무 도메인 핵심 테이블 관계

```
┌─────────────────┐     ┌─────────────────┐
│ journal_entries │────▶│ journal_lines   │
│ (거래 헤더)      │     │ (차변/대변)      │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │                       ▼
         │              ┌─────────────────┐
         │              │ accounts        │
         │              │ (계정과목)       │
         │              └─────────────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│cash_amount_entries│──▶│ v_cash_location │
│ (현금 거래)       │    │ (현금 위치 뷰)   │
└─────────────────┘     └─────────────────┘
```

---

### 👷 근태/시프트 도메인 테스트

#### 테스트 질문 예시

```sql
INSERT INTO ai_test_queue (session_id, question) VALUES
('shift-01', '오늘 출근한 직원'),
('shift-02', '이번 주 지각자'),
('shift-03', '초과근무 현황'),
('shift-04', '매장별 인건비');
```

#### 품질 체크 기준

```sql
SELECT 
  session_id,
  question,
  success,
  -- 근태 도메인 체크 항목
  CASE WHEN generated_sql ILIKE '%v_shift_request_ai%' THEN '✅' ELSE '❌' END AS "AI뷰 사용",
  CASE WHEN generated_sql ILIKE '%problem_details_v2%' THEN '✅' ELSE '➖' END AS "JSONB 사용",
  -- deprecated 체크 (근태 도메인용)
  CASE WHEN generated_sql ILIKE '%is_late_v2%' 
       OR generated_sql ILIKE '%is_extratime_v2%' 
       OR generated_sql ILIKE '%late_minutes_v2%' 
       THEN '❌' ELSE '✅' END AS "deprecated 없음",
  -- 동적 TZ
  CASE WHEN generated_sql ILIKE '%SELECT timezone FROM companies%' THEN '✅' ELSE '➖' END AS "동적TZ"
FROM ai_sql_logs 
WHERE session_id LIKE 'shift-%'
ORDER BY session_id;
```

---

### 📦 재고 도메인 테스트

#### 테스트 질문 예시

```sql
INSERT INTO ai_test_queue (session_id, question) VALUES
('inventory-01', '재고 부족 상품 목록'),
('inventory-02', '상품별 현재 재고'),
('inventory-03', '매장별 재고 현황');
```

#### 품질 체크 기준

```sql
SELECT 
  session_id,
  question,
  success,
  CASE WHEN generated_sql ILIKE '%current_stock%' 
       OR generated_sql ILIKE '%products%' 
       THEN '✅' ELSE '➖' END AS "재고테이블 사용"
FROM ai_sql_logs 
WHERE session_id LIKE 'inventory-%';
```

---

### 🔄 범용 품질 체크 함수

모든 도메인에서 사용할 수 있는 품질 체크 함수:

```sql
-- 범용 품질 체크 함수
CREATE OR REPLACE FUNCTION check_domain_quality(
  p_session_pattern TEXT,
  p_domain TEXT  -- 'finance', 'shift', 'inventory', 'user'
)
RETURNS TABLE (
  session_id TEXT,
  question TEXT,
  success BOOLEAN,
  uses_correct_table BOOLEAN,
  has_deprecated BOOLEAN,
  has_dynamic_tz BOOLEAN,
  quality_score INT
) AS $$
DECLARE
  v_required_tables TEXT[];
  v_deprecated_cols TEXT[];
BEGIN
  -- 도메인별 설정
  CASE p_domain
    WHEN 'finance' THEN
      v_required_tables := ARRAY['journal_entries', 'cash_amount_entries', 'v_cash_location', 'accounts'];
      v_deprecated_cols := ARRAY['old_balance', 'legacy_amount'];
    WHEN 'shift' THEN
      v_required_tables := ARRAY['v_shift_request_ai'];
      v_deprecated_cols := ARRAY['is_late_v2', 'is_extratime_v2', 'late_minutes_v2', 'overtime_minutes_v2'];
    WHEN 'inventory' THEN
      v_required_tables := ARRAY['current_stock', 'products'];
      v_deprecated_cols := ARRAY['old_qty'];
    WHEN 'user' THEN
      v_required_tables := ARRAY['users', 'user_salaries'];
      v_deprecated_cols := ARRAY['old_salary'];
    ELSE
      v_required_tables := ARRAY[]::TEXT[];
      v_deprecated_cols := ARRAY[]::TEXT[];
  END CASE;

  RETURN QUERY
  SELECT 
    l.session_id,
    l.question,
    l.success,
    -- 올바른 테이블 사용 여부
    EXISTS (
      SELECT 1 FROM unnest(v_required_tables) tbl 
      WHERE l.generated_sql ILIKE '%' || tbl || '%'
    ),
    -- deprecated 컬럼 사용 여부
    EXISTS (
      SELECT 1 FROM unnest(v_deprecated_cols) col 
      WHERE l.generated_sql ILIKE '%' || col || '%'
    ),
    -- 동적 TZ 사용
    l.generated_sql ILIKE '%SELECT timezone FROM companies%',
    -- 품질 점수 계산
    (
      CASE WHEN EXISTS (
        SELECT 1 FROM unnest(v_required_tables) tbl 
        WHERE l.generated_sql ILIKE '%' || tbl || '%'
      ) THEN 30 ELSE 0 END +
      CASE WHEN NOT EXISTS (
        SELECT 1 FROM unnest(v_deprecated_cols) col 
        WHERE l.generated_sql ILIKE '%' || col || '%'
      ) THEN 30 ELSE 0 END +
      CASE WHEN l.generated_sql NOT ILIKE '%''Asia/Ho_Chi_Minh''%' THEN 20 ELSE 0 END +
      CASE WHEN l.success THEN 20 ELSE 0 END
    )::INT
  FROM ai_sql_logs l
  WHERE l.session_id LIKE p_session_pattern;
END;
$$ LANGUAGE plpgsql;

-- 사용 예시
SELECT * FROM check_domain_quality('finance-%', 'finance');
SELECT * FROM check_domain_quality('shift-%', 'shift');
SELECT * FROM check_domain_quality('inventory-%', 'inventory');
```

---

## 📌 자주 사용하는 테스트 질문

### 기본 질문 (쉬움)

```sql
INSERT INTO ai_test_queue (session_id, question) VALUES
('basic-01', '오늘 출근한 직원'),
('basic-02', '이번 주 지각자'),
('basic-03', '이번 달 급여 총액'),
('basic-04', '직원별 근무시간');
```

### 문제 유형별 (중간)

```sql
INSERT INTO ai_test_queue (session_id, question) VALUES
('type-01', '지각한 직원 목록'),
('type-02', '초과근무한 직원'),
('type-03', '조퇴한 직원'),
('type-04', '결근자 현황'),
('type-05', '미퇴근 기록');
```

### 복잡한 질문 (어려움)

```sql
INSERT INTO ai_test_queue (session_id, question) VALUES
('hard-01', '지각도 하고 야근도 한 직원'),
('hard-02', '지난달 대비 이번달 지각률 변화'),
('hard-03', '매장별 가장 많이 야근한 직원'),
('hard-04', '연속 3일 이상 야근한 직원'),
('hard-05', '지각 차감액이 보너스보다 큰 직원');
```

### 모호한 질문 (AI 해석력 테스트)

```sql
INSERT INTO ai_test_queue (session_id, question) VALUES
('vague-01', '문제 있는 직원'),
('vague-02', '요즘 근태 어때?'),
('vague-03', '일 잘하는 직원'),
('vague-04', '출퇴근 이상한 사람');
```

---

## 🔄 정기 테스트 체크리스트

### 배포 전 테스트

- [ ] 기본 질문 10개 성공률 90% 이상
- [ ] deprecated 컬럼 사용 0건
- [ ] TZ 하드코딩 0건
- [ ] v_shift_request_ai 사용률 100%

### 주간 회귀 테스트

- [ ] ontology_test_cases 전체 실행
- [ ] 실패율 20% 이하
- [ ] 품질 점수 평균 70점 이상

---

## 📞 문의

- 온톨로지 관련: ontology_* 테이블 수정
- Edge Function 관련: ai-respond-user 로그 확인
- 테스트 인프라: ai_test_queue 트리거 확인

---

## ⚙️ 커스터마이징 가이드

다른 회사, 다른 테이블, 다른 프로젝트에서 테스트하려면 아래 항목들을 수정해야 합니다.

### 1. 다른 회사/사용자로 테스트

#### 방법 A: INSERT 시 직접 지정

```sql
-- 다른 회사/사용자로 테스트
INSERT INTO ai_test_queue (session_id, question, company_id, user_id) 
VALUES (
  'other-company-test-001', 
  '오늘 출근한 직원',
  'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',  -- 다른 company_id
  'ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj'   -- 다른 user_id
);
```

#### 방법 B: 테이블 기본값 변경

```sql
-- ai_test_queue 테이블의 기본값 변경
ALTER TABLE ai_test_queue 
ALTER COLUMN company_id SET DEFAULT 'new-company-uuid'::uuid;

ALTER TABLE ai_test_queue 
ALTER COLUMN user_id SET DEFAULT 'new-user-uuid'::uuid;
```

#### 회사/사용자 ID 찾기

```sql
-- 회사 목록 확인
SELECT company_id, company_name, timezone FROM companies;

-- 특정 회사의 사용자 목록
SELECT user_id, first_name, last_name, email 
FROM users 
WHERE company_id = 'your-company-id';
```

---

### 2. 다른 Supabase 프로젝트로 변경

트리거 함수에서 Edge Function URL과 인증 토큰을 수정해야 합니다.

```sql
-- 트리거 함수 수정
CREATE OR REPLACE FUNCTION trigger_ai_test_on_insert()
RETURNS TRIGGER AS $$
DECLARE
  request_id bigint;
BEGIN
  SELECT net.http_post(
    -- ✅ 1. Edge Function URL 변경
    url := 'https://[YOUR_PROJECT_REF].supabase.co/functions/v1/ai-respond-user',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      -- ✅ 2. Anon Key 변경
      'Authorization', 'Bearer [YOUR_ANON_KEY]'
    ),
    body := jsonb_build_object(
      'question', NEW.question,
      'company_id', NEW.company_id,
      'user_id', NEW.user_id,
      'session_id', NEW.session_id
    )
  ) INTO request_id;
  
  UPDATE ai_test_queue 
  SET status = 'sent', sent_at = NOW()
  WHERE id = NEW.id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### 필요한 정보 찾기

| 항목 | 위치 |
|------|------|
| Project Ref | Supabase Dashboard > Settings > General > Reference ID |
| Anon Key | Supabase Dashboard > Settings > API > anon public |
| Service Role Key | Supabase Dashboard > Settings > API > service_role (비공개) |

---

### 3. 다른 테이블/뷰 품질 체크

시프트가 아닌 다른 도메인(예: 재고, 매출, 고객)을 테스트할 때 품질 체크 기준을 수정합니다.

#### 예시: 재고 테이블 테스트

```sql
-- 재고 관련 품질 체크
SELECT 
  session_id,
  question,
  success,
  -- 재고 전용 뷰 사용 체크
  CASE WHEN generated_sql ILIKE '%v_inventory_ai%' THEN '✅' ELSE '❌' END AS "재고AI뷰",
  -- 재고 deprecated 컬럼 체크
  CASE WHEN generated_sql ILIKE '%old_stock_qty%' THEN '❌' ELSE '✅' END AS "deprecated 없음",
  -- 동적 TZ (공통)
  CASE WHEN generated_sql ILIKE '%SELECT timezone FROM companies%' THEN '✅' ELSE '➖' END AS "동적TZ"
FROM ai_sql_logs 
WHERE session_id LIKE 'inventory-test-%';
```

#### 품질 체크 템플릿 함수

```sql
-- 재사용 가능한 품질 체크 함수
CREATE OR REPLACE FUNCTION check_sql_quality(
  p_session_pattern TEXT,
  p_required_view TEXT DEFAULT 'v_shift_request_ai',
  p_deprecated_cols TEXT[] DEFAULT ARRAY['is_late_v2', 'is_extratime_v2']
)
RETURNS TABLE (
  session_id TEXT,
  question TEXT,
  success BOOLEAN,
  uses_view BOOLEAN,
  has_deprecated BOOLEAN,
  has_hardcoded_tz BOOLEAN,
  has_dynamic_tz BOOLEAN,
  quality_score INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    l.session_id,
    l.question,
    l.success,
    l.generated_sql ILIKE '%' || p_required_view || '%',
    EXISTS (
      SELECT 1 FROM unnest(p_deprecated_cols) col 
      WHERE l.generated_sql ILIKE '%' || col || '%'
    ),
    l.generated_sql ILIKE '%''Asia/Ho_Chi_Minh''%',
    l.generated_sql ILIKE '%SELECT timezone FROM companies%',
    (
      CASE WHEN l.generated_sql ILIKE '%' || p_required_view || '%' THEN 25 ELSE 0 END +
      CASE WHEN NOT EXISTS (
        SELECT 1 FROM unnest(p_deprecated_cols) col 
        WHERE l.generated_sql ILIKE '%' || col || '%'
      ) THEN 25 ELSE 0 END +
      CASE WHEN l.generated_sql NOT ILIKE '%''Asia/Ho_Chi_Minh''%' THEN 25 ELSE 0 END +
      CASE WHEN l.success THEN 25 ELSE 0 END
    )::INT
  FROM ai_sql_logs l
  WHERE l.session_id LIKE p_session_pattern;
END;
$$ LANGUAGE plpgsql;

-- 사용 예시
SELECT * FROM check_sql_quality(
  'inventory-test-%',           -- 세션 패턴
  'v_inventory_ai',             -- 필수 뷰
  ARRAY['old_stock_qty', 'deprecated_col']  -- deprecated 컬럼 목록
);
```

---

### 4. 새로운 도메인 온톨로지 추가

AI가 새로운 테이블/뷰를 올바르게 사용하도록 온톨로지를 추가해야 합니다.

#### Step 1: 엔티티 추가

```sql
-- 새 테이블/뷰 등록
INSERT INTO ontology_entities (
  entity_name,
  table_name,
  description,
  ai_usage_hint,
  is_active
) VALUES (
  'InventoryAI',
  'v_inventory_ai',
  '재고 관리용 AI 전용 뷰',
  '## v_inventory_ai - 재고 조회용
  
### 필수 사용 상황
- 재고 수량 질문
- 입출고 내역 질문
- 재고 부족 알림

### 주요 컬럼
- current_qty: 현재 재고
- min_qty: 최소 재고
- last_inbound_at: 마지막 입고일

### 사용 금지 컬럼
- old_stock_qty (deprecated)',
  true
);
```

#### Step 2: 컬럼 정보 추가

```sql
-- 주요 컬럼 등록
INSERT INTO ontology_columns (entity_name, column_name, data_type, description, ai_usage_hint)
VALUES 
  ('InventoryAI', 'current_qty', 'numeric', '현재 재고 수량', '재고 수량 질문에 사용'),
  ('InventoryAI', 'min_qty', 'numeric', '최소 재고 수량', '재고 부족 판단에 사용'),
  ('InventoryAI', 'product_name', 'text', '상품명', '상품 검색에 사용');
```

#### Step 3: 개념(Concept) 추가

```sql
-- AI 힌트 개념 추가
INSERT INTO ontology_concepts (
  concept_name,
  description,
  ai_usage_hint,
  is_active
) VALUES (
  'inventory_query_rules',
  '재고 조회 규칙',
  '## 재고 질문 처리 규칙

### 필수 테이블
- v_inventory_ai 사용 (inventory 테이블 직접 사용 금지)

### 재고 부족 판단
WHERE current_qty < min_qty

### 시간대 처리
- 항상 동적 timezone 사용
- AT TIME ZONE (SELECT timezone FROM companies WHERE company_id = $company_id)',
  true
);
```

#### Step 4: 테스트 케이스 추가

```sql
-- 새 도메인 테스트 케이스
INSERT INTO ontology_test_cases (
  question_ko,
  domain,
  tags,
  expected_tables,
  is_active
) VALUES 
  ('재고 부족한 상품 목록', 'inventory', ARRAY['stock', 'alert'], ARRAY['v_inventory_ai'], true),
  ('오늘 입고된 상품', 'inventory', ARRAY['inbound'], ARRAY['v_inventory_ai'], true),
  ('상품별 재고 현황', 'inventory', ARRAY['stock', 'summary'], ARRAY['v_inventory_ai'], true);
```

---

### 5. 전체 설정 체크리스트

새로운 환경에서 테스트 시스템을 설정할 때:

#### 필수 설정

- [ ] `ai_test_queue` 테이블 생성
- [ ] `trigger_ai_test_on_insert` 트리거 함수 생성
- [ ] 트리거 함수에 올바른 URL/Auth 설정
- [ ] `pg_net` 확장 활성화 확인

#### 선택 설정

- [ ] 기본 company_id/user_id 설정
- [ ] 품질 체크 함수 생성
- [ ] 온톨로지 테이블에 새 도메인 추가
- [ ] 테스트 케이스 추가

#### 확인 쿼리

```sql
-- 1. pg_net 확장 확인
SELECT * FROM pg_extension WHERE extname = 'pg_net';

-- 2. 트리거 확인
SELECT trigger_name, event_manipulation, action_statement
FROM information_schema.triggers
WHERE trigger_name = 'auto_test_on_insert';

-- 3. 테이블 확인
SELECT table_name FROM information_schema.tables 
WHERE table_name IN ('ai_test_queue', 'ai_sql_logs', 'ontology_test_cases');

-- 4. 온톨로지 엔티티 확인
SELECT entity_name, table_name, is_active 
FROM ontology_entities 
WHERE is_active = true;
```

---

### 6. 환경별 설정 예시

#### 개발 환경

```sql
-- 개발용 설정
ALTER TABLE ai_test_queue 
ALTER COLUMN company_id SET DEFAULT 'dev-company-uuid'::uuid;

-- 트리거에서 개발 Edge Function URL 사용
-- url := 'https://dev-project.supabase.co/functions/v1/ai-respond-user'
```

#### 스테이징 환경

```sql
-- 스테이징용 설정
ALTER TABLE ai_test_queue 
ALTER COLUMN company_id SET DEFAULT 'staging-company-uuid'::uuid;

-- 트리거에서 스테이징 Edge Function URL 사용
-- url := 'https://staging-project.supabase.co/functions/v1/ai-respond-user'
```

#### 프로덕션 환경

```sql
-- 프로덕션은 직접 테스트 금지!
-- 별도의 테스트 회사 계정 사용 권장
ALTER TABLE ai_test_queue 
ALTER COLUMN company_id SET DEFAULT 'test-company-in-prod-uuid'::uuid;
```

---

## 📞 문의

- 온톨로지 관련: ontology_* 테이블 수정
- Edge Function 관련: ai-respond-user 로그 확인
- 테스트 인프라: ai_test_queue 트리거 확인

---

*마지막 업데이트: 2025-12-14*