-- ============================================================================
-- 함수: manager_shift_get_cards_v5
-- 설명: 매니저용 시프트 카드 데이터를 조회합니다. (근무 날짜 기준)
-- 버전: 5.0 - problem_details_v2 필드 추가 (월간 문제 캘린더용)
-- ============================================================================
--
-- [v5 변경사항]
-- - problem_details 필드 추가 (problem_details_v2 JSONB 전체 반환)
--   구조: {
--     "is_solved": bool,
--     "problem_count": int,
--     "has_late": bool,
--     "has_overtime": bool,
--     "has_absence": bool,
--     "has_early_leave": bool,
--     "has_no_checkout": bool,
--     "has_reported": bool,
--     "has_location_issue": bool,
--     "has_payroll_late": bool,
--     "has_payroll_overtime": bool,
--     "has_payroll_early_leave": bool,
--     "detected_at": timestamp,
--     "problems": [
--       {"type": "late", "actual_minutes": 28, "payroll_minutes": 40, "is_payroll_adjusted": false},
--       {"type": "overtime", "actual_minutes": 17, ...},
--       {"type": "no_checkout"},
--       {"type": "reported", "reason": "...", "reported_at": "...", "is_report_solved": false}
--     ]
--   }
--
-- [사용처]
-- - Flutter: managerCardsProvider (time_table_manage feature)
-- - 월간 문제 캘린더에서 날짜별 문제 상태 표시
-- - 문제 상세 페이지에서 problem_details 표시
-- ============================================================================

CREATE OR REPLACE FUNCTION manager_shift_get_cards_v5(
    p_company_id uuid,
    p_start_date date,
    p_end_date date,
    p_store_id uuid DEFAULT NULL,
    p_timezone text DEFAULT 'Asia/Ho_Chi_Minh'
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN (
        WITH card_data AS (
            SELECT
                vsr.store_id,
                vsr.store_name,
                json_agg(
                    json_build_object(
                        'shift_date', DATE(vsr.start_time_utc AT TIME ZONE p_timezone),
                        'shift_request_id', vsr.shift_request_id,
                        'user_id', vsr.user_id,
                        'user_name', vsr.user_name,
                        'profile_image', vsr.profile_image,
                        'shift_name', vsr.shift_name,
                        'shift_time', CONCAT(
                            TO_CHAR(vsr.start_time_utc AT TIME ZONE p_timezone, 'HH24:MI'),
                            '-',
                            TO_CHAR(vsr.end_time_utc AT TIME ZONE p_timezone, 'HH24:MI')
                        ),
                        'shift_start_time', TO_CHAR(vsr.start_time_utc AT TIME ZONE p_timezone, 'YYYY-MM-DD HH24:MI'),
                        'shift_end_time', TO_CHAR(vsr.end_time_utc AT TIME ZONE p_timezone, 'YYYY-MM-DD HH24:MI'),
                        'is_approved', vsr.is_approved,
                        'is_problem', vsr.is_problem_v2,
                        'is_problem_solved', vsr.is_problem_solved_v2,
                        'is_late', vsr.is_late_v2,
                        'late_minute', ROUND(COALESCE(vsr.late_minutes_v2, 0))::integer,
                        'is_over_time', vsr.is_extratime_v2,
                        'over_time_minute', COALESCE(vsr.overtime_minutes_v2, 0),
                        'paid_hour', vsr.paid_hours_v2,
                        'salary_type', COALESCE(vsr.salary_type, 'hourly'),
                        'salary_amount',
                            CASE
                                WHEN vsr.salary_amount IS NOT NULL AND vsr.salary_amount > 0 THEN
                                    to_char(COALESCE(vsr.salary_amount, 0), 'FM999,999,999')
                                ELSE '0'
                            END,
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
                        'actual_start', TO_CHAR(vsr.actual_start_time_utc AT TIME ZONE p_timezone, 'HH24:MI:SS'),
                        'actual_end', TO_CHAR(vsr.actual_end_time_utc AT TIME ZONE p_timezone, 'HH24:MI:SS'),
                        'confirm_start_time', TO_CHAR(vsr.confirm_start_time_v2 AT TIME ZONE p_timezone, 'HH24:MI'),
                        'confirm_end_time', TO_CHAR(vsr.confirm_end_time_v2 AT TIME ZONE p_timezone, 'HH24:MI'),
                        'notice_tag', COALESCE(
                            (SELECT jsonb_agg(
                                json_build_object(
                                    'id', tag->>'id',
                                    'type', tag->>'type',
                                    'content', tag->>'content',
                                    'created_at', tag->>'created_at',
                                    'created_by', tag->>'created_by',
                                    'created_by_name', CASE
                                        WHEN tag->>'created_by' IS NULL THEN 'System'
                                        ELSE COALESCE(
                                            (SELECT CONCAT(first_name, ' ', last_name)
                                             FROM users
                                             WHERE user_id::text = tag->>'created_by'),
                                            'Unknown User'
                                        )
                                    END
                                )
                            ) FROM jsonb_array_elements(vsr.notice_tag_v2) AS tag),
                            '[]'::jsonb
                        ),
                        'problem_type', vsr.problem_type_v2,
                        'is_valid_checkin_location', vsr.is_valid_checkin_location_v2,
                        'is_valid_checkout_location', vsr.is_valid_checkout_location_v2,
                        'checkin_distance_from_store', COALESCE(vsr.checkin_distance_from_store_v2, 0),
                        'checkout_distance_from_store', COALESCE(vsr.checkout_distance_from_store_v2, 0),
                        'store_name', vsr.store_name,
                        'is_reported', vsr.is_reported_v2,
                        'is_reported_solved', vsr.is_reported_solved_v2,
                        'report_reason', vsr.report_reason_v2,
                        'manager_memo', COALESCE(vsr.manager_memo_v2, '[]'::jsonb),
                        -- v5: problem_details 추가
                        'problem_details', COALESCE(vsr.problem_details_v2, '{}'::jsonb)
                    )
                    ORDER BY DATE(vsr.start_time_utc AT TIME ZONE p_timezone) DESC
                ) as cards,
                COUNT(*) as request_count,
                COUNT(*) FILTER (WHERE vsr.is_approved = true) as approved_count,
                COUNT(*) FILTER (WHERE vsr.is_problem_v2 = true) as problem_count
            FROM v_shift_request vsr
            JOIN stores s ON vsr.store_id = s.store_id
            WHERE s.company_id = p_company_id
            AND vsr.start_time_utc IS NOT NULL
            AND DATE(vsr.start_time_utc AT TIME ZONE p_timezone) BETWEEN p_start_date AND p_end_date
            AND (p_store_id IS NULL OR vsr.store_id = p_store_id)
            GROUP BY vsr.store_id, vsr.store_name
        ),
        content_data AS (
            SELECT DISTINCT
                tag->>'content' as content,
                tag->>'type' as type
            FROM v_shift_request vsr
            JOIN stores s ON vsr.store_id = s.store_id,
            jsonb_array_elements(vsr.notice_tag_v2) AS tag
            WHERE s.company_id = p_company_id
            AND vsr.start_time_utc IS NOT NULL
            AND DATE(vsr.start_time_utc AT TIME ZONE p_timezone) BETWEEN p_start_date AND p_end_date
            AND (p_store_id IS NULL OR vsr.store_id = p_store_id)
            AND tag->>'content' IS NOT NULL
            AND tag->>'content' != ''
        ),
        final_stores AS (
            SELECT json_agg(
                json_build_object(
                    'store_id', store_id,
                    'store_name', store_name,
                    'request_count', request_count,
                    'approved_count', approved_count,
                    'problem_count', problem_count,
                    'cards', cards
                )
            ) as stores_data
            FROM card_data
        )
        SELECT json_build_object(
            'available_contents', COALESCE(
                (SELECT json_agg(
                    json_build_object(
                        'content', content,
                        'type', type
                    )
                    ORDER BY content
                ) FROM content_data),
                '[]'::json
            ),
            'stores', COALESCE(
                (SELECT stores_data FROM final_stores),
                CASE
                    WHEN p_store_id IS NOT NULL THEN
                        format('[{"store_id": "%s", "store_name": null, "request_count": 0, "approved_count": 0, "problem_count": 0, "cards": []}]', p_store_id)::json
                    ELSE
                        '[{"store_id": null, "store_name": null, "request_count": 0, "approved_count": 0, "problem_count": 0, "cards": []}]'::json
                END
            ),
            'timezone', p_timezone
        )
    );
END;
$$;

-- 권한 부여
GRANT EXECUTE ON FUNCTION manager_shift_get_cards_v5(uuid, date, date, uuid, text) TO authenticated;

-- 코멘트 추가
COMMENT ON FUNCTION manager_shift_get_cards_v5 IS
'매니저용 시프트 카드 데이터 조회 (v5)
v5 변경사항: problem_details 필드 추가 (problem_details_v2 JSONB)
- 월간 문제 캘린더용 상세 정보 포함
- has_late, has_overtime, has_absence 등 플래그
- problems 배열: 각 문제의 상세 정보 (type, actual_minutes, payroll_minutes)';
