# Inventory Analysis - Folder Restructure Proposal

> **Date**: 2026-01-09
> **Status**: Proposal

---

## 1. Current Structure (Before)

```
lib/features/inventory_analysis/
├── data/
│   ├── datasources/
│   │   └── inventory_analytics_datasource.dart    # 모든 RPC 호출
│   ├── models/
│   │   ├── analytics_models.dart                  # 배럴 파일
│   │   ├── bcg_matrix_model.dart
│   │   ├── category_detail_model.dart
│   │   ├── discrepancy_model.dart
│   │   ├── inventory_optimization_model.dart
│   │   ├── sales_dashboard_model.dart
│   │   └── supply_chain_model.dart
│   └── repositories/
│       └── inventory_analytics_repository_impl.dart
├── di/
│   └── analytics_providers.dart
├── domain/
│   ├── entities/
│   │   ├── analytics_entities.dart                # 배럴 파일
│   │   ├── analytics_hub.dart
│   │   ├── bcg_category.dart
│   │   ├── category_detail.dart
│   │   ├── discrepancy_overview.dart
│   │   ├── inventory_optimization.dart
│   │   ├── sales_dashboard.dart
│   │   └── supply_chain_status.dart
│   ├── exceptions/
│   │   └── analytics_exceptions.dart
│   └── repositories/
│       └── inventory_analytics_repository.dart
└── presentation/
    ├── pages/
    │   ├── analytics_pages.dart                   # 배럴 파일
    │   ├── discrepancy_page.dart
    │   ├── inventory_analytics_hub_page.dart
    │   ├── inventory_optimization_page.dart
    │   ├── sales_dashboard_page.dart              # 1000+ lines
    │   └── supply_chain_page.dart
    ├── providers/
    │   ├── analytics_hub_provider.dart
    │   ├── analytics_hub_state.dart
    │   ├── analytics_providers.dart
    │   ├── discrepancy_provider.dart
    │   ├── inventory_optimization_provider.dart
    │   ├── sales_dashboard_provider.dart
    │   └── supply_chain_provider.dart
    └── widgets/
        ├── common/
        ├── discrepancy/
        ├── hub/
        ├── optimization/
        ├── sales/
        └── supply_chain/
```

### 문제점
1. `sales_dashboard_page.dart`가 1000줄 이상으로 너무 큼
2. 기능별로 분리되어 있지 않아 유지보수 어려움
3. 새로운 기능 추가 시 어디에 넣어야 할지 불명확
4. widgets는 페이지별로 분리되어 있지만 다른 레이어는 아님

---

## 2. Proposed Structure (After)

**원칙**: 각 분석 페이지를 독립적인 feature 모듈처럼 구성

```
lib/features/inventory_analysis/
├── shared/                                        # 공유 컴포넌트
│   ├── data/
│   │   ├── datasources/
│   │   │   └── inventory_analytics_datasource.dart
│   │   └── models/
│   │       └── analytics_models.dart              # 배럴 파일
│   ├── domain/
│   │   ├── entities/
│   │   │   └── analytics_entities.dart            # 배럴 파일
│   │   ├── exceptions/
│   │   │   └── analytics_exceptions.dart
│   │   └── repositories/
│   │       └── inventory_analytics_repository.dart
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
├── hub/                                           # Analytics Hub 페이지
│   ├── data/
│   │   └── models/
│   │       └── hub_model.dart
│   ├── domain/
│   │   └── entities/
│   │       └── analytics_hub.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── inventory_analytics_hub_page.dart
│   │   ├── providers/
│   │   │   ├── analytics_hub_provider.dart
│   │   │   └── analytics_hub_state.dart
│   │   └── widgets/
│   │       └── hub_card.dart
│   └── di/
│       └── hub_providers.dart
│
├── sales_dashboard/                               # Sales Dashboard 페이지
│   ├── data/
│   │   └── models/
│   │       ├── sales_dashboard_model.dart
│   │       ├── bcg_matrix_model.dart
│   │       ├── category_detail_model.dart
│   │       └── sales_analytics_model.dart         # NEW
│   ├── domain/
│   │   └── entities/
│   │       ├── sales_dashboard.dart
│   │       ├── bcg_category.dart
│   │       ├── category_detail.dart
│   │       └── sales_analytics.dart               # NEW
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── sales_dashboard_page.dart
│   │   ├── providers/
│   │   │   ├── sales_dashboard_provider.dart
│   │   │   └── sales_analytics_v2_provider.dart   # NEW
│   │   └── widgets/
│   │       ├── bcg_matrix_chart.dart              # 분리
│   │       ├── monthly_comparison_card.dart       # 분리
│   │       ├── summary_hero_card.dart             # 분리
│   │       ├── time_range_selector.dart           # NEW
│   │       ├── summary_cards.dart                 # NEW
│   │       ├── time_series_chart.dart             # NEW
│   │       ├── top_products_list.dart             # NEW
│   │       ├── drill_down_section.dart            # NEW
│   │       └── drill_down_breadcrumb.dart         # NEW
│   └── di/
│       └── sales_dashboard_providers.dart
│
├── supply_chain/                                  # Supply Chain 페이지
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
├── discrepancy/                                   # Discrepancy 페이지
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
├── optimization/                                  # Inventory Optimization 페이지
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
└── inventory_analysis.dart                        # 메인 배럴 파일
```

---

## 3. Key Changes

### 3.1 sales_dashboard_page.dart 분리

현재 1000줄 이상의 파일을 다음과 같이 분리:

| 현재 메서드 | 분리될 파일 |
|------------|-------------|
| `_buildHeroCard()` | `widgets/summary_hero_card.dart` |
| `_buildMonthlyComparison()` | `widgets/monthly_comparison_card.dart` |
| `_buildBcgChartWithQuadrants()` | `widgets/bcg_matrix_chart.dart` |
| `_buildLegendChip()` | `widgets/bcg_matrix_chart.dart` |
| `_QuadrantBackgroundPainter` | `widgets/bcg_matrix_chart.dart` |

**New widgets for V2:**
- `widgets/time_range_selector.dart`
- `widgets/summary_cards.dart`
- `widgets/time_series_chart.dart`
- `widgets/top_products_list.dart`
- `widgets/drill_down_section.dart`
- `widgets/drill_down_breadcrumb.dart`

### 3.2 Datasource 유지

`shared/data/datasources/inventory_analytics_datasource.dart`
- 모든 RPC 호출을 담당하는 단일 파일 유지
- 각 페이지 모듈에서 import하여 사용

### 3.3 배럴 파일 업데이트

```dart
// lib/features/inventory_analysis/inventory_analysis.dart

// Shared
export 'shared/data/models/analytics_models.dart';
export 'shared/domain/entities/analytics_entities.dart';
export 'shared/domain/exceptions/analytics_exceptions.dart';
export 'shared/presentation/widgets/analytics_widgets.dart';

// Hub
export 'hub/presentation/pages/inventory_analytics_hub_page.dart';

// Sales Dashboard
export 'sales_dashboard/presentation/pages/sales_dashboard_page.dart';

// Supply Chain
export 'supply_chain/presentation/pages/supply_chain_page.dart';

// Discrepancy
export 'discrepancy/presentation/pages/discrepancy_page.dart';

// Optimization
export 'optimization/presentation/pages/inventory_optimization_page.dart';
```

---

## 4. Migration Steps

### Phase 1: 폴더 구조 생성 (먼저 새 폴더만 생성)

```bash
# 새 폴더 구조 생성
mkdir -p lib/features/inventory_analysis/shared/{data/{datasources,models},domain/{entities,exceptions,repositories},presentation/widgets,di}
mkdir -p lib/features/inventory_analysis/hub/{data/models,domain/entities,presentation/{pages,providers,widgets},di}
mkdir -p lib/features/inventory_analysis/sales_dashboard/{data/models,domain/entities,presentation/{pages,providers,widgets},di}
mkdir -p lib/features/inventory_analysis/supply_chain/{data/models,domain/entities,presentation/{pages,providers,widgets},di}
mkdir -p lib/features/inventory_analysis/discrepancy/{data/models,domain/entities,presentation/{pages,providers,widgets},di}
mkdir -p lib/features/inventory_analysis/optimization/{data/models,domain/entities,presentation/{pages,providers,widgets},di}
```

### Phase 2: 파일 이동 (점진적으로)

1. **shared/** 먼저 이동
   - datasources, exceptions, 공통 widgets

2. **sales_dashboard/** 이동
   - 가장 복잡한 페이지
   - 새 V2 파일들 추가

3. **나머지 페이지** 이동
   - supply_chain, discrepancy, optimization, hub

### Phase 3: Import 경로 업데이트

- 모든 import 경로를 새 구조에 맞게 업데이트
- 배럴 파일을 통한 import 사용 권장

### Phase 4: 기존 폴더 정리

- 빈 폴더 삭제
- 사용하지 않는 파일 삭제

---

## 5. 장점

1. **명확한 모듈 경계**: 각 페이지가 독립적인 모듈로 관리됨
2. **코드 탐색 용이**: 관련 파일이 한 폴더에 모여있음
3. **병렬 개발 가능**: 팀원들이 서로 다른 페이지를 독립적으로 개발 가능
4. **테스트 용이**: 페이지별로 테스트 작성 가능
5. **재사용성**: shared 폴더의 공통 컴포넌트 재사용
6. **확장성**: 새 페이지 추가 시 새 폴더만 추가

---

## 6. 결정 필요 사항

1. **지금 바로 리팩토링할지?** vs **V2 기능 먼저 추가 후 리팩토링?**
   - 추천: V2 기능을 새 구조로 바로 추가

2. **기존 코드 마이그레이션 범위?**
   - 옵션 A: 전체 마이그레이션 (권장)
   - 옵션 B: sales_dashboard만 먼저 마이그레이션

3. **sales_dashboard_page.dart 분리 수준?**
   - 옵션 A: 위젯만 분리 (권장)
   - 옵션 B: 페이지도 여러 파일로 분리

---

**Document Created**: 2026-01-09
