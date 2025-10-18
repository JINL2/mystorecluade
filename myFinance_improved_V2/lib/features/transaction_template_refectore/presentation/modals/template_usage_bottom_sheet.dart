/// Transaction Template Usage Modal - Create transactions from saved templates
///
/// Purpose: Allows users to create transactions from templates with minimal input.
/// Handles complex templates with cash locations, counterparties, and debt tracking.
///
/// Keyboard Handling: Uses TossKeyboardAwareBottomSheet for proper keyboard management
///
/// Usage: TemplateUsageBottomSheet.show(context, template)
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/shared/widgets/toss/keyboard/toss_textfield_keyboard_modal.dart';
import 'package:myfinance_improved/shared/widgets/toss/keyboard/toss_numberpad_modal.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/themes/toss_design_system.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import '../widgets/common/store_selector.dart';
import 'package:myfinance_improved/shared/widgets/specific/selectors/autonomous_cash_location_selector.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart' as Legacy;
import 'package:myfinance_improved/app/providers/auth_provider.dart';
// Updated imports to use new provider structure
import '../providers/template_provider.dart';
import 'package:myfinance_improved/app/providers/journal_input_providers.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/journal_input/exchange_rate_calculator.dart';
// 🔧 ENHANCED: Template analysis for intelligent UI
import '../../domain/value_objects/template_analysis_result.dart';
import '../../domain/enums/template_enums.dart';
import '../../domain/validators/template_form_validator.dart';
// ✅ Clean Architecture: Use Case from Domain layer
import '../../domain/usecases/create_transaction_from_template_usecase.dart';
// ✅ Clean Architecture: Provider from Presentation layer
import '../providers/use_case_providers.dart';

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
        final debit = data.firstWhere((e) => e['type'] == 'debit', orElse: () => <String, dynamic>{});
        final credit = data.firstWhere((e) => e['type'] == 'credit', orElse: () => <String, dynamic>{});
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
      contentPadding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,  // ✅ Reduced: 12px instead of default 16px
        vertical: TossSpacing.space3,
      ),
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
              print('🔵 [CREATE TRANSACTION] Button clicked!');

              // Get the form state and submit
              final state = formKey.currentState;
              print('🔵 [CREATE TRANSACTION] formKey.currentState: ${state != null ? "exists" : "NULL"}');

              if (state != null) {
                final isValid = state._isFormValid;
                print('🔵 [CREATE TRANSACTION] _isFormValid: $isValid');

                if (isValid) {
                  print('🔵 [CREATE TRANSACTION] Form is valid, calling _handleSubmit()...');
                  await state._handleSubmit();
                  print('🔵 [CREATE TRANSACTION] _handleSubmit() completed');
                } else {
                  print('❌ [CREATE TRANSACTION] Form is INVALID - cannot submit');
                  print('❌ [CREATE TRANSACTION] Validation details:');
                  print('   - Amount: "${state._amountController.text}"');
                  print('   - Selected Cash Location: ${state._selectedMyCashLocationId}');
                  print('   - Selected Counterparty: ${state._selectedCounterpartyId}');
                  print('   - Analysis missing items: ${state._analysis.missingItems}');
                }
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
  // 🔧 ENHANCED: Template analysis for intelligent UI
  late final TemplateAnalysisResult _analysis;

  // Controllers and state variables
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dynamic selection state
  String? _selectedMyCashLocationId;
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyCashLocationId;
  bool _showTemplateDetails = false;

  // 🔧 ENHANCED: Real-time validation state
  String? _amountError;
  String? _cashLocationError;
  String? _counterpartyError;
  TemplateValidationResult? _lastValidationResult;

  @override
  void initState() {
    super.initState();
    print('🔧 [INIT] TemplateUsageBottomSheet initState called');

    // Analyze template to determine required fields
    print('🔧 [INIT] Analyzing template...');
    _analysis = TemplateAnalysisResult.analyze(widget.template);
    print('🔧 [INIT] Analysis complete:');
    print('   - Missing items: ${_analysis.missingItems}');
    print('   - Missing fields count: ${_analysis.missingFields}');
    print('   - Template data: ${widget.template['data']}');

    // Add listeners for real-time validation
    _amountController.addListener(_validateAmountField);
    print('🔧 [INIT] Listeners added');
  }

  /// Real-time amount field validation
  void _validateAmountField() {
    setState(() {
      _amountError = TemplateFormValidator.validateAmountField(_amountController.text);
    });
  }

  /// Real-time cash location validation
  void _validateCashLocationField() {
    setState(() {
      _cashLocationError = TemplateFormValidator.validateCashLocation(
        analysis: _analysis,
        selectedCashLocationId: _selectedMyCashLocationId,
      );
    });
  }

  /// Real-time counterparty validation
  void _validateCounterpartyField() {
    setState(() {
      _counterpartyError = TemplateFormValidator.validateCounterparty(
        analysis: _analysis,
        selectedCounterpartyId: _selectedCounterpartyId,
      );
    });
  }

  /// Comprehensive form validation using domain validator
  bool get _isFormValid {
    print('🔍 [VALIDATION] Checking form validity...');
    print('🔍 [VALIDATION] - Amount text: "${_amountController.text}"');
    print('🔍 [VALIDATION] - Selected cash location: $_selectedMyCashLocationId');
    print('🔍 [VALIDATION] - Selected counterparty: $_selectedCounterpartyId');
    print('🔍 [VALIDATION] - Missing items: ${_analysis.missingItems}');

    final canSubmit = TemplateFormValidator.canSubmit(
      analysis: _analysis,
      amountText: _amountController.text,
      selectedMyCashLocationId: _selectedMyCashLocationId,
      selectedCounterpartyId: _selectedCounterpartyId,
      selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
    );

    print('🔍 [VALIDATION] Result: ${canSubmit ? "✅ VALID" : "❌ INVALID"}');
    return canSubmit;
  }

  /// Get full validation result for error display
  TemplateValidationResult _getValidationResult() {
    return TemplateFormValidator.validate(
      analysis: _analysis,
      amountText: _amountController.text,
      selectedMyCashLocationId: _selectedMyCashLocationId,
      selectedCounterpartyId: _selectedCounterpartyId,
      selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ No padding here - parent TossTextFieldKeyboardModal handles it
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔧 ENHANCED: Template info card (Legacy style)
        _buildTemplateInfoCard(),

        SizedBox(height: TossSpacing.space3),

        // 🔧 ENHANCED: "Just enter these:" section with blue border (Legacy style)
        _buildInputSection(),

        SizedBox(height: TossSpacing.space3),

        // 🔧 ENHANCED: Template details collapsible section
        _buildTemplateDetailsSection(),
      ],
    );
  }

  /// Builds template info card (Legacy style with icon)
  Widget _buildTemplateInfoCard() {
    final data = widget.template['data'] as List? ?? [];
    if (data.isEmpty) return SizedBox.shrink();

    final debit = data.firstWhere((e) => e['type'] == 'debit', orElse: () => <String, dynamic>{});
    final credit = data.firstWhere((e) => e['type'] == 'credit', orElse: () => <String, dynamic>{});

    final debitTag = debit['category_tag']?.toString() ?? '';
    final creditTag = credit['category_tag']?.toString() ?? '';

    if (debitTag.isEmpty || creditTag.isEmpty) return SizedBox.shrink();

    // Get template name from widget
    final templateName = widget.template['name']?.toString() ?? 'Template';

    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          // 📋 Template icon (blue)
          Container(
            padding: EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(
              Icons.receipt_long,
              color: TossColors.primary,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Template name (bold)
                Text(
                  templateName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                // Transaction type (gray)
                Text(
                  '${TemplateUsageBottomSheet._formatTagName(debitTag)} → ${TemplateUsageBottomSheet._formatTagName(creditTag)}',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds input section with blue border (Legacy style)
  Widget _buildInputSection() {
    // Check if guidance should be shown
    final showGuidance = _analysis.missingFields > 0 && _analysis.missingFields <= 3;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: TossColors.primary.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      padding: EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✏️ "Just enter these:" header (Legacy style)
          if (showGuidance) ...[
            Row(
              children: [
                Icon(
                  Icons.edit,
                  color: TossColors.primary,
                  size: 20,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Just enter these:',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
          ],

          // Dynamic form fields
          _buildDynamicFields(),
        ],
      ),
    );
  }

  /// Builds dynamic form fields based on template analysis
  Widget _buildDynamicFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount field (always required)
        _buildAmountField(),

        SizedBox(height: TossSpacing.space3),

        // Description field (optional)
        _buildDescriptionField(),

        // Cash location selector (if needed)
        if (_analysis.missingItems.contains('cash_location')) ...[
          SizedBox(height: TossSpacing.space3),
          _buildCashLocationSelector(),
        ],

        // Counterparty selector (if needed)
        if (_analysis.missingItems.contains('counterparty')) ...[
          SizedBox(height: TossSpacing.space3),
          _buildCounterpartySelector(),
        ],
      ],
    );
  }

  /// Builds amount input field with validation
  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TossTextField(
          controller: _amountController,
          label: 'Amount *',
          hintText: 'Enter amount',
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // Real-time validation happens via listener
            setState(() {});
          },
        ),
        if (_amountError != null) ...[
          SizedBox(height: TossSpacing.space1),
          Text(
            _amountError!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds description input field
  Widget _buildDescriptionField() {
    return TossTextField(
      controller: _descriptionController,
      label: 'Note',
      hintText: 'Add a note (optional)',
      maxLines: 2,
    );
  }

  /// Builds cash location selector with validation
  Widget _buildCashLocationSelector() {
    final appState = ref.watch(Legacy.appStateProvider);
    final storeId = appState.storeChoosen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Cash Location',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              '*',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space2),
        AutonomousCashLocationSelector(
          storeId: storeId,
          selectedLocationId: _selectedMyCashLocationId,
          onChanged: (cashLocationId) {
            setState(() {
              _selectedMyCashLocationId = cashLocationId;
              _validateCashLocationField();
            });
          },
        ),
        if (_cashLocationError != null) ...[
          SizedBox(height: TossSpacing.space1),
          Text(
            _cashLocationError!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds counterparty selector
  Widget _buildCounterpartySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Counterparty',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              '*',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space2),
        Container(
          padding: EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray300),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Text(
            'Counterparty selector (to be implemented)',
            style: TossTextStyles.body.copyWith(color: TossColors.gray500),
          ),
        ),
      ],
    );
  }

  /// Builds template details collapsible section
  Widget _buildTemplateDetailsSection() {
    final data = widget.template['data'] as List? ?? [];
    if (data.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _showTemplateDetails = !_showTemplateDetails),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // ℹ️ Info icon (Legacy style)
                    Icon(
                      Icons.info_outline,
                      color: TossColors.gray600,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space2),
                    Text(
                      'Template Details',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray800,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _showTemplateDetails ? Icons.expand_less : Icons.expand_more,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),
        if (_showTemplateDetails) ...[
          SizedBox(height: TossSpacing.space3),
          // Constrain height to prevent overflow over buttons
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 200, // Limit height to ensure buttons are visible
            ),
            child: SingleChildScrollView(
              child: _buildTemplateDataDisplay(data),
            ),
          ),
        ],
      ],
    );
  }

  /// Builds template data display with DEBIT/CREDIT entries
  Widget _buildTemplateDataDisplay(List data) {
    // Get store name from tags if available
    final tags = widget.template['tags'] as Map<String, dynamic>? ?? {};
    final counterpartyStoreName = tags['counterparty_store_name']?.toString();

    // 🔍 DEBUG: Print template data to console
    print('🔍 Template Data: $data');
    print('🔍 Template Tags: $tags');
    print('🔍 Store Name: $counterpartyStoreName');

    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray300),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: data.map((entry) {
          final type = entry['type']?.toString() ?? '';
          final categoryTag = entry['category_tag']?.toString() ?? '';
          final accountName = entry['account_name']?.toString() ?? 'Unknown';

          // Extract optional name fields
          final cashLocationName = entry['cash_location_name']?.toString();
          final counterpartyName = entry['counterparty_name']?.toString();
          final counterpartyCashLocationName = entry['counterparty_cash_location_name']?.toString();

          return Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              children: [
                // DEBIT/CREDIT badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: type == 'debit' ? TossColors.primary.withOpacity(0.1) : TossColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: TossTextStyles.caption.copyWith(
                      color: type == 'debit' ? TossColors.primary : TossColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account name (removed redundant category tag)
                      Text(
                        accountName,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Conditional: Cash location name
                      if (cashLocationName != null) ...[
                        SizedBox(height: TossSpacing.space1),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: TossColors.gray500,
                            ),
                            SizedBox(width: TossSpacing.space1),
                            Text(
                              cashLocationName,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ],
                      // Conditional: Counterparty name
                      if (counterpartyName != null) ...[
                        SizedBox(height: TossSpacing.space1),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: TossColors.gray500,
                            ),
                            SizedBox(width: TossSpacing.space1),
                            Text(
                              counterpartyName,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ],
                      // Conditional: Counterparty store name (only for Payable/Receivable)
                      if (counterpartyName != null && counterpartyStoreName != null) ...[
                        SizedBox(height: TossSpacing.space1),
                        Row(
                          children: [
                            Icon(
                              Icons.store_outlined,
                              size: 14,
                              color: TossColors.gray500,
                            ),
                            SizedBox(width: TossSpacing.space1),
                            Text(
                              counterpartyStoreName,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ],
                      // Conditional: Counterparty cash location name
                      if (counterpartyCashLocationName != null) ...[
                        SizedBox(height: TossSpacing.space1),
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_outlined,
                              size: 14,
                              color: TossColors.gray500,
                            ),
                            SizedBox(width: TossSpacing.space1),
                            Text(
                              counterpartyCashLocationName,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  
  /// ✅ Clean Architecture: Creates transaction using Use Case
  Future<void> _createTransactionFromTemplate(double amount) async {
    print('🎯 [PRESENTATION] Calling Use Case...');

    // Get app state for company/user/store IDs
    // ✅ FIXED: Access state properties from AppState, not AppStateNotifier
    final legacyAppState = ref.read(Legacy.appStateProvider);
    final user = ref.read(authStateProvider);

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final companyId = legacyAppState.companyChoosen;
    final storeId = legacyAppState.storeChoosen;
    final userId = user.id;

    print('🎯 [PRESENTATION] Company ID: $companyId');
    print('🎯 [PRESENTATION] User ID: $userId');
    print('🎯 [PRESENTATION] Store ID: $storeId');

    // Build use case parameters
    final params = CreateTransactionFromTemplateParams(
      template: widget.template,
      amount: amount,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      selectedMyCashLocationId: _selectedMyCashLocationId,
      selectedCounterpartyId: _selectedCounterpartyId,
      selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
      companyId: companyId!,
      userId: userId,
      storeId: storeId,
    );

    // Execute use case
    final useCase = ref.read(createTransactionFromTemplateUseCaseProvider);
    await useCase.execute(params);

    print('✅ [PRESENTATION] Transaction created successfully via Use Case!');
  }

  Future<void> _handleSubmit() async {
    // 🔧 ENHANCED: Comprehensive form submission with validation and feedback
    print('📤 [SUBMIT] _handleSubmit() called');

    // 1. Validate form
    print('📤 [SUBMIT] Step 1: Validating form...');
    final validationResult = _getValidationResult();
    print('📤 [SUBMIT] Validation result: ${validationResult.isValid ? "✅ VALID" : "❌ INVALID"}');

    if (!validationResult.isValid) {
      print('❌ [SUBMIT] Validation failed!');
      print('❌ [SUBMIT] First error: ${validationResult.firstError}');
      print('❌ [SUBMIT] All errors: ${validationResult.errors}');

      // Show first error in snackbar
      if (mounted && validationResult.firstError != null) {
        print('📤 [SUBMIT] Showing error snackbar...');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(validationResult.firstError!),
            backgroundColor: TossColors.error,
            duration: Duration(seconds: 3),
          ),
        );
      }
      print('📤 [SUBMIT] Returning early due to validation failure');
      return;
    }

    try {
      print('📤 [SUBMIT] Validation passed, continuing with submission...');

      // 2. Show loading state
      if (mounted) {
        print('📤 [SUBMIT] Step 2: Showing loading state (TODO)');
        // TODO: Show loading indicator
      }

      // 3. Parse amount
      print('📤 [SUBMIT] Step 3: Parsing amount...');
      final cleanAmount = _amountController.text.replaceAll(',', '').replaceAll(' ', '');
      print('📤 [SUBMIT] Raw amount: "${_amountController.text}"');
      print('📤 [SUBMIT] Cleaned amount: "$cleanAmount"');

      final amount = double.parse(cleanAmount);
      print('📤 [SUBMIT] Parsed amount: $amount');

      // 4. Create transaction from template
      print('📤 [SUBMIT] Step 4: Creating transaction via RPC...');
      await _createTransactionFromTemplate(amount);
      print('📤 [SUBMIT] Transaction creation completed');

      // 5. Success feedback
      print('📤 [SUBMIT] Step 5: Showing success feedback');
      if (mounted) {
        print('📤 [SUBMIT] Showing success snackbar...');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white),
                SizedBox(width: TossSpacing.space2),
                Text('Transaction created successfully'),
              ],
            ),
            backgroundColor: TossColors.success,
            duration: Duration(seconds: 2),
          ),
        );

        print('📤 [SUBMIT] Closing modal and returning success...');
        // Close modal and notify parent
        Navigator.of(context).pop(true); // Return true to indicate success
        print('✅ [SUBMIT] _handleSubmit() completed successfully');
      }

    } catch (e, stackTrace) {
      // 6. Error feedback
      print('❌ [SUBMIT] ERROR in _handleSubmit(): $e');
      print('❌ [SUBMIT] Stack trace: $stackTrace');

      if (mounted) {
        print('📤 [SUBMIT] Showing error snackbar...');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: TossColors.white),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text('Failed to create transaction: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            duration: Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: TossColors.white,
              onPressed: () => _handleSubmit(),
            ),
          ),
        );
      }
    }
  }
}