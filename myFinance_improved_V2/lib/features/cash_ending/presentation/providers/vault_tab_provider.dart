// lib/features/cash_ending/presentation/providers/vault_tab_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import 'vault_tab_notifier.dart';
import 'vault_tab_state.dart';

/// Provider for Vault Tab
///
/// ✅ Injects GetStockFlowsUseCase (Clean Architecture compliant)
final vaultTabProvider = StateNotifierProvider<VaultTabNotifier, VaultTabState>((ref) {
  final getStockFlowsUseCase = ref.watch(getStockFlowsUseCaseProvider);
  final vaultRepo = ref.watch(vaultRepositoryProvider);

  return VaultTabNotifier(
    getStockFlowsUseCase: getStockFlowsUseCase,
    vaultRepository: vaultRepo,
  );
});
