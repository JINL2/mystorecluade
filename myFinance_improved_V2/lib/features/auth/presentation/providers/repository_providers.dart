import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Domain Layer
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/repositories/store_repository.dart';
import '../../domain/repositories/user_repository.dart';

// Data Layer - DataSources
import '../../data/datasources/supabase_auth_datasource.dart';
import '../../data/datasources/supabase_user_datasource.dart';
import '../../data/datasources/supabase_company_datasource.dart';
import '../../data/datasources/supabase_store_datasource.dart';

// Data Layer - Repositories
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/company_repository_impl.dart';
import '../../data/repositories/store_repository_impl.dart';

/// Repository Providers
///
/// Infrastructure layer that wires up dependencies.
/// This file belongs in infrastructure because it:
/// - Imports concrete implementations from data layer
/// - Creates instances with Supabase dependencies
/// - Provides dependency injection configuration
///
/// Clean Architecture layers:
/// - Domain: Interfaces (repositories, entities, use cases)
/// - Data: Implementations (datasources, repository impls)
/// - Infrastructure: Dependency wiring (THIS FILE)
/// - Presentation: UI and state management

/// Supabase Client Provider
///
/// Provides the singleton Supabase client instance.
/// This is the foundation for all repository implementations.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// DataSource Providers
// ============================================================================

/// Auth DataSource Provider
///
/// 🚚 Delivery driver - Direct communication with Supabase Auth API
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthDataSource(client);
});

/// User DataSource Provider
///
/// 🚚 Delivery driver - Direct communication with Supabase Database
final userDataSourceProvider = Provider<UserDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseUserDataSource(client);
});

/// Company DataSource Provider
///
/// 🚚 Delivery driver - Direct communication with Supabase
final companyDataSourceProvider = Provider<CompanyDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseCompanyDataSource(client);
});

/// Store DataSource Provider
///
/// 🚚 Delivery driver - Direct communication with Supabase
final storeDataSourceProvider = Provider<StoreDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseStoreDataSource(client);
});

// ============================================================================
// Repository Providers
// ============================================================================

/// Auth Repository Provider
///
/// 📜 Contract implementer - Implements Domain Repository Interface
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

/// User Repository Provider
///
/// 📜 Contract implementer - Implements Domain Repository Interface
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return UserRepositoryImpl(dataSource);
});

/// Company Repository Provider
///
/// 📜 Contract implementer - Implements Domain Repository Interface
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final dataSource = ref.watch(companyDataSourceProvider);
  return CompanyRepositoryImpl(dataSource);
});

/// Store Repository Provider
///
/// 📜 Contract implementer - Implements Domain Repository Interface
final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final dataSource = ref.watch(storeDataSourceProvider);
  return StoreRepositoryImpl(dataSource);
});
