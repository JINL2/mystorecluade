import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/debt_overview.dart';
import '../../../domain/entities/prioritized_debt.dart';
import '../../../domain/value_objects/debt_filter.dart';

part 'debt_control_state.freezed.dart';

/// Debt Control Page State - UI state for debt control dashboard
///
/// Manages the overview, debts list, filters, and loading states
/// for the main debt control page.
@freezed
class DebtControlState with _$DebtControlState {
  const factory DebtControlState({
    DebtOverview? overview,
    @Default([]) List<PrioritizedDebt> debts,
    @Default(false) bool isLoadingOverview,
    @Default(false) bool isLoadingDebts,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    @Default(DebtFilter()) DebtFilter filter,
    @Default('company') String viewpoint, // 'company', 'store', 'headquarters'
    String? selectedStoreId,
  }) = _DebtControlState;

  const DebtControlState._();

  /// Check if any data is loading
  bool get isLoading => isLoadingOverview || isLoadingDebts;

  /// Check if filter is active
  bool get hasActiveFilter => filter.isActive;

  /// Get total debt count
  int get totalDebtCount => debts.length;

  /// Get critical debt count
  int get criticalDebtCount =>
      debts.where((debt) => debt.isCritical).length;

  /// Check if overview data is available
  bool get hasOverview => overview != null;

  /// Check if debts data is available
  bool get hasDebts => debts.isNotEmpty;
}

/// Perspective Selection State - UI state for viewpoint selection
///
/// Manages the perspective/viewpoint selection (company, store, etc.)
@freezed
class PerspectiveState with _$PerspectiveState {
  const factory PerspectiveState({
    @Default('company') String selectedPerspective,
    String? selectedStoreId,
    String? selectedStoreName,
    @Default([]) List<Map<String, String>> availableStores,
    @Default(false) bool isChangingPerspective,
  }) = _PerspectiveState;

  const PerspectiveState._();

  /// Check if company perspective is selected
  bool get isCompanyPerspective => selectedPerspective == 'company';

  /// Check if store perspective is selected
  bool get isStorePerspective => selectedPerspective == 'store';

  /// Check if headquarters perspective is selected
  bool get isHeadquartersPerspective => selectedPerspective == 'headquarters';

  /// Get display name for current perspective
  String get perspectiveDisplayName {
    if (isStorePerspective && selectedStoreName != null) {
      return selectedStoreName!;
    }
    return selectedPerspective.toUpperCase();
  }
}

/// Alert Action State - UI state for alert actions
///
/// Tracks state when performing actions on critical alerts.
@freezed
class AlertActionState with _$AlertActionState {
  const factory AlertActionState({
    @Default(<String>{}) Set<String> processingAlerts,
    @Default(<String, String>{}) Map<String, String> alertErrors,
  }) = _AlertActionState;

  const AlertActionState._();

  /// Check if alert is being processed
  bool isProcessing(String alertId) => processingAlerts.contains(alertId);

  /// Get error for alert if any
  String? getError(String alertId) => alertErrors[alertId];

  /// Check if any alert has error
  bool get hasErrors => alertErrors.isNotEmpty;
}
