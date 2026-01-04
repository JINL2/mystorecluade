-- Migration: Add updated_at, edited_by, edited_by_name to v_user_salary view
-- Purpose: Track salary changes with timestamp and editor information
-- Date: 2026-01-04
-- IMPORTANT: New columns are added at the END to preserve existing column order

CREATE OR REPLACE VIEW v_user_salary AS
SELECT
    -- 1-8: Basic user info (KEEP ORDER)
    us.salary_id,
    us.user_id,
    u.first_name,
    u.last_name,
    concat(u.last_name, ' ', u.first_name) AS full_name,
    u.email,
    u.profile_image,
    us.company_id,
    -- 9-11: Salary info (KEEP ORDER)
    us.salary_amount,
    us.salary_type,
    us.bonus_amount,
    -- 12-13: Role info (KEEP ORDER)
    ur.role_id,
    r.role_name,
    -- 14-16: Currency info (KEEP ORDER)
    ct.currency_name,
    ct.currency_code,
    ct.symbol,
    -- 17-18: Created timestamps (KEEP ORDER)
    us.created_at,
    us.created_at_utc,
    -- 19-20: Bank info (KEEP ORDER)
    uba.user_bank_name AS bank_name,
    uba.user_account_number AS bank_account_number,
    -- 21: Activity tracking (KEEP ORDER)
    NULLIF(
        GREATEST(
            COALESCE(la.last_shift, '1970-01-01 00:00:00'::timestamp without time zone)::timestamp with time zone,
            COALESCE(la.last_journal, '1970-01-01 00:00:00'::timestamp without time zone)::timestamp with time zone,
            COALESCE(la.last_cash, '1970-01-01 00:00:00'::timestamp without time zone)::timestamp with time zone,
            COALESCE(la.last_app_usage, '1970-01-01 00:00:00'::timestamp without time zone::timestamp with time zone)
        ),
        '1970-01-01 00:00:00'::timestamp without time zone
    ) AS last_activity_at,
    -- 22-32: Work schedule template (KEEP ORDER)
    us.work_schedule_template_id,
    wst.template_name AS work_schedule_template_name,
    wst.work_start_time,
    wst.work_end_time,
    wst.monday AS work_monday,
    wst.tuesday AS work_tuesday,
    wst.wednesday AS work_wednesday,
    wst.thursday AS work_thursday,
    wst.friday AS work_friday,
    wst.saturday AS work_saturday,
    wst.sunday AS work_sunday,
    -- 33-36: NEW COLUMNS (added at the end)
    us.updated_at,
    us.updated_at_utc,
    us.edited_by,
    concat(editor.last_name, ' ', editor.first_name) AS edited_by_name
FROM user_salaries us
JOIN users u ON u.user_id = us.user_id
JOIN user_companies uc ON uc.user_id = us.user_id AND uc.company_id = us.company_id AND uc.is_deleted = false
LEFT JOIN work_schedule_templates wst ON wst.template_id = us.work_schedule_template_id
-- NEW: Join to get editor's name
LEFT JOIN users editor ON editor.user_id = us.edited_by
LEFT JOIN LATERAL (
    SELECT
        user_roles.user_role_id,
        user_roles.user_id,
        user_roles.role_id,
        user_roles.created_at,
        user_roles.updated_at,
        user_roles.is_deleted,
        user_roles.deleted_at
    FROM user_roles
    JOIN roles ON roles.role_id = user_roles.role_id
    WHERE user_roles.user_id = u.user_id
      AND user_roles.is_deleted = false
      AND roles.company_id = us.company_id
    ORDER BY user_roles.created_at DESC
    LIMIT 1
) ur ON true
LEFT JOIN roles r ON r.role_id = ur.role_id
LEFT JOIN currency_types ct ON ct.currency_id = us.currency_id
LEFT JOIN LATERAL (
    SELECT
        users_bank_account.user_bank_name,
        users_bank_account.user_account_number
    FROM users_bank_account
    WHERE users_bank_account.user_id = us.user_id
      AND (users_bank_account.company_id = us.company_id OR users_bank_account.company_id IS NULL)
    ORDER BY (
        CASE
            WHEN users_bank_account.company_id = us.company_id THEN 0
            ELSE 1
        END
    ), users_bank_account.updated_at DESC NULLS LAST
    LIMIT 1
) uba ON true
LEFT JOIN LATERAL (
    SELECT
        (SELECT max(sr.created_at) FROM shift_requests sr WHERE sr.user_id = us.user_id) AS last_shift,
        (SELECT max(je.created_at) FROM journal_entries je WHERE je.created_by = us.user_id) AS last_journal,
        (SELECT max(ca.created_at) FROM cash_amount_entries ca WHERE ca.created_by = us.user_id) AS last_cash,
        (SELECT max(up.clicked_at) FROM user_preferences up WHERE up.user_id = us.user_id AND up.company_id = us.company_id) AS last_app_usage
) la ON true;
