import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data Layer - DataSources
import '../data/datasources/supabase_auth_datasource.dart';
import '../data/datasources/supabase_company_datasource.dart';
import '../data/datasources/supabase_store_datasource.dart';
import '../data/datasources/supabase_user_datasource.dart';
// Data Layer - Repositories
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/company_repository_impl.dart';
import '../data/repositories/store_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
// Domain Layer
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/company_repository.dart';
import '../domain/repositories/store_repository.dart';
import '../domain/repositories/user_repository.dart';

/// DI Layer - Dependency Injection
///
/// This file wires up all dependencies for the auth feature.
/// Following Clean Architecture, DI layer sits between data and presentation.
///
/// Architecture:
/// - Domain: Interfaces only
/// - Data: Implementations
/// - DI: Dependency wiring (THIS FILE)
/// - Presentation: UI and state (imports from DI, never from data)

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// DataSource Providers
// ============================================================================

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthDataSource(client);
});

final userDataSourceProvider = Provider<UserDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseUserDataSource(client);
});

final companyDataSourceProvider = Provider<CompanyDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseCompanyDataSource(client);
});

final storeDataSourceProvider = Provider<StoreDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseStoreDataSource(client);
});

// ============================================================================
// Repository Providers
// ============================================================================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return UserRepositoryImpl(dataSource);
});

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final dataSource = ref.watch(companyDataSourceProvider);
  return CompanyRepositoryImpl(dataSource);
});

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final dataSource = ref.watch(storeDataSourceProvider);
  return StoreRepositoryImpl(dataSource);
});
