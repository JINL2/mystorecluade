# AI Test Automation System - Complete Implementation Guide

> **목적**: ontology_test_cases에 100개 질문을 넣고 자동으로 ai-respond-user를 테스트하여 품질 분석

---

## 📐 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     AI TEST AUTOMATION SYSTEM                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────────┐                                                       │
│  │ ontology_test    │  100개 테스트 케이스                                   │
│  │ _cases           │  (question + expected_sql + quality_rules)            │
│  └────────┬─────────┘                                                       │
│           │                                                                 │
│           │ 1. POST /ai-test-runner                                         │
│           ▼                                                                 │
│  ┌──────────────────┐                                                       │
│  │ ai-test-runner   │  테스트 오케스트레이터                                 │
│  │ (Edge Function)  │  - 배치 실행 관리                                     │
│  │                  │  - 품질 체크 자동화                                    │
│  └────────┬─────────┘                                                       │
│           │                                                                 │
│           │ 2. 각 질문 순차 호출                                             │
│           ▼                                                                 │
│  ┌──────────────────┐      HTTP POST       ┌──────────────────┐            │
│  │  Loop per test   │ ──────────────────▶  │ ai-respond-user  │            │
│  │  case            │                      │ (v11)            │            │
│  └──────────────────┘                      └────────┬─────────┘            │
│                                                     │                      │
│                                                     │ 자동 저장             │
│                                                     ▼                      │
│  ┌──────────────────┐                      ┌──────────────────┐            │
│  │ ai_test_runs     │                      │ ai_sql_logs      │            │
│  │ (배치 관리)       │                      │ (AI 응답 로그)    │            │
│  └────────┬─────────┘                      └────────┬─────────┘            │
│           │                                         │                      │
│           │ 3. 품질 체크 + 결과 저장                  │                      │
│           ▼                                         │                      │
│  ┌──────────────────┐◀──── session_id 연결 ─────────┘                      │
│  │ ontology_test    │                                                       │
│  │ _results         │                                                       │
│  └────────┬─────────┘                                                       │
│           │                                                                 │
│           │ 4. 분석                                                         │
│           ▼                                                                 │
│  ┌──────────────────────────────────────────────────┐                      │
│  │ Analysis Views                                   │                      │
│  │ - v_test_run_summary (배치별 요약)                │                      │
│  │ - v_test_quality_report (품질 리포트)             │                      │
│  │ - v_test_domain_stats (도메인별 통계)             │                      │
│  └──────────────────────────────────────────────────┘                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Phase 1: 테이블 스키마

### 1-1. `ai_test_runs` 테이블 (신규)

```sql
-- ============================================
-- ai_test_runs: 테스트 실행 배치 관리
-- ============================================

CREATE TABLE IF NOT EXISTS ai_test_runs (
  run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_name TEXT NOT NULL,                    -- "v11 배포 후 전체 테스트"
  description TEXT,                          -- 테스트 목적/설명

  -- 설정
  config JSONB DEFAULT '{}',                 -- {company_id, user_id, ...}
  ontology_version TEXT,                     -- "2024-12-14"
  edge_function_version TEXT,                -- "v11"

  -- 필터
  filter_domains TEXT[],                     -- ['HR', '회계'] - NULL이면 전체
  filter_tags TEXT[],                        -- ['timezone', 'deprecated']
  filter_test_ids INTEGER[],                 -- 특정 test_id만

  -- 결과 집계
  total_cases INTEGER DEFAULT 0,
  passed_count INTEGER DEFAULT 0,
  failed_count INTEGER DEFAULT 0,
  error_count INTEGER DEFAULT 0,

  -- 품질 점수
  avg_score NUMERIC(5,2),
  quality_summary JSONB,                     -- {tz_hardcode: 5, deprecated: 3, ...}

  -- 상태
  status TEXT DEFAULT 'pending',             -- pending, running, completed, failed
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  execution_time_ms INTEGER,

  -- 메타
  created_at TIMESTAMPTZ DEFAULT NOW(),
  created_by TEXT                            -- "claude-audit", "manual"
);

-- 인덱스
CREATE INDEX idx_test_runs_status ON ai_test_runs(status);
CREATE INDEX idx_test_runs_created ON ai_test_runs(created_at DESC);

COMMENT ON TABLE ai_test_runs IS '테스트 실행 배치 관리. 여러 테스트 케이스를 그룹으로 실행하고 결과를 집계';
```

### 1-2. `ontology_test_cases` 확장 (기존 테이블 수정)

```sql
-- ============================================
-- ontology_test_cases 확장
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

-- 코멘트
COMMENT ON COLUMN ontology_test_cases.quality_rules IS '품질 검증 규칙. 예: {"must_use_dynamic_tz": true, "forbidden_columns": ["is_late_v2"]}';
COMMENT ON COLUMN ontology_test_cases.priority IS '실행 우선순위 (높을수록 먼저). 기본 50';
```

### 1-3. `ontology_test_results` 확장 (기존 테이블 수정)

```sql
-- ============================================
-- ontology_test_results 확장
-- ============================================

-- ai_sql_logs 연결
ALTER TABLE ontology_test_results
ADD COLUMN IF NOT EXISTS sql_log_id UUID REFERENCES ai_sql_logs(log_id);

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

-- 코멘트
COMMENT ON COLUMN ontology_test_results.quality_checks IS '품질 체크 결과. 예: {"tz_hardcode": false, "deprecated_cols": [], "score": 95}';
```

---

## 📋 Phase 2: ai-test-runner Edge Function

### 2-1. 전체 코드

```typescript
// supabase/functions/ai-test-runner/index.ts

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// =============================================================================
// AI Test Runner v1.0
// =============================================================================
// 목적: ontology_test_cases의 테스트 케이스를 자동으로 실행하고 품질 분석
//
// 사용법:
// POST /ai-test-runner
// {
//   "run_name": "v11 전체 테스트",
//   "company_id": "ebd66ba7-fde7-4332-b6b5-0d8a7f615497",
//   "user_id": "0d2e61ad-e230-454e-8b90-efbe1c1a268",
//   "filter": {
//     "domains": ["HR", "회계"],    // optional
//     "tags": ["timezone"],         // optional
//     "test_ids": [1, 2, 3]         // optional
//   },
//   "options": {
//     "parallel": false,            // 병렬 실행 여부
//     "delay_ms": 1000,             // 요청 간 딜레이
//     "stop_on_error": false        // 에러 시 중단 여부
//   }
// }
// =============================================================================

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Content-Type': 'application/json'
};

// =============================================================================
// 품질 체크 함수들
// =============================================================================

interface QualityCheckResult {
  score: number;                    // 0-100
  passed: boolean;
  checks: {
    tz_hardcode: boolean;           // Asia/Ho_Chi_Minh 하드코딩
    tz_dynamic: boolean;            // SELECT timezone FROM companies 사용
    deprecated_cols: string[];      // 사용된 deprecated 컬럼들
    year_hardcode: boolean;         // 2024-12 등 연도 하드코딩
    extract_cast: boolean;          // EXTRACT 후 ::integer 캐스팅 누락
    cross_join: boolean;            // CROSS JOIN 사용
    missing_company_filter: boolean; // company_id 필터 누락
    sql_valid: boolean;             // SQL 실행 성공
  };
  issues: string[];                 // 발견된 이슈 목록
}

// Deprecated 컬럼 목록 (ontology에서 로드해야 하지만, 일단 하드코딩)
const DEPRECATED_COLUMNS = [
  'is_late_v2', 'is_extratime_v2', 'late_minutes_v2', 'overtime_minutes_v2',
  'is_problem_v2', 'problem_type_v2', 'has_unsolved_problem_v2',
  'late_deduct_minute_v2', 'overtime_plus_minute_v2',
  'late_deducut_amount_v2', 'overtime_amount_v2',
  'request_date', 'request_time', 'start_time', 'end_time',
  'actual_start_time', 'actual_end_time', 'is_late', 'is_extratime',
  'entry_date', 'journal_type'
];

function checkSQLQuality(sql: string, sqlSuccess: boolean): QualityCheckResult {
  const issues: string[] = [];
  const upperSQL = sql.toUpperCase();
  const checks = {
    tz_hardcode: false,
    tz_dynamic: false,
    deprecated_cols: [] as string[],
    year_hardcode: false,
    extract_cast: false,
    cross_join: false,
    missing_company_filter: false,
    sql_valid: sqlSuccess
  };

  // 1. TZ 하드코딩 체크
  if (sql.includes("'Asia/Ho_Chi_Minh'") || sql.includes("'Asia/Bangkok'") || sql.includes("'UTC'")) {
    checks.tz_hardcode = true;
    issues.push('❌ TIMEZONE 하드코딩 발견 (동적 조회 필요)');
  }

  // 2. TZ 동적 조회 체크
  if (sql.toLowerCase().includes('select timezone from companies')) {
    checks.tz_dynamic = true;
  } else if (sql.includes('AT TIME ZONE') && !checks.tz_hardcode) {
    // AT TIME ZONE 사용하지만 동적 조회 안 함
    issues.push('⚠️ AT TIME ZONE 사용하지만 동적 조회 없음');
  }

  // 3. Deprecated 컬럼 체크
  for (const col of DEPRECATED_COLUMNS) {
    // 단어 경계로 체크 (컬럼명만 매칭)
    const regex = new RegExp(`\\b${col}\\b`, 'i');
    if (regex.test(sql)) {
      checks.deprecated_cols.push(col);
    }
  }
  if (checks.deprecated_cols.length > 0) {
    issues.push(`❌ DEPRECATED 컬럼 사용: ${checks.deprecated_cols.join(', ')}`);
  }

  // 4. 연도 하드코딩 체크
  if (/202[0-4]-\d{2}/.test(sql)) {
    checks.year_hardcode = true;
    issues.push('❌ 과거 연도 하드코딩 (2024 이전)');
  }

  // 5. EXTRACT 캐스팅 체크
  if (sql.includes('EXTRACT') && sql.includes('MAKE_DATE')) {
    if (!sql.includes('::integer') && !sql.includes(':: integer')) {
      checks.extract_cast = true;
      issues.push('❌ EXTRACT 결과 ::integer 캐스팅 누락');
    }
  }

  // 6. CROSS JOIN 체크
  if (upperSQL.includes('CROSS JOIN')) {
    checks.cross_join = true;
    issues.push('❌ CROSS JOIN 사용 금지');
  }

  // 7. company_id 필터 체크
  if (!sql.toLowerCase().includes('company_id')) {
    checks.missing_company_filter = true;
    issues.push('⚠️ company_id 필터 누락');
  }

  // 8. SQL 실행 실패
  if (!sqlSuccess) {
    issues.push('❌ SQL 실행 실패');
  }

  // 점수 계산 (100점 만점)
  let score = 100;
  if (checks.tz_hardcode) score -= 30;
  if (!checks.tz_dynamic && sql.includes('AT TIME ZONE')) score -= 10;
  if (checks.deprecated_cols.length > 0) score -= 20;
  if (checks.year_hardcode) score -= 20;
  if (checks.extract_cast) score -= 10;
  if (checks.cross_join) score -= 20;
  if (checks.missing_company_filter) score -= 5;
  if (!sqlSuccess) score -= 30;

  score = Math.max(0, score);

  return {
    score,
    passed: score >= 70 && sqlSuccess,
    checks,
    issues
  };
}

// =============================================================================
// 메인 핸들러
// =============================================================================

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: CORS_HEADERS });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  const startTime = Date.now();

  try {
    // =========================================================================
    // 1. 요청 파싱
    // =========================================================================
    const body = await req.json();
    const {
      run_name,
      description,
      company_id,
      user_id,
      filter = {},
      options = {}
    } = body;

    if (!company_id || !user_id) {
      throw new Error('company_id and user_id are required');
    }

    const runName = run_name || `Test Run ${new Date().toISOString()}`;
    const delayMs = options.delay_ms || 500;
    const stopOnError = options.stop_on_error || false;

    console.log(`[ai-test-runner] Starting: ${runName}`);

    // =========================================================================
    // 2. 테스트 런 생성
    // =========================================================================
    const { data: runData, error: runError } = await supabase
      .from('ai_test_runs')
      .insert({
        run_name: runName,
        description,
        config: { company_id, user_id },
        filter_domains: filter.domains || null,
        filter_tags: filter.tags || null,
        filter_test_ids: filter.test_ids || null,
        status: 'running',
        started_at: new Date().toISOString(),
        created_by: 'ai-test-runner'
      })
      .select('run_id')
      .single();

    if (runError) throw new Error(`Failed to create test run: ${runError.message}`);

    const runId = runData.run_id;
    console.log(`[ai-test-runner] Run ID: ${runId}`);

    // =========================================================================
    // 3. 테스트 케이스 로드
    // =========================================================================
    let query = supabase
      .from('ontology_test_cases')
      .select('*')
      .eq('is_active', true)
      .order('priority', { ascending: false })
      .order('test_id', { ascending: true });

    // 필터 적용
    if (filter.domains && filter.domains.length > 0) {
      query = query.in('domain', filter.domains);
    }
    if (filter.tags && filter.tags.length > 0) {
      query = query.overlaps('tags', filter.tags);
    }
    if (filter.test_ids && filter.test_ids.length > 0) {
      query = query.in('test_id', filter.test_ids);
    }

    const { data: testCases, error: casesError } = await query;

    if (casesError) throw new Error(`Failed to load test cases: ${casesError.message}`);
    if (!testCases || testCases.length === 0) {
      throw new Error('No test cases found');
    }

    console.log(`[ai-test-runner] Loaded ${testCases.length} test cases`);

    // =========================================================================
    // 4. Deprecated 컬럼 목록 동적 로드
    // =========================================================================
    const { data: deprecatedCols } = await supabase.rpc('execute_sql', {
      query_text: `
        SELECT column_name
        FROM ontology_columns
        WHERE is_deprecated = true
      `
    });

    const dynamicDeprecatedCols = deprecatedCols?.map((r: any) => r.column_name) || DEPRECATED_COLUMNS;

    // =========================================================================
    // 5. 각 테스트 케이스 실행
    // =========================================================================
    const results: any[] = [];
    let passedCount = 0;
    let failedCount = 0;
    let errorCount = 0;
    const qualitySummary: Record<string, number> = {
      tz_hardcode: 0,
      deprecated_cols: 0,
      year_hardcode: 0,
      extract_cast: 0,
      sql_error: 0
    };

    const aiRespondUrl = `${Deno.env.get('SUPABASE_URL')}/functions/v1/ai-respond-user`;

    for (const testCase of testCases) {
      const testStartTime = Date.now();
      const sessionId = `test-${runId.slice(0, 8)}-${testCase.test_id}`;

      console.log(`[ai-test-runner] Testing #${testCase.test_id}: ${testCase.question_ko.substring(0, 30)}...`);

      try {
        // ai-respond-user 호출
        const response = await fetch(aiRespondUrl, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${Deno.env.get('SUPABASE_ANON_KEY')}`
          },
          body: JSON.stringify({
            question: testCase.question_ko,
            company_id,
            user_id,
            session_id: sessionId
          })
        });

        // SSE 응답 처리 (결과만 추출)
        const text = await response.text();

        // ai_sql_logs에서 결과 조회 (session_id로)
        await new Promise(resolve => setTimeout(resolve, 500)); // 로그 저장 대기

        const { data: logData } = await supabase
          .from('ai_sql_logs')
          .select('*')
          .eq('session_id', sessionId)
          .order('created_at', { ascending: false })
          .limit(1)
          .single();

        const generatedSql = logData?.generated_sql || '';
        const sqlSuccess = logData?.success || false;
        const rowCount = logData?.row_count || 0;
        const errorMessage = logData?.error_message || null;

        // 품질 체크
        const qualityResult = checkSQLQuality(generatedSql, sqlSuccess);

        // 품질 이슈 집계
        if (qualityResult.checks.tz_hardcode) qualitySummary.tz_hardcode++;
        if (qualityResult.checks.deprecated_cols.length > 0) qualitySummary.deprecated_cols++;
        if (qualityResult.checks.year_hardcode) qualitySummary.year_hardcode++;
        if (qualityResult.checks.extract_cast) qualitySummary.extract_cast++;
        if (!sqlSuccess) qualitySummary.sql_error++;

        // 결과 판정
        const isPassed = qualityResult.passed && sqlSuccess;
        if (isPassed) passedCount++;
        else if (!sqlSuccess) errorCount++;
        else failedCount++;

        // 결과 저장
        const testResult = {
          test_id: testCase.test_id,
          run_id: runId,
          sql_log_id: logData?.log_id || null,
          ai_sql: generatedSql,
          ai_result: logData?.result_sample || null,
          ai_execution_time_ms: Date.now() - testStartTime,
          is_pass: isPassed,
          score: qualityResult.score,
          failure_reason: qualityResult.issues.length > 0 ? qualityResult.issues.join('\n') : null,
          quality_checks: qualityResult.checks,
          tested_at: new Date().toISOString(),
          tested_by: 'ai-test-runner',
          version: 1
        };

        const { error: insertError } = await supabase
          .from('ontology_test_results')
          .insert(testResult);

        if (insertError) {
          console.error(`[ai-test-runner] Failed to save result: ${insertError.message}`);
        }

        results.push(testResult);

        // 에러 시 중단 옵션
        if (stopOnError && !isPassed) {
          console.log(`[ai-test-runner] Stopping due to error (stop_on_error=true)`);
          break;
        }

      } catch (testError: any) {
        console.error(`[ai-test-runner] Test #${testCase.test_id} error: ${testError.message}`);
        errorCount++;

        results.push({
          test_id: testCase.test_id,
          run_id: runId,
          is_pass: false,
          score: 0,
          failure_reason: `Exception: ${testError.message}`,
          tested_at: new Date().toISOString()
        });

        if (stopOnError) break;
      }

      // 딜레이
      if (delayMs > 0) {
        await new Promise(resolve => setTimeout(resolve, delayMs));
      }
    }

    // =========================================================================
    // 6. 테스트 런 완료 업데이트
    // =========================================================================
    const totalTime = Date.now() - startTime;
    const avgScore = results.length > 0
      ? results.reduce((sum, r) => sum + (r.score || 0), 0) / results.length
      : 0;

    await supabase
      .from('ai_test_runs')
      .update({
        status: 'completed',
        total_cases: testCases.length,
        passed_count: passedCount,
        failed_count: failedCount,
        error_count: errorCount,
        avg_score: Math.round(avgScore * 100) / 100,
        quality_summary: qualitySummary,
        completed_at: new Date().toISOString(),
        execution_time_ms: totalTime
      })
      .eq('run_id', runId);

    console.log(`[ai-test-runner] Completed: ${passedCount}/${testCases.length} passed (${Math.round(avgScore)}%)`);

    // =========================================================================
    // 7. 응답 반환
    // =========================================================================
    return new Response(JSON.stringify({
      success: true,
      run_id: runId,
      summary: {
        total: testCases.length,
        passed: passedCount,
        failed: failedCount,
        errors: errorCount,
        pass_rate: Math.round((passedCount / testCases.length) * 100),
        avg_score: Math.round(avgScore),
        execution_time_ms: totalTime
      },
      quality_summary: qualitySummary,
      results: results.map(r => ({
        test_id: r.test_id,
        is_pass: r.is_pass,
        score: r.score,
        issues: r.failure_reason
      }))
    }), { headers: CORS_HEADERS });

  } catch (error: any) {
    console.error(`[ai-test-runner] Fatal error: ${error.message}`);

    return new Response(JSON.stringify({
      success: false,
      error: error.message
    }), {
      status: 500,
      headers: CORS_HEADERS
    });
  }
});
```

---

## 📋 Phase 3: 분석 View

### 3-1. `v_test_run_summary` (테스트 런 요약)

```sql
-- ============================================
-- v_test_run_summary: 테스트 런 요약
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
  quality_summary->>'tz_hardcode' AS tz_hardcode_count,
  quality_summary->>'deprecated_cols' AS deprecated_cols_count,
  quality_summary->>'year_hardcode' AS year_hardcode_count,
  quality_summary->>'sql_error' AS sql_error_count,

  -- 시간
  started_at,
  completed_at,
  execution_time_ms,
  CASE WHEN execution_time_ms IS NOT NULL
    THEN ROUND(execution_time_ms / 1000.0, 1) || 's'
    ELSE NULL
  END AS duration,

  created_by

FROM ai_test_runs
ORDER BY created_at DESC;

COMMENT ON VIEW v_test_run_summary IS '테스트 런 요약 뷰. 각 배치 테스트의 결과와 품질 점수 확인';
```

### 3-2. `v_test_quality_report` (품질 리포트)

```sql
-- ============================================
-- v_test_quality_report: 품질 이슈 상세 리포트
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
  r.quality_checks->>'tz_hardcode' AS has_tz_hardcode,
  r.quality_checks->>'tz_dynamic' AS has_tz_dynamic,
  r.quality_checks->'deprecated_cols' AS deprecated_cols_used,
  r.quality_checks->>'year_hardcode' AS has_year_hardcode,
  r.quality_checks->>'extract_cast' AS has_extract_cast_issue,
  r.quality_checks->>'sql_valid' AS sql_valid,

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
```

### 3-3. `v_test_domain_stats` (도메인별 통계)

```sql
-- ============================================
-- v_test_domain_stats: 도메인별 통계
-- ============================================

CREATE OR REPLACE VIEW v_test_domain_stats AS
SELECT
  tr.run_id,
  tr.run_name,
  tc.domain,

  COUNT(*) AS total_cases,
  SUM(CASE WHEN r.is_pass THEN 1 ELSE 0 END) AS passed,
  SUM(CASE WHEN NOT r.is_pass AND r.quality_checks->>'sql_valid' = 'true' THEN 1 ELSE 0 END) AS failed_quality,
  SUM(CASE WHEN r.quality_checks->>'sql_valid' = 'false' THEN 1 ELSE 0 END) AS sql_errors,

  ROUND(AVG(r.score), 1) AS avg_score,
  ROUND(AVG(r.ai_execution_time_ms)) AS avg_time_ms,

  -- 주요 이슈 카운트
  SUM(CASE WHEN r.quality_checks->>'tz_hardcode' = 'true' THEN 1 ELSE 0 END) AS tz_hardcode_issues,
  SUM(CASE WHEN jsonb_array_length(COALESCE(r.quality_checks->'deprecated_cols', '[]'::jsonb)) > 0 THEN 1 ELSE 0 END) AS deprecated_col_issues

FROM ontology_test_results r
JOIN ai_test_runs tr ON tr.run_id = r.run_id
JOIN ontology_test_cases tc ON tc.test_id = r.test_id
GROUP BY tr.run_id, tr.run_name, tc.domain
ORDER BY tr.created_at DESC, tc.domain;

COMMENT ON VIEW v_test_domain_stats IS '도메인별 테스트 통계. HR, 회계, 현금 등 영역별 품질 확인';
```

### 3-4. `v_test_failed_cases` (실패 케이스 목록)

```sql
-- ============================================
-- v_test_failed_cases: 실패한 테스트 케이스
-- ============================================

CREATE OR REPLACE VIEW v_test_failed_cases AS
SELECT
  tr.run_name,
  tc.test_id,
  tc.domain,
  tc.question_ko,
  tc.tags,

  r.score,
  r.failure_reason,

  -- 이슈 플래그
  CASE WHEN r.quality_checks->>'tz_hardcode' = 'true' THEN '🔴 TZ' ELSE '' END ||
  CASE WHEN jsonb_array_length(COALESCE(r.quality_checks->'deprecated_cols', '[]'::jsonb)) > 0 THEN '🔴 DEP' ELSE '' END ||
  CASE WHEN r.quality_checks->>'year_hardcode' = 'true' THEN '🟡 YEAR' ELSE '' END ||
  CASE WHEN r.quality_checks->>'sql_valid' = 'false' THEN '❌ SQL' ELSE '' END
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
```

### 3-5. `v_test_improvement_trend` (개선 추이)

```sql
-- ============================================
-- v_test_improvement_trend: 버전별 개선 추이
-- ============================================

CREATE OR REPLACE VIEW v_test_improvement_trend AS
SELECT
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
```

---

## 📋 Phase 4: 유용한 쿼리

### 4-1. 최신 테스트 런 결과 확인

```sql
-- 최신 테스트 런 요약
SELECT * FROM v_test_run_summary LIMIT 5;

-- 최신 런의 도메인별 통계
SELECT * FROM v_test_domain_stats
WHERE run_id = (SELECT run_id FROM ai_test_runs ORDER BY created_at DESC LIMIT 1);
```

### 4-2. 실패 케이스 분석

```sql
-- 실패 케이스 (최신 런)
SELECT * FROM v_test_failed_cases
WHERE run_name = (SELECT run_name FROM ai_test_runs ORDER BY created_at DESC LIMIT 1);

-- TZ 하드코딩 문제만
SELECT * FROM v_test_quality_report
WHERE has_tz_hardcode = 'true'
ORDER BY tested_at DESC;

-- Deprecated 컬럼 사용 문제만
SELECT test_id, domain, question_ko, deprecated_cols_used, ai_sql
FROM v_test_quality_report
WHERE jsonb_array_length(COALESCE(deprecated_cols_used, '[]'::jsonb)) > 0
ORDER BY tested_at DESC;
```

### 4-3. 개선 효과 비교

```sql
-- v10 vs v11 비교
SELECT
  edge_function_version,
  COUNT(*) AS test_count,
  ROUND(AVG(avg_score), 1) AS avg_score,
  ROUND(AVG(pass_rate), 1) AS avg_pass_rate,
  SUM(tz_issues) AS total_tz_issues,
  SUM(deprecated_issues) AS total_deprecated_issues
FROM v_test_improvement_trend
GROUP BY edge_function_version
ORDER BY edge_function_version DESC;
```

### 4-4. 특정 도메인 집중 분석

```sql
-- HR 도메인 상세
SELECT
  tc.test_id,
  tc.question_ko,
  r.score,
  r.is_pass,
  r.failure_reason
FROM ontology_test_results r
JOIN ontology_test_cases tc ON tc.test_id = r.test_id
WHERE tc.domain = 'HR'
  AND r.run_id = (SELECT run_id FROM ai_test_runs ORDER BY created_at DESC LIMIT 1)
ORDER BY r.score ASC;
```

---

## 📋 Phase 5: 사용 가이드

### 5-1. 테스트 실행 방법

```bash
# 전체 테스트 실행
curl -X POST 'https://[PROJECT_REF].supabase.co/functions/v1/ai-test-runner' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer [ANON_KEY]' \
  -d '{
    "run_name": "v11 전체 테스트",
    "company_id": "ebd66ba7-fde7-4332-b6b5-0d8a7f615497",
    "user_id": "0d2e61ad-e230-454e-8b90-efbe1c1a268"
  }'

# 특정 도메인만 테스트
curl -X POST '...' \
  -d '{
    "run_name": "HR 도메인 테스트",
    "company_id": "...",
    "user_id": "...",
    "filter": {
      "domains": ["HR"]
    }
  }'

# 특정 태그만 테스트
curl -X POST '...' \
  -d '{
    "run_name": "Timezone 관련 테스트",
    "company_id": "...",
    "user_id": "...",
    "filter": {
      "tags": ["timezone", "date"]
    }
  }'

# 특정 테스트 케이스만
curl -X POST '...' \
  -d '{
    "run_name": "회귀 테스트 #20-25",
    "company_id": "...",
    "user_id": "...",
    "filter": {
      "test_ids": [20, 21, 22, 23, 24, 25]
    }
  }'
```

### 5-2. 테스트 케이스 추가 방법

```sql
-- 새 테스트 케이스 추가
INSERT INTO ontology_test_cases (
  domain,
  question_ko,
  question_en,
  expected_sql,
  expected_result_check,
  difficulty,
  tags,
  quality_rules,
  priority,
  is_active
) VALUES (
  'HR',
  '오늘 지각한 직원 목록',
  'List of employees who were late today',
  $$
  SELECT u.user_name,
         (sr.problem_details_v2->'problems'->0->>'actual_minutes')::int AS late_minutes
  FROM v_shift_request sr
  JOIN users u ON u.user_id = sr.user_id
  WHERE sr.company_id = $company_id
    AND sr.problem_details_v2->>'has_late' = 'true'
    AND (sr.start_time_utc AT TIME ZONE (SELECT timezone FROM companies WHERE company_id = $company_id))::date =
        (NOW() AT TIME ZONE (SELECT timezone FROM companies WHERE company_id = $company_id))::date
  $$,
  'row_count >= 0',
  'medium',
  ARRAY['HR', 'attendance', 'late', 'today'],
  '{"must_use_dynamic_tz": true, "must_use_problem_details_v2": true, "forbidden_columns": ["is_late_v2", "late_minutes_v2"]}',
  80,
  true
);
```

### 5-3. 품질 규칙 정의

```json
// quality_rules 예시
{
  "must_use_dynamic_tz": true,           // 동적 TZ 필수
  "must_use_problem_details_v2": true,   // problem_details_v2 사용 필수
  "forbidden_columns": [                  // 사용 금지 컬럼
    "is_late_v2",
    "is_extratime_v2",
    "request_date"
  ],
  "required_filters": [                   // 필수 필터
    "company_id",
    "is_approved"
  ],
  "max_execution_time_ms": 5000          // 최대 실행 시간
}
```

---

## 📋 Phase 6: 체크리스트

### 배포 전 체크리스트

- [ ] `ai_test_runs` 테이블 생성
- [ ] `ontology_test_cases` 확장 컬럼 추가
- [ ] `ontology_test_results` 확장 컬럼 추가
- [ ] 분석 View 5개 생성
- [ ] `ai-test-runner` Edge Function 배포
- [ ] 테스트 케이스 100개 추가

### 테스트 케이스 도메인 목표

| 도메인 | 목표 케이스 수 | 포함 내용 |
|--------|--------------|----------|
| HR | 30개 | 출퇴근, 지각, 초과근무, 급여 |
| 회계 | 25개 | 매출, 비용, 손익, 계정 |
| 현금 | 15개 | 금고, 입출금, 잔액 |
| 재고 | 15개 | 재고현황, 입출고 |
| 기타 | 15개 | 네비게이션, 일반 질문 |

---

## 📋 응답 예시

### 성공 응답

```json
{
  "success": true,
  "run_id": "a1b2c3d4-...",
  "summary": {
    "total": 100,
    "passed": 85,
    "failed": 10,
    "errors": 5,
    "pass_rate": 85,
    "avg_score": 82,
    "execution_time_ms": 120000
  },
  "quality_summary": {
    "tz_hardcode": 3,
    "deprecated_cols": 5,
    "year_hardcode": 2,
    "sql_error": 5
  },
  "results": [
    {"test_id": 1, "is_pass": true, "score": 100, "issues": null},
    {"test_id": 2, "is_pass": false, "score": 50, "issues": "❌ TZ 하드코딩"}
  ]
}
```

---

## 📞 문의

- 테스트 케이스 추가 요청
- 품질 규칙 수정 요청
- Edge Function 버그 리포트

→ 담당자에게 연락
