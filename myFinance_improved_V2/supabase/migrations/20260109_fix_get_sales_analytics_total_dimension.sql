-- Fix get_sales_analytics function for p_dimension='total' case
-- The previous_period CTE was missing GROUP BY clause when dimension is 'total'

CREATE OR REPLACE FUNCTION get_sales_analytics(
    p_company_id UUID,
    p_start_date DATE,
    p_end_date DATE,
    p_store_id UUID DEFAULT NULL,
    p_group_by TEXT DEFAULT 'daily',
    p_dimension TEXT DEFAULT 'total',
    p_metric TEXT DEFAULT 'revenue',
    p_top_n INT DEFAULT NULL,
    p_compare_previous BOOLEAN DEFAULT false,
    p_order_by TEXT DEFAULT 'DESC'
)
RETURNS JSON
LANGUAGE plpgsql
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
BEGIN
    IF p_group_by NOT IN ('daily', 'weekly', 'monthly') THEN
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

    v_group_expression := CASE p_group_by
        WHEN 'daily' THEN 'sale_date'
        WHEN 'weekly' THEN 'DATE_TRUNC(''week'', sale_date)::DATE'
        WHEN 'monthly' THEN 'DATE_TRUNC(''month'', sale_date)::DATE'
    END;

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
                %s as period,
                %s,
                SUM(quantity_sold) as total_quantity,
                SUM(revenue) as total_revenue,
                SUM(margin) as total_margin,
                CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END as margin_rate,
                SUM(invoice_count) as invoice_count
            FROM inventory_statistic_sales_daily
            WHERE company_id = %L
              AND sale_date BETWEEN %L AND %L
              AND (%L IS NULL OR store_id = %L)
            GROUP BY %s%s%s
        ),
        previous_period AS (
            SELECT
                %s,
                SUM(quantity_sold) as prev_quantity,
                SUM(revenue) as prev_revenue,
                SUM(margin) as prev_margin
            FROM inventory_statistic_sales_daily
            WHERE company_id = %L
              AND sale_date BETWEEN %L AND %L
              AND (%L IS NULL OR store_id = %L)
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
                'metric', %L
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
        -- current_period
        v_group_expression,
        v_dimension_select,
        p_company_id,
        p_start_date,
        p_end_date,
        p_store_id,
        p_store_id,
        v_group_expression,
        CASE WHEN v_dimension_groupby_full != '' THEN ', ' ELSE '' END,
        v_dimension_groupby_full,
        -- previous_period
        v_dimension_select,
        p_company_id,
        v_previous_start,
        v_previous_end,
        p_store_id,
        p_store_id,
        -- FIX: Use GROUP BY only when dimension is not 'total'
        CASE WHEN v_dimension_groupby_full != '' THEN format('GROUP BY %s', v_dimension_groupby_full) ELSE '' END,
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
        p_metric
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
