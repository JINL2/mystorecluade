import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/cash_location_detail.dart';

part 'account_settings_state.freezed.dart';

/// State for Account Settings Page
///
/// Manages the form state and loading status for account settings.
@freezed
class AccountSettingsState with _$AccountSettingsState {
  const AccountSettingsState._();

  const factory AccountSettingsState({
    /// The loaded cash location detail
    CashLocationDetail? location,

    /// Current account name (editable)
    @Default('') String accountName,

    /// Note/memo for the location
    @Default('') String note,

    /// Description (for cash/vault types)
    @Default('') String description,

    /// Bank name (for bank type only)
    @Default('') String bankName,

    /// Account number (for bank type only)
    @Default('') String accountNumber,

    /// Whether this is the main account
    @Default(false) bool isMainAccount,

    /// Loading state
    @Default(false) bool isLoading,

    /// Whether data is being saved
    @Default(false) bool isSaving,

    /// Error message if any
    String? errorMessage,

    /// Success message for UI feedback
    String? successMessage,
  }) = _AccountSettingsState;

  /// Check if the state has loaded data
  bool get hasData => location != null;

  /// Check if currently in any loading state
  bool get isBusy => isLoading || isSaving;
}
