import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../providers/account_settings_notifier.dart';
import '../providers/states/account_settings_state.dart';
import '../widgets/sheets/text_edit_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

  // Trade info section expanded state
  bool _isTradeInfoExpanded = false;

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
      appBar: const TossAppBar(
        title: 'Account Settings',
        backgroundColor: TossColors.white,
      ),
      backgroundColor: TossColors.white,
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
                          // Trade info section (only for bank accounts)
                          if (widget.locationType == 'bank') ...[
                            const SizedBox(height: TossSpacing.space4),
                            _buildTradeInfoSection(state),
                          ],
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
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              accountName,
              style: TossTextStyles.titleLarge,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            '${_getAccountTypeText()} Account',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
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
        border: Border.all(color: TossColors.gray200),
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
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: TossFontWeight.regular,
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
              style: TossTextStyles.h4.copyWith(
                fontWeight: TossFontWeight.regular,
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Text(
                value.isEmpty ? (hintText ?? '') : value,
                style: TossTextStyles.h4.copyWith(
                  fontWeight: value.isEmpty ? TossFontWeight.regular : TossFontWeight.semibold,
                  color: value.isEmpty ? TossColors.gray400 : TossColors.gray800,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconMD,
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
            border: Border.all(color: TossColors.gray200),
          ),
          child: Center(
            child: Text(
              'Delete Account',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.error,
                fontWeight: TossFontWeight.medium,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Expandable trade/international banking info section
  Widget _buildTradeInfoSection(AccountSettingsState state) {
    // Check if any trade field has data
    final hasTradeData = state.beneficiaryName.isNotEmpty ||
        state.bankAddress.isNotEmpty ||
        state.swiftCode.isNotEmpty ||
        state.bankBranch.isNotEmpty ||
        state.accountType.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          // Header (clickable to expand/collapse)
          InkWell(
            onTap: () {
              setState(() {
                _isTradeInfoExpanded = !_isTradeInfoExpanded;
              });
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  Icon(
                    Icons.public,
                    size: TossSpacing.iconMD,
                    color: hasTradeData
                        ? Theme.of(context).colorScheme.primary
                        : TossColors.gray600,
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'International Banking Info',
                          style: TossTextStyles.h4.copyWith(
                            color: TossColors.black87,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space0),
                        Text(
                          hasTradeData
                              ? 'Tap to view/edit'
                              : 'For international trade & wire transfers',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isTradeInfoExpanded ? 0.5 : 0,
                    duration: TossAnimations.normal,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: TossColors.gray400,
                      size: TossSpacing.iconMD2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildTradeInfoFields(state),
            crossFadeState: _isTradeInfoExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: TossAnimations.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildTradeInfoFields(AccountSettingsState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space5,
        0,
        TossSpacing.space5,
        TossSpacing.space4,
      ),
      child: Column(
        children: [
          const Divider(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space2),

          // Beneficiary Name
          _buildInputField(
            'Beneficiary Name',
            state.beneficiaryName,
            hintText: 'Add beneficiary',
            onTap: () => _showBeneficiaryNameEditBottomSheet(state.beneficiaryName),
          ),

          // SWIFT Code
          _buildInputField(
            'SWIFT / BIC Code',
            state.swiftCode,
            hintText: 'Add SWIFT code',
            onTap: () => _showSwiftCodeEditBottomSheet(state.swiftCode),
          ),

          // Bank Branch
          _buildInputField(
            'Bank Branch',
            state.bankBranch,
            hintText: 'Add branch',
            onTap: () => _showBankBranchEditBottomSheet(state.bankBranch),
          ),

          // Bank Address
          _buildInputField(
            'Bank Address',
            state.bankAddress,
            hintText: 'Add address',
            onTap: () => _showBankAddressEditBottomSheet(state.bankAddress),
          ),

          // Account Type
          _buildInputField(
            'Account Type',
            state.accountType,
            hintText: 'Select type',
            onTap: () => _showAccountTypeSelector(state.accountType),
          ),
        ],
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
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateBankName(newBankName);
        return success;
      },
    );
  }

  void _showAccountNumberEditBottomSheet(String currentAccountNumber) {
    _showEditBottomSheet(
      title: 'Change account number',
      initialText: currentAccountNumber,
      keyboardType: TextInputType.number,
      onSave: (newAccountNumber) async {
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateAccountNumber(newAccountNumber);
        return success;
      },
    );
  }

  // Trade info bottom sheet methods
  void _showBeneficiaryNameEditBottomSheet(String currentValue) {
    _showEditBottomSheet(
      title: 'Edit beneficiary name',
      initialText: currentValue,
      hintText: 'Enter beneficiary name',
      onSave: (newValue) async {
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateBeneficiaryName(newValue);
        return success;
      },
    );
  }

  void _showSwiftCodeEditBottomSheet(String currentValue) {
    _showEditBottomSheet(
      title: 'Edit SWIFT/BIC code',
      initialText: currentValue,
      hintText: 'e.g., BKCHKHHH',
      onSave: (newValue) async {
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateSwiftCode(newValue.toUpperCase());
        return success;
      },
    );
  }

  void _showBankBranchEditBottomSheet(String currentValue) {
    _showEditBottomSheet(
      title: 'Edit bank branch',
      initialText: currentValue,
      hintText: 'Enter bank branch',
      onSave: (newValue) async {
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateBankBranch(newValue);
        return success;
      },
    );
  }

  void _showBankAddressEditBottomSheet(String currentValue) {
    _showEditBottomSheet(
      title: 'Edit bank address',
      initialText: currentValue,
      hintText: 'Enter bank address',
      multiline: true,
      onSave: (newValue) async {
        final success = await ref
            .read(accountSettingsNotifierProvider(_params).notifier)
            .updateBankAddress(newValue);
        return success;
      },
    );
  }

  void _showAccountTypeSelector(String currentValue) {
    final accountTypes = ['Savings', 'Checking', 'Current', 'Business'];

    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (BuildContext modalContext) {
        return Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.xl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Account Type',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: TossFontWeight.bold,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              ...accountTypes.map((type) {
                final isSelected = currentValue == type;
                return ListTile(
                  title: Text(
                    type,
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : TossColors.gray800,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () async {
                    Navigator.of(modalContext).pop();
                    await ref
                        .read(accountSettingsNotifierProvider(_params).notifier)
                        .updateAccountType(type);
                  },
                );
              }),
              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        );
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
                      style: TossTextStyles.body,
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

        await Future.delayed(TossAnimations.slow);

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
