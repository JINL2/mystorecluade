-- ============================================================================
-- EXECUTE THIS SQL IN SUPABASE DASHBOARD SQL EDITOR
-- ============================================================================
-- This combines both migrations for subscription limit functionality:
-- 1. check_subscription_limit RPC (fresh limit checking)
-- 2. get_user_companies_with_salary RPC update (add employee_count fields)
--
-- UPDATE (2024-01): Company count now only counts OWNED companies (role_name = 'Owner')
-- This allows users to JOIN unlimited companies as employees
-- ============================================================================

-- ============================================================================
-- PART 1: check_subscription_limit RPC
-- ============================================================================
-- CHANGE: 'company' check now only counts companies where user is OWNER
-- This allows:
--   - Free users to JOIN unlimited companies as employee
--   - Free users to CREATE only 1 company as owner
-- ============================================================================

CREATE OR REPLACE FUNCTION public.check_subscription_limit(
  p_user_id UUID,
  p_check_type TEXT,
  p_company_id UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_plan_name TEXT;
  v_max_limit INT;
  v_current_count INT;
  v_can_add BOOLEAN;
  v_plan_id UUID;
BEGIN
  -- 1. Get user's current plan
  IF p_company_id IS NOT NULL THEN
    SELECT c.inherited_plan_id
    INTO v_plan_id
    FROM companies c
    WHERE c.company_id = p_company_id
      AND c.is_deleted = false;
  ELSE
    SELECT c.inherited_plan_id
    INTO v_plan_id
    FROM user_companies uc
    JOIN companies c ON c.company_id = uc.company_id
    WHERE uc.user_id = p_user_id
      AND uc.is_deleted = false
      AND c.is_deleted = false
    ORDER BY uc.created_at
    LIMIT 1;
  END IF;

  -- Default to Free plan if no plan found
  IF v_plan_id IS NULL THEN
    SELECT sp.plan_id INTO v_plan_id
    FROM subscription_plans sp
    WHERE sp.plan_name = 'free'
    LIMIT 1;
  END IF;

  -- 2. Calculate max_limit and current_count based on check_type
  CASE p_check_type
    WHEN 'company' THEN
      SELECT sp.plan_name, sp.max_companies
      INTO v_plan_name, v_max_limit
      FROM subscription_plans sp
      WHERE sp.plan_id = v_plan_id;

      -- ✅ CHANGED: Only count companies where user is OWNER
      -- This allows users to JOIN unlimited companies as employees
      SELECT COUNT(DISTINCT r.company_id)
      INTO v_current_count
      FROM user_roles ur
      JOIN roles r ON r.role_id = ur.role_id
      JOIN companies c ON c.company_id = r.company_id
      WHERE ur.user_id = p_user_id
        AND ur.is_deleted = false
        AND c.is_deleted = false
        AND r.role_name = 'Owner';

    WHEN 'store' THEN
      SELECT sp.plan_name, sp.max_stores
      INTO v_plan_name, v_max_limit
      FROM subscription_plans sp
      WHERE sp.plan_id = v_plan_id;

      IF p_company_id IS NOT NULL THEN
        SELECT COUNT(DISTINCT s.store_id)
        INTO v_current_count
        FROM user_stores us
        JOIN stores s ON s.store_id = us.store_id
        WHERE us.user_id = p_user_id
          AND us.is_deleted = false
          AND s.is_deleted = false
          AND s.company_id = p_company_id;
      ELSE
        SELECT COUNT(DISTINCT s.store_id)
        INTO v_current_count
        FROM user_stores us
        JOIN stores s ON s.store_id = us.store_id
        WHERE us.user_id = p_user_id
          AND us.is_deleted = false
          AND s.is_deleted = false;
      END IF;

    -- NOTE: roles table does NOT have is_deleted column
    WHEN 'employee' THEN
      SELECT sp.plan_name, sp.max_employees
      INTO v_plan_name, v_max_limit
      FROM subscription_plans sp
      WHERE sp.plan_id = v_plan_id;

      IF p_company_id IS NOT NULL THEN
        SELECT COUNT(DISTINCT ur.user_id)
        INTO v_current_count
        FROM user_roles ur
        JOIN roles r ON r.role_id = ur.role_id
        WHERE r.company_id = p_company_id
          AND ur.is_deleted = false;
      ELSE
        SELECT COUNT(DISTINCT ur.user_id)
        INTO v_current_count
        FROM user_companies uc
        JOIN companies c ON c.company_id = uc.company_id
        JOIN roles r ON r.company_id = c.company_id
        JOIN user_roles ur ON ur.role_id = r.role_id
        WHERE uc.user_id = p_user_id
          AND uc.is_deleted = false
          AND c.is_deleted = false
          AND ur.is_deleted = false;
      END IF;

    ELSE
      RETURN jsonb_build_object(
        'error', 'Invalid check_type. Use: company, store, or employee',
        'can_add', false
      );
  END CASE;

  -- 3. Determine if can add (NULL max_limit = unlimited)
  IF v_max_limit IS NULL THEN
    v_can_add := true;
  ELSE
    v_can_add := v_current_count < v_max_limit;
  END IF;

  -- 4. Return result
  RETURN jsonb_build_object(
    'can_add', v_can_add,
    'plan_name', COALESCE(v_plan_name, 'free'),
    'max_limit', v_max_limit,
    'current_count', v_current_count,
    'check_type', p_check_type
  );

END;
$function$;

COMMENT ON FUNCTION public.check_subscription_limit(UUID, TEXT, UUID) IS
'Subscription plan limit check. check_type: company/store/employee.
For company: only counts OWNED companies (allows unlimited JOIN as employee).
Returns: {can_add, plan_name, max_limit, current_count, check_type}';


-- ============================================================================
-- PART 2: get_user_companies_with_salary RPC (add employee_count fields)
-- ============================================================================
-- CHANGE: company_count now only counts OWNED companies
-- ============================================================================

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
    -- ✅ CHANGED: Only count companies where user is OWNER
    'company_count', (
      SELECT COUNT(DISTINCT r.company_id)
      FROM user_roles ur
      JOIN roles r ON r.role_id = ur.role_id
      JOIN companies c ON c.company_id = r.company_id
      WHERE ur.user_id = p_user_id
        AND ur.is_deleted = false
        AND c.is_deleted = false
        AND r.role_name = 'Owner'
    ),
    -- Total store count across all companies (unchanged - shows all stores user has access to)
    'total_store_count', (
      SELECT COUNT(DISTINCT s.store_id)
      FROM distinct_user_stores dus
      JOIN stores s ON s.store_id = dus.store_id
      WHERE dus.user_id = p_user_id
        AND dus.is_deleted = false
        AND s.is_deleted = false
    ),
    -- Total employee count across all companies (unchanged)
    -- NOTE: roles table does NOT have is_deleted column
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
            -- Employee count for this company (unchanged)
            -- NOTE: roles table does NOT have is_deleted column
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

-- ============================================================================
-- VERIFICATION: Test the functions after execution
-- ============================================================================
-- Run these queries to verify the changes:
--
-- 1. Test check_subscription_limit (should now count only OWNED companies):
-- SELECT check_subscription_limit('YOUR_USER_ID'::uuid, 'company', NULL);
--
-- 2. Compare: All companies vs Owned companies
-- SELECT
--   (SELECT COUNT(DISTINCT c.company_id)
--    FROM user_companies uc
--    JOIN companies c ON c.company_id = uc.company_id
--    WHERE uc.user_id = 'YOUR_USER_ID' AND uc.is_deleted = false AND c.is_deleted = false) as all_companies,
--   (SELECT COUNT(DISTINCT r.company_id)
--    FROM user_roles ur
--    JOIN roles r ON r.role_id = ur.role_id
--    JOIN companies c ON c.company_id = r.company_id
--    WHERE ur.user_id = 'YOUR_USER_ID' AND ur.is_deleted = false AND c.is_deleted = false AND r.role_name = 'Owner') as owned_companies;
--
-- 3. Test get_user_companies_with_salary returns correct company_count:
-- SELECT get_user_companies_with_salary('YOUR_USER_ID'::uuid);
-- ============================================================================
