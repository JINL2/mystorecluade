-- ============================================
-- AI Test Automation System - Tables
-- 실행 순서: 1번째
-- ============================================

-- ============================================
-- 1. ai_test_runs 테이블 (신규)
-- ============================================

CREATE TABLE IF NOT EXISTS ai_test_runs (
  run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_name TEXT NOT NULL,
  description TEXT,

  -- 설정
  config JSONB DEFAULT '{}',
  ontology_version TEXT,
  edge_function_version TEXT,

  -- 필터
  filter_domains TEXT[],
  filter_tags TEXT[],
  filter_test_ids INTEGER[],

  -- 결과 집계
  total_cases INTEGER DEFAULT 0,
  passed_count INTEGER DEFAULT 0,
  failed_count INTEGER DEFAULT 0,
  error_count INTEGER DEFAULT 0,

  -- 품질 점수
  avg_score NUMERIC(5,2),
  quality_summary JSONB,

  -- 상태
  status TEXT DEFAULT 'pending',
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  execution_time_ms INTEGER,

  -- 메타
  created_at TIMESTAMPTZ DEFAULT NOW(),
  created_by TEXT
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_test_runs_status ON ai_test_runs(status);
CREATE INDEX IF NOT EXISTS idx_test_runs_created ON ai_test_runs(created_at DESC);

COMMENT ON TABLE ai_test_runs IS '테스트 실행 배치 관리. 여러 테스트 케이스를 그룹으로 실행하고 결과를 집계';


-- ============================================
-- 2. ontology_test_cases 확장
-- ============================================

-- 품질 검증 규칙 컬럼 추가
ALTER TABLE ontology_test_cases
ADD COLUMN IF NOT EXISTS quality_rules JSONB DEFAULT '{}';

-- 우선순위 컬럼 추가
ALTER TABLE ontology_test_cases
ADD COLUMN IF NOT EXISTS priority INTEGER DEFAULT 50;

-- 언어별 질문 추가
ALTER TABLE ontology_test_cases
ADD COLUMN IF NOT EXISTS question_vi TEXT;

-- 마지막 테스트 결과 캐시
ALTER TABLE ontology_test_cases
ADD COLUMN IF NOT EXISTS last_test_result JSONB;

ALTER TABLE ontology_test_cases
ADD COLUMN IF NOT EXISTS last_tested_at TIMESTAMPTZ;

COMMENT ON COLUMN ontology_test_cases.quality_rules IS '품질 검증 규칙. 예: {"must_use_dynamic_tz": true, "forbidden_columns": ["is_late_v2"]}';
COMMENT ON COLUMN ontology_test_cases.priority IS '실행 우선순위 (높을수록 먼저). 기본 50';


-- ============================================
-- 3. ontology_test_results 확장
-- ============================================

-- ai_sql_logs 연결
ALTER TABLE ontology_test_results
ADD COLUMN IF NOT EXISTS sql_log_id UUID;

-- 품질 체크 상세
ALTER TABLE ontology_test_results
ADD COLUMN IF NOT EXISTS quality_checks JSONB DEFAULT '{}';

-- 실행 상세
ALTER TABLE ontology_test_results
ADD COLUMN IF NOT EXISTS context_load_time_ms INTEGER;

ALTER TABLE ontology_test_results
ADD COLUMN IF NOT EXISTS ai_call_time_ms INTEGER;

ALTER TABLE ontology_test_results
ADD COLUMN IF NOT EXISTS sql_execution_time_ms INTEGER;

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_test_results_run ON ontology_test_results(run_id);
CREATE INDEX IF NOT EXISTS idx_test_results_pass ON ontology_test_results(is_pass);
CREATE INDEX IF NOT EXISTS idx_test_results_sql_log ON ontology_test_results(sql_log_id);

COMMENT ON COLUMN ontology_test_results.quality_checks IS '품질 체크 결과. 예: {"tz_hardcode": false, "deprecated_cols": [], "score": 95}';
