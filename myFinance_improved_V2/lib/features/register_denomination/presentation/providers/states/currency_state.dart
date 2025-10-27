import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/currency.dart';

part 'currency_state.freezed.dart';

/// Currency Page State - UI state for currency management
///
/// Manages the state of currency list and operations including:
/// - Currency list and loading states
/// - Selected currency
/// - Error handling
@freezed
class CurrencyState with _$CurrencyState {
  const factory CurrencyState({
    /// List of company currencies
    @Default([]) List<Currency> currencies,

    /// Currently selected currency
    Currency? selectedCurrency,

    /// Whether currently loading currencies
    @Default(false) bool isLoading,

    /// Whether currently adding a currency
    @Default(false) bool isAdding,

    /// Error message if any error occurred
    String? errorMessage,

    /// Field-specific validation errors
    @Default({}) Map<String, String> fieldErrors,
  }) = _CurrencyState;

  /// Initial state factory
  factory CurrencyState.initial() => const CurrencyState();
}

/// Currency Type Selection State - UI state for currency type selection
@freezed
class CurrencyTypeSelectionState with _$CurrencyTypeSelectionState {
  const factory CurrencyTypeSelectionState({
    /// List of available currency types
    @Default([]) List<CurrencyType> availableTypes,

    /// Selected currency type
    CurrencyType? selectedType,

    /// Whether currently loading types
    @Default(false) bool isLoading,

    /// Search query for filtering
    @Default('') String searchQuery,

    /// Error message
    String? errorMessage,
  }) = _CurrencyTypeSelectionState;

  /// Initial state factory
  factory CurrencyTypeSelectionState.initial() => const CurrencyTypeSelectionState();
}
