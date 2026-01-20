-- ============================================================================
-- Fix Inventory Optimization Statistics
-- ============================================================================
-- 수정 1: Lead Time 30일 → 10일 (실제 평균 6.7일 + 버퍼)
-- 수정 2: 건당 표준편차 → 일별 표준편차 (올바른 Safety Stock 계산)
--
-- 변경 내용:
--   - stddev: 건당 → 일별 (daily_stddev)
--   - safety_stock_95: sqrt(30) → sqrt(10), 일별 stddev 사용
--   - reorder_point_95: × 30 → × 10, 일별 stddev 사용
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
        STDDEV(daily_qty) AS stddev_daily  -- 일별 표준편차 (올바른 방법)
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

    -- 일평균 판매량
    COALESCE(ds.avg_daily_demand, 0) AS avg_daily_demand,

    -- 일별 수요 표준편차 (올바른 방법)
    COALESCE(ds.stddev_daily, 0) AS demand_stddev,

    -- 변동계수 (CV) = stddev / mean
    CASE
        WHEN ds.avg_daily_demand > 0 THEN ds.stddev_daily / ds.avg_daily_demand
        ELSE 0
    END AS demand_cv,

    -- ============================================
    -- 안전재고 (Lead Time = 10일, 일별 stddev)
    -- ============================================
    -- safety_stock = Z × σ_daily × √L = 1.65 × stddev_daily × √10
    (1.65 * COALESCE(ds.stddev_daily, 0) * sqrt(10::float)) AS safety_stock_95,

    -- ============================================
    -- 재주문점 (Lead Time = 10일, 일별 stddev)
    -- ============================================
    -- reorder_point = (avg_daily_demand × L) + safety_stock
    (
        (COALESCE(ds.avg_daily_demand, 0) * 10)::float
        +
        (1.65 * COALESCE(ds.stddev_daily, 0) * sqrt(10::float))
    ) AS reorder_point_95,

    -- 재고회전율
    CASE
        WHEN cs.current_stock > 0 THEN (ds.total_sold_90d / 90 * 365) / cs.current_stock
        ELSE 0
    END AS inventory_turnover,

    -- 재고일수
    CASE
        WHEN ds.avg_daily_demand > 0
        THEN cs.current_stock / ds.avg_daily_demand
        ELSE 999
    END AS days_of_inventory

FROM inventory_products p
JOIN inventory_product_categories c ON p.category_id = c.category_id
LEFT JOIN daily_stats ds ON p.product_id = ds.product_id
LEFT JOIN current_stock_agg cs ON p.product_id = cs.product_id
WHERE p.is_active = true AND p.is_deleted = false;

-- 인덱스 생성
CREATE UNIQUE INDEX idx_inv_stat_opt_product_id
    ON inventory_statistic_inventory_optimization(product_id);

CREATE INDEX idx_inv_stat_opt_company_id
    ON inventory_statistic_inventory_optimization(company_id);

COMMENT ON MATERIALIZED VIEW inventory_statistic_inventory_optimization IS
'재고 최적화 통계. Lead Time=10일, 일별 표준편차 사용. 2026-01-12 수정';
