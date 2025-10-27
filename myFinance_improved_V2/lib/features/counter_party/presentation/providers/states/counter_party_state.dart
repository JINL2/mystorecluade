import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/counter_party.dart';
import '../../../domain/entities/counter_party_stats.dart';
import '../../../domain/value_objects/counter_party_filter.dart';

part 'counter_party_state.freezed.dart';

/// Counter Party Page State - UI state for counter party page
///
/// Manages the overall page state including data loading,
/// filtering, searching, and error handling.
@freezed
class CounterPartyPageState with _$CounterPartyPageState {
  const factory CounterPartyPageState({
    @Default([]) List<CounterParty> counterParties,
    CounterPartyStats? stats,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    @Default('') String searchQuery,
    @Default(CounterPartyFilter()) CounterPartyFilter filter,
    DateTime? lastFetchedAt,
  }) = _CounterPartyPageState;

  const CounterPartyPageState._();

  /// Check if cache is stale (older than 30 seconds)
  bool get isCacheStale {
    if (lastFetchedAt == null) return true;
    return DateTime.now().difference(lastFetchedAt!).inSeconds > 30;
  }

  /// Check if any filter is active
  bool get hasActiveFilter {
    return filter.types != null && filter.types!.isNotEmpty ||
           filter.isInternal != null ||
           searchQuery.isNotEmpty;
  }

  /// Get filtered counter parties
  List<CounterParty> get filteredCounterParties {
    var result = counterParties;

    // Apply type filter
    if (filter.types != null && filter.types!.isNotEmpty) {
      result = result.where((cp) => filter.types!.contains(cp.type)).toList();
    }

    // Apply internal/external filter
    if (filter.isInternal != null) {
      result = result.where((cp) => cp.isInternal == filter.isInternal!).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((cp) {
        return cp.name.toLowerCase().contains(query) ||
               (cp.email?.toLowerCase().contains(query) ?? false) ||
               (cp.phone?.contains(query) ?? false);
      }).toList();
    }

    return result;
  }
}

/// Counter Party Form State - UI state for counter party creation/editing
///
/// Tracks form validation, submission progress, and errors.
@freezed
class CounterPartyFormState with _$CounterPartyFormState {
  const factory CounterPartyFormState({
    @Default(0) int currentStep,
    @Default(3) int totalSteps,
    @Default(false) bool isSubmitting,
    @Default(false) bool isValidating,
    CounterParty? editingCounterParty,
    String? errorMessage,
    @Default({}) Map<String, String> fieldErrors,
    @Default(false) bool isSuccess,
  }) = _CounterPartyFormState;

  const CounterPartyFormState._();

  /// Check if current step is valid
  bool get isCurrentStepValid {
    // Step validation logic will be in the form widget
    return fieldErrors.isEmpty;
  }

  /// Check if form is in edit mode
  bool get isEditMode => editingCounterParty != null;
}

/// Counter Party List State - Simple list state for optimized rendering
///
/// Used for list-specific UI state like selection, expansion, etc.
@freezed
class CounterPartyListState with _$CounterPartyListState {
  const factory CounterPartyListState({
    String? selectedCounterPartyId,
    @Default({}) Set<String> expandedItems,
    @Default(false) bool isSelectionMode,
    @Default({}) Set<String> selectedItems,
  }) = _CounterPartyListState;

  const CounterPartyListState._();

  /// Check if item is selected
  bool isSelected(String id) => selectedItems.contains(id);

  /// Check if item is expanded
  bool isExpanded(String id) => expandedItems.contains(id);

  /// Get selected count
  int get selectedCount => selectedItems.length;
}
