/// Company Data Layer Providers
///
/// This file contains all data layer providers for company feature.
/// These providers are internal to the data layer and should NOT be
/// imported directly by presentation layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/company_repository.dart';
import '../datasources/company_remote_datasource.dart';
import '../repositories/company_repository_impl.dart';

// ============================================================================
// Internal Providers (Private - used only within data layer)
// ============================================================================

/// Supabase client provider (Internal)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Company Remote Data Source provider (Internal)
final companyRemoteDataSourceProvider = Provider<CompanyRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return CompanyRemoteDataSourceImpl(supabaseClient);
});

// ============================================================================
// Public Repository Providers (Exposed to Domain layer)
// ============================================================================

/// Company Repository provider
///
/// Provides CompanyRepositoryImpl implementation.
/// This is the ONLY provider that should be exported to domain layer.
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final remoteDataSource = ref.watch(companyRemoteDataSourceProvider);
  return CompanyRepositoryImpl(remoteDataSource);
});
