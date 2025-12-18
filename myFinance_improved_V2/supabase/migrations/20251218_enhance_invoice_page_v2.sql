-- Migration: Add first_product_name and ai_description to get_invoice_page_v2
-- Purpose: Show product name and AI summary in invoice list for quick identification
--
-- Changes:
--   - items_summary now includes first_product_name
--   - Added ai_description field (from journal_entries)
--   - Added index for journal_entries.invoice_id for performance

-- Step 1: Create index for performance (if not exists)
CREATE INDEX IF NOT EXISTS idx_journal_entries_invoice_id
ON journal_entries(invoice_id)
WHERE invoice_id IS NOT NULL AND is_deleted = false;

-- Step 2: Update RPC function
CREATE OR REPLACE FUNCTION get_invoice_page_v2(
    p_company_id UUID,
    p_store_id UUID,
    p_page INTEGER,
    p_limit INTEGER,
    p_search TEXT DEFAULT NULL,
    p_start_date DATE DEFAULT NULL,
    p_end_date DATE DEFAULT NULL,
    p_timezone TEXT DEFAULT 'Asia/Ho_Chi_Minh'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
/*
=============================================================================
FUNCTION: get_invoice_page_v2 (v2.1 - with first_product_name & ai_description)
=============================================================================

NEW FIELDS (v2.1):
- items_summary.first_product_name: First product name for quick identification
- ai_description: AI generated summary from linked journal entry

PERFORMANCE:
- Uses idx_journal_entries_invoice_id for efficient journal lookup
- first_product_name uses existing idx_inventory_invoice_items_invoice_id
=============================================================================
*/
DECLARE
  v_offset INTEGER;
  v_invoices JSONB;
  v_total_count INTEGER;
  v_result JSONB;
  v_currency_code TEXT;
  v_currency_name TEXT;
  v_currency_symbol TEXT;
  v_period_total_amount NUMERIC;
  v_period_total_cost NUMERIC;
  v_period_invoice_count INTEGER;
  v_completed_count INTEGER;
  v_draft_count INTEGER;
  v_cancelled_count INTEGER;
  v_cash_count INTEGER;
  v_card_count INTEGER;
  v_transfer_count INTEGER;
BEGIN
  -- Get company's base currency information
  SELECT
    ct.currency_code,
    ct.currency_name,
    ct.symbol
  INTO
    v_currency_code,
    v_currency_name,
    v_currency_symbol
  FROM companies c
  INNER JOIN currency_types ct ON c.base_currency_id = ct.currency_id
  WHERE c.company_id = p_company_id;

  -- Calculate offset for pagination
  v_offset := (p_page - 1) * p_limit;

  -- Get total count for pagination
  SELECT COUNT(*)
  INTO v_total_count
  FROM inventory_invoice ii
  LEFT JOIN counterparties c ON ii.customer_id = c.counterparty_id
  WHERE
    ii.company_id = p_company_id
    AND (p_store_id IS NULL OR ii.store_id = p_store_id)
    AND ii.is_deleted = false
    AND (p_start_date IS NULL OR (ii.sale_date_utc AT TIME ZONE p_timezone)::date >= p_start_date)
    AND (p_end_date IS NULL OR (ii.sale_date_utc AT TIME ZONE p_timezone)::date <= p_end_date)
    AND (p_search IS NULL OR (
      ii.invoice_number ILIKE '%' || p_search || '%' OR
      c.name ILIKE '%' || p_search || '%' OR
      ii.payment_method ILIKE '%' || p_search || '%'
    ));

  -- Get summary statistics
  SELECT
    COUNT(*) FILTER (WHERE ii.status = 'completed'),
    COUNT(*) FILTER (WHERE ii.status = 'draft'),
    COUNT(*) FILTER (WHERE ii.status = 'cancelled'),
    COUNT(*) FILTER (WHERE ii.payment_method = 'cash'),
    COUNT(*) FILTER (WHERE ii.payment_method = 'card'),
    COUNT(*) FILTER (WHERE ii.payment_method = 'transfer'),
    COALESCE(SUM(ii.total_amount), 0),
    COALESCE(SUM(ii.total_cost), 0),
    COUNT(*)
  INTO
    v_completed_count,
    v_draft_count,
    v_cancelled_count,
    v_cash_count,
    v_card_count,
    v_transfer_count,
    v_period_total_amount,
    v_period_total_cost,
    v_period_invoice_count
  FROM inventory_invoice ii
  LEFT JOIN counterparties c ON ii.customer_id = c.counterparty_id
  WHERE
    ii.company_id = p_company_id
    AND (p_store_id IS NULL OR ii.store_id = p_store_id)
    AND ii.is_deleted = false
    AND (p_start_date IS NULL OR (ii.sale_date_utc AT TIME ZONE p_timezone)::date >= p_start_date)
    AND (p_end_date IS NULL OR (ii.sale_date_utc AT TIME ZONE p_timezone)::date <= p_end_date)
    AND (p_search IS NULL OR (
      ii.invoice_number ILIKE '%' || p_search || '%' OR
      c.name ILIKE '%' || p_search || '%' OR
      ii.payment_method ILIKE '%' || p_search || '%'
    ));

  -- Get invoices with pagination (with first_product_name and ai_description)
  WITH invoice_list AS (
    SELECT
      ii.invoice_id,
      ii.invoice_number,
      ii.sale_date_utc AT TIME ZONE p_timezone as sale_date,
      ii.status,
      ii.payment_method,
      ii.subtotal,
      ii.tax_amount,
      ii.discount_amount,
      ii.total_amount,
      COALESCE(ii.total_cost, 0) as total_cost,
      ii.created_at_utc AT TIME ZONE p_timezone as created_at,
      -- Customer info
      c.counterparty_id as customer_id,
      c.name as customer_name,
      c.phone as customer_phone,
      c.type as customer_type,
      -- Store info
      s.store_id,
      s.store_name,
      s.store_code,
      -- Cash location info
      cl.cash_location_id,
      cl.location_name,
      cl.location_type,
      -- Created by info
      u.user_id as created_by_id,
      u.first_name || ' ' || u.last_name as created_by_name,
      u.email as created_by_email,
      -- Items summary
      (
        SELECT COUNT(*)
        FROM inventory_invoice_items
        WHERE invoice_id = ii.invoice_id
      ) as item_count,
      (
        SELECT COALESCE(SUM(quantity_sold), 0)
        FROM inventory_invoice_items
        WHERE invoice_id = ii.invoice_id
      ) as total_quantity,
      -- NEW: First product name
      (
        SELECT p.product_name
        FROM inventory_invoice_items iit
        JOIN inventory_products p ON p.product_id = iit.product_id
        WHERE iit.invoice_id = ii.invoice_id
        ORDER BY iit.created_at_utc
        LIMIT 1
      ) as first_product_name,
      -- NEW: AI description from journal
      (
        SELECT je.ai_description
        FROM journal_entries je
        WHERE je.invoice_id = ii.invoice_id
          AND je.is_deleted = false
        LIMIT 1
      ) as ai_description
    FROM inventory_invoice ii
    LEFT JOIN counterparties c ON ii.customer_id = c.counterparty_id
    LEFT JOIN stores s ON ii.store_id = s.store_id
    LEFT JOIN cash_locations cl ON ii.cash_location_id = cl.cash_location_id
    LEFT JOIN users u ON ii.created_by = u.user_id
    WHERE
      ii.company_id = p_company_id
      AND (p_store_id IS NULL OR ii.store_id = p_store_id)
      AND ii.is_deleted = false
      AND (p_start_date IS NULL OR (ii.sale_date_utc AT TIME ZONE p_timezone)::date >= p_start_date)
      AND (p_end_date IS NULL OR (ii.sale_date_utc AT TIME ZONE p_timezone)::date <= p_end_date)
      AND (p_search IS NULL OR (
        ii.invoice_number ILIKE '%' || p_search || '%' OR
        c.name ILIKE '%' || p_search || '%' OR
        ii.payment_method ILIKE '%' || p_search || '%'
      ))
    ORDER BY
      ii.sale_date_utc DESC,
      ii.created_at_utc DESC
    LIMIT p_limit
    OFFSET v_offset
  )
  SELECT jsonb_agg(
    jsonb_build_object(
      'invoice_id', il.invoice_id,
      'invoice_number', il.invoice_number,
      'sale_date', il.sale_date,
      'status', il.status,
      'customer', CASE
        WHEN il.customer_id IS NOT NULL THEN
          jsonb_build_object(
            'customer_id', il.customer_id,
            'name', il.customer_name,
            'phone', il.customer_phone,
            'type', il.customer_type
          )
        ELSE NULL
      END,
      'store', jsonb_build_object(
        'store_id', il.store_id,
        'store_name', il.store_name,
        'store_code', il.store_code
      ),
      'cash_location', CASE
        WHEN il.cash_location_id IS NOT NULL THEN
          jsonb_build_object(
            'cash_location_id', il.cash_location_id,
            'location_name', il.location_name,
            'location_type', il.location_type
          )
        ELSE NULL
      END,
      'payment', jsonb_build_object(
        'method', il.payment_method,
        'status', CASE
          WHEN il.status = 'completed' THEN 'paid'
          WHEN il.status = 'cancelled' THEN 'cancelled'
          ELSE 'pending'
        END
      ),
      'amounts', jsonb_build_object(
        'subtotal', il.subtotal,
        'tax_amount', il.tax_amount,
        'discount_amount', il.discount_amount,
        'total_amount', il.total_amount,
        'total_cost', il.total_cost,
        'profit', il.total_amount - il.total_cost
      ),
      'items_summary', jsonb_build_object(
        'item_count', il.item_count,
        'total_quantity', il.total_quantity,
        'first_product_name', il.first_product_name  -- NEW
      ),
      -- NEW: AI description at root level
      'ai_description', il.ai_description,
      'created_by', CASE
        WHEN il.created_by_id IS NOT NULL THEN
          jsonb_build_object(
            'user_id', il.created_by_id,
            'name', il.created_by_name,
            'email', il.created_by_email
          )
        ELSE NULL
      END,
      'created_at', il.created_at
    ) ORDER BY il.sale_date DESC, il.created_at DESC
  ) INTO v_invoices
  FROM invoice_list il;

  -- Build result
  v_result := jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'invoices', COALESCE(v_invoices, '[]'::jsonb),
      'pagination', jsonb_build_object(
        'page', p_page,
        'limit', p_limit,
        'total', v_total_count,
        'total_pages', CEIL(v_total_count::NUMERIC / p_limit),
        'has_next', (p_page * p_limit) < v_total_count,
        'has_prev', p_page > 1
      ),
      'filters_applied', jsonb_build_object(
        'search', p_search,
        'store_id', p_store_id,
        'date_range', jsonb_build_object(
          'start_date', p_start_date,
          'end_date', p_end_date
        ),
        'timezone', p_timezone
      ),
      'summary', jsonb_build_object(
        'period_total', jsonb_build_object(
          'invoice_count', v_period_invoice_count,
          'total_amount', v_period_total_amount,
          'total_cost', v_period_total_cost,
          'profit', v_period_total_amount - v_period_total_cost,
          'avg_per_invoice', CASE
            WHEN v_period_invoice_count > 0 THEN
              ROUND(v_period_total_amount / v_period_invoice_count, 2)
            ELSE 0
          END
        ),
        'by_status', jsonb_build_object(
          'completed', v_completed_count,
          'draft', v_draft_count,
          'cancelled', v_cancelled_count
        ),
        'by_payment', jsonb_build_object(
          'cash', v_cash_count,
          'card', v_card_count,
          'transfer', v_transfer_count
        )
      ),
      'currency', jsonb_build_object(
        'code', v_currency_code,
        'name', v_currency_name,
        'symbol', v_currency_symbol
      )
    )
  );

  RETURN v_result;
END;
$function$;

-- Add comment for documentation
COMMENT ON FUNCTION get_invoice_page_v2(UUID, UUID, INTEGER, INTEGER, TEXT, DATE, DATE, TEXT) IS '
================================================================================
FUNCTION: get_invoice_page_v2 (v2.1)
================================================================================
Get paginated invoice list with product name and AI description.

NEW FIELDS (v2.1):
- items_summary.first_product_name: First product name for list display
- ai_description: AI summary from linked journal (nullable)

DISPLAY FORMAT:
- 1 product:  "루이비통 벨트"
- N products: "루이비통 벨트 외 N-1건"

PERFORMANCE:
- Uses idx_journal_entries_invoice_id for ai_description lookup
- ~19ms additional query time (not noticeable)
================================================================================
';
