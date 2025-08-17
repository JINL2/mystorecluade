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
      await _repository.addDenomination(input);
      
      // Refresh the denomination list for this currency
      _ref.invalidate(denominationListProvider(input.currencyId));
      _ref.invalidate(denominationStatsProvider(input.currencyId));
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
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
    state = const AsyncValue.loading();
    
    try {
      await _repository.removeDenomination(denominationId);
      
      // Refresh the denomination list for this currency
      _ref.invalidate(denominationListProvider(currencyId));
      _ref.invalidate(denominationStatsProvider(currencyId));
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
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