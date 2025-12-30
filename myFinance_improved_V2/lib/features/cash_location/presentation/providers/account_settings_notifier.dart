import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/monitoring/sentry_config.dart';
import 'cash_location_providers.dart';
import 'states/account_settings_state.dart';

part 'account_settings_notifier.g.dart';

/// Parameters for AccountSettingsNotifier
class AccountSettingsParams {
  final String locationId;
  final String accountName;
  final String locationType;

  const AccountSettingsParams({
    required this.locationId,
    required this.accountName,
    required this.locationType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountSettingsParams &&
          runtimeType == other.runtimeType &&
          locationId == other.locationId &&
          accountName == other.accountName &&
          locationType == other.locationType;

  @override
  int get hashCode =>
      locationId.hashCode ^ accountName.hashCode ^ locationType.hashCode;
}

/// Notifier for Account Settings Page
///
/// Manages all business logic for account settings including:
/// - Loading cash location data
/// - Updating name, note, description
/// - Toggling main account status
/// - Deleting the account
@riverpod
class AccountSettingsNotifier extends _$AccountSettingsNotifier {
  @override
  AccountSettingsState build(AccountSettingsParams params) {
    // Initial state with account name from params
    final initialState = AccountSettingsState(
      accountName: params.accountName,
    );

    // Schedule data loading after build
    Future.microtask(() => _loadData());

    return initialState;
  }

  /// Load cash location data
  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      if (params.locationId.isNotEmpty) {
        await _loadByLocationId();
      } else {
        await _loadByName();
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to load data',
        extra: {
          'locationId': params.locationId,
          'accountName': params.accountName,
        },
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load data: ${e.toString()}',
      );
    }
  }

  Future<void> _loadByLocationId() async {
    final useCase = ref.read(getCashLocationByIdUseCaseProvider);
    final location = await useCase(params.locationId);

    if (location == null) {
      // Fallback to loading by name
      await _loadByName();
      return;
    }

    state = state.copyWith(
      isLoading: false,
      location: location,
      accountName: location.locationName,
      note: location.note ?? '',
      description: location.description ?? '',
      bankName: location.bankName ?? '',
      accountNumber: location.accountNumber ?? '',
      isMainAccount: location.isMainLocation,
      // Trade fields
      beneficiaryName: location.beneficiaryName ?? '',
      bankAddress: location.bankAddress ?? '',
      swiftCode: location.swiftCode ?? '',
      bankBranch: location.bankBranch ?? '',
      accountType: location.accountType ?? '',
    );
  }

  Future<void> _loadByName() async {
    final appState = ref.read(appStateProvider);
    final useCase = ref.read(getCashLocationByNameUseCaseProvider);

    final location = await useCase(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen,
      locationName: params.accountName,
    );

    if (location == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      location: location,
      accountName: location.locationName,
      note: location.note ?? '',
      description: location.description ?? '',
      bankName: location.bankName ?? '',
      accountNumber: location.accountNumber ?? '',
      isMainAccount: location.isMainLocation,
      // Trade fields
      beneficiaryName: location.beneficiaryName ?? '',
      bankAddress: location.bankAddress ?? '',
      swiftCode: location.swiftCode ?? '',
      bankBranch: location.bankBranch ?? '',
      accountType: location.accountType ?? '',
    );
  }

  /// Refresh data (for app resume)
  Future<void> refresh() async {
    await _loadData();
  }

  /// Update account name
  Future<bool> updateName(String newName) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(
        UpdateCashLocationParams(
          locationId: params.locationId,
          locationName: newName,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        accountName: newName,
        successMessage: 'Name updated successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update name',
        extra: {'locationId': params.locationId, 'newName': newName},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update name: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update note
  Future<bool> updateNote(String newNote) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(
        UpdateCashLocationParams(
          locationId: params.locationId,
          locationName: state.accountName,
          locationInfo: newNote,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        note: newNote,
        successMessage: 'Note updated successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update note',
        extra: {'locationId': params.locationId},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update note: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update description
  Future<bool> updateDescription(String newDescription) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(
        UpdateCashLocationParams(
          locationId: params.locationId,
          locationName: state.accountName,
          locationInfo: newDescription,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        description: newDescription,
        successMessage: 'Description updated successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update description',
        extra: {'locationId': params.locationId},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update description: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update bank name (local state only, no DB update currently)
  void updateBankName(String newBankName) {
    state = state.copyWith(bankName: newBankName);
  }

  /// Update account number (local state only, no DB update currently)
  void updateAccountNumber(String newAccountNumber) {
    state = state.copyWith(accountNumber: newAccountNumber);
  }

  /// Update beneficiary name
  Future<bool> updateBeneficiaryName(String newBeneficiaryName) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(
        UpdateCashLocationParams(
          locationId: params.locationId,
          locationName: state.accountName,
          beneficiaryName: newBeneficiaryName,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        beneficiaryName: newBeneficiaryName,
        successMessage: 'Beneficiary name updated successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update beneficiary name',
        extra: {'locationId': params.locationId},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update beneficiary name: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update bank address
  Future<bool> updateBankAddress(String newBankAddress) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(
        UpdateCashLocationParams(
          locationId: params.locationId,
          locationName: state.accountName,
          bankAddress: newBankAddress,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        bankAddress: newBankAddress,
        successMessage: 'Bank address updated successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update bank address',
        extra: {'locationId': params.locationId},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update bank address: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update SWIFT code
  Future<bool> updateSwiftCode(String newSwiftCode) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(
        UpdateCashLocationParams(
          locationId: params.locationId,
          locationName: state.accountName,
          swiftCode: newSwiftCode,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        swiftCode: newSwiftCode,
        successMessage: 'SWIFT code updated successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update SWIFT code',
        extra: {'locationId': params.locationId},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update SWIFT code: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update bank branch
  Future<bool> updateBankBranch(String newBankBranch) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(
        UpdateCashLocationParams(
          locationId: params.locationId,
          locationName: state.accountName,
          bankBranch: newBankBranch,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        bankBranch: newBankBranch,
        successMessage: 'Bank branch updated successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update bank branch',
        extra: {'locationId': params.locationId},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update bank branch: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update account type
  Future<bool> updateAccountType(String newAccountType) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(
        UpdateCashLocationParams(
          locationId: params.locationId,
          locationName: state.accountName,
          accountType: newAccountType,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        accountType: newAccountType,
        successMessage: 'Account type updated successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update account type',
        extra: {'locationId': params.locationId},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update account type: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update main account status
  Future<bool> updateMainAccountStatus(bool isMain) async {
    final previousValue = state.isMainAccount;

    // Optimistically update UI
    state = state.copyWith(
      isMainAccount: isMain,
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final appState = ref.read(appStateProvider);
      final useCase = ref.read(updateMainAccountStatusUseCaseProvider);

      await useCase(
        UpdateMainAccountStatusParams(
          locationId: params.locationId,
          isMainAccount: isMain,
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen,
          locationType: params.locationType,
        ),
      );

      // Invalidate cache to refresh the list
      ref.invalidate(allCashLocationsProvider);

      state = state.copyWith(
        isSaving: false,
        successMessage: isMain ? 'Set as main account' : 'Removed as main account',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to update main account status',
        extra: {'locationId': params.locationId, 'isMain': isMain},
      );

      // Revert on failure
      state = state.copyWith(
        isSaving: false,
        isMainAccount: previousValue,
        errorMessage: 'Failed to update main account: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete cash location
  Future<bool> deleteCashLocation() async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);

    try {
      final useCase = ref.read(deleteCashLocationUseCaseProvider);

      await useCase(params.locationId);

      // Invalidate cache to refresh the list
      ref.invalidate(allCashLocationsProvider);

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Account deleted successfully',
      );

      return true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsNotifier: Failed to delete cash location',
        extra: {'locationId': params.locationId},
      );
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to delete account: ${e.toString()}',
      );
      return false;
    }
  }

  /// Clear success message
  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  /// Clear error message
  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null);
  }
}
