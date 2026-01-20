# 📊 Inventory Optimization V2 - 통계 기반 재고 최적화

> **목표**: 모든 업종에서 작동하는 통계 기반 재고 최적화
> **접근**: 하드코딩(7일/14일) → P10/P25 자동 계산

---

## 🎯 핵심 개념

### 왜 통계적 접근인가?

```
하드코딩 방식의 문제:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
모든 회사에 7일/14일 적용
→ 명품점: 7일이면 안전한데 긴급으로 분류됨 ❌
→ 편의점: 7일이면 이미 늦었는데 정상으로 분류됨 ❌


P10/P25 통계 방식:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
회사 데이터에서 자동 계산
→ 명품점: P10=10일, P25=25일 (느린 회전 반영)
→ 편의점: P10=1일, P25=2일 (빠른 회전 반영)
→ 각 회사 상황에 맞게! ✅
```

### P10, P25란?

```
100개 상품의 "남은 재고일"을 정렬:

[1, 1, 2, 2, 3, 3, 4, 5, 6, 7, ... , 50, 60, 80, 100, 150]
 ↑                    ↑
P10                  P25
(하위 10%)          (하위 25%)

P10 = "가장 위험한 10%의 경계선" → 🔴 긴급 기준
P25 = "위험한 25%의 경계선" → 🟡 주의 기준
```

---

## 📈 계산 공식

### 남은 재고일 (Days of Inventory)

```
남은 재고일 = 현재 재고량 ÷ 일평균 판매량

예시:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
프라다지갑:
• 현재 재고: 1개
• 일평균 판매: 2개/일
• 남은 재고일: 1 ÷ 2 = 0.5일

→ "지금 속도로 팔리면 0.5일 후 품절"
```

### 임계값 결정 로직

```
샘플 수 >= 30 → 통계 계산 (P10, P25)
샘플 수 < 30  → 기본값 사용 (7일, 14일)
```

---

## 🗂️ 데이터베이스 객체

### Materialized View

| 이름 | 설명 |
|------|------|
| `v_company_reorder_thresholds` | 회사별 P10/P25 임계값 |

### Views

| 이름 | 설명 |
|------|------|
| `v_inventory_status` | 상품별 Yes/No 상태 분류 (핵심!) |
| `v_company_inventory_health` | 회사별 건강도 요약 |
| `v_category_reorder_summary` | 카테고리별 요약 |
| `v_brand_reorder_summary` | 브랜드별 요약 |

### RPC 함수

| 이름 | 설명 |
|------|------|
| `get_inventory_health_dashboard` | 대시보드 데이터 (한 번의 호출로 모든 데이터) |
| `get_reorder_by_category` | 카테고리별 목록 |
| `get_reorder_by_brand` | 브랜드별 목록 |
| `get_reorder_products_paged` | 상품 목록 (페이지네이션) |
| `refresh_inventory_optimization_views` | View 새로고침 |

---

## 🚀 Flutter에서 사용법

### 대시보드 데이터 가져오기

```dart
// 한 번의 RPC 호출로 모든 데이터 제공!
final dashboard = await supabase.rpc(
  'get_inventory_health_dashboard',
  params: {'p_company_id': companyId},
);

final health = dashboard['health'];
final thresholds = dashboard['thresholds'];
final topCategories = dashboard['top_categories'];
final urgentProducts = dashboard['urgent_products'];
final abnormalProducts = dashboard['abnormal_products'];
```

### 반환 데이터 구조

```dart
// health 객체
health['total_products']       // 전체 상품 수: 5342
health['stockout_count']       // 품절: 3785
health['stockout_rate']        // 품절률: 70.9%
health['critical_count']       // 긴급: 72
health['critical_rate']        // 긴급률: 1.3%
health['warning_count']        // 주의: 59
health['warning_rate']         // 주의율: 1.1%
health['reorder_needed_count'] // 재주문필요 (품절제외): 458
health['overstock_count']      // 과잉: 6
health['overstock_rate']       // 과잉률: 0.1%
health['dead_stock_count']     // Dead Stock: 1019
health['dead_stock_rate']      // Dead Stock률: 19.1%
health['abnormal_count']       // 이상(음수재고): 55
health['normal_count']         // 정상: 19

// thresholds 객체
thresholds['critical_days']    // 긴급 기준: 1.0일
thresholds['warning_days']     // 주의 기준: 2.0일
thresholds['threshold_source'] // 'calculated' 또는 'default'
thresholds['sample_size']      // 샘플 수: 458
```

### 카테고리별 데이터

```dart
final categories = await supabase.rpc(
  'get_reorder_by_category',
  params: {'p_company_id': companyId},
);

// 각 카테고리 데이터
categories[0]['category_name']        // "Bag"
categories[0]['total_products']       // 2473
categories[0]['reorder_needed_count'] // 169
categories[0]['critical_count']       // 30
categories[0]['stockout_count']       // 1889
```

### 상품 목록 (페이지네이션)

```dart
final products = await supabase.rpc(
  'get_reorder_products_paged',
  params: {
    'p_company_id': companyId,
    'p_category_id': categoryId,     // 선택적
    'p_status_filter': 'critical',   // 선택적: 'critical', 'warning', 'stockout', 'overstock', 'dead_stock', 'reorder_needed', 'abnormal'
    'p_page': 0,
    'p_page_size': 20,
  },
);

products['items']       // 상품 리스트
products['total_count'] // 전체 개수
products['page']        // 현재 페이지
products['page_size']   // 페이지 크기
products['has_more']    // 더 있는지
```

---

## 📱 UI 표시 예시

### 대시보드 카드

```
┌─────────────────────────────────────────────────────────────┐
│  📊 재고 건강도 (Inventory Health)                          │
│                                                             │
│  ┌─────────────┬─────────────┬─────────────┐               │
│  │   품절      │  주문필요   │   과잉      │               │
│  │   70.9%    │    8.6%    │    0.1%    │               │
│  │  3,785개   │   458개    │     6개    │               │
│  │     🔴     │     🟡     │     🐌     │               │
│  └─────────────┴─────────────┴─────────────┘               │
│                                                             │
│  💀 Dead Stock: 1,019개 (19.1%)                            │
│  ⚠️ Abnormal (음수재고): 55개 (1.0%)                       │
│                                                             │
│  📈 임계값: P10=1일, P25=2일 (자동계산)                     │
│                                                             │
│  [카테고리별] [브랜드별] [전체상품]                         │
└─────────────────────────────────────────────────────────────┘
```

### 상태별 필터 칩

```dart
// 필터 옵션
enum InventoryFilter {
  all,           // 전체
  critical,      // 🔴 긴급
  warning,       // 🟡 주의
  stockout,      // ⚫ 품절
  reorderNeeded, // 📦 재주문필요
  overstock,     // 🐌 과잉
  deadStock,     // 💀 안팔림
  abnormal,      // ⚠️ 이상
}
```

---

## 🔄 상태 분류 로직

### Yes/No Boolean 필드

| 필드 | 조건 | 설명 |
|------|------|------|
| `is_abnormal` | current_stock < 0 | 음수 재고 (데이터 이상) |
| `is_stockout` | current_stock = 0 | 품절 |
| `is_critical` | 재고>0 & 재고<재주문점 & 재고일<=P10 | 긴급 |
| `is_warning` | 재고>0 & 재고<재주문점 & P10<재고일<=P25 | 주의 |
| `is_reorder_needed` | current_stock < reorder_point | 재주문 필요 |
| `is_overstock` | 재고>0 & 판매있음 & 재고일>90 | 과잉 |
| `is_dead_stock` | 90일간 판매=0 & 재고>0 | 안 팔림 |

### status_label (UI 표시용)

```
'abnormal'       → ⚠️ 이상 (음수재고)
'stockout'       → ⚫ 품절
'critical'       → 🔴 긴급
'warning'        → 🟡 주의
'reorder_needed' → 📦 재주문필요
'overstock'      → 🐌 과잉
'dead_stock'     → 💀 안팔림
'normal'         → 🟢 정상
```

### priority_rank (정렬용)

```
1 = abnormal (가장 먼저 해결)
2 = stockout
3 = critical
4 = warning
5 = reorder_needed
6 = dead_stock / overstock
7 = normal
```

---

## 📊 실제 데이터 예시

### 회사 563ad9ff 결과

```
임계값:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
샘플 수: 458개 (충분!)
P10 (긴급): 1.0일
P25 (주의): 2.0일
소스: calculated (자동계산)

건강도:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
총 상품: 5,342개
품절: 3,785개 (70.9%)
긴급: 72개 (1.3%)
주의: 59개 (1.1%)
재주문필요: 458개
과잉: 6개 (0.1%)
Dead Stock: 1,019개 (19.1%)
이상(음수): 55개 (1.0%)
정상: 19개
```

---

## ⚠️ 주의사항

### 음수 재고 처리

일부 상품에 음수 재고가 존재함 (데이터 이상)
- `is_abnormal = true`로 분류
- `priority_rank = 1`로 최우선 표시
- 데이터 정리 필요 알림

### Materialized View 새로고침

```sql
-- 수동 새로고침
SELECT refresh_inventory_optimization_views();

-- 또는 직접
REFRESH MATERIALIZED VIEW CONCURRENTLY v_company_reorder_thresholds;
```

권장: 일 1회 또는 재고 변동 후 새로고침

---

## 🔗 관련 파일

```
supabase/migrations/
└── 20260112_inventory_optimization_v2.sql

lib/features/inventory_analysis/optimization/
├── INVENTORY_OPTIMIZATION_V2.md (이 파일)
├── data/
│   ├── datasources/
│   │   └── inventory_optimization_datasource.dart
│   ├── models/
│   │   ├── inventory_health_dto.dart
│   │   ├── category_summary_dto.dart
│   │   └── inventory_product_dto.dart
│   └── repositories/
│       └── inventory_optimization_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── inventory_health.dart
│   │   ├── threshold_info.dart
│   │   ├── category_summary.dart
│   │   └── inventory_product.dart
│   └── repositories/
│       └── inventory_optimization_repository.dart
└── presentation/
    ├── pages/
    │   ├── inventory_dashboard_page.dart
    │   ├── category_list_page.dart
    │   └── product_list_page.dart
    ├── providers/
    │   ├── inventory_dashboard_notifier.dart
    │   └── inventory_products_notifier.dart
    └── widgets/
        ├── health_summary_card.dart
        ├── threshold_info_chip.dart
        ├── category_tile.dart
        └── product_tile.dart
```

---

## 🎯 요약

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 통계 기반 자동 임계값 (P10/P25)
✅ 8가지 상태 분류 (Yes/No)
✅ 한 번의 RPC로 대시보드 데이터
✅ 페이지네이션 지원
✅ 7가지 필터 옵션
✅ 음수 재고 감지 (abnormal)
✅ 모든 업종 자동 적응
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
