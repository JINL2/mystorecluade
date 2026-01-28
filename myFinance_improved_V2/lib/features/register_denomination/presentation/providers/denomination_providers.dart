import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// App-level
import 'package:myfinance_improved/app/providers/app_state_provider.dart';

// Feature - DI (Dependency Injection)
import '../../di/providers.dart';
// Feature - Domain
import '../../domain/entities/denomination.dart';
import '../../domain/entities/denomination_delete_result.dart';

part 'denomination_providers.g.dart';

// ============================================================================
// Denomination List Provider
// ============================================================================

/// Denominations for a specific currency
@riverpod
Future<List<Denomination>> denominationList(Ref ref, String currencyId) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    throw Exception('No company selected');
  }

  final repository = ref.watch(denominationRepositoryProvider);
  return repository.getCurrencyDenominations(companyId, currencyId);
}

// ============================================================================
// Denomination Operations Notifier
// ============================================================================

/// Denomination operations notifier
@riverpod
class DenominationOperations extends _$DenominationOperations {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> addDenomination(DenominationInput input) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(denominationRepositoryProvider);
      await repository.addDenomination(input);

      // Refresh providers after successful database operation
      ref.invalidate(denominationListProvider(input.currencyId));
      ref.read(localDenominationListProvider.notifier).reset(input.currencyId);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<DenominationDeleteResult> removeDenomination(String denominationId, String currencyId) async {
    state = const AsyncValue.loading();

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }

      final repository = ref.read(denominationRepositoryProvider);
      final result = await repository.removeDenomination(denominationId, companyId);

      if (result.success) {
        // Refresh the denomination list for this currency
        ref.invalidate(denominationListProvider(currencyId));
      }

      state = const AsyncValue.data(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> applyTemplate(String currencyCode, String currencyId) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(denominationRepositoryProvider);
      await repository.applyDenominationTemplate(currencyCode, companyId, currencyId);

      // Refresh the denomination list for this currency
      ref.invalidate(denominationListProvider(currencyId));

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addBulkDenominations(List<DenominationInput> inputs) async {
    if (inputs.isEmpty) return;

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(denominationRepositoryProvider);
      await repository.addBulkDenominations(inputs);

      // Refresh denomination lists for affected currencies
      final currencyIds = inputs.map((input) => input.currencyId).toSet();
      for (final currencyId in currencyIds) {
        ref.invalidate(denominationListProvider(currencyId));
      }

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void resetState() {
    state = const AsyncValue.data(null);
  }
}

// ============================================================================
// Template Providers
// ============================================================================

/// Available templates provider
@riverpod
List<String> availableTemplates(Ref ref) {
  final templateService = ref.watch(denominationTemplateServiceProvider);
  return templateService.getAvailableTemplates();
}

/// Denomination template provider
@riverpod
List<DenominationTemplateItem> denominationTemplate(Ref ref, String currencyCode) {
  final templateService = ref.watch(denominationTemplateServiceProvider);
  return templateService.getTemplate(currencyCode);
}

/// Has template provider
@riverpod
bool hasTemplate(Ref ref, String currencyCode) {
  final templateService = ref.watch(denominationTemplateServiceProvider);
  return templateService.hasTemplate(currencyCode);
}

// ============================================================================
// Local Denomination List Provider (for Optimistic UI Updates)
// ============================================================================

/// Local denomination list notifier for optimistic UI updates
@riverpod
class LocalDenominationList extends _$LocalDenominationList {
  @override
  Map<String, List<Denomination>> build() => {};

  // Initialize local state with remote data
  void initializeFromRemote(String currencyId, List<Denomination> denominations) {
    state = {...state, currencyId: denominations};
  }

  // Get current local denominations for a currency
  List<Denomination> getDenominations(String currencyId) {
    return state[currencyId] ?? [];
  }

  // Optimistically remove denomination from local state
  void optimisticallyRemove(String currencyId, String denominationId) {
    final currentList = state[currencyId] ?? [];
    final updatedList = currentList.where((d) => d.id != denominationId).toList();
    state = {...state, currencyId: updatedList};
  }

  // Optimistically add denomination to local state
  void optimisticallyAdd(String currencyId, Denomination denomination) {
    final currentList = state[currencyId] ?? [];
    final updatedList = [...currentList, denomination];
    state = {...state, currencyId: updatedList};
  }

  // Reset local state for a currency (sync with remote)
  void reset(String currencyId) {
    final newState = Map<String, List<Denomination>>.from(state);
    newState.remove(currencyId);
    state = newState;
  }

  // Clear all local state
  void clearAll() {
    state = {};
  }
}

// ============================================================================
// Effective Denomination List Provider
// ============================================================================

/// Combined provider that uses local state when available, falls back to remote
@riverpod
AsyncValue<List<Denomination>> effectiveDenominationList(Ref ref, String currencyId) {
  final localState = ref.watch(localDenominationListProvider);
  final remoteState = ref.watch(denominationListProvider(currencyId));

  // If we have local state for this currency, use it
  if (localState.containsKey(currencyId)) {
    return AsyncValue.data(localState[currencyId]!);
  }

  // For new currencies or when no local state exists, use remote state directly
  // Don't initialize local state here to avoid stale data issues
  return remoteState;
}
