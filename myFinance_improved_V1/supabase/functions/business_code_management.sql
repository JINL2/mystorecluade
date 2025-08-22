-- ============================================================================
-- Business Code Management RPC Functions
-- Efficient database operations for business code lookup and joining workflow
-- ============================================================================

-- ============================================================================
-- Function 1: find_business_by_code
-- Purpose: Efficiently find a company or store by business code
-- Returns: Business information with validation status
-- ============================================================================

CREATE OR REPLACE FUNCTION find_business_by_code(
    p_business_code TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_result JSON;
    v_company_record RECORD;
    v_store_record RECORD;
    v_normalized_code TEXT;
BEGIN
    -- Input validation
    IF p_business_code IS NULL OR LENGTH(TRIM(p_business_code)) = 0 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Business code is required',
            'error_code', 'INVALID_INPUT'
        );
    END IF;

    -- Normalize the business code (uppercase, trim)
    v_normalized_code := UPPER(TRIM(p_business_code));
    
    -- Validate business code format (6-12 characters)
    IF LENGTH(v_normalized_code) < 6 OR LENGTH(v_normalized_code) > 12 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Business code must be between 6-12 characters',
            'error_code', 'INVALID_FORMAT'
        );
    END IF;

    -- First try to find a company with this code
    SELECT 
        c.company_id,
        c.company_name,
        c.company_code,
        c.company_type_id,
        c.owner_id,
        c.base_currency_id,
        ct.type_name as company_type_name,
        cur.currency_name,
        cur.currency_code,
        cur.symbol as currency_symbol,
        c.created_at
    INTO v_company_record
    FROM companies c
    LEFT JOIN company_types ct ON c.company_type_id = ct.company_type_id
    LEFT JOIN currency_types cur ON c.base_currency_id = cur.currency_id
    WHERE c.company_code = v_normalized_code
      AND c.is_deleted = false;

    -- If company found, return company information
    IF FOUND THEN
        RETURN json_build_object(
            'success', true,
            'business_type', 'company',
            'business_id', v_company_record.company_id,
            'business_name', v_company_record.company_name,
            'business_code', v_company_record.company_code,
            'company_type_id', v_company_record.company_type_id,
            'company_type_name', v_company_record.company_type_name,
            'owner_id', v_company_record.owner_id,
            'base_currency_id', v_company_record.base_currency_id,
            'currency_name', v_company_record.currency_name,
            'currency_code', v_company_record.currency_code,
            'currency_symbol', v_company_record.currency_symbol,
            'created_at', v_company_record.created_at
        );
    END IF;

    -- If no company found, try to find a store with this code
    SELECT 
        s.store_id,
        s.store_name,
        s.store_code,
        s.store_address,
        s.store_phone,
        s.company_id,
        c.company_name,
        c.owner_id,
        s.created_at
    INTO v_store_record
    FROM stores s
    INNER JOIN companies c ON s.company_id = c.company_id
    WHERE s.store_code = v_normalized_code
      AND s.is_deleted = false
      AND c.is_deleted = false;

    -- If store found, return store information
    IF FOUND THEN
        RETURN json_build_object(
            'success', true,
            'business_type', 'store',
            'business_id', v_store_record.store_id,
            'business_name', v_store_record.store_name,
            'business_code', v_store_record.store_code,
            'store_address', v_store_record.store_address,
            'store_phone', v_store_record.store_phone,
            'company_id', v_store_record.company_id,
            'company_name', v_store_record.company_name,
            'owner_id', v_store_record.owner_id,
            'created_at', v_store_record.created_at
        );
    END IF;

    -- No business found with this code
    RETURN json_build_object(
        'success', false,
        'error', 'Invalid business code. Please check and try again.',
        'error_code', 'NOT_FOUND'
    );

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'An unexpected error occurred',
            'error_code', 'INTERNAL_ERROR',
            'error_detail', SQLERRM
        );
END;
$$;

-- ============================================================================
-- Function 2: join_business_by_code  
-- Purpose: Join a user to a business (company or store) using business code
-- Returns: Success status and joined business information
-- ============================================================================

CREATE OR REPLACE FUNCTION join_business_by_code(
    p_user_id UUID,
    p_business_code TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
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
        RETURN v_business_info; -- Return the same error from find function
    END IF;

    -- Extract business information
    v_business_type := v_business_info->>'business_type';
    v_business_id := (v_business_info->>'business_id')::UUID;
    v_business_name := v_business_info->>'business_name';
    v_owner_id := (v_business_info->>'owner_id')::UUID;
    
    -- Set company_id based on business type
    IF v_business_type = 'company' THEN
        v_company_id := v_business_id;
    ELSE
        v_company_id := (v_business_info->>'company_id')::UUID;
    END IF;

    -- Check if user is trying to join their own company
    IF p_user_id = v_owner_id THEN
        RETURN json_build_object(
            'success', false,
            'error', 'You cannot join your own business as an employee',
            'error_code', 'OWNER_CANNOT_JOIN'
        );
    END IF;

    -- Check if user is already a member of this company
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

    -- Begin transaction for atomic operations
    BEGIN
        -- Add user to company
        INSERT INTO user_companies (user_id, company_id)
        VALUES (p_user_id, v_company_id);

        -- If joining a specific store, also add user to that store
        IF v_business_type = 'store' THEN
            -- Check if user_stores link already exists
            IF NOT EXISTS (
                SELECT 1 FROM user_stores us
                WHERE us.user_id = p_user_id 
                  AND us.store_id = v_business_id 
                  AND us.is_deleted = false
            ) THEN
                INSERT INTO user_stores (user_id, store_id)
                VALUES (p_user_id, v_business_id);
            END IF;
        END IF;

        -- Find or create Employee role for this company
        SELECT role_id INTO v_employee_role_id
        FROM roles r
        WHERE r.company_id = v_company_id
          AND r.role_name = 'Employee'
          AND r.role_type = 'employee';

        -- Create Employee role if it doesn't exist
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

            -- Grant basic permissions to Employee role
            -- Get essential features for employees
            INSERT INTO role_permissions (role_id, feature_id, can_access)
            SELECT 
                v_employee_role_id,
                f.feature_id,
                true
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

        -- Assign Employee role to user (if not already assigned)
        IF NOT EXISTS (
            SELECT 1 FROM user_roles ur
            WHERE ur.user_id = p_user_id 
              AND ur.role_id = v_employee_role_id 
              AND ur.is_deleted = false
        ) THEN
            INSERT INTO user_roles (user_id, role_id)
            VALUES (p_user_id, v_employee_role_id);
        END IF;

        -- Return success response
        RETURN json_build_object(
            'success', true,
            'message', 'Successfully joined business',
            'business_type', v_business_type,
            'business_id', v_business_id,
            'business_name', v_business_name,
            'company_id', v_company_id,
            'company_name', CASE 
                WHEN v_business_type = 'company' THEN v_business_name 
                ELSE v_business_info->>'company_name' 
            END,
            'role_assigned', 'Employee',
            'role_id', v_employee_role_id,
            'joined_at', NOW()
        );

    EXCEPTION
        WHEN unique_violation THEN
            -- Handle race conditions where multiple processes try to create the same records
            RETURN json_build_object(
                'success', false,
                'error', 'You are already a member of this company or a conflict occurred',
                'error_code', 'CONFLICT'
            );
        WHEN OTHERS THEN
            -- Rollback will happen automatically
            RETURN json_build_object(
                'success', false,
                'error', 'Failed to join business due to a database error',
                'error_code', 'DATABASE_ERROR',
                'error_detail', SQLERRM
            );
    END;

END;
$$;

-- ============================================================================
-- Function 3: validate_business_code_format
-- Purpose: Validate business code format without database lookup
-- Returns: Validation result
-- ============================================================================

CREATE OR REPLACE FUNCTION validate_business_code_format(
    p_business_code TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Check if code is provided
    IF p_business_code IS NULL OR LENGTH(TRIM(p_business_code)) = 0 THEN
        RETURN json_build_object(
            'valid', false,
            'error', 'Business code is required',
            'error_code', 'REQUIRED'
        );
    END IF;

    -- Check length (must be between 6-12 characters)
    IF LENGTH(TRIM(p_business_code)) < 6 OR LENGTH(TRIM(p_business_code)) > 12 THEN
        RETURN json_build_object(
            'valid', false,
            'error', 'Business code must be between 6-12 characters',
            'error_code', 'INVALID_LENGTH'
        );
    END IF;

    -- Check if contains only alphanumeric characters (6-12 characters)
    IF NOT (UPPER(TRIM(p_business_code)) ~ '^[A-Z0-9]{6,12}$') THEN
        RETURN json_build_object(
            'valid', false,
            'error', 'Business code must contain only letters and numbers',
            'error_code', 'INVALID_CHARACTERS'
        );
    END IF;

    -- Valid format
    RETURN json_build_object(
        'valid', true,
        'normalized_code', UPPER(TRIM(p_business_code))
    );
END;
$$;

-- ============================================================================
-- Function 4: get_user_business_memberships
-- Purpose: Get all businesses a user is member of (optimized for dashboard)
-- Returns: User's business memberships with details
-- ============================================================================

CREATE OR REPLACE FUNCTION get_user_business_memberships(
    p_user_id UUID
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_result JSON;
    v_companies JSON[];
    v_company_record RECORD;
    v_stores JSON[];
    v_store_record RECORD;
BEGIN
    -- Input validation
    IF p_user_id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'User ID is required'
        );
    END IF;

    -- Get companies user is member of
    FOR v_company_record IN
        SELECT 
            c.company_id,
            c.company_name,
            c.company_code,
            ct.type_name as company_type,
            c.owner_id,
            (c.owner_id = p_user_id) as is_owner,
            uc.created_at as joined_at,
            COALESCE(
                array_agg(
                    json_build_object(
                        'role_id', r.role_id,
                        'role_name', r.role_name,
                        'role_type', r.role_type
                    )
                ) FILTER (WHERE r.role_id IS NOT NULL), 
                '{}'::json[]
            ) as roles
        FROM user_companies uc
        INNER JOIN companies c ON uc.company_id = c.company_id
        LEFT JOIN company_types ct ON c.company_type_id = ct.company_type_id
        LEFT JOIN user_roles ur ON ur.user_id = uc.user_id
        LEFT JOIN roles r ON ur.role_id = r.role_id AND r.company_id = c.company_id
        WHERE uc.user_id = p_user_id
          AND uc.is_deleted = false
          AND c.is_deleted = false
          AND (ur.is_deleted = false OR ur.is_deleted IS NULL)
        GROUP BY c.company_id, c.company_name, c.company_code, ct.type_name, 
                 c.owner_id, uc.created_at
        ORDER BY uc.created_at DESC
    LOOP
        -- Get stores for this company that user has access to
        SELECT COALESCE(
            array_agg(
                json_build_object(
                    'store_id', s.store_id,
                    'store_name', s.store_name,
                    'store_code', s.store_code,
                    'store_address', s.store_address
                )
            ) FILTER (WHERE s.store_id IS NOT NULL), 
            '{}'::json[]
        ) INTO v_stores
        FROM user_stores us
        INNER JOIN stores s ON us.store_id = s.store_id
        WHERE us.user_id = p_user_id
          AND s.company_id = v_company_record.company_id
          AND us.is_deleted = false
          AND s.is_deleted = false;

        -- Add company with its stores to the companies array
        v_companies := v_companies || json_build_object(
            'company_id', v_company_record.company_id,
            'company_name', v_company_record.company_name,
            'company_code', v_company_record.company_code,
            'company_type', v_company_record.company_type,
            'is_owner', v_company_record.is_owner,
            'joined_at', v_company_record.joined_at,
            'roles', v_company_record.roles,
            'stores', COALESCE(v_stores, '{}'::json[])
        );
    END LOOP;

    RETURN json_build_object(
        'success', true,
        'user_id', p_user_id,
        'companies', COALESCE(v_companies, '{}'::json[]),
        'total_companies', COALESCE(array_length(v_companies, 1), 0)
    );

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Failed to retrieve user business memberships',
            'error_detail', SQLERRM
        );
END;
$$;

-- ============================================================================
-- Grant necessary permissions for these functions
-- ============================================================================

-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION find_business_by_code(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION join_business_by_code(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION validate_business_code_format(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_business_memberships(UUID) TO authenticated;

-- Grant execute permissions to service role for server-side operations
GRANT EXECUTE ON FUNCTION find_business_by_code(TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION join_business_by_code(UUID, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION validate_business_code_format(TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION get_user_business_memberships(UUID) TO service_role;

-- ============================================================================
-- Usage Examples and Testing
-- ============================================================================

/*
-- Example 1: Validate business code format
SELECT validate_business_code_format('ABC123');
SELECT validate_business_code_format('abc123'); -- Should normalize to ABC123
SELECT validate_business_code_format('ABC12'); -- Should fail - too short
SELECT validate_business_code_format('ABC123!'); -- Should fail - invalid characters

-- Example 2: Find business by code
SELECT find_business_by_code('ABC123');

-- Example 3: Join business by code
SELECT join_business_by_code('user-uuid-here', 'ABC123');

-- Example 4: Get user's business memberships
SELECT get_user_business_memberships('user-uuid-here');
*/