/// Repository Providers for employee_setting module
///
/// Following project majority pattern: data/repositories/repository_providers.dart
/// (Used by: homepage, cash_location, transaction_history, journal_input, inventory_management)
///
/// Purpose: Provides dependency injection for repositories
/// - Centralizes Data layer dependencies
/// - Presentation layer imports this file
/// - Maintains Clean Architecture by hiding implementation details
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/employee_repository.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/employee_remote_datasource.dart';
import '../datasources/role_remote_datasource.dart';
import 'employee_repository_impl.dart';
import 'role_repository_impl.dart';

// ============================================================================
// Internal Providers (Private - used only within this file)
// ============================================================================

/// Supabase client provider (Internal)
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Employee remote data source provider (Internal)
final _employeeRemoteDataSourceProvider = Provider<EmployeeRemoteDataSource>((ref) {
  final supabase = ref.read(_supabaseClientProvider);
  return EmployeeRemoteDataSource(supabase);
});

/// Role remote data source provider (Internal)
final _roleRemoteDataSourceProvider = Provider<RoleRemoteDataSource>((ref) {
  final supabase = ref.read(_supabaseClientProvider);
  return RoleRemoteDataSource(supabase);
});

// ============================================================================
// Public Repository Providers (Exposed to Presentation layer)
// ============================================================================

/// Employee repository provider
///
/// Provides EmployeeRepositoryImpl implementation.
/// Presentation layer should use this provider.
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final dataSource = ref.read(_employeeRemoteDataSourceProvider);
  return EmployeeRepositoryImpl(dataSource);
});

/// Role repository provider
///
/// Provides RoleRepositoryImpl implementation.
/// Presentation layer should use this provider.
final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  final dataSource = ref.read(_roleRemoteDataSourceProvider);
  return RoleRepositoryImpl(dataSource);
});
