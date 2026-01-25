-- =====================================================
-- Add owner notification when employee limit is reached
-- =====================================================
-- When someone tries to join a company that has reached
-- its employee limit, send a notification to the owner
-- so they know to upgrade their subscription.

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
    -- For notification
    v_requester_name TEXT;
    v_company_name TEXT;
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
    -- ★ Check employee limit before joining
    -- =====================================================
    -- Get company's subscription plan
    SELECT c.inherited_plan_id, c.company_name
    INTO v_plan_id, v_company_name
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
        -- =====================================================
        -- ★ NEW: Send notification to owner (with i18n)
        -- =====================================================
        DECLARE
            v_owner_lang TEXT;
            v_title TEXT;
            v_body TEXT;
        BEGIN
            -- Get requester's name for notification (with fallback to 'Someone')
            SELECT COALESCE(
                NULLIF(TRIM(CONCAT(u.first_name, ' ', u.last_name)), ''),
                u.email,
                'Someone'
            )
            INTO v_requester_name
            FROM users u
            WHERE u.user_id = p_user_id;

            -- ★ FIX: If user not found, default to 'Someone'
            IF v_requester_name IS NULL THEN
                v_requester_name := 'Someone';
            END IF;

            -- Get owner's language preference (default: en)
            SELECT COALESCE(l.language_code, 'en')
            INTO v_owner_lang
            FROM users u
            LEFT JOIN languages l ON l.language_id = u.user_language
            WHERE u.user_id = v_owner_id;

            -- ★ FIX: If owner not found, default to 'en'
            IF v_owner_lang IS NULL THEN
                v_owner_lang := 'en';
            END IF;

            -- Set title and body based on language
            CASE v_owner_lang
                WHEN 'ko' THEN
                    v_title := '직원 한도 초과';
                    v_body := v_requester_name || '님이 ' || COALESCE(v_company_name, '회사') ||
                        '에 가입을 시도했으나 직원 한도(' || v_current_employee_count || '/' || v_max_employees ||
                        ')에 도달했습니다. 플랜을 업그레이드하여 더 많은 직원을 추가하세요.';
                WHEN 'vi' THEN
                    v_title := 'Đã đạt giới hạn nhân viên';
                    v_body := v_requester_name || ' đã cố gắng tham gia ' || COALESCE(v_company_name, 'công ty') ||
                        ' nhưng đã đạt giới hạn nhân viên (' || v_current_employee_count || '/' || v_max_employees ||
                        '). Nâng cấp gói để thêm nhân viên.';
                ELSE  -- 'en' or default
                    v_title := 'Employee Limit Reached';
                    v_body := v_requester_name || ' tried to join ' || COALESCE(v_company_name, 'your company') ||
                        ' but the employee limit (' || v_current_employee_count || '/' || v_max_employees ||
                        ') has been reached. Upgrade your plan to add more employees.';
            END CASE;

            -- Send notification directly to owner (bypasses all permissions)
            PERFORM send_notification_to_user(
                v_owner_id,
                v_title,
                v_body,
                'subscription',
                jsonb_build_object(
                    'type', 'employee_limit_reached',
                    'company_id', v_company_id,
                    'company_name', v_company_name,
                    'requester_id', p_user_id,
                    'requester_name', v_requester_name,
                    'current_employees', v_current_employee_count,
                    'max_employees', v_max_employees,
                    'action_url', '/subscription'
                ),
                '/subscription',  -- action_url - deep link to subscription page
                NULL,             -- image_url
                NULL              -- scheduled_time (send immediately)
            );
        END;
        -- =====================================================

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
'Join a company or store by invite code.
Features:
- Employee limit checking based on subscription plan
- Soft Delete restoration (2026 Best Practice)
- Owner notification when limit is reached (sent directly, bypasses permissions)
- NULL safety for requester name and owner language
Error codes: EMPLOYEE_LIMIT_REACHED, ALREADY_MEMBER, OWNER_CANNOT_JOIN, BUSINESS_NOT_FOUND';
