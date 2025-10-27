import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/supabase_debt_data_source.dart';
import '../../data/repositories/debt_repository_impl.dart';
import '../../domain/repositories/debt_repository.dart';

/// Data source provider
final debtDataSourceProvider = Provider<SupabaseDebtDataSource>((ref) {
  return SupabaseDebtDataSource();
});

/// Repository provider for debt control operations
/// This is the single source of truth for all debt-related data operations
final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  final dataSource = ref.watch(debtDataSourceProvider);
  return DebtRepositoryImpl(dataSource: dataSource);
});
