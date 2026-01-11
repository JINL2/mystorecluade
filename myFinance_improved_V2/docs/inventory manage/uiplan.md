# 인벤토리 분석 시스템 - 사용자 중심 UI 명세서 (v2)

## 🎯 설계 원칙

### 1. 두괄식 정보 제공
- **결론 먼저**: 문제가 있나? 없나?
- **근거 제시**: 왜 그런가?
- **액션 제안**: 뭘 해야 하나?

### 2. 전체 → 세부
- 큰 그림부터 보여주기
- 클릭하면 상세로 드릴다운
- 사용자가 원하는 만큼만 깊이 들어감

### 3. 액션 중심
- 통계는 수단, 의사결정이 목적
- "이 상품 주문해야 함" (명확한 액션)
- "통계적으로 유의미함" (근거)

---

## 📊 시스템 1: 수익률 및 판매량 분석

### 🎯 사용자 질문
1. **"우리 사업 잘 되고 있어?"** → 한눈에 보기
2. **"어디에 집중해야 해?"** → 전략 방향
3. **"구체적으로 뭐가 문제야?"** → 드릴다운

---

### 📱 화면 1-1: 사업 상태 대시보드 (첫 화면)
```
┌─────────────────────────────────────────────────┐
│  🎯 사업 상태: 양호 ✅                          │
│  (이번 달 vs 지난 달)                          │
├─────────────────────────────────────────────────┤
│                                                 │
│  💰 매출                                        │
│  125M원 ↑ 15% (지난 달: 109M원)                │
│  ████████████████████████░░░░░                 │
│                                                 │
│  📈 마진                                        │
│  80M원 ↑ 12% (지난 달: 71M원)                  │
│  ████████████████████░░░░░░░                   │
│  마진율: 64% (목표: 60% ✅)                    │
│                                                 │
│  🛒 판매량                                      │
│  1,234개 ↑ 8% (지난 달: 1,142개)               │
│  ████████████████░░░░░░░░░                     │
│                                                 │
│  ⚠️ 주의사항                                   │
│  • Shoes 카테고리 마진율 하락 (-5%)            │
│  • "샤넬 가방" 재고 부족 (2개 남음)            │
│                                                 │
│  [전략 분석 보기 →]                            │
└─────────────────────────────────────────────────┘
```

**사용자 의도:**
- "사업 잘 되나?" → 한눈에 파악
- 문제 있으면 바로 알림
- 자세히 보고 싶으면 클릭

**필요한 데이터:**
```sql
-- 이번 달 vs 지난 달 비교
SELECT 
    this_month.total_revenue,
    last_month.total_revenue,
    (this_month.total_revenue - last_month.total_revenue) / last_month.total_revenue * 100 as revenue_growth_pct,
    
    this_month.total_margin,
    this_month.margin_rate_pct,
    
    this_month.total_quantity,
    last_month.total_quantity,
    (this_month.total_quantity - last_month.total_quantity) / last_month.total_quantity * 100 as quantity_growth_pct
FROM mv_sales_overview_monthly this_month
CROSS JOIN mv_sales_overview_monthly last_month
WHERE this_month.month = DATE_TRUNC('month', CURRENT_DATE)
  AND last_month.month = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month');

-- 주의사항: 마진율 하락 카테고리
SELECT 
    c.category_name,
    this_m.margin_rate_pct as this_month_margin,
    last_m.margin_rate_pct as last_month_margin,
    this_m.margin_rate_pct - last_m.margin_rate_pct as margin_change
FROM mv_sales_by_category_monthly this_m
JOIN mv_sales_by_category_monthly last_m ON this_m.category_id = last_m.category_id
WHERE this_m.month = DATE_TRUNC('month', CURRENT_DATE)
  AND last_m.month = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
  AND this_m.margin_rate_pct - last_m.margin_rate_pct < -3  -- 3% 이상 하락
ORDER BY margin_change ASC
LIMIT 3;
```

---

### 📱 화면 1-2: 전략 분석 (클릭 후)
```
┌─────────────────────────────────────────────────┐
│  💡 전략 추천: 여기에 집중하세요                │
├─────────────────────────────────────────────────┤
│                                                 │
│  🌟 확대해야 할 분야 (Star)                    │
│  ┌─────────────────────────────────────────┐  │
│  │ 1. Bag 카테고리                         │  │
│  │    매출: 85M원 (전체의 68%)             │  │
│  │    마진율: 68% 🔥                        │  │
│  │    추천: 재고 확대, 프로모션 강화       │  │
│  │    [상세 보기 →]                        │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  💰 유지해야 할 분야 (Cash Cow)                │
│  ┌─────────────────────────────────────────┐  │
│  │ 2. Belt 카테고리                        │  │
│  │    매출: 42M원 (안정적)                 │  │
│  │    마진율: 55%                          │  │
│  │    추천: 현재 전략 유지                 │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  ⚠️ 재검토 필요 (Problem Child)                │
│  ┌─────────────────────────────────────────┐  │
│  │ 3. Shoes 카테고리                       │  │
│  │    매출: 38M원 (판매량 많음)            │  │
│  │    마진율: 48% ↓ (목표 미달)            │  │
│  │    추천: 원가 절감 또는 가격 인상       │  │
│  │    [상세 분석 →]                        │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  🗑️ 축소 고려 (Dog)                           │
│  ┌─────────────────────────────────────────┐  │
│  │ 4. Accessories 일부 제품                │  │
│  │    매출: 저조, 마진: 낮음               │  │
│  │    추천: 단종 또는 대체품 검토          │  │
│  │    [리스트 보기 →]                      │  │
│  └─────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

**사용자 의도:**
- "어디에 집중?"
- 액션 가능한 추천
- 카테고리별로 그룹화 (제품 레벨은 너무 많음)

**필요한 데이터:**
```sql
-- 전략 매트릭스 (카테고리 레벨)
WITH category_metrics AS (
    SELECT 
        category_id,
        category_name,
        total_revenue,
        margin_rate_pct,
        total_quantity,
        -- 판매량 순위 (전체 대비)
        PERCENT_RANK() OVER (ORDER BY total_quantity) as sales_volume_percentile,
        -- 마진율 순위
        PERCENT_RANK() OVER (ORDER BY margin_rate_pct) as margin_percentile
    FROM mv_sales_by_category_monthly
    WHERE month = DATE_TRUNC('month', CURRENT_DATE)
)
SELECT 
    category_name,
    total_revenue,
    margin_rate_pct,
    total_quantity,
    CASE 
        WHEN sales_volume_percentile >= 0.5 AND margin_percentile >= 0.5 THEN 'Star'
        WHEN sales_volume_percentile < 0.5 AND margin_percentile >= 0.5 THEN 'Cash Cow'
        WHEN sales_volume_percentile >= 0.5 AND margin_percentile < 0.5 THEN 'Problem Child'
        ELSE 'Dog'
    END as strategy_quadrant
FROM category_metrics
ORDER BY 
    CASE 
        WHEN strategy_quadrant = 'Star' THEN 1
        WHEN strategy_quadrant = 'Cash Cow' THEN 2
        WHEN strategy_quadrant = 'Problem Child' THEN 3
        ELSE 4
    END,
    total_revenue DESC;
```

---

### 📱 화면 1-3: 카테고리 상세 (Star 클릭 시)
```
┌─────────────────────────────────────────────────┐
│  📦 Bag 카테고리 상세                           │
├─────────────────────────────────────────────────┤
│                                                 │
│  📊 카테고리 성과                               │
│  매출: 85M원 (전체의 68%)                       │
│  마진: 58M원 (마진율 68%)                       │
│  판매량: 245개                                  │
│  추세: ↑ 지난 달 대비 +18%                     │
│                                                 │
│  🏆 Top 5 브랜드                                │
│  ┌─────────────────────────────────────────┐  │
│  │ 1. CHANEL     45M원  마진 72% ⭐⭐⭐⭐⭐  │  │
│  │ 2. HERMÈS     28M원  마진 68% ⭐⭐⭐⭐⭐  │  │
│  │ 3. LV         12M원  마진 65% ⭐⭐⭐⭐   │  │
│  │    [더 보기...]                         │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  ⚠️ 주의 필요한 제품                            │
│  • 샤넬 클래식 플랩: 재고 2개 (주문 필요)      │
│  • 에르메스 버킨: 마진율 하락 (-5%)            │
│                                                 │
│  💡 추천 액션                                   │
│  1. CHANEL 재고 확대 (현재 2개 → 15개)         │
│  2. 신규 브랜드 추가 검토 (Bottega, Loewe)     │
│  3. 프로모션 계획 수립                         │
└─────────────────────────────────────────────────┘
```

**사용자 의도:**
- 카테고리 내 브랜드 성과
- **제품은 문제 있을 때만** 표시
- 정상 제품은 안 보여줌 (너무 많음)

**필요한 데이터:**
```sql
-- 카테고리 내 브랜드 Top 5
SELECT 
    b.brand_name,
    SUM(s.total_revenue) as revenue,
    AVG(s.margin_rate_pct) as avg_margin_rate,
    SUM(s.total_quantity) as quantity
FROM mv_sales_by_product_monthly s
JOIN inventory_products p ON s.product_id = p.product_id
JOIN inventory_brands b ON p.brand_id = b.brand_id
WHERE s.month = DATE_TRUNC('month', CURRENT_DATE)
  AND p.category_id = :category_id
GROUP BY b.brand_name
ORDER BY revenue DESC
LIMIT 5;

-- 주의 필요한 제품만 (재고 부족 OR 마진 하락)
SELECT 
    p.product_name,
    cs.quantity_on_hand,
    opt.reorder_point_95,
    this_m.margin_rate_pct as current_margin,
    last_m.margin_rate_pct as last_month_margin,
    this_m.margin_rate_pct - last_m.margin_rate_pct as margin_change
FROM inventory_products p
JOIN inventory_current_stock cs ON p.product_id = cs.product_id
JOIN mv_inventory_optimization opt ON p.product_id = opt.product_id
LEFT JOIN mv_sales_by_product_monthly this_m ON p.product_id = this_m.product_id 
    AND this_m.month = DATE_TRUNC('month', CURRENT_DATE)
LEFT JOIN mv_sales_by_product_monthly last_m ON p.product_id = last_m.product_id 
    AND last_m.month = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
WHERE p.category_id = :category_id
  AND (
    cs.quantity_on_hand < opt.reorder_point_95  -- 재고 부족
    OR this_m.margin_rate_pct - last_m.margin_rate_pct < -3  -- 마진 3% 이상 하락
  )
ORDER BY 
    CASE 
        WHEN cs.quantity_on_hand < opt.reorder_point_95 THEN 1
        ELSE 2
    END,
    margin_change ASC
LIMIT 10;
```

---

## 🚚 시스템 2: 공급망 병목 분석

### 🎯 사용자 질문
1. **"공급망에 문제 있어?"** → 결론
2. **"어떤 상품이 문제야?"** → 적분값 순위
3. **"왜 문제야?"** → 단계별 분석

---

### 📱 화면 2-1: 공급망 상태 (첫 화면)
```
┌─────────────────────────────────────────────────┐
│  🎯 공급망 상태: 주의 필요 ⚠️                   │
├─────────────────────────────────────────────────┤
│                                                 │
│  📊 종합 점수: 73/100                           │
│  ████████████████████░░░░░░░░                   │
│                                                 │
│  • 전체 손실률: 6.6% (목표: <5% ❌)            │
│  • 평균 리드타임: 32일 (목표: <30일 ❌)        │
│  • 품질 합격률: 95.2% (목표: >95% ✅)          │
│                                                 │
│  ⚠️ 최대 병목: Stage 2 (배송 중 분실)          │
│  손실률 2.8% - 개선 필요                        │
│                                                 │
│  🚨 긴급 주의 상품 (적분값 기준)                │
│  1. 샤넬 클래식 플랩  📉 위험도: 높음          │
│     180일 × 평균 2개 지연 = 360 개·일          │
│     [상세 →]                                   │
│                                                 │
│  2. 에르메스 버킨      📉 위험도: 높음          │
│     90일 × 평균 4개 지연 = 360 개·일           │
│     [상세 →]                                   │
│                                                 │
│  [전체 문제 상품 보기 →]                       │
│  [공급자 성과 보기 →]                          │
└─────────────────────────────────────────────────┘
```

**핵심 개념: 적분값 (Error-Days)**
```
적분값 = 지연 일수 × 평균 부족 수량

예시:
- 상품 A: 10일 동안 매일 1개씩 부족 = 10 개·일
- 상품 B: 100일 동안 매일 100개씩 부족 = 10,000 개·일

→ 상품 B가 훨씬 심각!
```

**필요한 데이터:**
```sql
-- 공급망 종합 점수
WITH metrics AS (
    SELECT 
        -- 손실률 점수 (0-40점)
        CASE 
            WHEN loss_rate_pct <= 3 THEN 40
            WHEN loss_rate_pct <= 5 THEN 30
            WHEN loss_rate_pct <= 7 THEN 20
            ELSE 10
        END as loss_score,
        
        -- 리드타임 점수 (0-30점)
        CASE 
            WHEN avg_lead_time_days <= 25 THEN 30
            WHEN avg_lead_time_days <= 30 THEN 25
            WHEN avg_lead_time_days <= 35 THEN 20
            ELSE 10
        END as leadtime_score,
        
        -- 품질 점수 (0-30점)
        CASE 
            WHEN (stage3_accepted * 100.0 / NULLIF(stage3_received, 0)) >= 97 THEN 30
            WHEN (stage3_accepted * 100.0 / NULLIF(stage3_received, 0)) >= 95 THEN 25
            WHEN (stage3_accepted * 100.0 / NULLIF(stage3_received, 0)) >= 90 THEN 20
            ELSE 10
        END as quality_score,
        
        loss_rate_pct,
        avg_lead_time_days,
        (stage3_accepted * 100.0 / NULLIF(stage3_received, 0)) as quality_rate
    FROM mv_supply_chain_overview_monthly o
    JOIN mv_supply_chain_stages_monthly s ON o.month = s.month
    WHERE o.month = DATE_TRUNC('month', CURRENT_DATE)
)
SELECT 
    loss_score + leadtime_score + quality_score as total_score,
    loss_rate_pct,
    avg_lead_time_days,
    quality_rate
FROM metrics;

-- 최대 병목 단계
SELECT 
    'Stage 1' as stage_name,
    stage1_loss_rate_pct as loss_rate
FROM mv_supply_chain_stages_monthly
WHERE month = DATE_TRUNC('month', CURRENT_DATE)
UNION ALL
SELECT 
    'Stage 2',
    stage2_loss_rate_pct
FROM mv_supply_chain_stages_monthly
WHERE month = DATE_TRUNC('month', CURRENT_DATE)
UNION ALL
SELECT 
    'Stage 3',
    stage3_rejection_rate_pct
FROM mv_supply_chain_stages_monthly
WHERE month = DATE_TRUNC('month', CURRENT_DATE)
ORDER BY loss_rate DESC
LIMIT 1;
```

---

### 📱 화면 2-2: 문제 상품 리스트 (적분값 순)
```
┌──────────────────────────────────────────────────────────┐
│  🚨 문제 상품 (Error Integral 기준)                      │
├────────┬──────────┬────────┬────────┬──────────────────┤
│ 순위   │ 상품     │지연일수│부족수량│ 적분값 (개·일)   │
├────────┼──────────┼────────┼────────┼──────────────────┤
│ 🔴 1   │샤넬 플랩 │ 180일  │ 평균2개│ 360 ⚠️ 심각     │
│        │          │        │        │ [해결방안 →]    │
├────────┼──────────┼────────┼────────┼──────────────────┤
│ 🔴 2   │에르메스  │  90일  │ 평균4개│ 360 ⚠️ 심각     │
│        │ 버킨     │        │        │ [해결방안 →]    │
├────────┼──────────┼────────┼────────┼──────────────────┤
│ 🟡 3   │LV 지갑   │ 120일  │ 평균1개│ 120 주의        │
├────────┼──────────┼────────┼────────┼──────────────────┤
│ 🟢 4   │구찌 벨트 │  30일  │ 평균2개│  60 경미        │
└────────┴──────────┴────────┴────────┴──────────────────┘

심각 (>300): 즉시 대체 공급자 검토
주의 (100-300): 모니터링 강화
경미 (<100): 정상 범위
```

**적분 계산 로직:**
```sql
CREATE MATERIALIZED VIEW mv_supply_chain_product_errors AS
WITH daily_gaps AS (
    -- 주문 시점부터 입고 시점까지의 일별 부족량
    SELECT 
        poi.product_id,
        p.product_name,
        po.created_at_utc::date as order_date,
        COALESCE(r.received_date_utc::date, CURRENT_DATE) as received_date,
        poi.quantity_ordered,
        COALESCE(ri.quantity_accepted, 0) as quantity_received,
        poi.quantity_ordered - COALESCE(ri.quantity_accepted, 0) as shortage,
        
        -- 지연 일수
        COALESCE(
            EXTRACT(DAY FROM (r.received_date_utc - po.created_at_utc)),
            EXTRACT(DAY FROM (CURRENT_DATE - po.created_at_utc))
        ) as delay_days
    FROM inventory_purchase_orders po
    JOIN inventory_purchase_order_items poi ON po.order_id = poi.order_id
    JOIN inventory_products p ON poi.product_id = p.product_id
    LEFT JOIN inventory_order_shipment_links osl ON po.order_id = osl.order_id
    LEFT JOIN inventory_sessions sess ON sess.shipment_id = osl.shipment_id
    LEFT JOIN inventory_receiving r ON r.session_id = sess.session_id
    LEFT JOIN inventory_receiving_items ri ON r.receiving_id = ri.receiving_id 
        AND poi.product_id = ri.product_id
    WHERE po.created_at_utc >= CURRENT_DATE - INTERVAL '6 months'
)
SELECT 
    product_id,
    product_name,
    COUNT(*) as order_count,
    SUM(shortage) as total_shortage,
    AVG(shortage) as avg_shortage_per_order,
    SUM(delay_days) as total_delay_days,
    AVG(delay_days) as avg_delay_days,
    
    -- 적분값: 평균 부족량 × 평균 지연일수
    AVG(shortage) * AVG(delay_days) as error_integral,
    
    -- 위험도
    CASE 
        WHEN AVG(shortage) * AVG(delay_days) >= 300 THEN 'Critical'
        WHEN AVG(shortage) * AVG(delay_days) >= 100 THEN 'Warning'
        ELSE 'Normal'
    END as risk_level
FROM daily_gaps
WHERE shortage > 0  -- 부족이 있는 경우만
GROUP BY product_id, product_name
HAVING COUNT(*) >= 2  -- 최소 2번 이상 발생
ORDER BY error_integral DESC;
```

---

### 📱 화면 2-3: 상품 상세 + 판매 추이
```
┌─────────────────────────────────────────────────┐
│  📦 샤넬 클래식 플랩 - 공급망 분석              │
├─────────────────────────────────────────────────┤
│                                                 │
│  🚨 상태: 심각 (Error Integral: 360)           │
│                                                 │
│  📉 공급 문제                                   │
│  • 평균 지연: 180일 (목표: 30일)               │
│  • 평균 부족: 2개/주문                          │
│  • 주 공급자: ABC공장 (평점: ⭐⭐)             │
│                                                 │
│  📈 판매 추이 vs 공급 추이                      │
│  ┌─────────────────────────────────────────┐  │
│  │ 수량                                    │  │
│  │  15┤     판매 (실제)                    │  │
│  │    │    ╱╲    ╱╲                        │  │
│  │  10┤   ╱  ╲  ╱  ╲                       │  │
│  │    │  ╱    ╲╱    ╲                      │  │
│  │   5┤ ╱            ╲    ⚠️ 재고 부족    │  │
│  │    │╱              ╲                    │  │
│  │   0┼─────────────────────              │  │
│  │    │                                    │  │
│  │    │     공급 (입고)                    │  │
│  │   5┤         ■         ■              │  │
│  │    │                                    │  │
│  │    └────────────────────────────────    │  │
│  │    1월 2월 3월 4월 5월 6월             │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  💡 문제 원인                                   │
│  1. 공급자 생산 능력 부족                      │
│  2. 배송 지연 (Stage 2에서 평균 60일)          │
│  3. 품질 거부율 12% (업계 평균: 3%)            │
│                                                 │
│  ✅ 추천 액션                                   │
│  1. 대체 공급자 추가 (XYZ공장 검토)            │
│  2. 주문량 2배 증가 (안전 마진 확보)           │
│  3. 선불 결제로 우선순위 확보                  │
│  4. 품질 기준 완화 또는 재가공 프로세스 추가   │
└─────────────────────────────────────────────────┘
```

**필요한 데이터:**
```sql
-- 상품별 판매 vs 공급 추이 (월별)
SELECT 
    DATE_TRUNC('month', sale_date_utc) as month,
    'Sales' as type,
    SUM(quantity_sold) as quantity
FROM inventory_invoice_items ii
JOIN inventory_invoice i ON ii.invoice_id = i.invoice_id
WHERE product_id = :product_id
  AND sale_date_utc >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY DATE_TRUNC('month', sale_date_utc)

UNION ALL

SELECT 
    DATE_TRUNC('month', r.received_date_utc) as month,
    'Supply' as type,
    SUM(ri.quantity_accepted) as quantity
FROM inventory_receiving_items ri
JOIN inventory_receiving r ON ri.receiving_id = r.receiving_id
WHERE ri.product_id = :product_id
  AND r.received_date_utc >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY DATE_TRUNC('month', r.received_date_utc)

ORDER BY month, type;
```

---

## 🔍 시스템 3: 도난/분실 분석

### 🎯 사용자 질문
1. **"우리 가게에 도둑 있어?"** → 통계적 결론
2. **"어디가 문제야?"** → 매장/제품 순위
3. **"왜 그렇게 생각해?"** → 근거 제시

---
# 시스템 3: 재고 불일치 통계 분석 - 완전 명세서

## 📊 데이터베이스 현황

### 사용 가능한 데이터
```sql
inventory_logs (event_type = 'counting')
├── product_id (UUID)
├── store_id (UUID)
├── quantity_before (NUMERIC)
├── quantity_after (NUMERIC)
├── quantity_change (NUMERIC) ⭐ 핵심
├── cost_after (NUMERIC) - 대부분 NULL
├── created_at_utc (TIMESTAMPTZ)
└── reason (VARCHAR)

inventory_products
├── product_id (UUID)
├── product_name (VARCHAR)
├── cost_price (NUMERIC) ⭐ 원가 (사용 가능!)
├── category_id (UUID)
└── brand_id (UUID)

stores
├── store_id (UUID)
└── store_name (VARCHAR)
```

### 금액 계산 로직
```sql
adjustment_value = quantity_change × COALESCE(cost_after, product.cost_price, 0)

예시:
quantity_change: +5
cost_price: 123원
→ adjustment_value = +615원 (이득)

quantity_change: -6
cost_price: 780,600원
→ adjustment_value = -4,683,600원 (손실)
```

### 현재 데이터 상황
- counting 이벤트: 12건
- 기간: 2025-12-19 ~ 2025-12-22 (3일)
- 매장: 1개만 (테스트 데이터)
- 금액 데이터: product.cost_price 사용 가능 ✅

---

## 🎯 핵심 컨셉

### 1. 정규분포 원리
```
정상 (자연 발생):
+615 -200 +427,800 -1,812,600 +604,200 ...
→ 표본이 많아지면 평균이 0 근처로 수렴

비정상 (인위적):
-800K -1.2M -850K -620K -380K ... (계속 -)
→ 0으로 수렴 안 함, 계속 마이너스
```

### 2. 기간별 누적 손실/이득
```
1주일: +2M - 5M = -3M (순 손실)
1개월: +8M - 12M = -4M (순 손실)
3개월: +25M - 27M = -2M (순 손실)

표본이 많아지면:
정상: 0 근처로 수렴
비정상: 계속 마이너스 (또는 플러스)
```

### 3. Chi-square 검정
```
매장별 +/- 분포가 균등한가?
→ p < 0.05 이면 특정 매장 비정상
```

### 4. 목적
```
통계적으로 "이상하다" 판정 → 사용자가 원인 조사
CCTV "언제" 볼지는 우리가 모름 (판단 안 함)
```

---

## 📱 UI 설계

### 화면 3-1: 통계 대시보드 (첫 화면)

```
┌─────────────────────────────────────────────────┐
│  📊 재고 불일치 통계 분석                       │
├─────────────────────────────────────────────────┤
│                                                 │
│  🔍 분석 기간                                   │
│  • 전체: 2024-01-01 ~ 현재 (12개월)            │
│  • 최근 30일                                    │
│  • 최근 7일                                     │
│  [기간 선택 ▼]                                  │
│                                                 │
│  💰 기간 누적 손익                              │
│  ┌─────────────────────────────────────────┐  │
│  │ 전체 (12개월)                           │  │
│  │ ─────────────────────────────────────   │  │
│  │ 증가: +45.2M원 (발견)                   │  │
│  │ 감소: -48.7M원 (미발견)                 │  │
│  │ ═══════════════════════════════════════ │  │
│  │ 순 손실: -3.5M원 (-7.2%)                │  │
│  │                                         │  │
│  │ 📈 추세: 0으로 수렴 중 ✅                │  │
│  │    (표본 증가 → 정상 신호)              │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  📊 통계 검정 결과 (전체 기간)                  │
│  ┌─────────────────────────────────────────┐  │
│  │ Chi-square Test                         │  │
│  │ χ² = 24.82, p = 0.0002                 │  │
│  │                                         │  │
│  │ 🎯 판정: 자연 발생 어려움                │  │
│  │         (99.98% 확률로 패턴 존재)       │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  🏪 매장별 현황                                 │
│  ┌─────────────────────────────────────────┐  │
│  │ 강남점: -8.2M원   🔴 통계적 이상       │  │
│  │ 홍대점: +1.5M원   🟢 정상 범위         │  │
│  │ 압구정: -0.3M원   🟢 정상 범위         │  │
│  │ 신사점: +2.1M원   🟢 정상 범위         │  │
│  │ 청담점: +1.4M원   🟢 정상 범위         │  │
│  │ 명동점: +0.0M원   🟢 정상 범위         │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  [매장별 상세 →] [기간별 추이 →]               │
└─────────────────────────────────────────────────┘
```

**핵심 지표:**
1. **누적 손익** - 기간 동안 총 얼마 손해/이득
2. **0 수렴 여부** - 정상이면 0 가까이
3. **Chi-square** - 매장별 균등 분포 검증

---

### 화면 3-2: 매장별 상세

```
┌──────────────────────────────────────────────────────────┐
│  🏪 강남점 - 통계 분석 (전체 기간)                       │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  💰 누적 손익                                            │
│  ┌────────────────────────────────────────────────────┐│
│  │ 전체 기간 (12개월)                                 ││
│  │ ────────────────────────────────────────────────   ││
│  │ 증가: +12.8M원 (발견, 42건)                        ││
│  │ 감소: -21.0M원 (미발견, 125건)                     ││
│  │ ══════════════════════════════════════════════════ ││
│  │ 순 손실: -8.2M원 (-39.0%)                          ││
│  │                                                    ││
│  │ 📈 추세: 0으로 수렴 안 함 ⚠️                       ││
│  │    (계속 마이너스 → 비정상 신호)                  ││
│  └────────────────────────────────────────────────────┘│
│                                                          │
│  📊 수량 기준                                            │
│  • 증가: +178개 (평균 +4.2/회)                          │
│  • 감소: -542개 (평균 -4.3/회)                          │
│  • 순: -364개                                            │
│  • 증감 비율: 42건 / 125건 (25%)                        │
│                                                          │
│  🎯 통계 검정                                            │
│  ┌────────────────────────────────────────────────────┐│
│  │ Chi-square 기여도: 51% (전체 중 가장 높음)         ││
│  │ Z-score: -3.82                                     ││
│  │ p-value: 0.00014 (개별 매장 검정)                  ││
│  │                                                    ││
│  │ 🎯 판정: 자연 발생 매우 어려움                     ││
│  │         (99.99% 확률로 비정상 패턴)                ││
│  └────────────────────────────────────────────────────┘│
│                                                          │
│  💡 데이터 해석                                          │
│  • 감소가 증가보다 3배 많음 (정상: 1:1 비율)            │
│  • 누적 손실이 0으로 수렴 안 하고 계속 증가 중          │
│  • 다른 매장과 비교해 통계적으로 유의미한 차이          │
│                                                          │
│  ✅ 권장 조치                                            │
│  • 재고 관리 프로세스 전수 점검                         │
│  • 리카운트 영상 검토 (사용자 판단)                     │
│  • 직원 재교육 또는 시스템 개선                         │
│                                                          │
│  [기간별 추이 →] [리카운트 내역 →]                     │
└──────────────────────────────────────────────────────────┘
```

---

### 화면 3-3: 기간별 추이

```
┌─────────────────────────────────────────────────┐
│  📈 기간별 누적 손익 추이                       │
├─────────────────────────────────────────────────┤
│                                                 │
│  💰 월별 누적 손익 (강남점)                     │
│  ┌─────────────────────────────────────────┐  │
│  │ 손익                                    │  │
│  │  +5M┤                                   │  │
│  │     │                                   │  │
│  │   0M┼─────●─────●─────●               │  │
│  │     │      ╲    ╲    ╲                 │  │
│  │  -5M┤       ●────●────●───●           │  │
│  │     │                  ╲   ╲          │  │
│  │ -10M┤                   ●───●─────●   │  │
│  │     └─────────────────────────────    │  │
│  │     1월 2월 3월 4월 5월 6월 ... 12월  │  │
│  │                                         │  │
│  │ 🎯 추세: 지속적 하락 (0 수렴 안 함)     │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  📊 월별 Chi-square 추세                        │
│  ┌─────────────────────────────────────────┐  │
│  │ χ²                                      │  │
│  │  30┤                          ●         │  │
│  │    │                    ●               │  │
│  │  20┤              ●                     │  │
│  │    │        ●                           │  │
│  │  10┤  ●                                 │  │
│  │    └─────────────────────────────────   │  │
│  │    1월  3월  5월  7월  9월  11월       │  │
│  │                                         │  │
│  │ 임계값 (p=0.05): 11.07                 │  │
│  │ 🎯 7월부터 임계값 초과 (문제 시작)      │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  💡 패턴 분석                                   │
│  • 7월 이전: 정상 범위 (χ² < 11.07)            │
│  • 7월: 문제 시작 (χ² = 15.3)                  │
│  • 이후: 지속적 악화 (χ² 증가)                 │
│                                                 │
│  가능한 원인 (사용자 판단 필요):                │
│  • 7월에 새 직원 입사?                          │
│  • 7월에 프로세스 변경?                         │
│  • 7월에 시스템 업데이트?                       │
└─────────────────────────────────────────────────┘
```

---

### 화면 3-4: 전체 매장 비교

```
┌─────────────────────────────────────────────────┐
│  🏪 전체 매장 통계 비교                         │
├─────────────────────────────────────────────────┤
│                                                 │
│  💰 누적 손익 비교 (12개월)                     │
│  ┌─────────────────────────────────────────┐  │
│  │          순 손익                        │  │
│  │ 강남점   ▓▓▓▓▓▓▓▓  -8.2M 🔴            │  │
│  │ 홍대점   ░░  +1.5M 🟢                   │  │
│  │ 압구정   ░ -0.3M 🟢                     │  │
│  │ 신사점   ░░░  +2.1M 🟢                  │  │
│  │ 청담점   ░░  +1.4M 🟢                   │  │
│  │ 명동점   (±0) 🟢                        │  │
│  │                                         │  │
│  │ 전체: -3.5M (평균: -0.6M/매장)         │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  📊 Z-score 분포                                │
│  ┌─────────────────────────────────────────┐  │
│  │          Z-score                        │  │
│  │  -4  -3  -2  -1   0  +1  +2  +3        │  │
│  │   │───│───│───│───│───│───│───│        │  │
│  │   ●강남(비정상)                         │  │
│  │              ●홍 ●압 ●신 ●청 ●명      │  │
│  │             (정상 범위)                 │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  🎯 Chi-square 기여도                           │
│  강남점: 51% ████████████████████████████      │  │
│  홍대점: 18% ██████████                         │  │
│  압구정: 12% ███████                            │  │
│  신사점:  8% █████                              │  │
│  청담점:  6% ████                               │  │
│  명동점:  5% ███                                │  │
│                                                 │
│  💡 결론                                        │
│  • 강남점이 전체 비정상성의 절반 이상 차지      │  │
│  • 다른 매장은 정상 범위 (±2σ 이내)            │  │
│  • 강남점 문제 해결 시 전체 통계 개선 예상      │  │
└─────────────────────────────────────────────────┘
```

---

### 화면 3-5: 0 수렴 분석

```
┌─────────────────────────────────────────────────┐
│  📊 0 수렴 분석 (정규분포 검증)                 │
├─────────────────────────────────────────────────┤
│                                                 │
│  🎯 개념                                        │
│  자연적인 재고 불일치는 +와 -가 균등하게        │
│  발생하므로 표본이 많아질수록 평균이 0으로      │
│  수렴해야 합니다.                               │
│                                                 │
│  📈 전체 매장 평균 추세                         │
│  ┌─────────────────────────────────────────┐  │
│  │ 평균 손익                               │  │
│  │  +1M┤                                   │  │
│  │     │ ●                                 │  │
│  │   0M┼───●─────●───●─────●───●───●──●  │  │
│  │     │       ╲           ╱             │  │
│  │  -1M┤                                   │  │
│  │     └─────────────────────────────────  │  │
│  │     1월  3월  5월  7월  9월  11월      │  │
│  │                                         │  │
│  │ ✅ 수렴 중 (정상 신호)                  │  │
│  │    표준오차: ±0.2M (감소 추세)          │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  🏪 강남점 추세 (문제 매장)                     │
│  ┌─────────────────────────────────────────┐  │
│  │ 평균 손익                               │  │
│  │  +1M┤                                   │  │
│  │     │                                   │  │
│  │   0M┼●                                  │  │
│  │     │ ╲                                 │  │
│  │  -1M┤  ●                                │  │
│  │     │   ╲                               │  │
│  │  -2M┤    ●                              │  │
│  │     │     ╲___                          │  │
│  │  -3M┤         ●───●───●───●───●       │  │
│  │     └─────────────────────────────────  │  │
│  │     1월  3월  5월  7월  9월  11월      │  │
│  │                                         │  │
│  │ ⚠️ 수렴 안 함 (비정상 신호)             │  │
│  │    계속 마이너스 유지 (평균 -0.68M/월)  │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  📊 통계적 검증                                 │
│  ┌─────────────────────────────────────────┐  │
│  │ One-sample t-test (H0: μ = 0)           │  │
│  │                                         │  │
│  │ 전체: t = -1.24, p = 0.22               │  │
│  │ → 0과 유의미한 차이 없음 (정상) ✅       │  │
│  │                                         │  │
│  │ 강남: t = -5.82, p = 0.0001             │  │
│  │ → 0과 유의미한 차이 있음 (비정상) ⚠️     │  │
│  └─────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## 🗄️ 데이터베이스 구성

### Materialized View 1: 월별 매장별 집계
```sql
CREATE MATERIALIZED VIEW mv_discrepancy_monthly AS
SELECT 
    DATE_TRUNC('month', il.created_at_utc) as month,
    il.store_id,
    s.store_name,
    
    -- 건수
    COUNT(*) as total_adjustments,
    COUNT(*) FILTER (WHERE il.quantity_change > 0) as increase_count,
    COUNT(*) FILTER (WHERE il.quantity_change < 0) as decrease_count,
    
    -- 수량
    SUM(CASE WHEN il.quantity_change > 0 THEN il.quantity_change ELSE 0 END) as increase_qty,
    SUM(CASE WHEN il.quantity_change < 0 THEN ABS(il.quantity_change) ELSE 0 END) as decrease_qty,
    SUM(il.quantity_change) as net_qty,
    
    -- 금액
    SUM(CASE 
        WHEN il.quantity_change > 0 
        THEN il.quantity_change * COALESCE(il.cost_after, p.cost_price, 0)
        ELSE 0 
    END) as increase_value,
    
    SUM(CASE 
        WHEN il.quantity_change < 0 
        THEN ABS(il.quantity_change * COALESCE(il.cost_after, p.cost_price, 0))
        ELSE 0 
    END) as decrease_value,
    
    SUM(il.quantity_change * COALESCE(il.cost_after, p.cost_price, 0)) as net_value
    
FROM inventory_logs il
JOIN stores s ON il.store_id = s.store_id
LEFT JOIN inventory_products p ON il.product_id = p.product_id
WHERE il.event_type = 'counting'
GROUP BY DATE_TRUNC('month', il.created_at_utc), il.store_id, s.store_name;

CREATE INDEX idx_discrepancy_monthly ON mv_discrepancy_monthly(month, store_id);
```

### Materialized View 2: 누적 합계
```sql
CREATE MATERIALIZED VIEW mv_discrepancy_cumulative AS
SELECT 
    il.store_id,
    s.store_name,
    
    -- 전체 기간 누적
    COUNT(*) as total_adjustments,
    COUNT(*) FILTER (WHERE il.quantity_change > 0) as increase_count,
    COUNT(*) FILTER (WHERE il.quantity_change < 0) as decrease_count,
    
    -- 금액
    SUM(CASE 
        WHEN il.quantity_change > 0 
        THEN il.quantity_change * COALESCE(il.cost_after, p.cost_price, 0)
        ELSE 0 
    END) as total_increase_value,
    
    SUM(CASE 
        WHEN il.quantity_change < 0 
        THEN ABS(il.quantity_change * COALESCE(il.cost_after, p.cost_price, 0))
        ELSE 0 
    END) as total_decrease_value,
    
    SUM(il.quantity_change * COALESCE(il.cost_after, p.cost_price, 0)) as net_cumulative_value,
    
    -- 비율
    CASE 
        WHEN COUNT(*) > 0 
        THEN COUNT(*) FILTER (WHERE il.quantity_change > 0) * 100.0 / COUNT(*)
        ELSE 0 
    END as increase_pct,
    
    -- 평균
    AVG(il.quantity_change * COALESCE(il.cost_after, p.cost_price, 0)) as avg_adjustment_value
    
FROM inventory_logs il
JOIN stores s ON il.store_id = s.store_id
LEFT JOIN inventory_products p ON il.product_id = p.product_id
WHERE il.event_type = 'counting'
GROUP BY il.store_id, s.store_name;

CREATE INDEX idx_discrepancy_cumulative ON mv_discrepancy_cumulative(store_id);
```

---

## 🐍 Python 통계 계산

### Chi-square 검정
```python
from scipy.stats import chi2_contingency, norm, ttest_1samp
import pandas as pd
import numpy as np

# 데이터 로드
df = pd.read_sql("""
    SELECT * FROM mv_discrepancy_monthly
    WHERE month >= CURRENT_DATE - INTERVAL '12 months'
""", conn)

# 1. Chi-square 검정 (전체 기간)
observed_qty = df.groupby('store_id')[['increase_count', 'decrease_count']].sum()
chi2_qty, p_qty, dof, expected_qty = chi2_contingency(observed_qty.values)

print(f"수량 Chi-square: χ² = {chi2_qty:.2f}, p = {p_qty:.4f}")

# 금액 기준
observed_val = df.groupby('store_id')[['increase_value', 'decrease_value']].sum()
chi2_val, p_val, _, _ = chi2_contingency(observed_val.values)

print(f"금액 Chi-square: χ² = {chi2_val:.2f}, p = {p_val:.4f}")

# 2. 각 매장의 Chi-square 기여도
contributions = []
for i in range(len(observed_qty)):
    contrib = 0
    for j in range(2):
        contrib += ((observed_qty.values[i][j] - expected_qty[i][j])**2 / 
                    expected_qty[i][j])
    contributions.append(contrib)

observed_qty['chi2_contribution'] = contributions
observed_qty['chi2_contribution_pct'] = (
    observed_qty['chi2_contribution'] / chi2_qty * 100
)

# 3. Z-score (매장별 누적 손익)
cumulative = pd.read_sql("SELECT * FROM mv_discrepancy_cumulative", conn)
cumulative['z_score'] = (
    (cumulative['net_cumulative_value'] - cumulative['net_cumulative_value'].mean()) / 
    cumulative['net_cumulative_value'].std()
)

# 4. 0 수렴 검증 (t-test)
# 전체 평균이 0과 유의미한 차이가 있는가?
monthly_avg = df.groupby('month')['net_value'].sum()
t_stat, p_value = ttest_1samp(monthly_avg, 0)

print(f"\n0 수렴 검정: t = {t_stat:.2f}, p = {p_value:.4f}")
if p_value > 0.05:
    print("✅ 0으로 수렴 중 (정상)")
else:
    print("⚠️ 0으로 수렴 안 함 (비정상)")

# 5. 매장별 0 수렴 검정
for store_id in df['store_id'].unique():
    store_data = df[df['store_id'] == store_id]['net_value']
    if len(store_data) >= 3:  # 최소 3개월 데이터
        t_stat, p_value = ttest_1samp(store_data, 0)
        store_name = df[df['store_id'] == store_id]['store_name'].iloc[0]
        
        if p_value < 0.001:
            status = "🔴 비정상"
        elif p_value < 0.05:
            status = "🟡 주의"
        else:
            status = "🟢 정상"
        
        print(f"{store_name}: t = {t_stat:.2f}, p = {p_value:.4f} {status}")

# 6. 판정 함수
def classify_store(row):
    """매장 상태 판정"""
    z_score = row['z_score']
    chi2_contrib = row['chi2_contribution_pct']
    
    # 개별 매장 Chi-square (이항분포 검정)
    from scipy.stats import binom_test
    p_individual = binom_test(
        row['decrease_count'],
        row['increase_count'] + row['decrease_count'],
        0.5,
        alternative='two-sided'
    )
    
    if abs(z_score) >= 3 and p_individual < 0.001:
        return '🔴 비정상 (통계적 이상)'
    elif abs(z_score) >= 2 and p_individual < 0.05:
        return '🟡 주의 (모니터링)'
    else:
        return '🟢 정상'

cumulative = cumulative.merge(
    observed_qty[['chi2_contribution_pct']], 
    left_on='store_id', 
    right_index=True
)
cumulative['status'] = cumulative.apply(classify_store, axis=1)

# 결과 저장 (API에서 사용)
result = {
    'overall': {
        'chi2_qty': chi2_qty,
        'p_qty': p_qty,
        'chi2_val': chi2_val,
        'p_val': p_val,
        't_stat': t_stat,
        'p_convergence': p_value,
        'converging_to_zero': p_value > 0.05
    },
    'stores': cumulative.to_dict('records')
}

import json
print(json.dumps(result, indent=2, default=str))
```

---

## 🚀 API 엔드포인트

### GET /api/discrepancy/overview
```python
@app.get("/api/discrepancy/overview")
async def get_overview(period: str = "all"):
    """
    통계 대시보드 데이터
    period: "7d", "30d", "all"
    """
    # Python에서 계산한 통계 반환
    return {
        "period": period,
        "cumulative": {
            "increase_value": 45200000,
            "decrease_value": 48700000,
            "net_value": -3500000,
            "net_pct": -7.2,
            "converging_to_zero": True
        },
        "chi_square": {
            "chi2": 24.82,
            "p_value": 0.0002,
            "interpretation": "자연 발생 어려움"
        },
        "stores": [
            {
                "store_id": "...",
                "store_name": "강남점",
                "net_value": -8200000,
                "status": "🔴 비정상",
                "z_score": -3.82,
                "chi2_contribution_pct": 51
            },
            ...
        ]
    }
```

### GET /api/discrepancy/store/{store_id}
```python
@app.get("/api/discrepancy/store/{store_id}")
async def get_store_detail(store_id: str, period: str = "all"):
    """
    매장별 상세 데이터
    """
    return {
        "store_id": store_id,
        "store_name": "강남점",
        "cumulative": {
            "increase_value": 12800000,
            "decrease_value": 21000000,
            "net_value": -8200000,
            "increase_count": 42,
            "decrease_count": 125,
            "increase_pct": 25.1
        },
        "statistics": {
            "z_score": -3.82,
            "chi2_contribution": 51,
            "p_value": 0.00014,
            "converging_to_zero": False
        },
        "monthly_trend": [
            {"month": "2025-01", "net_value": -200000},
            {"month": "2025-02", "net_value": -450000},
            ...
        ]
    }
```

### GET /api/discrepancy/trend
```python
@app.get("/api/discrepancy/trend")
async def get_trend(store_id: str = None):
    """
    기간별 추이 데이터
    """
    return {
        "monthly_chi_square": [
            {"month": "2025-01", "chi2": 8.2, "p_value": 0.15},
            {"month": "2025-02", "chi2": 10.5, "p_value": 0.06},
            {"month": "2025-07", "chi2": 15.3, "p_value": 0.009},
            ...
        ],
        "cumulative_net_value": [
            {"month": "2025-01", "value": -200000, "std_error": 150000},
            {"month": "2025-02", "value": -650000, "std_error": 220000},
            ...
        ]
    }
```

---

## 📋 구현 체크리스트

### Phase 1: 데이터베이스 (1일)
- [ ] mv_discrepancy_monthly 생성
- [ ] mv_discrepancy_cumulative 생성
- [ ] 인덱스 추가
- [ ] 자동 리프레시 설정 (pg_cron)

### Phase 2: Python 통계 (2일)
- [ ] Chi-square 계산 함수
- [ ] Z-score 계산
- [ ] t-test (0 수렴 검증)
- [ ] 판정 로직
- [ ] 단위 테스트

### Phase 3: API (2일)
- [ ] GET /overview
- [ ] GET /store/{id}
- [ ] GET /trend
- [ ] 캐싱 (Redis)
- [ ] API 테스트

### Phase 4: Frontend (5일)
- [ ] 대시보드 화면
- [ ] 매장별 상세
- [ ] 기간별 추이 차트
- [ ] 0 수렴 분석
- [ ] 전체 매장 비교

### Phase 5: 테스트 & 최적화 (2일)
- [ ] 성능 테스트
- [ ] 데이터 검증
- [ ] 통계 검증 (전문가 리뷰)
- [ ] UI/UX 테스트

---

## ⚠️ 주의사항

### 1. 통계는 판정만, 원인은 사용자
```
❌ "CCTV 15:30 확인하세요"
✅ "통계적으로 이상합니다. 조사하세요"
```

### 2. 표본이 적으면 신뢰도 낮음
```
10건 미만: 통계 의미 없음
30건 이상: 신뢰 가능
100건 이상: 높은 신뢰도
```

### 3. 0 수렴은 시간 필요
```
1개월: 수렴 판단 어려움
3개월: 추세 확인 가능
6개월+: 명확한 판단
```

### 4. 금액 vs 수량 둘 다 확인
```
수량만: 고가/저가 무시
금액만: 수량 무시
→ 둘 다 이상해야 확실!
```

이제 완벽합니까?

---

## 📦 시스템 4: 재고 주문 최적화

### 🎯 사용자 질문
1. **"재고 관리 잘 되고 있어?"** → 종합 상태
2. **"뭘 주문해야 해?"** → 액션 리스트
3. **"왜 그래야 해?"** → 근거 (통계)

---

### 📱 화면 4-1: 재고 상태 대시보드 (첫 화면)
```
┌─────────────────────────────────────────────────┐
│  🎯 재고 상태: 양호 ✅                          │
├─────────────────────────────────────────────────┤
│                                                 │
│  📊 종합 점수: 82/100                           │
│  ████████████████████████░░░░░                  │
│                                                 │
│  핵심 지표                                      │
│  • 품절률: 2.3% (목표: <5% ✅)                 │
│  • 과잉재고: 8.1% (목표: <10% ✅)              │
│  • 재고회전율: 4.2회/년 (목표: >4 ✅)          │
│                                                 │
│  ⚠️ 즉시 주문 필요 (95% 신뢰수준)               │
│  87개 제품                                      │
│                                                 │
│  Top 3 긴급 주문                                │
│  ┌─────────────────────────────────────────┐  │
│  │ 1. 샤넬 클래식 플랩                     │  │
│  │    현재: 2개 | 필요: 15개 | 주문: 13개 │  │
│  │    이유: 일평균 0.5개 판매             │  │
│  │    [주문서 작성 →]                     │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  📈 재고 효율                                   │
│  • 안정적 상품: 645개 (52%) - 관리 용이        │
│  • 변동성 높음: 188개 (15%) - 안전재고 필요    │
│                                                 │
│  [전체 주문 리스트 →]                          │
│  [제품 분류 보기 →]                            │
└─────────────────────────────────────────────────┘
```

**ABC 분석 설명:**
```
ABC 분석 = 매출 기여도로 중요도 분류

A등급 (20% 제품): 매출 80% 차지 → 중요!
  → 99% 신뢰수준 안전재고 (재고 부족 방지)
  
B등급 (30% 제품): 매출 15% 차지 → 보통
  → 95% 신뢰수준 안전재고
  
C등급 (50% 제품): 매출 5% 차지 → 덜 중요
  → 최소 재고 또는 주문 생산
```

**필요한 데이터:**
```sql
-- 재고 종합 점수
WITH metrics AS (
    SELECT 
        -- 품절률 (현재 재고 = 0인 제품 비율)
        COUNT(*) FILTER (WHERE current_stock = 0) * 100.0 / COUNT(*) as stockout_rate,
        
        -- 과잉재고율 (재고 > 재주문점 × 2)
        COUNT(*) FILTER (WHERE current_stock > reorder_point_95 * 2) * 100.0 / COUNT(*) as overstock_rate,
        
        -- 평균 재고회전율
        AVG(inventory_turnover) as avg_turnover,
        
        -- 주문 필요 제품 수
        COUNT(*) FILTER (WHERE current_stock < reorder_point_95) as reorder_needed_count
    FROM mv_inventory_optimization
    WHERE avg_daily_demand > 0  -- 판매 이력 있는 제품만
)
SELECT 
    -- 점수 계산 (각 40, 30, 30점)
    CASE 
        WHEN stockout_rate <= 3 THEN 40
        WHEN stockout_rate <= 5 THEN 30
        WHEN stockout_rate <= 7 THEN 20
        ELSE 10
    END +
    CASE 
        WHEN overstock_rate <= 5 THEN 30
        WHEN overstock_rate <= 10 THEN 25
        WHEN overstock_rate <= 15 THEN 20
        ELSE 10
    END +
    CASE 
        WHEN avg_turnover >= 5 THEN 30
        WHEN avg_turnover >= 4 THEN 25
        WHEN avg_turnover >= 3 THEN 20
        ELSE 10
    END as total_score,
    
    stockout_rate,
    overstock_rate,
    avg_turnover,
    reorder_needed_count
FROM metrics;

-- Top 3 긴급 주문
SELECT 
    product_name,
    current_stock,
    reorder_point_95,
    reorder_point_95 - current_stock as order_qty,
    avg_daily_demand,
    days_of_inventory  -- 현재 재고로 며칠 버틸 수 있나
FROM mv_inventory_optimization
WHERE current_stock < reorder_point_95
ORDER BY (reorder_point_95 - current_stock) DESC
LIMIT 3;
```

---

### 📱 화면 4-2: 주문 리스트 (전체 보기)
```
┌──────────────────────────────────────────────────────────┐
│  📋 주문 필요 제품 (87개)                                │
│                                                          │
│  필터: [🔴긴급(35) ▼] [A등급 ▼] [전체 카테고리 ▼]      │
├────┬──────────┬────┬────┬────┬────────┬──────┬─────────┤
│우선│ 제품     │현재│필요│주문│일판매  │버틸일│ 액션    │
├────┼──────────┼────┼────┼────┼────────┼──────┼─────────┤
│ 🔴│샤넬 플랩 │ 2개│15개│13개│ 0.5개/일│ 4일  │[주문▶] │
├────┼──────────┼────┼────┼────┼────────┼──────┼─────────┤
│ 🔴│에르메스  │ 5개│18개│13개│ 0.6개/일│ 8일  │[주문▶] │
├────┼──────────┼────┼────┼────┼────────┼──────┼─────────┤
│ 🟡│LV 지갑   │12개│20개│ 8개│ 0.7개/일│17일  │[주문▶] │
└────┴──────────┴────┴────┴────┴────────┴──────┴─────────┘

🔴 긴급 (버틸일 < 7일): 즉시 주문
🟡 보통 (7-14일): 1주일 내 주문
🟢 여유 (14일+): 모니터링

[주문서 일괄 생성 →]
```

**필요한 데이터:**
```sql
-- 주문 리스트 (우선순위별)
SELECT 
    product_id,
    product_name,
    category_name,
    current_stock,
    reorder_point_95,
    reorder_point_95 - current_stock as suggested_order_qty,
    avg_daily_demand,
    days_of_inventory,
    
    -- ABC 등급 (Python에서 계산해서 JOIN)
    abc_class,
    
    -- 우선순위
    CASE 
        WHEN days_of_inventory < 7 THEN 'Critical'
        WHEN days_of_inventory < 14 THEN 'Warning'
        ELSE 'Normal'
    END as priority
FROM mv_inventory_optimization
WHERE current_stock < reorder_point_95
ORDER BY 
    CASE 
        WHEN days_of_inventory < 7 THEN 1
        WHEN days_of_inventory < 14 THEN 2
        ELSE 3
    END,
    days_of_inventory ASC,
    (reorder_point_95 - current_stock) DESC;
```

---

### 📱 화면 4-3: 제품 분류 (클릭 시)
```
┌─────────────────────────────────────────────────┐
│  📊 재고 제품 분류                              │
├─────────────────────────────────────────────────┤
│                                                 │
│  💎 A등급 제품 (249개, 20%)                    │
│  매출 기여: 196M원 (80%)                        │
│  ┌─────────────────────────────────────────┐  │
│  │ 전략: 절대 품절 금지                   │  │
│  │ 안전재고: 99% 신뢰수준 (높음)          │  │
│  │ 모니터링: 매일                         │  │
│  │                                         │  │
│  │ 주문 필요: 45개                        │  │
│  │ [리스트 보기 →]                        │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  💼 B등급 제품 (187개, 15%)                    │
│  매출 기여: 37M원 (15%)                         │
│  ┌─────────────────────────────────────────┐  │
│  │ 전략: 적정 재고 유지                   │  │
│  │ 안전재고: 95% 신뢰수준 (보통)          │  │
│  │ 모니터링: 주간                         │  │
│  │                                         │  │
│  │ 주문 필요: 32개                        │  │
│  │ [리스트 보기 →]                        │  │
│  └─────────────────────────────────────────┘  │
│                                                 │
│  📦 C등급 제품 (809개, 65%)                    │
│  매출 기여: 12M원 (5%)                          │
│  ┌─────────────────────────────────────────┐  │
│  │ 전략: 최소 재고 또는 주문 생산         │  │
│  │ 안전재고: 낮음 또는 없음               │  │
│  │ 모니터링: 월간                         │  │
│  │                                         │  │
│  │ 주문 필요: 10개                        │  │
│  │ 추천: 248개 제품 단종 검토             │  │
│  │ [리스트 보기 →]                        │  │
│  └─────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

**ABC 분류 계산 (Python):**
```python
import pandas as pd

df = pd.read_sql("SELECT * FROM mv_inventory_optimization", conn)

# 매출 기준 정렬
df = df.sort_values('total_revenue_90d', ascending=False)

# 누적 매출 비율
df['cumulative_revenue'] = df['total_revenue_90d'].cumsum()
df['cumulative_pct'] = df['cumulative_revenue'] / df['total_revenue_90d'].sum()

# ABC 분류
df['abc_class'] = df['cumulative_pct'].apply(
    lambda x: 'A' if x <= 0.80 else ('B' if x <= 0.95 else 'C')
)

# DB에 다시 저장 (새 컬럼으로)
```

---

### 📱 화면 4-4: 수요 변동성 분석 (상세)
```
┌─────────────────────────────────────────────────┐
│  📈 수요 패턴 분석                              │
├─────────────────────────────────────────────────┤
│                                                 │
│  🟢 안정적 (Stable) - 645개 (52%)              │
│  변동계수 < 0.5                                 │
│  ████████████████████████                       │
│  → 관리 용이, 안전재고 적게 필요               │
│                                                 │
│  🟡 보통 (Moderate) - 412개 (33%)              │
│  변동계수 0.5-1.0                               │
│  ████████████████                               │
│  → 적절한 안전재고 필요                        │
│                                                 │
│  🔴 변동성 높음 (Volatile) - 188개 (15%)       │
│  변동계수 > 1.0                                 │
│  ███████                                        │
│  → 높은 안전재고 또는 주문 생산 검토           │
│                                                 │
│  [각 그룹 제품 보기 →]                         │
└─────────────────────────────────────────────────┘
```

**변동계수 (CV) 설명:**
```
CV = 표준편차 / 평균

예시:
- 제품 A: 평균 10개/일, 표준편차 2개 → CV = 0.2 (안정)
- 제품 B: 평균 10개/일, 표준편차 8개 → CV = 0.8 (변동)
- 제품 C: 평균 10개/일, 표준편차 15개 → CV = 1.5 (매우 변동)

CV 낮음 → 예측 쉬움 → 안전재고 적게
CV 높음 → 예측 어려움 → 안전재고 많이
```

---

## 🔄 Materialized View 최종 리스트

### 시스템 1: 수익률 분석 (3개 View)
1. `mv_sales_overview_monthly` - 월별 종합
2. `mv_sales_by_category_monthly` - 카테고리별
3. `mv_sales_by_product_monthly` - 제품별 (문제 있을 때만 조회)

### 시스템 2: 공급망 분석 (4개 View)
1. `mv_supply_chain_overview_monthly` - 종합 점수
2. `mv_supply_chain_stages_monthly` - 단계별 오류
3. `mv_supply_chain_product_errors` - **적분값** ⭐ (NEW!)
4. `mv_supplier_performance_monthly` - 공급자 성과

### 시스템 3: 도난 분석 (2개 View)
1. `mv_theft_analysis_monthly` - 매장별 통계
2. `mv_lost_products_monthly` - 제품별 분실

### 시스템 4: 재고 최적화 (1개 View)
1. `mv_inventory_optimization` - 종합 (ABC는 Python에서)

**총 10개 View** (더 효율적!)

---

## 🎯 UI 설계 원칙 요약

### ✅ 두괄식 구조
1. **결론** (문제 있나? 없나?)
2. **근거** (왜?)
3. **액션** (뭘 해야 하나?)

### ✅ 전체 → 세부
- 첫 화면: 한눈에 파악
- 클릭: 상세 드릴다운
- 사용자가 원하는 만큼만

### ✅ 액션 중심
- "이 상품 주문하세요" (명확)
- "통계적으로 유의미합니다" (근거)
- "CCTV 확인하세요" (다음 단계)

### ✅ 불필요한 정보 숨기기
- 제품 전체 리스트 ❌
- 문제 있는 제품만 ✅
- 정상은 "정상입니다" 한 줄

이제 구현 시작할까요?
