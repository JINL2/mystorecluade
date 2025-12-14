-- ============================================
-- AI Test Automation System - Views
-- 실행 순서: 2번째 (테이블 생성 후)
-- ============================================

-- ============================================
-- 1. v_test_run_summary: 테스트 런 요약
-- ============================================

CREATE OR REPLACE VIEW v_test_run_summary AS
SELECT
  run_id,
  run_name,
  ontology_version,
  edge_function_version,
  status,

  -- 결과 집계
  total_cases,
  passed_count,
  failed_count,
  error_count,

  -- 비율 계산
  CASE WHEN total_cases > 0
    THEN ROUND(passed_count * 100.0 / total_cases, 1)
    ELSE 0
  END AS pass_rate,

  avg_score,

  -- 품질 이슈 요약
  (quality_summary->>'tz_hardcode')::int AS tz_hardcode_count,
  (quality_summary->>'deprecated_cols')::int AS deprecated_cols_count,
  (quality_summary->>'year_hardcode')::int AS year_hardcode_count,
  (quality_summary->>'sql_error')::int AS sql_error_count,

  -- 시간
  started_at,
  completed_at,
  execution_time_ms,
  CASE WHEN execution_time_ms IS NOT NULL
    THEN ROUND(execution_time_ms / 1000.0, 1) || 's'
    ELSE NULL
  END AS duration,

  created_by,
  created_at

FROM ai_test_runs
ORDER BY created_at DESC;

COMMENT ON VIEW v_test_run_summary IS '테스트 런 요약 뷰. 각 배치 테스트의 결과와 품질 점수 확인';


-- ============================================
-- 2. v_test_quality_report: 품질 이슈 상세 리포트
-- ============================================

CREATE OR REPLACE VIEW v_test_quality_report AS
SELECT
  tr.run_id,
  tr.run_name,
  tc.test_id,
  tc.domain,
  tc.question_ko,
  tc.difficulty,

  -- 결과
  r.is_pass,
  r.score,
  r.failure_reason,

  -- 품질 체크 상세
  (r.quality_checks->>'tz_hardcode')::boolean AS has_tz_hardcode,
  (r.quality_checks->>'tz_dynamic')::boolean AS has_tz_dynamic,
  r.quality_checks->'deprecated_cols' AS deprecated_cols_used,
  (r.quality_checks->>'year_hardcode')::boolean AS has_year_hardcode,
  (r.quality_checks->>'extract_cast')::boolean AS has_extract_cast_issue,
  (r.quality_checks->>'sql_valid')::boolean AS sql_valid,

  -- SQL
  r.ai_sql,
  tc.expected_sql,

  -- 성능
  r.ai_execution_time_ms,

  r.tested_at

FROM ontology_test_results r
JOIN ai_test_runs tr ON tr.run_id = r.run_id
JOIN ontology_test_cases tc ON tc.test_id = r.test_id
ORDER BY tr.created_at DESC, r.score ASC;

COMMENT ON VIEW v_test_quality_report IS '품질 이슈 상세 리포트. 실패한 테스트와 품질 문제 확인';


-- ============================================
-- 3. v_test_domain_stats: 도메인별 통계
-- ============================================

CREATE OR REPLACE VIEW v_test_domain_stats AS
SELECT
  tr.run_id,
  tr.run_name,
  tc.domain,

  COUNT(*) AS total_cases,
  SUM(CASE WHEN r.is_pass THEN 1 ELSE 0 END) AS passed,
  SUM(CASE WHEN NOT r.is_pass AND (r.quality_checks->>'sql_valid')::boolean = true THEN 1 ELSE 0 END) AS failed_quality,
  SUM(CASE WHEN (r.quality_checks->>'sql_valid')::boolean = false THEN 1 ELSE 0 END) AS sql_errors,

  ROUND(AVG(r.score), 1) AS avg_score,
  ROUND(AVG(r.ai_execution_time_ms)) AS avg_time_ms,

  -- 주요 이슈 카운트
  SUM(CASE WHEN (r.quality_checks->>'tz_hardcode')::boolean = true THEN 1 ELSE 0 END) AS tz_hardcode_issues,
  SUM(CASE WHEN jsonb_array_length(COALESCE(r.quality_checks->'deprecated_cols', '[]'::jsonb)) > 0 THEN 1 ELSE 0 END) AS deprecated_col_issues

FROM ontology_test_results r
JOIN ai_test_runs tr ON tr.run_id = r.run_id
JOIN ontology_test_cases tc ON tc.test_id = r.test_id
GROUP BY tr.run_id, tr.run_name, tc.domain
ORDER BY tr.created_at DESC, tc.domain;

COMMENT ON VIEW v_test_domain_stats IS '도메인별 테스트 통계. HR, 회계, 현금 등 영역별 품질 확인';


-- ============================================
-- 4. v_test_failed_cases: 실패한 테스트 케이스
-- ============================================

CREATE OR REPLACE VIEW v_test_failed_cases AS
SELECT
  tr.run_id,
  tr.run_name,
  tc.test_id,
  tc.domain,
  tc.question_ko,
  tc.tags,

  r.score,
  r.failure_reason,

  -- 이슈 플래그
  CASE WHEN (r.quality_checks->>'tz_hardcode')::boolean = true THEN '🔴TZ ' ELSE '' END ||
  CASE WHEN jsonb_array_length(COALESCE(r.quality_checks->'deprecated_cols', '[]'::jsonb)) > 0 THEN '🔴DEP ' ELSE '' END ||
  CASE WHEN (r.quality_checks->>'year_hardcode')::boolean = true THEN '🟡YEAR ' ELSE '' END ||
  CASE WHEN (r.quality_checks->>'sql_valid')::boolean = false THEN '❌SQL' ELSE '' END
  AS issue_flags,

  r.ai_sql,
  tc.expected_sql,

  r.tested_at

FROM ontology_test_results r
JOIN ai_test_runs tr ON tr.run_id = r.run_id
JOIN ontology_test_cases tc ON tc.test_id = r.test_id
WHERE r.is_pass = false
ORDER BY tr.created_at DESC, r.score ASC;

COMMENT ON VIEW v_test_failed_cases IS '실패한 테스트 케이스 목록. 문제 해결 우선순위 파악용';


-- ============================================
-- 5. v_test_improvement_trend: 버전별 개선 추이
-- ============================================

CREATE OR REPLACE VIEW v_test_improvement_trend AS
SELECT
  run_id,
  run_name,
  edge_function_version,
  ontology_version,
  created_at::date AS test_date,

  total_cases,
  passed_count,
  ROUND(passed_count * 100.0 / NULLIF(total_cases, 0), 1) AS pass_rate,
  avg_score,

  (quality_summary->>'tz_hardcode')::int AS tz_issues,
  (quality_summary->>'deprecated_cols')::int AS deprecated_issues,
  (quality_summary->>'sql_error')::int AS sql_errors,

  execution_time_ms

FROM ai_test_runs
WHERE status = 'completed'
ORDER BY created_at DESC;

COMMENT ON VIEW v_test_improvement_trend IS '버전별 개선 추이. 온톨로지/Edge Function 업데이트 효과 확인';


-- ============================================
-- 6. v_test_latest_results: 최신 테스트 결과 (빠른 조회용)
-- ============================================

CREATE OR REPLACE VIEW v_test_latest_results AS
WITH latest_run AS (
  SELECT run_id FROM ai_test_runs
  WHERE status = 'completed'
  ORDER BY created_at DESC
  LIMIT 1
)
SELECT
  tc.test_id,
  tc.domain,
  tc.question_ko,
  tc.difficulty,
  tc.tags,

  r.is_pass,
  r.score,
  r.failure_reason,
  r.quality_checks,
  r.ai_sql,
  r.tested_at

FROM ontology_test_results r
JOIN ontology_test_cases tc ON tc.test_id = r.test_id
WHERE r.run_id = (SELECT run_id FROM latest_run)
ORDER BY r.is_pass ASC, r.score ASC;

COMMENT ON VIEW v_test_latest_results IS '최신 테스트 런의 결과. 빠른 조회용';
