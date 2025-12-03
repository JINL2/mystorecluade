// lib/features/report_control/presentation/pages/templates/financial_summary/providers/financial_data_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/repositories/financial_data_repository.dart';
import '../data/datasources/financial_data_datasource.dart';
import '../data/repositories/financial_data_repository_impl.dart';

/// Supabase Client Provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Financial Data DataSource Provider
final _financialDataDataSourceProvider = Provider<FinancialDataDataSource>((ref) {
  final supabase = ref.watch(_supabaseClientProvider);
  return FinancialDataDataSource(supabase);
});

/// Financial Data Repository Provider
final financialDataRepositoryProvider = Provider<FinancialDataRepository>((ref) {
  final dataSource = ref.watch(_financialDataDataSourceProvider);
  return FinancialDataRepositoryImpl(dataSource);
});
