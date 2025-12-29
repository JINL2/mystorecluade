import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// App-level
import 'package:myfinance_improved/app/providers/app_state_provider.dart';

// Feature - DI (Dependency Injection)
import '../../di/providers.dart';
// Feature - Domain
import '../../domain/entities/denomination.dart';
import '../../domain/repositories/denomination_repository.dart';

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

/// Real-time denominations stream
@riverpod
Stream<List<Denomination>> denominationStream(Ref ref, String currencyId) {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return Stream.value([]);
  }

  final repository = ref.watch(denominationRepositoryProvider);
  return repository.watchCurrencyDenominations(companyId, currencyId);
}

// ============================================================================
// Denomination Stats Provider
// ============================================================================

/// Denomination statistics
@riverpod
Future<DenominationStats> denominationStats(Ref ref, String currencyId) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    throw Exception('No company selected');
  }

  final repository = ref.watch(denominationRepositoryProvider);
  return repository.getDenominationStats(companyId, currencyId);
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
      ref.invalidate(denominationStatsProvider(input.currencyId));
      ref.read(localDenominationListProvider.notifier).reset(input.currencyId);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateDenomination(
    String denominationId,
    String currencyId, {
    double? value,
    DenominationType? type,
    String? displayName,
    String? emoji,
    bool? isActive,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(denominationRepositoryProvider);
      await repository.updateDenomination(
        denominationId,
        value: value,
        type: type,
        displayName: displayName,
        emoji: emoji,
        isActive: isActive,
      );

      // Refresh the denomination list for this currency
      ref.invalidate(denominationListProvider(currencyId));
      ref.invalidate(denominationStatsProvider(currencyId));

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeDenomination(String denominationId, String currencyId) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(denominationRepositoryProvider);
      await repository.removeDenomination(denominationId);

      // Refresh the denomination list for this currency
      ref.invalidate(denominationListProvider(currencyId));
      ref.invalidate(denominationStatsProvider(currencyId));

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      // Re-throw to propagate the error
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
      ref.invalidate(denominationStatsProvider(currencyId));

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
        ref.invalidate(denominationStatsProvider(currencyId));
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
// Denomination Validation Notifier
// ============================================================================

/// Denomination validation notifier
@riverpod
class DenominationValidation extends _$DenominationValidation {
  @override
  AsyncValue<DenominationValidationResult> build() =>
      const AsyncValue.data(DenominationValidationResult(isValid: true));

  Future<void> validateDenominations(String currencyId, List<DenominationInput> denominations) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(denominationRepositoryProvider);
      final result = await repository.validateDenominations(companyId, currencyId, denominations);
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void resetValidation() {
    state = const AsyncValue.data(DenominationValidationResult(isValid: true));
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
// UI State Providers
// ============================================================================

/// Selected denomination type provider
@riverpod
class SelectedDenominationType extends _$SelectedDenominationType {
  @override
  DenominationType build() => DenominationType.bill;

  void update(DenominationType type) {
    state = type;
  }
}

/// Denomination form provider
@riverpod
class DenominationForm extends _$DenominationForm {
  @override
  DenominationInput? build() => null;

  void update(DenominationInput? input) {
    state = input;
  }

  void clear() {
    state = null;
  }
}

// ============================================================================
// Denomination Editor State
// ============================================================================

/// Denomination editor state
class DenominationEditorState {
  const DenominationEditorState({
    this.editingDenomination,
    this.isEditing = false,
    this.value = 0.0,
    this.type = DenominationType.bill,
    this.displayName,
    this.emoji,
  });

  final Denomination? editingDenomination;
  final bool isEditing;
  final double value;
  final DenominationType type;
  final String? displayName;
  final String? emoji;

  DenominationEditorState copyWith({
    Denomination? editingDenomination,
    bool? isEditing,
    double? value,
    DenominationType? type,
    String? displayName,
    String? emoji,
  }) {
    return DenominationEditorState(
      editingDenomination: editingDenomination ?? this.editingDenomination,
      isEditing: isEditing ?? this.isEditing,
      value: value ?? this.value,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      emoji: emoji ?? this.emoji,
    );
  }
}

/// Denomination editor notifier
@riverpod
class DenominationEditor extends _$DenominationEditor {
  @override
  DenominationEditorState build() => const DenominationEditorState();

  void setEditingDenomination(Denomination? denomination) {
    state = state.copyWith(
      editingDenomination: denomination,
      isEditing: denomination != null,
    );
  }

  void updateValue(double value) {
    state = state.copyWith(value: value);
  }

  void updateType(DenominationType type) {
    state = state.copyWith(type: type);
  }

  void updateDisplayName(String displayName) {
    state = state.copyWith(displayName: displayName);
  }

  void updateEmoji(String emoji) {
    state = state.copyWith(emoji: emoji);
  }

  void reset() {
    state = const DenominationEditorState();
  }

  DenominationInput? toInput(String companyId, String currencyId) {
    if (state.value <= 0) return null;

    return DenominationInput(
      companyId: companyId,
      currencyId: currencyId,
      value: state.value,
      type: state.type,
      displayName: state.displayName?.isNotEmpty == true ? state.displayName : null,
      emoji: state.emoji?.isNotEmpty == true ? state.emoji : null,
    );
  }
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
