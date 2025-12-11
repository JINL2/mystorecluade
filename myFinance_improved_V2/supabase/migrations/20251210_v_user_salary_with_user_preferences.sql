-- Update v_user_salary view to include user_preferences.clicked_at for better activity tracking
-- user_preferences tracks real-time app usage (feature clicks)
-- Filter by company_id AND get latest clicked_at

CREATE OR REPLACE VIEW v_user_salary AS
SELECT
    us.salary_id,
    us.user_id,
    u.first_name,
    u.last_name,
    concat(u.last_name, ' ', u.first_name) AS full_name,
    u.profile_image,
    us.company_id,
    us.salary_amount,
    us.salary_type,
    us.bonus_amount,
    ur.role_id,
    r.role_name,
    ct.currency_name,
    ct.currency_code,
    ct.symbol,
    us.created_at,
    us.created_at_utc,
    -- Last activity timestamp calculated from multiple sources including user_preferences
    NULLIF(
        GREATEST(
            COALESCE(la.last_shift, '1970-01-01'::timestamp),
            COALESCE(la.last_journal, '1970-01-01'::timestamp),
            COALESCE(la.last_cash, '1970-01-01'::timestamp),
            COALESCE(la.last_app_usage, '1970-01-01'::timestamp)
        ),
        '1970-01-01'::timestamp
    ) AS last_activity_at
FROM user_salaries us
JOIN users u ON u.user_id = us.user_id
-- Fix: Join roles table and filter by BOTH user_id AND company_id
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
-- Calculate last activity from multiple tables including user_preferences (filtered by company_id)
LEFT JOIN LATERAL (
    SELECT
        (SELECT MAX(sr.created_at) FROM shift_requests sr WHERE sr.user_id = us.user_id) AS last_shift,
        (SELECT MAX(je.created_at) FROM journal_entries je WHERE je.created_by = us.user_id) AS last_journal,
        (SELECT MAX(ca.created_at) FROM cash_amount_entries ca WHERE ca.created_by = us.user_id) AS last_cash,
        (SELECT MAX(up.clicked_at) FROM user_preferences up WHERE up.user_id = us.user_id AND up.company_id = us.company_id) AS last_app_usage
) la ON true;

COMMENT ON VIEW v_user_salary IS 'Employee salary view with last_activity_at from user_preferences (app usage tracking). Updated 2025-12-10.';
