// lib/features/cash_ending/presentation/providers/bank_tab_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bank_tab_notifier.dart';
import 'bank_tab_state.dart';
import 'repository_providers.dart';

/// Provider for Bank Tab
final bankTabProvider = StateNotifierProvider<BankTabNotifier, BankTabState>((ref) {
  final stockFlowRepo = ref.watch(stockFlowRepositoryProvider);
  final bankRepo = ref.watch(bankRepositoryProvider);

  return BankTabNotifier(
    stockFlowRepository: stockFlowRepo,
    bankRepository: bankRepo,
  );
});
