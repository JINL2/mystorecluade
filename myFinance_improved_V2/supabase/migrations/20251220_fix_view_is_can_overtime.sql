-- ============================================================================
-- 마이그레이션: fix_view_is_can_overtime
-- 설명: v_shift_request 뷰에서 is_can_overtime = false일 때 초과근무 계산 제한
-- 문제: is_can_overtime = false인 시프트에서도 confirm_end_time_v2가 초과 계산됨
-- ============================================================================

CREATE OR REPLACE VIEW v_shift_request AS
SELECT sr.shift_request_id,
    sr.user_id,
    u.first_name,
    u.last_name,
    concat(u.first_name, ' ', u.last_name) AS user_name,
    u.email AS user_email,
    u.profile_image,
    sr.store_id,
    s.store_name,
    s.store_code,
    s.company_id,
    sr.request_date,
    sr.request_time,
    sr.shift_id,
    vs.shift_name,
    vs.order_number,
    vs.is_can_overtime,
    sr.start_time,
    sr.end_time,
    round(EXTRACT(epoch FROM sr.end_time - sr.start_time) / 3600.0, 2) AS scheduled_hours,
    sr.actual_start_time,
    sr.actual_end_time,
        CASE
            WHEN sr.actual_start_time IS NOT NULL AND sr.actual_end_time IS NOT NULL THEN round(EXTRACT(epoch FROM sr.actual_end_time - sr.actual_start_time) / 3600.0, 2)
            ELSE NULL::numeric
        END AS actual_worked_hours,
    sr.confirm_start_time AS original_confirm_start_time,
    sr.confirm_end_time AS original_confirm_end_time,
        CASE
            WHEN sr.confirm_start_time IS NOT NULL THEN sr.confirm_start_time
            WHEN sr.actual_start_time IS NOT NULL THEN
            CASE
                WHEN sr.actual_start_time <= sr.start_time THEN sr.start_time
                ELSE sr.start_time + (ceil(EXTRACT(epoch FROM sr.actual_start_time - sr.start_time) / 60.0 / COALESCE(s.payment_time, 30)::numeric) * COALESCE(s.payment_time, 30)::numeric)::double precision * '00:01:00'::interval
            END
            ELSE NULL::timestamp without time zone
        END AS confirm_start_time,
        CASE
            WHEN sr.confirm_end_time IS NOT NULL THEN sr.confirm_end_time
            WHEN sr.actual_end_time IS NOT NULL THEN
            CASE
                WHEN sr.actual_end_time <= sr.end_time THEN sr.actual_end_time
                ELSE sr.end_time +
                CASE
                    WHEN floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) = 0::numeric THEN '00:00:00'::interval
                    ELSE (floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                END
            END
            ELSE NULL::timestamp without time zone
        END AS confirm_end_time,
        CASE
            WHEN (sr.confirm_start_time IS NOT NULL OR sr.actual_start_time IS NOT NULL) AND (sr.confirm_end_time IS NOT NULL OR sr.actual_end_time IS NOT NULL) THEN round(EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_end_time IS NOT NULL THEN sr.confirm_end_time
                WHEN sr.actual_end_time IS NOT NULL THEN
                CASE
                    WHEN sr.actual_end_time <= sr.end_time THEN sr.actual_end_time
                    ELSE sr.end_time +
                    CASE
                        WHEN floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) = 0::numeric THEN '00:00:00'::interval
                        ELSE (floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                    END
                END
                ELSE NULL::timestamp without time zone
            END -
            CASE
                WHEN sr.confirm_start_time IS NOT NULL THEN sr.confirm_start_time
                WHEN sr.actual_start_time IS NOT NULL THEN
                CASE
                    WHEN sr.actual_start_time <= sr.start_time THEN sr.start_time
                    ELSE sr.start_time + (ceil(EXTRACT(epoch FROM sr.actual_start_time - sr.start_time) / 60.0 / COALESCE(s.payment_time, 30)::numeric) * COALESCE(s.payment_time, 30)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp without time zone
            END) / 3600.0, 2)
            ELSE 0::numeric
        END AS paid_hours,
    sr.is_late,
        CASE
            WHEN sr.is_late = true AND sr.actual_start_time IS NOT NULL THEN GREATEST(0::numeric, EXTRACT(epoch FROM sr.actual_start_time - sr.start_time) / 60::numeric)
            ELSE 0::numeric
        END AS late_minutes,
    sr.late_deducut_amount,
    sr.is_extratime,
        CASE
            WHEN sr.actual_end_time IS NOT NULL AND sr.actual_end_time > sr.end_time THEN EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60::numeric
            ELSE 0::numeric
        END AS overtime_minutes,
    sr.overtime_amount,
    us.salary_type,
    us.salary_amount,
        CASE
            WHEN lower(us.salary_type) = 'hourly'::text AND (sr.confirm_start_time IS NOT NULL OR sr.actual_start_time IS NOT NULL) AND (sr.confirm_end_time IS NOT NULL OR sr.actual_end_time IS NOT NULL) THEN round(EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_end_time IS NOT NULL THEN sr.confirm_end_time
                WHEN sr.actual_end_time IS NOT NULL THEN
                CASE
                    WHEN sr.actual_end_time <= sr.end_time THEN sr.actual_end_time
                    ELSE sr.end_time +
                    CASE
                        WHEN floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) = 0::numeric THEN '00:00:00'::interval
                        ELSE (floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                    END
                END
                ELSE NULL::timestamp without time zone
            END -
            CASE
                WHEN sr.confirm_start_time IS NOT NULL THEN sr.confirm_start_time
                WHEN sr.actual_start_time IS NOT NULL THEN
                CASE
                    WHEN sr.actual_start_time <= sr.start_time THEN sr.start_time
                    ELSE sr.start_time + (ceil(EXTRACT(epoch FROM sr.actual_start_time - sr.start_time) / 60.0 / COALESCE(s.payment_time, 30)::numeric) * COALESCE(s.payment_time, 30)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp without time zone
            END) / 3600.0 * COALESCE(us.salary_amount, 0::numeric), 2)
            ELSE 0::numeric
        END AS total_salary_pay,
    sr.bonus_amount,
        CASE
            WHEN lower(us.salary_type) = 'hourly'::text AND (sr.confirm_start_time IS NOT NULL OR sr.actual_start_time IS NOT NULL) AND (sr.confirm_end_time IS NOT NULL OR sr.actual_end_time IS NOT NULL) THEN round(EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_end_time IS NOT NULL THEN sr.confirm_end_time
                WHEN sr.actual_end_time IS NOT NULL THEN
                CASE
                    WHEN sr.actual_end_time <= sr.end_time THEN sr.actual_end_time
                    ELSE sr.end_time +
                    CASE
                        WHEN floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) = 0::numeric THEN '00:00:00'::interval
                        ELSE (floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                    END
                END
                ELSE NULL::timestamp without time zone
            END -
            CASE
                WHEN sr.confirm_start_time IS NOT NULL THEN sr.confirm_start_time
                WHEN sr.actual_start_time IS NOT NULL THEN
                CASE
                    WHEN sr.actual_start_time <= sr.start_time THEN sr.start_time
                    ELSE sr.start_time + (ceil(EXTRACT(epoch FROM sr.actual_start_time - sr.start_time) / 60.0 / COALESCE(s.payment_time, 30)::numeric) * COALESCE(s.payment_time, 30)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp without time zone
            END) / 3600.0 * COALESCE(us.salary_amount, 0::numeric), 2) + COALESCE(sr.bonus_amount, 0::numeric)
            ELSE COALESCE(sr.bonus_amount, 0::numeric)
        END AS total_pay_with_bonus,
        CASE
            WHEN sr.is_late = true AND lower(us.salary_type) = 'hourly'::text THEN round(COALESCE(sr.late_deducut_amount, 0::numeric) / 60.0 * COALESCE(us.salary_amount, 0::numeric), 0)
            ELSE 0::numeric
        END AS late_deduction_krw,
    sr.is_approved,
    sr.approved_by,
    sr.checkin_location,
    sr.checkin_distance_from_store,
    sr.is_valid_checkin_location,
    sr.checkout_location,
    sr.checkout_distance_from_store,
    sr.is_valid_checkout_location,
    s.allowed_distance,
    s.huddle_time,
    s.payment_time,
    sr.notice_tag,
    sr.is_reported,
    sr.report_time,
    sr.problem_type,
    sr.is_problem,
    sr.is_problem_solved,
    sr.is_problem = true AND sr.is_problem_solved = false AS has_unsolved_problem,
    sr.created_at,
    sr.updated_at,
        CASE
            WHEN sr.confirm_start_time IS NOT NULL OR sr.actual_start_time IS NOT NULL THEN GREATEST(0::numeric, EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_start_time IS NOT NULL THEN sr.confirm_start_time
                WHEN sr.actual_start_time IS NOT NULL THEN
                CASE
                    WHEN sr.actual_start_time <= sr.start_time THEN sr.start_time
                    ELSE sr.start_time + (ceil(EXTRACT(epoch FROM sr.actual_start_time - sr.start_time) / 60.0 / COALESCE(s.payment_time, 30)::numeric) * COALESCE(s.payment_time, 30)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp without time zone
            END - sr.start_time) / 60.0)::integer
            ELSE 0
        END AS late_deduct_minute,
        CASE
            WHEN sr.confirm_end_time IS NOT NULL OR sr.actual_end_time IS NOT NULL THEN GREATEST(0::numeric, EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_end_time IS NOT NULL THEN sr.confirm_end_time
                WHEN sr.actual_end_time IS NOT NULL THEN
                CASE
                    WHEN sr.actual_end_time <= sr.end_time THEN sr.actual_end_time
                    ELSE sr.end_time +
                    CASE
                        WHEN floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) = 0::numeric THEN '00:00:00'::interval
                        ELSE (floor(EXTRACT(epoch FROM sr.actual_end_time - sr.end_time) / 60.0 / COALESCE(s.payment_time, 20)::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                    END
                END
                ELSE NULL::timestamp without time zone
            END - sr.end_time) / 60.0)::integer
            ELSE 0
        END AS overtime_plus_minute,
    sr.report_reason,
    sr.request_date_utc,
    sr.start_time_utc,
    sr.end_time_utc,
    sr.actual_start_time_utc,
    sr.actual_end_time_utc,
    sr.confirm_start_time_utc AS original_confirm_start_time_utc,
    sr.confirm_end_time_utc AS original_confirm_end_time_utc,
    sr.report_time_utc,
    sr.created_at_utc,
    sr.updated_at_utc,
    sr.is_late_v2,
    sr.late_deducut_amount_v2,
    sr.is_extratime_v2,
    sr.overtime_amount_v2,
    sr.is_problem_v2,
    sr.is_problem_solved_v2,
    sr.problem_type_v2,
    sr.is_problem_v2 = true AND sr.is_problem_solved_v2 = false AS has_unsolved_problem_v2,
    sr.bonus_amount_v2,
    sr.report_reason_v2,
    sr.notice_tag_v2,
    sr.is_reported_v2,
    sr.checkin_distance_from_store_v2,
    sr.checkout_distance_from_store_v2,
    sr.is_valid_checkin_location_v2,
    sr.is_valid_checkout_location_v2,
    sr.is_reported_solved_v2,
    sr.manager_memo_v2,
    round(EXTRACT(epoch FROM sr.end_time_utc - sr.start_time_utc) / 3600.0, 2) AS scheduled_hours_v2,
        CASE
            WHEN sr.actual_start_time_utc IS NOT NULL AND sr.actual_end_time_utc IS NOT NULL THEN round(EXTRACT(epoch FROM sr.actual_end_time_utc - sr.actual_start_time_utc) / 3600.0, 2)
            ELSE NULL::numeric
        END AS actual_worked_hours_v2,
        CASE
            WHEN sr.is_late_v2 = true AND sr.actual_start_time_utc IS NOT NULL THEN GREATEST(0::numeric, EXTRACT(epoch FROM sr.actual_start_time_utc - sr.start_time_utc) / 60::numeric)
            ELSE 0::numeric
        END AS late_minutes_v2,
        CASE
            WHEN sr.actual_end_time_utc IS NOT NULL AND sr.actual_end_time_utc > sr.end_time_utc THEN EXTRACT(epoch FROM sr.actual_end_time_utc - sr.end_time_utc) / 60::numeric
            ELSE 0::numeric
        END AS overtime_minutes_v2,
        CASE
            WHEN sr.confirm_start_time_utc IS NOT NULL THEN sr.confirm_start_time_utc
            WHEN sr.actual_start_time_utc IS NOT NULL THEN
            CASE
                WHEN sr.actual_start_time_utc <= sr.start_time_utc THEN sr.start_time_utc
                ELSE sr.start_time_utc + (ceil(EXTRACT(epoch FROM sr.actual_start_time_utc - sr.start_time_utc) / 60.0 / COALESCE(s.huddle_time, 15)::numeric) * COALESCE(s.payment_time, 20)::numeric)::double precision * '00:01:00'::interval
            END
            ELSE NULL::timestamp with time zone
        END AS confirm_start_time_v2,
        -- ★★★ 수정: is_can_overtime 체크 추가 ★★★
        CASE
            WHEN sr.confirm_end_time_utc IS NOT NULL THEN sr.confirm_end_time_utc
            WHEN sr.actual_end_time_utc IS NOT NULL THEN
            CASE
                WHEN sr.actual_end_time_utc <= sr.end_time_utc THEN sr.actual_end_time_utc
                -- ★ is_can_overtime = false면 end_time_utc로 제한
                WHEN COALESCE(vs.is_can_overtime, true) = false THEN sr.end_time_utc
                ELSE sr.end_time_utc + (GREATEST(0::numeric, ceil(EXTRACT(epoch FROM sr.actual_end_time_utc - sr.end_time_utc) / 60.0 / COALESCE(s.payment_time, 20)::numeric) - 1::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
            END
            ELSE NULL::timestamp with time zone
        END AS confirm_end_time_v2,
        -- ★★★ 수정: paid_hours_v2 계산에도 is_can_overtime 체크 추가 ★★★
        CASE
            WHEN (sr.confirm_start_time_utc IS NOT NULL OR sr.actual_start_time_utc IS NOT NULL) AND (sr.confirm_end_time_utc IS NOT NULL OR sr.actual_end_time_utc IS NOT NULL) THEN round(EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_end_time_utc IS NOT NULL THEN sr.confirm_end_time_utc
                WHEN sr.actual_end_time_utc IS NOT NULL THEN
                CASE
                    WHEN sr.actual_end_time_utc <= sr.end_time_utc THEN sr.actual_end_time_utc
                    -- ★ is_can_overtime = false면 end_time_utc로 제한
                    WHEN COALESCE(vs.is_can_overtime, true) = false THEN sr.end_time_utc
                    ELSE sr.end_time_utc + (GREATEST(0::numeric, ceil(EXTRACT(epoch FROM sr.actual_end_time_utc - sr.end_time_utc) / 60.0 / COALESCE(s.payment_time, 20)::numeric) - 1::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp with time zone
            END -
            CASE
                WHEN sr.confirm_start_time_utc IS NOT NULL THEN sr.confirm_start_time_utc
                WHEN sr.actual_start_time_utc IS NOT NULL THEN
                CASE
                    WHEN sr.actual_start_time_utc <= sr.start_time_utc THEN sr.start_time_utc
                    ELSE sr.start_time_utc + (ceil(EXTRACT(epoch FROM sr.actual_start_time_utc - sr.start_time_utc) / 60.0 / COALESCE(s.huddle_time, 15)::numeric) * COALESCE(s.payment_time, 20)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp with time zone
            END) / 3600.0, 2)
            ELSE 0::numeric
        END AS paid_hours_v2,
        CASE
            WHEN sr.confirm_start_time_utc IS NOT NULL OR sr.actual_start_time_utc IS NOT NULL THEN GREATEST(0::numeric, EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_start_time_utc IS NOT NULL THEN sr.confirm_start_time_utc
                WHEN sr.actual_start_time_utc IS NOT NULL THEN
                CASE
                    WHEN sr.actual_start_time_utc <= sr.start_time_utc THEN sr.start_time_utc
                    ELSE sr.start_time_utc + (ceil(EXTRACT(epoch FROM sr.actual_start_time_utc - sr.start_time_utc) / 60.0 / COALESCE(s.huddle_time, 15)::numeric) * COALESCE(s.payment_time, 20)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp with time zone
            END - sr.start_time_utc) / 60.0)::integer
            ELSE 0
        END AS late_deduct_minute_v2,
        -- ★★★ 수정: overtime_plus_minute_v2 계산에도 is_can_overtime 체크 추가 ★★★
        CASE
            WHEN sr.confirm_end_time_utc IS NOT NULL OR sr.actual_end_time_utc IS NOT NULL THEN GREATEST(0::numeric, EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_end_time_utc IS NOT NULL THEN sr.confirm_end_time_utc
                WHEN sr.actual_end_time_utc IS NOT NULL THEN
                CASE
                    WHEN sr.actual_end_time_utc <= sr.end_time_utc THEN sr.actual_end_time_utc
                    -- ★ is_can_overtime = false면 end_time_utc로 제한
                    WHEN COALESCE(vs.is_can_overtime, true) = false THEN sr.end_time_utc
                    ELSE sr.end_time_utc + (GREATEST(0::numeric, ceil(EXTRACT(epoch FROM sr.actual_end_time_utc - sr.end_time_utc) / 60.0 / COALESCE(s.payment_time, 20)::numeric) - 1::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp with time zone
            END - sr.end_time_utc) / 60.0)::integer
            ELSE 0
        END AS overtime_plus_minute_v2,
        -- ★★★ 수정: total_salary_pay_v2 계산에도 is_can_overtime 체크 추가 ★★★
        CASE
            WHEN lower(us.salary_type) = 'hourly'::text AND (sr.confirm_start_time_utc IS NOT NULL OR sr.actual_start_time_utc IS NOT NULL) AND (sr.confirm_end_time_utc IS NOT NULL OR sr.actual_end_time_utc IS NOT NULL) THEN round(EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_end_time_utc IS NOT NULL THEN sr.confirm_end_time_utc
                WHEN sr.actual_end_time_utc IS NOT NULL THEN
                CASE
                    WHEN sr.actual_end_time_utc <= sr.end_time_utc THEN sr.actual_end_time_utc
                    -- ★ is_can_overtime = false면 end_time_utc로 제한
                    WHEN COALESCE(vs.is_can_overtime, true) = false THEN sr.end_time_utc
                    ELSE sr.end_time_utc + (GREATEST(0::numeric, ceil(EXTRACT(epoch FROM sr.actual_end_time_utc - sr.end_time_utc) / 60.0 / COALESCE(s.payment_time, 20)::numeric) - 1::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp with time zone
            END -
            CASE
                WHEN sr.confirm_start_time_utc IS NOT NULL THEN sr.confirm_start_time_utc
                WHEN sr.actual_start_time_utc IS NOT NULL THEN
                CASE
                    WHEN sr.actual_start_time_utc <= sr.start_time_utc THEN sr.start_time_utc
                    ELSE sr.start_time_utc + (ceil(EXTRACT(epoch FROM sr.actual_start_time_utc - sr.start_time_utc) / 60.0 / COALESCE(s.huddle_time, 15)::numeric) * COALESCE(s.payment_time, 20)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp with time zone
            END) / 3600.0 * COALESCE(us.salary_amount, 0::numeric), 2)
            ELSE 0::numeric
        END AS total_salary_pay_v2,
        -- ★★★ 수정: total_pay_with_bonus_v2 계산에도 is_can_overtime 체크 추가 ★★★
        CASE
            WHEN lower(us.salary_type) = 'hourly'::text AND (sr.confirm_start_time_utc IS NOT NULL OR sr.actual_start_time_utc IS NOT NULL) AND (sr.confirm_end_time_utc IS NOT NULL OR sr.actual_end_time_utc IS NOT NULL) THEN round(EXTRACT(epoch FROM
            CASE
                WHEN sr.confirm_end_time_utc IS NOT NULL THEN sr.confirm_end_time_utc
                WHEN sr.actual_end_time_utc IS NOT NULL THEN
                CASE
                    WHEN sr.actual_end_time_utc <= sr.end_time_utc THEN sr.actual_end_time_utc
                    -- ★ is_can_overtime = false면 end_time_utc로 제한
                    WHEN COALESCE(vs.is_can_overtime, true) = false THEN sr.end_time_utc
                    ELSE sr.end_time_utc + (GREATEST(0::numeric, ceil(EXTRACT(epoch FROM sr.actual_end_time_utc - sr.end_time_utc) / 60.0 / COALESCE(s.payment_time, 20)::numeric) - 1::numeric) * COALESCE(s.huddle_time, 15)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp with time zone
            END -
            CASE
                WHEN sr.confirm_start_time_utc IS NOT NULL THEN sr.confirm_start_time_utc
                WHEN sr.actual_start_time_utc IS NOT NULL THEN
                CASE
                    WHEN sr.actual_start_time_utc <= sr.start_time_utc THEN sr.start_time_utc
                    ELSE sr.start_time_utc + (ceil(EXTRACT(epoch FROM sr.actual_start_time_utc - sr.start_time_utc) / 60.0 / COALESCE(s.huddle_time, 15)::numeric) * COALESCE(s.payment_time, 20)::numeric)::double precision * '00:01:00'::interval
                END
                ELSE NULL::timestamp with time zone
            END) / 3600.0 * COALESCE(us.salary_amount, 0::numeric), 2) + COALESCE(sr.bonus_amount_v2, 0::numeric)
            ELSE COALESCE(sr.bonus_amount_v2, 0::numeric)
        END AS total_pay_with_bonus_v2,
        CASE
            WHEN sr.is_late_v2 = true AND lower(us.salary_type) = 'hourly'::text THEN round(COALESCE(sr.late_deducut_amount_v2, 0::numeric) / 60.0 * COALESCE(us.salary_amount, 0::numeric), 0)
            ELSE 0::numeric
        END AS late_deduction_krw_v2,
    sr.problem_details_v2
   FROM shift_requests sr
     JOIN stores s ON sr.store_id = s.store_id
     LEFT JOIN users u ON sr.user_id = u.user_id
     LEFT JOIN user_salaries us ON sr.user_id = us.user_id AND us.company_id = s.company_id
     LEFT JOIN v_store_shifts vs ON sr.shift_id = vs.shift_id;

-- 코멘트 업데이트
COMMENT ON VIEW v_shift_request IS
'시프트 요청 통합 뷰
v2.1: is_can_overtime 설정 확인 추가 - false인 시프트는 confirm_end_time_v2가 end_time_utc로 제한됨';
