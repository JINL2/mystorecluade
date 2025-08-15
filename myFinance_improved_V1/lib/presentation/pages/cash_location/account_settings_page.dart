import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  final String accountName;
  final String locationType;
  
  const AccountSettingsPage({
    super.key,
    required this.accountName,
    required this.locationType,
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
  
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.accountName;
    // Initialize bank-specific fields if it's a bank account
    if (widget.locationType == 'bank') {
      _bankNameController.text = 'KB Bank'; // Mock data
      _accountNumberController.text = '8888889999999'; // Mock full account number
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
    return Scaffold(
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Name (like Balance/Accounts heading)
          Container(
            width: double.infinity,
            child: Text(
              widget.accountName,
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
              color: Colors.grey[600],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.cardShadow,
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
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _isMainAccount,
                  onChanged: (value) {
                    setState(() {
                      _isMainAccount = value;
                    });
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
                color: Colors.grey[700],
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
                color: controller.text.isEmpty ? Colors.grey[400] : Colors.black87,
              ),
            ),
            
            // Arrow
            SizedBox(width: TossSpacing.space2),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.cardShadow,
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
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext modalContext) {
        return _SimpleNameEditSheet(
          initialName: initialText,
          onSave: (String newName) {
            // Close the modal first
            Navigator.of(modalContext).pop();
            // Then update the parent state
            if (mounted) {
              setState(() {
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
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext modalContext) {
        return _SimpleNoteEditSheet(
          initialNote: initialText,
          onSave: (String newNote) {
            // Close the modal first
            Navigator.of(modalContext).pop();
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
      backgroundColor: Colors.transparent,
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
      backgroundColor: Colors.transparent,
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
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
                // Handle account deletion
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
    
    // Auto-focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
                  color: Colors.grey[300],
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
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => onSave(controller.text),
                      style: TossTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
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
                        fillColor: Colors.transparent,
                        filled: false,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.grey[400],
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
                            color: Colors.white,
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
    
    // Auto-focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
                  color: Colors.grey[300],
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
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 4,
                      minLines: 4,
                      style: TossTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
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
                        fillColor: Colors.transparent,
                        filled: false,
                        hintText: 'Add note...',
                        hintStyle: TossTextStyles.body.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400],
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
                            color: Colors.white,
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