/// Inventory Analysis Feature
///
/// This barrel file exports all public APIs for the inventory analysis feature.
/// Use this file to import inventory analysis components in other parts of the app.
///
/// 각 기능은 독립적인 Clean Architecture 구조를 가지며,
/// shared 폴더에는 공통 위젯만 남아있습니다.
library;

// ============================================================================
// Shared Components (Widgets Only)
// ============================================================================

// Presentation - Shared Widgets
export 'shared/presentation/widgets/analytics_widgets.dart';

// ============================================================================
// Sales Analysis
// ============================================================================

// Domain - Entities
export 'sales/domain/entities/bcg_category.dart';
export 'sales/domain/entities/category_detail.dart';
export 'sales/domain/entities/sales_analytics.dart';
export 'sales/domain/entities/sales_dashboard.dart';

// Domain - Repository Interface
export 'sales/domain/repositories/sales_repository.dart';

// Presentation - Pages
export 'sales/presentation/pages/sales_analytics_v2_page.dart';
export 'sales/presentation/pages/sales_dashboard_page.dart';

// Presentation - Providers (@riverpod 2025)
export 'sales/presentation/providers/sales_analytics_v2_notifier.dart';
export 'sales/presentation/providers/sales_dashboard_notifier.dart';
export 'sales/presentation/providers/sales_di_provider.dart';
export 'sales/presentation/providers/states/sales_analytics_state.dart';

// Presentation - Widgets
export 'sales/presentation/widgets/drill_down_breadcrumb.dart';
export 'sales/presentation/widgets/drill_down_section.dart';
export 'sales/presentation/widgets/summary_cards.dart';
export 'sales/presentation/widgets/time_range_selector.dart';
export 'sales/presentation/widgets/time_series_chart.dart';
export 'sales/presentation/widgets/top_products_list.dart';

// ============================================================================
// Inventory Optimization
// ============================================================================

// Domain - Entities
export 'optimization/domain/entities/inventory_optimization.dart';

// Domain - Repository Interface
export 'optimization/domain/repositories/optimization_repository.dart';

// DI - Providers (hide supabaseClientProvider to avoid conflicts)
export 'optimization/di/optimization_providers.dart'
    hide supabaseClientProvider;

// Presentation - Pages
export 'optimization/presentation/pages/inventory_optimization_page.dart';

// Presentation - Providers
export 'optimization/presentation/providers/inventory_optimization_provider.dart';

// ============================================================================
// Supply Chain
// ============================================================================

// Domain - Entities
export 'supply_chain/domain/entities/supply_chain_status.dart';

// Domain - Repository Interface
export 'supply_chain/domain/repositories/supply_chain_repository.dart';

// DI - Providers (hide supabaseClientProvider to avoid conflicts)
export 'supply_chain/di/supply_chain_providers.dart'
    hide supabaseClientProvider;

// Presentation - Pages
export 'supply_chain/presentation/pages/supply_chain_page.dart';

// Presentation - Providers
export 'supply_chain/presentation/providers/supply_chain_provider.dart';

// ============================================================================
// Discrepancy
// ============================================================================

// Domain - Entities
export 'discrepancy/domain/entities/discrepancy_overview.dart';

// Domain - Repository Interface
export 'discrepancy/domain/repositories/discrepancy_repository.dart';

// DI - Providers (hide supabaseClientProvider to avoid conflicts)
export 'discrepancy/di/discrepancy_providers.dart'
    hide supabaseClientProvider;

// Presentation - Pages
export 'discrepancy/presentation/pages/discrepancy_page.dart';

// Presentation - Providers
export 'discrepancy/presentation/providers/discrepancy_provider.dart';

// ============================================================================
// Hub (Main Entry Point)
// ============================================================================

// Domain - Entities
export 'hub/domain/entities/analytics_hub.dart';

// Domain - Repository Interface
export 'hub/domain/repositories/hub_repository.dart';

// DI - Providers
export 'hub/di/hub_providers.dart';

// Presentation - Pages
export 'hub/presentation/pages/inventory_analytics_hub_page.dart';

// Presentation - Providers
export 'hub/presentation/providers/analytics_hub_provider.dart';
export 'hub/presentation/providers/analytics_hub_state.dart';
