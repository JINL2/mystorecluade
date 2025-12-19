-- ============================================================
-- get_monthly_problem_status_v1
-- 월간 캘린더에서 날짜별 문제 상태를 반환
--
-- 반환 색상:
-- - 'orange': 미해결 리포트 있음 (is_reported_v2 = true AND is_reported_solved_v2 != true)
-- - 'red': 미해결 문제 있음 (is_problem_v2 = true AND is_problem_solved_v2 = false)
-- - 'green': 모든 문제 해결됨 (is_problem_v2 = true AND is_problem_solved_v2 = true)
-- - 'gray': 문제 없음
--
-- 우선순위: orange > red > green > gray
-- ============================================================

CREATE OR REPLACE FUNCTION get_monthly_problem_status_v1(
    p_store_id UUID,
    p_year INT,
    p_month INT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_start_date DATE;
    v_end_date DATE;
    v_result JSONB := '[]'::JSONB;
    v_day_data RECORD;
BEGIN
    -- 월의 시작과 끝 날짜 계산
    v_start_date := make_date(p_year, p_month, 1);
    v_end_date := (v_start_date + INTERVAL '1 month' - INTERVAL '1 day')::DATE;

    -- 날짜별로 문제 상태 집계
    FOR v_day_data IN
        SELECT
            shift_date,
            -- 미해결 리포트 개수 (orange)
            COUNT(*) FILTER (
                WHERE is_reported_v2 = TRUE
                AND (is_reported_solved_v2 IS NULL OR is_reported_solved_v2 = FALSE)
            ) AS unsolved_reports,
            -- 미해결 문제 개수 (red) - 리포트 제외
            COUNT(*) FILTER (
                WHERE is_problem_v2 = TRUE
                AND is_problem_solved_v2 = FALSE
                AND (is_reported_v2 IS NULL OR is_reported_v2 = FALSE)
            ) AS unsolved_problems,
            -- 해결된 문제 개수 (green)
            COUNT(*) FILTER (
                WHERE is_problem_v2 = TRUE
                AND is_problem_solved_v2 = TRUE
            ) AS solved_problems,
            -- 전체 shift 개수
            COUNT(*) AS total_shifts,
            -- 상세 정보 (문제 유형별)
            jsonb_agg(
                CASE
                    WHEN is_problem_v2 = TRUE OR is_reported_v2 = TRUE
                    THEN jsonb_build_object(
                        'request_id', request_id,
                        'employee_name', employee_name,
                        'is_reported', COALESCE(is_reported_v2, FALSE),
                        'is_reported_solved', COALESCE(is_reported_solved_v2, FALSE),
                        'is_problem', COALESCE(is_problem_v2, FALSE),
                        'is_problem_solved', COALESCE(is_problem_solved_v2, FALSE),
                        'problem_type', problem_type_v2,
                        'problem_details', problem_details_v2
                    )
                    ELSE NULL
                END
            ) FILTER (WHERE is_problem_v2 = TRUE OR is_reported_v2 = TRUE) AS problem_details
        FROM v_shift_request
        WHERE store_id = p_store_id
        AND shift_date >= v_start_date
        AND shift_date <= v_end_date
        AND is_approved = TRUE  -- 승인된 shift만
        GROUP BY shift_date
        ORDER BY shift_date
    LOOP
        v_result := v_result || jsonb_build_object(
            'date', v_day_data.shift_date,
            'status', CASE
                -- 우선순위: orange > red > green > gray
                WHEN v_day_data.unsolved_reports > 0 THEN 'orange'
                WHEN v_day_data.unsolved_problems > 0 THEN 'red'
                WHEN v_day_data.solved_problems > 0 THEN 'green'
                ELSE 'gray'
            END,
            'counts', jsonb_build_object(
                'unsolved_reports', v_day_data.unsolved_reports,
                'unsolved_problems', v_day_data.unsolved_problems,
                'solved_problems', v_day_data.solved_problems,
                'total_shifts', v_day_data.total_shifts
            ),
            'problems', COALESCE(v_day_data.problem_details, '[]'::JSONB)
        );
    END LOOP;

    RETURN jsonb_build_object(
        'success', TRUE,
        'year', p_year,
        'month', p_month,
        'store_id', p_store_id,
        'days', v_result
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'success', FALSE,
        'error', SQLERRM
    );
END;
$$;

-- 함수 코멘트 추가
COMMENT ON FUNCTION get_monthly_problem_status_v1(UUID, INT, INT) IS
'월간 캘린더에서 날짜별 문제 상태 반환.
색상 코드: orange(미해결 리포트), red(미해결 문제), green(해결됨), gray(문제없음)';
