-- Comprehensive RPC function to fetch all debt control data
-- This function fetches all data once and returns it for local filtering in Flutter

CREATE OR REPLACE FUNCTION get_debt_control_data(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
    v_result JSONB;
    v_metadata JSONB;
    v_summary JSONB;
    v_store_aggregates JSONB;
    v_records JSONB;
    v_perspective TEXT;
BEGIN
    -- Determine perspective based on store_id parameter
    v_perspective := CASE 
        WHEN p_store_id IS NOT NULL THEN 'store'
        ELSE 'company'
    END;
    
    -- Build metadata
    v_metadata := jsonb_build_object(
        'company_id', p_company_id,
        'store_id', p_store_id,
        'perspective', v_perspective,
        'generated_at', CURRENT_TIMESTAMP,
        'currency', '₫'
    );
    
    -- Calculate summary aggregates
    WITH debt_totals AS (
        SELECT 
            COALESCE(SUM(CASE WHEN debt_type = 'receivable' THEN amount ELSE 0 END), 0) as total_receivable,
            COALESCE(SUM(CASE WHEN debt_type = 'payable' THEN amount ELSE 0 END), 0) as total_payable,
            COUNT(DISTINCT counterparty_id) as counterparty_count,
            COUNT(*) as transaction_count
        FROM debts
        WHERE company_id = p_company_id
            AND (p_store_id IS NULL OR store_id = p_store_id)
            AND deleted_at IS NULL
    ),
    internal_totals AS (
        SELECT 
            COALESCE(SUM(CASE WHEN d.debt_type = 'receivable' THEN d.amount ELSE 0 END), 0) as internal_receivable,
            COALESCE(SUM(CASE WHEN d.debt_type = 'payable' THEN d.amount ELSE 0 END), 0) as internal_payable
        FROM debts d
        JOIN counterparties c ON d.counterparty_id = c.counterparty_id
        WHERE d.company_id = p_company_id
            AND (p_store_id IS NULL OR d.store_id = p_store_id)
            AND c.is_internal = true
            AND d.deleted_at IS NULL
    ),
    external_totals AS (
        SELECT 
            COALESCE(SUM(CASE WHEN d.debt_type = 'receivable' THEN d.amount ELSE 0 END), 0) as external_receivable,
            COALESCE(SUM(CASE WHEN d.debt_type = 'payable' THEN d.amount ELSE 0 END), 0) as external_payable
        FROM debts d
        JOIN counterparties c ON d.counterparty_id = c.counterparty_id
        WHERE d.company_id = p_company_id
            AND (p_store_id IS NULL OR d.store_id = p_store_id)
            AND c.is_internal = false
            AND d.deleted_at IS NULL
    )
    SELECT jsonb_build_object(
        'total_receivable', dt.total_receivable,
        'total_payable', dt.total_payable,
        'net_position', dt.total_receivable - dt.total_payable,
        'internal_receivable', it.internal_receivable,
        'internal_payable', it.internal_payable,
        'external_receivable', et.external_receivable,
        'external_payable', et.external_payable,
        'counterparty_count', dt.counterparty_count,
        'transaction_count', dt.transaction_count
    ) INTO v_summary
    FROM debt_totals dt, internal_totals it, external_totals et;
    
    -- Get store aggregates (only for company perspective)
    IF v_perspective = 'company' THEN
        SELECT COALESCE(jsonb_agg(
            jsonb_build_object(
                'store_id', s.store_id,
                'store_name', s.store_name,
                'receivable', COALESCE(sa.receivable, 0),
                'payable', COALESCE(sa.payable, 0),
                'net_position', COALESCE(sa.receivable - sa.payable, 0),
                'counterparty_count', COALESCE(sa.counterparty_count, 0)
            ) ORDER BY s.store_name
        ), '[]'::jsonb) INTO v_store_aggregates
        FROM stores s
        LEFT JOIN LATERAL (
            SELECT 
                SUM(CASE WHEN debt_type = 'receivable' THEN amount ELSE 0 END) as receivable,
                SUM(CASE WHEN debt_type = 'payable' THEN amount ELSE 0 END) as payable,
                COUNT(DISTINCT counterparty_id) as counterparty_count
            FROM debts
            WHERE company_id = p_company_id
                AND store_id = s.store_id
                AND deleted_at IS NULL
        ) sa ON true
        WHERE s.company_id = p_company_id
            AND s.deleted_at IS NULL;
    ELSE
        v_store_aggregates := '[]'::jsonb;
    END IF;
    
    -- Get all debt records with counterparty information
    -- Return ALL records - filtering will be done locally in Flutter
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'counterparty_id', r.counterparty_id,
            'counterparty_name', r.counterparty_name,
            'is_internal', r.is_internal,
            'linked_company_id', r.linked_company_id,
            'store_id', r.store_id,
            'store_name', r.store_name,
            'receivable_amount', r.receivable_amount,
            'payable_amount', r.payable_amount,
            'net_amount', r.net_amount,
            'last_activity', r.last_activity,
            'transaction_count', r.transaction_count,
            'days_outstanding', r.days_outstanding
        ) ORDER BY ABS(r.net_amount) DESC
    ), '[]'::jsonb) INTO v_records
    FROM (
        SELECT 
            c.counterparty_id,
            c.name as counterparty_name,
            c.is_internal,
            c.linked_company_id,
            d.store_id,
            s.store_name,
            SUM(CASE WHEN d.debt_type = 'receivable' THEN d.amount ELSE 0 END) as receivable_amount,
            SUM(CASE WHEN d.debt_type = 'payable' THEN d.amount ELSE 0 END) as payable_amount,
            SUM(CASE WHEN d.debt_type = 'receivable' THEN d.amount ELSE -d.amount END) as net_amount,
            MAX(d.created_at) as last_activity,
            COUNT(d.debt_id) as transaction_count,
            EXTRACT(DAY FROM NOW() - MIN(d.due_date)) as days_outstanding
        FROM counterparties c
        INNER JOIN debts d ON c.counterparty_id = d.counterparty_id
        LEFT JOIN stores s ON d.store_id = s.store_id
        WHERE d.company_id = p_company_id
            AND (p_store_id IS NULL OR d.store_id = p_store_id)
            AND d.deleted_at IS NULL
        GROUP BY 
            c.counterparty_id, 
            c.name, 
            c.is_internal, 
            c.linked_company_id,
            d.store_id,
            s.store_name
        HAVING SUM(CASE WHEN d.debt_type = 'receivable' THEN d.amount ELSE -d.amount END) != 0
    ) r;
    
    -- Build final result
    v_result := jsonb_build_object(
        'metadata', v_metadata,
        'summary', v_summary,
        'store_aggregates', v_store_aggregates,
        'records', v_records
    );
    
    RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_debt_control_data(UUID, UUID) TO authenticated;

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_debts_company_store_deleted 
ON debts(company_id, store_id, deleted_at);

CREATE INDEX IF NOT EXISTS idx_debts_counterparty_deleted 
ON debts(counterparty_id, deleted_at);

-- Comment on function
COMMENT ON FUNCTION get_debt_control_data IS 'Fetches all debt control data for a company or store. Returns all records for local filtering in the application.';