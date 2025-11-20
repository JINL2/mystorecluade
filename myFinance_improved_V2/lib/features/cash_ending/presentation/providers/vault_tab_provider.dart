// lib/features/cash_ending/presentation/providers/vault_tab_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repository_providers.dart';
import 'vault_tab_notifier.dart';
import 'vault_tab_state.dart';

/// Provider for Vault Tab
final vaultTabProvider = StateNotifierProvider<VaultTabNotifier, VaultTabState>((ref) {
  final stockFlowRepo = ref.watch(stockFlowRepositoryProvider);
  final vaultRepo = ref.watch(vaultRepositoryProvider);

  return VaultTabNotifier(
    stockFlowRepository: stockFlowRepo,
    vaultRepository: vaultRepo,
  );
});
