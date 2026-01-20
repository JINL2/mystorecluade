-- ============================================================================
-- Fix Inventory Optimization Statistics V2
-- ============================================================================
-- 이전 마이그레이션에서 CASCADE로 삭제된 뷰들 복구 + 수정 적용
--
-- 수정 1: Lead Time 30일 → 10일
-- 수정 2: 건당 표준편차 → 일별 표준편차
-- ============================================================================

-- ============================================================================
-- STEP 1: 기본 통계 뷰 재생성 (일별 stddev, Lead Time = 10)
-- ============================================================================

DROP MATERIALIZED VIEW IF EXISTS inventory_statistic_inventory_optimization CASCADE;

CREATE MATERIALIZED VIEW inventory_statistic_inventory_optimization AS
WITH
-- Step 1: 일별 판매량 집계
daily_sales AS (
    SELECT
        product_id,
        date(created_at_utc) AS sale_date,
        SUM(ABS(quantity_change)) AS daily_qty
    FROM inventory_logs
    WHERE event_type = 'stock_sale'
      AND created_at_utc >= (CURRENT_DATE - '90 days'::interval)
      AND quantity_change < 0
    GROUP BY product_id, date(created_at_utc)
),
-- Step 2: 상품별 일별 통계 (올바른 일별 표준편차)
daily_stats AS (
    SELECT
        product_id,
        COUNT(*) AS days_with_sales,
        SUM(daily_qty) AS total_sold_90d,
        AVG(daily_qty) AS avg_daily_demand,
        STDDEV(daily_qty) AS stddev_daily
    FROM daily_sales
    GROUP BY product_id
),
-- Step 3: 현재 재고 집계
current_stock_agg AS (
    SELECT
        product_id,
        SUM(quantity_on_hand) AS current_stock
    FROM inventory_current_stock
    GROUP BY product_id
)
SELECT
    p.company_id,
    p.product_id,
    p.product_name,
    c.category_id,
    c.category_name,
    COALESCE(cs.current_stock, 0) AS current_stock,
    COALESCE(ds.total_sold_90d, 0) AS total_sold_90d,
    COALESCE(ds.days_with_sales, 0) AS days_with_sales_90d,
    COALESCE(ds.avg_daily_demand, 0) AS avg_daily_demand,
    COALESCE(ds.stddev_daily, 0) AS demand_stddev,
    CASE
        WHEN ds.avg_daily_demand > 0 THEN ds.stddev_daily / ds.avg_daily_demand
        ELSE 0
    END AS demand_cv,
    -- Safety Stock (L=10)
    (1.65 * COALESCE(ds.stddev_daily, 0) * sqrt(10::float)) AS safety_stock_95,
    -- Reorder Point (L=10)
    (
        (COALESCE(ds.avg_daily_demand, 0) * 10)::float
        + (1.65 * COALESCE(ds.stddev_daily, 0) * sqrt(10::float))
    ) AS reorder_point_95,
    -- Inventory Turnover
    CASE
        WHEN cs.current_stock > 0 THEN (ds.total_sold_90d / 90 * 365) / cs.current_stock
        ELSE 0
    END AS inventory_turnover,
    -- Days of Inventory
    CASE
        WHEN ds.avg_daily_demand > 0 THEN cs.current_stock / ds.avg_daily_demand
        ELSE 999
    END AS days_of_inventory
FROM inventory_products p
JOIN inventory_product_categories c ON p.category_id = c.category_id
LEFT JOIN daily_stats ds ON p.product_id = ds.product_id
LEFT JOIN current_stock_agg cs ON p.product_id = cs.product_id
WHERE p.is_active = true AND p.is_deleted = false;

CREATE UNIQUE INDEX idx_inv_stat_opt_product_id ON inventory_statistic_inventory_optimization(product_id);
CREATE INDEX idx_inv_stat_opt_company_id ON inventory_statistic_inventory_optimization(company_id);

-- ============================================================================
-- STEP 2: 회사별 임계값 (P10/P25)
-- ============================================================================

DROP MATERIALIZED VIEW IF EXISTS v_company_reorder_thresholds CASCADE;

CREATE MATERIALIZED VIEW v_company_reorder_thresholds AS
WITH company_samples AS (
    SELECT
        company_id,
        COUNT(*) FILTER (
            WHERE days_with_sales_90d > 0
              AND current_stock > 0
              AND current_stock < reorder_point_95
        ) as sample_size,
        PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY days_of_inventory)
            FILTER (
                WHERE days_with_sales_90d > 0
                  AND current_stock > 0
                  AND current_stock < reorder_point_95
            ) as calculated_p10,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY days_of_inventory)
            FILTER (
                WHERE days_with_sales_90d > 0
                  AND current_stock > 0
                  AND current_stock < reorder_point_95
            ) as calculated_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY days_of_inventory)
            FILTER (
                WHERE days_with_sales_90d > 0
                  AND current_stock > 0
                  AND current_stock < reorder_point_95
            ) as calculated_p50
    FROM inventory_statistic_inventory_optimization
    GROUP BY company_id
)
SELECT
    company_id,
    sample_size,
    CASE WHEN sample_size >= 30 THEN ROUND(calculated_p10::numeric, 1) ELSE 7.0 END as critical_days,
    CASE WHEN sample_size >= 30 THEN ROUND(calculated_p25::numeric, 1) ELSE 14.0 END as warning_days,
    ROUND(calculated_p50::numeric, 1) as median_days,
    CASE WHEN sample_size >= 30 THEN 'calculated' ELSE 'default' END as threshold_source,
    ROUND(calculated_p10::numeric, 2) as raw_p10,
    ROUND(calculated_p25::numeric, 2) as raw_p25
FROM company_samples;

CREATE UNIQUE INDEX idx_company_thresholds_company_id ON v_company_reorder_thresholds(company_id);

-- ============================================================================
-- STEP 3: 재고 상태 분류 뷰
-- ============================================================================

DROP VIEW IF EXISTS v_inventory_status CASCADE;

CREATE VIEW v_inventory_status AS
SELECT
    io.company_id,
    io.product_id,
    io.product_name,
    io.category_id,
    io.category_name,
    io.current_stock,
    io.days_of_inventory,
    io.avg_daily_demand,
    io.reorder_point_95,
    io.days_with_sales_90d,
    io.total_sold_90d,
    COALESCE(t.critical_days, 7.0) as critical_days,
    COALESCE(t.warning_days, 14.0) as warning_days,
    COALESCE(t.threshold_source, 'default') as threshold_source,
    (io.current_stock = 0) as is_stockout,
    (io.current_stock < io.reorder_point_95) as is_reorder_needed,
    (io.current_stock > 0 AND io.current_stock < io.reorder_point_95
     AND io.days_of_inventory <= COALESCE(t.critical_days, 7.0)) as is_critical,
    (io.current_stock > 0 AND io.current_stock < io.reorder_point_95
     AND io.days_of_inventory > COALESCE(t.critical_days, 7.0)
     AND io.days_of_inventory <= COALESCE(t.warning_days, 14.0)) as is_warning,
    (io.current_stock > 0 AND io.days_with_sales_90d > 0 AND io.days_of_inventory > 90) as is_overstock,
    (io.days_with_sales_90d = 0 AND io.current_stock > 0) as is_dead_stock,
    CASE
        WHEN io.current_stock = 0 THEN 'stockout'
        WHEN io.days_with_sales_90d = 0 AND io.current_stock > 0 THEN 'dead_stock'
        WHEN io.current_stock > 0 AND io.days_with_sales_90d > 0 AND io.days_of_inventory > 90 THEN 'overstock'
        WHEN io.current_stock > 0 AND io.current_stock < io.reorder_point_95
             AND io.days_of_inventory <= COALESCE(t.critical_days, 7.0) THEN 'critical'
        WHEN io.current_stock > 0 AND io.current_stock < io.reorder_point_95
             AND io.days_of_inventory <= COALESCE(t.warning_days, 14.0) THEN 'warning'
        WHEN io.current_stock < io.reorder_point_95 THEN 'reorder_needed'
        ELSE 'normal'
    END as status_label,
    CASE
        WHEN io.current_stock = 0 THEN 1
        WHEN io.current_stock > 0 AND io.current_stock < io.reorder_point_95
             AND io.days_of_inventory <= COALESCE(t.critical_days, 7.0) THEN 2
        WHEN io.current_stock > 0 AND io.current_stock < io.reorder_point_95
             AND io.days_of_inventory <= COALESCE(t.warning_days, 14.0) THEN 3
        WHEN io.current_stock < io.reorder_point_95 THEN 4
        WHEN io.days_with_sales_90d = 0 AND io.current_stock > 0 THEN 5
        WHEN io.current_stock > 0 AND io.days_with_sales_90d > 0 AND io.days_of_inventory > 90 THEN 5
        ELSE 6
    END as priority_rank
FROM inventory_statistic_inventory_optimization io
LEFT JOIN v_company_reorder_thresholds t ON io.company_id = t.company_id;

-- ============================================================================
-- STEP 4: 회사별 건강도 요약
-- ============================================================================

DROP VIEW IF EXISTS v_company_inventory_health CASCADE;

CREATE VIEW v_company_inventory_health AS
SELECT
    company_id,
    COUNT(*) as total_products,
    COUNT(*) FILTER (WHERE is_stockout) as stockout_count,
    COUNT(*) FILTER (WHERE is_critical) as critical_count,
    COUNT(*) FILTER (WHERE is_warning) as warning_count,
    COUNT(*) FILTER (WHERE is_reorder_needed AND NOT is_stockout) as reorder_needed_count,
    COUNT(*) FILTER (WHERE is_overstock) as overstock_count,
    COUNT(*) FILTER (WHERE is_dead_stock) as dead_stock_count,
    COUNT(*) FILTER (WHERE status_label = 'normal') as normal_count,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_stockout) / NULLIF(COUNT(*), 0), 1) as stockout_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_critical) / NULLIF(COUNT(*), 0), 1) as critical_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_warning) / NULLIF(COUNT(*), 0), 1) as warning_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_overstock) / NULLIF(COUNT(*), 0), 1) as overstock_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_dead_stock) / NULLIF(COUNT(*), 0), 1) as dead_stock_rate,
    MAX(critical_days) as critical_days,
    MAX(warning_days) as warning_days,
    MAX(threshold_source) as threshold_source
FROM v_inventory_status
GROUP BY company_id;

-- ============================================================================
-- STEP 5: 카테고리별 요약
-- ============================================================================

DROP VIEW IF EXISTS v_category_reorder_summary CASCADE;

CREATE VIEW v_category_reorder_summary AS
SELECT
    company_id,
    category_id,
    category_name,
    COUNT(*) as total_products,
    COUNT(*) FILTER (WHERE is_stockout) as stockout_count,
    COUNT(*) FILTER (WHERE is_critical) as critical_count,
    COUNT(*) FILTER (WHERE is_warning) as warning_count,
    COUNT(*) FILTER (WHERE is_reorder_needed) as reorder_needed_count,
    COUNT(*) FILTER (WHERE is_overstock) as overstock_count,
    COUNT(*) FILTER (WHERE is_dead_stock) as dead_stock_count,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_reorder_needed) / NULLIF(COUNT(*), 0), 1) as reorder_rate
FROM v_inventory_status
GROUP BY company_id, category_id, category_name
HAVING COUNT(*) > 0;

-- ============================================================================
-- STEP 6: 브랜드별 요약
-- ============================================================================

DROP VIEW IF EXISTS v_brand_reorder_summary CASCADE;

CREATE VIEW v_brand_reorder_summary AS
SELECT
    p.company_id,
    p.brand_id,
    b.brand_name,
    COUNT(*) as total_products,
    COUNT(*) FILTER (WHERE s.is_stockout) as stockout_count,
    COUNT(*) FILTER (WHERE s.is_critical) as critical_count,
    COUNT(*) FILTER (WHERE s.is_warning) as warning_count,
    COUNT(*) FILTER (WHERE s.is_reorder_needed) as reorder_needed_count,
    COUNT(*) FILTER (WHERE s.is_overstock) as overstock_count,
    COUNT(*) FILTER (WHERE s.is_dead_stock) as dead_stock_count,
    ROUND(100.0 * COUNT(*) FILTER (WHERE s.is_reorder_needed) / NULLIF(COUNT(*), 0), 1) as reorder_rate
FROM inventory_products p
JOIN v_inventory_status s ON p.product_id = s.product_id
LEFT JOIN inventory_brands b ON p.brand_id = b.brand_id
WHERE p.is_active = true AND p.is_deleted = false
GROUP BY p.company_id, p.brand_id, b.brand_name
HAVING COUNT(*) > 0;

-- ============================================================================
-- 완료!
-- ============================================================================
