// lib/features/report_control/di/report_control_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/report_remote_datasource.dart';
import '../data/repositories/report_repository_impl.dart';
import '../domain/repositories/report_repository.dart';

/// DI Container for Report Control Feature
///
/// This is the ONLY place where Data layer implementations are instantiated.
/// Presentation layer must NOT import Data layer - only this DI container.
///
/// Clean Architecture Compliance:
/// - Presentation → Domain (via this DI)
/// - Data → Domain
/// - Domain → Nothing (pure business logic)

/// Supabase client provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Report Remote Data Source provider (private - only used within DI)
final _reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  final supabase = ref.watch(_supabaseClientProvider);
  return ReportRemoteDataSource(supabase);
});

/// Report Repository provider
///
/// This is the PUBLIC interface that Presentation layer uses.
/// Returns Domain interface (ReportRepository), not implementation.
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final dataSource = ref.watch(_reportRemoteDataSourceProvider);
  return ReportRepositoryImpl(dataSource);
});
