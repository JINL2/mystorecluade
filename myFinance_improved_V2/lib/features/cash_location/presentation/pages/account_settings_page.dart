import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/features/cash_location/presentation/providers/cash_location_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_confirm_cancel_dialog.dart';

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
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule refresh after build to avoid showSnackBar during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }
  
  Future<void> _refreshData() async {
    if (widget.locationId.isNotEmpty) {
      await _loadCashLocationData();
    } else {
      await _loadCashLocationDataByName();
    }
  }
  
  Future<void> _loadCashLocationData() async {
    try {
      final repository = ref.read(cashLocationRepositoryProvider);
      final location = await repository.getCashLocationById(
        locationId: widget.locationId,
      );

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
    } catch (e) {
      // If fails, try loading by name
      _loadCashLocationDataByName();
    }
  }
  
  Future<void> _loadCashLocationDataByName() async {
    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(cashLocationRepositoryProvider);

      final location = await repository.getCashLocationByName(
        locationName: widget.accountName,
        locationType: widget.locationType,
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
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
    } catch (e) {
      // Silent fail - location not found
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
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: TossAppBar1(
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
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    // Settings Options
                    _buildSettingsOptions(),
                    
                    SizedBox(height: TossSpacing.space4),
                    
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
      margin: EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space4,
      ),
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Name (like Balance/Accounts heading)
          Container(
            width: double.infinity,
            child: Text(
              _currentAccountName,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
          
          SizedBox(height: TossSpacing.space2),
          
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
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      padding: EdgeInsets.fromLTRB(
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
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
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
        padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
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
            SizedBox(width: TossSpacing.space2),
            Icon(
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
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: GestureDetector(
        onTap: () {
          // Show delete confirmation dialog
          _showDeleteConfirmation();
        },
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space5),
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
    final initialText = _nameController.text;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext modalContext) {
        return _SimpleNameEditSheet(
          initialName: initialText,
          onSave: (String newName) async {
            // Close the modal first
            Navigator.of(modalContext).pop();
            // Update database
            await _updateCashLocationName(newName);
            // Then update the parent state
            if (mounted) {
              setState(() {
                _currentAccountName = newName;
                _nameController.text = newName;
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
  
  void _showNoteEditBottomSheet() {
    final initialText = _noteController.text;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext modalContext) {
        return _SimpleNoteEditSheet(
          initialNote: initialText,
          onSave: (String newNote) async {
            // Close the modal first
            Navigator.of(modalContext).pop();
            // Update database
            await _updateCashLocationNote(newNote);
            // Then update the parent state
            if (mounted) {
              setState(() {
                _noteController.text = newNote;
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
  
  void _showDescriptionEditBottomSheet() {
    final initialText = _descriptionController.text;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext modalContext) {
        return _SimpleNoteEditSheet(
          initialNote: initialText,
          onSave: (String newDescription) async {
            // Close the modal first
            Navigator.of(modalContext).pop();
            // Update database
            await _updateCashLocationDescription(newDescription);
            // Then update the parent state
            if (mounted) {
              setState(() {
                _descriptionController.text = newDescription;
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
  
  void _showBankNameEditBottomSheet() {
    final initialText = _bankNameController.text;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext modalContext) {
        return _SimpleNameEditSheet(
          initialName: initialText,
          onSave: (String newBankName) {
            // Close the modal first
            Navigator.of(modalContext).pop();
            // Then update the parent state
            if (mounted) {
              setState(() {
                _bankNameController.text = newBankName;
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
  
  void _showAccountNumberEditBottomSheet() {
    final initialText = _accountNumberController.text;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext modalContext) {
        return _SimpleNameEditSheet(
          initialName: initialText,
          onSave: (String newAccountNumber) {
            // Close the modal first
            Navigator.of(modalContext).pop();
            // Then update the parent state
            if (mounted) {
              setState(() {
                _accountNumberController.text = newAccountNumber;
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
                padding: EdgeInsets.all(TossSpacing.space5),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TossLoadingView(),
                    SizedBox(height: TossSpacing.space4),
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
        // Note: Provider invalidation temporarily disabled - needs proper setup
        // final appState = ref.read(appStateProvider);
        // ref.invalidate(allCashLocationsProvider(...));

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
      final repository = ref.read(cashLocationRepositoryProvider);

      await repository.updateCashLocation(
        locationId: widget.locationId,
        name: newName,
      );

      // Update the current name after successful DB update
      _currentAccountName = newName;

      // Invalidate cache to refresh the list
      // TODO: Fix provider invalidation after proper setup
      // ref.invalidate(allCashLocationsProvider(...));

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Name Updated',
            message: 'Account name updated successfully',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update name: ${e.toString()}',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
  
  Future<void> _updateCashLocationNote(String newNote) async {
    try {
      final repository = ref.read(cashLocationRepositoryProvider);

      await repository.updateCashLocation(
        locationId: widget.locationId,
        name: _currentAccountName,
        note: newNote,
      );

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Note Updated',
            message: 'Note updated successfully',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update note: ${e.toString()}',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
  
  Future<void> _updateCashLocationDescription(String newDescription) async {
    try {
      final repository = ref.read(cashLocationRepositoryProvider);

      await repository.updateCashLocation(
        locationId: widget.locationId,
        name: _currentAccountName,
        description: newDescription,
      );

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Description Updated',
            message: 'Description updated successfully',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update description: ${e.toString()}',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
  
  Future<void> _updateMainAccountStatus(bool isMain) async {
    try {
      final repository = ref.read(cashLocationRepositoryProvider);
      final appState = ref.read(appStateProvider);

      await repository.updateMainAccountStatus(
        locationId: widget.locationId,
        isMain: isMain,
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
        locationType: widget.locationType,
      );

      // Invalidate cache to refresh the list
      // TODO: Fix provider invalidation after proper setup
      // ref.invalidate(allCashLocationsProvider(...));

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
    } catch (e) {
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
      final repository = ref.read(cashLocationRepositoryProvider);

      await repository.deleteCashLocation(widget.locationId);

      // Don't show success message here, it will be shown after dialog closes
      return true; // Return success
    } catch (e) {
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

class _SimpleNameEditSheet extends StatelessWidget {
  final String initialName;
  final Function(String) onSave;
  final VoidCallback onCancel;
  
  const _SimpleNameEditSheet({
    required this.initialName,
    required this.onSave,
    required this.onCancel,
  });
  
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialName);
    final focusNode = FocusNode();
    
    
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header and Content
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: TossSpacing.space2),
                    
                    Text(
                      'Change account name',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // Input field with underline
                    TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => onSave(controller.text),
                      style: TossTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray800,
                      ),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(
                          bottom: TossSpacing.space2,
                          top: TossSpacing.space1,
                        ),
                        fillColor: TossColors.transparent,
                        filled: false,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: TossColors.gray400,
                            size: 20,
                          ),
                          onPressed: () {
                            controller.clear();
                          },
                        ),
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // Bottom button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => onSave(controller.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleNoteEditSheet extends StatelessWidget {
  final String initialNote;
  final Function(String) onSave;
  final VoidCallback onCancel;
  
  const _SimpleNoteEditSheet({
    required this.initialNote,
    required this.onSave,
    required this.onCancel,
  });
  
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialNote);
    final focusNode = FocusNode();
    
    
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header and Content
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: TossSpacing.space2),
                    
                    Text(
                      'Add note',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // Multi-line input field with underline
                    TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 4,
                      minLines: 4,
                      style: TossTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray800,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(
                          bottom: TossSpacing.space2,
                          top: TossSpacing.space1,
                        ),
                        fillColor: TossColors.transparent,
                        filled: false,
                        hintText: 'Add note...',
                        hintStyle: TossTextStyles.body.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: TossColors.gray400,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // Bottom button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => onSave(controller.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
