# Inventory Analysis - Final Folder Structure

> **Date**: 2026-01-09
> **Pages**: 4개 (Sales, Optimization, Supply Chain, Discrepancy)
> **Pattern**: 각 페이지별 data/domain/presentation 완전 분리

---

## 최종 폴더 구조

```
lib/features/inventory_analysis/
│
├── shared/                              # 공유 컴포넌트
│   ├── data/
│   │   └── datasources/
│   │       └── inventory_analytics_datasource.dart
│   ├── domain/
│   │   └── exceptions/
│   │       └── analytics_exceptions.dart
│   ├── presentation/
│   │   └── widgets/
│   │       ├── analytics_list_item.dart
│   │       ├── analytics_metric_tile.dart
│   │       ├── analytics_section_header.dart
│   │       ├── analytics_status_badge.dart
│   │       └── analytics_summary_card.dart
│   └── di/
│       └── shared_providers.dart
│
├── sales/                               # 1. Sales Analysis
│   ├── data/
│   │   └── models/
│   │       ├── sales_dashboard_model.dart
│   │       ├── bcg_matrix_model.dart
│   │       ├── category_detail_model.dart
│   │       └── sales_analytics_model.dart      # NEW (V2)
│   ├── domain/
│   │   └── entities/
│   │       ├── sales_dashboard.dart
│   │       ├── bcg_category.dart
│   │       ├── category_detail.dart
│   │       └── sales_analytics.dart            # NEW (V2)
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── sales_dashboard_page.dart
│   │   ├── providers/
│   │   │   ├── sales_dashboard_provider.dart
│   │   │   └── sales_analytics_v2_provider.dart  # NEW (V2)
│   │   └── widgets/
│   │       ├── bcg_matrix_chart.dart           # Extract from page
│   │       ├── monthly_comparison_card.dart    # Extract from page
│   │       ├── summary_hero_card.dart          # Extract from page
│   │       ├── time_range_selector.dart        # NEW (V2)
│   │       ├── summary_cards.dart              # NEW (V2)
│   │       ├── time_series_chart.dart          # NEW (V2)
│   │       ├── top_products_list.dart          # NEW (V2)
│   │       ├── drill_down_section.dart         # NEW (V2)
│   │       └── drill_down_breadcrumb.dart      # NEW (V2)
│   └── di/
│       └── sales_providers.dart
│
├── optimization/                        # 2. Inventory Optimization
│   ├── data/
│   │   └── models/
│   │       └── inventory_optimization_model.dart
│   ├── domain/
│   │   └── entities/
│   │       └── inventory_optimization.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── inventory_optimization_page.dart
│   │   ├── providers/
│   │   │   └── inventory_optimization_provider.dart
│   │   └── widgets/
│   │       └── ...
│   └── di/
│       └── optimization_providers.dart
│
├── supply_chain/                        # 3. Supply Chain
│   ├── data/
│   │   └── models/
│   │       └── supply_chain_model.dart
│   ├── domain/
│   │   └── entities/
│   │       └── supply_chain_status.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── supply_chain_page.dart
│   │   ├── providers/
│   │   │   └── supply_chain_provider.dart
│   │   └── widgets/
│   │       └── ...
│   └── di/
│       └── supply_chain_providers.dart
│
├── discrepancy/                         # 4. Discrepancy
│   ├── data/
│   │   └── models/
│   │       └── discrepancy_model.dart
│   ├── domain/
│   │   └── entities/
│   │       └── discrepancy_overview.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── discrepancy_page.dart
│   │   ├── providers/
│   │   │   └── discrepancy_provider.dart
│   │   └── widgets/
│   │       └── ...
│   └── di/
│       └── discrepancy_providers.dart
│
├── hub/                                 # Hub Page (메인 진입점)
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── inventory_analytics_hub_page.dart
│   │   └── providers/
│   │       └── analytics_hub_provider.dart
│   └── di/
│       └── hub_providers.dart
│
└── inventory_analysis.dart              # 배럴 파일
```

---

## 파일 이동 매핑

### From → To

| 현재 위치 | 새 위치 |
|----------|---------|
| `data/datasources/inventory_analytics_datasource.dart` | `shared/datasources/` |
| `domain/exceptions/analytics_exceptions.dart` | `shared/exceptions/` |
| `presentation/widgets/analytics_*.dart` (공통) | `shared/widgets/` |
| `data/models/sales_dashboard_model.dart` | `sales/data/models/` |
| `data/models/bcg_matrix_model.dart` | `sales/data/models/` |
| `data/models/category_detail_model.dart` | `sales/data/models/` |
| `domain/entities/sales_dashboard.dart` | `sales/domain/entities/` |
| `domain/entities/bcg_category.dart` | `sales/domain/entities/` |
| `domain/entities/category_detail.dart` | `sales/domain/entities/` |
| `presentation/pages/sales_dashboard_page.dart` | `sales/presentation/pages/` |
| `presentation/providers/sales_dashboard_provider.dart` | `sales/presentation/providers/` |
| `presentation/widgets/sales/*` | `sales/presentation/widgets/` |
| `data/models/inventory_optimization_model.dart` | `optimization/data/models/` |
| `domain/entities/inventory_optimization.dart` | `optimization/domain/entities/` |
| `presentation/pages/inventory_optimization_page.dart` | `optimization/presentation/pages/` |
| `presentation/providers/inventory_optimization_provider.dart` | `optimization/presentation/providers/` |
| `data/models/supply_chain_model.dart` | `supply_chain/data/models/` |
| `domain/entities/supply_chain_status.dart` | `supply_chain/domain/entities/` |
| `presentation/pages/supply_chain_page.dart` | `supply_chain/presentation/pages/` |
| `presentation/providers/supply_chain_provider.dart` | `supply_chain/presentation/providers/` |
| `data/models/discrepancy_model.dart` | `discrepancy/data/models/` |
| `domain/entities/discrepancy_overview.dart` | `discrepancy/domain/entities/` |
| `presentation/pages/discrepancy_page.dart` | `discrepancy/presentation/pages/` |
| `presentation/providers/discrepancy_provider.dart` | `discrepancy/presentation/providers/` |
| `presentation/pages/inventory_analytics_hub_page.dart` | `hub/presentation/pages/` |
| `presentation/providers/analytics_hub_provider.dart` | `hub/presentation/providers/` |

---

## 배럴 파일

```dart
// lib/features/inventory_analysis/inventory_analysis.dart

// Shared
export 'shared/datasources/inventory_analytics_datasource.dart';
export 'shared/exceptions/analytics_exceptions.dart';

// Sales
export 'sales/presentation/pages/sales_dashboard_page.dart';
export 'sales/domain/entities/sales_dashboard.dart';
export 'sales/domain/entities/sales_analytics.dart';

// Optimization
export 'optimization/presentation/pages/inventory_optimization_page.dart';

// Supply Chain
export 'supply_chain/presentation/pages/supply_chain_page.dart';

// Discrepancy
export 'discrepancy/presentation/pages/discrepancy_page.dart';

// Hub
export 'hub/presentation/pages/inventory_analytics_hub_page.dart';
```

---

## 작업 순서

### Step 1: 폴더 구조 생성
```bash
cd lib/features/inventory_analysis

# shared (공유 - data/domain/presentation 포함)
mkdir -p shared/data/datasources
mkdir -p shared/domain/exceptions
mkdir -p shared/presentation/widgets
mkdir -p shared/di

# sales (매출 분석 - data/domain/presentation 포함)
mkdir -p sales/data/models
mkdir -p sales/domain/entities
mkdir -p sales/presentation/pages
mkdir -p sales/presentation/providers
mkdir -p sales/presentation/widgets
mkdir -p sales/di

# optimization (재고 최적화 - data/domain/presentation 포함)
mkdir -p optimization/data/models
mkdir -p optimization/domain/entities
mkdir -p optimization/presentation/pages
mkdir -p optimization/presentation/providers
mkdir -p optimization/presentation/widgets
mkdir -p optimization/di

# supply_chain (공급망 - data/domain/presentation 포함)
mkdir -p supply_chain/data/models
mkdir -p supply_chain/domain/entities
mkdir -p supply_chain/presentation/pages
mkdir -p supply_chain/presentation/providers
mkdir -p supply_chain/presentation/widgets
mkdir -p supply_chain/di

# discrepancy (불일치 - data/domain/presentation 포함)
mkdir -p discrepancy/data/models
mkdir -p discrepancy/domain/entities
mkdir -p discrepancy/presentation/pages
mkdir -p discrepancy/presentation/providers
mkdir -p discrepancy/presentation/widgets
mkdir -p discrepancy/di

# hub (허브 페이지 - presentation만)
mkdir -p hub/presentation/pages
mkdir -p hub/presentation/providers
mkdir -p hub/di
```

### 각 페이지 폴더 구조 (동일 패턴)
```
[page_name]/
├── data/                    # 데이터 레이어
│   └── models/              # JSON 모델 (*.g.dart 생성됨)
├── domain/                  # 도메인 레이어
│   └── entities/            # 엔티티 (*.freezed.dart 생성됨)
├── presentation/            # 프레젠테이션 레이어
│   ├── pages/               # 페이지 위젯
│   ├── providers/           # Riverpod Provider, State
│   └── widgets/             # 재사용 위젯
└── di/                      # 의존성 주입
    └── *_providers.dart     # Provider 등록
```

### Step 2: Sales 먼저 이동 + V2 추가
1. 기존 sales 관련 파일 이동
2. V2 새 파일 생성
3. Import 경로 수정

### Step 3: 나머지 페이지 이동

### Step 4: 기존 폴더 정리

---

**Document Created**: 2026-01-09
