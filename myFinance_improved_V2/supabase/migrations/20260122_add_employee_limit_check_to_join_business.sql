-- =====================================================
-- Update join_business_by_code to check employee limits
-- =====================================================
-- This migration adds employee subscription limit checking
-- to prevent exceeding the company's plan limits when
-- new employees join via invite code.
--
-- Error code: EMPLOYEE_LIMIT_REACHED
-- Returned when company has reached max_employees limit

CREATE OR REPLACE FUNCTION public.join_business_by_code(p_user_id uuid, p_business_code text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_business_info JSON;
    v_business_type TEXT;
    v_company_id UUID;
    v_business_id UUID;
    v_business_name TEXT;
    v_owner_id UUID;
    v_employee_role_id UUID;
    v_existing_link_count INT;
    v_features_for_employee JSON[];
    v_permission_record RECORD;
    v_stores_registered INT;
    -- Employee limit check variables
    v_plan_id UUID;
    v_max_employees INT;
    v_current_employee_count INT;
BEGIN
    -- Input validation
    IF p_user_id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'User ID is required',
            'error_code', 'INVALID_USER'
        );
    END IF;

    -- First, find the business by code
    v_business_info := find_business_by_code(p_business_code);

    -- Check if business was found
    IF NOT (v_business_info->>'success')::boolean THEN
        RETURN v_business_info;
    END IF;

    -- Extract business information
    v_business_type := v_business_info->>'business_type';
    v_business_id := (v_business_info->>'business_id')::UUID;
    v_business_name := v_business_info->>'business_name';
    v_owner_id := (v_business_info->>'owner_id')::UUID;

    IF v_business_type = 'company' THEN
        v_company_id := v_business_id;
    ELSE
        v_company_id := (v_business_info->>'company_id')::UUID;
    END IF;

    IF p_user_id = v_owner_id THEN
        RETURN json_build_object(
            'success', false,
            'error', 'You cannot join your own business as an employee',
            'error_code', 'OWNER_CANNOT_JOIN'
        );
    END IF;

    SELECT COUNT(*) INTO v_existing_link_count
    FROM user_companies uc
    WHERE uc.user_id = p_user_id
      AND uc.company_id = v_company_id
      AND uc.is_deleted = false;

    IF v_existing_link_count > 0 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'You are already a member of this company',
            'error_code', 'ALREADY_MEMBER'
        );
    END IF;

    -- =====================================================
    -- ★ NEW: Check employee limit before joining
    -- =====================================================
    -- Get company's subscription plan
    SELECT c.inherited_plan_id
    INTO v_plan_id
    FROM companies c
    WHERE c.company_id = v_company_id
      AND c.is_deleted = false;

    -- Default to Free plan if no plan found
    IF v_plan_id IS NULL THEN
        SELECT sp.plan_id INTO v_plan_id
        FROM subscription_plans sp
        WHERE sp.plan_name = 'free'
        LIMIT 1;
    END IF;

    -- Get max employees for the plan
    SELECT sp.max_employees
    INTO v_max_employees
    FROM subscription_plans sp
    WHERE sp.plan_id = v_plan_id;

    -- Count current employees in the company
    SELECT COUNT(DISTINCT ur.user_id)
    INTO v_current_employee_count
    FROM user_roles ur
    JOIN roles r ON r.role_id = ur.role_id
    WHERE r.company_id = v_company_id
      AND ur.is_deleted = false;

    -- Check if limit is reached (NULL = unlimited)
    IF v_max_employees IS NOT NULL AND v_current_employee_count >= v_max_employees THEN
        RETURN json_build_object(
            'success', false,
            'error', 'This company has reached its employee limit. Please ask the owner to upgrade their subscription.',
            'error_code', 'EMPLOYEE_LIMIT_REACHED',
            'max_employees', v_max_employees,
            'current_employees', v_current_employee_count
        );
    END IF;
    -- =====================================================
    -- End of employee limit check
    -- =====================================================

    BEGIN
        -- =====================================================
        -- ★ 2026 Best Practice: Restore soft-deleted record OR Insert new
        -- =====================================================
        -- Check if user was previously a member (soft-deleted)
        IF EXISTS (
            SELECT 1 FROM user_companies uc
            WHERE uc.user_id = p_user_id
              AND uc.company_id = v_company_id
              AND uc.is_deleted = true
        ) THEN
            -- Restore the soft-deleted record
            UPDATE user_companies
            SET is_deleted = false,
                deleted_at = NULL,
                deleted_at_utc = NULL,
                updated_at = NOW(),
                updated_at_utc = NOW()
            WHERE user_id = p_user_id
              AND company_id = v_company_id
              AND is_deleted = true;
        ELSE
            -- Insert new record
            INSERT INTO user_companies (user_id, company_id)
            VALUES (p_user_id, v_company_id);
        END IF;

        IF v_business_type = 'company' THEN
            INSERT INTO user_stores (user_id, store_id)
            SELECT p_user_id, store_id
            FROM stores
            WHERE company_id = v_company_id
              AND is_deleted = false
              AND NOT EXISTS (
                  SELECT 1 FROM user_stores us
                  WHERE us.user_id = p_user_id
                    AND us.store_id = stores.store_id
                    AND us.is_deleted = false
              );

            GET DIAGNOSTICS v_stores_registered = ROW_COUNT;

        ELSIF v_business_type = 'store' THEN
            IF NOT EXISTS (
                SELECT 1 FROM user_stores us
                WHERE us.user_id = p_user_id
                  AND us.store_id = v_business_id
                  AND us.is_deleted = false
            ) THEN
                INSERT INTO user_stores (user_id, store_id)
                VALUES (p_user_id, v_business_id);
                v_stores_registered := 1;
            ELSE
                v_stores_registered := 0;
            END IF;
        END IF;

        SELECT role_id INTO v_employee_role_id
        FROM roles r
        WHERE r.company_id = v_company_id
          AND r.role_name = 'Employee'
          AND r.role_type = 'employee';

        IF v_employee_role_id IS NULL THEN
            INSERT INTO roles (
                role_name,
                role_type,
                company_id,
                description,
                is_deletable
            ) VALUES (
                'Employee',
                'employee',
                v_company_id,
                'Regular employee with basic permissions',
                false
            )
            RETURNING role_id INTO v_employee_role_id;

            INSERT INTO role_permissions (role_id, feature_id)
            SELECT
                v_employee_role_id,
                f.feature_id
            FROM features f
            WHERE f.feature_name IN (
                'Attendance',
                'Timetable',
                'Cash Ending',
                'Journal Input',
                'Transaction History',
                'My Page'
            );
        END IF;

        IF NOT EXISTS (
            SELECT 1 FROM user_roles ur
            WHERE ur.user_id = p_user_id
              AND ur.role_id = v_employee_role_id
              AND ur.is_deleted = false
        ) THEN
            INSERT INTO user_roles (user_id, role_id)
            VALUES (p_user_id, v_employee_role_id);
        END IF;

        RETURN json_build_object(
            'success', true,
            'message', CASE
                WHEN v_business_type = 'company' THEN 'Successfully joined company with all stores'
                ELSE 'Successfully joined specific store'
            END,
            'business_type', v_business_type,
            'business_id', v_business_id,
            'business_name', v_business_name,
            'company_id', v_company_id,
            'company_name', CASE
                WHEN v_business_type = 'company' THEN v_business_name
                ELSE v_business_info->>'company_name'
            END,
            'stores_registered', v_stores_registered,
            'role_assigned', 'Employee',
            'role_id', v_employee_role_id,
            'joined_at', NOW()
        );

    EXCEPTION
        WHEN unique_violation THEN
            RETURN json_build_object(
                'success', false,
                'error', 'You are already a member of this company or a conflict occurred',
                'error_code', 'CONFLICT'
            );
        WHEN OTHERS THEN
            RETURN json_build_object(
                'success', false,
                'error', 'Failed to join business due to a database error',
                'error_code', 'DATABASE_ERROR',
                'error_detail', SQLERRM
            );
    END;

END;
$function$;

-- Add comment for documentation
COMMENT ON FUNCTION public.join_business_by_code(uuid, text) IS
'Join a company or store by invite code. Now includes employee limit checking based on the company''s subscription plan. Returns EMPLOYEE_LIMIT_REACHED error if the company has reached its plan limit.';
