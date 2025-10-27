import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/services/supabase_service.dart';

import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_datasource.dart';
import 'transaction_repository_impl.dart';

/// Provider for TransactionDataSource
final transactionDataSourceProvider = Provider<TransactionDataSource>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return TransactionDataSource(supabaseService);
});

/// Provider for TransactionRepository
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dataSource = ref.watch(transactionDataSourceProvider);

  return TransactionRepositoryImpl(
    dataSource: dataSource,
    getCompanyId: () {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) {
        throw Exception('No company selected');
      }
      return appState.companyChoosen;
    },
    getStoreId: () {
      final appState = ref.read(appStateProvider);
      return appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
    },
  );
});
