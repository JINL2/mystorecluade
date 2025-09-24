/// Transaction Template Usage Modal - Create transactions from saved templates
///
/// Purpose: Allows users to create transactions from templates with minimal input.
/// Handles complex templates with cash locations, counterparties, and debt tracking.
///
/// Keyboard Handling: Uses TossKeyboardAwareBottomSheet for proper keyboard management
///
/// Usage: TemplateUsageBottomSheet.show(context, template)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/toss/keyboard/toss_textfield_keyboard_modal.dart';
import '../../../widgets/toss/keyboard/toss_numberpad_modal.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../widgets/common/toss_loading_view.dart';
import '../../../../core/themes/toss_design_system.dart';
import '../../../../core/themes/toss_shadows.dart';
// Removed unused import: cash_location_selector.dart
import './store_selector.dart';
// Removed unused import: selector_entities.dart
import '../../../widgets/specific/selectors/autonomous_cash_location_selector.dart';
// Removed unused import: transaction_history_model.dart
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import '../providers/counterparty_providers.dart';
import '../providers/transaction_template_providers.dart';
import '../../journal_input/providers/journal_input_providers.dart';
import '../../../../data/services/supabase_service.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import '../../journal_input/widgets/exchange_rate_calculator.dart';

// Form complexity levels
enum FormComplexity {
  simple,        // Only amount input needed
  withCash,      // Need cash location selection
  withCounterparty, // Need counterparty's cash location
  complex        // Multiple selections needed
}

// Template form requirements analysis
class TemplateFormRequirements {
  bool hasPayableReceivable = false;
  bool hasCash = false;
  bool needsCounterparty = false;
  bool needsCounterpartyCashLocation = false;
  bool needsMyCashLocation = false;
  FormComplexity complexity = FormComplexity.simple;
  
  bool get isSimple => complexity == FormComplexity.simple;
  bool get needsSelectors => complexity != FormComplexity.simple;
}

// Debt configuration model
class DebtConfiguration {
  String category;
  DateTime issueDate;
  DateTime? dueDate;
  double interestRate;
  TextEditingController interestRateController;
  
  DebtConfiguration({
    this.category = 'note',
    DateTime? issueDate,
    this.dueDate,
    this.interestRate = 0.0,
  }) : issueDate = issueDate ?? DateTime.now(),
        interestRateController = TextEditingController(text: '0');
        
  void dispose() {
    interestRateController.dispose();
  }
}

// Template analyzer to determine form requirements
class TemplateFormAnalyzer {
  static TemplateFormRequirements analyzeTemplate(Map<String, dynamic> template) {
    final requirements = TemplateFormRequirements();
    final data = template['data'] as List? ?? [];
    final tags = template['tags'] as Map? ?? {};
    
    // Check if we have pre-selected MY cash locations in tags
    final tagsCashLocations = tags['cash_locations'] as List? ?? [];
    final hasPreselectedMyCashLocation = tagsCashLocations.isNotEmpty && 
        tagsCashLocations.first != null && 
        tagsCashLocations.first != 'none' &&
        tagsCashLocations.first != '';
    
    // Analyze transaction type to determine what's needed
    int debitCashCount = 0;
    int creditCashCount = 0;
    bool hasPayableOrReceivable = false;
    
    for (var entry in data) {
      final categoryTag = entry['category_tag'] as String?;
      final transactionType = entry['type'] as String?; // 'debit' or 'credit'
      
      // Count cash accounts on each side
      if (categoryTag == 'cash') {
        requirements.hasCash = true;
        if (transactionType == 'debit') {
          debitCashCount++;
        } else if (transactionType == 'credit') {
          creditCashCount++;
        }
        
        // Check if MY cash location is missing for this cash account
        if ((entry['cash_location_id'] == null || 
             entry['cash_location_id'] == '' ||
             entry['cash_location_id'] == 'none') &&
            !hasPreselectedMyCashLocation) {
          requirements.needsMyCashLocation = true;
        }
      }
      
      // Check for payable/receivable accounts
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        requirements.hasPayableReceivable = true;
        hasPayableOrReceivable = true;
        
        // Check if counterparty info is missing
        if (entry['counterparty_id'] == null && template['counterparty_id'] == null) {
          requirements.needsCounterparty = true;
        }
      }
    }
    
    // Determine if we need counterparty cash location
    // ONLY for Cash-to-Cash transfers (both sides have cash accounts)
    // NOT for Receivable/Payable to/from Cash transactions
    if (debitCashCount > 0 && creditCashCount > 0 && !hasPayableOrReceivable) {
      // This is a pure cash-to-cash transfer
      // Check if counterparty cash location is missing
      final templateCounterpartyCashLoc = template['counterparty_cash_location_id'];
      if (templateCounterpartyCashLoc == null || 
          templateCounterpartyCashLoc == '' || 
          templateCounterpartyCashLoc == 'none') {
        // Check if this is an internal counterparty (only internal transfers need cash location)
        final counterpartyId = template['counterparty_id'];
        if (counterpartyId != null) {
          // We'll need to check if it's internal when building the form
          // For now, assume we might need it
          requirements.needsCounterpartyCashLocation = true;
        }
      }
    }
    
    // Determine overall form complexity
    requirements.complexity = _calculateComplexity(requirements);
    
    return requirements;
  }
  
  static FormComplexity _calculateComplexity(TemplateFormRequirements req) {
    int missingFields = 0;
    
    if (req.needsCounterparty) missingFields++;
    if (req.needsCounterpartyCashLocation) missingFields++;
    if (req.needsMyCashLocation) missingFields++;
    
    if (missingFields == 0) return FormComplexity.simple;
    if (missingFields == 1) {
      if (req.needsMyCashLocation) return FormComplexity.withCash;
      return FormComplexity.withCounterparty;
    }
    return FormComplexity.complex;
  }
}

// Main Template Usage Bottom Sheet
class TemplateUsageBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> template;
  
  const TemplateUsageBottomSheet({
    super.key,
    required this.template,
  });
  
  static String _formatTagName(String tag) {
    // Convert category tags to readable names
    switch (tag.toLowerCase()) {
      case 'payable':
        return 'Payable';
      case 'receivable':
        return 'Receivable';
      case 'cash':
        return 'Cash';
      case 'expense':
        return 'Expense';
      case 'revenue':
        return 'Revenue';
      default:
        return tag.substring(0, 1).toUpperCase() + tag.substring(1);
    }
  }
  
  static Future<void> show(BuildContext context, Map<String, dynamic> template) {
    // Clean up template name for display
    String templateName = template['name']?.toString() ?? 'Transaction Template';
    if (templateName.toLowerCase().contains('none') || 
        templateName.toLowerCase().contains('account none')) {
      // Try to create a better name from the template type
      final data = template['data'] as List? ?? [];
      if (data.isNotEmpty) {
        final debit = data.firstWhere((e) => e['type'] == 'debit', orElse: () => {});
        final credit = data.firstWhere((e) => e['type'] == 'credit', orElse: () => {});
        final String debitTag = debit['category_tag']?.toString() ?? '';
        final String creditTag = credit['category_tag']?.toString() ?? '';
        if (debitTag.isNotEmpty && creditTag.isNotEmpty) {
          templateName = '${_formatTagName(debitTag)} to ${_formatTagName(creditTag)}';
        }
      }
    }
    
    // Create a key to access the form state
    final GlobalKey<_TemplateUsageBottomSheetState> formKey = GlobalKey();
    
    // Use TossTextFieldKeyboardModal with action buttons
    return TossTextFieldKeyboardModal.show(
      context: context,
      title: templateName,
      content: TemplateUsageBottomSheet(key: formKey, template: template),
      // Keep the original action buttons for the modal
      actionButtons: [
        Expanded(
          child: TossSecondaryButton(
            text: 'Cancel',
            fullWidth: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: TossPrimaryButton(
            text: 'Create Transaction',
            fullWidth: true,
            onPressed: () async {
              // Get the form state and submit
              final state = formKey.currentState;
              if (state != null && state._isFormValid) {
                await state._handleSubmit();
              }
            },
          ),
        ),
      ],
    );
  }
  
  @override
  ConsumerState<TemplateUsageBottomSheet> createState() => _TemplateUsageBottomSheetState();
}

class _TemplateUsageBottomSheetState extends ConsumerState<TemplateUsageBottomSheet> {
  late final TemplateFormRequirements requirements;
  final _formKey = GlobalKey<FormState>();
  final _numberFormat = NumberFormat('#,###');
  
  // Controllers
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  String _previousValue = '';
  
  // Selected values
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyStoreId;
  String? _selectedCounterpartyCashLocationId;
  String? _selectedMyCashLocationId;
  
  // Debt configuration for each payable/receivable account
  // Key is the account_id, value is the debt configuration
  Map<String, DebtConfiguration> _debtConfigurations = {};
  
  // State
  bool _isSubmitting = false;
  
  // Store linked company ID for internal counterparties
  String? _linkedCompanyId;
  
  // Track if multiple currencies exist
  bool _hasMultipleCurrencies = false;
  
  // Form validation helper
  bool get _isFormValid {
    // Description is optional - no validation needed
    
    // Amount must be entered and valid
    if (_amountController.text.isEmpty) return false;
    final cleanAmount = _amountController.text.replaceAll(',', '');
    final amount = int.tryParse(cleanAmount);
    if (amount == null || amount <= 0) return false;
    
    // Check requirements based on template
    // Check if counterparty is needed
    if (requirements.needsCounterparty) {
      if (_selectedCounterpartyId == null || _selectedCounterpartyId == '') {
        return false;
      }
    }
    
    // Only validate MY cash location if it's truly needed (not pre-selected)
    if (requirements.needsMyCashLocation) {
      // MY cash location is needed only if:
      // 1. Template has cash account
      // 2. No pre-selected cash location in entry or tags
      // 3. User hasn't selected one
      if (_selectedMyCashLocationId == null || _selectedMyCashLocationId == 'none' || _selectedMyCashLocationId == '') {
        return false;
      }
    }
    
    if (requirements.needsCounterpartyCashLocation) {
      // Check if store is needed (not saved in tags)
      final tags = widget.template['tags'] as Map? ?? {};
      final storedCounterpartyStoreId = tags['counterparty_store_id'] as String?;
      
      if (storedCounterpartyStoreId == null && _selectedCounterpartyStoreId == null) {
        return false;
      }
      
      if (_selectedCounterpartyCashLocationId == null) {
        return false;
      }
    }
    
    return true;
  }
  
  @override
  void initState() {
    super.initState();
    requirements = TemplateFormAnalyzer.analyzeTemplate(widget.template);
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    
    _amountController.addListener(() {
      _formatNumber();
      // Trigger rebuild to update button state
      setState(() {});
    });
    
    // Description is optional, no need to listen for changes
    
    // Check if counterparty_store_id is stored in tags
    final tags = widget.template['tags'] as Map? ?? {};
    final storedCounterpartyStoreId = tags['counterparty_store_id'] as String?;
    if (storedCounterpartyStoreId != null) {
      _selectedCounterpartyStoreId = storedCounterpartyStoreId;
    }
    
    // Initialize counterparty information from template
    final data = widget.template['data'] as List? ?? [];
    
    // First check for template-level counterparty ID
    final templateCounterpartyId = widget.template['counterparty_id'] as String?;
    if (templateCounterpartyId != null && templateCounterpartyId != '') {
      _selectedCounterpartyId = templateCounterpartyId;
      if (kDebugMode) {
      }
    }
    
    for (var entry in data) {
      final categoryTag = entry['category_tag'] as String?;
      final accountId = entry['account_id'] as String?;
      
      // Check for counterparty ID in line data (if not set at template level)
      if (_selectedCounterpartyId == null) {
        final entryCounterpartyId = entry['counterparty_id'] as String?;
        if (entryCounterpartyId != null && entryCounterpartyId != '') {
          _selectedCounterpartyId = entryCounterpartyId;
          if (kDebugMode) {
          }
        }
      }
      
      // Check for counterparty cash location in any line (for internal transfers)
      final counterpartyCashLocationId = entry['counterparty_cash_location_id'] as String?;
      if (counterpartyCashLocationId != null && 
          counterpartyCashLocationId != '' && 
          counterpartyCashLocationId != 'none') {
        _selectedCounterpartyCashLocationId = counterpartyCashLocationId;
        if (kDebugMode) {
        }
      }
      
      if (accountId != null && 
          (categoryTag == 'payable' || categoryTag == 'receivable')) {
        _debtConfigurations[accountId] = DebtConfiguration();
      }
    }
    
    // Initialize linked company ID if available in template
    // This will be overridden when fetching counterparty details
    _linkedCompanyId = null;
    
    // Check for multiple currencies on page load
    _checkForMultipleCurrencies();
  }
  
  @override
  void dispose() {
    _amountController.removeListener(_formatNumber);
    _amountController.dispose();
    _descriptionController.dispose();
    
    // Dispose debt configurations
    for (var config in _debtConfigurations.values) {
      config.dispose();
    }
    
    super.dispose();
  }
  
  void _formatNumber() {
    final text = _amountController.text;
    
    // Skip if unchanged
    if (text == _previousValue) return;
    
    // Remove all non-digits
    final cleanText = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanText.isEmpty) {
      _previousValue = '';
      return;
    }
    
    // Parse and format the number
    final number = int.tryParse(cleanText);
    if (number == null) return;
    
    // Format with commas
    final formatted = _numberFormat.format(number);
    
    // Update controller with formatted text
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    
    _previousValue = formatted;
  }
  
  Future<void> _checkForMultipleCurrencies() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      setState(() {
        _hasMultipleCurrencies = false;
      });
      return;
    }
    
    try {
      final exchangeRatesData = await ref.read(exchangeRatesProvider(companyId).future);
      if (exchangeRatesData != null) {
        final exchangeRates = exchangeRatesData['exchange_rates'] as List? ?? [];
        // Only show calculator if there's more than 1 currency (base + at least one other)
        setState(() {
          _hasMultipleCurrencies = exchangeRates.length > 1;
        });
      } else {
        // No exchange rate data means only base currency
        setState(() {
          _hasMultipleCurrencies = false;
        });
      }
    } catch (e) {
      // On error, assume only base currency
      setState(() {
        _hasMultipleCurrencies = false;
      });
    }
  }
  
  void _showExchangeRateCalculator() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),  // Visible backdrop
      isDismissible: true,  // Allow dismissing by tapping outside
      enableDrag: true,     // Allow dragging to dismiss
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,  // Fixed height
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ExchangeRateCalculator(
          initialAmount: _amountController.text.replaceAll(',', ''),
          onAmountSelected: (amount) {
            // Format the result with thousand separators
            final numericValue = double.tryParse(amount) ?? 0;
            final formatter = NumberFormat('#,##0', 'en_US');
            setState(() {
              _amountController.text = formatter.format(numericValue.toInt());
            });
          },
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Check if template has all requirements filled
    final bool isTemplateComplete = _checkTemplateCompleteness();
    
    // Build form content without action buttons (they're handled by the page)
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Template Info Card - Compact
          _buildCompactTemplateHeader(),
          
          SizedBox(height: TossSpacing.space3),
          
          // Primary Input Section - What user needs to do
          _buildPrimaryInputSection(),
          
          SizedBox(height: TossSpacing.space3),
          
          // Collapsible Details Section
          _buildCollapsibleDetailsSection(isTemplateComplete),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
  
  bool _checkTemplateCompleteness() {
    // Check if all required fields are pre-filled in template
    final needsCashLocation = requirements.needsMyCashLocation && _selectedMyCashLocationId == null;
    final needsCounterparty = requirements.needsCounterpartyCashLocation && _selectedCounterpartyCashLocationId == null;
    final hasAllDebtConfig = _debtConfigurations.values.every((config) => 
      config.category.isNotEmpty
    );
    
    return !needsCashLocation && !needsCounterparty && hasAllDebtConfig;
  }
  
  Widget _buildCompactTemplateHeader() {
    String templateName = widget.template['name'] ?? 'Transaction Template';
    final data = widget.template['data'] as List? ?? [];
    
    // Clean up template name if it contains 'none' or looks bad
    if (templateName.toLowerCase().contains('none') || 
        templateName.toLowerCase().contains('account none')) {
      // Generate a better name from template structure
      if (data.isNotEmpty) {
        final debit = data.firstWhere((e) => e['type'] == 'debit', orElse: () => {});
        final credit = data.firstWhere((e) => e['type'] == 'credit', orElse: () => {});
        final debitTag = debit['category_tag'] ?? '';
        final creditTag = credit['category_tag'] ?? '';
        if (debitTag.isNotEmpty && creditTag.isNotEmpty) {
          templateName = '${_formatCategoryTag(debitTag)} to ${_formatCategoryTag(creditTag)}';
        }
      }
    }
    
    // Get simple type description
    String typeDescription = '';
    if (data.isNotEmpty) {
      final debitAccounts = data.where((e) => e['type'] == 'debit')
          .map((e) => _formatCategoryTag(e['category_tag'] ?? 'account'))
          .toList();
      final creditAccounts = data.where((e) => e['type'] == 'credit')
          .map((e) => _formatCategoryTag(e['category_tag'] ?? 'account'))
          .toList();
      
      if (debitAccounts.isNotEmpty && creditAccounts.isNotEmpty) {
        typeDescription = '${debitAccounts.first} → ${creditAccounts.first}';
      }
    }
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt, size: 20, color: TossColors.primary),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  templateName,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          if (typeDescription.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space1),
            Row(
              children: [
                Expanded(
                  child: Text(
                    typeDescription,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildPrimaryInputSection() {
    final missingRequirements = <Widget>[];
    
    // Check what's missing
    if (requirements.needsMyCashLocation && _selectedMyCashLocationId == null) {
      missingRequirements.add(_buildMyCashLocationSelector());
    }
    
    // Check if we need counterparty selection (for receivable/payable without counterparty)
    if (requirements.needsCounterparty) {
      missingRequirements.add(_buildCounterpartySelector());
    }
    
    if (requirements.needsCounterpartyCashLocation && _selectedCounterpartyCashLocationId == null) {
      missingRequirements.add(_buildCounterpartyCashLocationSection());
    }
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.primary.withAlpha(51),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with clear instruction
          Row(
            children: [
              Icon(
                Icons.edit,
                size: 20,
                color: TossColors.primary,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Just enter these:',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Amount - Always first, always visible
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Amount *',
                style: TossTextStyles.label.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await TossNumberpadModal.show(
                          context: context,
                          title: 'Enter Amount',
                          initialValue: _amountController.text.replaceAll(',', ''),
                          // No currency symbol - universal numberpad
                          allowDecimal: false,
                          onConfirm: (value) {
                            _amountController.text = _numberFormat.format(int.parse(value));
                            setState(() {});
                          },
                        );
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.none, // Use none since we have custom numberpad
                        // Removed autofocus to prevent keyboard from appearing immediately
                        style: TossTextStyles.h3.copyWith( // Larger text
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          filled: true,
                          fillColor: TossColors.gray50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          borderSide: BorderSide(color: TossColors.gray300, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          borderSide: BorderSide(color: TossColors.primary, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space3,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                        LengthLimitingTextInputFormatter(15),
                        ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Amount is required';
                            }
                            return null;
                          },
                        ),
                        ),
                      ),
                  ),
                  // Only show calculator if multiple currencies exist
                  if (_hasMultipleCurrencies) ...[
                    SizedBox(width: TossSpacing.space2),
                    // Calculator button
                    Container(
                      height: 56, // Match text field height
                      width: 56,
                      decoration: BoxDecoration(
                        color: TossColors.primary,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      child: Material(
                        color: TossColors.transparent,
                        child: InkWell(
                          onTap: _showExchangeRateCalculator,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          child: Container(
                            padding: EdgeInsets.all(TossSpacing.space3),
                            child: Icon(
                              Icons.calculate_outlined,
                              color: TossColors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Description - Optional, right below amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Note (optional)',
                style: TossTextStyles.label.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Add a note...',
                  filled: true,
                  fillColor: TossColors.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    borderSide: BorderSide(color: TossColors.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    borderSide: BorderSide(color: TossColors.primary, width: 1.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space3,
                  ),
                ),
              ),
            ],
          ),
          
          // Missing requirements if any
          if (missingRequirements.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space3),
            Divider(color: TossColors.gray200),
            SizedBox(height: TossSpacing.space3),
            ...missingRequirements.map((widget) => 
              Padding(
                padding: EdgeInsets.only(bottom: TossSpacing.space3),
                child: widget,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildCollapsibleDetailsSection(bool isCollapsed) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: TossColors.transparent),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
              color: TossColors.gray600,
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              'Template Details',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            Spacer(),
            if (isCollapsed)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.success.withAlpha(25),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  'Using defaults',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        initiallyExpanded: !isCollapsed, // Auto-expand if missing requirements
        children: [
          Padding(
            padding: EdgeInsets.all(TossSpacing.space3),
            child: _buildTransactionEntrySections(),
          ),
        ],
      ),
    );
  }
  
  
  // New method to build debit and credit sections with their specific requirements
  Widget _buildTransactionEntrySections() {
    final data = widget.template['data'] as List? ?? [];
    final debitEntries = data.where((e) => e['type'] == 'debit').toList();
    final creditEntries = data.where((e) => e['type'] == 'credit').toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Debit Section
        if (debitEntries.isNotEmpty) 
          _buildEntrySection('DEBIT', debitEntries, true),
        
        // Credit Section
        if (creditEntries.isNotEmpty) 
          _buildEntrySection('CREDIT', creditEntries, false),
      ],
    );
  }
  
  Widget _buildEntrySection(String title, List<dynamic> entries, bool isDebit) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        color: TossColors.gray50,
        border: Border.all(
          color: TossColors.gray200,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: isDebit 
                ? TossColors.success.withAlpha(25) 
                : TossColors.warning.withAlpha(25),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md),
                topRight: Radius.circular(TossBorderRadius.md),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDebit ? TossColors.success : TossColors.warning,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    title,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(TossSpacing.space3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: entries.map((entry) => _buildEnhancedEntryInfo(entry)).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEnhancedEntryInfo(Map<String, dynamic> entry) {
    return Consumer(
      builder: (context, ref, child) {
        return _buildEnhancedEntryInfoContent(entry, ref);
      },
    );
  }
  
  Widget _buildEnhancedEntryInfoContent(Map<String, dynamic> entry, WidgetRef ref) {
    final accountName = entry['account_name'] ?? 'Unknown Account';
    final categoryTag = entry['category_tag'] as String?;
    
    // Get additional information based on account type
    List<String> additionalInfo = [];
    
    // For cash accounts, show cash location if set
    if (categoryTag == 'cash') {
      final cashLocationId = entry['cash_location_id'];
      if (cashLocationId != null && cashLocationId != 'none' && cashLocationId != '') {
        // Try to get actual cash location name from providers
        String cashLocationDisplay = '📍 Cash location set';
        try {
          final cashLocationsAsync = ref.watch(cashLocationsProvider);
          cashLocationsAsync.whenData((locations) {
            final location = locations.firstWhere(
              (loc) => loc['cash_location_id'] == cashLocationId,
              orElse: () => {},
            );
            if (location.isNotEmpty) {
              cashLocationDisplay = '📍 ${location['location_name'] ?? 'Location set'}';
            }
          });
        } catch (e) {
          // Fallback to template tags
          final tags = widget.template['tags'] as Map? ?? {};
          final cashLocationName = tags['cash_location_name'] as String?;
          if (cashLocationName != null) {
            cashLocationDisplay = '📍 $cashLocationName';
          }
        }
        additionalInfo.add(cashLocationDisplay);
      } else {
        // Check if user selected one in the form
        if (_selectedMyCashLocationId != null && _selectedMyCashLocationId != '') {
          additionalInfo.add('✅ Will use selected location');
        } else {
          additionalInfo.add('⚠️ Select cash location');
        }
      }
    }
    
    // For payable/receivable, show counterparty if set
    if (categoryTag == 'payable' || categoryTag == 'receivable') {
      // First try to get counterparty name from entry data
      String? counterpartyName = entry['counterparty_name'] as String?;
      final counterpartyId = entry['counterparty_id'] ?? widget.template['counterparty_id'];
      
      // If no name in entry, try to get from template level
      if (counterpartyName == null || counterpartyName.isEmpty) {
        counterpartyName = widget.template['counterparty_name'] as String?;
      }
      
      if (counterpartyId != null && counterpartyId != '') {
        // Try to get actual counterparty name from providers if not already available
        String counterpartyDisplay = '👤 ${counterpartyName ?? counterpartyId}';
        
        if (counterpartyName == null || counterpartyName.isEmpty) {
          try {
            final counterpartiesAsync = ref.watch(counterpartiesProvider);
            counterpartiesAsync.whenData((counterparties) {
              final cp = counterparties.firstWhere(
                (c) => c['counterparty_id'] == counterpartyId,
                orElse: () => {},
              );
              if (cp.isNotEmpty) {
                final name = cp['counterparty_name'] ?? cp['name'] ?? counterpartyId;
                final isInternal = cp['is_internal'] as bool? ?? false;
                counterpartyDisplay = '👤 $name${isInternal ? " (Internal)" : ""}';
              }
            });
          } catch (e) {
            // Fallback to template data
            final counterpartyName = entry['counterparty_name'] ?? widget.template['counterparty_name'];
            if (counterpartyName != null) {
              counterpartyDisplay = '👤 $counterpartyName';
            }
          }
        }
        additionalInfo.add(counterpartyDisplay);
        
        // Check if counterparty cash location is set (for cash transfers)
        final counterpartyCashLocId = entry['counterparty_cash_location_id'] ?? widget.template['counterparty_cash_location_id'];
        String? counterpartyCashLocName = entry['counterparty_cash_location_name'] as String?;
        
        // If no name in entry, try template level or tags
        if (counterpartyCashLocName == null || counterpartyCashLocName.isEmpty) {
          counterpartyCashLocName = widget.template['counterparty_cash_location_name'] as String?;
          if (counterpartyCashLocName == null || counterpartyCashLocName.isEmpty) {
            final tags = widget.template['tags'] as Map? ?? {};
            counterpartyCashLocName = tags['counterparty_cash_location_name'] as String?;
          }
        }
        
        if (counterpartyCashLocId != null && counterpartyCashLocId != 'none' && counterpartyCashLocId != '') {
          final locationDisplay = counterpartyCashLocName ?? 'Their location';
          additionalInfo.add('🏪 $locationDisplay');
        }
      } else {
        // Check if user selected one in the form
        if (_selectedCounterpartyId != null && _selectedCounterpartyId != '') {
          additionalInfo.add('✅ Will use selected counterparty');
        } else if (requirements.needsCounterparty) {
          additionalInfo.add('⚠️ Select counterparty');
        }
      }
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.gray50.withAlpha(128),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getAccountIcon(categoryTag),
                size: 16,
                color: TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  accountName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray800,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (categoryTag != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    _formatCategoryTag(categoryTag),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          if (additionalInfo.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space1),
            Padding(
              padding: EdgeInsets.only(left: TossSpacing.space5),
              child: Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space1,
                children: additionalInfo.map((info) => Text(
                  info,
                  style: TossTextStyles.caption.copyWith(
                    color: info.contains('⚠️') ? TossColors.warning : TossColors.gray600,
                    fontSize: 12,
                  ),
                )).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  IconData _getAccountIcon(String? categoryTag) {
    switch (categoryTag?.toLowerCase()) {
      case 'cash':
        return Icons.account_balance_wallet;
      case 'payable':
        return Icons.arrow_upward;
      case 'receivable':
        return Icons.arrow_downward;
      case 'expense':
        return Icons.remove_circle_outline;
      case 'revenue':
        return Icons.add_circle_outline;
      default:
        return Icons.account_balance;
    }
  }
  
  Widget _buildCashLocationSelector(Map<String, dynamic> entry) {
    // Check if cash location is pre-selected
    final preselectedCashLocation = entry['cash_location_id'];
    
    if (preselectedCashLocation != null && preselectedCashLocation != 'none') {
      // Fixed cash location
      return Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, size: 16, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space2),
            Text(
              'Cash Location: ${entry['cash_location_name'] ?? preselectedCashLocation}',
              style: TossTextStyles.body.copyWith(color: TossColors.gray700),
            ),
          ],
        ),
      );
    }
    
    // User needs to select cash location
    return Consumer(
      builder: (context, ref, child) {
        final cashLocationsAsync = ref.watch(cashLocationsProvider);
        
        return cashLocationsAsync.when(
          data: (cashLocations) => TossDropdown<String>(
            value: _selectedMyCashLocationId,
            items: cashLocations.map((location) => 
              TossDropdownItem<String>(
                value: location['cash_location_id'] as String,
                label: location['location_name'] as String,
              )
            ).toList(),
            label: 'Cash Location',
            hint: 'Select cash location',
            onChanged: (String? cashLocationId) {
              setState(() {
                _selectedMyCashLocationId = cashLocationId;
              });
            },
          ),
          loading: () => const TossLoadingView(),
          error: (_, __) => Text('Error loading cash locations', 
            style: TossTextStyles.caption.copyWith(color: TossColors.error)),
        );
      },
    );
  }
  
  Widget _buildDebtConfigurationForAccount(String accountId, String categoryTag) {
    final config = _debtConfigurations[accountId]!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Debt Category Dropdown
        TossDropdown<String>(
          value: config.category,
          items: [
            TossDropdownItem<String>(value: 'note', label: 'Note'),
            TossDropdownItem<String>(value: 'account', label: 'Account'),
            TossDropdownItem<String>(value: 'loan', label: 'Loan'),
            TossDropdownItem<String>(value: 'other', label: 'Other'),
          ],
          onChanged: (value) {
            setState(() {
              config.category = value ?? 'note';
            });
          },
          label: 'Debt Category',
          hint: 'Select debt category',
        ),
        SizedBox(height: TossSpacing.space3),
        
        // Date pickers in a row
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                label: 'Issue Date',
                date: config.issueDate,
                onChanged: (date) {
                  setState(() {
                    config.issueDate = date;
                  });
                },
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _buildDatePicker(
                label: 'Due Date',
                date: config.dueDate,
                isOptional: true,
                onChanged: (date) {
                  setState(() {
                    config.dueDate = date;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space3),
        
        // Interest Rate
        GestureDetector(
          onTap: () async {
            final result = await TossNumberpadModal.show(
              context: context,
              title: 'Interest Rate (%)',
              initialValue: config.interestRateController.text,
              // No currency symbol for percentage input
              allowDecimal: true,
              maxDecimalPlaces: 2,
              onConfirm: (value) {
                config.interestRateController.text = value;
                config.interestRate = double.tryParse(value) ?? 0.0;
                setState(() {});
              },
            );
          },
          child: AbsorbPointer(
            child: TossTextField(
              controller: config.interestRateController,
              label: 'Interest Rate (%)',
              hintText: 'Enter interest rate',
              keyboardType: TextInputType.none, // Use none since we have custom numberpad
              onChanged: (value) {
                final rate = double.tryParse(value) ?? 0.0;
                config.interestRate = rate;
              },
            ),
          ),
        ),
      ],
    );
  }
  
  // Build counterparty cash location section for receivable/payable accounts
  Widget _buildCounterpartyCashLocationSection() {
    // Check if counterparty cash location was pre-selected in template
    final templateCounterpartyCashLoc = widget.template['counterparty_cash_location_id'];
    
    if (templateCounterpartyCashLoc != null && 
        templateCounterpartyCashLoc != '' && 
        templateCounterpartyCashLoc != 'none') {
      // Pre-selected, show as fixed
      return Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.account_balance_wallet, size: 16, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                'Counterparty Cash Location: Set in template',
                style: TossTextStyles.body.copyWith(color: TossColors.gray700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    
    // Need to select counterparty's cash location
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Counterparty Cash Location',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
            fontSize: 12,
          ),
        ),
        SizedBox(height: TossSpacing.space1),
        _buildCounterpartyStoreAndCashLocationSelectors(),
      ],
    );
  }
  
  Widget _buildCounterpartyStoreAndCashLocationSelectors() {
    // First check if we have a counterparty
    String? counterpartyId;
    
    // Check template level first
    if (widget.template['counterparty_id'] != null) {
      counterpartyId = widget.template['counterparty_id'] as String;
    } else {
      // Check in data entries
      final data = widget.template['data'] as List? ?? [];
      for (var entry in data) {
        if (entry['counterparty_id'] != null) {
          counterpartyId = entry['counterparty_id'] as String;
          break;
        }
      }
    }
    
    if (counterpartyId == null) {
      return Text(
        'No counterparty configured',
        style: TossTextStyles.caption.copyWith(color: TossColors.error),
      );
    }
    
    return Consumer(
      builder: (context, ref, child) {
        // Fetch counterparty details
        final counterpartyAsync = ref.watch(counterpartyByIdProvider(counterpartyId));
        
        return counterpartyAsync.when(
          data: (counterparty) {
            if (counterparty == null) {
              return Text(
                'Counterparty not found',
                style: TossTextStyles.caption.copyWith(color: TossColors.error),
              );
            }
            
            final linkedCompanyId = counterparty['linked_company_id'] as String?;
            final isInternal = counterparty['is_internal'] as bool? ?? false;
            
            // Store linked company ID for debt tracking
            _linkedCompanyId = linkedCompanyId;
            
            if (!isInternal || linkedCompanyId == null) {
              // External counterparty - no cash location needed
              return Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 14,
                      color: TossColors.gray500,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Expanded(
                      child: Text(
                        'External - no cash location',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            // Internal counterparty - need to select store and cash location
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCounterpartyStoreSelector(),
                SizedBox(height: TossSpacing.space2),
                _buildCounterpartyCashLocationSelector(),
              ],
            );
          },
          loading: () => const TossLoadingView(),
          error: (_, __) => Text(
            'Error loading counterparty',
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        );
      },
    );
  }
  
  Widget _buildMyCashLocationSelector() {
    return Consumer(
      builder: (context, ref, child) {
        final cashLocationsAsync = ref.watch(cashLocationsProvider);
        
        return cashLocationsAsync.when(
          data: (cashLocations) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'My Cash Location *',
                  style: TossTextStyles.label.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                TossDropdown<String>(
                  value: _selectedMyCashLocationId,
                  items: cashLocations.map((location) => 
                    TossDropdownItem<String>(
                      value: location['cash_location_id'] as String,
                      label: location['location_name'] as String,
                    )
                  ).toList(),
                  label: '',
                  hint: 'Select cash location',
                  onChanged: (String? cashLocationId) {
                    setState(() {
                      _selectedMyCashLocationId = cashLocationId;
                    });
                  },
                ),
              ],
            );
          },
          loading: () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'My Cash Location *',
                style: TossTextStyles.label.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              TossDesignSystem.buildShimmer(
                width: double.infinity,
                height: 48,
              ),
            ],
          ),
          error: (_, __) => Text(
            'Error loading cash locations', 
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        );
      },
    );
  }
  
  Widget _buildCounterpartySelector() {
    return Consumer(
      builder: (context, ref, child) {
        final counterpartiesAsync = ref.watch(counterpartiesProvider);
        
        return counterpartiesAsync.when(
          data: (counterparties) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Counterparty *',
                  style: TossTextStyles.label.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                TossDropdown<String>(
                  value: _selectedCounterpartyId,
                  items: counterparties.map((cp) => 
                    TossDropdownItem<String>(
                      value: cp['counterparty_id'] as String,
                      label: cp['counterparty_name'] as String,
                      subtitle: (cp['is_internal'] as bool? ?? false) ? 'Internal' : 'External',
                    )
                  ).toList(),
                  label: '',
                  hint: 'Select counterparty',
                  onChanged: (String? counterpartyId) {
                    setState(() {
                      _selectedCounterpartyId = counterpartyId;
                      // Reset dependent fields when counterparty changes
                      _selectedCounterpartyStoreId = null;
                      _selectedCounterpartyCashLocationId = null;
                    });
                  },
                ),
              ],
            );
          },
          loading: () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Counterparty *',
                style: TossTextStyles.label.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              TossDesignSystem.buildShimmer(
                width: double.infinity,
                height: 48,
              ),
            ],
          ),
          error: (_, __) => Text(
            'Error loading counterparties', 
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        );
      },
    );
  }
  
  Widget _buildCounterpartyStoreSelector() {
    // First check if counterparty_store_id is already stored in tags
    final tags = widget.template['tags'] as Map? ?? {};
    final storedCounterpartyStoreId = tags['counterparty_store_id'] as String?;
    
    // If store is already saved, use it directly
    if (storedCounterpartyStoreId != null) {
      // Set the selected store ID immediately
      if (_selectedCounterpartyStoreId == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _selectedCounterpartyStoreId = storedCounterpartyStoreId;
          });
        });
      }
      // Return empty container since we don't need store selection
      return SizedBox.shrink();
    }
    
    // Otherwise, get counterparty ID and show store selector
    String? counterpartyId;
    
    // Check template level first
    if (widget.template['counterparty_id'] != null) {
      counterpartyId = widget.template['counterparty_id'] as String;
    } else {
      // Check in data entries
      final data = widget.template['data'] as List? ?? [];
      for (var entry in data) {
        if (entry['counterparty_id'] != null) {
          counterpartyId = entry['counterparty_id'] as String;
          break;
        }
      }
    }
    
    if (counterpartyId == null) {
      return Text(
        'No counterparty configured in template',
        style: TossTextStyles.caption.copyWith(color: TossColors.error),
      );
    }
    
    return Consumer(
      builder: (context, ref, child) {
        // First, fetch counterparty details to get linked_company_id
        final counterpartyAsync = ref.watch(counterpartyByIdProvider(counterpartyId));
        
        return counterpartyAsync.when(
          data: (counterparty) {
            if (counterparty == null) {
              return Text(
                'Counterparty not found',
                style: TossTextStyles.caption.copyWith(color: TossColors.error),
              );
            }
            
            final linkedCompanyId = counterparty['linked_company_id'] as String?;
            final counterpartyName = counterparty['name'] as String? ?? 'Unknown';
            final isInternal = counterparty['is_internal'] as bool? ?? false;
            
            // Store linked company ID for debt tracking
            _linkedCompanyId = linkedCompanyId;
            
            // Only internal counterparties have linked_company_id
            if (!isInternal || linkedCompanyId == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Counterparty Store',
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 14,
                          color: TossColors.gray500,
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Expanded(
                          child: Text(
                            'External ($counterpartyName)',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            
            // Fetch stores for the counterparty's linked company
            final storesAsync = ref.watch(storesForLinkedCompanyProvider(linkedCompanyId));
            
            return storesAsync.when(
              data: (stores) {
                if (stores.isEmpty) {
                  return Text(
                    'No stores available for $counterpartyName',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  );
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Counterparty Store ($counterpartyName)',
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    // Use StoreSelector for consistent styling
                    StoreSelector(
                      linkedCompanyId: linkedCompanyId,
                      selectedStoreId: _selectedCounterpartyStoreId,
                      onChanged: (storeId, storeName) {
                        setState(() {
                          _selectedCounterpartyStoreId = storeId;
                          _selectedCounterpartyCashLocationId = null; // Reset location
                          // Button state will update automatically
                        });
                      },
                      label: '',  // Empty label since we already have a section title
                      hint: 'Select counterparty store',
                    ),
                  ],
                );
              },
              loading: () => Center(
                child: TossLoadingView(),
              ),
              error: (error, stack) => Text(
                'Error loading stores',
                style: TossTextStyles.caption.copyWith(color: TossColors.error),
              ),
            );
          },
          loading: () => Center(
            child: TossLoadingView(),
          ),
          error: (error, stack) => Text(
            'Error loading counterparty details',
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        );
      },
    );
  }
  
  Widget _buildCounterpartyCashLocationSelector() {
    // Check if we have a store ID either from selection or from tags
    final tags = widget.template['tags'] as Map? ?? {};
    final storedCounterpartyStoreId = tags['counterparty_store_id'] as String?;
    final storeIdToUse = _selectedCounterpartyStoreId ?? storedCounterpartyStoreId;
    
    if (_linkedCompanyId == null) return SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AutonomousCashLocationSelector(
          companyId: _linkedCompanyId, // Use the counterparty's company ID
          storeId: storeIdToUse, // Use the counterparty's store ID if available
          selectedLocationId: _selectedCounterpartyCashLocationId,
          onChanged: (cashLocationId) {
            setState(() {
              _selectedCounterpartyCashLocationId = cashLocationId;
            });
          },
          label: 'Counterparty Cash Location',
          hint: 'Select counterparty cash location',
          showSearch: false, // Simplified for template usage
          showTransactionCount: false,
          showScopeTabs: false, // No need for tabs in template usage
        ),
      ],
    );
  }
  
  // Expose form validation state for external access
  bool get isFormValid => _isFormValid;
  bool get isSubmitting => _isSubmitting;
  
  // Expose submit handler for external access
  Future<void> handleSubmit() => _handleSubmit();
  
  // Helper function to construct p_lines array
  List<Map<String, dynamic>> _constructPLines(
    double amount,
    List<Map<String, dynamic>>? myCashLocations,
  ) {
    final lines = <Map<String, dynamic>>[];
    final templateData = widget.template['data'] as List? ?? [];
    final tags = widget.template['tags'] as Map? ?? {};
    
    // Get pre-selected MY cash location from tags if available
    final tagsCashLocations = tags['cash_locations'] as List? ?? [];
    final preselectedMyCashLocationId = tagsCashLocations.isNotEmpty ? 
        tagsCashLocations.first as String? : null;
    
    for (var templateLine in templateData) {
      final line = <String, dynamic>{
        'account_id': templateLine['account_id'],
        'description': templateLine['description'] ?? '',
      };
      
      // Set amounts based on type
      if (templateLine['type'] == 'debit') {
        line['debit'] = amount.toString();
        line['credit'] = '0';
      } else {
        line['debit'] = '0';
        line['credit'] = amount.toString();
      }
      
      // Add counterparty info if present (for line-level tracking)
      if (templateLine['counterparty_id'] != null) {
        line['counterparty_id'] = templateLine['counterparty_id'];
        
        // Add counterparty store if available
        final storeId = _selectedCounterpartyStoreId ?? 
                       tags['counterparty_store_id'];
        if (storeId != null) {
          line['counterparty_store_id'] = storeId;
        }
      }
      
      // Handle CASH accounts - Add MY cash location
      if (templateLine['category_tag'] == 'cash') {
        // Priority order for cash location:
        // 1. Cash location from the line entry
        // 2. Pre-selected cash location from tags
        // 3. User-selected cash location
        String? cashLocationId = templateLine['cash_location_id'];
        
        if (cashLocationId == null || cashLocationId == '' || cashLocationId == 'none') {
          // Check tags for pre-selected cash location
          if (preselectedMyCashLocationId != null && 
              preselectedMyCashLocationId != '' && 
              preselectedMyCashLocationId != 'none') {
            cashLocationId = preselectedMyCashLocationId;
          } else {
            // Use user-selected cash location
            cashLocationId = _selectedMyCashLocationId;
          }
        }
        
        if (cashLocationId != null && cashLocationId != 'none' && cashLocationId != '') {
          // Find the cash location name
          String? cashLocationName;
          if (myCashLocations != null) {
            final location = myCashLocations.firstWhere(
              (loc) => loc['cash_location_id'] == cashLocationId,
              orElse: () => {},
            );
            cashLocationName = location['location_name'] as String?;
          }
          
          // Add cash object with both ID and name
          line['cash'] = {
            'cash_location_id': cashLocationId,
            'cash_location_name': cashLocationName ?? '',
          };
        }
      }
      
      // Handle PAYABLE/RECEIVABLE accounts - Add debt tracking
      if (templateLine['category_tag'] == 'payable' || 
          templateLine['category_tag'] == 'receivable') {
        
        final accountId = templateLine['account_id'] as String?;
        if (accountId != null && _debtConfigurations.containsKey(accountId)) {
          line['debt'] = _constructDebtObject(
            templateLine,
            amount,
            accountId,
          );
        }
      }
      
      lines.add(line);
    }
    
    return lines;
  }
  
  // Helper function to construct debt object with user configurations
  Map<String, dynamic> _constructDebtObject(
    Map<String, dynamic> templateLine,
    double amount,
    String accountId,
  ) {
    final config = _debtConfigurations[accountId];
    if (config == null) return {};
    
    final categoryTag = templateLine['category_tag'];
    final counterpartyId = templateLine['counterparty_id'] ?? 
                          widget.template['counterparty_id'];
    final counterpartyName = templateLine['counterparty_name'] ?? '';
    final tags = widget.template['tags'] as Map? ?? {};
    final counterpartyStoreId = _selectedCounterpartyStoreId ?? 
                               tags['counterparty_store_id'];
    
    // Use the stored linked company ID for internal counterparties
    final linkedCompanyId = _linkedCompanyId ?? '';
    
    return {
      'counterparty_id': counterpartyId ?? '',
      'direction': categoryTag, // 'payable' or 'receivable'
      'category': config.category, // User-selected category
      'account_id': accountId,
      'original_amount': amount,
      'interest_rate': config.interestRate,
      'interest_account_id': '', // TODO: Add interest account selection if needed
      'interest_due_day': null, // Empty as shown in example
      'issue_date': DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(config.issueDate),
      'due_date': config.dueDate != null ? 
          DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(config.dueDate!) : null,
      'status': null, // Empty as shown in example
      'description': null, // Empty as shown in example
      'linkedCounterparty_store_id': counterpartyStoreId ?? '',
      'linkedCounterparty_companyId': linkedCompanyId,
      'counterparty_Name': counterpartyName,
    };
  }
  
  Future<void> _handleSubmit() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;
    
    // Description is optional - no validation needed
    
    // Additional validation based on requirements
    // Validate counterparty if needed
    if (requirements.needsCounterparty) {
      if (_selectedCounterpartyId == null || _selectedCounterpartyId == '') {
        _showError('Please select a counterparty');
        return;
      }
    }
    
    // Validate MY cash location only if truly needed
    if (requirements.needsMyCashLocation) {
      if (_selectedMyCashLocationId == null || _selectedMyCashLocationId == 'none' || _selectedMyCashLocationId == '') {
        _showError('Please select your cash location');
        return;
      }
    }
    
    if (requirements.needsCounterpartyCashLocation) {
      // Check if store is needed (not saved in tags)
      final tags = widget.template['tags'] as Map? ?? {};
      final storedCounterpartyStoreId = tags['counterparty_store_id'] as String?;
      
      if (storedCounterpartyStoreId == null && _selectedCounterpartyStoreId == null) {
        _showError('Please select counterparty store');
        return;
      }
      if (_selectedCounterpartyCashLocationId == null) {
        _showError('Please select counterparty cash location');
        return;
      }
    }
    
    // Get numeric amount
    final cleanAmount = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(cleanAmount);
    if (amount == null || amount <= 0) {
      _showError('Invalid amount');
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    try {
      // Get Supabase client and user info
      final supabase = Supabase.instance.client;
      final appState = ref.read(appStateProvider);
      final user = ref.read(authStateProvider);
      
      if (user == null) {
        _showError('User not authenticated');
        return;
      }
      
      // Get description (optional - can be empty/null)
      final description = _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim();
      
      // Get my cash locations for name lookup if needed
      // Include pre-selected cash locations from tags
      List<Map<String, dynamic>>? myCashLocations;
      final tags = widget.template['tags'] as Map? ?? {};
      final tagsCashLocations = tags['cash_locations'] as List? ?? [];
      final preselectedMyCashLocationId = tagsCashLocations.isNotEmpty ? 
          tagsCashLocations.first as String? : null;
      
      if (_selectedMyCashLocationId != null || preselectedMyCashLocationId != null) {
        final cashLocationsResponse = await supabase
            .from('cash_locations')
            .select('cash_location_id, location_name')
            .eq('company_id', appState.companyChoosen)
            .eq('store_id', appState.storeChoosen);
        myCashLocations = List<Map<String, dynamic>>.from(cashLocationsResponse);
      }
      
      // Construct p_lines with proper cash/debt handling
      final pLines = _constructPLines(amount, myCashLocations);
      
      // Extract main counterparty (goes OUTSIDE p_lines)
      String? mainCounterpartyId = widget.template['counterparty_id'];
      
      // If user selected a counterparty (for receivable/payable without one), use that
      if (requirements.needsCounterparty && _selectedCounterpartyId != null) {
        mainCounterpartyId = _selectedCounterpartyId;
      } else if (mainCounterpartyId == null) {
        // Find from template data
        final data = widget.template['data'] as List? ?? [];
        for (var line in data) {
          if (line['counterparty_id'] != null) {
            mainCounterpartyId = line['counterparty_id'] as String;
            break;
          }
        }
      }
      
      // Format entry date properly
      final entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
      
      // Prepare RPC parameters
      final rpcParams = {
        'p_base_amount': amount,
        'p_company_id': appState.companyChoosen,
        'p_created_by': user.id,
        'p_description': description,
        'p_entry_date': entryDate,
        'p_lines': pLines,
        'p_counterparty_id': mainCounterpartyId,  // Main counterparty (OUTSIDE p_lines)
        'p_if_cash_location_id': _selectedCounterpartyCashLocationId, // COUNTERPARTY's cash location (OUTSIDE p_lines)
        'p_store_id': appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
      };
      
      
      // Track template usage BEFORE creating transaction (so it tracks even if transaction fails)
      await _trackTemplateUsage();
      
      // Call RPC with properly structured parameters
      await supabase.rpc(
        'insert_journal_with_everything',
        params: rpcParams,
      );
      
      // Success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction created successfully'),
            backgroundColor: TossColors.success,
          ),
        );
        Navigator.of(context).pop(true); // Return success
      }
    } on PostgrestException catch (e) {
      // Handle database-specific errors
      
      if (e.code == '23505') {
        _showError('Duplicate transaction detected');
      } else if (e.message.contains('not balanced')) {
        _showError('Transaction amounts are not balanced');
      } else {
        _showError('Database error: ${e.message}');
      }
    } catch (e, stackTrace) {
      _showError('Failed to create transaction: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.error,
      ),
    );
  }

  /// Track template usage for analytics - stores in transaction_templates_preferences table
  Future<void> _trackTemplateUsage() async {
    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) {
        return;
      }

      final supabase = ref.read(supabaseServiceProvider);
      final templateId = widget.template['template_id'] as String?; // Fixed: use template_id not id
      final templateName = widget.template['name'] as String? ?? 'Unknown Template';
      final templateType = widget.template['template_type'] as String? ?? 'transaction';

      if (templateId == null) {
        return;
      }


      // Use correct log_template_usage RPC parameters for transaction_templates_preferences table
      final response = await supabase.client.rpc('log_template_usage', params: {
        'p_template_id': templateId,
        'p_template_name': templateName,
        'p_company_id': appState.companyChoosen,
        'p_template_type': templateType,
        'p_usage_type': 'used',
        'p_metadata': {
          'context': 'transaction_creation',
          'selection_source': 'template_usage_sheet',
          'amount': _amountController.text,
        },
      });
      
    } catch (e) {
      // Don't interrupt user experience, but log the error
    }
  }
  
  
  // Helper method to format category tags
  String _formatCategoryTag(String tag) {
    switch (tag.toLowerCase()) {
      case 'payable':
        return 'Payable';
      case 'receivable':
        return 'Receivable';
      case 'cash':
        return 'Cash';
      case 'expense':
        return 'Expense';
      case 'revenue':
        return 'Revenue';
      default:
        return tag.substring(0, 1).toUpperCase() + tag.substring(1);
    }
  }
  
  // Date picker widget
  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    bool isOptional = false,
    required Function(DateTime) onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selected != null) {
          onChanged(selected);
        }
      },
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          color: TossColors.white,
          border: Border.all(
            color: TossColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isOptional) ...[
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '(Optional)',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: TossSpacing.space1),
            Text(
              date != null 
                ? DateFormat('yyyy-MM-dd').format(date)
                : 'Select date',
              style: TossTextStyles.body.copyWith(
                color: date != null ? TossColors.gray900 : TossColors.gray400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

