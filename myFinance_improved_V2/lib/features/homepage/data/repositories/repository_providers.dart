/// Repository Providers for homepage module
///
/// Following Clean Architecture pattern: Presentation layer imports this file
/// to access repositories without knowing implementation details.
///
/// Private providers (_prefix) are internal to Data layer.
/// Public providers expose Domain interfaces to Presentation layer.
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/repositories/homepage_repository.dart';
import '../../domain/repositories/join_repository.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/company_remote_datasource.dart';
import '../datasources/homepage_data_source.dart';
import '../datasources/join_remote_datasource.dart';
import '../datasources/store_remote_datasource.dart';
import 'company_repository_impl.dart';
import 'homepage_repository_impl.dart';
import 'join_repository_impl.dart';
import 'store_repository_impl.dart';

// ============================================================================
// Internal Providers (Private - used only within this file)
// ============================================================================

/// Supabase client provider (Internal)
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// SupabaseService provider (Internal)
final _supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Homepage data source provider (Internal)
final _homepageDataSourceProvider = Provider<HomepageDataSource>((ref) {
  final supabaseService = ref.read(_supabaseServiceProvider);
  return HomepageDataSource(supabaseService);
});

/// Company remote data source provider (Internal)
final _companyRemoteDataSourceProvider = Provider<CompanyRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(_supabaseClientProvider);
  return CompanyRemoteDataSourceImpl(supabaseClient);
});

/// Store remote data source provider (Internal)
final _storeRemoteDataSourceProvider = Provider<StoreRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(_supabaseClientProvider);
  return StoreRemoteDataSourceImpl(supabaseClient);
});

/// Join remote data source provider (Internal)
final _joinRemoteDataSourceProvider = Provider<JoinRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(_supabaseClientProvider);
  return JoinRemoteDataSourceImpl(supabaseClient);
});

// ============================================================================
// Public Repository Providers (Exposed to Presentation layer)
// ============================================================================

/// Homepage repository provider
///
/// Provides HomepageRepositoryImpl implementation.
/// Presentation layer should use this provider.
final homepageRepositoryProvider = Provider<HomepageRepository>((ref) {
  final dataSource = ref.watch(_homepageDataSourceProvider);
  return HomepageRepositoryImpl(dataSource: dataSource);
});

/// Company repository provider
///
/// Provides CompanyRepositoryImpl implementation.
/// Presentation layer should use this provider.
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final remoteDataSource = ref.watch(_companyRemoteDataSourceProvider);
  return CompanyRepositoryImpl(remoteDataSource);
});

/// Store repository provider
///
/// Provides StoreRepositoryImpl implementation.
/// Presentation layer should use this provider.
final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final remoteDataSource = ref.watch(_storeRemoteDataSourceProvider);
  return StoreRepositoryImpl(remoteDataSource);
});

/// Join repository provider
///
/// Provides JoinRepositoryImpl implementation.
/// Presentation layer should use this provider.
final joinRepositoryProvider = Provider<JoinRepository>((ref) {
  final remoteDataSource = ref.watch(_joinRemoteDataSourceProvider);
  return JoinRepositoryImpl(remoteDataSource);
});
