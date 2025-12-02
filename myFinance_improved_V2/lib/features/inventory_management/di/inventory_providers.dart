// Dependency Injection: Inventory Management
// Centralized DI configuration for inventory feature
// This file is the ONLY place where Data layer implementations are imported
// All other layers reference Domain interfaces only

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/supabase_service.dart';

// Data layer imports (ONLY allowed in DI configuration)
import '../data/datasources/inventory_remote_datasource.dart';
import '../data/repositories/inventory_repository_impl.dart';

// Domain layer imports (interfaces)
import '../domain/repositories/inventory_repository.dart';

// ============================================================================
// Inventory Feature DI Providers
// ============================================================================

/// Remote DataSource Provider
/// Creates the remote data source with Supabase client
final inventoryRemoteDataSourceProvider = Provider<InventoryRemoteDataSource>(
  (ref) {
    final supabaseService = ref.watch(supabaseServiceProvider);
    return InventoryRemoteDataSource(supabaseService.client);
  },
);

/// Repository Provider
/// Provides the inventory repository implementation
/// Returns: Domain interface type (InventoryRepository), NOT implementation
/// This ensures Presentation layer only depends on Domain abstractions
final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) {
    final dataSource = ref.watch(inventoryRemoteDataSourceProvider);
    return InventoryRepositoryImpl(dataSource);
  },
);
