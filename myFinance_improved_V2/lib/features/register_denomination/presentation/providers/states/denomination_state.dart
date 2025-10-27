import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/denomination.dart';

part 'denomination_state.freezed.dart';

/// Denomination Page State - UI state for denomination management
///
/// Manages the state of denomination list and operations including:
/// - Denomination list for a specific currency
/// - Loading and error states
/// - CRUD operations
@freezed
class DenominationState with _$DenominationState {
  const factory DenominationState({
    /// List of denominations for the selected currency
    @Default([]) List<Denomination> denominations,

    /// Currently selected denomination for editing
    Denomination? selectedDenomination,

    /// Whether currently loading denominations
    @Default(false) bool isLoading,

    /// Whether currently adding a denomination
    @Default(false) bool isAdding,

    /// Whether currently updating a denomination
    @Default(false) bool isUpdating,

    /// Whether currently deleting a denomination
    @Default(false) bool isDeleting,

    /// Error message if any error occurred
    String? errorMessage,

    /// Field-specific validation errors
    @Default({}) Map<String, String> fieldErrors,

    /// Selected currency ID for filtering
    String? selectedCurrencyId,
  }) = _DenominationState;

  /// Initial state factory
  factory DenominationState.initial() => const DenominationState();
}

/// Denomination Creation State - UI state for creating denominations
@freezed
class DenominationCreationState with _$DenominationCreationState {
  const factory DenominationCreationState({
    /// Whether currently creating
    @Default(false) bool isCreating,

    /// Whether currently validating
    @Default(false) bool isValidating,

    /// Created denomination
    Denomination? createdDenomination,

    /// Error message
    String? errorMessage,

    /// Field-specific validation errors
    @Default({}) Map<String, String> fieldErrors,

    /// Form fields
    double? value,
    DenominationType? type,
    String? displayName,
    String? emoji,
  }) = _DenominationCreationState;

  /// Initial state factory
  factory DenominationCreationState.initial() => const DenominationCreationState();
}
