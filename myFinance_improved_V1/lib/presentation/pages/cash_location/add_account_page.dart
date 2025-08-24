import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../providers/app_state_provider.dart';
import '../../../data/services/cash_location_service.dart';
import '../../widgets/common/toss_scaffold.dart';

class AddAccountPage extends ConsumerStatefulWidget {
  final String locationType; // 'cash', 'bank', 'vault'
  
  const AddAccountPage({
    super.key,
    required this.locationType,
  });

  @override
  ConsumerState<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends ConsumerState<AddAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailedAddressController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  
  // Track validation state
  bool _hasAttemptedSubmit = false;
  final Set<String> _filledFields = <String>{};
  
  @override
  void initState() {
    super.initState();
    // Add listeners to track field changes
    _nameController.addListener(() => _updateFieldStatus('name'));
    _bankNameController.addListener(() => _updateFieldStatus('bankName'));
    _accountNumberController.addListener(() => _updateFieldStatus('accountNumber'));
    _addressController.addListener(() => _updateFieldStatus('address'));
    _recipientController.addListener(() => _updateFieldStatus('recipient'));
  }
  
  void _updateFieldStatus(String fieldName) {
    TextEditingController controller = _getControllerByName(fieldName);
    if (controller.text.trim().isNotEmpty) {
      _filledFields.add(fieldName);
    } else {
      _filledFields.remove(fieldName);
    }
    if (mounted) setState(() {});
  }
  
  TextEditingController _getControllerByName(String fieldName) {
    switch (fieldName) {
      case 'name': return _nameController;
      case 'bankName': return _bankNameController;
      case 'accountNumber': return _accountNumberController;
      case 'address': return _addressController;
      case 'recipient': return _recipientController;
      default: return _nameController;
    }
  }
  
  List<String> _getRequiredFields() {
    List<String> required = ['name'];
    if (widget.locationType == 'bank') {
      required.addAll(['bankName', 'accountNumber']);
    } else {
      required.addAll(['address', 'recipient']);
    }
    return required;
  }
  
  bool _isFieldRequired(String fieldName) {
    return _getRequiredFields().contains(fieldName);
  }
  
  bool _shouldShowError(String fieldName) {
    return _hasAttemptedSubmit && 
           _isFieldRequired(fieldName) && 
           !_filledFields.contains(fieldName);
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _addressController.dispose();
    _detailedAddressController.dispose();
    _nicknameController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
  
  String get _pageTitle {
    switch (widget.locationType) {
      case 'bank':
        return 'Add Bank Account';
      case 'vault':
        return 'Add Vault Account';
      case 'cash':
      default:
        return 'Add Cash Account';
    }
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
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Name Field
                    _buildSectionTitle('Account Name', fieldName: 'name'),
                    SizedBox(height: TossSpacing.space2),
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'Enter account name',
                      fieldName: 'name',
                    ),
                    
                    // Bank-specific fields
                    if (widget.locationType == 'bank') ...[
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Bank Name', fieldName: 'bankName'),
                      SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _bankNameController,
                        hintText: 'Enter bank name',
                        fieldName: 'bankName',
                      ),
                      
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Account Number', fieldName: 'accountNumber'),
                      SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _accountNumberController,
                        hintText: 'Enter account number',
                        fieldName: 'accountNumber',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    
                    // Address fields (for cash/vault locations)
                    if (widget.locationType != 'bank') ...[
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Address', fieldName: 'address'),
                      SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _addressController,
                        hintText: 'Search building, lot, or road',
                        fieldName: 'address',
                      ),
                      
                      SizedBox(height: TossSpacing.space4),
                      _buildTextField(
                        controller: _detailedAddressController,
                        hintText: 'Enter the detailed address',
                        maxLines: 2,
                      ),
                      
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Address nickname'),
                      SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _nicknameController,
                        hintText: 'Enter address nickname (e.g., friend\'s house)',
                      ),
                      
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Recipient', fieldName: 'recipient'),
                      SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _recipientController,
                        hintText: 'Enter recipient\'s name',
                        fieldName: 'recipient',
                      ),
                      
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Phone number'),
                      SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _phoneController,
                        hintText: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Delivery instructions'),
                      SizedBox(height: TossSpacing.space2),
                      _buildDropdownField(
                        controller: _instructionsController,
                        hintText: 'Enter delivery instructions',
                      ),
                    ],
                    
                    SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ),
            
            // Bottom button
            _buildBottomButton(),
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
              _pageTitle,
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title, {String? fieldName}) {
    bool showError = fieldName != null && _shouldShowError(fieldName);
    return Text(
      title,
      style: TossTextStyles.body.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: showError ? const Color(0xFFEF4444) : Colors.black87,
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? fieldName,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    bool showError = fieldName != null && _shouldShowError(fieldName);
    
    return Container(
      decoration: BoxDecoration(
        color: showError ? const Color(0xFFFEF2F2) : Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: showError ? const Color(0xFFEF4444) : Colors.grey[300]!,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        onSubmitted: (_) {
          // Hide keyboard when user presses done
          FocusScope.of(context).unfocus();
        },
        onTap: () {
          // Clear error state when user starts typing in a field
          if (showError && fieldName != null) {
            setState(() {
              _filledFields.add(fieldName);
            });
          }
        },
        style: TossTextStyles.body.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TossTextStyles.body.copyWith(
            fontSize: 16,
            color: showError ? const Color(0xFFEF4444).withOpacity(0.7) : Colors.grey[400],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(TossSpacing.space4),
        ),
      ),
    );
  }
  
  Widget _buildDropdownField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        style: TossTextStyles.body.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TossTextStyles.body.copyWith(
            fontSize: 16,
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(TossSpacing.space4),
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey[400],
            size: 24,
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Handle confirm action
              _handleConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              elevation: 0,
            ),
            child: Text(
              'Confirm',
              style: TossTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _handleConfirm() async {
    // First, dismiss keyboard
    FocusScope.of(context).unfocus();
    
    setState(() {
      _hasAttemptedSubmit = true;
    });
    
    // Check if all required fields are filled
    List<String> requiredFields = _getRequiredFields();
    List<String> emptyFields = requiredFields.where((field) => 
      !_filledFields.contains(field)
    ).toList();
    
    if (emptyFields.isNotEmpty) {
      // Just show the red styling, no snackbar
      return;
    }
    
    // Get app state
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty || storeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a company and store first')),
      );
      return;
    }
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing loading dialogs
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    
    try {
      // Prepare location_info JSON based on location type
      Map<String, dynamic> locationInfo = {};
      
      if (widget.locationType == 'bank') {
        // For bank accounts, store bank-specific info
        locationInfo = {
          'bank_name': _bankNameController.text.trim(),
          'account_number': _accountNumberController.text.trim(),
        };
      } else {
        // For cash/vault locations, store address and contact info
        locationInfo = {
          'address': _addressController.text.trim(),
          'detailed_address': _detailedAddressController.text.trim(),
          'nickname': _nicknameController.text.trim(),
          'recipient': _recipientController.text.trim(),
          'phone': _phoneController.text.trim(),
          'instructions': _instructionsController.text.trim(),
        };
      }
      
      // Prepare the data for insertion
      final data = {
        'company_id': companyId,
        'store_id': storeId,
        'location_name': _nameController.text.trim(),
        'location_type': widget.locationType,
        'location_info': jsonEncode(locationInfo),
        // currency_code is left as null - will use database default
      };
      
      // Add bank-specific fields if it's a bank account
      if (widget.locationType == 'bank') {
        data['bank_name'] = _bankNameController.text.trim();
        data['bank_account'] = _accountNumberController.text.trim();
      }
      
      // Insert into Supabase
      final supabase = Supabase.instance.client;
      await supabase.from('cash_locations').insert(data);
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Invalidate the cash locations cache to refresh the list
      ref.invalidate(allCashLocationsProvider);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_pageTitle.replaceAll('Add ', '')} added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      // Go back to previous screen
      if (mounted) Navigator.of(context).pop();
      
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add account: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}