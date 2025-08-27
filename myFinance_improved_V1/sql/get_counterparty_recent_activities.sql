-- =====================================================
-- Get Counterparty Recent Activities Function
-- =====================================================
-- Fetches recent transaction activities for a specific counterparty
-- from the company's perspective
-- 
-- Author: System
-- Version: 1.0
-- Date: 2025-01-26
-- =====================================================

DROP FUNCTION IF EXISTS get_counterparty_recent_activities;

CREATE OR REPLACE FUNCTION get_counterparty_recent_activities(
    p_company_id UUID,
    p_counterparty_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_limit INTEGER DEFAULT 10
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_activities JSONB;
    v_currency TEXT := 'VND';
BEGIN
    -- Fetch recent activities
    WITH recent_transactions AS (
        SELECT 
            t.id,
            t.transaction_date,
            t.created_at,
            t.transaction_type,
            t.payment_status,
            t.final_amount,
            t.buyer,
            t.supplier,
            t.store_id,
            s.store_name,
            -- Determine activity type
            CASE 
                WHEN t.transaction_type = 'payment' THEN
                    CASE 
                        WHEN t.buyer = p_company_id THEN 'Payment Made'
                        ELSE 'Payment Received'
                    END
                WHEN t.transaction_type = 'purchase' THEN
                    CASE 
                        WHEN t.buyer = p_company_id THEN 'Purchase Order'
                        ELSE 'Sales Invoice'
                    END
                WHEN t.transaction_type = 'sale' THEN
                    CASE 
                        WHEN t.buyer = p_company_id THEN 'Purchase Invoice'
                        ELSE 'Sales Order'
                    END
                WHEN t.transaction_type = 'credit_note' THEN 'Credit Note'
                WHEN t.transaction_type = 'debit_note' THEN 'Debit Note'
                WHEN t.transaction_type = 'refund' THEN 'Refund'
                ELSE 'Transaction'
            END AS activity_type,
            -- Determine amount sign (positive = receivable, negative = payable)
            CASE 
                WHEN t.buyer = p_company_id THEN -t.final_amount
                ELSE t.final_amount
            END AS signed_amount,
            -- Transaction reference
            COALESCE(t.invoice_number, t.reference_number, t.id::TEXT) AS reference,
            t.notes
        FROM transactions t
        LEFT JOIN store s ON t.store_id = s.id
        WHERE (
            (t.buyer = p_company_id AND t.supplier = p_counterparty_id)
            OR (t.supplier = p_company_id AND t.buyer = p_counterparty_id)
        )
        AND t.is_deleted = false
        AND (p_store_id IS NULL OR t.store_id = p_store_id)
        ORDER BY t.transaction_date DESC, t.created_at DESC
        LIMIT p_limit
    ),
    formatted_activities AS (
        SELECT 
            jsonb_build_object(
                'id', id,
                'date', transaction_date,
                'created_at', created_at,
                'type', activity_type,
                'transaction_type', transaction_type,
                'payment_status', payment_status,
                'amount', ABS(signed_amount),
                'signed_amount', signed_amount,
                'is_receivable', signed_amount > 0,
                'reference', reference,
                'store_id', store_id,
                'store_name', store_name,
                'notes', notes,
                'days_ago', EXTRACT(EPOCH FROM (NOW() - transaction_date)) / 86400,
                'formatted_date', CASE 
                    WHEN DATE(transaction_date) = CURRENT_DATE THEN 'Today'
                    WHEN DATE(transaction_date) = CURRENT_DATE - INTERVAL '1 day' THEN 'Yesterday'
                    WHEN DATE(transaction_date) >= CURRENT_DATE - INTERVAL '7 days' THEN 
                        EXTRACT(DAY FROM (CURRENT_DATE - DATE(transaction_date))) || ' days ago'
                    WHEN DATE(transaction_date) >= CURRENT_DATE - INTERVAL '30 days' THEN 
                        CEIL(EXTRACT(DAY FROM (CURRENT_DATE - DATE(transaction_date))) / 7) || ' weeks ago'
                    WHEN DATE(transaction_date) >= CURRENT_DATE - INTERVAL '365 days' THEN 
                        CEIL(EXTRACT(DAY FROM (CURRENT_DATE - DATE(transaction_date))) / 30) || ' months ago'
                    ELSE TO_CHAR(transaction_date, 'DD/MM/YYYY')
                END
            ) AS activity
        FROM recent_transactions
    )
    SELECT jsonb_agg(activity ORDER BY (activity->>'date')::DATE DESC, (activity->>'created_at')::TIMESTAMP DESC) 
    INTO v_activities
    FROM formatted_activities;

    -- Return the result
    RETURN jsonb_build_object(
        'activities', COALESCE(v_activities, '[]'::jsonb),
        'metadata', jsonb_build_object(
            'company_id', p_company_id,
            'counterparty_id', p_counterparty_id,
            'store_id', p_store_id,
            'generated_at', NOW(),
            'currency', v_currency,
            'limit', p_limit
        )
    );
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_counterparty_recent_activities(UUID, UUID, UUID, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION get_counterparty_recent_activities(UUID, UUID, UUID, INTEGER) TO anon;

-- Add comment
COMMENT ON FUNCTION get_counterparty_recent_activities IS 'Fetches recent transaction activities for a specific counterparty relationship';

-- =====================================================
-- Test the function
-- =====================================================
DO $$
DECLARE
    v_result JSONB;
BEGIN
    -- Test the function with sample data
    SELECT get_counterparty_recent_activities(
        '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,  -- company_id
        'b6b24d9f-d8e8-4b76-87f9-35b8c5a05b9a'::UUID,  -- counterparty_id (test1)
        NULL,  -- store_id (all stores)
        5  -- limit
    ) INTO v_result;
    
    -- Check if result has expected structure
    IF v_result IS NOT NULL AND 
       v_result ? 'activities' AND 
       v_result ? 'metadata' THEN
        RAISE NOTICE 'Recent activities function test successful!';
        RAISE NOTICE 'Number of activities: %', 
            jsonb_array_length(v_result->'activities');
    ELSE
        RAISE WARNING 'Recent activities function test failed - unexpected structure';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE WARNING 'Recent activities function test error: %', SQLERRM;
END $$;