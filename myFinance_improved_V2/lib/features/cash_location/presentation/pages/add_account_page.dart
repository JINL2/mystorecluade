import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';

import '../../domain/entities/currency_type.dart';
import '../../domain/usecases/create_cash_location_use_case.dart';
import '../providers/cash_location_providers.dart';

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
      appBar: TossAppBar1(
        title: _pageTitle,
        backgroundColor: TossColors.gray50,
      ),
      backgroundColor: TossColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Name Field
                    _buildSectionTitle('Account Name', fieldName: 'name'),
                    const SizedBox(height: TossSpacing.space2),
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'Enter account name',
                      fieldName: 'name',
                    ),
                    
                    // Bank-specific fields
                    if (widget.locationType == 'bank') ...[
                      const SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Bank Name', fieldName: 'bankName'),
                      const SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _bankNameController,
                        hintText: 'Enter bank name',
                        fieldName: 'bankName',
                      ),
                      
                      const SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Account Number', fieldName: 'accountNumber'),
                      const SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _accountNumberController,
                        hintText: 'Enter account number',
                        fieldName: 'accountNumber',
                        keyboardType: TextInputType.number,
                      ),
                      
                      const SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Currency', fieldName: 'currency'),
                      const SizedBox(height: TossSpacing.space2),
                      _buildCurrencyDropdown(),
                    ],
                    
                    // Description field (for cash/vault locations)
                    if (widget.locationType != 'bank') ...[
                      const SizedBox(height: TossSpacing.space6),
                      _buildSectionTitle('Description'),
                      const SizedBox(height: TossSpacing.space2),
                      _buildTextField(
                        controller: _descriptionController,
                        hintText: 'Enter description (optional)',
                        maxLines: 3,
                      ),
                    ],
                    
                    const SizedBox(height: TossSpacing.space8),
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
        color: showError ? TossColors.error : TossColors.black87,
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
        color: showError ? TossColors.errorLight : TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: showError ? TossColors.error : TossColors.gray300,
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
          if (showError) {
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
            color: showError ? TossColors.error.withOpacity(0.7) : TossColors.gray400,
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
          contentPadding: const EdgeInsets.all(TossSpacing.space4),
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
          contentPadding: const EdgeInsets.all(TossSpacing.space4),
          suffixIcon: const Icon(
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
            color: showError ? TossColors.errorLight : TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: showError ? TossColors.error : TossColors.gray300,
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
                color: showError ? TossColors.error.withOpacity(0.7) : TossColors.gray400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: TossColors.gray400,
              size: 24,
            ),
            isExpanded: true,
            style: TossTextStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: TossColors.black87,
            ),
            items: currencies.map<DropdownMenuItem<String>>((CurrencyType currency) {
              return DropdownMenuItem<String>(
                value: currency.currencyId,
                child: Row(
                  children: [
                    // Currency symbol
                    SizedBox(
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
                    const SizedBox(width: TossSpacing.space2),
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
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: const Center(
          child: TossLoadingView(),
        ),
      ),
      error: (error, stack) => Container(
        decoration: BoxDecoration(
          color: TossColors.errorLight,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.error),
        ),
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Text(
          'Failed to load currencies',
          style: TossTextStyles.body.copyWith(
            color: TossColors.error,
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
      padding: const EdgeInsets.all(TossSpacing.space4),
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
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => TossDialog.warning(
          title: 'Missing Information',
          message: 'Please select a company and store first',
          primaryButtonText: 'OK',
        ),
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
      // Use the CreateCashLocationUseCase
      final useCase = ref.read(createCashLocationUseCaseProvider);

      await useCase(CreateCashLocationParams(
        companyId: companyId,
        storeId: storeId,
        locationName: _nameController.text.trim(),
        locationType: widget.locationType,
        bankName: widget.locationType == 'bank' ? _bankNameController.text.trim() : null,
        accountNumber: widget.locationType == 'bank' ? _accountNumberController.text.trim() : null,
        currencyId: _selectedCurrencyId,
        description: _descriptionController.text.trim(),
      ),);
      
      // Close loading dialog
      if (mounted) context.pop();
      
      // Invalidate the cash locations cache to refresh the list
      ref.invalidate(allCashLocationsProvider);
      
      // Show success message
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Account Added',
            message: '${_pageTitle.replaceAll('Add ', '')} added successfully',
            primaryButtonText: 'OK',
          ),
        );
      }

      // Go back to previous screen
      if (mounted) context.pop();
      
    } catch (e) {
      // Close loading dialog
      if (mounted) context.pop();

      // Show error message
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.error(
            title: 'Add Failed',
            message: 'Failed to add account: ${e.toString()}',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
}
