import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/usecases/create_cash_location_use_case.dart';
import '../providers/cash_location_providers.dart';
import '../widgets/currency_selector_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
  final TextEditingController _currencyController = TextEditingController(); // Fixed: No longer creates new instances

  // Trade/International banking controllers
  final TextEditingController _beneficiaryNameController = TextEditingController();
  final TextEditingController _bankAddressController = TextEditingController();
  final TextEditingController _swiftCodeController = TextEditingController();
  final TextEditingController _bankBranchController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();

  // Currency selection
  String? _selectedCurrencyId;
  CurrencyType? _selectedCurrency;

  // Trade info section expanded state
  bool _isTradeInfoExpanded = false;

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
      case 'currency': return _currencyController; // Fixed: Reuse existing controller
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
    _currencyController.dispose();
    // Trade controllers
    _beneficiaryNameController.dispose();
    _bankAddressController.dispose();
    _swiftCodeController.dispose();
    _bankBranchController.dispose();
    _accountTypeController.dispose();
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
                    _buildTextField(
                      label: 'Account Name',
                      controller: _nameController,
                      hintText: 'Enter account name',
                      fieldName: 'name',
                    ),

                    // Bank-specific fields
                    if (widget.locationType == 'bank') ...[
                      const SizedBox(height: TossSpacing.space4),
                      _buildTextField(
                        label: 'Bank Name',
                        controller: _bankNameController,
                        hintText: 'Enter bank name',
                        fieldName: 'bankName',
                      ),

                      const SizedBox(height: TossSpacing.space4),
                      _buildTextField(
                        label: 'Account Number',
                        controller: _accountNumberController,
                        hintText: 'Enter account number',
                        fieldName: 'accountNumber',
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: TossSpacing.space4),
                      _buildCurrencySection(),

                      // Trade/International Banking Info (Expandable)
                      const SizedBox(height: TossSpacing.space4),
                      _buildTradeInfoSection(),
                    ],

                    // Description field (for cash/vault locations)
                    if (widget.locationType != 'bank') ...[
                      const SizedBox(height: TossSpacing.space4),
                      _buildTextField(
                        label: 'Description',
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
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    String? fieldName,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    bool showError = fieldName != null && _shouldShowError(fieldName);

    return TossTextField.filled(
      label: label,
      hintText: hintText,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      isRequired: fieldName != null && _isFieldRequired(fieldName),
      errorText: showError ? 'This field is required' : null,
      onFieldSubmitted: (_) {
        FocusScope.of(context).unfocus();
      },
      onChanged: (value) {
        if (fieldName != null) {
          _updateFieldStatus(fieldName);
        }
      },
    );
  }
  
  Widget _buildCurrencySection() {
    bool showError = _shouldShowError('currency');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Currency',
              style: TossTextStyles.label.copyWith(
                color: showError ? TossColors.error : TossColors.gray700,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        _buildCurrencyDropdown(),
        if (showError) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Please select a currency',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCurrencyDropdown() {
    final currencyTypesAsync = ref.watch(currencyTypesProvider);
    bool showError = _shouldShowError('currency');

    return currencyTypesAsync.when(
      data: (currencies) {
        // Find selected currency for display
        final selectedCurrency = _selectedCurrencyId != null
            ? currencies.firstWhere(
                (c) => c.currencyId == _selectedCurrencyId,
                orElse: () => currencies.first,
              )
            : null;

        return InkWell(
          onTap: () => _showCurrencySelector(currencies),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: showError ? TossColors.errorLight : TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: showError ? TossColors.error : TossColors.gray300,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: selectedCurrency != null
                      ? Row(
                          children: [
                            // Flag emoji
                            Text(
                              selectedCurrency.flagEmoji,
                              style: TossTextStyles.h2,
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            // Currency name
                            Expanded(
                              child: Text(
                                selectedCurrency.currencyName,
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            // Currency code
                            Text(
                              selectedCurrency.currencyCode,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Select currency',
                          style: TossTextStyles.body.copyWith(
                            color: showError ? TossColors.error.withOpacity(0.7) : TossColors.gray400,
                          ),
                        ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: showError ? TossColors.error : TossColors.gray400,
                  size: 24,
                ),
              ],
            ),
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
          ),
        ),
      ),
    );
  }

  void _showCurrencySelector(List<CurrencyType> currencies) async {
    final selectedCurrency = await CurrencySelectorSheet.show(
      context: context,
      currencies: currencies,
      selectedCurrencyId: _selectedCurrencyId,
    );

    if (selectedCurrency != null) {
      setState(() {
        _selectedCurrencyId = selectedCurrency.currencyId;
        _selectedCurrency = selectedCurrency;
        _filledFields.add('currency');
      });
    }
  }

  /// Expandable trade/international banking info section
  Widget _buildTradeInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300),
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
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  Icon(
                    Icons.public,
                    size: 20,
                    color: TossColors.gray600,
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'International Banking Info',
                          style: TossTextStyles.bodyMedium.copyWith(
                            color: TossColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'For international trade & wire transfers',
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
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildTradeInfoFields(),
            crossFadeState: _isTradeInfoExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: TossAnimations.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildTradeInfoFields() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        0,
        TossSpacing.space4,
        TossSpacing.space4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space4),

          // Beneficiary Name
          TossTextField.filled(
            label: 'Beneficiary Name',
            hintText: 'Enter beneficiary name',
            controller: _beneficiaryNameController,
          ),

          const SizedBox(height: TossSpacing.space3),

          // SWIFT Code
          TossTextField.filled(
            label: 'SWIFT / BIC Code',
            hintText: 'e.g., BKCHKHHH',
            controller: _swiftCodeController,
          ),

          const SizedBox(height: TossSpacing.space3),

          // Bank Branch
          TossTextField.filled(
            label: 'Bank Branch',
            hintText: 'Enter bank branch',
            controller: _bankBranchController,
          ),

          const SizedBox(height: TossSpacing.space3),

          // Bank Address
          TossTextField.filled(
            label: 'Bank Address',
            hintText: 'Enter bank address',
            controller: _bankAddressController,
            maxLines: 2,
          ),

          const SizedBox(height: TossSpacing.space3),

          // Account Type
          _buildAccountTypeLabel(),
          const SizedBox(height: TossSpacing.space2),
          _buildAccountTypeSelector(),
        ],
      ),
    );
  }

  Widget _buildAccountTypeLabel() {
    return Text(
      'Account Type',
      style: TossTextStyles.label.copyWith(
        color: TossColors.gray700,
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    final accountTypes = ['Savings', 'Checking', 'Current', 'Business'];
    final selectedType = _accountTypeController.text;

    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: accountTypes.map((type) {
        final isSelected = selectedType == type;
        return InkWell(
          onTap: () {
            setState(() {
              _accountTypeController.text = isSelected ? '' : type;
            });
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary.withValues(alpha: 0.1)
                  : TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
              border: Border.all(
                color: isSelected
                    ? TossColors.primary
                    : TossColors.gray200,
              ),
            ),
            child: Text(
              type,
              style: isSelected
                  ? TossTextStyles.bodyMedium.copyWith(color: TossColors.primary)
                  : TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
            ),
          ),
        );
      }).toList(),
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
          child: TossButton.primary(
            text: 'Confirm',
            onPressed: isButtonEnabled ? () {
              // Handle confirm action
              _handleConfirm();
            } : null,
            isEnabled: isButtonEnabled,
            fullWidth: true,
            height: 56,
            borderRadius: TossBorderRadius.md,
            textStyle: TossTextStyles.button.copyWith(
              color: isButtonEnabled ? TossColors.white : TossColors.gray500,
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
        // Trade/International banking fields (only for bank accounts)
        beneficiaryName: widget.locationType == 'bank' ? _beneficiaryNameController.text.trim() : null,
        bankAddress: widget.locationType == 'bank' ? _bankAddressController.text.trim() : null,
        swiftCode: widget.locationType == 'bank' ? _swiftCodeController.text.trim() : null,
        bankBranch: widget.locationType == 'bank' ? _bankBranchController.text.trim() : null,
        accountType: widget.locationType == 'bank' ? _accountTypeController.text.trim() : null,
      ));
      
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
