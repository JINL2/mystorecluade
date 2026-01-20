-- ============================================================================
-- Fix user_shift_cards_v7: Extend end_time range from 3 days to 7 days
-- ============================================================================
-- 문제: 월말~월초에 걸친 주(Week)를 볼 때, 다음 달 초 데이터가 누락됨
-- 원인: v_end_time이 월말 + 3일까지만 조회 (예: 12월 요청 → 1월 3일까지)
-- 해결: v_end_time을 월말 + 7일로 확장하여 주 전체 데이터 포함
--
-- 예시:
--   - 12월 요청 시 기존: 11월 29일 ~ 1월 3일 (1월 4일 누락)
--   - 12월 요청 시 수정: 11월 29일 ~ 1월 7일 (주 전체 포함)
-- ============================================================================

CREATE OR REPLACE FUNCTION user_shift_cards_v7(
    p_request_time timestamp,
    p_user_id uuid,
    p_company_id uuid,
    p_store_id uuid DEFAULT NULL,
    p_timezone text DEFAULT 'Asia/Ho_Chi_Minh'
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
/*
============================================
함수: user_shift_cards_v7
설명: 사용자의 월간 시프트 카드 데이터를 조회합니다.
변경: v6 대비 manager_memo 필드 추가
수정: 2026-01-14 - 조회 범위 확장 (3일 → 7일)

[파라미터]
- p_request_time: 조회 기준 시간 (로컬)
- p_user_id: 사용자 ID
- p_company_id: 회사 ID
- p_store_id: 매장 ID (Optional - null이면 회사 전체 매장)
- p_timezone: 타임존 (기본: Asia/Ho_Chi_Minh)

[반환값]
- shift_date: 시프트 날짜/시간
- shift_request_id: 시프트 요청 ID
- shift_name: 시프트 이름
- shift_start_time/shift_end_time: 예정 시작/종료 시간
- scheduled_hours: 예정 근무시간
- is_approved: 승인 여부
- actual_start_time/actual_end_time: 실제 체크인/체크아웃 시간
- confirm_start_time/confirm_end_time: 확정 시작/종료 시간
- paid_hours: 급여 시간
- base_pay/bonus_amount/total_pay_with_bonus: 급여 정보
- salary_type/salary_amount: 급여 유형/금액
- store_id: 매장 ID
- store_name: 매장명
- problem_details: 문제 상세 JSONB (모든 문제 정보 통합)
- manager_memo: 매니저 메모 JSONB array (v7 추가)
============================================
*/
DECLARE
    result_json json;
    v_start_time timestamptz;
    v_end_time timestamptz;
BEGIN
    -- 입력값 검증
    IF p_request_time IS NULL THEN
        RAISE EXCEPTION 'request_time cannot be null' USING ERRCODE = 'P0001';
    END IF;

    IF p_user_id IS NULL THEN
        RAISE EXCEPTION 'user_id cannot be null' USING ERRCODE = 'P0001';
    END IF;

    IF p_company_id IS NULL THEN
        RAISE EXCEPTION 'company_id cannot be null' USING ERRCODE = 'P0001';
    END IF;

    -- 조회 범위 계산 (해당 월 기준 앞뒤 여유)
    -- 수정: 3일 → 7일로 확장하여 월말~월초 주 전체 포함
    v_start_time := (date_trunc('month', p_request_time) - INTERVAL '2 days') AT TIME ZONE p_timezone;
    v_end_time := (date_trunc('month', p_request_time) + INTERVAL '1 month' + INTERVAL '7 days') AT TIME ZONE p_timezone;

    -- 시프트 카드 데이터 조회
    SELECT json_agg(
        json_build_object(
            -- 기본 정보
            'shift_date', to_char(vsr.start_time_utc AT TIME ZONE p_timezone, 'YYYY-MM-DD"T"HH24:MI:SS'),
            'shift_request_id', vsr.shift_request_id,
            'shift_name', COALESCE(vsr.shift_name, 'N/A'),
            'shift_start_time',
                CASE
                    WHEN vsr.start_time_utc IS NOT NULL THEN to_char(vsr.start_time_utc AT TIME ZONE p_timezone, 'YYYY-MM-DD"T"HH24:MI:SS')
                    ELSE null
                END,
            'shift_end_time',
                CASE
                    WHEN vsr.end_time_utc IS NOT NULL THEN to_char(vsr.end_time_utc AT TIME ZONE p_timezone, 'YYYY-MM-DD"T"HH24:MI:SS')
                    ELSE null
                END,
            'scheduled_hours', COALESCE(vsr.scheduled_hours_v2, 0),
            'is_approved', COALESCE(vsr.is_approved, false),

            -- 출퇴근 시간
            'actual_start_time',
                CASE
                    WHEN vsr.actual_start_time_utc IS NOT NULL THEN to_char(vsr.actual_start_time_utc AT TIME ZONE p_timezone, 'HH24:MI:SS')
                    ELSE null
                END,
            'actual_end_time',
                CASE
                    WHEN vsr.actual_end_time_utc IS NOT NULL THEN to_char(vsr.actual_end_time_utc AT TIME ZONE p_timezone, 'HH24:MI:SS')
                    ELSE null
                END,
            'confirm_start_time',
                CASE
                    WHEN vsr.confirm_start_time_v2 IS NOT NULL THEN to_char(vsr.confirm_start_time_v2 AT TIME ZONE p_timezone, 'HH24:MI')
                    ELSE null
                END,
            'confirm_end_time',
                CASE
                    WHEN vsr.confirm_end_time_v2 IS NOT NULL THEN to_char(vsr.confirm_end_time_v2 AT TIME ZONE p_timezone, 'HH24:MI')
                    ELSE null
                END,

            -- 급여 정보
            'paid_hours', COALESCE(vsr.paid_hours_v2, 0),
            'base_pay',
                CASE
                    WHEN vsr.total_salary_pay_v2 IS NOT NULL THEN
                        to_char(COALESCE(vsr.total_salary_pay_v2, 0), 'FM999,999,999')
                    ELSE '0'
                END,
            'bonus_amount', COALESCE(vsr.bonus_amount_v2, 0),
            'total_pay_with_bonus',
                CASE
                    WHEN vsr.total_pay_with_bonus_v2 IS NOT NULL AND vsr.total_pay_with_bonus_v2 > 0 THEN
                        to_char(COALESCE(vsr.total_pay_with_bonus_v2, 0), 'FM999,999,999')
                    ELSE '0'
                END,
            'salary_type', COALESCE(vsr.salary_type, 'hourly'),
            'salary_amount',
                CASE
                    WHEN vsr.salary_amount IS NOT NULL AND vsr.salary_amount > 0 THEN
                        to_char(COALESCE(vsr.salary_amount, 0), 'FM999,999,999')
                    ELSE '0'
                END,

            -- 매장 정보
            'store_id', vsr.store_id,
            'store_name', COALESCE(s.store_name, 'Unknown Store'),

            -- 문제 상세 (JSONB) - 모든 문제 정보를 하나의 JSONB로 통합
            'problem_details', COALESCE(
                vsr.problem_details_v2,
                '{"has_late":false,"has_absence":false,"has_overtime":false,"has_early_leave":false,"has_no_checkout":false,"has_location_issue":false,"has_reported":false,"is_solved":false,"problem_count":0,"problems":[]}'::jsonb
            ),

            -- v7: 매니저 메모 (JSONB array)
            'manager_memo', COALESCE(vsr.manager_memo_v2, '[]'::jsonb)
        )
        ORDER BY vsr.start_time_utc ASC
    ) INTO result_json
    FROM v_shift_request vsr
    JOIN stores s ON vsr.store_id = s.store_id
    WHERE vsr.user_id = p_user_id
        AND s.company_id = p_company_id
        -- store_id 필터: null이면 회사 전체, 값이 있으면 해당 매장만
        AND (p_store_id IS NULL OR vsr.store_id = p_store_id)
        AND vsr.start_time_utc >= v_start_time
        AND vsr.start_time_utc < v_end_time;

    -- 결과가 없는 경우 빈 배열 반환
    IF result_json IS NULL THEN
        result_json := '[]'::json;
    END IF;

    RETURN result_json;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'error', true,
            'error_code', SQLSTATE,
            'error_message', SQLERRM,
            'data', '[]'::json
        );
END;
$$;

-- 코멘트 추가
COMMENT ON FUNCTION user_shift_cards_v7 IS '사용자 월간 시프트 카드 조회. 2026-01-14: 조회 범위 3일→7일 확장 (월말~월초 주 데이터 누락 수정)';
