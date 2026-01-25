-- Add employee_count, total_store_count, total_employee_count to get_user_companies_with_salary
-- This enables subscription limit checking in the Flutter app
--
-- Changes:
-- 1. Added 'total_store_count' - Total stores across all user's companies
-- 2. Added 'total_employee_count' - Total employees across all user's companies
-- 3. Added 'employee_count' per company - Employees in each company

CREATE OR REPLACE FUNCTION public.get_user_companies_with_salary(p_user_id uuid)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  result json;
BEGIN
  WITH distinct_user_companies AS (
    SELECT DISTINCT ON (uc.user_id, uc.company_id)
      uc.user_id,
      uc.company_id,
      uc.is_deleted
    FROM user_companies uc
    WHERE uc.user_id = p_user_id
    ORDER BY uc.user_id, uc.company_id, uc.created_at DESC
  ),
  distinct_user_stores AS (
    SELECT DISTINCT ON (us.user_id, us.store_id)
      us.user_id,
      us.store_id,
      us.is_deleted
    FROM user_stores us
    WHERE us.user_id = p_user_id
    ORDER BY us.user_id, us.store_id, us.created_at DESC
  )
  SELECT json_build_object(
    'user_id', u.user_id,
    'profile_image', u.profile_image::text,
    'user_first_name', u.first_name::text,
    'user_last_name', u.last_name::text,
    'company_count', (
      SELECT COUNT(DISTINCT c.company_id)
      FROM distinct_user_companies duc
      JOIN companies c ON c.company_id = duc.company_id
      WHERE duc.user_id = p_user_id
        AND duc.is_deleted = false
        AND c.is_deleted = false
    ),
    -- NEW: Total store count across all companies
    'total_store_count', (
      SELECT COUNT(DISTINCT s.store_id)
      FROM distinct_user_stores dus
      JOIN stores s ON s.store_id = dus.store_id
      WHERE dus.user_id = p_user_id
        AND dus.is_deleted = false
        AND s.is_deleted = false
    ),
    -- NEW: Total employee count across all companies
    'total_employee_count', (
      SELECT COUNT(DISTINCT ur.user_id)
      FROM distinct_user_companies duc
      JOIN companies c ON c.company_id = duc.company_id
      JOIN roles r ON r.company_id = c.company_id
      JOIN user_roles ur ON ur.role_id = r.role_id
      WHERE duc.user_id = p_user_id
        AND duc.is_deleted = false
        AND c.is_deleted = false
        AND ur.is_deleted = false
    ),
    'companies', COALESCE(
      (
        SELECT json_agg(company_info)
        FROM (
          SELECT jsonb_build_object(
            'company_id', c.company_id,
            'company_name', c.company_name::text,
            'company_code', c.company_code::text,
            -- Salary info for this user in this company
            'salary_type', (
              SELECT us.salary_type
              FROM user_salaries us
              WHERE us.user_id = p_user_id
                AND us.company_id = c.company_id
              LIMIT 1
            ),
            'currency_code', (
              SELECT ct.currency_code
              FROM user_salaries us
              JOIN currency_types ct ON ct.currency_id = us.currency_id
              WHERE us.user_id = p_user_id
                AND us.company_id = c.company_id
              LIMIT 1
            ),
            'currency_symbol', (
              SELECT ct.symbol
              FROM user_salaries us
              JOIN currency_types ct ON ct.currency_id = us.currency_id
              WHERE us.user_id = p_user_id
                AND us.company_id = c.company_id
              LIMIT 1
            ),
            -- Subscription plan info
            'subscription', CASE
              WHEN c.inherited_plan_id IS NOT NULL THEN (
                SELECT jsonb_build_object(
                  'plan_id', sp.plan_id,
                  'plan_name', sp.plan_name,
                  'display_name', sp.display_name,
                  'plan_type', sp.plan_type,
                  'max_companies', sp.max_companies,
                  'max_stores', sp.max_stores,
                  'max_employees', sp.max_employees,
                  'ai_daily_limit', sp.ai_daily_limit,
                  'features', sp.features,
                  'price_monthly', sp.price_monthly
                )
                FROM subscription_plans sp
                WHERE sp.plan_id = c.inherited_plan_id
              )
              ELSE (
                -- Default: Free plan
                SELECT jsonb_build_object(
                  'plan_id', sp.plan_id,
                  'plan_name', sp.plan_name,
                  'display_name', sp.display_name,
                  'plan_type', sp.plan_type,
                  'max_companies', sp.max_companies,
                  'max_stores', sp.max_stores,
                  'max_employees', sp.max_employees,
                  'ai_daily_limit', sp.ai_daily_limit,
                  'features', sp.features,
                  'price_monthly', sp.price_monthly
                )
                FROM subscription_plans sp
                WHERE sp.plan_name = 'free'
                LIMIT 1
              )
            END,
            'role', (
              SELECT jsonb_build_object(
                'role_id', r.role_id,
                'role_name', r.role_name::text,
                'permissions', (
                  CASE
                    WHEN r.role_type = 'owner' THEN (
                      SELECT json_agg(f.feature_id)
                      FROM features f
                    )
                    ELSE (
                      SELECT COALESCE(json_agg(rp.feature_id), '[]'::json)
                      FROM role_permissions rp
                      WHERE rp.role_id = r.role_id
                    )
                  END
                )
              )
              FROM roles r
              JOIN user_roles ur ON ur.role_id = r.role_id
              WHERE r.company_id = c.company_id
                AND ur.user_id = p_user_id
                AND ur.is_deleted = false
              LIMIT 1
            ),
            'store_count', (
              SELECT COUNT(DISTINCT s.store_id)
              FROM distinct_user_stores dus
              JOIN stores s ON s.store_id = dus.store_id
              WHERE dus.user_id = p_user_id
                AND dus.is_deleted = false
                AND s.is_deleted = false
                AND s.company_id = c.company_id
            ),
            -- NEW: Employee count for this company
            'employee_count', (
              SELECT COUNT(DISTINCT ur.user_id)
              FROM roles r
              JOIN user_roles ur ON ur.role_id = r.role_id
              WHERE r.company_id = c.company_id
                AND ur.is_deleted = false
            ),
            'stores', (
              SELECT COALESCE(json_agg(
                jsonb_build_object(
                  'store_id', s.store_id,
                  'store_name', s.store_name::text,
                  'store_code', s.store_code::text,
                  'store_phone', s.store_phone::text
                ) ORDER BY s.store_name
              ), '[]'::json)
              FROM distinct_user_stores dus
              JOIN stores s ON s.store_id = dus.store_id
              WHERE dus.user_id = p_user_id
                AND dus.is_deleted = false
                AND s.is_deleted = false
                AND s.company_id = c.company_id
            )
          ) AS company_info
          FROM distinct_user_companies duc
          JOIN companies c ON c.company_id = duc.company_id
          WHERE duc.user_id = p_user_id
            AND duc.is_deleted = false
            AND c.is_deleted = false
          ORDER BY c.created_at
        ) sorted_companies
      ),
      '[]'::json
    )
  )
  INTO result
  FROM users u
  WHERE u.user_id = p_user_id
    AND u.is_deleted = false;

  RETURN result;
END;
$function$;
