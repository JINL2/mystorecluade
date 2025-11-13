import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/debt_communication.dart';
import '../../domain/entities/payment_plan.dart';
import '../../domain/entities/prioritized_debt.dart';
import 'debt_repository_provider.dart';
import 'states/debt_control_state.dart';

/// Selected debt provider for detail view
final selectedDebtProvider = StateProvider<PrioritizedDebt?>((ref) => null);

/// Debt detail provider managing communications and payment plans
final debtDetailProvider =
    AsyncNotifierProvider.family<DebtDetailNotifier, DebtDetailState, String>(
  () => DebtDetailNotifier(),
);

class DebtDetailNotifier
    extends FamilyAsyncNotifier<DebtDetailState, String> {
  @override
  Future<DebtDetailState> build(String debtId) async {
    // Get the selected debt from selectedDebtProvider
    final debt = ref.read(selectedDebtProvider);

    return DebtDetailState(debt: debt);
  }

  /// Load communications for the debt
  Future<void> loadCommunications() async {
    if (state.value == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(isLoadingCommunications: true),
    );

    try {
      final repository = ref.read(debtRepositoryProvider);
      final communications = await repository.getDebtCommunications(arg);

      state = AsyncValue.data(
        state.value!.copyWith(
          communications: communications,
          isLoadingCommunications: false,
        ),
      );
    } catch (error) {
      state = AsyncValue.data(
        state.value!.copyWith(
          communications: const [],
          isLoadingCommunications: false,
          errorMessage: 'Failed to load communications',
        ),
      );
    }
  }

  /// Load payment plans for the debt
  Future<void> loadPaymentPlans() async {
    if (state.value == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(isLoadingPaymentPlans: true),
    );

    try {
      final repository = ref.read(debtRepositoryProvider);
      final paymentPlans = await repository.getPaymentPlans(arg);

      state = AsyncValue.data(
        state.value!.copyWith(
          paymentPlans: paymentPlans,
          isLoadingPaymentPlans: false,
        ),
      );
    } catch (error) {
      state = AsyncValue.data(
        state.value!.copyWith(
          paymentPlans: const [],
          isLoadingPaymentPlans: false,
          errorMessage: 'Failed to load payment plans',
        ),
      );
    }
  }

  /// Add new communication record
  Future<void> addCommunication(DebtCommunication communication) async {
    if (state.value == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(
        isPerformingAction: true,
        actionInProgress: 'add_communication',
      ),
    );

    try {
      final repository = ref.read(debtRepositoryProvider);
      await repository.createDebtCommunication(communication);

      // Reload communications
      await loadCommunications();

      state = AsyncValue.data(
        state.value!.copyWith(
          isPerformingAction: false,
          actionInProgress: null,
        ),
      );
    } catch (error) {
      state = AsyncValue.data(
        state.value!.copyWith(
          isPerformingAction: false,
          actionInProgress: null,
          errorMessage: 'Failed to add communication',
        ),
      );
    }
  }

  /// Create new payment plan
  Future<void> createPaymentPlan(PaymentPlan paymentPlan) async {
    if (state.value == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(
        isPerformingAction: true,
        actionInProgress: 'create_payment_plan',
      ),
    );

    try {
      final repository = ref.read(debtRepositoryProvider);
      await repository.createPaymentPlan(paymentPlan);

      // Reload payment plans
      await loadPaymentPlans();

      state = AsyncValue.data(
        state.value!.copyWith(
          isPerformingAction: false,
          actionInProgress: null,
        ),
      );
    } catch (error) {
      state = AsyncValue.data(
        state.value!.copyWith(
          isPerformingAction: false,
          actionInProgress: null,
          errorMessage: 'Failed to create payment plan',
        ),
      );
    }
  }

  /// Update payment plan status
  Future<void> updatePaymentPlanStatus(String planId, String status) async {
    if (state.value == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(
        isPerformingAction: true,
        actionInProgress: 'update_payment_plan',
      ),
    );

    try {
      final repository = ref.read(debtRepositoryProvider);
      await repository.updatePaymentPlanStatus(planId, status);

      // Update local state
      final updatedPlans = state.value!.paymentPlans.map((plan) {
        if (plan is PaymentPlan && plan.id == planId) {
          return plan.copyWith(status: status);
        }
        return plan;
      }).toList();

      state = AsyncValue.data(
        state.value!.copyWith(
          paymentPlans: updatedPlans,
          isPerformingAction: false,
          actionInProgress: null,
        ),
      );
    } catch (error) {
      state = AsyncValue.data(
        state.value!.copyWith(
          isPerformingAction: false,
          actionInProgress: null,
          errorMessage: 'Failed to update payment plan',
        ),
      );
    }
  }

  /// Clear error message
  void clearError() {
    if (state.value != null) {
      state = AsyncValue.data(
        state.value!.copyWith(errorMessage: null),
      );
    }
  }
}
