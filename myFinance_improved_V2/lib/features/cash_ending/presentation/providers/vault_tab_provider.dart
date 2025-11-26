// lib/features/cash_ending/presentation/providers/vault_tab_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import 'vault_tab_notifier.dart';
import 'vault_tab_state.dart';

/// Provider for Vault Tab
///
/// ✅ 100% UseCase-based (Clean Architecture compliant)
final vaultTabProvider = StateNotifierProvider<VaultTabNotifier, VaultTabState>((ref) {
  final getStockFlowsUseCase = ref.watch(getStockFlowsUseCaseProvider);
  final saveVaultTransactionUseCase = ref.watch(saveVaultTransactionUseCaseProvider);
  final recountVaultUseCase = ref.watch(recountVaultUseCaseProvider);
  final executeMultiCurrencyRecountUseCase = ref.watch(executeMultiCurrencyRecountUseCaseProvider);
  final getBalanceSummaryUseCase = ref.watch(getVaultBalanceSummaryUseCaseProvider);

  return VaultTabNotifier(
    getStockFlowsUseCase: getStockFlowsUseCase,
    saveVaultTransactionUseCase: saveVaultTransactionUseCase,
    recountVaultUseCase: recountVaultUseCase,
    executeMultiCurrencyRecountUseCase: executeMultiCurrencyRecountUseCase,
    getBalanceSummaryUseCase: getBalanceSummaryUseCase,
  );
});
