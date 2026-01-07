# 📱 인벤토리 분석 시스템 - UI 구현 플랜 (v2 - Hybrid Approach)

## 🎯 2025 UI Trends 적용

### Hybrid Approach 채택 이유
| 방식 | 장점 | 단점 | 선택 |
|------|------|------|------|
| Single Page | 빠른 탐색 | 느린 로딩, 과부하 | ❌ |
| Multi-Page Only | 분리된 관심사 | Overview 없음 | ❌ |
| **Hybrid** | 빠른 Overview + 상세 드릴다운 | - | ✅ |

### 적용된 2025 트렌드
- **Progressive Disclosure** - Dashboard → Detail 드릴다운
- **Action-Oriented** - 숫자 + 상태 + 액션 제안
- **Low Cognitive Load** - 한 화면에 4개 카드 요약만
- **Status Indicators** - ✅🟡🔴⚠️ 시각적 상태
- **Mobile-First** - 2×2 그리드 → 모바일 1열 스크롤

---

## 🏗️ 프로젝트 구조

### 기술 스택
| 항목 | 기술 |
|------|------|
| Framework | Flutter 3.x |
| State Management | **Riverpod 2.5** + riverpod_annotation |
| Navigation | **go_router 13.x** |
| Charts | **fl_chart 0.69** |
| Design System | Toss Design System (자체 구현) |
| Backend | Supabase (RPC 호출) |
| Code Generation | freezed, json_serializable |

### 구현 위치
```
lib/features/inventory_management/    # 기존 폴더에 추가
├── data/
│   ├── datasources/
│   │   └── inventory_analytics_datasource.dart    # NEW
│   ├── repositories/
│   │   └── inventory_analytics_repository_impl.dart  # NEW
│   └── models/
│       └── analytics/                              # NEW
│           ├── sales_dashboard_model.dart
│           ├── bcg_matrix_model.dart
│           ├── supply_chain_model.dart
│           ├── discrepancy_model.dart
│           └── inventory_optimization_model.dart
├── domain/
│   ├── entities/
│   │   └── analytics/                              # NEW
│   │       ├── sales_dashboard.dart
│   │       ├── bcg_category.dart
│   │       ├── supply_chain_status.dart
│   │       ├── discrepancy_overview.dart
│   │       └── inventory_optimization.dart
│   └── repositories/
│       └── inventory_analytics_repository.dart     # NEW
├── presentation/
│   ├── pages/
│   │   └── analytics/                              # NEW
│   │       ├── analytics_hub_page.dart            # 메인 허브 (Dashboard)
│   │       ├── sales_analysis_page.dart           # 시스템 1
│   │       ├── supply_chain_page.dart             # 시스템 2
│   │       ├── discrepancy_analysis_page.dart     # 시스템 3
│   │       └── inventory_optimization_page.dart   # 시스템 4
│   ├── widgets/
│   │   └── analytics/                              # NEW
│   │       ├── common/
│   │       │   ├── score_indicator.dart
│   │       │   ├── trend_badge.dart
│   │       │   ├── metric_card.dart
│   │       │   ├── status_chip.dart
│   │       │   └── analytics_summary_card.dart
│   │       ├── charts/
│   │       │   ├── bcg_matrix_chart.dart
│   │       │   ├── trend_line_chart.dart
│   │       │   └── progress_bar.dart
│   │       ├── hub/
│   │       │   └── analytics_card.dart
│   │       ├── sales/
│   │       │   ├── sales_summary_card.dart
│   │       │   ├── bcg_quadrant_card.dart
│   │       │   └── category_detail_sheet.dart
│   │       ├── supply_chain/
│   │       │   ├── supply_chain_score_card.dart
│   │       │   └── problem_product_tile.dart
│   │       ├── discrepancy/
│   │       │   ├── discrepancy_summary_card.dart
│   │       │   ├── store_comparison_tile.dart
│   │       │   └── insufficient_data_view.dart
│   │       └── optimization/
│   │           ├── optimization_score_card.dart
│   │           └── reorder_product_tile.dart
│   └── providers/
│       └── analytics/                              # NEW
│           ├── analytics_providers.dart
│           └── states/
│               ├── analytics_hub_state.dart
│               ├── sales_analysis_state.dart
│               ├── supply_chain_state.dart
│               ├── discrepancy_state.dart
│               └── optimization_state.dart
└── di/
    └── analytics_providers.dart                    # NEW
```

---

## 📊 5개 페이지 구조 (Hybrid)

### 페이지 구성
```
📊 Inventory Analytics
│
├─ 🏠 Page 0: AnalyticsHubPage (Dashboard Overview)
│   ├─ 수익률 분석 카드 → Page 1로 이동
│   ├─ 재고 최적화 카드 → Page 4로 이동
│   ├─ 공급망 분석 카드 → Page 2로 이동
│   └─ 재고 불일치 카드 → Page 3으로 이동
│
├─ 📈 Page 1: SalesAnalysisPage (수익률 분석)
├─ 🚚 Page 2: SupplyChainPage (공급망 분석)
├─ 🔍 Page 3: DiscrepancyAnalysisPage (재고 불일치)
└─ 📦 Page 4: InventoryOptimizationPage (재고 최적화)
```

### 라우팅 구조
```
/inventory/analytics              → AnalyticsHubPage
/inventory/analytics/sales        → SalesAnalysisPage
/inventory/analytics/supply-chain → SupplyChainPage
/inventory/analytics/discrepancy  → DiscrepancyAnalysisPage
/inventory/analytics/optimization → InventoryOptimizationPage
```

---

## 📱 Page 0: Analytics Hub (Dashboard Overview)

### 화면 레이아웃
```
┌─────────────────────────────────────────────────┐
│  [←] 재고 분석                                  │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌───────────────────┬───────────────────┐     │
│  │ 📈 수익률 분석    │ 📦 재고 최적화    │     │
│  │                   │                   │     │
│  │ ✅ 양호           │ 🔴 34개 주문 필요 │     │
│  │ +45.8% 성장       │ 긴급 13개         │     │
│  │ 1.1B 매출         │                   │     │
│  │                   │                   │     │
│  │ [상세 보기 →]     │ [상세 보기 →]     │     │
│  └───────────────────┴───────────────────┘     │
│                                                 │
│  ┌───────────────────┬───────────────────┐     │
│  │ 🚚 공급망 분석    │ 🔍 재고 불일치    │     │
│  │                   │                   │     │
│  │ ✅ 정상           │ ⚠️ 데이터 부족    │     │
│  │ 위험 제품 0개     │ 12건 이벤트       │     │
│  │                   │                   │     │
│  │ [상세 보기 →]     │ [상세 보기 →]     │     │
│  └───────────────────┴───────────────────┘     │
│                                                 │
│  ─────────────────────────────────────────     │
│                                                 │
│  💡 빠른 액션                                   │
│  [리포트 생성] [긴급 주문] [재고 확인]         │
│                                                 │
└─────────────────────────────────────────────────┘
```

### RPC 호출 매핑
| 카드 | RPC 함수 | 표시 데이터 |
|------|----------|-------------|
| 수익률 분석 | `get_sales_dashboard` | 상태, 성장률, 매출 |
| 재고 최적화 | `get_inventory_optimization_dashboard` | 주문 필요 수, 긴급 수 |
| 공급망 분석 | `get_supply_chain_status` | 상태, 위험 제품 수 |
| 재고 불일치 | `get_discrepancy_overview` | 상태, 이벤트 수 |

### Provider 설계
```dart
// providers/analytics/analytics_providers.dart

/// Hub 페이지용 모든 데이터를 병렬 로드
@riverpod
class AnalyticsHubNotifier extends _$AnalyticsHubNotifier {
  @override
  Future<AnalyticsHubState> build() async {
    final companyId = ref.watch(appStateProvider).companyId;

    // 4개 RPC 병렬 호출
    final results = await Future.wait([
      ref.read(inventoryAnalyticsRepositoryProvider).getSalesDashboard(companyId),
      ref.read(inventoryAnalyticsRepositoryProvider).getOptimizationDashboard(companyId),
      ref.read(inventoryAnalyticsRepositoryProvider).getSupplyChainStatus(companyId),
      ref.read(inventoryAnalyticsRepositoryProvider).getDiscrepancyOverview(companyId),
    ]);

    return AnalyticsHubState(
      salesSummary: results[0] as SalesSummary,
      optimizationSummary: results[1] as OptimizationSummary,
      supplyChainSummary: results[2] as SupplyChainSummary,
      discrepancySummary: results[3] as DiscrepancySummary,
    );
  }
}
```

### 핵심 위젯: Analytics Card
```dart
// widgets/analytics/hub/analytics_card.dart

class AnalyticsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String status;        // 'good', 'warning', 'critical', 'insufficient'
  final String statusText;
  final String primaryMetric;
  final String? secondaryMetric;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(icon, size: 20, color: TossColors.gray600),
                SizedBox(width: 8),
                Text(title, style: TossTextStyles.body2Bold),
                Spacer(),
                _buildStatusBadge(),
              ],
            ),
            SizedBox(height: TossSpacing.md),

            // Status Text
            Text(statusText, style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            )),
            SizedBox(height: 4),

            // Primary Metric
            Text(primaryMetric, style: TossTextStyles.heading3),

            // Secondary Metric
            if (secondaryMetric != null) ...[
              SizedBox(height: 4),
              Text(secondaryMetric!, style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              )),
            ],

            Spacer(),

            // CTA
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('상세 보기', style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                )),
                Icon(Icons.chevron_right, size: 16, color: TossColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final (color, text) = switch (status) {
      'good' => (TossColors.success, '양호'),
      'warning' => (TossColors.warning, '주의'),
      'critical' => (TossColors.error, '긴급'),
      'insufficient' => (TossColors.gray400, '데이터 부족'),
      _ => (TossColors.gray400, '-'),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TossTextStyles.caption.copyWith(color: color)),
    );
  }
}
```

---

## 📱 Page 1: 수익률 분석 (Sales Analysis)

### 화면 레이아웃
```
┌─────────────────────────────────────────────────┐
│  [←] 수익률 분석                    [기간 선택] │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ 🎯 사업 상태: 양호 ✅                   │   │
│  │ 이번 달 vs 지난 달                      │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  ┌─────────┬─────────┬─────────┐               │
│  │  매출   │  마진   │ 판매량  │               │
│  │ 1.1B   │ 1.1B   │  34개   │               │
│  │ +45.8% │ +55.2% │ -71.9% │               │
│  └─────────┴─────────┴─────────┘               │
│                                                 │
│  ⚠️ 주의사항                                   │
│  • 판매량 감소 주의                            │
│                                                 │
│  ─────────────────────────────────────────     │
│                                                 │
│  💡 전략 분석 (BCG Matrix)                     │
│  ┌─────────────────────────────────────────┐   │
│  │    [Star]     [Cash Cow]                │   │
│  │    [Problem]  [Dog]                     │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  📊 카테고리별 상세                             │
│  • Bag: 85M원 (68%)            [상세 →]       │
│  • Belt: 42M원 (20%)           [상세 →]       │
│  • Shoes: 38M원 (12%)          [상세 →]       │
│                                                 │
└─────────────────────────────────────────────────┘
```

### RPC 호출 매핑
| 화면 요소 | RPC 함수 | 파라미터 |
|----------|----------|----------|
| 사업 상태 | `get_sales_dashboard` | company_id, store_id? |
| BCG Matrix | `get_bcg_matrix` | company_id, month?, store_id? |
| 카테고리 상세 | `get_category_detail` | company_id, category_id, month? |

---

## 📱 Page 2: 공급망 분석 (Supply Chain)

### 화면 레이아웃
```
┌─────────────────────────────────────────────────┐
│  [←] 공급망 분석                                │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ 🎯 공급망 상태: 정상 ✅                 │   │
│  │                                          │   │
│  │ 위험 제품 없음                          │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  ─────────────────────────────────────────     │
│                                                 │
│  🚨 문제 상품 (Error Integral 기준)            │
│                                                 │
│  데이터가 있을 경우:                            │
│  ┌─────────────────────────────────────────┐   │
│  │ 1. 샤넬 클래식 플랩  🔴 360 개·일       │   │
│  │    180일 × 평균 2개 지연                │   │
│  │                              [상세 →]   │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  데이터가 없을 경우:                            │
│  ┌─────────────────────────────────────────┐   │
│  │ ✅ 현재 위험 제품이 없습니다            │   │
│  │    공급망이 원활하게 운영되고 있습니다  │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  💡 Error Integral 이란?                       │
│  지연일수 × 부족수량 = 누적 영향도             │
│  값이 클수록 비즈니스 영향이 큽니다            │
│                                                 │
└─────────────────────────────────────────────────┘
```

### RPC 호출 매핑
| 화면 요소 | RPC 함수 | 파라미터 |
|----------|----------|----------|
| 공급망 상태 | `get_supply_chain_status` | company_id |

---

## 📱 Page 3: 재고 불일치 분석 (Discrepancy)

### 화면 레이아웃
```
┌─────────────────────────────────────────────────┐
│  [←] 재고 불일치 분석          [기간: 전체 ▼] │
├─────────────────────────────────────────────────┤
│                                                 │
│  ⚠️ 데이터 부족 시:                             │
│  ┌─────────────────────────────────────────┐   │
│  │        📊                               │   │
│  │    분석 불가                            │   │
│  │                                          │   │
│  │  현재: 1개 매장, 12건 이벤트            │   │
│  │  필요: 최소 3개 매장, 30건 이벤트       │   │
│  │                                          │   │
│  │  더 많은 데이터가 수집되면              │   │
│  │  통계 분석이 가능해집니다               │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  ─────── 데이터 충분 시 ───────               │
│                                                 │
│  💰 기간 누적 손익                              │
│  ┌─────────────────────────────────────────┐   │
│  │ 증가 (발견):      +45.2M원              │   │
│  │ 감소 (미발견):    -48.7M원              │   │
│  │ ════════════════════════════════════    │   │
│  │ 순 손익:          -3.5M원 (-7.2%)       │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  🏪 매장별 현황                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ 강남점    -8.2M원    🔴 통계적 이상    │   │
│  │ 홍대점    +1.5M원    🟢 정상 범위      │   │
│  │ 압구정    -0.3M원    🟢 정상 범위      │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
└─────────────────────────────────────────────────┘
```

### RPC 호출 매핑
| 화면 요소 | RPC 함수 | 파라미터 |
|----------|----------|----------|
| 전체 개요 | `get_discrepancy_overview` | company_id, period? |

---

## 📱 Page 4: 재고 최적화 (Inventory Optimization)

### 화면 레이아웃
```
┌─────────────────────────────────────────────────┐
│  [←] 재고 최적화               [필터: 긴급 ▼] │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ 🎯 재고 상태: 양호 ✅                   │   │
│  │ 종합 점수: 82/100                       │   │
│  │ ████████████████████████░░░░░           │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  ┌─────────┬─────────┬─────────┐               │
│  │ 품절률  │과잉재고 │ 회전율  │               │
│  │  2.78%  │   0%    │  5.59   │               │
│  │   ✅    │   ✅    │   ✅    │               │
│  └─────────┴─────────┴─────────┘               │
│                                                 │
│  ─────────────────────────────────────────     │
│                                                 │
│  🚨 주문 필요 (34개 제품)                      │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ 🔴 긴급  로에베 벨트                    │   │
│  │ 현재: -18개 → 필요: 30개                │   │
│  │ 주문량: 48개                            │   │
│  │ 일평균 1.2개 판매 | 버틸일: -18일       │   │
│  │                         [주문서 작성 →] │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ 🟡 주의  샤넬 클래식 플랩               │   │
│  │ 현재: 2개 → 필요: 15개                  │   │
│  │ 주문량: 13개                            │   │
│  │ 일평균 0.5개 판매 | 버틸일: 4일         │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  [전체 리스트 보기 →]                         │
│                                                 │
└─────────────────────────────────────────────────┘
```

### RPC 호출 매핑
| 화면 요소 | RPC 함수 | 파라미터 |
|----------|----------|----------|
| 대시보드 | `get_inventory_optimization_dashboard` | company_id |
| 주문 리스트 | `get_inventory_reorder_list` | company_id, priority?, limit? |

---

## 🎨 공통 위젯

### 1. Score Indicator (점수 게이지)
```dart
// widgets/analytics/common/score_indicator.dart

class ScoreIndicator extends StatelessWidget {
  final int score;
  final int maxScore;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final percentage = score / maxScore;
    final color = percentage >= 0.8
        ? TossColors.success
        : percentage >= 0.6
            ? TossColors.warning
            : TossColors.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage,
                strokeWidth: 6,
                backgroundColor: TossColors.gray100,
                valueColor: AlwaysStoppedAnimation(color),
              ),
              Text(
                '$score',
                style: TossTextStyles.heading2.copyWith(color: color),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          SizedBox(height: 8),
          Text(label!, style: TossTextStyles.caption),
        ],
      ],
    );
  }
}
```

### 2. Metric Card (지표 카드)
```dart
// widgets/analytics/common/metric_card.dart

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? change;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.md),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          )),
          SizedBox(height: 4),
          Text(value, style: TossTextStyles.heading3),
          if (change != null) ...[
            SizedBox(height: 4),
            Text(
              change!,
              style: TossTextStyles.caption.copyWith(
                color: isPositive ? TossColors.success : TossColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 3. Status Chip (상태 칩)
```dart
// widgets/analytics/common/status_chip.dart

class StatusChip extends StatelessWidget {
  final String status; // 'good', 'warning', 'critical', 'insufficient'
  final String? customText;

  @override
  Widget build(BuildContext context) {
    final (color, defaultText) = switch (status) {
      'good' => (TossColors.success, '양호'),
      'warning' => (TossColors.warning, '주의'),
      'critical' => (TossColors.error, '긴급'),
      'insufficient' => (TossColors.gray400, '데이터 부족'),
      _ => (TossColors.gray400, '-'),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        customText ?? defaultText,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

---

## 🔗 라우팅 설정

### go_router 설정 추가
```dart
// app/config/app_router.dart 에 추가

// 인벤토리 분석 라우트 (기존 inventory 하위에 추가)
GoRoute(
  path: '/inventory/analytics',
  name: 'inventoryAnalytics',
  builder: (context, state) => const AnalyticsHubPage(),
  routes: [
    GoRoute(
      path: 'sales',
      name: 'salesAnalysis',
      builder: (context, state) => const SalesAnalysisPage(),
    ),
    GoRoute(
      path: 'supply-chain',
      name: 'supplyChainAnalysis',
      builder: (context, state) => const SupplyChainPage(),
    ),
    GoRoute(
      path: 'discrepancy',
      name: 'discrepancyAnalysis',
      builder: (context, state) => const DiscrepancyAnalysisPage(),
    ),
    GoRoute(
      path: 'optimization',
      name: 'inventoryOptimization',
      builder: (context, state) => const InventoryOptimizationPage(),
    ),
  ],
),
```

---

## 📋 구현 체크리스트

### Phase 1: 기반 구조 (1일)
```
[ ] analytics 폴더 구조 생성
[ ] Entity 정의 (freezed)
    [ ] SalesSummary
    [ ] OptimizationSummary
    [ ] SupplyChainSummary
    [ ] DiscrepancySummary
    [ ] BcgCategory
    [ ] ReorderProduct
    [ ] StoreDiscrepancy
[ ] Model 정의 (json_serializable)
[ ] Repository 인터페이스 정의
[ ] Remote Datasource 구현 (RPC 호출)
[ ] Repository 구현체
[ ] DI Provider 설정
```

### Phase 2: 공통 컴포넌트 (1일)
```
[ ] ScoreIndicator
[ ] MetricCard
[ ] StatusChip
[ ] AnalyticsCard (Hub용)
[ ] TrendBadge
[ ] ProgressBar
```

### Phase 3: Hub 페이지 (1일)
```
[ ] AnalyticsHubPage
[ ] AnalyticsHubNotifier (Provider)
[ ] 4개 카드 레이아웃
[ ] 네비게이션 연결
[ ] 로딩/에러 상태
```

### Phase 4: 상세 페이지 (3일)
```
[ ] SalesAnalysisPage
    [ ] SalesSummaryCard
    [ ] MetricsRow (매출/마진/판매량)
    [ ] BcgMatrixSection
    [ ] CategoryList

[ ] SupplyChainPage
    [ ] SupplyChainStatusCard
    [ ] ProblemProductList
    [ ] EmptyState

[ ] DiscrepancyAnalysisPage
    [ ] InsufficientDataView
    [ ] DiscrepancySummaryCard
    [ ] StoreComparisonList

[ ] InventoryOptimizationPage
    [ ] OptimizationScoreCard
    [ ] MetricsRow (품절률/과잉/회전율)
    [ ] ReorderList (priority filter)
```

### Phase 5: 통합 & 테스트 (1일)
```
[ ] 라우팅 설정
[ ] 에러 핸들링
[ ] 로딩 상태
[ ] Empty 상태
[ ] Pull-to-refresh
```

---

## 📝 코드 생성 명령어

```bash
# freezed 모델 생성
dart run build_runner build --delete-conflicting-outputs

# 또는 watch 모드
dart run build_runner watch --delete-conflicting-outputs
```

---

## ⚠️ 주의사항

### 1. Toss Design System 준수
- 모든 색상: `TossColors` 사용
- 모든 간격: `TossSpacing` 사용
- 모든 텍스트: `TossTextStyles` 사용
- 기존 위젯: `TossCard`, `TossButton`, `TossAppBar`, `TossScaffold` 등 활용

### 2. 성능 최적화
- Hub 페이지: 4개 RPC **병렬 호출** (`Future.wait`)
- 상세 페이지: 해당 RPC만 호출
- 리스트: `ListView.builder` 사용
- `ref.watch` vs `ref.read` 적절히 사용

### 3. 에러 핸들링
- RPC 실패 시 `TossErrorView` + 재시도 버튼
- 데이터 부족 시 `InsufficientDataView` (친절한 안내)
- 빈 데이터 시 `TossEmptyView`

### 4. 모바일 대응
- Hub: 2×2 그리드 → 모바일에서 1열 스크롤
- 카드 높이: 고정 (일관된 레이아웃)
- 터치 영역: 최소 48×48

---

## ✅ 결론

### 구조
- **1개 Hub (Dashboard)** + **4개 상세 페이지** = **5개 페이지**
- 기존 `inventory_management` 폴더에 `analytics/` 서브폴더로 추가

### 2025 트렌드 적용
- ✅ Progressive Disclosure (Hub → Detail)
- ✅ Action-Oriented (상태 + 액션 제안)
- ✅ Low Cognitive Load (4개 카드 요약)
- ✅ Mobile-First (반응형 그리드)

### 예상 소요 시간
| Phase | 내용 | 기간 |
|-------|------|------|
| 1 | 기반 구조 | 1일 |
| 2 | 공통 컴포넌트 | 1일 |
| 3 | Hub 페이지 | 1일 |
| 4 | 상세 페이지 4개 | 3일 |
| 5 | 통합 & 테스트 | 1일 |
| **합계** | | **7일** |
