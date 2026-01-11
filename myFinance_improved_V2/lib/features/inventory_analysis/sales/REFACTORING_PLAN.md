# Sales Analytics UI/UX Refactoring Plan

## 현재 상태 분석 (2025.01.11)

### 현재 페이지 구조
```
SalesAnalyticsV2Page (단일 긴 스크롤 페이지)
├── Store Selector (드롭다운)
├── TimeRangeSelector (칩)
├── SummaryCards (3개 KPI)
├── TimeSeriesChart (Metric 토글 + Category 필터 내장)
├── BcgMatrixChart (Revenue/Qty, Mean/Median 토글 내장)
├── TopProductsList (Expand/Collapse)
└── DrillDownSection (Expand/Collapse + 드릴다운 네비게이션)
```

### 핵심 문제점

| 문제 | 심각도 | 설명 |
|------|--------|------|
| 정보 과부하 | HIGH | 한 페이지에 7개 섹션, 긴 스크롤 |
| Expand 안티패턴 | CRITICAL | 100개 데이터 한번에 렌더링 → 성능 저하 |
| Metric 토글 위치 | MEDIUM | TimeSeriesChart 내부에만 있음 → 글로벌 필터여야 함 |
| API 비효율 | MEDIUM | Metric 변경 시 6개 API 재호출 (불필요) |

---

## Phase 1: 글로벌 필터 통합 (우선순위 HIGH)

### 목표
Store, TimeRange, Metric 3가지 필터를 상단에 통합하여 모든 위젯에 일관되게 적용

### 변경 사항

#### 1.1 페이지 상단 필터 바 통합
```
┌─────────────────────────────────────────────────┐
│  Store: [All Stores ▼]                          │
│  ┌─────────────────────────────────────────┐    │
│  │ [7D] [30D] [90D] [1Y] [Custom]          │    │ ← TimeRange
│  └─────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────┐    │
│  │ [Revenue] [Margin] [Quantity]           │    │ ← Metric (NEW)
│  └─────────────────────────────────────────┘    │
└─────────────────────────────────────────────────┘
```

#### 1.2 파일 변경 목록

| 파일 | 변경 내용 |
|------|----------|
| `sales_analytics_v2_page.dart` | Metric 토글을 상단으로 이동 |
| `time_series_chart.dart` | 내부 Metric 토글 제거, props로 받기 |
| `summary_cards.dart` | 선택된 Metric 강조 표시 |
| `top_products_list.dart` | 선택된 Metric 기준 정렬 |
| `drill_down_section.dart` | 선택된 Metric 기준 표시 |
| `sales_analytics_v2_notifier.dart` | setMetric() API 재호출 제거 |

#### 1.3 Metric 변경 최적화
```dart
// Before (비효율)
void setMetric(Metric metric, {...}) {
  state = state.copyWith(selectedMetric: metric);
  loadData(...);  // 6개 API 재호출
}

// After (최적화)
void setMetric(Metric metric) {
  state = state.copyWith(selectedMetric: metric);
  // API 재호출 없음 - 기존 데이터로 UI만 재렌더링
}
```

---

## Phase 2: Top Products 페이지 분리 (우선순위 HIGH)

### 목표
Expand/Collapse 안티패턴 제거, 별도 상세 페이지로 분리

### 변경 사항

#### 2.1 새 파일 생성
```
sales/presentation/pages/
├── sales_analytics_v2_page.dart (기존)
├── top_products_page.dart (NEW) ← 전체 목록 페이지
└── ...
```

#### 2.2 Hub에서 미리보기
```dart
// 기존: Expand 버튼
TopProductsList(
  products: products,
  initialShowCount: 5,
  // Expand 클릭 → 100개 렌더링 (문제)
)

// 변경: 전체보기 버튼
TopProductsPreview(
  products: products.take(3).toList(),  // Top 3만
  onViewAll: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => TopProductsPage(...)),
  ),
)
```

#### 2.3 상세 페이지 구조
```dart
// top_products_page.dart
class TopProductsPage extends ConsumerWidget {
  @override
  Widget build(context, ref) {
    return Scaffold(
      appBar: TossAppBar(title: 'Top Products'),
      body: Column(
        children: [
          // 검색 + 필터
          SearchBar(...),
          FilterChips(metric: selectedMetric),
          // 가상 스크롤 리스트
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) => ProductListTile(products[i]),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Phase 3: Category Analysis (DrillDown) 페이지 분리 (우선순위 HIGH)

### 목표
드릴다운 기능을 별도 페이지로 분리, 성능 최적화

### 변경 사항

#### 3.1 새 파일 생성
```
sales/presentation/pages/
├── category_analysis_page.dart (NEW) ← 드릴다운 전용 페이지
└── ...
```

#### 3.2 Hub에서 미리보기
```dart
// 기존: Expand 버튼 + 드릴다운 내장
DrillDownSection(
  items: items,
  initialShowCount: 5,
  onItemTap: drillDown,
  // 문제: 한 카드에 너무 많은 기능
)

// 변경: 미리보기 + 페이지 이동
CategoryPreview(
  items: items.take(3).toList(),  // Top 3만
  onViewAll: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CategoryAnalysisPage(...)),
  ),
)
```

#### 3.3 상세 페이지 구조
```dart
// category_analysis_page.dart
class CategoryAnalysisPage extends ConsumerStatefulWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: TossAppBar(
        title: 'Category Analysis',
        // 브레드크럼을 앱바 아래에 표시
      ),
      body: Column(
        children: [
          // 브레드크럼 네비게이션
          DrillDownBreadcrumb(...),
          // 검색
          SearchBar(...),
          // 가상 스크롤 리스트
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => CategoryListTile(
                item: items[i],
                onTap: () => drillDown(items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Phase 4: BCG Matrix 개선 (우선순위 MEDIUM)

### 목표
100+ 카테고리 성능 최적화, 상세 보기 기능 추가

### 변경 사항

#### 4.1 카테고리 제한
```dart
// 현재: 모든 카테고리 렌더링
final spots = chartData.spotData.map(...).toList();

// 변경: 상위 50개만 표시
final displaySpots = chartData.spotData
    .sorted((a, b) => b.revenue.compareTo(a.revenue))
    .take(50)
    .toList();

// + "더 많은 카테고리 보기" 버튼
```

#### 4.2 사분면별 상세 보기
```dart
// BCG Legend 클릭 시 해당 사분면 카테고리 목록 표시
BcgLegend(
  onQuadrantTap: (quadrant) => showModalBottomSheet(
    context: context,
    builder: (_) => QuadrantDetailSheet(
      quadrant: quadrant,
      categories: categoriesInQuadrant,
    ),
  ),
)
```

---

## Phase 5: 위젯 성능 최적화 (우선순위 MEDIUM)

### 5.1 const 생성자 추가
```dart
// Before
TossLoadingView()

// After
const TossLoadingView()
```

### 5.2 불필요한 리빌드 방지
```dart
// Consumer 위젯을 더 작은 단위로 분리
// 예: Metric 변경 시 SummaryCards만 리빌드
```

### 5.3 이미지/아이콘 캐싱
```dart
// 반복되는 아이콘을 const로 추출
static const _trendUpIcon = Icon(Icons.trending_up, ...);
```

---

## 최종 페이지 구조

```
📁 sales/presentation/pages/
├── sales_analytics_hub_page.dart      ← 메인 허브 (요약만)
│   ├── GlobalFilterBar (Store + TimeRange + Metric)
│   ├── SummaryCards
│   ├── TrendChartCard (전체 차트, 카테고리 필터 유지)
│   ├── BcgMatrixCard (토글 유지)
│   ├── TopProductsPreview (Top 3 + 전체보기)
│   └── CategoryPreview (Top 3 + 전체보기)
│
├── top_products_page.dart             ← 제품 전체 목록
│   ├── SearchBar + FilterChips
│   └── ListView.builder (가상 스크롤)
│
├── category_analysis_page.dart        ← 카테고리 드릴다운
│   ├── Breadcrumb
│   ├── SearchBar
│   └── ListView.builder (가상 스크롤)
│
└── (기존 sales_dashboard_page.dart 유지)
```

---

## 구현 순서

| 순서 | Phase | 예상 작업 | 파일 수 |
|------|-------|----------|--------|
| 1 | Phase 1 | 글로벌 Metric 토글 | 6개 수정 |
| 2 | Phase 2 | TopProducts 페이지 분리 | 2개 생성, 2개 수정 |
| 3 | Phase 3 | CategoryAnalysis 페이지 분리 | 2개 생성, 2개 수정 |
| 4 | Phase 4 | BCG Matrix 최적화 | 3개 수정 |
| 5 | Phase 5 | 성능 최적화 | 다수 수정 |

---

## 참고: 현재 파일 구조

```
📁 sales/
├── 📁 data/
│   ├── datasources/sales_datasource.dart
│   ├── models/
│   └── repositories/sales_repository_impl.dart
├── 📁 domain/
│   ├── entities/
│   │   ├── bcg_category.dart
│   │   ├── category_detail.dart
│   │   ├── sales_analytics.dart
│   │   └── sales_dashboard.dart
│   └── repositories/sales_repository.dart
└── 📁 presentation/
    ├── 📁 pages/
    │   ├── sales_analytics_v2_page.dart (357 lines)
    │   └── sales_dashboard_page.dart (150 lines)
    ├── 📁 providers/
    │   ├── sales_analytics_v2_notifier.dart (393 lines)
    │   ├── sales_dashboard_notifier.dart (116 lines)
    │   ├── sales_di_provider.dart
    │   └── states/sales_analytics_state.dart (66 lines)
    └── 📁 widgets/
        ├── bcg_matrix_chart.dart (158 lines)
        ├── bcg_matrix/ (여러 파일)
        ├── drill_down_breadcrumb.dart
        ├── drill_down_section.dart (360 lines)
        ├── summary_cards.dart (178 lines)
        ├── time_range_selector.dart (78 lines)
        ├── time_series_chart.dart (462 lines)
        └── top_products_list.dart (282 lines)
```

---

## 작성일: 2025.01.11
## 작성자: Claude Code (30년차 Flutter Architect)
