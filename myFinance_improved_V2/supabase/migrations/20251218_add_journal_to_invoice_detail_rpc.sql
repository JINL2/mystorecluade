-- Migration: Add journal info (ai_description, attachments) to get_invoice_detail RPC
-- This allows sales_invoice feature to show AI descriptions and images like transaction_history
--
-- Changes:
--   - Added journal object with journal_id, ai_description, attachments
--   - Attachments include file_url, file_name, file_type (no OCR for efficiency)
--   - Uses LEFT JOIN to handle invoices without journals

CREATE OR REPLACE FUNCTION get_invoice_detail(
    p_invoice_id UUID,
    p_timezone TEXT DEFAULT 'Asia/Ho_Chi_Minh'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_invoice RECORD;
    v_items JSONB;
    v_item_count INTEGER;
    v_total_quantity NUMERIC;
    v_journal JSONB;
    v_result JSONB;
BEGIN
    -- Validate required parameter
    IF p_invoice_id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'p_invoice_id is required',
            'code', 'MISSING_INVOICE_ID'
        );
    END IF;

    -- Get invoice header with all related info
    SELECT
        -- Invoice basic info
        i.invoice_id,
        i.invoice_number,
        i.status,
        TO_CHAR(i.sale_date_utc AT TIME ZONE p_timezone, 'YYYY-MM-DD HH24:MI:SS') as sale_date,
        i.subtotal,
        i.tax_amount,
        i.discount_amount,
        i.total_amount,
        COALESCE(i.total_cost, 0) as total_cost,
        i.payment_method,
        TO_CHAR(i.created_at_utc AT TIME ZONE p_timezone, 'YYYY-MM-DD HH24:MI:SS') as created_at,
        -- Refund info
        CASE WHEN i.refund_date_utc IS NOT NULL
            THEN TO_CHAR(i.refund_date_utc AT TIME ZONE p_timezone, 'YYYY-MM-DD HH24:MI:SS')
            ELSE NULL
        END as refund_date,
        i.refund_reason,
        -- Store info
        s.store_id,
        s.store_name,
        s.store_code,
        -- Customer info
        c.counterparty_id as customer_id,
        c.name as customer_name,
        c.phone as customer_phone,
        c.email as customer_email,
        c.address as customer_address,
        c.type as customer_type,
        -- Cash location info
        cl.cash_location_id,
        cl.location_name as cash_location_name,
        cl.location_type as cash_location_type,
        -- Created by info
        u_created.user_id as created_by_id,
        TRIM(COALESCE(u_created.first_name, '') || ' ' || COALESCE(u_created.last_name, '')) as created_by_name,
        u_created.email as created_by_email,
        u_created.profile_image as created_by_profile_image,
        -- Refunded by info
        u_refund.user_id as refunded_by_id,
        TRIM(COALESCE(u_refund.first_name, '') || ' ' || COALESCE(u_refund.last_name, '')) as refunded_by_name,
        u_refund.email as refunded_by_email,
        u_refund.profile_image as refunded_by_profile_image
    INTO v_invoice
    FROM inventory_invoice i
    LEFT JOIN stores s ON i.store_id = s.store_id
    LEFT JOIN counterparties c ON i.customer_id = c.counterparty_id
    LEFT JOIN cash_locations cl ON i.cash_location_id = cl.cash_location_id
    LEFT JOIN users u_created ON i.created_by = u_created.user_id
    LEFT JOIN users u_refund ON i.refunded_by = u_refund.user_id
    WHERE i.invoice_id = p_invoice_id
      AND i.is_deleted = false;

    -- Check if invoice exists
    IF v_invoice IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Invoice not found',
            'code', 'INVOICE_NOT_FOUND'
        );
    END IF;

    -- Get items with product details
    SELECT
        jsonb_agg(
            jsonb_build_object(
                'invoice_item_id', it.item_id,
                'product_id', it.product_id,
                'product_name', p.product_name,
                'sku', p.sku,
                'barcode', p.barcode,
                'product_image', CASE
                    WHEN p.image_urls IS NOT NULL AND jsonb_array_length(p.image_urls) > 0
                    THEN p.image_urls->>0
                    ELSE NULL
                END,
                'brand_name', b.brand_name,
                'category_name', cat.category_name,
                'quantity', it.quantity_sold,
                'unit_price', it.unit_price,
                'unit_cost', it.unit_cost,
                'discount_amount', COALESCE(it.discount_amount, 0),
                'total_price', it.total_amount,
                'total_cost', it.unit_cost * it.quantity_sold
            ) ORDER BY it.created_at_utc
        ),
        COUNT(*),
        COALESCE(SUM(it.quantity_sold), 0)
    INTO v_items, v_item_count, v_total_quantity
    FROM inventory_invoice_items it
    JOIN inventory_products p ON it.product_id = p.product_id
    LEFT JOIN inventory_brands b ON p.brand_id = b.brand_id
    LEFT JOIN inventory_product_categories cat ON p.category_id = cat.category_id
    WHERE it.invoice_id = p_invoice_id;

    -- Get journal info with attachments (single efficient query)
    SELECT
        CASE WHEN je.journal_id IS NOT NULL THEN
            jsonb_build_object(
                'journal_id', je.journal_id,
                'ai_description', je.ai_description,
                'attachments', COALESCE(
                    (
                        SELECT jsonb_agg(
                            jsonb_build_object(
                                'attachment_id', ja.attachment_id::text,
                                'file_url', ja.file_url,
                                'file_name', ja.file_name,
                                'file_type', ja.file_type
                            ) ORDER BY ja.uploaded_at_utc
                        )
                        FROM journal_attachments ja
                        WHERE ja.journal_id = je.journal_id
                    ),
                    '[]'::jsonb
                )
            )
        ELSE NULL
        END
    INTO v_journal
    FROM journal_entries je
    WHERE je.invoice_id = p_invoice_id
      AND je.is_deleted = false
    LIMIT 1;

    -- Build result
    v_result := jsonb_build_object(
        'success', true,
        'data', jsonb_build_object(
            'invoice_id', v_invoice.invoice_id,
            'invoice_number', v_invoice.invoice_number,
            'status', v_invoice.status,
            'sale_date', v_invoice.sale_date,
            'payment_method', v_invoice.payment_method,
            'payment_status', CASE
                WHEN v_invoice.status = 'completed' THEN 'paid'
                WHEN v_invoice.status = 'cancelled' THEN 'refunded'
                ELSE 'pending'
            END,

            'store', jsonb_build_object(
                'store_id', v_invoice.store_id,
                'store_name', v_invoice.store_name,
                'store_code', v_invoice.store_code
            ),

            'customer', CASE
                WHEN v_invoice.customer_id IS NOT NULL THEN
                    jsonb_build_object(
                        'customer_id', v_invoice.customer_id,
                        'name', v_invoice.customer_name,
                        'phone', v_invoice.customer_phone,
                        'email', v_invoice.customer_email,
                        'address', v_invoice.customer_address,
                        'type', v_invoice.customer_type
                    )
                ELSE NULL
            END,

            'cash_location', CASE
                WHEN v_invoice.cash_location_id IS NOT NULL THEN
                    jsonb_build_object(
                        'cash_location_id', v_invoice.cash_location_id,
                        'location_name', v_invoice.cash_location_name,
                        'location_type', v_invoice.cash_location_type
                    )
                ELSE NULL
            END,

            'amounts', jsonb_build_object(
                'subtotal', v_invoice.subtotal,
                'tax_amount', v_invoice.tax_amount,
                'discount_amount', v_invoice.discount_amount,
                'total_amount', v_invoice.total_amount,
                'total_cost', v_invoice.total_cost,
                'profit', v_invoice.total_amount - v_invoice.total_cost
            ),

            'items', COALESCE(v_items, '[]'::jsonb),

            'items_summary', jsonb_build_object(
                'item_count', v_item_count,
                'total_quantity', v_total_quantity
            ),

            -- NEW: Journal info with ai_description and attachments
            'journal', v_journal,

            'refund', CASE
                WHEN v_invoice.refund_date IS NOT NULL THEN
                    jsonb_build_object(
                        'refund_date', v_invoice.refund_date,
                        'refund_reason', v_invoice.refund_reason,
                        'refunded_by', CASE
                            WHEN v_invoice.refunded_by_id IS NOT NULL THEN
                                jsonb_build_object(
                                    'user_id', v_invoice.refunded_by_id,
                                    'name', v_invoice.refunded_by_name,
                                    'email', v_invoice.refunded_by_email,
                                    'profile_image', v_invoice.refunded_by_profile_image
                                )
                            ELSE NULL
                        END
                    )
                ELSE NULL
            END,

            'created_by', CASE
                WHEN v_invoice.created_by_id IS NOT NULL THEN
                    jsonb_build_object(
                        'user_id', v_invoice.created_by_id,
                        'name', v_invoice.created_by_name,
                        'email', v_invoice.created_by_email,
                        'profile_image', v_invoice.created_by_profile_image
                    )
                ELSE NULL
            END,
            'created_at', v_invoice.created_at
        )
    );

    RETURN v_result;

EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Error fetching invoice detail',
            'error', SQLERRM,
            'detail', SQLSTATE
        );
END;
$$;

-- Add comment for documentation
COMMENT ON FUNCTION get_invoice_detail(UUID, TEXT) IS '
================================================================================
FUNCTION: get_invoice_detail (v2 - with journal info)
================================================================================
Returns detailed invoice information including:
- Invoice basic info
- Items with product details
- Customer, store, payment info
- Journal info with AI description and attachments (NEW)
- Refund info for cancelled invoices

--------------------------------------------------------------------------------
NEW FIELDS (v2)
--------------------------------------------------------------------------------
journal: {
  journal_id: UUID,
  ai_description: TEXT,        -- AI generated description
  attachments: [               -- Attached images/files
    {
      attachment_id: TEXT,
      file_url: TEXT,
      file_name: TEXT,
      file_type: TEXT          -- e.g., "image/jpeg", "application/pdf"
    }
  ]
}

--------------------------------------------------------------------------------
EFFICIENCY NOTES
--------------------------------------------------------------------------------
- Single query for journal + attachments (no N+1)
- OCR text excluded (not needed in UI, reduces data transfer)
- LEFT JOIN ensures invoices without journals still work
================================================================================
';
