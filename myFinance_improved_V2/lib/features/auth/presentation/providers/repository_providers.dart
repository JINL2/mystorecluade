import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Domain Layer
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/repositories/store_repository.dart';
import '../../domain/repositories/user_repository.dart';

// Data Layer - DataSources (NEW Clean Architecture!)
import '../../data/datasources/supabase_auth_datasource.dart';
import '../../data/datasources/supabase_user_datasource.dart';
import '../../data/datasources/supabase_company_datasource.dart';
import '../../data/datasources/supabase_store_datasource.dart';

// Data Layer - Repositories (NEW Clean Architecture!)
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/company_repository_impl.dart';
import '../../data/repositories/store_repository_impl.dart';

/// Supabase Client Provider
///
/// Provides the singleton Supabase client instance.
/// This is the foundation for all repository implementations.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// DataSource Providers (NEW Clean Architecture!)
// ============================================================================

/// Auth DataSource Provider
///
/// 🚚 배달 기사 - Supabase Auth API와 직접 통신
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthDataSource(client);
});

/// User DataSource Provider
///
/// 🚚 배달 기사 - Supabase Database와 직접 통신 (users, user_companies, user_stores)
final userDataSourceProvider = Provider<UserDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseUserDataSource(client);
});

/// Company DataSource Provider
///
/// 🚚 배달 기사 - Supabase와 직접 통신
final companyDataSourceProvider = Provider<CompanyDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseCompanyDataSource(client);
});

/// Store DataSource Provider
///
/// 🚚 배달 기사 - Supabase와 직접 통신
final storeDataSourceProvider = Provider<StoreDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseStoreDataSource(client);
});

// ============================================================================
// Repository Providers (Clean Architecture Implementation!)
// ============================================================================

/// Auth Repository Provider
///
/// 📜 계약 이행자 - Domain Repository Interface 구현
/// Uses AuthDataSource for Supabase Auth communication
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

/// User Repository Provider
///
/// 📜 계약 이행자 - Domain Repository Interface 구현
/// Uses UserDataSource for Supabase Database communication
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return UserRepositoryImpl(dataSource);
});

/// Company Repository Provider
///
/// 📜 계약 이행자 - Domain Repository Interface 구현
/// Uses CompanyDataSource for Supabase communication
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final dataSource = ref.watch(companyDataSourceProvider);
  return CompanyRepositoryImpl(dataSource);
});

/// Store Repository Provider
///
/// 📜 계약 이행자 - Domain Repository Interface 구현
/// Uses StoreDataSource for Supabase communication
final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final dataSource = ref.watch(storeDataSourceProvider);
  return StoreRepositoryImpl(dataSource);
});
