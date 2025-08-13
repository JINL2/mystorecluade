-- Create RPC function for updating counterparty (bypasses RLS issues)
CREATE OR REPLACE FUNCTION update_counterparty(
    p_counterparty_id UUID,
    p_user_id UUID,
    p_name TEXT,
    p_type TEXT,
    p_email TEXT DEFAULT NULL,
    p_phone TEXT DEFAULT NULL,
    p_address TEXT DEFAULT NULL,
    p_notes TEXT DEFAULT NULL,
    p_is_internal BOOLEAN DEFAULT FALSE,
    p_linked_company_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
    updated_record counterparties%ROWTYPE;
BEGIN
    -- Check if user has access to this counterparty through company membership
    IF NOT EXISTS (
        SELECT 1 
        FROM counterparties cp
        INNER JOIN user_companies uc ON cp.company_id = uc.company_id
        WHERE cp.counterparty_id = p_counterparty_id 
        AND uc.user_id = p_user_id
        AND cp.is_deleted = FALSE
    ) THEN
        RETURN json_build_object(
            'success', FALSE,
            'error', 'Counter party not found or access denied',
            'code', 'ACCESS_DENIED'
        );
    END IF;

    -- Perform the update
    UPDATE counterparties 
    SET 
        name = p_name,
        type = p_type,
        email = p_email,
        phone = p_phone,
        address = p_address,
        notes = p_notes,
        is_internal = p_is_internal,
        linked_company_id = p_linked_company_id,
        updated_at = NOW()
    WHERE counterparty_id = p_counterparty_id
    RETURNING * INTO updated_record;

    -- Check if update was successful
    IF updated_record.counterparty_id IS NULL THEN
        RETURN json_build_object(
            'success', FALSE,
            'error', 'Update failed',
            'code', 'UPDATE_FAILED'
        );
    END IF;

    -- Return success with updated data
    SELECT json_build_object(
        'success', TRUE,
        'data', row_to_json(updated_record),
        'message', 'Counter party updated successfully'
    ) INTO result;

    RETURN result;
END;
$$;