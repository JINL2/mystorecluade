/// Repository providers for sale_product feature
///
/// Provides repository instances with proper dependency injection.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/payment_remote_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/repositories/sales_journal_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/repositories/sales_journal_repository.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

/// Payment remote data source provider
final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSource(Supabase.instance.client);
});

// ============================================================================
// Repository Providers
// ============================================================================

/// Payment repository provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dataSource = ref.read(paymentRemoteDataSourceProvider);
  return PaymentRepositoryImpl(dataSource);
});

/// Sales journal repository provider
final salesJournalRepositoryProvider = Provider<SalesJournalRepository>((ref) {
  return SalesJournalRepositoryImpl(Supabase.instance.client);
});
