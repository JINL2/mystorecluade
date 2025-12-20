import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/monitoring/sentry_config.dart';
import 'package:myfinance_improved/features/cash_location/presentation/providers/cash_location_providers.dart';
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
  ConsumerState<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage>
    with WidgetsBindingObserver {
  bool _isMainAccount = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  String _currentAccountName = '';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentAccountName = widget.accountName;
    _nameController.text = widget.accountName;
    // Schedule data refresh after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data when app returns to foreground
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }
  
  // Note: Removed didChangeDependencies override that was causing excessive rebuilds.
  // The method was calling _refreshData() on every dependency change,
  // which could cause UI flickering and AppBar disappearing issues.
  // Data refresh is already handled by:
  // - initState (initial load)
  // - didChangeAppLifecycleState (app resume)
  
  Future<void> _refreshData() async {
    if (widget.locationId.isNotEmpty) {
      await _loadCashLocationData();
    } else {
      await _loadCashLocationDataByName();
    }
  }
  
  Future<void> _loadCashLocationData() async {
    try {
      final useCase = ref.read(getCashLocationByIdUseCaseProvider);
      final location = await useCase(widget.locationId);

      if (location == null) {
        // If not found by ID, try loading by name
        _loadCashLocationDataByName();
        return;
      }

      if (mounted) {
        setState(() {
          _currentAccountName = location.locationName;
          _nameController.text = _currentAccountName;
          _noteController.text = location.note ?? '';
          _isMainAccount = location.isMainLocation;

          if (widget.locationType == 'bank') {
            _bankNameController.text = location.bankName ?? '';
            _accountNumberController.text = location.accountNumber ?? '';
          } else {
            // For cash/vault, load description
            _descriptionController.text = location.description ?? '';
          }
        });
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsPage: Failed to load cash location by ID',
        extra: {'locationId': widget.locationId},
      );
      // If fails, try loading by name
      _loadCashLocationDataByName();
    }
  }

  Future<void> _loadCashLocationDataByName() async {
    try {
      final appState = ref.read(appStateProvider);
      final useCase = ref.read(getCashLocationByNameUseCaseProvider);

      final location = await useCase(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
        locationName: widget.accountName,
      );

      if (location == null) return;

      if (mounted) {
        setState(() {
          _currentAccountName = location.locationName;
          _nameController.text = _currentAccountName;
          _noteController.text = location.note ?? '';
          _isMainAccount = location.isMainLocation;

          if (widget.locationType == 'bank') {
            _bankNameController.text = location.bankName ?? '';
            _accountNumberController.text = location.accountNumber ?? '';
          } else {
            // For cash/vault, load description
            _descriptionController.text = location.description ?? '';
          }
        });
      }
    } catch (e, stackTrace) {
      // Log but don't show error to user
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsPage: Failed to load cash location by name',
        extra: {'accountName': widget.accountName, 'locationType': widget.locationType},
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nameController.dispose();
    _noteController.dispose();
    _descriptionController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  // Generic helper method for showing edit bottom sheets
  Future<void> _showEditBottomSheet({
    required String title,
    required TextEditingController controller,
    String? hintText,
    bool multiline = false,
    TextInputType? keyboardType,
    Future<void> Function(String)? onUpdate,
  }) async {
    final initialText = controller.text;

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

            // Call update method if provided
            if (onUpdate != null) {
              await onUpdate(newValue);
            }

            // Update controller if mounted
            if (mounted) {
              setState(() {
                controller.text = newValue;
              });
            }
          },
          onCancel: () {
            Navigator.of(modalContext).pop();
          },
        );
      },
    );
  }

  // Generic helper method for showing update dialogs
  Future<void> _showUpdateDialog({
    required bool success,
    required String title,
    required String message,
  }) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (success) {
          return TossDialog.success(
            title: title,
            message: message,
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          );
        } else {
          return TossDialog.error(
            title: title,
            message: message,
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: const TossAppBar1(
        title: 'Account Settings',
        backgroundColor: TossColors.gray50,
      ),
      backgroundColor: TossColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Account Info
                    _buildAccountInfo(),
                    
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Settings Options
                    _buildSettingsOptions(),
                    
                    const SizedBox(height: TossSpacing.space4),
                    
                    // Delete Account Button
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
  
  // Removed _buildHeader method - now using TossAppBar
  
  Widget _buildAccountInfo() {
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
          // Account Name (like Balance/Accounts heading)
          SizedBox(
            width: double.infinity,
            child: Text(
              _currentAccountName,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
          
          const SizedBox(height: TossSpacing.space2),
          
          // Account Location (like "65% of total balance")
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
  
  Widget _buildSettingsOptions() {
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
            _nameController,
            isFirst: true,
            onTap: () {
              _showNameEditBottomSheet();
            },
          ),
          
          // Bank-specific fields (only show for bank accounts)
          if (widget.locationType == 'bank') ...[
            // Bank Name field
            _buildInputField(
              'Bank Name',
              _bankNameController,
              onTap: () {
                _showBankNameEditBottomSheet();
              },
            ),
            
            // Account Number field
            _buildInputField(
              'Account Number',
              _accountNumberController,
              onTap: () {
                _showAccountNumberEditBottomSheet();
              },
            ),
          ],
          
          // Description field for cash/vault, Note field for bank
          if (widget.locationType != 'bank')
            _buildInputField(
              'Description',
              _descriptionController,
              hintText: 'Add description',
              onTap: () {
                _showDescriptionEditBottomSheet();
              },
            )
          else
            _buildInputField(
              'Note',
              _noteController,
              hintText: 'Add note',
              onTap: () {
                _showNoteEditBottomSheet();
              },
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
                  value: _isMainAccount,
                  onChanged: (value) async {
                    setState(() {
                      _isMainAccount = value;
                    });
                    await _updateMainAccountStatus(value);
                  },
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
    TextEditingController controller, {
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
            // Label - lighter weight for secondary information
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: TossColors.gray700,
              ),
            ),
            
            // Spacer
            const Spacer(),
            
            // Value - bolder weight for primary content
            Text(
              controller.text.isEmpty ? (hintText ?? '') : controller.text,
              style: TossTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: controller.text.isEmpty ? FontWeight.w400 : FontWeight.w600,
                color: controller.text.isEmpty ? TossColors.gray400 : TossColors.gray800,
              ),
            ),
            
            // Arrow
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
        onTap: () {
          // Show delete confirmation dialog
          _showDeleteConfirmation();
        },
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
  
  void _showNameEditBottomSheet() {
    _showEditBottomSheet(
      title: 'Change account name',
      controller: _nameController,
      onUpdate: (newName) async {
        await _updateCashLocationName(newName);
        if (mounted) {
          setState(() {
            _currentAccountName = newName;
          });
        }
      },
    );
  }
  
  void _showNoteEditBottomSheet() {
    _showEditBottomSheet(
      title: 'Add note',
      controller: _noteController,
      hintText: 'Add note...',
      multiline: true,
      onUpdate: (newNote) => _updateCashLocationNote(newNote),
    );
  }
  
  void _showDescriptionEditBottomSheet() {
    _showEditBottomSheet(
      title: 'Edit description',
      controller: _descriptionController,
      multiline: true,
      onUpdate: (newDescription) => _updateCashLocationDescription(newDescription),
    );
  }

  void _showBankNameEditBottomSheet() {
    _showEditBottomSheet(
      title: 'Change bank name',
      controller: _bankNameController,
    );
  }

  void _showAccountNumberEditBottomSheet() {
    _showEditBottomSheet(
      title: 'Change account number',
      controller: _accountNumberController,
      keyboardType: TextInputType.number,
    );
  }
  
  void _showDeleteConfirmation() async {
    // Save the main widget's context before showing any dialogs
    final rootContext = context;

    // Show confirm/cancel dialog
    final confirmed = await TossConfirmCancelDialog.showDelete(
      context: rootContext,
      title: 'Delete Account',
      message: 'Are you sure you want to delete this account? This action cannot be undone.',
      confirmButtonText: 'Delete',
      cancelButtonText: 'Cancel',
    );

    // If user confirmed deletion
    if (confirmed == true) {
      // Check if the widget is still mounted before proceeding
      if (!mounted) return;

      // Show loading indicator using the root context
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
                      style: TossTextStyles.body.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      // Delete the cash location
      final success = await _deleteCashLocation();

      // Check if still mounted before any navigation
      if (!mounted) return;

      // Close the loading dialog using the root navigator
      Navigator.of(rootContext).pop();

      if (success) {
        // Invalidate cache to refresh the list
        ref.invalidate(allCashLocationsProvider);

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

        // Add a small delay for the success message to show
        await Future.delayed(const Duration(milliseconds: 300));

        // Navigate back to Cash Location list page
        // Check if still mounted after the delay
        if (mounted) {
          // Use GoRouter for safer navigation back to cash location page
          // This will replace the current navigation stack
          context.go('/cashLocation');
        }
      } else {
        // Show error message if deletion failed
        if (mounted) {
          await showDialog(
            context: rootContext,
            barrierDismissible: false,
            builder: (context) => TossDialog.error(
              title: 'Delete Failed',
              message: 'Failed to delete account',
              primaryButtonText: 'OK',
            ),
          );
        }
      }
    }
  }
  
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
  
  Future<void> _updateCashLocationName(String newName) async {
    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(UpdateCashLocationParams(
        locationId: widget.locationId,
        locationName: newName,
      ));

      // Update the current name after successful DB update
      _currentAccountName = newName;

      await _showUpdateDialog(
        success: true,
        title: 'Name Updated',
        message: 'Account name updated successfully',
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsPage: Failed to update name',
        extra: {'locationId': widget.locationId, 'newName': newName},
      );
      await _showUpdateDialog(
        success: false,
        title: 'Update Failed',
        message: 'Failed to update name: ${e.toString()}',
      );
    }
  }

  Future<void> _updateCashLocationNote(String newNote) async {
    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(UpdateCashLocationParams(
        locationId: widget.locationId,
        locationName: _currentAccountName,
        locationInfo: newNote,
      ));

      await _showUpdateDialog(
        success: true,
        title: 'Note Updated',
        message: 'Note updated successfully',
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsPage: Failed to update note',
        extra: {'locationId': widget.locationId},
      );
      await _showUpdateDialog(
        success: false,
        title: 'Update Failed',
        message: 'Failed to update note: ${e.toString()}',
      );
    }
  }

  Future<void> _updateCashLocationDescription(String newDescription) async {
    try {
      final useCase = ref.read(updateCashLocationUseCaseProvider);

      await useCase(UpdateCashLocationParams(
        locationId: widget.locationId,
        locationName: _currentAccountName,
        locationInfo: newDescription,
      ));

      await _showUpdateDialog(
        success: true,
        title: 'Description Updated',
        message: 'Description updated successfully',
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsPage: Failed to update description',
        extra: {'locationId': widget.locationId},
      );
      await _showUpdateDialog(
        success: false,
        title: 'Update Failed',
        message: 'Failed to update description: ${e.toString()}',
      );
    }
  }

  Future<void> _updateMainAccountStatus(bool isMain) async {
    try {
      final appState = ref.read(appStateProvider);
      final useCase = ref.read(updateMainAccountStatusUseCaseProvider);

      await useCase(UpdateMainAccountStatusParams(
        locationId: widget.locationId,
        isMainAccount: isMain,
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
        locationType: widget.locationType,
      ));

      // Invalidate cache to refresh the list
      ref.invalidate(allCashLocationsProvider);

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Account Updated',
            message: isMain ? 'Set as main account' : 'Removed as main account',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsPage: Failed to update main account status',
        extra: {'locationId': widget.locationId, 'isMain': isMain},
      );
      // Revert the state if update failed
      if (mounted) {
        setState(() {
          _isMainAccount = !isMain;
        });
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update main account: ${e.toString()}',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }

  Future<bool> _deleteCashLocation() async {
    try {
      final useCase = ref.read(deleteCashLocationUseCaseProvider);

      await useCase(widget.locationId);

      // Don't show success message here, it will be shown after dialog closes
      return true; // Return success
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'AccountSettingsPage: Failed to delete cash location',
        extra: {'locationId': widget.locationId},
      );
      // Show error message only on failure
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.error(
            title: 'Delete Failed',
            message: 'Failed to delete account: ${e.toString()}',
            primaryButtonText: 'OK',
          ),
        );
      }
      return false; // Return failure
    }
  }
}
