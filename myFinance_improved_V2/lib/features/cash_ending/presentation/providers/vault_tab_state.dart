// lib/features/cash_ending/presentation/providers/vault_tab_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/stock_flow.dart';

import 'base_tab_state.dart';
part 'vault_tab_state.freezed.dart';

/// State for Vault Tab
@freezed
class VaultTabState with _$VaultTabState implements BaseTabState {
  const factory VaultTabState({
    // Stock flow data
    @Default([]) List<ActualFlow> stockFlows,
    LocationSummary? locationSummary,

    // Loading states
    @Default(false) bool isLoadingFlows,
    @Default(false) bool isSaving,

    // Pagination
    @Default(0) int flowsOffset,
    @Default(false) bool hasMoreFlows,

    // Error handling
    String? errorMessage,
  }) = _VaultTabState;
}
