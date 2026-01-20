-- ============================================================================
-- Inventory Optimization V2 - Statistical Approach
-- ============================================================================
-- 목적: 모든 업종에서 작동하는 통계 기반 재고 최적화
-- 접근: 하드코딩(7일/14일) → P10/P25 자동 계산
-- 작성일: 2026-01-12
-- ============================================================================

-- ============================================================================
-- STEP 1: 회사별 임계값 (Company Thresholds)
-- ============================================================================
-- P10 = 긴급 기준 (하위 10%)
-- P25 = 주의 기준 (하위 25%)
-- 샘플 < 30이면 기본값 사용 (7일/14일)
-- ============================================================================

DROP MATERIALIZED VIEW IF EXISTS v_company_reorder_thresholds CASCADE;

CREATE MATERIALIZED VIEW v_company_reorder_thresholds AS
WITH company_samples AS (
    SELECT
        company_id,
        -- 유효한 샘플만 (판매이력 있고 + 재고 있고 + 재주문 필요)
        COUNT(*) FILTER (
            WHERE days_with_sales_90d > 0
              AND current_stock > 0
              AND current_stock < reorder_point_95
        ) as sample_size,

        -- P10 계산 (샘플 있을 때만)
        PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY days_of_inventory)
            FILTER (
                WHERE days_with_sales_90d > 0
                  AND current_stock > 0
                  AND current_stock < reorder_point_95
            ) as calculated_p10,

        -- P25 계산 (샘플 있을 때만)
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY days_of_inventory)
            FILTER (
                WHERE days_with_sales_90d > 0
                  AND current_stock > 0
                  AND current_stock < reorder_point_95
            ) as calculated_p25,

        -- P50 (중앙값) - 참고용
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

    -- 임계값: 샘플 >= 30이면 계산값, 아니면 기본값
    CASE
        WHEN sample_size >= 30 THEN ROUND(calculated_p10::numeric, 1)
        ELSE 7.0  -- 기본값: 7일
    END as critical_days,

    CASE
        WHEN sample_size >= 30 THEN ROUND(calculated_p25::numeric, 1)
        ELSE 14.0  -- 기본값: 14일
    END as warning_days,

    -- 참고용 중앙값
    ROUND(calculated_p50::numeric, 1) as median_days,

    -- 임계값 소스 (디버깅/표시용)
    CASE
        WHEN sample_size >= 30 THEN 'calculated'
        ELSE 'default'
    END as threshold_source,

    -- 원본 계산값 (디버깅용)
    ROUND(calculated_p10::numeric, 2) as raw_p10,
    ROUND(calculated_p25::numeric, 2) as raw_p25

FROM company_samples;

-- 인덱스
CREATE UNIQUE INDEX idx_company_thresholds_company_id
    ON v_company_reorder_thresholds(company_id);

COMMENT ON MATERIALIZED VIEW v_company_reorder_thresholds IS
'회사별 재주문 임계값 (P10=긴급, P25=주의). 샘플 30개 이상이면 통계 계산, 미만이면 기본값(7/14일) 사용';


-- ============================================================================
-- STEP 2: 재고 상태 분류 (Inventory Status)
-- ============================================================================
-- Yes/No 분류만 (정량적 계산은 나중에)
-- - is_stockout: 품절?
-- - is_reorder_needed: 주문 필요?
-- - is_critical: 긴급? (P10 이하)
-- - is_warning: 주의? (P10~P25)
-- - is_overstock: 과잉? (90일 이상)
-- - is_dead_stock: 안 팔림? (90일간 판매 0)
-- ============================================================================

DROP VIEW IF EXISTS v_inventory_status CASCADE;

CREATE VIEW v_inventory_status AS
SELECT
    io.company_id,
    io.product_id,
    io.product_name,
    io.category_id,
    io.category_name,

    -- 기본 데이터
    io.current_stock,
    io.days_of_inventory,
    io.avg_daily_demand,
    io.reorder_point_95,
    io.days_with_sales_90d,
    io.total_sold_90d,

    -- 임계값 (회사별)
    COALESCE(t.critical_days, 7.0) as critical_days,
    COALESCE(t.warning_days, 14.0) as warning_days,
    COALESCE(t.threshold_source, 'default') as threshold_source,

    -- ========================================
    -- Yes/No 분류 (Boolean)
    -- ========================================

    -- 1. 품절?
    (io.current_stock = 0) as is_stockout,

    -- 2. 주문 필요? (재고 < 재주문점)
    (io.current_stock < io.reorder_point_95) as is_reorder_needed,

    -- 3. 긴급? (P10 이하) - 재주문 필요하고 + 재고일 <= P10
    (io.current_stock > 0
     AND io.current_stock < io.reorder_point_95
     AND io.days_of_inventory <= COALESCE(t.critical_days, 7.0)
    ) as is_critical,

    -- 4. 주의? (P10~P25) - 재주문 필요하고 + P10 < 재고일 <= P25
    (io.current_stock > 0
     AND io.current_stock < io.reorder_point_95
     AND io.days_of_inventory > COALESCE(t.critical_days, 7.0)
     AND io.days_of_inventory <= COALESCE(t.warning_days, 14.0)
    ) as is_warning,

    -- 5. 과잉재고? (90일 이상)
    (io.current_stock > 0
     AND io.days_with_sales_90d > 0
     AND io.days_of_inventory > 90
    ) as is_overstock,

    -- 6. 안 팔림? (Dead Stock) - 90일간 판매 없고 재고 있음
    (io.days_with_sales_90d = 0 AND io.current_stock > 0) as is_dead_stock,

    -- ========================================
    -- 상태 라벨 (UI 표시용)
    -- ========================================
    CASE
        WHEN io.current_stock = 0 THEN 'stockout'
        WHEN io.days_with_sales_90d = 0 AND io.current_stock > 0 THEN 'dead_stock'
        WHEN io.current_stock > 0 AND io.days_with_sales_90d > 0 AND io.days_of_inventory > 90 THEN 'overstock'
        WHEN io.current_stock > 0
             AND io.current_stock < io.reorder_point_95
             AND io.days_of_inventory <= COALESCE(t.critical_days, 7.0) THEN 'critical'
        WHEN io.current_stock > 0
             AND io.current_stock < io.reorder_point_95
             AND io.days_of_inventory <= COALESCE(t.warning_days, 14.0) THEN 'warning'
        WHEN io.current_stock < io.reorder_point_95 THEN 'reorder_needed'
        ELSE 'normal'
    END as status_label,

    -- 우선순위 (정렬용): 1=가장 급함, 6=정상
    CASE
        WHEN io.current_stock = 0 THEN 1  -- 품절
        WHEN io.current_stock > 0
             AND io.current_stock < io.reorder_point_95
             AND io.days_of_inventory <= COALESCE(t.critical_days, 7.0) THEN 2  -- 긴급
        WHEN io.current_stock > 0
             AND io.current_stock < io.reorder_point_95
             AND io.days_of_inventory <= COALESCE(t.warning_days, 14.0) THEN 3  -- 주의
        WHEN io.current_stock < io.reorder_point_95 THEN 4  -- 재주문 필요
        WHEN io.days_with_sales_90d = 0 AND io.current_stock > 0 THEN 5  -- Dead Stock
        WHEN io.current_stock > 0 AND io.days_with_sales_90d > 0 AND io.days_of_inventory > 90 THEN 5  -- 과잉
        ELSE 6  -- 정상
    END as priority_rank

FROM inventory_statistic_inventory_optimization io
LEFT JOIN v_company_reorder_thresholds t ON io.company_id = t.company_id;

COMMENT ON VIEW v_inventory_status IS
'재고 상태 Yes/No 분류. is_stockout, is_critical, is_warning, is_overstock, is_dead_stock 등';


-- ============================================================================
-- STEP 3: 회사별 재고 건강도 요약 (Company Health Summary)
-- ============================================================================

DROP VIEW IF EXISTS v_company_inventory_health CASCADE;

CREATE VIEW v_company_inventory_health AS
SELECT
    company_id,

    -- 전체 상품 수
    COUNT(*) as total_products,

    -- 상태별 개수
    COUNT(*) FILTER (WHERE is_stockout) as stockout_count,
    COUNT(*) FILTER (WHERE is_critical) as critical_count,
    COUNT(*) FILTER (WHERE is_warning) as warning_count,
    COUNT(*) FILTER (WHERE is_reorder_needed AND NOT is_stockout) as reorder_needed_count,
    COUNT(*) FILTER (WHERE is_overstock) as overstock_count,
    COUNT(*) FILTER (WHERE is_dead_stock) as dead_stock_count,
    COUNT(*) FILTER (WHERE status_label = 'normal') as normal_count,

    -- 상태별 비율 (%)
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_stockout) / NULLIF(COUNT(*), 0), 1) as stockout_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_critical) / NULLIF(COUNT(*), 0), 1) as critical_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_warning) / NULLIF(COUNT(*), 0), 1) as warning_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_overstock) / NULLIF(COUNT(*), 0), 1) as overstock_rate,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_dead_stock) / NULLIF(COUNT(*), 0), 1) as dead_stock_rate,

    -- 임계값 정보
    MAX(critical_days) as critical_days,
    MAX(warning_days) as warning_days,
    MAX(threshold_source) as threshold_source

FROM v_inventory_status
GROUP BY company_id;

COMMENT ON VIEW v_company_inventory_health IS
'회사별 재고 건강도 요약. 상태별 개수와 비율';


-- ============================================================================
-- STEP 4: 카테고리별 재주문 요약 (Category Reorder Summary)
-- ============================================================================

DROP VIEW IF EXISTS v_category_reorder_summary CASCADE;

CREATE VIEW v_category_reorder_summary AS
SELECT
    company_id,
    category_id,
    category_name,

    -- 전체 상품 수
    COUNT(*) as total_products,

    -- 재주문 관련
    COUNT(*) FILTER (WHERE is_stockout) as stockout_count,
    COUNT(*) FILTER (WHERE is_critical) as critical_count,
    COUNT(*) FILTER (WHERE is_warning) as warning_count,
    COUNT(*) FILTER (WHERE is_reorder_needed) as reorder_needed_count,

    -- 과잉/Dead Stock
    COUNT(*) FILTER (WHERE is_overstock) as overstock_count,
    COUNT(*) FILTER (WHERE is_dead_stock) as dead_stock_count,

    -- 비율
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_reorder_needed) / NULLIF(COUNT(*), 0), 1) as reorder_rate

FROM v_inventory_status
GROUP BY company_id, category_id, category_name
HAVING COUNT(*) > 0;

COMMENT ON VIEW v_category_reorder_summary IS
'카테고리별 재주문 요약. 재주문 필요/긴급/주의 개수';


-- ============================================================================
-- STEP 5: 브랜드별 재주문 요약 (Brand Reorder Summary)
-- ============================================================================

DROP VIEW IF EXISTS v_brand_reorder_summary CASCADE;

CREATE VIEW v_brand_reorder_summary AS
SELECT
    p.company_id,
    p.brand_id,
    b.brand_name,

    -- 전체 상품 수
    COUNT(*) as total_products,

    -- 재주문 관련
    COUNT(*) FILTER (WHERE s.is_stockout) as stockout_count,
    COUNT(*) FILTER (WHERE s.is_critical) as critical_count,
    COUNT(*) FILTER (WHERE s.is_warning) as warning_count,
    COUNT(*) FILTER (WHERE s.is_reorder_needed) as reorder_needed_count,

    -- 과잉/Dead Stock
    COUNT(*) FILTER (WHERE s.is_overstock) as overstock_count,
    COUNT(*) FILTER (WHERE s.is_dead_stock) as dead_stock_count,

    -- 비율
    ROUND(100.0 * COUNT(*) FILTER (WHERE s.is_reorder_needed) / NULLIF(COUNT(*), 0), 1) as reorder_rate

FROM inventory_products p
JOIN v_inventory_status s ON p.product_id = s.product_id
LEFT JOIN inventory_brands b ON p.brand_id = b.brand_id
WHERE p.is_active = true AND p.is_deleted = false
GROUP BY p.company_id, p.brand_id, b.brand_name
HAVING COUNT(*) > 0;

COMMENT ON VIEW v_brand_reorder_summary IS
'브랜드별 재주문 요약. 재주문 필요/긴급/주의 개수';


-- ============================================================================
-- STEP 6: RPC 함수 - 대시보드
-- ============================================================================

DROP FUNCTION IF EXISTS get_inventory_health_dashboard(UUID);

CREATE OR REPLACE FUNCTION get_inventory_health_dashboard(p_company_id UUID)
RETURNS JSON
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_build_object(
        -- 회사 건강도 요약
        'health', (
            SELECT json_build_object(
                'total_products', total_products,
                'stockout_count', stockout_count,
                'stockout_rate', stockout_rate,
                'critical_count', critical_count,
                'critical_rate', critical_rate,
                'warning_count', warning_count,
                'warning_rate', warning_rate,
                'reorder_needed_count', reorder_needed_count,
                'overstock_count', overstock_count,
                'overstock_rate', overstock_rate,
                'dead_stock_count', dead_stock_count,
                'dead_stock_rate', dead_stock_rate,
                'normal_count', normal_count
            )
            FROM v_company_inventory_health
            WHERE company_id = p_company_id
        ),

        -- 임계값 정보
        'thresholds', (
            SELECT json_build_object(
                'critical_days', critical_days,
                'warning_days', warning_days,
                'threshold_source', threshold_source,
                'sample_size', sample_size
            )
            FROM v_company_reorder_thresholds
            WHERE company_id = p_company_id
        ),

        -- 카테고리별 Top 5 (재주문 필요 많은 순)
        'top_categories', (
            SELECT COALESCE(json_agg(row_to_json(t)), '[]'::json)
            FROM (
                SELECT
                    category_id,
                    category_name,
                    total_products,
                    reorder_needed_count,
                    critical_count,
                    warning_count,
                    stockout_count
                FROM v_category_reorder_summary
                WHERE company_id = p_company_id
                  AND reorder_needed_count > 0
                ORDER BY critical_count DESC, reorder_needed_count DESC
                LIMIT 5
            ) t
        ),

        -- 긴급 상품 Top 10 (가장 급한 순)
        'urgent_products', (
            SELECT COALESCE(json_agg(row_to_json(t)), '[]'::json)
            FROM (
                SELECT
                    product_id,
                    product_name,
                    category_name,
                    current_stock,
                    ROUND(days_of_inventory::numeric, 1) as days_of_inventory,
                    status_label
                FROM v_inventory_status
                WHERE company_id = p_company_id
                  AND is_reorder_needed = true
                ORDER BY priority_rank, days_of_inventory
                LIMIT 10
            ) t
        )
    ) INTO v_result;

    RETURN COALESCE(v_result, '{}'::json);
END;
$$;

COMMENT ON FUNCTION get_inventory_health_dashboard IS
'재고 건강도 대시보드. 상태 요약 + 임계값 + Top 카테고리 + 긴급 상품';


-- ============================================================================
-- STEP 7: RPC 함수 - 카테고리별 목록
-- ============================================================================

DROP FUNCTION IF EXISTS get_reorder_by_category(UUID);

CREATE OR REPLACE FUNCTION get_reorder_by_category(p_company_id UUID)
RETURNS JSON
LANGUAGE SQL
STABLE
AS $$
    SELECT COALESCE(json_agg(row_to_json(t)), '[]'::json)
    FROM (
        SELECT
            category_id,
            category_name,
            total_products,
            stockout_count,
            critical_count,
            warning_count,
            reorder_needed_count,
            overstock_count,
            dead_stock_count,
            reorder_rate
        FROM v_category_reorder_summary
        WHERE company_id = p_company_id
        ORDER BY critical_count DESC, reorder_needed_count DESC
    ) t;
$$;

COMMENT ON FUNCTION get_reorder_by_category IS
'카테고리별 재주문 요약 목록';


-- ============================================================================
-- STEP 8: RPC 함수 - 브랜드별 목록
-- ============================================================================

DROP FUNCTION IF EXISTS get_reorder_by_brand(UUID);

CREATE OR REPLACE FUNCTION get_reorder_by_brand(p_company_id UUID)
RETURNS JSON
LANGUAGE SQL
STABLE
AS $$
    SELECT COALESCE(json_agg(row_to_json(t)), '[]'::json)
    FROM (
        SELECT
            brand_id,
            brand_name,
            total_products,
            stockout_count,
            critical_count,
            warning_count,
            reorder_needed_count,
            overstock_count,
            dead_stock_count,
            reorder_rate
        FROM v_brand_reorder_summary
        WHERE company_id = p_company_id
        ORDER BY critical_count DESC, reorder_needed_count DESC
    ) t;
$$;

COMMENT ON FUNCTION get_reorder_by_brand IS
'브랜드별 재주문 요약 목록';


-- ============================================================================
-- STEP 9: RPC 함수 - 상품 목록 (페이지네이션)
-- ============================================================================

DROP FUNCTION IF EXISTS get_reorder_products_paged(UUID, UUID, TEXT, INT, INT);

CREATE OR REPLACE FUNCTION get_reorder_products_paged(
    p_company_id UUID,
    p_category_id UUID DEFAULT NULL,
    p_status_filter TEXT DEFAULT NULL,  -- 'critical', 'warning', 'stockout', 'overstock', 'dead_stock', 'reorder_needed'
    p_page INT DEFAULT 0,
    p_page_size INT DEFAULT 20
)
RETURNS JSON
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_total_count INT;
    v_result JSON;
BEGIN
    -- 전체 개수 계산
    SELECT COUNT(*)
    INTO v_total_count
    FROM v_inventory_status
    WHERE company_id = p_company_id
      AND (p_category_id IS NULL OR category_id = p_category_id)
      AND (
          p_status_filter IS NULL
          OR (p_status_filter = 'critical' AND is_critical = true)
          OR (p_status_filter = 'warning' AND is_warning = true)
          OR (p_status_filter = 'stockout' AND is_stockout = true)
          OR (p_status_filter = 'overstock' AND is_overstock = true)
          OR (p_status_filter = 'dead_stock' AND is_dead_stock = true)
          OR (p_status_filter = 'reorder_needed' AND is_reorder_needed = true)
      );

    -- 페이지 데이터 조회
    SELECT json_build_object(
        'items', COALESCE((
            SELECT json_agg(row_to_json(t))
            FROM (
                SELECT
                    product_id,
                    product_name,
                    category_id,
                    category_name,
                    current_stock,
                    ROUND(days_of_inventory::numeric, 1) as days_of_inventory,
                    ROUND(avg_daily_demand::numeric, 2) as avg_daily_demand,
                    ROUND(reorder_point_95::numeric, 1) as reorder_point,
                    status_label,
                    is_stockout,
                    is_critical,
                    is_warning,
                    is_overstock,
                    is_dead_stock,
                    priority_rank
                FROM v_inventory_status
                WHERE company_id = p_company_id
                  AND (p_category_id IS NULL OR category_id = p_category_id)
                  AND (
                      p_status_filter IS NULL
                      OR (p_status_filter = 'critical' AND is_critical = true)
                      OR (p_status_filter = 'warning' AND is_warning = true)
                      OR (p_status_filter = 'stockout' AND is_stockout = true)
                      OR (p_status_filter = 'overstock' AND is_overstock = true)
                      OR (p_status_filter = 'dead_stock' AND is_dead_stock = true)
                      OR (p_status_filter = 'reorder_needed' AND is_reorder_needed = true)
                  )
                ORDER BY priority_rank, days_of_inventory
                LIMIT p_page_size
                OFFSET p_page * p_page_size
            ) t
        ), '[]'::json),
        'total_count', v_total_count,
        'page', p_page,
        'page_size', p_page_size,
        'has_more', v_total_count > (p_page + 1) * p_page_size
    ) INTO v_result;

    RETURN v_result;
END;
$$;

COMMENT ON FUNCTION get_reorder_products_paged IS
'상품 목록 (페이지네이션). 카테고리/상태 필터 가능';


-- ============================================================================
-- STEP 10: Materialized View 새로고침 함수
-- ============================================================================

DROP FUNCTION IF EXISTS refresh_inventory_optimization_views();

CREATE OR REPLACE FUNCTION refresh_inventory_optimization_views()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    -- 기존 View 새로고침 (있다면)
    REFRESH MATERIALIZED VIEW CONCURRENTLY inventory_statistic_inventory_optimization;

    -- 임계값 View 새로고침
    REFRESH MATERIALIZED VIEW CONCURRENTLY v_company_reorder_thresholds;
END;
$$;

COMMENT ON FUNCTION refresh_inventory_optimization_views IS
'재고 최적화 관련 Materialized View 새로고침';


-- ============================================================================
-- STEP 11: 초기 데이터 새로고침
-- ============================================================================

-- Materialized View 초기 새로고침
REFRESH MATERIALIZED VIEW v_company_reorder_thresholds;


-- ============================================================================
-- 완료!
-- ============================================================================
--
-- 생성된 객체:
--
-- Materialized Views:
--   - v_company_reorder_thresholds: 회사별 P10/P25 임계값
--
-- Views:
--   - v_inventory_status: 상품별 Yes/No 상태 분류
--   - v_company_inventory_health: 회사별 건강도 요약
--   - v_category_reorder_summary: 카테고리별 요약
--   - v_brand_reorder_summary: 브랜드별 요약
--
-- Functions:
--   - get_inventory_health_dashboard(company_id): 대시보드 데이터
--   - get_reorder_by_category(company_id): 카테고리별 목록
--   - get_reorder_by_brand(company_id): 브랜드별 목록
--   - get_reorder_products_paged(...): 상품 목록 (페이지네이션)
--   - refresh_inventory_optimization_views(): View 새로고침
--
-- ============================================================================
