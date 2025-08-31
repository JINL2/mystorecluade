import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../../data/services/cash_location_service.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../../data/services/currency_service.dart';

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
  final TextEditingController _descriptionController = TextEditingController();
  
  // Currency selection
  String? _selectedCurrencyId;
  CurrencyType? _selectedCurrency;
  
  // Track validation state
  bool _hasAttemptedSubmit = false;
  final Set<String> _filledFields = <String>{};
  
  @override
  void initState() {
    super.initState();
    // Add listeners to track field changes and update button state
    _nameController.addListener(() {
      _updateFieldStatus('name');
      setState(() {}); // Refresh UI to update button state
    });
    
    if (widget.locationType == 'bank') {
      _bankNameController.addListener(() {
        _updateFieldStatus('bankName');
        setState(() {}); // Refresh UI to update button state
      });
      _accountNumberController.addListener(() {
        _updateFieldStatus('accountNumber');
        setState(() {}); // Refresh UI to update button state
      });
      _updateFieldStatus('currency');
    }
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
      case 'currency': return TextEditingController(); // Dummy for currency
      default: return _nameController;
    }
  }
  
  List<String> _getRequiredFields() {
    List<String> required = ['name'];
    if (widget.locationType == 'bank') {
      required.addAll(['bankName', 'accountNumber', 'currency']);
    }
    // For cash and vault, only name is required, description is optional
    return required;
  }
  
  bool _isFieldRequired(String fieldName) {
    return _getRequiredFields().contains(fieldName);
  }
  
  bool _shouldShowError(String fieldName) {
    if (fieldName == 'currency') {
      return _hasAttemptedSubmit && 
             _isFieldRequired(fieldName) && 
             _selectedCurrencyId == null;
    }
    return _hasAttemptedSubmit && 
           _isFieldRequired(fieldName) && 
           !_filledFields.contains(fieldName);
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _descriptionController.dispose();
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
      appBar: TossAppBar(
        title: _pageTitle,
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            
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
                      
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Currency', fieldName: 'currency'),
                      SizedBox(height: TossSpacing.space2),
                      _buildCurrencyDropdown(),
                    ],
                    
                    // Description field (for cash/vault locations)
                    if (widget.locationType != 'bank') ...[
                      SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Description'),
                      SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _descriptionController,
                        hintText: 'Enter description (optional)',
                        maxLines: 3,
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
  
  // Removed _buildHeader method - now using TossAppBar
  
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
        color: showError ? const Color(0xFFFEF2F2) : TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: showError ? const Color(0xFFEF4444) : TossColors.gray300,
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
            color: showError ? const Color(0xFFEF4444).withOpacity(0.7) : TossColors.gray400,
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
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300),
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
            color: TossColors.gray400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(TossSpacing.space4),
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: TossColors.gray400,
            size: 24,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrencyDropdown() {
    final currencyTypesAsync = ref.watch(currencyTypesProvider);
    bool showError = _shouldShowError('currency');
    
    return currencyTypesAsync.when(
      data: (currencies) {
        return Container(
          decoration: BoxDecoration(
            color: showError ? const Color(0xFFFEF2F2) : TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: showError ? const Color(0xFFEF4444) : TossColors.gray300,
              width: 1.0,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCurrencyId,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCurrencyId = newValue;
                if (newValue != null) {
                  _selectedCurrency = currencies.firstWhere(
                    (currency) => currency.currencyId == newValue,
                  );
                  _filledFields.add('currency');
                } else {
                  _selectedCurrency = null;
                  _filledFields.remove('currency');
                }
              });
            },
            decoration: InputDecoration(
              hintText: 'Select currency',
              hintStyle: TossTextStyles.body.copyWith(
                fontSize: 16,
                color: showError ? const Color(0xFFEF4444).withOpacity(0.7) : TossColors.gray400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: TossColors.gray400,
              size: 24,
            ),
            isExpanded: true,
            style: TossTextStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            items: currencies.map<DropdownMenuItem<String>>((CurrencyType currency) {
              return DropdownMenuItem<String>(
                value: currency.currencyId,
                child: Row(
                  children: [
                    // Currency symbol
                    Container(
                      width: 32,
                      child: Text(
                        currency.symbol,
                        style: TossTextStyles.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    // Currency name
                    Expanded(
                      child: Text(
                        currency.currencyName,
                        style: TossTextStyles.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Currency code
                    Text(
                      currency.currencyCode,
                      style: TossTextStyles.caption.copyWith(
                        fontSize: 14,
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () => Container(
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.gray300),
        ),
        padding: EdgeInsets.all(TossSpacing.space4),
        child: const Center(
          child: const TossLoadingView(),
        ),
      ),
      error: (error, stack) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: const Color(0xFFEF4444)),
        ),
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Text(
          'Failed to load currencies',
          style: TossTextStyles.body.copyWith(
            color: const Color(0xFFEF4444),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomButton() {
    // Check if account name is filled
    final bool isAccountNameFilled = _nameController.text.trim().isNotEmpty;
    
    // For bank accounts, also check other required fields
    final bool isBankFieldsFilled = widget.locationType != 'bank' || 
        (_bankNameController.text.trim().isNotEmpty && 
         _accountNumberController.text.trim().isNotEmpty && 
         _selectedCurrencyId != null);
    
    final bool isButtonEnabled = isAccountNameFilled && isBankFieldsFilled;
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isButtonEnabled ? () {
              // Handle confirm action
              _handleConfirm();
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonEnabled 
                  ? Theme.of(context).colorScheme.primary 
                  : TossColors.gray300,
              disabledBackgroundColor: TossColors.gray300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              elevation: 0,
            ),
            child: Text(
              'Confirm',
              style: TossTextStyles.body.copyWith(
                color: isButtonEnabled ? TossColors.white : TossColors.gray500,
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
    List<String> emptyFields = requiredFields.where((field) {
      if (field == 'currency') {
        // Special handling for currency dropdown
        return _selectedCurrencyId == null;
      }
      return !_filledFields.contains(field);
    }).toList();
    
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
          child: TossLoadingView(),
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
        // For cash/vault locations, store only description
        locationInfo = {
          'description': _descriptionController.text.trim(),
        };
      }
      
      // Prepare the data for insertion
      final data = {
        'company_id': companyId,
        'store_id': storeId,
        'location_name': _nameController.text.trim(),
        'location_type': widget.locationType,
        'location_info': jsonEncode(locationInfo),
      };
      
      // Add bank-specific fields if it's a bank account
      if (widget.locationType == 'bank') {
        data['bank_name'] = _bankNameController.text.trim();
        data['bank_account'] = _accountNumberController.text.trim();
        // Add currency_id for bank accounts
        if (_selectedCurrencyId != null) {
          data['currency_id'] = _selectedCurrencyId!;
        }
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
            backgroundColor: TossColors.success,
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
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
}