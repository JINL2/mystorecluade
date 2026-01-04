-- Migration: Add sorting support to inventory page RPC
-- Version: get_inventory_page_v5
-- Date: 2025-01-04

CREATE OR REPLACE FUNCTION get_inventory_page_v5(
    p_company_id UUID,
    p_store_id UUID,
    p_page INTEGER DEFAULT 1,
    p_limit INTEGER DEFAULT 20,
    p_search TEXT DEFAULT NULL,
    p_availability TEXT DEFAULT NULL,
    p_brand_id UUID DEFAULT NULL,
    p_category_id UUID DEFAULT NULL,
    p_sort_by TEXT DEFAULT 'created_at',
    p_sort_direction TEXT DEFAULT 'desc',
    p_timezone TEXT DEFAULT 'Asia/Ho_Chi_Minh'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
/*
================================================================================
FUNCTION: get_inventory_page_v5
VERSION: 5.0
================================================================================
Added sorting support to v4.

--------------------------------------------------------------------------------
NEW PARAMETERS
--------------------------------------------------------------------------------
| Parameter        | Type    | Required | Default      | Description                |
|------------------|---------|----------|--------------|----------------------------|
| p_sort_by        | TEXT    | NO       | 'created_at' | Field to sort by           |
| p_sort_direction | TEXT    | NO       | 'desc'       | Sort direction (asc/desc)  |

--------------------------------------------------------------------------------
SORT OPTIONS
--------------------------------------------------------------------------------
p_sort_by values:
  - 'name': Sort by product_name
  - 'price': Sort by selling_price
  - 'stock': Sort by quantity_on_hand
  - 'created_at': Sort by created_at_utc (default)
  - 'value': Sort by (quantity_on_hand * selling_price)

p_sort_direction values:
  - 'asc': Ascending order
  - 'desc': Descending order (default)
================================================================================
*/
DECLARE
    v_offset INTEGER;
    v_products JSONB;
    v_total_count INTEGER;
    v_total_value NUMERIC;
    v_result JSONB;
    v_currency_code TEXT;
    v_currency_name TEXT;
    v_currency_symbol TEXT;
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

    -- Get total count and total_value for filtered products
    SELECT
        COUNT(*),
        COALESCE(SUM(
            COALESCE(cs.quantity_on_hand, 0) *
            COALESCE(sp.selling_price, p.selling_price, 0)
        ), 0)
    INTO
        v_total_count,
        v_total_value
    FROM inventory_products p
    LEFT JOIN inventory_current_stock cs
        ON p.product_id = cs.product_id
        AND cs.store_id = p_store_id
    LEFT JOIN inventory_store_prices sp
        ON p.product_id = sp.product_id
        AND sp.store_id = p_store_id
        AND sp.is_active = true
    WHERE
        p.company_id = p_company_id
        AND p.is_active = true
        AND p.is_deleted = false
        AND (p_search IS NULL OR (
            p.product_name ILIKE '%' || p_search || '%' OR
            p.sku ILIKE '%' || p_search || '%' OR
            p.barcode = p_search
        ))
        AND (
            p_availability IS NULL
            OR (p_availability = 'in_stock' AND COALESCE(cs.quantity_on_hand, 0) > 0)
            OR (p_availability = 'out_of_stock' AND COALESCE(cs.quantity_on_hand, 0) <= 0)
            OR (p_availability = 'low_stock'
                AND COALESCE(cs.quantity_on_hand, 0) > 0
                AND COALESCE(p.min_stock, 0) > 0
                AND COALESCE(cs.quantity_on_hand, 0) <= p.min_stock)
        )
        AND (p_brand_id IS NULL OR p.brand_id = p_brand_id)
        AND (p_category_id IS NULL OR p.category_id = p_category_id);

    -- Get products with pagination and dynamic sorting
    WITH product_list AS (
        SELECT
            p.product_id,
            p.sku,
            p.barcode,
            p.product_name,
            p.product_type,
            p.unit,
            p.image_urls,
            p.brand_id,
            b.brand_name,
            p.category_id,
            c.category_name,
            COALESCE(cs.quantity_on_hand, 0) as quantity_on_hand,
            COALESCE(cs.quantity_available, 0) as quantity_available,
            COALESCE(cs.quantity_reserved, 0) as quantity_reserved,
            COALESCE(sp.cost_price, p.cost_price) as cost_price,
            COALESCE(sp.selling_price, p.selling_price) as selling_price,
            CASE WHEN sp.price_id IS NOT NULL THEN 'store' ELSE 'default' END as price_source,
            p.is_active,
            p.created_at_utc,
            CASE
                WHEN COALESCE(cs.quantity_on_hand, 0) <= 0 THEN 'out_of_stock'
                WHEN COALESCE(p.min_stock, 0) > 0 AND COALESCE(cs.quantity_on_hand, 0) <= p.min_stock THEN 'low'
                WHEN COALESCE(p.max_stock, 0) > 0 AND COALESCE(cs.quantity_on_hand, 0) > p.max_stock THEN 'overstock'
                ELSE 'normal'
            END as stock_level,
            -- Calculate total value for sorting
            COALESCE(cs.quantity_on_hand, 0) * COALESCE(sp.selling_price, p.selling_price, 0) as total_value
        FROM inventory_products p
        LEFT JOIN inventory_current_stock cs
            ON p.product_id = cs.product_id
            AND cs.store_id = p_store_id
        LEFT JOIN inventory_store_prices sp
            ON p.product_id = sp.product_id
            AND sp.store_id = p_store_id
            AND sp.is_active = true
        LEFT JOIN inventory_brands b
            ON p.brand_id = b.brand_id
        LEFT JOIN inventory_product_categories c
            ON p.category_id = c.category_id
        WHERE
            p.company_id = p_company_id
            AND p.is_active = true
            AND p.is_deleted = false
            AND (p_search IS NULL OR (
                p.product_name ILIKE '%' || p_search || '%' OR
                p.sku ILIKE '%' || p_search || '%' OR
                p.barcode = p_search
            ))
            AND (
                p_availability IS NULL
                OR (p_availability = 'in_stock' AND COALESCE(cs.quantity_on_hand, 0) > 0)
                OR (p_availability = 'out_of_stock' AND COALESCE(cs.quantity_on_hand, 0) <= 0)
                OR (p_availability = 'low_stock'
                    AND COALESCE(cs.quantity_on_hand, 0) > 0
                    AND COALESCE(p.min_stock, 0) > 0
                    AND COALESCE(cs.quantity_on_hand, 0) <= p.min_stock)
            )
            AND (p_brand_id IS NULL OR p.brand_id = p_brand_id)
            AND (p_category_id IS NULL OR p.category_id = p_category_id)
        ORDER BY
            CASE WHEN p_sort_by = 'name' AND p_sort_direction = 'asc' THEN p.product_name END ASC NULLS LAST,
            CASE WHEN p_sort_by = 'name' AND p_sort_direction = 'desc' THEN p.product_name END DESC NULLS LAST,
            CASE WHEN p_sort_by = 'price' AND p_sort_direction = 'asc' THEN COALESCE(sp.selling_price, p.selling_price, 0) END ASC,
            CASE WHEN p_sort_by = 'price' AND p_sort_direction = 'desc' THEN COALESCE(sp.selling_price, p.selling_price, 0) END DESC,
            CASE WHEN p_sort_by = 'stock' AND p_sort_direction = 'asc' THEN COALESCE(cs.quantity_on_hand, 0) END ASC,
            CASE WHEN p_sort_by = 'stock' AND p_sort_direction = 'desc' THEN COALESCE(cs.quantity_on_hand, 0) END DESC,
            CASE WHEN p_sort_by = 'value' AND p_sort_direction = 'asc' THEN COALESCE(cs.quantity_on_hand, 0) * COALESCE(sp.selling_price, p.selling_price, 0) END ASC,
            CASE WHEN p_sort_by = 'value' AND p_sort_direction = 'desc' THEN COALESCE(cs.quantity_on_hand, 0) * COALESCE(sp.selling_price, p.selling_price, 0) END DESC,
            CASE WHEN p_sort_by = 'created_at' AND p_sort_direction = 'asc' THEN p.created_at_utc END ASC,
            CASE WHEN (p_sort_by = 'created_at' OR p_sort_by IS NULL) AND (p_sort_direction = 'desc' OR p_sort_direction IS NULL) THEN p.created_at_utc END DESC
        LIMIT p_limit
        OFFSET v_offset
    )
    SELECT jsonb_agg(
        jsonb_build_object(
            'product_id', pl.product_id,
            'sku', pl.sku,
            'barcode', pl.barcode,
            'product_name', pl.product_name,
            'product_type', pl.product_type,
            'brand_id', pl.brand_id,
            'brand_name', pl.brand_name,
            'category_id', pl.category_id,
            'category_name', pl.category_name,
            'unit', pl.unit,
            'image_urls', COALESCE(pl.image_urls, '[]'::jsonb),
            'created_at', pl.created_at_utc AT TIME ZONE p_timezone,
            'stock', jsonb_build_object(
                'quantity_on_hand', pl.quantity_on_hand,
                'quantity_available', pl.quantity_available,
                'quantity_reserved', pl.quantity_reserved
            ),
            'price', jsonb_build_object(
                'cost', pl.cost_price,
                'selling', pl.selling_price,
                'source', pl.price_source
            ),
            'status', jsonb_build_object(
                'stock_level', pl.stock_level,
                'is_active', pl.is_active
            ),
            'recent_changes', (
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'date', f.event_date_utc AT TIME ZONE p_timezone,
                        'type', f.flow_type,
                        'quantity_change', f.quantity_change,
                        'quantity_after', f.stock_after,
                        'note', f.notes
                    ) ORDER BY f.event_date_utc DESC
                )
                FROM (
                    SELECT
                        event_date_utc,
                        flow_type,
                        quantity_change,
                        stock_after,
                        notes
                    FROM inventory_flow
                    WHERE product_id = pl.product_id
                        AND store_id = p_store_id
                    ORDER BY event_date_utc DESC
                    LIMIT 3
                ) f
            )
        )
    ) INTO v_products
    FROM product_list pl;

    -- Build result
    v_result := jsonb_build_object(
        'success', true,
        'data', jsonb_build_object(
            'products', COALESCE(v_products, '[]'::jsonb),
            'pagination', jsonb_build_object(
                'page', p_page,
                'limit', p_limit,
                'total', v_total_count,
                'total_pages', CEIL(v_total_count::NUMERIC / p_limit),
                'has_next', (p_page * p_limit) < v_total_count
            ),
            'summary', jsonb_build_object(
                'total_value', v_total_value,
                'filtered_count', v_total_count
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
$$;
