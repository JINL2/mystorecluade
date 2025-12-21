-- user_shift_stats: Change from store-specific to company-wide salary data
-- The p_store_id parameter is kept for backwards compatibility but no longer used for filtering
--
-- Changes:
-- - Removed "AND vsr.store_id = p_store_id" from all 12 queries
-- - salary_info and reliability_score were already company-wide (no change needed)
-- - Now calculates salary data across ALL stores in the company

CREATE OR REPLACE FUNCTION public.user_shift_stats(
    p_user_id uuid,
    p_company_id uuid,
    p_store_id uuid,
    p_request_time timestamp with time zone,
    p_timezone text DEFAULT 'Asia/Ho_Chi_Minh'::text
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
    result_json json;
    salary_info_json json;
    today_json json;
    this_week_json json;
    this_month_json json;
    last_month_json json;
    this_year_json json;
    weekly_payments_json json;
    v_reliability_score_json json;

    v_local_time timestamp;
    v_today_start timestamp;
    v_today_end timestamp;
    v_yesterday_start timestamp;
    v_yesterday_end timestamp;
    v_week_start timestamp;
    v_week_end timestamp;
    v_last_week_start timestamp;
    v_last_week_end timestamp;
    v_month_start timestamp;
    v_month_end timestamp;
    v_last_month_start timestamp;
    v_last_month_end timestamp;
    v_two_months_ago_start timestamp;
    v_two_months_ago_end timestamp;
    v_year_start timestamp;
    v_year_end timestamp;
    v_last_year_start timestamp;
    v_last_year_end timestamp;

    v_yesterday_total numeric;
    v_last_week_total numeric;
    v_last_month_total numeric;
    v_two_months_ago_total numeric;
    v_last_year_total numeric;
BEGIN
    v_local_time := p_request_time AT TIME ZONE p_timezone;

    v_today_start := date_trunc('day', v_local_time);
    v_today_end := v_today_start + interval '1 day';
    v_yesterday_start := v_today_start - interval '1 day';
    v_yesterday_end := v_today_start;
    v_week_start := date_trunc('week', v_local_time);
    v_week_end := v_week_start + interval '1 week';
    v_last_week_start := v_week_start - interval '1 week';
    v_last_week_end := v_week_start;
    v_month_start := date_trunc('month', v_local_time);
    v_month_end := v_month_start + interval '1 month';
    v_last_month_start := date_trunc('month', v_local_time) - interval '1 month';
    v_last_month_end := date_trunc('month', v_local_time);
    v_two_months_ago_start := date_trunc('month', v_local_time) - interval '2 months';
    v_two_months_ago_end := date_trunc('month', v_local_time) - interval '1 month';
    v_year_start := date_trunc('year', v_local_time);
    v_year_end := v_year_start + interval '1 year';
    v_last_year_start := date_trunc('year', v_local_time) - interval '1 year';
    v_last_year_end := date_trunc('year', v_local_time);

    -- Salary info (already company-wide)
    SELECT json_build_object(
        'salary_type', COALESCE(vus.salary_type, 'hourly'),
        'salary_amount', COALESCE(vus.salary_amount, 0),
        'currency_code', COALESCE(vus.currency_code, 'VND'),
        'currency_symbol', COALESCE(vus.symbol, '₫')
    ) INTO salary_info_json
    FROM v_user_salary vus
    WHERE vus.user_id = p_user_id AND vus.company_id = p_company_id
    LIMIT 1;

    IF salary_info_json IS NULL THEN
        salary_info_json := json_build_object(
            'salary_type', 'hourly', 'salary_amount', 0,
            'currency_code', 'VND', 'currency_symbol', '₫'
        );
    END IF;

    -- Reliability score (already company-wide)
    SELECT json_build_object(
        'completed_shifts', COALESCE(completed_shifts, 0),
        'on_time_rate', COALESCE(on_time_rate, 0),
        'final_score', COALESCE(final_score, 50),
        'score_breakdown', COALESCE(score_breakdown, '{}'::jsonb)
    ) INTO v_reliability_score_json
    FROM v_employee_statistics_score
    WHERE user_id = p_user_id AND company_id = p_company_id;

    IF v_reliability_score_json IS NULL THEN
        v_reliability_score_json := json_build_object(
            'completed_shifts', 0,
            'on_time_rate', 0,
            'final_score', 50,
            'score_breakdown', '{}'::json
        );
    END IF;

    -- Previous period totals (CHANGED: removed store_id filter - now company-wide)
    SELECT COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
        WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
    ), 0) INTO v_yesterday_total
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_yesterday_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_yesterday_end;

    SELECT COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
        WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
    ), 0) INTO v_last_week_total
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_last_week_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_last_week_end;

    SELECT COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
        WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
    ), 0) INTO v_last_month_total
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_last_month_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_last_month_end;

    SELECT COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
        WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
    ), 0) INTO v_two_months_ago_total
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_two_months_ago_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_two_months_ago_end;

    SELECT COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
        WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
    ), 0) INTO v_last_year_total
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_last_year_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_last_year_end;

    -- Today (CHANGED: removed store_id filter - now company-wide)
    SELECT json_build_object(
        'on_time_rate', CASE WHEN COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL) = 0 THEN 0
            ELSE ROUND(COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL AND vsr.is_late_v2 = false)::numeric /
                COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL)::numeric * 100, 1) END,
        'complete_shifts', COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL),
        'total_confirmed_hours', COALESCE(SUM(vsr.paid_hours_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'base_pay', COALESCE(SUM(vsr.total_salary_pay_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'bonus_pay', COALESCE(SUM(vsr.bonus_amount_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'total_payment', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'previous_total_payment', v_yesterday_total,
        'change_percentage', CASE WHEN v_yesterday_total = 0 THEN
            CASE WHEN COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) > 0 THEN 100 ELSE 0 END
            ELSE ROUND((COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) - v_yesterday_total) / v_yesterday_total * 100, 1) END
    ) INTO today_json
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_today_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_today_end;

    -- This Week (CHANGED: removed store_id filter - now company-wide)
    SELECT json_build_object(
        'on_time_rate', CASE WHEN COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL) = 0 THEN 0
            ELSE ROUND(COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL AND vsr.is_late_v2 = false)::numeric /
                COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL)::numeric * 100, 1) END,
        'complete_shifts', COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL),
        'total_confirmed_hours', COALESCE(SUM(vsr.paid_hours_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'base_pay', COALESCE(SUM(vsr.total_salary_pay_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'bonus_pay', COALESCE(SUM(vsr.bonus_amount_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'total_payment', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'previous_total_payment', v_last_week_total,
        'change_percentage', CASE WHEN v_last_week_total = 0 THEN
            CASE WHEN COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) > 0 THEN 100 ELSE 0 END
            ELSE ROUND((COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) - v_last_week_total) / v_last_week_total * 100, 1) END
    ) INTO this_week_json
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_week_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_week_end;

    -- This Month (CHANGED: removed store_id filter - now company-wide)
    SELECT json_build_object(
        'on_time_rate', CASE WHEN COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL) = 0 THEN 0
            ELSE ROUND(COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL AND vsr.is_late_v2 = false)::numeric /
                COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL)::numeric * 100, 1) END,
        'complete_shifts', COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL),
        'total_confirmed_hours', COALESCE(SUM(vsr.paid_hours_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'base_pay', COALESCE(SUM(vsr.total_salary_pay_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'bonus_pay', COALESCE(SUM(vsr.bonus_amount_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'total_payment', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'previous_total_payment', v_last_month_total,
        'change_percentage', CASE WHEN v_last_month_total = 0 THEN
            CASE WHEN COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) > 0 THEN 100 ELSE 0 END
            ELSE ROUND((COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) - v_last_month_total) / v_last_month_total * 100, 1) END
    ) INTO this_month_json
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_month_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_month_end;

    -- Last Month (CHANGED: removed store_id filter - now company-wide)
    SELECT json_build_object(
        'on_time_rate', CASE WHEN COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL) = 0 THEN 0
            ELSE ROUND(COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL AND vsr.is_late_v2 = false)::numeric /
                COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL)::numeric * 100, 1) END,
        'complete_shifts', COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL),
        'total_confirmed_hours', COALESCE(SUM(vsr.paid_hours_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'base_pay', COALESCE(SUM(vsr.total_salary_pay_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'bonus_pay', COALESCE(SUM(vsr.bonus_amount_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'total_payment', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'previous_total_payment', v_two_months_ago_total,
        'change_percentage', CASE WHEN v_two_months_ago_total = 0 THEN
            CASE WHEN COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) > 0 THEN 100 ELSE 0 END
            ELSE ROUND((COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) - v_two_months_ago_total) / v_two_months_ago_total * 100, 1) END
    ) INTO last_month_json
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_last_month_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_last_month_end;

    -- This Year (CHANGED: removed store_id filter - now company-wide)
    SELECT json_build_object(
        'on_time_rate', CASE WHEN COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL) = 0 THEN 0
            ELSE ROUND(COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL AND vsr.is_late_v2 = false)::numeric /
                COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL)::numeric * 100, 1) END,
        'complete_shifts', COUNT(*) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL),
        'total_confirmed_hours', COALESCE(SUM(vsr.paid_hours_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'base_pay', COALESCE(SUM(vsr.total_salary_pay_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'bonus_pay', COALESCE(SUM(vsr.bonus_amount_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'total_payment', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0),
        'previous_total_payment', v_last_year_total,
        'change_percentage', CASE WHEN v_last_year_total = 0 THEN
            CASE WHEN COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) > 0 THEN 100 ELSE 0 END
            ELSE ROUND((COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL), 0) - v_last_year_total) / v_last_year_total * 100, 1) END
    ) INTO this_year_json
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_year_start
      AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_year_end;

    -- Weekly payments (CHANGED: removed store_id filter - now company-wide)
    SELECT json_build_object(
        'w1', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
            WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_week_start
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_week_end), 0),
        'w2', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
            WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_week_start - interval '1 week'
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_week_start), 0),
        'w3', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
            WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_week_start - interval '2 weeks'
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_week_start - interval '1 week'), 0),
        'w4', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
            WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_week_start - interval '3 weeks'
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_week_start - interval '2 weeks'), 0),
        'w5', COALESCE(SUM(vsr.total_pay_with_bonus_v2) FILTER (
            WHERE vsr.confirm_start_time_v2 IS NOT NULL AND vsr.confirm_end_time_v2 IS NOT NULL
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) >= v_week_start - interval '4 weeks'
              AND (vsr.start_time_utc AT TIME ZONE p_timezone) < v_week_start - interval '3 weeks'), 0)
    ) INTO weekly_payments_json
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id AND vsr.company_id = p_company_id
      AND vsr.is_approved = true;

    -- Build final result
    result_json := json_build_object(
        'salary_info', salary_info_json,
        'today', today_json,
        'this_week', this_week_json,
        'this_month', this_month_json,
        'last_month', last_month_json,
        'this_year', this_year_json,
        'weekly_payments', weekly_payments_json,
        'reliability_score', v_reliability_score_json
    );

    RETURN result_json;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'error', true,
            'error_code', SQLSTATE,
            'error_message', SQLERRM
        );
END;
$function$;

COMMENT ON FUNCTION user_shift_stats IS 'Get user shift statistics for Stats tab. Returns company-wide salary data (store_id parameter kept for backwards compatibility but not used for filtering).';
