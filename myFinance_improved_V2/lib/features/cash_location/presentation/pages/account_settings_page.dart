import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';

import '../providers/account_settings_notifier.dart';
import '../providers/states/account_settings_state.dart';
import '../widgets/sheets/text_edit_sheet.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  final String accountName;
  final String locationType;
  final String locationId;

  const AccountSettingsPage({
    super.key,
    required this.accountName,
    required this.locationType,
    required this.locationId,
  });

  @override
  ConsumerState<AccountSettingsPage> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage>
    with WidgetsBindingObserver {
  late final AccountSettingsParams _params;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _params = AccountSettingsParams(
      locationId: widget.locationId,
      accountName: widget.accountName,
      locationType: widget.locationType,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(accountSettingsNotifierProvider(_params).notifier).refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountSettingsNotifierProvider(_params));

    // Listen for success/error messages
    ref.listen(accountSettingsNotifierProvider(_params), (previous, next) {
      if (next.successMessage != null && previous?.successMessage != next.successMessage) {
        _showSuccessDialog(next.successMessage!);
        ref.read(accountSettingsNotifierProvider(_params).notifier).clearSuccessMessage();
      }
      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        _showErrorDialog(next.errorMessage!);
        ref.read(accountSettingsNotifierProvider(_params).notifier).clearErrorMessage();
      }
    });

    return TossScaffold(
      appBar: const TossAppBar1(
        title: 'Account Settings',
        backgroundColor: TossColors.gray50,
      ),
      backgroundColor: TossColors.gray50,
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: TossLoadingView())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildAccountInfo(state.accountName),
                          const SizedBox(height: TossSpacing.space4),
                          _buildSettingsOptions(state),
                          const SizedBox(height: TossSpacing.space4),
                          _buildDeleteSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAccountInfo(String accountName) {
    return Container(
      margin: const EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space4,
      ),
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              accountName,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            '${_getAccountTypeText()} Account',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(AccountSettingsState state) {
    final notifier = ref.read(accountSettingsNotifierProvider(_params).notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space5,
        TossSpacing.space4,
        TossSpacing.space5,
        TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          // Name field
          _buildInputField(
            'Name',
            state.accountName,
            isFirst: true,
            onTap: () => _showNameEditBottomSheet(state.accountName),
          ),

          // Bank-specific fields
          if (widget.locationType == 'bank') ...[
            _buildInputField(
              'Bank Name',
              state.bankName,
              onTap: () => _showBankNameEditBottomSheet(state.bankName),
            ),
            _buildInputField(
              'Account Number',
              state.accountNumber,
              onTap: () => _showAccountNumberEditBottomSheet(state.accountNumber),
            ),
          ],

          // Description/Note field
          if (widget.locationType != 'bank')
            _buildInputField(
              'Description',
              state.description,
              hintText: 'Add description',
              onTap: () => _showDescriptionEditBottomSheet(state.description),
            )
          else
            _buildInputField(
              'Note',
              state.note,
              hintText: 'Add note',
              onTap: () => _showNoteEditBottomSheet(state.note),
            ),

          // Main Account switch
          Container(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              children: [
                Text(
                  'Main Account',
                  style: TossTextStyles.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: TossColors.gray700,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: state.isMainAccount,
                  onChanged: state.isSaving
                      ? null
                      : (value) => notifier.updateMainAccountStatus(value),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String value, {
    String? hintText,
    bool isFirst = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
        child: Row(
          children: [
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: TossColors.gray700,
              ),
            ),
            const Spacer(),
            Text(
              value.isEmpty ? (hintText ?? '') : value,
              style: TossTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: value.isEmpty ? FontWeight.w400 : FontWeight.w600,
                color: value.isEmpty ? TossColors.gray400 : TossColors.gray800,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: GestureDetector(
        onTap: _showDeleteConfirmation,
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.card,
          ),
          child: Center(
            child: Text(
              'Delete Account',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bottom sheet methods
  void _showNameEditBottomSheet(String currentName) {
    _showEditBottomSheet(
      title: 'Change account name',
      initialText: currentName,
      onSave: (newName) async {
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateName(newName);
        return success;
      },
    );
  }

  void _showNoteEditBottomSheet(String currentNote) {
    _showEditBottomSheet(
      title: 'Add note',
      initialText: currentNote,
      hintText: 'Add note...',
      multiline: true,
      onSave: (newNote) async {
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateNote(newNote);
        return success;
      },
    );
  }

  void _showDescriptionEditBottomSheet(String currentDescription) {
    _showEditBottomSheet(
      title: 'Edit description',
      initialText: currentDescription,
      multiline: true,
      onSave: (newDescription) async {
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateDescription(newDescription);
        return success;
      },
    );
  }

  void _showBankNameEditBottomSheet(String currentBankName) {
    _showEditBottomSheet(
      title: 'Change bank name',
      initialText: currentBankName,
      onSave: (newBankName) async {
        ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateBankName(newBankName);
        return true;
      },
    );
  }

  void _showAccountNumberEditBottomSheet(String currentAccountNumber) {
    _showEditBottomSheet(
      title: 'Change account number',
      initialText: currentAccountNumber,
      keyboardType: TextInputType.number,
      onSave: (newAccountNumber) async {
        ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateAccountNumber(newAccountNumber);
        return true;
      },
    );
  }

  Future<void> _showEditBottomSheet({
    required String title,
    required String initialText,
    String? hintText,
    bool multiline = false,
    TextInputType? keyboardType,
    required Future<bool> Function(String) onSave,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext modalContext) {
        return TextEditSheet(
          title: title,
          initialText: initialText,
          hintText: hintText,
          multiline: multiline,
          keyboardType: keyboardType,
          onSave: (String newValue) async {
            Navigator.of(modalContext).pop();
            await onSave(newValue);
          },
          onCancel: () => Navigator.of(modalContext).pop(),
        );
      },
    );
  }

  void _showDeleteConfirmation() async {
    final rootContext = context;

    final confirmed = await TossConfirmCancelDialog.showDelete(
      context: rootContext,
      title: 'Delete Account',
      message:
          'Are you sure you want to delete this account? This action cannot be undone.',
      confirmButtonText: 'Delete',
      cancelButtonText: 'Cancel',
    );

    if (confirmed == true) {
      if (!mounted) return;

      // Show loading indicator
      showDialog(
        context: rootContext,
        barrierDismissible: false,
        builder: (BuildContext loadingContext) {
          return PopScope(
            canPop: false,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space5),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TossLoadingView(),
                    const SizedBox(height: TossSpacing.space4),
                    Text(
                      'Deleting...',
                      style: TossTextStyles.body.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      // Delete using notifier
      final success = await ref
          .read(accountSettingsNotifierProvider(_params).notifier)
          .deleteCashLocation();

      if (!mounted) return;

      // Close loading dialog
      Navigator.of(rootContext).pop();

      if (success) {
        // Show success message
        if (mounted) {
          await showDialog(
            context: rootContext,
            barrierDismissible: false,
            builder: (context) => TossDialog.success(
              title: 'Account Deleted',
              message: 'Account deleted successfully',
              primaryButtonText: 'OK',
            ),
          );
        }

        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          context.go('/cashLocation');
        }
      }
    }
  }

  // Helper methods
  String _getAccountTypeText() {
    switch (widget.locationType) {
      case 'bank':
        return 'Bank';
      case 'vault':
        return 'Vault';
      case 'cash':
      default:
        return 'Cash';
    }
  }

  void _showSuccessDialog(String message) async {
    // Don't show dialog for certain messages that are handled elsewhere
    if (message == 'Account deleted successfully') return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.success(
        title: 'Updated',
        message: message,
        primaryButtonText: 'OK',
        onPrimaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.error(
        title: 'Error',
        message: message,
        primaryButtonText: 'OK',
        onPrimaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
