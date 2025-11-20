// lib/features/cash_ending/presentation/providers/cash_tab_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cash_tab_notifier.dart';
import 'cash_tab_state.dart';
import 'repository_providers.dart';

/// Provider for Cash Tab
final cashTabProvider = StateNotifierProvider<CashTabNotifier, CashTabState>((ref) {
  final stockFlowRepo = ref.watch(stockFlowRepositoryProvider);
  final cashEndingRepo = ref.watch(cashEndingRepositoryProvider);

  return CashTabNotifier(
    stockFlowRepository: stockFlowRepo,
    cashEndingRepository: cashEndingRepo,
  );
});
