import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/balance_sheet_data_source.dart';
import '../data/repositories/balance_sheet_repository_impl.dart';
import '../domain/repositories/balance_sheet_repository.dart';

/// Balance Sheet Feature Dependency Injection
///
/// This file isolates Data layer dependencies from Presentation layer.
/// Presentation layer should only import from this file, not directly from Data.

/// Data source provider (internal - not exported to presentation)
final _balanceSheetDataSourceProvider = Provider<BalanceSheetDataSource>((ref) {
  return BalanceSheetDataSource(Supabase.instance.client);
});

/// Repository provider - exports Domain interface type
/// Presentation layer uses this provider to access repository
final balanceSheetRepositoryProvider = Provider<BalanceSheetRepository>((ref) {
  final dataSource = ref.read(_balanceSheetDataSourceProvider);
  return BalanceSheetRepositoryImpl(dataSource);
});
