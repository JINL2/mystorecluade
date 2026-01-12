-- Add timezone support to get_sales_analytics, get_drill_down_analytics, get_bcg_matrix_v2
-- This fixes the UTC vs local time mismatch issue
--
-- Problem:
--   - inventory_statistic_sales_daily.sale_date = DATE(created_at_utc) -- UTC date
--   - Client sends local date (e.g., Vietnam UTC+7)
--   - Data mismatch due to timezone difference
--
-- Solution:
--   - Read timezone from companies table (no client parameter needed!)
--   - Convert sale_date comparison to use timezone-aware logic
--   - Fallback to 'Asia/Ho_Chi_Minh' if company timezone is null

-- ============================================================================
-- DROP existing functions first (parameter signature changed)
-- ============================================================================
-- Drop all possible overloads to ensure clean replacement
DROP FUNCTION IF EXISTS get_sales_analytics(UUID, DATE, DATE, UUID, TEXT, TEXT, TEXT, TEXT, INT, BOOLEAN, UUID, TEXT);
DROP FUNCTION IF EXISTS get_sales_analytics(UUID, DATE, DATE, UUID, TEXT, TEXT, TEXT, TEXT, INT, BOOLEAN, UUID);

DROP FUNCTION IF EXISTS get_drill_down_analytics(UUID, DATE, DATE, UUID, TEXT, UUID, TEXT);
DROP FUNCTION IF EXISTS get_drill_down_analytics(UUID, DATE, DATE, UUID, TEXT, UUID);

DROP FUNCTION IF EXISTS get_bcg_matrix_v2(UUID, DATE, DATE, UUID, TEXT);
DROP FUNCTION IF EXISTS get_bcg_matrix_v2(UUID, DATE, DATE, UUID);

-- ============================================================================
-- 1. get_sales_analytics - Read timezone from companies table
-- ============================================================================
CREATE OR REPLACE FUNCTION get_sales_analytics(
    p_company_id UUID,
    p_start_date DATE,
    p_end_date DATE,
    p_store_id UUID DEFAULT NULL,
    p_group_by TEXT DEFAULT 'daily',
    p_dimension TEXT DEFAULT 'total',
    p_metric TEXT DEFAULT 'revenue',
    p_order_by TEXT DEFAULT 'DESC',
    p_top_n INT DEFAULT NULL,
    p_compare_previous BOOLEAN DEFAULT false,
    p_category_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
    v_main_query TEXT;
    v_group_expression TEXT;
    v_dimension_select TEXT;
    v_dimension_groupby_full TEXT;
    v_order_column TEXT;
    v_previous_start DATE;
    v_previous_end DATE;
    v_period_days INT;
    v_period_select TEXT;
    v_period_groupby TEXT;
    v_category_filter TEXT;
    v_local_sale_date TEXT;
    v_timezone TEXT;  -- NEW: Read from companies table
BEGIN
    -- NEW: Get timezone from companies table
    SELECT COALESCE(timezone, 'Asia/Ho_Chi_Minh') INTO v_timezone
    FROM companies
    WHERE company_id = p_company_id;

    -- Validate p_group_by: now supports 'total' for no date grouping
    IF p_group_by NOT IN ('daily', 'weekly', 'monthly', 'total') THEN
        RAISE EXCEPTION 'Invalid p_group_by: %', p_group_by;
    END IF;

    IF p_dimension NOT IN ('total', 'category', 'brand', 'product') THEN
        RAISE EXCEPTION 'Invalid p_dimension: %', p_dimension;
    END IF;

    IF p_metric NOT IN ('revenue', 'quantity', 'margin') THEN
        RAISE EXCEPTION 'Invalid p_metric: %', p_metric;
    END IF;

    v_period_days := p_end_date - p_start_date;
    v_previous_end := p_start_date - INTERVAL '1 day';
    v_previous_start := v_previous_end - v_period_days;

    -- Build category filter
    IF p_category_id IS NOT NULL THEN
        v_category_filter := format('AND category_id = %L', p_category_id);
    ELSE
        v_category_filter := '';
    END IF;

    -- Convert UTC sale_date to company timezone for comparison
    -- sale_date is stored as DATE(created_at_utc), so it's in UTC
    v_local_sale_date := format('((sale_date::timestamp AT TIME ZONE ''UTC'' AT TIME ZONE %L)::date)', v_timezone);

    -- Handle group_by = 'total' (no date grouping)
    IF p_group_by = 'total' THEN
        v_period_select := format('%L::DATE as period', p_start_date);
        v_period_groupby := '';
    ELSE
        v_group_expression := CASE p_group_by
            WHEN 'daily' THEN v_local_sale_date
            WHEN 'weekly' THEN 'DATE_TRUNC(''week'', ' || v_local_sale_date || ')::DATE'
            WHEN 'monthly' THEN 'DATE_TRUNC(''month'', ' || v_local_sale_date || ')::DATE'
        END;
        v_period_select := v_group_expression || ' as period';
        v_period_groupby := v_group_expression;
    END IF;

    CASE p_dimension
        WHEN 'total' THEN
            v_dimension_select := '''ALL'' as dimension_id, ''Total'' as dimension_name';
            v_dimension_groupby_full := '';
        WHEN 'category' THEN
            v_dimension_select := 'COALESCE(category_id::TEXT, ''null'') as dimension_id, COALESCE(category_name, ''Unknown'') as dimension_name';
            v_dimension_groupby_full := 'category_id, category_name';
        WHEN 'brand' THEN
            v_dimension_select := 'COALESCE(brand_id::TEXT, ''null'') as dimension_id, COALESCE(brand_name, ''Unknown'') as dimension_name';
            v_dimension_groupby_full := 'brand_id, brand_name';
        WHEN 'product' THEN
            v_dimension_select := 'product_id::TEXT as dimension_id, product_name as dimension_name';
            v_dimension_groupby_full := 'product_id, product_name';
    END CASE;

    v_order_column := CASE p_metric
        WHEN 'revenue' THEN 'total_revenue'
        WHEN 'quantity' THEN 'total_quantity'
        WHEN 'margin' THEN 'total_margin'
    END;

    v_main_query := format($q$
        WITH current_period AS (
            SELECT
                %s,
                %s,
                SUM(quantity_sold) as total_quantity,
                SUM(revenue) as total_revenue,
                SUM(margin) as total_margin,
                CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END as margin_rate,
                SUM(invoice_count) as invoice_count
            FROM inventory_statistic_sales_daily
            WHERE company_id = %L
              AND %s BETWEEN %L AND %L
              AND (%L IS NULL OR store_id = %L)
              %s
            %s
        ),
        previous_period AS (
            SELECT
                %s,
                SUM(quantity_sold) as prev_quantity,
                SUM(revenue) as prev_revenue,
                SUM(margin) as prev_margin
            FROM inventory_statistic_sales_daily
            WHERE company_id = %L
              AND %s BETWEEN %L AND %L
              AND (%L IS NULL OR store_id = %L)
              %s
            %s
        ),
        result AS (
            SELECT
                cp.period,
                cp.dimension_id,
                cp.dimension_name,
                ROUND(cp.total_quantity::numeric, 2) as total_quantity,
                ROUND(cp.total_revenue::numeric, 2) as total_revenue,
                ROUND(cp.total_margin::numeric, 2) as total_margin,
                ROUND(cp.margin_rate::numeric, 2) as margin_rate,
                cp.invoice_count,
                CASE WHEN %L AND pp.prev_revenue > 0
                     THEN ROUND(((cp.total_revenue - pp.prev_revenue) / pp.prev_revenue * 100)::numeric, 2)
                     ELSE NULL END as revenue_growth,
                CASE WHEN %L AND pp.prev_quantity > 0
                     THEN ROUND(((cp.total_quantity - pp.prev_quantity) / pp.prev_quantity * 100)::numeric, 2)
                     ELSE NULL END as quantity_growth,
                CASE WHEN %L AND pp.prev_margin > 0
                     THEN ROUND(((cp.total_margin - pp.prev_margin) / pp.prev_margin * 100)::numeric, 2)
                     ELSE NULL END as margin_growth
            FROM current_period cp
            LEFT JOIN previous_period pp ON cp.dimension_id = pp.dimension_id
            ORDER BY %s %s
            %s
        )
        SELECT json_build_object(
            'success', true,
            'params', json_build_object(
                'start_date', %L,
                'end_date', %L,
                'group_by', %L,
                'dimension', %L,
                'metric', %L,
                'category_id', %L,
                'timezone', %L
            ),
            'summary', (
                SELECT json_build_object(
                    'total_revenue', ROUND(SUM(total_revenue)::numeric, 2),
                    'total_quantity', ROUND(SUM(total_quantity)::numeric, 2),
                    'total_margin', ROUND(SUM(total_margin)::numeric, 2),
                    'avg_margin_rate', ROUND(AVG(margin_rate)::numeric, 2),
                    'record_count', COUNT(*)
                )
                FROM result
            ),
            'data', COALESCE((SELECT json_agg(row_to_json(r)) FROM result r), '[]'::json)
        )
    $q$,
        -- current_period SELECT
        v_period_select,
        v_dimension_select,
        p_company_id,
        v_local_sale_date,
        p_start_date,
        p_end_date,
        p_store_id,
        p_store_id,
        v_category_filter,
        -- current_period GROUP BY
        CASE
            WHEN v_period_groupby = '' AND v_dimension_groupby_full = '' THEN ''
            WHEN v_period_groupby = '' THEN 'GROUP BY ' || v_dimension_groupby_full
            WHEN v_dimension_groupby_full = '' THEN 'GROUP BY ' || v_period_groupby
            ELSE 'GROUP BY ' || v_period_groupby || ', ' || v_dimension_groupby_full
        END,
        -- previous_period SELECT
        v_dimension_select,
        p_company_id,
        v_local_sale_date,
        v_previous_start,
        v_previous_end,
        p_store_id,
        p_store_id,
        v_category_filter,
        -- previous_period GROUP BY
        CASE WHEN v_dimension_groupby_full != '' THEN 'GROUP BY ' || v_dimension_groupby_full ELSE '' END,
        -- growth calculations
        p_compare_previous,
        p_compare_previous,
        p_compare_previous,
        -- order and limit
        v_order_column,
        p_order_by,
        CASE WHEN p_top_n IS NOT NULL THEN format('LIMIT %s', p_top_n) ELSE '' END,
        -- params
        p_start_date,
        p_end_date,
        p_group_by,
        p_dimension,
        p_metric,
        p_category_id,
        v_timezone
    );

    EXECUTE v_main_query INTO v_result;
    RETURN v_result;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'detail', SQLSTATE
    );
END;
$$;

-- ============================================================================
-- 2. get_drill_down_analytics - Read timezone from companies table
-- ============================================================================
CREATE OR REPLACE FUNCTION get_drill_down_analytics(
    p_company_id UUID,
    p_start_date DATE,
    p_end_date DATE,
    p_store_id UUID DEFAULT NULL,
    p_level TEXT DEFAULT 'category',
    p_parent_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
    v_timezone TEXT;  -- NEW: Read from companies table
BEGIN
    -- NEW: Get timezone from companies table
    SELECT COALESCE(timezone, 'Asia/Ho_Chi_Minh') INTO v_timezone
    FROM companies
    WHERE company_id = p_company_id;

    -- Validate level
    IF p_level NOT IN ('category', 'brand', 'product') THEN
        RAISE EXCEPTION 'Invalid p_level: %. Must be category, brand, or product', p_level;
    END IF;

    IF p_level = 'category' THEN
        SELECT json_build_object(
            'success', true,
            'level', p_level,
            'parent_id', p_parent_id,
            'timezone', v_timezone,
            'data', COALESCE((
                SELECT json_agg(row_to_json(t) ORDER BY t.total_revenue DESC)
                FROM (
                    SELECT
                        COALESCE(category_id::TEXT, 'null') as item_id,
                        COALESCE(category_name, 'Unknown') as item_name,
                        'category' as item_type,
                        ROUND(SUM(quantity_sold)::numeric, 2) as total_quantity,
                        ROUND(SUM(revenue)::numeric, 2) as total_revenue,
                        ROUND(SUM(margin)::numeric, 2) as total_margin,
                        ROUND(CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END::numeric, 2) as margin_rate,
                        true as has_children
                    FROM inventory_statistic_sales_daily
                    WHERE company_id = p_company_id
                      AND ((sale_date::timestamp AT TIME ZONE 'UTC' AT TIME ZONE v_timezone)::date) BETWEEN p_start_date AND p_end_date
                      AND (p_store_id IS NULL OR store_id = p_store_id)
                    GROUP BY category_id, category_name
                ) t
            ), '[]'::json)
        ) INTO v_result;

    ELSIF p_level = 'brand' THEN
        SELECT json_build_object(
            'success', true,
            'level', p_level,
            'parent_id', p_parent_id,
            'timezone', v_timezone,
            'data', COALESCE((
                SELECT json_agg(row_to_json(t) ORDER BY t.total_revenue DESC)
                FROM (
                    SELECT
                        COALESCE(brand_id::TEXT, 'null') as item_id,
                        COALESCE(brand_name, 'Unknown') as item_name,
                        'brand' as item_type,
                        ROUND(SUM(quantity_sold)::numeric, 2) as total_quantity,
                        ROUND(SUM(revenue)::numeric, 2) as total_revenue,
                        ROUND(SUM(margin)::numeric, 2) as total_margin,
                        ROUND(CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END::numeric, 2) as margin_rate,
                        true as has_children
                    FROM inventory_statistic_sales_daily
                    WHERE company_id = p_company_id
                      AND ((sale_date::timestamp AT TIME ZONE 'UTC' AT TIME ZONE v_timezone)::date) BETWEEN p_start_date AND p_end_date
                      AND (p_store_id IS NULL OR store_id = p_store_id)
                      AND (p_parent_id IS NULL OR category_id = p_parent_id)
                    GROUP BY brand_id, brand_name
                ) t
            ), '[]'::json)
        ) INTO v_result;

    ELSIF p_level = 'product' THEN
        SELECT json_build_object(
            'success', true,
            'level', p_level,
            'parent_id', p_parent_id,
            'timezone', v_timezone,
            'data', COALESCE((
                SELECT json_agg(row_to_json(t) ORDER BY t.total_revenue DESC)
                FROM (
                    SELECT
                        product_id::TEXT as item_id,
                        product_name as item_name,
                        'product' as item_type,
                        ROUND(SUM(quantity_sold)::numeric, 2) as total_quantity,
                        ROUND(SUM(revenue)::numeric, 2) as total_revenue,
                        ROUND(SUM(margin)::numeric, 2) as total_margin,
                        ROUND(CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END::numeric, 2) as margin_rate,
                        false as has_children
                    FROM inventory_statistic_sales_daily
                    WHERE company_id = p_company_id
                      AND ((sale_date::timestamp AT TIME ZONE 'UTC' AT TIME ZONE v_timezone)::date) BETWEEN p_start_date AND p_end_date
                      AND (p_store_id IS NULL OR store_id = p_store_id)
                      AND (p_parent_id IS NULL OR brand_id = p_parent_id)
                    GROUP BY product_id, product_name
                ) t
            ), '[]'::json)
        ) INTO v_result;
    END IF;

    RETURN v_result;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'detail', SQLSTATE
    );
END;
$$;

-- ============================================================================
-- 3. get_bcg_matrix_v2 - Read timezone from companies table
-- ============================================================================
CREATE OR REPLACE FUNCTION get_bcg_matrix_v2(
    p_company_id UUID,
    p_start_date DATE,
    p_end_date DATE,
    p_store_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
    v_median_margin NUMERIC;
    v_median_revenue_pct NUMERIC;
    v_total_revenue NUMERIC;
    v_timezone TEXT;  -- NEW: Read from companies table
BEGIN
    -- NEW: Get timezone from companies table
    SELECT COALESCE(timezone, 'Asia/Ho_Chi_Minh') INTO v_timezone
    FROM companies
    WHERE company_id = p_company_id;

    -- Calculate total revenue for percentage calculation
    SELECT COALESCE(SUM(revenue), 0) INTO v_total_revenue
    FROM inventory_statistic_sales_daily
    WHERE company_id = p_company_id
      AND ((sale_date::timestamp AT TIME ZONE 'UTC' AT TIME ZONE v_timezone)::date) BETWEEN p_start_date AND p_end_date
      AND (p_store_id IS NULL OR store_id = p_store_id);

    IF v_total_revenue = 0 THEN
        RETURN json_build_object(
            'success', true,
            'star', '[]'::json,
            'cash_cow', '[]'::json,
            'problem_child', '[]'::json,
            'dog', '[]'::json,
            'timezone', v_timezone
        );
    END IF;

    -- Calculate medians for BCG classification
    WITH category_stats AS (
        SELECT
            category_id,
            category_name,
            SUM(revenue) as total_revenue,
            SUM(quantity_sold) as total_quantity,
            SUM(margin) as total_margin,
            CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END as margin_rate_pct,
            SUM(revenue) / NULLIF(v_total_revenue, 0) * 100 as revenue_pct
        FROM inventory_statistic_sales_daily
        WHERE company_id = p_company_id
          AND ((sale_date::timestamp AT TIME ZONE 'UTC' AT TIME ZONE v_timezone)::date) BETWEEN p_start_date AND p_end_date
          AND (p_store_id IS NULL OR store_id = p_store_id)
          AND category_id IS NOT NULL
        GROUP BY category_id, category_name
    )
    SELECT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY margin_rate_pct),
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue_pct)
    INTO v_median_margin, v_median_revenue_pct
    FROM category_stats;

    -- Build BCG matrix result
    WITH category_data AS (
        SELECT
            category_id,
            category_name,
            SUM(revenue) as total_revenue,
            SUM(quantity_sold) as total_quantity,
            SUM(margin) as total_margin,
            CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END as margin_rate_pct,
            SUM(revenue) / NULLIF(v_total_revenue, 0) * 100 as revenue_pct,
            PERCENT_RANK() OVER (ORDER BY SUM(quantity_sold)) * 100 as sales_volume_percentile,
            PERCENT_RANK() OVER (ORDER BY CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END) * 100 as margin_percentile
        FROM inventory_statistic_sales_daily
        WHERE company_id = p_company_id
          AND ((sale_date::timestamp AT TIME ZONE 'UTC' AT TIME ZONE v_timezone)::date) BETWEEN p_start_date AND p_end_date
          AND (p_store_id IS NULL OR store_id = p_store_id)
          AND category_id IS NOT NULL
        GROUP BY category_id, category_name
    ),
    classified AS (
        SELECT
            *,
            CASE
                WHEN margin_rate_pct >= v_median_margin AND revenue_pct >= v_median_revenue_pct THEN 'star'
                WHEN margin_rate_pct < v_median_margin AND revenue_pct >= v_median_revenue_pct THEN 'cash_cow'
                WHEN margin_rate_pct >= v_median_margin AND revenue_pct < v_median_revenue_pct THEN 'problem_child'
                ELSE 'dog'
            END as quadrant
        FROM category_data
    )
    SELECT json_build_object(
        'success', true,
        'timezone', v_timezone,
        'star', COALESCE((SELECT json_agg(row_to_json(t)) FROM classified t WHERE quadrant = 'star'), '[]'::json),
        'cash_cow', COALESCE((SELECT json_agg(row_to_json(t)) FROM classified t WHERE quadrant = 'cash_cow'), '[]'::json),
        'problem_child', COALESCE((SELECT json_agg(row_to_json(t)) FROM classified t WHERE quadrant = 'problem_child'), '[]'::json),
        'dog', COALESCE((SELECT json_agg(row_to_json(t)) FROM classified t WHERE quadrant = 'dog'), '[]'::json)
    ) INTO v_result;

    RETURN v_result;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'detail', SQLSTATE
    );
END;
$$;
