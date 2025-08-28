import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/denomination.dart';
import '../../../../domain/repositories/denomination_repository.dart';
import '../../../../data/repositories/supabase_denomination_repository.dart';
import '../../../../data/services/denomination_template_service.dart';
import '../../../providers/app_state_provider.dart';
import 'currency_providers.dart';

// Repository providers
final denominationTemplateServiceProvider = Provider<DenominationTemplateService>((ref) {
  return DenominationTemplateService();
});

final denominationRepositoryProvider = Provider<DenominationRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final templateService = ref.watch(denominationTemplateServiceProvider);
  return SupabaseDenominationRepository(supabaseClient, templateService);
});

// Denominations for a specific currency
final denominationListProvider = FutureProvider.family<List<Denomination>, String>((ref, currencyId) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    throw Exception('No company selected');
  }
  
  final repository = ref.watch(denominationRepositoryProvider);
  return repository.getCurrencyDenominations(companyId, currencyId);
});

// Real-time denominations stream
final denominationStreamProvider = StreamProvider.family<List<Denomination>, String>((ref, currencyId) {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    return Stream.value([]);
  }
  
  final repository = ref.watch(denominationRepositoryProvider);
  return repository.watchCurrencyDenominations(companyId, currencyId);
});

// Denomination statistics
final denominationStatsProvider = FutureProvider.family<DenominationStats, String>((ref, currencyId) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) {
    throw Exception('No company selected');
  }
  
  final repository = ref.watch(denominationRepositoryProvider);
  return repository.getDenominationStats(companyId, currencyId);
});

// Denomination operations provider
class DenominationOperationsNotifier extends StateNotifier<AsyncValue<void>> {
  DenominationOperationsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));
  
  final DenominationRepository _repository;
  final Ref _ref;

  Future<void> addDenomination(DenominationInput input) async {
    state = const AsyncValue.loading();
    
    try {
      // Create a temporary denomination object for optimistic update
      final optimisticDenomination = Denomination(
        id: 'temp-${DateTime.now().millisecondsSinceEpoch}', // Temporary ID
        companyId: input.companyId,
        currencyId: input.currencyId,
        value: input.value,
        type: input.type,
        displayName: input.displayName ?? _getDefaultDisplayName(input.value, input.type),
        emoji: input.emoji ?? _getDefaultEmoji(input.type),
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // OPTIMISTIC UI UPDATE - Add to local state immediately
      _ref.read(localDenominationListProvider.notifier)
          .optimisticallyAdd(input.currencyId, optimisticDenomination);
      
      // Perform database operation in background
      await _repository.addDenomination(input);
      
      // Refresh the remote providers after successful database operation
      _ref.invalidate(denominationListProvider(input.currencyId));
      _ref.invalidate(denominationStatsProvider(input.currencyId));
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      // If database operation fails, revert the optimistic update
      _ref.read(localDenominationListProvider.notifier).reset(input.currencyId);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  String _getDefaultDisplayName(double value, DenominationType type) {
    if (type == DenominationType.coin) {
      return value < 1.0 ? '${(value * 100).toInt()}¢' : '\$${value.toInt()}';
    } else {
      return '\$${value.toInt()}';
    }
  }

  String _getDefaultEmoji(DenominationType type) {
    return type == DenominationType.coin ? '🪙' : '💵';
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
      await _repository.updateDenomination(
        denominationId,
        value: value,
        type: type,
        displayName: displayName,
        emoji: emoji,
        isActive: isActive,
      );
      
      // Refresh the denomination list for this currency
      _ref.invalidate(denominationListProvider(currencyId));
      _ref.invalidate(denominationStatsProvider(currencyId));
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeDenomination(String denominationId, String currencyId) async {
    print('=== OPERATIONS PROVIDER DEBUG START ===');
    print('DenominationOperationsNotifier: Starting removal of denomination');
    print('  Denomination ID: $denominationId');
    print('  Currency ID: $currencyId');
    state = const AsyncValue.loading();
    
    try {
      print('Calling repository.removeDenomination...');
      await _repository.removeDenomination(denominationId);
      print('✅ DenominationOperationsNotifier: Successfully removed denomination $denominationId');
      
      // Refresh the denomination list for this currency
      print('Invalidating providers for currency: $currencyId');
      _ref.invalidate(denominationListProvider(currencyId));
      _ref.invalidate(denominationStatsProvider(currencyId));
      
      state = const AsyncValue.data(null);
      print('=== OPERATIONS PROVIDER DEBUG END - SUCCESS ===');
    } catch (error, stackTrace) {
      print('❌ DenominationOperationsNotifier: Error removing denomination: $error');
      print('Stack trace: $stackTrace');
      print('=== OPERATIONS PROVIDER DEBUG END - ERROR ===');
      state = AsyncValue.error(error, stackTrace);
      // Re-throw to propagate the error
      rethrow;
    }
  }

  Future<void> applyTemplate(String currencyCode, String currencyId) async {
    final appState = _ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      await _repository.applyDenominationTemplate(currencyCode, companyId, currencyId);
      
      // Refresh the denomination list for this currency
      _ref.invalidate(denominationListProvider(currencyId));
      _ref.invalidate(denominationStatsProvider(currencyId));
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addBulkDenominations(List<DenominationInput> inputs) async {
    if (inputs.isEmpty) return;

    state = const AsyncValue.loading();
    
    try {
      await _repository.addBulkDenominations(inputs);
      
      // Refresh denomination lists for affected currencies
      final currencyIds = inputs.map((input) => input.currencyId).toSet();
      for (final currencyId in currencyIds) {
        _ref.invalidate(denominationListProvider(currencyId));
        _ref.invalidate(denominationStatsProvider(currencyId));
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

final denominationOperationsProvider = StateNotifierProvider<DenominationOperationsNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(denominationRepositoryProvider);
  return DenominationOperationsNotifier(repository, ref);
});

// Denomination validation provider
class DenominationValidationNotifier extends StateNotifier<AsyncValue<DenominationValidationResult>> {
  DenominationValidationNotifier(this._repository, this._ref) : super(const AsyncValue.data(
    DenominationValidationResult(isValid: true),
  ));
  
  final DenominationRepository _repository;
  final Ref _ref;

  Future<void> validateDenominations(String currencyId, List<DenominationInput> denominations) async {
    final appState = _ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      state = AsyncValue.error(Exception('No company selected'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final result = await _repository.validateDenominations(companyId, currencyId, denominations);
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void resetValidation() {
    state = const AsyncValue.data(
      DenominationValidationResult(isValid: true),
    );
  }
}

final denominationValidationProvider = StateNotifierProvider<DenominationValidationNotifier, AsyncValue<DenominationValidationResult>>((ref) {
  final repository = ref.watch(denominationRepositoryProvider);
  return DenominationValidationNotifier(repository, ref);
});

// Template-related providers
final availableTemplatesProvider = Provider<List<String>>((ref) {
  final templateService = ref.watch(denominationTemplateServiceProvider);
  return templateService.getAvailableTemplates();
});

final denominationTemplateProvider = Provider.family<List<DenominationTemplateItem>, String>((ref, currencyCode) {
  final templateService = ref.watch(denominationTemplateServiceProvider);
  return templateService.getTemplate(currencyCode);
});

final hasTemplateProvider = Provider.family<bool, String>((ref, currencyCode) {
  final templateService = ref.watch(denominationTemplateServiceProvider);
  return templateService.hasTemplate(currencyCode);
});

// UI State providers
final selectedDenominationTypeProvider = StateProvider<DenominationType>((ref) => DenominationType.bill);

final denominationFormProvider = StateProvider<DenominationInput?>((ref) => null);

// Denomination editor state
class DenominationEditorNotifier extends StateNotifier<DenominationEditorState> {
  DenominationEditorNotifier() : super(const DenominationEditorState());

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

final denominationEditorProvider = StateNotifierProvider<DenominationEditorNotifier, DenominationEditorState>((ref) {
  return DenominationEditorNotifier();
});

// Local denomination list state for optimistic UI updates
class LocalDenominationListNotifier extends StateNotifier<Map<String, List<Denomination>>> {
  LocalDenominationListNotifier(this._ref) : super({});
  
  final Ref _ref; // ignore: unused_field

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

final localDenominationListProvider = StateNotifierProvider<LocalDenominationListNotifier, Map<String, List<Denomination>>>((ref) {
  return LocalDenominationListNotifier(ref);
});

// Combined provider that uses local state when available, falls back to remote
final effectiveDenominationListProvider = Provider.family<AsyncValue<List<Denomination>>, String>((ref, currencyId) {
  final localState = ref.watch(localDenominationListProvider);
  final remoteState = ref.watch(denominationListProvider(currencyId));
  
  // If we have local state for this currency, use it
  if (localState.containsKey(currencyId)) {
    return AsyncValue.data(localState[currencyId]!);
  }
  
  // For new currencies or when no local state exists, use remote state directly
  // Don't initialize local state here to avoid stale data issues
  return remoteState;
});