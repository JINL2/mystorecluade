# Sales Analytics V2 - Complete Technical Specification

> **Version**: 2.0
> **Created**: 2026-01-09
> **Author**: 30-Year DB Architect Edition
> **Status**: Ready for Implementation

---

## 1. Executive Summary

### 1.1 Purpose
Sales Dashboard 페이지에 **시간 범위 선택**, **Top 10 Products**, **Time Series Chart** 기능을 추가하여 더 유연한 매출 분석을 제공합니다.

### 1.2 Design Philosophy
- **MV 남용 금지**: Materialized View 대신 일반 테이블 + 트리거 사용
- **RPC 통합**: 8개 함수 → 3개 유연한 함수로 통합
- **기존 시스템 유지**: 현재 동작하는 기능 변경 없음
- **점진적 확장**: 새 기능만 추가

### 1.3 Key Metrics
| 항목 | 기존 | 신규 |
|------|------|------|
| 테이블 | 0 | 1 (일별 집계) |
| Materialized Views | 4 (유지) | 0 (추가 없음) |
| RPC Functions | 7 (유지) | 3 (신규) |
| 트리거 | 0 | 1 |

---

## 2. Current State Analysis

### 2.1 Existing Database Objects

#### Tables (유지)
```
inventory_logs          - 모든 재고 변동 기록 (원본)
inventory_products      - 상품 마스터
inventory_brands        - 브랜드 마스터
inventory_product_categories - 카테고리 마스터
```

#### Materialized Views (유지 - 변경 없음)
```
inventory_statistic_sales_by_category_monthly    - BCG Matrix용
inventory_statistic_discrepancy_monthly          - 불일치 분석용
inventory_statistic_inventory_optimization       - 재고 최적화용
inventory_statistic_supply_chain_product_errors  - 공급망 오류용
```

#### RPC Functions (유지 - 변경 없음)
```
get_sales_dashboard              - 이번달/지난달 비교
get_bcg_matrix                   - BCG 매트릭스
get_category_detail              - 카테고리 상세
get_supply_chain_status          - 공급망 상태
get_discrepancy_overview         - 불일치 개요
get_inventory_optimization_dashboard - 재고 최적화
get_inventory_reorder_list       - 재주문 목록
```

### 2.2 Data Statistics
```sql
-- inventory_logs 현황 (2026-01-09 기준)
총 판매 로그: 2,304건
기간: 2025-09-06 ~ 2026-01-09 (약 4개월)
회사 수: 4개
상품 수: 840개
```

### 2.3 Existing Indexes (inventory_logs)
```sql
idx_inventory_logs_company       - company_id
idx_inventory_logs_store         - store_id (partial)
idx_inventory_logs_product       - product_id (partial)
idx_inventory_logs_event         - (event_category, event_type)
idx_inventory_logs_created_at    - created_at_utc DESC
idx_logs_sale_company_date       - (company_id, created_at_utc) WHERE event_type='stock_sale'
```

---

## 3. New Database Objects

### 3.1 Daily Statistics Table

#### 3.1.1 Table Definition

```sql
-- =====================================================
-- inventory_statistic_sales_daily
-- 일별 상품별 매출 집계 테이블
-- =====================================================

CREATE TABLE IF NOT EXISTS inventory_statistic_sales_daily (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Dimensions (Composite Unique Key)
    company_id UUID NOT NULL REFERENCES companies(company_id),
    store_id UUID REFERENCES stores(store_id),  -- NULL = 전사
    sale_date DATE NOT NULL,
    product_id UUID NOT NULL REFERENCES inventory_products(product_id),

    -- Denormalized for performance (avoid JOINs)
    category_id UUID,
    category_name VARCHAR(255),
    brand_id UUID,
    brand_name VARCHAR(255),
    product_name VARCHAR(255),

    -- Metrics
    quantity_sold NUMERIC(15,2) DEFAULT 0,
    revenue NUMERIC(15,2) DEFAULT 0,
    cost NUMERIC(15,2) DEFAULT 0,
    margin NUMERIC(15,2) DEFAULT 0,
    margin_rate NUMERIC(5,2) DEFAULT 0,

    -- Invoice count (for average calculation)
    invoice_count INT DEFAULT 0,

    -- Audit
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Unique constraint for upsert
    CONSTRAINT uq_sales_daily_key
        UNIQUE(company_id, store_id, sale_date, product_id)
);

-- Enable RLS
ALTER TABLE inventory_statistic_sales_daily ENABLE ROW LEVEL SECURITY;

-- RLS Policy
CREATE POLICY "Users can view their company data"
ON inventory_statistic_sales_daily
FOR SELECT
USING (
    company_id IN (
        SELECT (c->>'company_id')::uuid
        FROM users u,
        LATERAL jsonb_array_elements(u.companies) AS c
        WHERE u.id = auth.uid()
    )
);
```

#### 3.1.2 Indexes

```sql
-- Primary access patterns
CREATE INDEX idx_stat_daily_company_date
ON inventory_statistic_sales_daily(company_id, sale_date DESC);

CREATE INDEX idx_stat_daily_company_store_date
ON inventory_statistic_sales_daily(company_id, store_id, sale_date DESC)
WHERE store_id IS NOT NULL;

-- Dimension-based queries
CREATE INDEX idx_stat_daily_category
ON inventory_statistic_sales_daily(company_id, category_id, sale_date DESC)
WHERE category_id IS NOT NULL;

CREATE INDEX idx_stat_daily_brand
ON inventory_statistic_sales_daily(company_id, brand_id, sale_date DESC)
WHERE brand_id IS NOT NULL;

CREATE INDEX idx_stat_daily_product
ON inventory_statistic_sales_daily(company_id, product_id, sale_date DESC);

-- Top N queries (revenue/quantity sorting)
CREATE INDEX idx_stat_daily_revenue
ON inventory_statistic_sales_daily(company_id, sale_date, revenue DESC);

CREATE INDEX idx_stat_daily_quantity
ON inventory_statistic_sales_daily(company_id, sale_date, quantity_sold DESC);
```

### 3.2 Trigger Function

```sql
-- =====================================================
-- fn_update_sales_daily
-- inventory_logs INSERT 시 자동으로 일별 집계 업데이트
-- =====================================================

CREATE OR REPLACE FUNCTION fn_update_sales_daily()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_sale_date DATE;
    v_product RECORD;
BEGIN
    -- Only process stock_sale events with negative quantity (actual sales)
    IF NEW.event_type != 'stock_sale' OR NEW.quantity_change >= 0 THEN
        RETURN NEW;
    END IF;

    -- Calculate sale date
    v_sale_date := DATE(NEW.created_at_utc);

    -- Get product details (denormalized data)
    SELECT
        p.product_name,
        p.category_id,
        c.category_name,
        p.brand_id,
        b.brand_name,
        p.selling_price,
        COALESCE(NEW.cost_after, p.cost_price, 0) as unit_cost
    INTO v_product
    FROM inventory_products p
    LEFT JOIN inventory_product_categories c ON p.category_id = c.category_id
    LEFT JOIN inventory_brands b ON p.brand_id = b.brand_id
    WHERE p.product_id = NEW.product_id;

    -- If product not found, skip
    IF NOT FOUND THEN
        RETURN NEW;
    END IF;

    -- Upsert into daily statistics
    INSERT INTO inventory_statistic_sales_daily (
        company_id,
        store_id,
        sale_date,
        product_id,
        category_id,
        category_name,
        brand_id,
        brand_name,
        product_name,
        quantity_sold,
        revenue,
        cost,
        margin,
        margin_rate,
        invoice_count,
        updated_at
    )
    VALUES (
        NEW.company_id,
        NEW.store_id,
        v_sale_date,
        NEW.product_id,
        v_product.category_id,
        v_product.category_name,
        v_product.brand_id,
        v_product.brand_name,
        v_product.product_name,
        ABS(NEW.quantity_change),
        ABS(NEW.quantity_change) * v_product.selling_price,
        ABS(NEW.quantity_change) * v_product.unit_cost,
        ABS(NEW.quantity_change) * (v_product.selling_price - v_product.unit_cost),
        CASE
            WHEN v_product.selling_price > 0
            THEN ((v_product.selling_price - v_product.unit_cost) / v_product.selling_price * 100)
            ELSE 0
        END,
        CASE WHEN NEW.invoice_id IS NOT NULL THEN 1 ELSE 0 END,
        NOW()
    )
    ON CONFLICT (company_id, store_id, sale_date, product_id)
    DO UPDATE SET
        quantity_sold = inventory_statistic_sales_daily.quantity_sold + ABS(NEW.quantity_change),
        revenue = inventory_statistic_sales_daily.revenue + ABS(NEW.quantity_change) * v_product.selling_price,
        cost = inventory_statistic_sales_daily.cost + ABS(NEW.quantity_change) * v_product.unit_cost,
        margin = inventory_statistic_sales_daily.margin + ABS(NEW.quantity_change) * (v_product.selling_price - v_product.unit_cost),
        margin_rate = CASE
            WHEN (inventory_statistic_sales_daily.revenue + ABS(NEW.quantity_change) * v_product.selling_price) > 0
            THEN ((inventory_statistic_sales_daily.margin + ABS(NEW.quantity_change) * (v_product.selling_price - v_product.unit_cost))
                  / (inventory_statistic_sales_daily.revenue + ABS(NEW.quantity_change) * v_product.selling_price) * 100)
            ELSE 0
        END,
        invoice_count = inventory_statistic_sales_daily.invoice_count +
            CASE WHEN NEW.invoice_id IS NOT NULL THEN 1 ELSE 0 END,
        updated_at = NOW();

    RETURN NEW;
END;
$$;

-- Create trigger
DROP TRIGGER IF EXISTS trg_inventory_logs_sales_daily ON inventory_logs;
CREATE TRIGGER trg_inventory_logs_sales_daily
AFTER INSERT ON inventory_logs
FOR EACH ROW
EXECUTE FUNCTION fn_update_sales_daily();
```

### 3.3 Backfill Function

```sql
-- =====================================================
-- fn_backfill_sales_daily
-- 기존 데이터를 일별 집계 테이블에 채우기
-- =====================================================

CREATE OR REPLACE FUNCTION fn_backfill_sales_daily(
    p_company_id UUID DEFAULT NULL,
    p_start_date DATE DEFAULT '2025-01-01',
    p_end_date DATE DEFAULT CURRENT_DATE
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_inserted INT := 0;
    v_updated INT := 0;
BEGIN
    -- Insert/Update daily statistics from inventory_logs
    INSERT INTO inventory_statistic_sales_daily (
        company_id,
        store_id,
        sale_date,
        product_id,
        category_id,
        category_name,
        brand_id,
        brand_name,
        product_name,
        quantity_sold,
        revenue,
        cost,
        margin,
        margin_rate,
        invoice_count
    )
    SELECT
        il.company_id,
        il.store_id,
        DATE(il.created_at_utc) as sale_date,
        il.product_id,
        p.category_id,
        c.category_name,
        p.brand_id,
        b.brand_name,
        p.product_name,
        SUM(ABS(il.quantity_change)) as quantity_sold,
        SUM(ABS(il.quantity_change) * p.selling_price) as revenue,
        SUM(ABS(il.quantity_change) * COALESCE(il.cost_after, p.cost_price, 0)) as cost,
        SUM(ABS(il.quantity_change) * (p.selling_price - COALESCE(il.cost_after, p.cost_price, 0))) as margin,
        CASE
            WHEN SUM(ABS(il.quantity_change) * p.selling_price) > 0
            THEN SUM(ABS(il.quantity_change) * (p.selling_price - COALESCE(il.cost_after, p.cost_price, 0)))
                 / SUM(ABS(il.quantity_change) * p.selling_price) * 100
            ELSE 0
        END as margin_rate,
        COUNT(DISTINCT il.invoice_id) as invoice_count
    FROM inventory_logs il
    JOIN inventory_products p ON il.product_id = p.product_id
    LEFT JOIN inventory_product_categories c ON p.category_id = c.category_id
    LEFT JOIN inventory_brands b ON p.brand_id = b.brand_id
    WHERE il.event_type = 'stock_sale'
      AND il.quantity_change < 0
      AND DATE(il.created_at_utc) BETWEEN p_start_date AND p_end_date
      AND (p_company_id IS NULL OR il.company_id = p_company_id)
    GROUP BY
        il.company_id,
        il.store_id,
        DATE(il.created_at_utc),
        il.product_id,
        p.category_id,
        c.category_name,
        p.brand_id,
        b.brand_name,
        p.product_name
    ON CONFLICT (company_id, store_id, sale_date, product_id)
    DO UPDATE SET
        quantity_sold = EXCLUDED.quantity_sold,
        revenue = EXCLUDED.revenue,
        cost = EXCLUDED.cost,
        margin = EXCLUDED.margin,
        margin_rate = EXCLUDED.margin_rate,
        invoice_count = EXCLUDED.invoice_count,
        updated_at = NOW();

    GET DIAGNOSTICS v_inserted = ROW_COUNT;

    RETURN json_build_object(
        'success', true,
        'rows_affected', v_inserted,
        'start_date', p_start_date,
        'end_date', p_end_date
    );
END;
$$;
```

---

## 4. RPC Functions (3개 신규)

### 4.1 get_sales_analytics (통합 분석 함수)

```sql
-- =====================================================
-- get_sales_analytics
-- 통합 매출 분석 함수 (Top N, Time Series, Growth 등)
-- =====================================================

CREATE OR REPLACE FUNCTION get_sales_analytics(
    -- Required
    p_company_id UUID,

    -- Time Range
    p_start_date DATE DEFAULT (CURRENT_DATE - INTERVAL '30 days')::DATE,
    p_end_date DATE DEFAULT CURRENT_DATE,
    p_store_id UUID DEFAULT NULL,

    -- Grouping
    p_group_by TEXT DEFAULT 'daily',     -- 'daily', 'weekly', 'monthly'
    p_dimension TEXT DEFAULT 'total',    -- 'total', 'category', 'brand', 'product'

    -- Metrics & Sorting
    p_metric TEXT DEFAULT 'revenue',     -- 'revenue', 'quantity', 'margin'
    p_order_by TEXT DEFAULT 'DESC',      -- 'ASC', 'DESC'
    p_top_n INT DEFAULT NULL,            -- NULL = all, number = limit

    -- Comparison
    p_compare_previous BOOLEAN DEFAULT FALSE
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
    v_main_query TEXT;
    v_group_expression TEXT;
    v_dimension_columns TEXT;
    v_dimension_group TEXT;
    v_order_column TEXT;
    v_previous_start DATE;
    v_previous_end DATE;
    v_period_days INT;
BEGIN
    -- Validate parameters
    IF p_group_by NOT IN ('daily', 'weekly', 'monthly') THEN
        RAISE EXCEPTION 'Invalid p_group_by: %. Must be daily, weekly, or monthly', p_group_by;
    END IF;

    IF p_dimension NOT IN ('total', 'category', 'brand', 'product') THEN
        RAISE EXCEPTION 'Invalid p_dimension: %. Must be total, category, brand, or product', p_dimension;
    END IF;

    IF p_metric NOT IN ('revenue', 'quantity', 'margin') THEN
        RAISE EXCEPTION 'Invalid p_metric: %. Must be revenue, quantity, or margin', p_metric;
    END IF;

    -- Calculate previous period for comparison
    v_period_days := p_end_date - p_start_date;
    v_previous_end := p_start_date - INTERVAL '1 day';
    v_previous_start := v_previous_end - v_period_days;

    -- Set group expression based on p_group_by
    v_group_expression := CASE p_group_by
        WHEN 'daily' THEN 'sale_date'
        WHEN 'weekly' THEN 'DATE_TRUNC(''week'', sale_date)::DATE'
        WHEN 'monthly' THEN 'DATE_TRUNC(''month'', sale_date)::DATE'
    END;

    -- Set dimension columns based on p_dimension
    v_dimension_columns := CASE p_dimension
        WHEN 'total' THEN '''ALL'' as dimension_id, ''Total'' as dimension_name'
        WHEN 'category' THEN 'category_id::TEXT as dimension_id, category_name as dimension_name'
        WHEN 'brand' THEN 'brand_id::TEXT as dimension_id, brand_name as dimension_name'
        WHEN 'product' THEN 'product_id::TEXT as dimension_id, product_name as dimension_name'
    END;

    -- Set dimension grouping
    v_dimension_group := CASE p_dimension
        WHEN 'total' THEN ''
        WHEN 'category' THEN ', category_id, category_name'
        WHEN 'brand' THEN ', brand_id, brand_name'
        WHEN 'product' THEN ', product_id, product_name'
    END;

    -- Set order column
    v_order_column := CASE p_metric
        WHEN 'revenue' THEN 'total_revenue'
        WHEN 'quantity' THEN 'total_quantity'
        WHEN 'margin' THEN 'total_margin'
    END;

    -- Build and execute main query
    v_main_query := format($q$
        WITH current_period AS (
            SELECT
                %s as period,
                %s,
                SUM(quantity_sold) as total_quantity,
                SUM(revenue) as total_revenue,
                SUM(margin) as total_margin,
                CASE WHEN SUM(revenue) > 0
                     THEN SUM(margin) / SUM(revenue) * 100
                     ELSE 0
                END as margin_rate,
                SUM(invoice_count) as invoice_count
            FROM inventory_statistic_sales_daily
            WHERE company_id = %L
              AND sale_date BETWEEN %L AND %L
              AND (%L IS NULL OR store_id = %L)
              AND (%s IS NOT NULL OR %L = 'total')
            GROUP BY %s %s
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
              AND (%s IS NOT NULL OR %L = 'total')
            GROUP BY 1
        ),
        result AS (
            SELECT
                cp.period,
                cp.dimension_id,
                cp.dimension_name,
                cp.total_quantity,
                cp.total_revenue,
                cp.total_margin,
                ROUND(cp.margin_rate::numeric, 2) as margin_rate,
                cp.invoice_count,
                CASE WHEN %L AND pp.prev_revenue > 0
                     THEN ROUND(((cp.total_revenue - pp.prev_revenue) / pp.prev_revenue * 100)::numeric, 2)
                     ELSE NULL
                END as revenue_growth,
                CASE WHEN %L AND pp.prev_quantity > 0
                     THEN ROUND(((cp.total_quantity - pp.prev_quantity) / pp.prev_quantity * 100)::numeric, 2)
                     ELSE NULL
                END as quantity_growth,
                CASE WHEN %L AND pp.prev_margin > 0
                     THEN ROUND(((cp.total_margin - pp.prev_margin) / pp.prev_margin * 100)::numeric, 2)
                     ELSE NULL
                END as margin_growth
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
                    'total_revenue', SUM(total_revenue),
                    'total_quantity', SUM(total_quantity),
                    'total_margin', SUM(total_margin),
                    'avg_margin_rate', ROUND(AVG(margin_rate)::numeric, 2),
                    'record_count', COUNT(*)
                )
                FROM result
            ),
            'data', COALESCE((SELECT json_agg(row_to_json(r)) FROM result r), '[]'::json)
        )
    $q$,
        -- Current period SELECT
        v_group_expression,
        v_dimension_columns,
        p_company_id,
        p_start_date,
        p_end_date,
        p_store_id,
        p_store_id,
        CASE p_dimension
            WHEN 'category' THEN 'category_id'
            WHEN 'brand' THEN 'brand_id'
            WHEN 'product' THEN 'product_id'
            ELSE '''x'''
        END,
        p_dimension,
        v_group_expression,
        v_dimension_group,
        -- Previous period SELECT
        v_dimension_columns,
        p_company_id,
        v_previous_start,
        v_previous_end,
        p_store_id,
        p_store_id,
        CASE p_dimension
            WHEN 'category' THEN 'category_id'
            WHEN 'brand' THEN 'brand_id'
            WHEN 'product' THEN 'product_id'
            ELSE '''x'''
        END,
        p_dimension,
        -- Growth calculations
        p_compare_previous,
        p_compare_previous,
        p_compare_previous,
        -- Order and limit
        v_order_column,
        p_order_by,
        CASE WHEN p_top_n IS NOT NULL THEN format('LIMIT %s', p_top_n) ELSE '' END,
        -- Params for response
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

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_sales_analytics TO authenticated;
```

### 4.2 get_bcg_matrix_v2 (시간 범위 지원)

```sql
-- =====================================================
-- get_bcg_matrix_v2
-- BCG Matrix with time range support
-- =====================================================

CREATE OR REPLACE FUNCTION get_bcg_matrix_v2(
    p_company_id UUID,
    p_start_date DATE DEFAULT DATE_TRUNC('month', CURRENT_DATE)::DATE,
    p_end_date DATE DEFAULT CURRENT_DATE,
    p_store_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
BEGIN
    WITH category_data AS (
        SELECT
            category_id,
            category_name,
            SUM(revenue) as total_revenue,
            SUM(margin) as total_margin,
            SUM(quantity_sold) as total_quantity,
            CASE WHEN SUM(revenue) > 0
                 THEN SUM(margin) / SUM(revenue) * 100
                 ELSE 0
            END as margin_rate_pct
        FROM inventory_statistic_sales_daily
        WHERE company_id = p_company_id
          AND sale_date BETWEEN p_start_date AND p_end_date
          AND (p_store_id IS NULL OR store_id = p_store_id)
          AND category_id IS NOT NULL
        GROUP BY category_id, category_name
    ),
    totals AS (
        SELECT
            SUM(total_revenue) as grand_total_revenue,
            SUM(total_quantity) as grand_total_quantity
        FROM category_data
    ),
    percentiles AS (
        SELECT
            cd.*,
            ROUND((cd.total_revenue / NULLIF(t.grand_total_revenue, 0) * 100)::numeric, 2) as revenue_pct,
            ROUND((cd.total_quantity / NULLIF(t.grand_total_quantity, 0) * 100)::numeric, 2) as sales_volume_pct
        FROM category_data cd
        CROSS JOIN totals t
    ),
    medians AS (
        SELECT
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales_volume_pct) as median_sales,
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY margin_rate_pct) as median_margin
        FROM percentiles
    ),
    classified AS (
        SELECT
            p.category_id,
            p.category_name,
            ROUND(p.total_revenue::numeric, 2) as total_revenue,
            ROUND(p.margin_rate_pct::numeric, 2) as margin_rate_pct,
            p.total_quantity,
            p.revenue_pct,
            p.sales_volume_pct as sales_volume_percentile,
            p.margin_rate_pct as margin_percentile,
            CASE
                WHEN p.sales_volume_pct >= m.median_sales AND p.margin_rate_pct >= m.median_margin THEN 'star'
                WHEN p.sales_volume_pct < m.median_sales AND p.margin_rate_pct >= m.median_margin THEN 'problem_child'
                WHEN p.sales_volume_pct >= m.median_sales AND p.margin_rate_pct < m.median_margin THEN 'cash_cow'
                ELSE 'dog'
            END as quadrant
        FROM percentiles p
        CROSS JOIN medians m
    )
    SELECT json_build_object(
        'success', true,
        'params', json_build_object(
            'start_date', p_start_date,
            'end_date', p_end_date,
            'store_id', p_store_id
        ),
        'medians', (SELECT json_build_object('sales', median_sales, 'margin', median_margin) FROM medians),
        'star', COALESCE((SELECT json_agg(row_to_json(t)) FROM (SELECT * FROM classified WHERE quadrant = 'star' ORDER BY total_revenue DESC) t), '[]'::json),
        'cash_cow', COALESCE((SELECT json_agg(row_to_json(t)) FROM (SELECT * FROM classified WHERE quadrant = 'cash_cow' ORDER BY total_revenue DESC) t), '[]'::json),
        'problem_child', COALESCE((SELECT json_agg(row_to_json(t)) FROM (SELECT * FROM classified WHERE quadrant = 'problem_child' ORDER BY total_revenue DESC) t), '[]'::json),
        'dog', COALESCE((SELECT json_agg(row_to_json(t)) FROM (SELECT * FROM classified WHERE quadrant = 'dog' ORDER BY total_revenue DESC) t), '[]'::json)
    ) INTO v_result;

    RETURN v_result;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM
    );
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_bcg_matrix_v2 TO authenticated;
```

### 4.3 get_drill_down_analytics (계층 탐색)

```sql
-- =====================================================
-- get_drill_down_analytics
-- 계층형 분석 (전체 → 카테고리 → 브랜드 → 상품)
-- =====================================================

CREATE OR REPLACE FUNCTION get_drill_down_analytics(
    p_company_id UUID,
    p_start_date DATE DEFAULT (CURRENT_DATE - INTERVAL '30 days')::DATE,
    p_end_date DATE DEFAULT CURRENT_DATE,
    p_store_id UUID DEFAULT NULL,
    p_level TEXT DEFAULT 'category',     -- 'category', 'brand', 'product'
    p_parent_id UUID DEFAULT NULL        -- 상위 레벨 필터 (category_id or brand_id)
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
BEGIN
    -- Validate level
    IF p_level NOT IN ('category', 'brand', 'product') THEN
        RAISE EXCEPTION 'Invalid level: %. Must be category, brand, or product', p_level;
    END IF;

    IF p_level = 'category' THEN
        -- Category level aggregation
        SELECT json_build_object(
            'success', true,
            'level', 'category',
            'data', COALESCE((
                SELECT json_agg(row_to_json(r) ORDER BY r.total_revenue DESC)
                FROM (
                    SELECT
                        category_id as id,
                        category_name as name,
                        SUM(quantity_sold) as total_quantity,
                        ROUND(SUM(revenue)::numeric, 2) as total_revenue,
                        ROUND(SUM(margin)::numeric, 2) as total_margin,
                        ROUND((CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END)::numeric, 2) as margin_rate,
                        COUNT(DISTINCT product_id) as product_count,
                        COUNT(DISTINCT brand_id) as brand_count
                    FROM inventory_statistic_sales_daily
                    WHERE company_id = p_company_id
                      AND sale_date BETWEEN p_start_date AND p_end_date
                      AND (p_store_id IS NULL OR store_id = p_store_id)
                      AND category_id IS NOT NULL
                    GROUP BY category_id, category_name
                ) r
            ), '[]'::json)
        ) INTO v_result;

    ELSIF p_level = 'brand' THEN
        -- Brand level aggregation (optionally filtered by category)
        SELECT json_build_object(
            'success', true,
            'level', 'brand',
            'parent_id', p_parent_id,
            'data', COALESCE((
                SELECT json_agg(row_to_json(r) ORDER BY r.total_revenue DESC)
                FROM (
                    SELECT
                        brand_id as id,
                        brand_name as name,
                        category_id,
                        category_name,
                        SUM(quantity_sold) as total_quantity,
                        ROUND(SUM(revenue)::numeric, 2) as total_revenue,
                        ROUND(SUM(margin)::numeric, 2) as total_margin,
                        ROUND((CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END)::numeric, 2) as margin_rate,
                        COUNT(DISTINCT product_id) as product_count
                    FROM inventory_statistic_sales_daily
                    WHERE company_id = p_company_id
                      AND sale_date BETWEEN p_start_date AND p_end_date
                      AND (p_store_id IS NULL OR store_id = p_store_id)
                      AND brand_id IS NOT NULL
                      AND (p_parent_id IS NULL OR category_id = p_parent_id)
                    GROUP BY brand_id, brand_name, category_id, category_name
                ) r
            ), '[]'::json)
        ) INTO v_result;

    ELSIF p_level = 'product' THEN
        -- Product level aggregation (optionally filtered by brand or category)
        SELECT json_build_object(
            'success', true,
            'level', 'product',
            'parent_id', p_parent_id,
            'data', COALESCE((
                SELECT json_agg(row_to_json(r) ORDER BY r.total_revenue DESC)
                FROM (
                    SELECT
                        product_id as id,
                        product_name as name,
                        brand_id,
                        brand_name,
                        category_id,
                        category_name,
                        SUM(quantity_sold) as total_quantity,
                        ROUND(SUM(revenue)::numeric, 2) as total_revenue,
                        ROUND(SUM(margin)::numeric, 2) as total_margin,
                        ROUND((CASE WHEN SUM(revenue) > 0 THEN SUM(margin) / SUM(revenue) * 100 ELSE 0 END)::numeric, 2) as margin_rate,
                        SUM(invoice_count) as invoice_count
                    FROM inventory_statistic_sales_daily
                    WHERE company_id = p_company_id
                      AND sale_date BETWEEN p_start_date AND p_end_date
                      AND (p_store_id IS NULL OR store_id = p_store_id)
                      AND (p_parent_id IS NULL OR brand_id = p_parent_id OR category_id = p_parent_id)
                    GROUP BY product_id, product_name, brand_id, brand_name, category_id, category_name
                ) r
            ), '[]'::json)
        ) INTO v_result;
    END IF;

    RETURN v_result;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM
    );
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_drill_down_analytics TO authenticated;
```

---

## 5. Flutter Implementation

### 5.1 Data Models

```dart
// lib/features/inventory_analysis/domain/entities/sales_analytics.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_analytics.freezed.dart';

/// Time range for analytics queries
enum TimeRange {
  today,
  thisWeek,
  thisMonth,
  last30Days,
  last90Days,
  thisYear,
  custom,
}

/// Grouping granularity
enum GroupBy {
  daily,
  weekly,
  monthly,
}

/// Analysis dimension
enum Dimension {
  total,
  category,
  brand,
  product,
}

/// Metric type
enum Metric {
  revenue,
  quantity,
  margin,
}

/// Analytics data point
@freezed
class AnalyticsDataPoint with _$AnalyticsDataPoint {
  const factory AnalyticsDataPoint({
    required DateTime period,
    required String dimensionId,
    required String dimensionName,
    required double totalQuantity,
    required double totalRevenue,
    required double totalMargin,
    required double marginRate,
    required int invoiceCount,
    double? revenueGrowth,
    double? quantityGrowth,
    double? marginGrowth,
  }) = _AnalyticsDataPoint;

  factory AnalyticsDataPoint.fromJson(Map<String, dynamic> json) {
    return AnalyticsDataPoint(
      period: DateTime.parse(json['period'] as String),
      dimensionId: json['dimension_id'] as String,
      dimensionName: json['dimension_name'] as String,
      totalQuantity: (json['total_quantity'] as num).toDouble(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalMargin: (json['total_margin'] as num).toDouble(),
      marginRate: (json['margin_rate'] as num).toDouble(),
      invoiceCount: json['invoice_count'] as int,
      revenueGrowth: json['revenue_growth'] != null
          ? (json['revenue_growth'] as num).toDouble()
          : null,
      quantityGrowth: json['quantity_growth'] != null
          ? (json['quantity_growth'] as num).toDouble()
          : null,
      marginGrowth: json['margin_growth'] != null
          ? (json['margin_growth'] as num).toDouble()
          : null,
    );
  }
}

/// Analytics summary
@freezed
class AnalyticsSummary with _$AnalyticsSummary {
  const factory AnalyticsSummary({
    required double totalRevenue,
    required double totalQuantity,
    required double totalMargin,
    required double avgMarginRate,
    required int recordCount,
  }) = _AnalyticsSummary;

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toDouble() ?? 0,
      totalMargin: (json['total_margin'] as num?)?.toDouble() ?? 0,
      avgMarginRate: (json['avg_margin_rate'] as num?)?.toDouble() ?? 0,
      recordCount: json['record_count'] as int? ?? 0,
    );
  }
}

/// Complete analytics response
@freezed
class SalesAnalyticsResponse with _$SalesAnalyticsResponse {
  const factory SalesAnalyticsResponse({
    required bool success,
    required AnalyticsSummary summary,
    required List<AnalyticsDataPoint> data,
    String? error,
  }) = _SalesAnalyticsResponse;

  factory SalesAnalyticsResponse.fromJson(Map<String, dynamic> json) {
    if (json['success'] != true) {
      return SalesAnalyticsResponse(
        success: false,
        summary: const AnalyticsSummary(
          totalRevenue: 0,
          totalQuantity: 0,
          totalMargin: 0,
          avgMarginRate: 0,
          recordCount: 0,
        ),
        data: [],
        error: json['error'] as String?,
      );
    }

    return SalesAnalyticsResponse(
      success: true,
      summary: AnalyticsSummary.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      data: (json['data'] as List<dynamic>)
          .map((e) => AnalyticsDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
```

### 5.2 Repository

```dart
// lib/features/inventory_analysis/data/repositories/sales_analytics_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/sales_analytics.dart';

class SalesAnalyticsRepository {
  final SupabaseClient _client;

  SalesAnalyticsRepository(this._client);

  /// Get sales analytics with flexible parameters
  Future<SalesAnalyticsResponse> getSalesAnalytics({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
    GroupBy groupBy = GroupBy.daily,
    Dimension dimension = Dimension.total,
    Metric metric = Metric.revenue,
    String orderBy = 'DESC',
    int? topN,
    bool comparePrevious = false,
  }) async {
    try {
      final response = await _client.rpc(
        'get_sales_analytics',
        params: {
          'p_company_id': companyId,
          'p_start_date': startDate.toIso8601String().substring(0, 10),
          'p_end_date': endDate.toIso8601String().substring(0, 10),
          if (storeId != null) 'p_store_id': storeId,
          'p_group_by': groupBy.name,
          'p_dimension': dimension.name,
          'p_metric': metric.name,
          'p_order_by': orderBy,
          if (topN != null) 'p_top_n': topN,
          'p_compare_previous': comparePrevious,
        },
      );

      return SalesAnalyticsResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return SalesAnalyticsResponse(
        success: false,
        summary: const AnalyticsSummary(
          totalRevenue: 0,
          totalQuantity: 0,
          totalMargin: 0,
          avgMarginRate: 0,
          recordCount: 0,
        ),
        data: [],
        error: e.toString(),
      );
    }
  }

  /// Get top N products by metric
  Future<SalesAnalyticsResponse> getTopProducts({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
    Metric metric = Metric.revenue,
    int topN = 10,
  }) async {
    return getSalesAnalytics(
      companyId: companyId,
      startDate: startDate,
      endDate: endDate,
      storeId: storeId,
      groupBy: GroupBy.daily,  // Ignored for product dimension
      dimension: Dimension.product,
      metric: metric,
      topN: topN,
      comparePrevious: true,
    );
  }

  /// Get time series data
  Future<SalesAnalyticsResponse> getTimeSeries({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
    GroupBy groupBy = GroupBy.weekly,
    bool comparePrevious = true,
  }) async {
    return getSalesAnalytics(
      companyId: companyId,
      startDate: startDate,
      endDate: endDate,
      storeId: storeId,
      groupBy: groupBy,
      dimension: Dimension.total,
      comparePrevious: comparePrevious,
    );
  }
}
```

### 5.3 Provider

```dart
// lib/features/inventory_analysis/presentation/providers/sales_analytics_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/sales_analytics_repository.dart';
import '../../domain/entities/sales_analytics.dart';

/// Sales Analytics State
class SalesAnalyticsState {
  final bool isLoading;
  final SalesAnalyticsResponse? timeSeries;
  final SalesAnalyticsResponse? topProducts;
  final String? error;
  final TimeRange selectedTimeRange;
  final DateTime startDate;
  final DateTime endDate;

  const SalesAnalyticsState({
    this.isLoading = false,
    this.timeSeries,
    this.topProducts,
    this.error,
    this.selectedTimeRange = TimeRange.thisMonth,
    required this.startDate,
    required this.endDate,
  });

  SalesAnalyticsState copyWith({
    bool? isLoading,
    SalesAnalyticsResponse? timeSeries,
    SalesAnalyticsResponse? topProducts,
    String? error,
    TimeRange? selectedTimeRange,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SalesAnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      timeSeries: timeSeries ?? this.timeSeries,
      topProducts: topProducts ?? this.topProducts,
      error: error,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

/// Sales Analytics Notifier
class SalesAnalyticsNotifier extends StateNotifier<SalesAnalyticsState> {
  final SalesAnalyticsRepository _repository;

  SalesAnalyticsNotifier(this._repository) : super(
    SalesAnalyticsState(
      startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      endDate: DateTime.now(),
    ),
  );

  /// Load all analytics data
  Future<void> loadData({
    required String companyId,
    String? storeId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load in parallel
      final results = await Future.wait([
        _repository.getTimeSeries(
          companyId: companyId,
          startDate: state.startDate,
          endDate: state.endDate,
          storeId: storeId,
          groupBy: _getGroupByForTimeRange(state.selectedTimeRange),
        ),
        _repository.getTopProducts(
          companyId: companyId,
          startDate: state.startDate,
          endDate: state.endDate,
          storeId: storeId,
        ),
      ]);

      state = state.copyWith(
        isLoading: false,
        timeSeries: results[0],
        topProducts: results[1],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Change time range
  void setTimeRange(TimeRange range, {DateTime? customStart, DateTime? customEnd}) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (range) {
      case TimeRange.today:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case TimeRange.thisWeek:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case TimeRange.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case TimeRange.last30Days:
        startDate = now.subtract(const Duration(days: 30));
        break;
      case TimeRange.last90Days:
        startDate = now.subtract(const Duration(days: 90));
        break;
      case TimeRange.thisYear:
        startDate = DateTime(now.year, 1, 1);
        break;
      case TimeRange.custom:
        startDate = customStart ?? state.startDate;
        endDate = customEnd ?? state.endDate;
        break;
    }

    state = state.copyWith(
      selectedTimeRange: range,
      startDate: startDate,
      endDate: endDate,
    );
  }

  GroupBy _getGroupByForTimeRange(TimeRange range) {
    switch (range) {
      case TimeRange.today:
      case TimeRange.thisWeek:
        return GroupBy.daily;
      case TimeRange.thisMonth:
      case TimeRange.last30Days:
        return GroupBy.daily;
      case TimeRange.last90Days:
        return GroupBy.weekly;
      case TimeRange.thisYear:
      case TimeRange.custom:
        return GroupBy.monthly;
    }
  }
}

/// Provider
final salesAnalyticsProvider = StateNotifierProvider<SalesAnalyticsNotifier, SalesAnalyticsState>(
  (ref) => SalesAnalyticsNotifier(
    SalesAnalyticsRepository(Supabase.instance.client),
  ),
);
```

### 5.4 UI Components

```dart
// lib/features/inventory_analysis/presentation/widgets/time_range_selector.dart

import 'package:flutter/material.dart';
import '../../domain/entities/sales_analytics.dart';

class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedRange;
  final ValueChanged<TimeRange> onChanged;

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TimeRange.values
            .where((r) => r != TimeRange.custom)
            .map((range) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_getRangeLabel(range)),
                selected: selectedRange == range,
                onSelected: (selected) {
                  if (selected) onChanged(range);
                },
              ),
            ))
            .toList(),
      ),
    );
  }

  String _getRangeLabel(TimeRange range) {
    switch (range) {
      case TimeRange.today:
        return 'Today';
      case TimeRange.thisWeek:
        return 'This Week';
      case TimeRange.thisMonth:
        return 'This Month';
      case TimeRange.last30Days:
        return 'Last 30 Days';
      case TimeRange.last90Days:
        return 'Last 90 Days';
      case TimeRange.thisYear:
        return 'This Year';
      case TimeRange.custom:
        return 'Custom';
    }
  }
}
```

---

## 6. Migration Steps

### 6.1 Phase 1: Database Setup (Day 1)

```sql
-- Step 1: Create daily statistics table
-- (Execute inventory_statistic_sales_daily CREATE TABLE statement)

-- Step 2: Create indexes
-- (Execute all CREATE INDEX statements)

-- Step 3: Create trigger function
-- (Execute fn_update_sales_daily function)

-- Step 4: Create trigger
-- (Execute CREATE TRIGGER statement)

-- Step 5: Backfill existing data
SELECT fn_backfill_sales_daily(
    p_start_date := '2025-01-01',
    p_end_date := CURRENT_DATE
);

-- Step 6: Verify data
SELECT
    COUNT(*) as total_rows,
    MIN(sale_date) as earliest,
    MAX(sale_date) as latest
FROM inventory_statistic_sales_daily;
```

### 6.2 Phase 2: RPC Functions (Day 1)

```sql
-- Step 1: Create get_sales_analytics function
-- Step 2: Create get_bcg_matrix_v2 function
-- Step 3: Create get_drill_down_analytics function
-- Step 4: Grant permissions
```

### 6.3 Phase 3: Flutter Implementation (Day 2-3)

```
1. Add data models (sales_analytics.dart)
2. Add repository (sales_analytics_repository.dart)
3. Add provider (sales_analytics_provider.dart)
4. Update sales_dashboard_page.dart with new widgets
5. Test all features
```

### 6.4 Phase 4: Testing & Validation (Day 3)

```
1. Unit tests for repository
2. Widget tests for UI components
3. Integration tests for full flow
4. Performance testing with large datasets
```

---

## 7. API Reference

### 7.1 get_sales_analytics

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| p_company_id | UUID | Yes | - | Company ID |
| p_start_date | DATE | No | 30 days ago | Start date |
| p_end_date | DATE | No | Today | End date |
| p_store_id | UUID | No | NULL | Store filter (NULL = all) |
| p_group_by | TEXT | No | 'daily' | 'daily', 'weekly', 'monthly' |
| p_dimension | TEXT | No | 'total' | 'total', 'category', 'brand', 'product' |
| p_metric | TEXT | No | 'revenue' | 'revenue', 'quantity', 'margin' |
| p_order_by | TEXT | No | 'DESC' | 'ASC', 'DESC' |
| p_top_n | INT | No | NULL | Limit results |
| p_compare_previous | BOOL | No | FALSE | Include growth % |

**Response:**
```json
{
  "success": true,
  "params": { ... },
  "summary": {
    "total_revenue": 1530200000,
    "total_quantity": 414,
    "total_margin": 1146766812,
    "avg_margin_rate": 74.94,
    "record_count": 45
  },
  "data": [
    {
      "period": "2026-01-09",
      "dimension_id": "product-uuid",
      "dimension_name": "Product Name",
      "total_quantity": 50,
      "total_revenue": 5000000,
      "total_margin": 3750000,
      "margin_rate": 75.0,
      "invoice_count": 12,
      "revenue_growth": 15.5,
      "quantity_growth": 10.2,
      "margin_growth": 18.3
    }
  ]
}
```

### 7.2 get_bcg_matrix_v2

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| p_company_id | UUID | Yes | - | Company ID |
| p_start_date | DATE | No | Month start | Start date |
| p_end_date | DATE | No | Today | End date |
| p_store_id | UUID | No | NULL | Store filter |

### 7.3 get_drill_down_analytics

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| p_company_id | UUID | Yes | - | Company ID |
| p_start_date | DATE | No | 30 days ago | Start date |
| p_end_date | DATE | No | Today | End date |
| p_store_id | UUID | No | NULL | Store filter |
| p_level | TEXT | No | 'category' | 'category', 'brand', 'product' |
| p_parent_id | UUID | No | NULL | Parent ID for filtering |

---

## 8. Performance Considerations

### 8.1 Expected Table Size

```
Daily rows per company:
- 100 products × 1 store = 100 rows/day
- 100 products × 5 stores = 500 rows/day

Annual estimate:
- 1 company, 1 store: 36,500 rows/year
- 1 company, 5 stores: 182,500 rows/year
- 10 companies, 5 stores each: 1,825,000 rows/year

Storage: ~200 bytes/row → ~365 MB/year for 10 companies
```

### 8.2 Query Performance Targets

| Query Type | Target | Index Used |
|------------|--------|------------|
| Daily totals | < 50ms | idx_stat_daily_company_date |
| Top 10 products | < 100ms | idx_stat_daily_revenue |
| Monthly trend | < 100ms | idx_stat_daily_company_date |
| Category breakdown | < 100ms | idx_stat_daily_category |

### 8.3 Trigger Performance

```
Expected overhead per INSERT: < 5ms
- Single row lookup (inventory_products)
- Single UPSERT operation
- Index maintenance
```

---

## 9. Rollback Plan

### 9.1 If Issues Occur

```sql
-- Step 1: Disable trigger
DROP TRIGGER IF EXISTS trg_inventory_logs_sales_daily ON inventory_logs;

-- Step 2: Keep table for debugging (don't drop immediately)
-- DROP TABLE IF EXISTS inventory_statistic_sales_daily;

-- Step 3: Remove RPC functions if needed
-- DROP FUNCTION IF EXISTS get_sales_analytics;
-- DROP FUNCTION IF EXISTS get_bcg_matrix_v2;
-- DROP FUNCTION IF EXISTS get_drill_down_analytics;
```

### 9.2 Flutter Rollback

```
1. Revert to previous sales_dashboard_page.dart
2. Remove new providers/repositories
3. Keep existing get_sales_dashboard RPC calls
```

---

## 10. Success Criteria

### 10.1 Functional Requirements

- [ ] Time range selector works with all options
- [ ] Top 10 products displays correctly
- [ ] Time series chart renders properly
- [ ] BCG Matrix works with date range
- [ ] Store filter works across all views
- [ ] Growth percentages calculate correctly

### 10.2 Performance Requirements

- [ ] Page load < 2 seconds
- [ ] Time range change < 1 second
- [ ] No UI jank during data loading
- [ ] Works offline with cached data

### 10.3 Data Integrity

- [ ] Daily statistics match inventory_logs totals
- [ ] Trigger fires reliably on all inserts
- [ ] Backfill produces consistent results
- [ ] No duplicate records in daily table

---

## Appendix A: Complete SQL Scripts

See separate file: `sales_analytics_v2_migrations.sql`

## Appendix B: Flutter Code Files

See separate file: `sales_analytics_v2_flutter.dart`

---

**Document History:**
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-09 | System | Initial draft |
| 2.0 | 2026-01-09 | 30-Year DB Architect | Complete rewrite with optimized design |
