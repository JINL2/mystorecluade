// lib/features/cash_ending/presentation/providers/bank_tab_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/stock_flow.dart';

import 'base_tab_state.dart';
part 'bank_tab_state.freezed.dart';

/// State for Bank Tab
@freezed
class BankTabState with _$BankTabState implements BaseTabState {
  const factory BankTabState({
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
  }) = _BankTabState;
}
