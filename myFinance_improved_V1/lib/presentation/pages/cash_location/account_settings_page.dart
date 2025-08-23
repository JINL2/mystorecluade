import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../../data/services/cash_location_service.dart';
import '../../widgets/common/toss_scaffold.dart';

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

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  bool _isMainAccount = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final _supabase = Supabase.instance.client;
  String _currentAccountName = '';
  
  @override
  void initState() {
    super.initState();
    _currentAccountName = widget.accountName;
    _nameController.text = widget.accountName;
    if (widget.locationId.isNotEmpty) {
      _loadCashLocationData();
    } else {
      _loadCashLocationDataByName();
    }
  }
  
  Future<void> _loadCashLocationData() async {
    try {
      final response = await _supabase
          .from('cash_locations')
          .select('*')
          .eq('cash_location_id', widget.locationId)
          .single();
      
      if (mounted) {
        setState(() {
          _currentAccountName = response['location_name'] ?? widget.accountName;
          _nameController.text = _currentAccountName;
          _noteController.text = response['note'] ?? '';
          _isMainAccount = response['main_cash_location'] ?? false;
          
          if (widget.locationType == 'bank') {
            _bankNameController.text = response['bank_name'] ?? '';
            _accountNumberController.text = response['bank_account'] ?? '';
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
      final response = await _supabase
          .from('cash_locations')
          .select('*')
          .eq('location_name', widget.accountName)
          .eq('location_type', widget.locationType)
          .eq('company_id', appState.companyChoosen)
          .eq('store_id', appState.storeChoosen)
          .single();
      
      if (mounted) {
        setState(() {
          _currentAccountName = response['location_name'] ?? widget.accountName;
          _nameController.text = _currentAccountName;
          _noteController.text = response['note'] ?? '';
          _isMainAccount = response['main_cash_location'] ?? false;
          
          if (widget.locationType == 'bank') {
            _bankNameController.text = response['bank_name'] ?? '';
            _accountNumberController.text = response['bank_account'] ?? '';
          }
        });
      }
    } catch (e) {
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
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
  
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Account Settings',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Spacer to balance the layout
          const SizedBox(width: 48),
        ],
      ),
    );
  }
  
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
          
          // Note field
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
                color: const Color(0xFFE53935),
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
  
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this account? This action cannot be undone.',
            style: TossTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteCashLocation();
                if (mounted) {
                  // Invalidate cache to refresh the list
                  ref.invalidate(allCashLocationsProvider);
                  Navigator.of(context).pop(); // Go back to previous screen
                }
              },
              child: Text(
                'Delete',
                style: TossTextStyles.body.copyWith(
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
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
      if (widget.locationId.isNotEmpty) {
        // Update using locationId
        await _supabase
            .from('cash_locations')
            .update({'location_name': newName})
            .eq('cash_location_id', widget.locationId);
      } else {
        // Fallback: Update using name and other identifying fields
        final appState = ref.read(appStateProvider);
        await _supabase
            .from('cash_locations')
            .update({'location_name': newName})
            .eq('location_name', _currentAccountName)
            .eq('location_type', widget.locationType)
            .eq('company_id', appState.companyChoosen)
            .eq('store_id', appState.storeChoosen);
      }
      
      // Update the current name after successful DB update
      _currentAccountName = newName;
      
      // Invalidate cache to refresh the list
      ref.invalidate(allCashLocationsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account name updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update name: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
  
  Future<void> _updateCashLocationNote(String newNote) async {
    try {
      if (widget.locationId.isNotEmpty) {
        await _supabase
            .from('cash_locations')
            .update({'note': newNote})
            .eq('cash_location_id', widget.locationId);
      } else {
        // Fallback: Update using name and other identifying fields
        final appState = ref.read(appStateProvider);
        await _supabase
            .from('cash_locations')
            .update({'note': newNote})
            .eq('location_name', _currentAccountName)
            .eq('location_type', widget.locationType)
            .eq('company_id', appState.companyChoosen)
            .eq('store_id', appState.storeChoosen);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update note: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
  
  Future<void> _updateMainAccountStatus(bool isMain) async {
    try {
      // If setting as main, first unset any existing main account
      if (isMain) {
        final appState = ref.read(appStateProvider);
        final companyId = appState.companyChoosen;
        final storeId = appState.storeChoosen;
        
        // Unset all main accounts for this location type
        await _supabase
            .from('cash_locations')
            .update({'main_cash_location': false})
            .eq('company_id', companyId)
            .eq('store_id', storeId)
            .eq('location_type', widget.locationType);
      }
      
      // Update the current account
      if (widget.locationId.isNotEmpty) {
        await _supabase
            .from('cash_locations')
            .update({'main_cash_location': isMain})
            .eq('cash_location_id', widget.locationId);
      } else {
        // Fallback: Update using name and other identifying fields
        final appState = ref.read(appStateProvider);
        await _supabase
            .from('cash_locations')
            .update({'main_cash_location': isMain})
            .eq('location_name', _currentAccountName)
            .eq('location_type', widget.locationType)
            .eq('company_id', appState.companyChoosen)
            .eq('store_id', appState.storeChoosen);
      }
      
      // Invalidate cache to refresh the list
      ref.invalidate(allCashLocationsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isMain ? 'Set as main account' : 'Removed as main account'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      // Revert the state if update failed
      if (mounted) {
        setState(() {
          _isMainAccount = !isMain;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update main account: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
  
  Future<void> _deleteCashLocation() async {
    try {
      // Soft delete by setting deleted_at timestamp
      if (widget.locationId.isNotEmpty) {
        await _supabase
            .from('cash_locations')
            .update({'deleted_at': DateTime.now().toIso8601String()})
            .eq('cash_location_id', widget.locationId);
      } else {
        // Fallback: Delete using name and other identifying fields
        final appState = ref.read(appStateProvider);
        await _supabase
            .from('cash_locations')
            .update({'deleted_at': DateTime.now().toIso8601String()})
            .eq('location_name', _currentAccountName)
            .eq('location_type', widget.locationType)
            .eq('company_id', appState.companyChoosen)
            .eq('store_id', appState.storeChoosen);
      }
      
      // Invalidate cache to refresh the list
      ref.invalidate(allCashLocationsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
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
                  borderRadius: BorderRadius.circular(2),
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
                            borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(2),
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
                            borderRadius: BorderRadius.circular(12),
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