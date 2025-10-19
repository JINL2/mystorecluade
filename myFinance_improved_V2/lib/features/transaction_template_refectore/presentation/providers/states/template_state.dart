import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/template_entity.dart';

part 'template_state.freezed.dart';

/// Template Page State - UI state for template page
///
/// Simple state model for template list page with loading,
/// error handling, and basic filtering.
@freezed
class TemplateState with _$TemplateState {
  const factory TemplateState({
    @Default([]) List<TransactionTemplate> templates,
    @Default(false) bool isLoading,
    @Default(false) bool isCreating,
    String? errorMessage,
    String? searchQuery,
    @Default('all') String selectedFilter,
  }) = _TemplateState;
}

/// Template Creation State - UI state for template creation
///
/// Tracks template creation flow progress and results.
@freezed
class TemplateCreationState with _$TemplateCreationState {
  const factory TemplateCreationState({
    @Default(false) bool isCreating,
    @Default(false) bool isValidating,
    TransactionTemplate? createdTemplate,
    String? errorMessage,
    @Default({}) Map<String, String> fieldErrors,
  }) = _TemplateCreationState;
}

/// Template Filter State - Simple filter options
///
/// Basic filtering options for template list.
@freezed
class TemplateFilterState with _$TemplateFilterState {
  const TemplateFilterState._(); // Private constructor for getters

  const factory TemplateFilterState({
    @Default('all') String visibilityFilter, // all, public, private
    @Default('all') String statusFilter,     // all, active, inactive
    @Default('') String searchText,
    @Default(false) bool showMyTemplatesOnly,
    List<String>? accountIds,                // Filter by account IDs
    String? counterpartyId,                  // Filter by counterparty ID
    String? cashLocationId,                  // Filter by cash location ID
  }) = _TemplateFilterState;

  /// Get display name for current filter
  String get displayName {
    if (showMyTemplatesOnly) return 'My Templates';
    if (visibilityFilter != 'all') return visibilityFilter.toUpperCase();
    if (statusFilter != 'all') return statusFilter.toUpperCase();
    if (searchText.isNotEmpty) return 'Search: $searchText';
    return 'All Templates';
  }

  /// Check if any filter is active
  bool get hasActiveFilter {
    return visibilityFilter != 'all' ||
           statusFilter != 'all' ||
           searchText.isNotEmpty ||
           showMyTemplatesOnly;
  }
}
