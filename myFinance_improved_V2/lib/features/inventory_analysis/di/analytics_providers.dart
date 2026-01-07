// Dependency Injection: Inventory Analytics
// Centralized DI configuration for inventory analytics feature
// This file is the ONLY place where Data layer implementations are imported
// All other layers reference Domain interfaces only

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/supabase_service.dart';

// Data layer imports (ONLY allowed in DI configuration)
import '../data/datasources/inventory_analytics_datasource.dart';
import '../data/repositories/inventory_analytics_repository_impl.dart';

// Domain layer imports (interfaces)
import '../domain/repositories/inventory_analytics_repository.dart';

// ============================================================================
// Inventory Analytics Feature DI Providers
// ============================================================================

/// Analytics Remote DataSource Provider
/// Creates the remote data source with Supabase client
final inventoryAnalyticsDatasourceProvider = Provider<InventoryAnalyticsDatasource>(
  (ref) {
    final supabaseService = ref.watch(supabaseServiceProvider);
    return InventoryAnalyticsDatasource(supabaseService.client);
  },
);

/// Analytics Repository Provider
/// Provides the inventory analytics repository implementation
/// Returns: Domain interface type (InventoryAnalyticsRepository), NOT implementation
/// This ensures Presentation layer only depends on Domain abstractions
final inventoryAnalyticsRepositoryProvider = Provider<InventoryAnalyticsRepository>(
  (ref) {
    final dataSource = ref.watch(inventoryAnalyticsDatasourceProvider);
    return InventoryAnalyticsRepositoryImpl(dataSource);
  },
);
