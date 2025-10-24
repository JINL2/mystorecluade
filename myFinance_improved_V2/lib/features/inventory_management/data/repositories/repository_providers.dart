// Repository Providers: Inventory Management
// Data Layer providers for dependency injection

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_datasource.dart';
import 'inventory_repository_impl.dart';

// ============================================================================
// Data Layer Providers
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
final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) {
    final dataSource = ref.watch(inventoryRemoteDataSourceProvider);
    return InventoryRepositoryImpl(dataSource);
  },
);
