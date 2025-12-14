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
//     "domains": ["HR", "회계"],
//     "tags": ["timezone"],
//     "test_ids": [1, 2, 3]
//   },
//   "options": {
//     "delay_ms": 1000,
//     "stop_on_error": false
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
  score: number;
  passed: boolean;
  checks: {
    tz_hardcode: boolean;
    tz_dynamic: boolean;
    deprecated_cols: string[];
    year_hardcode: boolean;
    extract_cast: boolean;
    cross_join: boolean;
    missing_company_filter: boolean;
    sql_valid: boolean;
  };
  issues: string[];
}

// 기본 Deprecated 컬럼 목록 (동적으로 로드됨)
const DEFAULT_DEPRECATED_COLUMNS = [
  'is_late_v2', 'is_extratime_v2', 'late_minutes_v2', 'overtime_minutes_v2',
  'is_problem_v2', 'problem_type_v2', 'has_unsolved_problem_v2',
  'late_deduct_minute_v2', 'overtime_plus_minute_v2',
  'late_deducut_amount_v2', 'overtime_amount_v2',
  'request_date', 'request_time', 'start_time', 'end_time',
  'actual_start_time', 'actual_end_time', 'is_late', 'is_extratime',
  'entry_date', 'journal_type'
];

function checkSQLQuality(
  sql: string,
  sqlSuccess: boolean,
  deprecatedColumns: string[] = DEFAULT_DEPRECATED_COLUMNS
): QualityCheckResult {
  const issues: string[] = [];
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

  if (!sql) {
    return {
      score: 0,
      passed: false,
      checks: { ...checks, sql_valid: false },
      issues: ['❌ SQL이 생성되지 않음']
    };
  }

  const upperSQL = sql.toUpperCase();

  // 1. TZ 하드코딩 체크
  const tzHardcodePatterns = [
    "'Asia/Ho_Chi_Minh'",
    "'Asia/Bangkok'",
    "'Asia/Seoul'",
    "'America/New_York'",
    "'Europe/London'"
  ];
  for (const pattern of tzHardcodePatterns) {
    if (sql.includes(pattern)) {
      checks.tz_hardcode = true;
      issues.push(`❌ TIMEZONE 하드코딩: ${pattern}`);
      break;
    }
  }

  // 2. TZ 동적 조회 체크
  if (sql.toLowerCase().includes('select timezone from companies')) {
    checks.tz_dynamic = true;
  } else if (sql.includes('AT TIME ZONE') && !checks.tz_hardcode) {
    issues.push('⚠️ AT TIME ZONE 사용하지만 동적 조회 없음');
  }

  // 3. Deprecated 컬럼 체크
  for (const col of deprecatedColumns) {
    const regex = new RegExp(`\\b${col}\\b`, 'i');
    if (regex.test(sql)) {
      checks.deprecated_cols.push(col);
    }
  }
  if (checks.deprecated_cols.length > 0) {
    issues.push(`❌ DEPRECATED 컬럼 사용: ${checks.deprecated_cols.join(', ')}`);
  }

  // 4. 연도 하드코딩 체크 (2020-2024)
  if (/['"]?202[0-4]-\d{2}/.test(sql)) {
    checks.year_hardcode = true;
    issues.push('❌ 과거 연도 하드코딩 발견');
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
  if (checks.deprecated_cols.length > 0) score -= Math.min(30, checks.deprecated_cols.length * 10);
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
  let runId: string | null = null;

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
      ontology_version,
      edge_function_version,
      filter = {},
      options = {}
    } = body;

    if (!company_id || !user_id) {
      throw new Error('company_id and user_id are required');
    }

    const runName = run_name || `Test Run ${new Date().toISOString().slice(0, 16)}`;
    const delayMs = options.delay_ms ?? 500;
    const stopOnError = options.stop_on_error ?? false;

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
        ontology_version: ontology_version || null,
        edge_function_version: edge_function_version || 'v11',
        filter_domains: filter.domains || null,
        filter_tags: filter.tags || null,
        filter_test_ids: filter.test_ids || null,
        status: 'running',
        started_at: new Date().toISOString(),
        created_by: 'ai-test-runner'
      })
      .select('run_id')
      .single();

    if (runError) {
      throw new Error(`Failed to create test run: ${runError.message}`);
    }

    runId = runData.run_id;
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

    if (casesError) {
      throw new Error(`Failed to load test cases: ${casesError.message}`);
    }
    if (!testCases || testCases.length === 0) {
      throw new Error('No test cases found matching the filter criteria');
    }

    console.log(`[ai-test-runner] Loaded ${testCases.length} test cases`);

    // =========================================================================
    // 4. Deprecated 컬럼 목록 동적 로드
    // =========================================================================
    const { data: deprecatedColsData } = await supabase.rpc('execute_sql', {
      query_text: `
        SELECT column_name
        FROM ontology_columns
        WHERE is_deprecated = true
      `
    });

    const deprecatedColumns = deprecatedColsData?.map((r: any) => r.column_name) || DEFAULT_DEPRECATED_COLUMNS;
    console.log(`[ai-test-runner] Loaded ${deprecatedColumns.length} deprecated columns`);

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
    const anonKey = Deno.env.get('SUPABASE_ANON_KEY');

    for (let i = 0; i < testCases.length; i++) {
      const testCase = testCases[i];
      const testStartTime = Date.now();
      const sessionId = `test-${runId!.slice(0, 8)}-${testCase.test_id}-${Date.now()}`;

      console.log(`[ai-test-runner] [${i + 1}/${testCases.length}] Testing #${testCase.test_id}: ${testCase.question_ko.substring(0, 40)}...`);

      try {
        // ai-respond-user 호출
        const response = await fetch(aiRespondUrl, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${anonKey}`
          },
          body: JSON.stringify({
            question: testCase.question_ko,
            company_id,
            user_id,
            session_id: sessionId
          })
        });

        // SSE 응답 읽기 (완료 대기)
        await response.text();

        // 잠시 대기 (로그 저장 시간)
        await new Promise(resolve => setTimeout(resolve, 300));

        // ai_sql_logs에서 결과 조회
        const { data: logData } = await supabase
          .from('ai_sql_logs')
          .select('*')
          .eq('session_id', sessionId)
          .order('created_at', { ascending: false })
          .limit(1)
          .single();

        const generatedSql = logData?.generated_sql || '';
        const sqlSuccess = logData?.success ?? false;
        const errorMessage = logData?.error_message || null;

        // 품질 체크
        const qualityResult = checkSQLQuality(generatedSql, sqlSuccess, deprecatedColumns);

        // 품질 이슈 집계
        if (qualityResult.checks.tz_hardcode) qualitySummary.tz_hardcode++;
        if (qualityResult.checks.deprecated_cols.length > 0) qualitySummary.deprecated_cols++;
        if (qualityResult.checks.year_hardcode) qualitySummary.year_hardcode++;
        if (qualityResult.checks.extract_cast) qualitySummary.extract_cast++;
        if (!sqlSuccess) qualitySummary.sql_error++;

        // 결과 판정
        const isPassed = qualityResult.passed;
        if (isPassed) passedCount++;
        else if (!sqlSuccess) errorCount++;
        else failedCount++;

        // 결과 저장
        const testResult = {
          test_id: testCase.test_id,
          run_id: runId,
          sql_log_id: logData?.log_id || null,
          ai_sql: generatedSql || null,
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

        await supabase.from('ontology_test_results').insert(testResult);

        // ontology_test_cases 업데이트 (마지막 테스트 결과)
        await supabase
          .from('ontology_test_cases')
          .update({
            last_test_result: {
              is_pass: isPassed,
              score: qualityResult.score,
              issues: qualityResult.issues
            },
            last_tested_at: new Date().toISOString()
          })
          .eq('test_id', testCase.test_id);

        results.push({
          test_id: testCase.test_id,
          is_pass: isPassed,
          score: qualityResult.score,
          issues: qualityResult.issues.length > 0 ? qualityResult.issues : null
        });

        // 진행상황 로그
        const passRate = Math.round((passedCount / (i + 1)) * 100);
        console.log(`[ai-test-runner] #${testCase.test_id}: ${isPassed ? '✅ PASS' : '❌ FAIL'} (score: ${qualityResult.score}, rate: ${passRate}%)`);

        if (stopOnError && !isPassed) {
          console.log(`[ai-test-runner] Stopping due to failure (stop_on_error=true)`);
          break;
        }

      } catch (testError: any) {
        console.error(`[ai-test-runner] Test #${testCase.test_id} exception: ${testError.message}`);
        errorCount++;

        const failResult = {
          test_id: testCase.test_id,
          run_id: runId,
          is_pass: false,
          score: 0,
          failure_reason: `Exception: ${testError.message}`,
          quality_checks: { sql_valid: false },
          tested_at: new Date().toISOString(),
          tested_by: 'ai-test-runner',
          version: 1
        };

        await supabase.from('ontology_test_results').insert(failResult);

        results.push({
          test_id: testCase.test_id,
          is_pass: false,
          score: 0,
          issues: [`Exception: ${testError.message}`]
        });

        if (stopOnError) break;
      }

      // 요청 간 딜레이 (rate limiting 방지)
      if (delayMs > 0 && i < testCases.length - 1) {
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

    const passRate = Math.round((passedCount / testCases.length) * 100);
    console.log(`[ai-test-runner] ✅ Completed: ${passedCount}/${testCases.length} passed (${passRate}%, avg score: ${Math.round(avgScore)})`);

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
        pass_rate: passRate,
        avg_score: Math.round(avgScore),
        execution_time_ms: totalTime
      },
      quality_summary: qualitySummary,
      results
    }), { headers: CORS_HEADERS });

  } catch (error: any) {
    console.error(`[ai-test-runner] Fatal error: ${error.message}`);

    // 런 상태 업데이트 (실패)
    if (runId) {
      await supabase
        .from('ai_test_runs')
        .update({
          status: 'failed',
          completed_at: new Date().toISOString(),
          execution_time_ms: Date.now() - startTime
        })
        .eq('run_id', runId);
    }

    return new Response(JSON.stringify({
      success: false,
      error: error.message,
      run_id: runId
    }), {
      status: 500,
      headers: CORS_HEADERS
    });
  }
});
