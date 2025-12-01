// Repository Providers: Inventory Management
// Presentation Layer providers for dependency injection
// Note: Moved from data/ to presentation/ for Clean Architecture compliance
// Presentation should not directly import data layer implementations

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/datasources/inventory_remote_datasource.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/repositories/inventory_repository.dart';

// ============================================================================
// Repository Providers (DI Configuration)
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
/// Note: Returns Domain interface type (InventoryRepository), not implementation
final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) {
    final dataSource = ref.watch(inventoryRemoteDataSourceProvider);
    return InventoryRepositoryImpl(dataSource);
  },
);
