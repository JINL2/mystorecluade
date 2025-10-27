import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'debt_repository_provider.dart';
import 'states/debt_control_state.dart';

/// Alert action state provider
final alertActionProvider =
    StateNotifierProvider<AlertActionNotifier, AlertActionState>(
  (ref) => AlertActionNotifier(ref),
);

class AlertActionNotifier extends StateNotifier<AlertActionState> {
  AlertActionNotifier(this.ref) : super(const AlertActionState());

  final Ref ref;

  /// Mark alert as read
  Future<void> markAlertAsRead(String alertId) async {
    // Add to processing state
    state = state.copyWith(
      processingAlerts: {...state.processingAlerts, alertId},
    );

    try {
      final repository = ref.read(debtRepositoryProvider);
      await repository.markAlertAsRead(alertId);

      // Remove from processing state
      state = state.copyWith(
        processingAlerts:
            state.processingAlerts.where((id) => id != alertId).toSet(),
      );
    } catch (error) {
      // Add error and remove from processing
      final errors = Map<String, String>.from(state.alertErrors);
      errors[alertId] = 'Failed to mark alert as read';

      state = state.copyWith(
        processingAlerts:
            state.processingAlerts.where((id) => id != alertId).toSet(),
        alertErrors: errors,
      );
    }
  }

  /// Clear error for specific alert
  void clearError(String alertId) {
    final errors = Map<String, String>.from(state.alertErrors);
    errors.remove(alertId);
    state = state.copyWith(alertErrors: errors);
  }

  /// Clear all errors
  void clearAllErrors() {
    state = state.copyWith(alertErrors: {});
  }

  /// Check if alert is processing
  bool isProcessing(String alertId) {
    return state.processingAlerts.contains(alertId);
  }
}
