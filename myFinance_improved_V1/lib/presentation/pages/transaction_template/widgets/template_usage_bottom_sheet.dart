import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../widgets/toss/toss_dropdown.dart';
// Removed unused import: cash_location_selector.dart
import './store_selector.dart';
// Removed unused import: selector_entities.dart
// Removed unused import: autonomous_cash_location_selector.dart
// Removed unused import: transaction_history_model.dart
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../journal_input/providers/journal_input_providers.dart';
import '../providers/counterparty_providers.dart';

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
    final categories = tags['categories'] as List? ?? [];
    
    // Check if we have pre-selected MY cash locations in tags
    final tagsCashLocations = tags['cash_locations'] as List? ?? [];
    final hasPreselectedMyCashLocation = tagsCashLocations.isNotEmpty && 
        tagsCashLocations.first != null && 
        tagsCashLocations.first != 'none' &&
        tagsCashLocations.first != '';
    
    // Analyze each line item in template data
    for (var entry in data) {
      final categoryTag = entry['category_tag'] as String?;
      
      // Check for payable/receivable accounts (COUNTERPARTY's cash location)
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        requirements.hasPayableReceivable = true;
        
        // Check if counterparty info is missing
        if (entry['counterparty_id'] == null && template['counterparty_id'] == null) {
          requirements.needsCounterparty = true;
        }
        
        // Check if COUNTERPARTY's cash location is missing
        // This is stored in counterparty_cash_location_id field
        // Check both null, empty string, and 'none' values
        final entryCashLoc = entry['counterparty_cash_location_id'];
        final templateCashLoc = template['counterparty_cash_location_id'];
        
        if ((entryCashLoc == null || entryCashLoc == '' || entryCashLoc == 'none') && 
            (templateCashLoc == null || templateCashLoc == '' || templateCashLoc == 'none')) {
          requirements.needsCounterpartyCashLocation = true;
        }
      }
      
      // Check for cash accounts (MY company's cash location)
      if (categoryTag == 'cash') {
        requirements.hasCash = true;
        
        // Check if MY cash location is missing
        // Only need selector if:
        // 1. No cash_location_id in the entry AND
        // 2. No pre-selected cash location in tags
        if ((entry['cash_location_id'] == null || 
             entry['cash_location_id'] == '' ||
             entry['cash_location_id'] == 'none') &&
            !hasPreselectedMyCashLocation) {
          requirements.needsMyCashLocation = true;
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
  
  static Future<void> show(BuildContext context, Map<String, dynamic> template) {
    return TossBottomSheet.show(
      context: context,
      title: template['name'],
      content: TemplateUsageBottomSheet(template: template),
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
  
  // Form validation helper
  bool get _isFormValid {
    // Description is optional - no validation needed
    
    // Amount must be entered and valid
    if (_amountController.text.isEmpty) return false;
    final cleanAmount = _amountController.text.replaceAll(',', '');
    final amount = int.tryParse(cleanAmount);
    if (amount == null || amount <= 0) return false;
    
    // Check requirements based on template
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
    
    // Initialize debt configurations for payable/receivable accounts
    final data = widget.template['data'] as List? ?? [];
    for (var entry in data) {
      final categoryTag = entry['category_tag'] as String?;
      final accountId = entry['account_id'] as String?;
      
      if (accountId != null && 
          (categoryTag == 'payable' || categoryTag == 'receivable')) {
        _debtConfigurations[accountId] = DebtConfiguration();
      }
    }
    
    // Initialize linked company ID if available in template
    // This will be overridden when fetching counterparty details
    _linkedCompanyId = null;
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
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Template Info Card
            _buildTemplateInfoCard(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Amount Input (always shown)
            _buildAmountInput(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Build debit and credit sections
            _buildTransactionEntrySections(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Description Input (always shown - at bottom)
            _buildDescriptionInput(),
            
            SizedBox(height: TossSpacing.space5),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTemplateInfoCard() {
    final categories = (widget.template['tags']?['categories'] as List?) ?? [];
    final description = widget.template['template_description'];
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(
              Icons.receipt_outlined,
              color: TossColors.primary,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.template['name'] ?? 'Template',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (categories.isNotEmpty) ...[
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    'Type: ${categories.join(' → ')}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
                if (description != null && description.toString().isNotEmpty) ...[
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    description.toString(),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Description',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              '(Optional)',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            color: TossColors.white,
            border: Border.all(
              color: _descriptionController.text.isNotEmpty 
                ? TossColors.primary
                : TossColors.gray200,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _descriptionController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
            minLines: 1,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: _descriptionController.text.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
              fontSize: 16,
            ),
            cursorColor: TossColors.primary,
            decoration: InputDecoration(
              hintText: 'Enter transaction description (optional)',
              hintStyle: TossTextStyles.body.copyWith(
                color: TossColors.gray400,
                fontSize: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(TossSpacing.space3),
            ),
            // No validator needed - description is optional
          ),
        ),
      ],
    );
  }
  
  Widget _buildAmountInput() {
    // Using native TextFormField with TossDropdown-like styling for consistency
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Amount',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            color: TossColors.white,
            border: Border.all(
              color: _amountController.text.isNotEmpty 
                ? TossColors.primary
                : TossColors.gray200,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
              LengthLimitingTextInputFormatter(15),
            ],
            validator: _validateAmount,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: _amountController.text.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
              fontSize: 16,
            ),
            cursorColor: TossColors.primary,
            decoration: InputDecoration(
              hintText: 'Enter amount (e.g., 123,456)',
              hintStyle: TossTextStyles.body.copyWith(
                color: TossColors.gray400,
                fontSize: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(TossSpacing.space3),
            ),
          ),
        ),
      ],
    );
  }
  
  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    
    // Remove commas and validate
    final cleanValue = value.replaceAll(',', '');
    final number = int.tryParse(cleanValue);
    
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (number <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (number > 999999999999) {
      return 'Amount is too large';
    }
    
    return null;
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
        if (debitEntries.isNotEmpty) ...[
          _buildEntrySection('DEBIT', debitEntries, true),
          SizedBox(height: TossSpacing.space4),
        ],
        
        // Credit Section
        if (creditEntries.isNotEmpty) ...[
          _buildEntrySection('CREDIT', creditEntries, false),
        ],
      ],
    );
  }
  
  Widget _buildEntrySection(String title, List<dynamic> entries, bool isDebit) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: isDebit ? TossColors.successLight : TossColors.warningLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            decoration: BoxDecoration(
              color: isDebit 
                ? TossColors.successLight 
                : TossColors.warningLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Text(
              title,
              style: TossTextStyles.labelLarge.copyWith(
                color: isDebit ? TossColors.success : TossColors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...entries.map((entry) => _buildEntryRequirements(entry)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEntryRequirements(Map<String, dynamic> entry) {
    final accountName = entry['account_name'] ?? 'Unknown Account';
    final categoryTag = entry['category_tag'] as String?;
    final accountId = entry['account_id'] as String?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Account name
        Text(
          accountName,
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        
        // Requirements based on account type
        if (categoryTag == 'cash') ...[
          _buildCashLocationSelector(entry),
        ] else if (categoryTag == 'receivable' || categoryTag == 'payable') ...[
          // For receivable/payable, check if we need counterparty cash location
          if (requirements.needsCounterpartyCashLocation) ...[
            _buildCounterpartyCashLocationSection(),
            SizedBox(height: TossSpacing.space3),
          ],
          // Then show debt configuration if needed
          if (accountId != null && categoryTag != null && _debtConfigurations.containsKey(accountId)) ...[
            _buildDebtConfigurationForAccount(accountId, categoryTag),
          ],
        ],
        // Other account types don't need special configuration
      ],
    );
  }
  
  Widget _buildCashLocationSelector(Map<String, dynamic> entry) {
    // Check if cash location is pre-selected
    final preselectedCashLocation = entry['cash_location_id'];
    final tags = widget.template['tags'] as Map? ?? {};
    final tagsCashLocations = tags['cash_locations'] as List? ?? [];
    final tagCashLocation = tagsCashLocations.isNotEmpty ? tagsCashLocations.first : null;
    
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
        final cashLocationsAsync = ref.watch(journalCashLocationsProvider);
        
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
          loading: () => CircularProgressIndicator(strokeWidth: 2),
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
        TossTextField(
          controller: config.interestRateController,
          label: 'Interest Rate (%)',
          hintText: 'Enter interest rate',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            final rate = double.tryParse(value) ?? 0.0;
            config.interestRate = rate;
          },
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
            Text(
              'Counterparty Cash Location: Set in template',
              style: TossTextStyles.body.copyWith(color: TossColors.gray700),
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
                child: Text(
                  'External counterparty - no cash location',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
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
          loading: () => CircularProgressIndicator(strokeWidth: 2),
          error: (_, __) => Text(
            'Error loading counterparty',
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        );
      },
    );
  }
  
  // Removed unused _buildMyCashLocationSelector method - now using inline dropdown in _buildCashLocationSelector
  
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
                    child: Text(
                      'External counterparty ($counterpartyName) - No store selection needed',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
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
                child: CircularProgressIndicator(
                  color: TossColors.primary,
                ),
              ),
              error: (error, stack) => Text(
                'Error loading stores',
                style: TossTextStyles.caption.copyWith(color: TossColors.error),
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: TossColors.primary,
            ),
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
    
    if (storeIdToUse == null) return SizedBox.shrink();
    
    return Consumer(
      builder: (context, ref, child) {
        // Fetch cash locations for the COUNTERPARTY's selected store
        final cashLocationsAsync = ref.watch(
          journalCounterpartyStoreCashLocationsProvider(storeIdToUse)
        );
        
        return cashLocationsAsync.when(
          data: (locations) {
            if (locations.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: TossSpacing.space3),
                  Text(
                    'No cash locations available for selected store',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              );
            }
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: TossSpacing.space3),
                Text(
                  'Counterparty Cash Location',
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray700,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                // Use TossDropdown for consistent styling
                TossDropdown<String>(
                  label: '',  // Empty label since we have it above
                  hint: 'Select cash location',
                  value: _selectedCounterpartyCashLocationId,
                  items: locations.map((location) {
                    final locationName = location['location_name'] as String? ?? 'Unknown';
                    final locationType = location['location_type'] as String? ?? '';
                    return TossDropdownItem<String>(
                      value: location['cash_location_id'] as String,
                      label: locationName,
                      subtitle: locationType.isNotEmpty ? locationType : null,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCounterpartyCashLocationId = value;
                      // Button state will update automatically
                    });
                  },
                ),
              ],
            );
          },
          loading: () => Column(
            children: [
              SizedBox(height: TossSpacing.space3),
              Center(
                child: CircularProgressIndicator(
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
          error: (error, stack) => Column(
            children: [
              SizedBox(height: TossSpacing.space3),
              Text(
                'Error loading cash locations',
                style: TossTextStyles.caption.copyWith(color: TossColors.error),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TossSecondaryButton(
            text: 'Cancel',
            onPressed: _isSubmitting ? null : () {
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(width: TossSpacing.space3),
        Expanded(
          child: TossPrimaryButton(
            text: _isSubmitting ? 'Creating...' : 'Create Transaction',
            onPressed: (_isSubmitting || !_isFormValid) ? null : _handleSubmit,
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }
  
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
      if (mainCounterpartyId == null) {
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
      
      // Debug logging
      print('=== RPC Parameters ===');
      print('p_base_amount: ${rpcParams['p_base_amount']}');
      print('p_company_id: ${rpcParams['p_company_id']}');
      print('p_created_by: ${rpcParams['p_created_by']}');
      print('p_description: ${rpcParams['p_description']}');
      print('p_entry_date: ${rpcParams['p_entry_date']}');
      print('p_counterparty_id: ${rpcParams['p_counterparty_id']}');
      print('p_if_cash_location_id: ${rpcParams['p_if_cash_location_id']}');
      print('p_store_id: ${rpcParams['p_store_id']}');
      print('p_lines: ${rpcParams['p_lines']}');
      print('===================');
      
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
      print('PostgrestException: ${e.message}');
      print('Error code: ${e.code}');
      print('Error details: ${e.details}');
      
      if (e.code == '23505') {
        _showError('Duplicate transaction detected');
      } else if (e.message.contains('not balanced')) {
        _showError('Transaction amounts are not balanced');
      } else {
        _showError('Database error: ${e.message}');
      }
    } catch (e, stackTrace) {
      print('Error creating transaction: $e');
      print('Stack trace: $stackTrace');
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
  
  // Build debt configuration widgets for payable/receivable accounts
  Widget _buildDebtConfigurations() {
    final data = widget.template['data'] as List? ?? [];
    final List<Widget> debtWidgets = [];
    
    for (var entry in data) {
      final categoryTag = entry['category_tag'] as String?;
      final accountId = entry['account_id'] as String?;
      final accountName = entry['account_name'] as String? ?? 'Account';
      
      if (accountId != null && _debtConfigurations.containsKey(accountId)) {
        debtWidgets.add(_buildSingleDebtConfiguration(
          accountId: accountId,
          accountName: accountName,
          categoryTag: categoryTag ?? '',
        ));
      }
    }
    
    if (debtWidgets.isEmpty) return SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section divider with label
        Container(
          margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: TossColors.gray200,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                child: Text(
                  'Debt Configuration',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: TossColors.gray200,
                ),
              ),
            ],
          ),
        ),
        ...debtWidgets,
      ],
    );
  }
  
  // Build single debt configuration for one account
  Widget _buildSingleDebtConfiguration({
    required String accountId,
    required String accountName,
    required String categoryTag,
  }) {
    final config = _debtConfigurations[accountId]!;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space4),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account info header
          Text(
            '$accountName (${categoryTag.toUpperCase()})',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          // Debt category dropdown
          TossDropdown<String>(
            label: 'Debt Category',
            hint: 'Select category',
            value: config.category,
            items: [
              TossDropdownItem(value: 'note', label: 'Note'),
              TossDropdownItem(value: 'account', label: 'Account'),
              TossDropdownItem(value: 'loan', label: 'Loan'),
              TossDropdownItem(value: 'other', label: 'Other'),
            ],
            onChanged: (value) {
              setState(() {
                config.category = value ?? 'note';
              });
            },
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Date pickers row
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
          
          // Interest rate input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interest Rate (%)',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  color: TossColors.white,
                  border: Border.all(
                    color: config.interestRateController.text.isNotEmpty 
                      ? TossColors.primary
                      : TossColors.gray200,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: config.interestRateController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontSize: 16,
                  ),
                  cursorColor: TossColors.primary,
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TossTextStyles.body.copyWith(
                      color: TossColors.gray400,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(TossSpacing.space3),
                  ),
                  onChanged: (value) {
                    config.interestRate = double.tryParse(value) ?? 0.0;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          color: Colors.white,
          border: Border.all(
            color: date != null ? TossColors.primary : TossColors.gray200,
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