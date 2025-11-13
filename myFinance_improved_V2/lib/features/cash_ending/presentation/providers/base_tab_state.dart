// lib/features/cash_ending/presentation/providers/base_tab_state.dart

import '../../domain/entities/stock_flow.dart';

/// Base interface for all tab states
/// Ensures consistent state structure across Cash, Bank, and Vault tabs
abstract class BaseTabState {
  // Stock flow data
  List<ActualFlow> get stockFlows;
  LocationSummary? get locationSummary;

  // Loading states
  bool get isLoadingFlows;
  bool get isSaving;

  // Pagination
  int get flowsOffset;
  bool get hasMoreFlows;

  // Error handling
  String? get errorMessage;

  // Note: copyWith is provided by Freezed generated code
  // No need to declare it here to avoid conflicts
}
