-- ============================================================
-- Migration: Work Schedule Template System
-- Date: 2025-12-28
-- Purpose:
--   1. Update v_user_salary view to include template info
--   2. Create RPC functions for template CRUD
--   3. Create RPC for assigning templates to employees
--
-- IMPORTANT: Run this in Supabase Dashboard SQL Editor
-- SAFE: Uses CREATE OR REPLACE, keeps existing column order
-- ============================================================

-- ============================================================
-- PART 1: Update v_user_salary View (SAFE - preserves column order)
-- ============================================================
-- Original columns (1-21) are kept in EXACT same order
-- New columns (22-32) are ADDED at the end

CREATE OR REPLACE VIEW v_user_salary AS
SELECT
    -- Original columns 1-16 (UNCHANGED)
    us.salary_id,
    us.user_id,
    u.first_name,
    u.last_name,
    concat(u.last_name, ' ', u.first_name) AS full_name,
    u.email,
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
    -- Original columns 17-21 (UNCHANGED)
    us.created_at,
    us.created_at_utc,
    uba.user_bank_name AS bank_name,
    uba.user_account_number AS bank_account_number,
    NULLIF(GREATEST(
        COALESCE(la.last_shift, '1970-01-01 00:00:00'::timestamp without time zone)::timestamp with time zone,
        COALESCE(la.last_journal, '1970-01-01 00:00:00'::timestamp without time zone)::timestamp with time zone,
        COALESCE(la.last_cash, '1970-01-01 00:00:00'::timestamp without time zone)::timestamp with time zone,
        COALESCE(la.last_app_usage, '1970-01-01 00:00:00'::timestamp without time zone::timestamp with time zone)
    ), '1970-01-01 00:00:00'::timestamp without time zone) AS last_activity_at,
    -- NEW columns 22-32 (ADDED at end)
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
    wst.sunday AS work_sunday
FROM user_salaries us
JOIN users u ON u.user_id = us.user_id
JOIN user_companies uc ON uc.user_id = us.user_id AND uc.company_id = us.company_id AND uc.is_deleted = false
-- NEW: Work Schedule Template JOIN
LEFT JOIN work_schedule_templates wst ON wst.template_id = us.work_schedule_template_id
-- Original JOINs (UNCHANGED)
LEFT JOIN LATERAL (
    SELECT user_roles.user_role_id,
        user_roles.user_id,
        user_roles.role_id,
        user_roles.created_at,
        user_roles.updated_at,
        user_roles.is_deleted,
        user_roles.deleted_at
    FROM user_roles
    JOIN roles ON roles.role_id = user_roles.role_id
    WHERE user_roles.user_id = u.user_id AND user_roles.is_deleted = false AND roles.company_id = us.company_id
    ORDER BY user_roles.created_at DESC
    LIMIT 1
) ur ON true
LEFT JOIN roles r ON r.role_id = ur.role_id
LEFT JOIN currency_types ct ON ct.currency_id = us.currency_id
LEFT JOIN LATERAL (
    SELECT users_bank_account.user_bank_name,
        users_bank_account.user_account_number
    FROM users_bank_account
    WHERE users_bank_account.user_id = us.user_id AND (users_bank_account.company_id = us.company_id OR users_bank_account.company_id IS NULL)
    ORDER BY (
        CASE
            WHEN users_bank_account.company_id = us.company_id THEN 0
            ELSE 1
        END), users_bank_account.updated_at DESC NULLS LAST
    LIMIT 1
) uba ON true
LEFT JOIN LATERAL (
    SELECT
        (SELECT max(sr.created_at) AS max FROM shift_requests sr WHERE sr.user_id = us.user_id) AS last_shift,
        (SELECT max(je.created_at) AS max FROM journal_entries je WHERE je.created_by = us.user_id) AS last_journal,
        (SELECT max(ca.created_at) AS max FROM cash_amount_entries ca WHERE ca.created_by = us.user_id) AS last_cash,
        (SELECT max(up.clicked_at) AS max FROM user_preferences up WHERE up.user_id = us.user_id AND up.company_id = us.company_id) AS last_app_usage
) la ON true;

COMMENT ON VIEW v_user_salary IS 'Employee salary view with work schedule template info. Updated 2025-12-28.';

-- ============================================================
-- PART 2: RPC - Get Work Schedule Templates
-- ============================================================

CREATE OR REPLACE FUNCTION get_work_schedule_templates(
    p_company_id UUID
)
RETURNS TABLE (
    template_id UUID,
    company_id UUID,
    template_name TEXT,
    work_start_time TIME,
    work_end_time TIME,
    monday BOOLEAN,
    tuesday BOOLEAN,
    wednesday BOOLEAN,
    thursday BOOLEAN,
    friday BOOLEAN,
    saturday BOOLEAN,
    sunday BOOLEAN,
    is_default BOOLEAN,
    employee_count BIGINT,
    created_at_utc TIMESTAMPTZ,
    updated_at_utc TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT
        wst.template_id,
        wst.company_id,
        wst.template_name,
        wst.work_start_time,
        wst.work_end_time,
        wst.monday,
        wst.tuesday,
        wst.wednesday,
        wst.thursday,
        wst.friday,
        wst.saturday,
        wst.sunday,
        wst.is_default,
        COUNT(us.salary_id)::BIGINT AS employee_count,
        wst.created_at_utc,
        wst.updated_at_utc
    FROM work_schedule_templates wst
    LEFT JOIN user_salaries us ON us.work_schedule_template_id = wst.template_id
    WHERE wst.company_id = p_company_id
    GROUP BY wst.template_id
    ORDER BY wst.is_default DESC, wst.template_name;
END;
$$;

COMMENT ON FUNCTION get_work_schedule_templates IS 'Get all work schedule templates for a company with employee count';

-- ============================================================
-- PART 3: RPC - Create Work Schedule Template
-- ============================================================

CREATE OR REPLACE FUNCTION create_work_schedule_template(
    p_company_id UUID,
    p_template_name TEXT,
    p_work_start_time TIME DEFAULT '09:00',
    p_work_end_time TIME DEFAULT '18:00',
    p_monday BOOLEAN DEFAULT true,
    p_tuesday BOOLEAN DEFAULT true,
    p_wednesday BOOLEAN DEFAULT true,
    p_thursday BOOLEAN DEFAULT true,
    p_friday BOOLEAN DEFAULT true,
    p_saturday BOOLEAN DEFAULT false,
    p_sunday BOOLEAN DEFAULT false,
    p_is_default BOOLEAN DEFAULT false
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_template_id UUID;
BEGIN
    -- If setting as default, unset other defaults first
    IF p_is_default THEN
        UPDATE work_schedule_templates
        SET is_default = false, updated_at_utc = NOW()
        WHERE company_id = p_company_id AND is_default = true;
    END IF;

    INSERT INTO work_schedule_templates (
        company_id, template_name, work_start_time, work_end_time,
        monday, tuesday, wednesday, thursday, friday, saturday, sunday,
        is_default
    ) VALUES (
        p_company_id, p_template_name, p_work_start_time, p_work_end_time,
        p_monday, p_tuesday, p_wednesday, p_thursday, p_friday, p_saturday, p_sunday,
        p_is_default
    )
    RETURNING template_id INTO v_template_id;

    RETURN jsonb_build_object(
        'success', true,
        'template_id', v_template_id,
        'message', 'Template created successfully'
    );
EXCEPTION
    WHEN unique_violation THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'DUPLICATE_NAME',
            'message', 'Template name already exists in this company'
        );
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'CREATE_FAILED',
            'message', SQLERRM
        );
END;
$$;

COMMENT ON FUNCTION create_work_schedule_template IS 'Create a new work schedule template for a company';

-- ============================================================
-- PART 4: RPC - Update Work Schedule Template
-- ============================================================

CREATE OR REPLACE FUNCTION update_work_schedule_template(
    p_template_id UUID,
    p_template_name TEXT DEFAULT NULL,
    p_work_start_time TIME DEFAULT NULL,
    p_work_end_time TIME DEFAULT NULL,
    p_monday BOOLEAN DEFAULT NULL,
    p_tuesday BOOLEAN DEFAULT NULL,
    p_wednesday BOOLEAN DEFAULT NULL,
    p_thursday BOOLEAN DEFAULT NULL,
    p_friday BOOLEAN DEFAULT NULL,
    p_saturday BOOLEAN DEFAULT NULL,
    p_sunday BOOLEAN DEFAULT NULL,
    p_is_default BOOLEAN DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_company_id UUID;
BEGIN
    -- Get company_id for the template
    SELECT company_id INTO v_company_id
    FROM work_schedule_templates
    WHERE template_id = p_template_id;

    IF v_company_id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'NOT_FOUND',
            'message', 'Template not found'
        );
    END IF;

    -- If setting as default, unset other defaults first
    IF p_is_default = true THEN
        UPDATE work_schedule_templates
        SET is_default = false, updated_at_utc = NOW()
        WHERE company_id = v_company_id
            AND is_default = true
            AND template_id != p_template_id;
    END IF;

    UPDATE work_schedule_templates
    SET
        template_name = COALESCE(p_template_name, template_name),
        work_start_time = COALESCE(p_work_start_time, work_start_time),
        work_end_time = COALESCE(p_work_end_time, work_end_time),
        monday = COALESCE(p_monday, monday),
        tuesday = COALESCE(p_tuesday, tuesday),
        wednesday = COALESCE(p_wednesday, wednesday),
        thursday = COALESCE(p_thursday, thursday),
        friday = COALESCE(p_friday, friday),
        saturday = COALESCE(p_saturday, saturday),
        sunday = COALESCE(p_sunday, sunday),
        is_default = COALESCE(p_is_default, is_default),
        updated_at_utc = NOW()
    WHERE template_id = p_template_id;

    RETURN jsonb_build_object(
        'success', true,
        'template_id', p_template_id,
        'message', 'Template updated successfully'
    );
EXCEPTION
    WHEN unique_violation THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'DUPLICATE_NAME',
            'message', 'Template name already exists in this company'
        );
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'UPDATE_FAILED',
            'message', SQLERRM
        );
END;
$$;

COMMENT ON FUNCTION update_work_schedule_template IS 'Update an existing work schedule template';

-- ============================================================
-- PART 5: RPC - Delete Work Schedule Template
-- ============================================================

CREATE OR REPLACE FUNCTION delete_work_schedule_template(
    p_template_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_employee_count BIGINT;
    v_template_name TEXT;
BEGIN
    -- Get template name for message
    SELECT template_name INTO v_template_name
    FROM work_schedule_templates
    WHERE template_id = p_template_id;

    IF v_template_name IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'NOT_FOUND',
            'message', 'Template not found'
        );
    END IF;

    -- Check if any employees are using this template
    SELECT COUNT(*) INTO v_employee_count
    FROM user_salaries
    WHERE work_schedule_template_id = p_template_id;

    IF v_employee_count > 0 THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'HAS_EMPLOYEES',
            'message', format('Cannot delete "%s": %s employee(s) are using this template', v_template_name, v_employee_count),
            'employee_count', v_employee_count
        );
    END IF;

    DELETE FROM work_schedule_templates
    WHERE template_id = p_template_id;

    RETURN jsonb_build_object(
        'success', true,
        'message', format('Template "%s" deleted successfully', v_template_name)
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'DELETE_FAILED',
            'message', SQLERRM
        );
END;
$$;

COMMENT ON FUNCTION delete_work_schedule_template IS 'Delete a work schedule template (only if no employees assigned)';

-- ============================================================
-- PART 6: RPC - Assign Work Schedule Template to Employee
-- ============================================================

CREATE OR REPLACE FUNCTION assign_work_schedule_template(
    p_user_id UUID,
    p_company_id UUID,
    p_template_id UUID  -- NULL to unassign
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_salary_type TEXT;
    v_template_name TEXT;
    v_rows_affected INT;
BEGIN
    -- Check salary record exists and get salary type
    SELECT salary_type INTO v_salary_type
    FROM user_salaries
    WHERE user_id = p_user_id AND company_id = p_company_id;

    IF v_salary_type IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'NOT_FOUND',
            'message', 'Employee salary record not found'
        );
    END IF;

    -- If assigning (not unassigning), verify template exists
    IF p_template_id IS NOT NULL THEN
        SELECT template_name INTO v_template_name
        FROM work_schedule_templates
        WHERE template_id = p_template_id AND company_id = p_company_id;

        IF v_template_name IS NULL THEN
            RETURN jsonb_build_object(
                'success', false,
                'error', 'TEMPLATE_NOT_FOUND',
                'message', 'Template not found or does not belong to this company'
            );
        END IF;
    END IF;

    -- Update the template assignment
    UPDATE user_salaries
    SET
        work_schedule_template_id = p_template_id,
        updated_at = NOW(),
        updated_at_utc = NOW()
    WHERE user_id = p_user_id AND company_id = p_company_id;

    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;

    IF v_rows_affected = 0 THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'UPDATE_FAILED',
            'message', 'Failed to update employee record'
        );
    END IF;

    RETURN jsonb_build_object(
        'success', true,
        'message', CASE
            WHEN p_template_id IS NULL THEN 'Work schedule template unassigned'
            ELSE format('Assigned to "%s" template', v_template_name)
        END,
        'template_id', p_template_id,
        'template_name', v_template_name,
        'salary_type', v_salary_type,
        'warning', CASE
            WHEN v_salary_type != 'monthly' THEN 'Note: This employee is not monthly type. Template may not affect check-in.'
            ELSE NULL
        END
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'ASSIGN_FAILED',
            'message', SQLERRM
        );
END;
$$;

COMMENT ON FUNCTION assign_work_schedule_template IS 'Assign or unassign a work schedule template to an employee';

-- ============================================================
-- VERIFICATION: Test the functions after running
-- ============================================================
-- 1. Check view has new columns:
--    SELECT column_name FROM information_schema.columns
--    WHERE table_name = 'v_user_salary' AND column_name LIKE 'work_%';
--
-- 2. Get templates:
--    SELECT * FROM get_work_schedule_templates('your-company-id');
--
-- 3. Test v_user_salary:
--    SELECT user_id, full_name, salary_type, work_schedule_template_name
--    FROM v_user_salary WHERE company_id = 'your-company-id' LIMIT 5;
