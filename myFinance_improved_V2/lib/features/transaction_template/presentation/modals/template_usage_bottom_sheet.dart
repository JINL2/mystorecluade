/// Transaction Template Usage Modal - Create transactions from saved templates
///
/// Purpose: Allows users to create transactions from templates with minimal input.
/// Handles complex templates with cash locations, counterparties, and debt tracking.
/// Supports attachment uploads for receipts and documents.
///
/// Keyboard Handling: Uses TossKeyboardAwareBottomSheet for proper keyboard management
///
/// 🔧 REFACTORED: Now uses RPC-based approach
/// - get_template_for_usage: Analyzes template and returns UI configuration
/// - create_transaction_from_template: Validates and creates transaction
/// Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md
///
/// Usage: TemplateUsageBottomSheet.show(context, template)
library;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart' as Legacy;
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_cash_location_selector.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_counterparty_selector.dart';
import 'package:myfinance_improved/shared/widgets/toss/keyboard/toss_textfield_keyboard_modal.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';

// ✅ Clean Architecture: Domain layer entities
import '../../domain/entities/template_attachment.dart';
import '../../domain/validators/template_form_validator.dart';
// 🔧 RPC-based: DTO from Data layer
import '../../data/dtos/template_usage_response_dto.dart';
import '../../data/providers/repository_providers.dart';
// ✅ Clean Architecture: Provider from Presentation layer
import '../providers/use_case_providers.dart';
import '../widgets/template_attachment_picker_section.dart';
import 'edit_template_bottom_sheet.dart';
// 🧮 Exchange rate calculator
import '../../../journal_input/presentation/widgets/exchange_rate_calculator.dart';
import '../../../journal_input/presentation/providers/journal_input_providers.dart';

/// Custom TextInputFormatter for thousand separators (000,000 format)
class ThousandSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty input
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Handle decimal numbers
    final parts = cleanText.split('.');
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    // Parse and format integer part
    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    final intValue = int.tryParse(integerPart) ?? 0;
    String formattedText = _formatter.format(intValue);

    // Add decimal part if exists
    if (decimalPart != null) {
      formattedText = '$formattedText.$decimalPart';
    }

    // Calculate new cursor position
    int cursorOffset = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
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

// Main Template Usage Bottom Sheet
class TemplateUsageBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> template;
  /// Callback to notify parent when form validity changes
  final ValueChanged<bool>? onValidityChanged;

  const TemplateUsageBottomSheet({
    super.key,
    required this.template,
    this.onValidityChanged,
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
  
  static Future<void> show(
    BuildContext context,
    Map<String, dynamic> template, {
    bool canEdit = false,
  }) {
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

    // Track button state for loading indicator
    final buttonStateNotifier = ValueNotifier<bool>(false);

    // Track form validity for button enabled state
    final formValidityNotifier = ValueNotifier<bool>(false);

    // Build action buttons based on permission
    final actionButtons = <Widget>[
      // Edit button (only shown if user has permission)
      if (canEdit)
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: buttonStateNotifier,
            builder: (context, isSubmitting, _) {
              return TossSecondaryButton(
                text: 'Edit',
                fullWidth: true,
                isEnabled: !isSubmitting,
                onPressed: isSubmitting ? null : () async {
                  // Close current modal and open edit modal
                  context.pop();
                  final updated = await EditTemplateBottomSheet.show(context, template);
                  if (updated == true) {
                    // Template was updated, could refresh the list here if needed
                  }
                },
              );
            },
          ),
        ),
      // Create Transaction button
      Expanded(
        flex: canEdit ? 2 : 1,
        child: ValueListenableBuilder<bool>(
          valueListenable: buttonStateNotifier,
          builder: (context, isSubmitting, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: formValidityNotifier,
              builder: (context, isFormValid, _) {
                // 🔧 FIXED: Button is disabled when form is invalid OR submitting
                final isButtonEnabled = isFormValid && !isSubmitting;

                return TossPrimaryButton(
                  text: isSubmitting ? 'Creating...' : 'Create Transaction',
                  fullWidth: true,
                  isEnabled: isButtonEnabled,
                  onPressed: !isButtonEnabled ? null : () async {
                    // Get the form state and submit
                    final state = formKey.currentState;

                    if (state != null) {
                      // 🔒 Check if already submitting
                      if (state.isSubmitting) return;

                      final isValid = state._isFormValid;

                      if (isValid) {
                        // Update button state
                        buttonStateNotifier.value = true;
                        await state._handleSubmit();
                        buttonStateNotifier.value = false;
                      }
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    ];

    // Use TossTextFieldKeyboardModal with action buttons
    return TossTextFieldKeyboardModal.show(
      context: context,
      title: templateName,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,  // ✅ Reduced: 12px instead of default 16px
        vertical: TossSpacing.space3,
      ),
      content: TemplateUsageBottomSheet(
        key: formKey,
        template: template,
        onValidityChanged: (isValid) {
          formValidityNotifier.value = isValid;
        },
      ),
      actionButtons: actionButtons,
    );
  }

  @override
  ConsumerState<TemplateUsageBottomSheet> createState() => _TemplateUsageBottomSheetState();
}

class _TemplateUsageBottomSheetState extends ConsumerState<TemplateUsageBottomSheet> {
  // 🔧 RPC-based: Template usage response from server
  TemplateUsageResponseDto? _rpcResponse;
  bool _isLoadingRpc = true;
  String? _rpcError;

  // Controllers and state variables
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dynamic selection state
  String? _selectedMyCashLocationId;
  String? _selectedCounterpartyId;
  String? _selectedCounterpartyStoreId; // 🆕 For internal counterparty
  String? _selectedCounterpartyCashLocationId;
  bool _showTemplateDetails = false;

  // 🔧 ENHANCED: Real-time validation state
  String? _amountError;
  String? _cashLocationError;
  String? _counterpartyError;

  // 📎 Attachment state
  List<TemplateAttachment> _pendingAttachments = [];

  // 🔄 Loading state for transaction creation
  bool _isSubmitting = false;

  // 🧮 Multiple currencies check for calculator button
  bool _hasMultipleCurrencies = false;

  @override
  void initState() {
    super.initState();

    // Add listeners for real-time validation
    _amountController.addListener(_validateAmountField);
    _amountController.addListener(_notifyValidityChange);

    // 🔧 RPC-based: Load template analysis from server
    _loadTemplateForUsage();

    // Check for multiple currencies (for calculator button)
    _checkForMultipleCurrencies();
  }

  /// 🔧 RPC-based: Load template analysis from server
  /// Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md Section 4.2
  Future<void> _loadTemplateForUsage() async {
    try {
      final appState = ref.read(Legacy.appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      final templateId = widget.template['template_id']?.toString() ?? '';

      if (templateId.isEmpty || companyId.isEmpty) {
        setState(() {
          _isLoadingRpc = false;
          _rpcError = 'Invalid template or company ID';
        });
        return;
      }

      final dataSource = ref.read(templateDataSourceProvider);
      final response = await dataSource.getTemplateForUsage(
        templateId: templateId,
        companyId: companyId,
        storeId: storeId.isNotEmpty ? storeId : null,
      );

      if (!mounted) return;

      if (!response.success) {
        setState(() {
          _isLoadingRpc = false;
          _rpcError = response.message ?? 'Failed to load template';
        });
        return;
      }

      // Initialize defaults from RPC response
      final defaults = response.defaults;
      if (defaults != null) {
        _selectedMyCashLocationId = defaults.cashLocationId;
        _selectedCounterpartyId = defaults.counterpartyId;
        _selectedCounterpartyStoreId = defaults.counterpartyStoreId;
        _selectedCounterpartyCashLocationId = defaults.counterpartyCashLocationId;
      }

      setState(() {
        _rpcResponse = response;
        _isLoadingRpc = false;
      });

      // Notify parent of initial form validity
      _notifyValidityChange();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRpc = false;
          _rpcError = 'Error loading template: ${e.toString()}';
        });
      }
    }
  }

  /// Check if company has multiple currencies for exchange rate calculator
  Future<void> _checkForMultipleCurrencies() async {
    final appState = ref.read(Legacy.appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      setState(() {
        _hasMultipleCurrencies = false;
      });
      return;
    }

    try {
      final exchangeRatesData = await ref.read(exchangeRatesProvider(companyId).future);
      final exchangeRates = exchangeRatesData['exchange_rates'] as List? ?? [];

      if (mounted) {
        setState(() {
          _hasMultipleCurrencies = exchangeRates.length > 1;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasMultipleCurrencies = false;
        });
      }
    }
  }

  /// Show exchange rate calculator bottom sheet
  void _showExchangeRateCalculator() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      isDismissible: true,
      enableDrag: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ExchangeRateCalculator(
          initialAmount: _amountController.text.replaceAll(',', ''),
          onAmountSelected: (amount) {
            final formatter = NumberFormat('#,##0.##', 'en_US');
            final numericValue = double.tryParse(amount) ?? 0;
            setState(() {
              _amountController.text = formatter.format(numericValue);
            });
          },
        ),
      ),
    );
  }

  /// Notify parent of form validity changes
  void _notifyValidityChange() {
    widget.onValidityChanged?.call(_isFormValid);
  }

  /// Real-time amount field validation
  void _validateAmountField() {
    setState(() {
      _amountError = TemplateFormValidator.validateAmountField(_amountController.text);
    });
  }

  /// Real-time cash location validation
  void _validateCashLocationField() {
    final uiConfig = _rpcResponse?.uiConfig;
    setState(() {
      if (uiConfig?.showCashLocationSelector == true && _selectedMyCashLocationId == null) {
        _cashLocationError = 'Cash location is required';
      } else {
        _cashLocationError = null;
      }
    });
    _notifyValidityChange();
  }

  /// Real-time counterparty validation
  void _validateCounterpartyField() {
    final uiConfig = _rpcResponse?.uiConfig;
    setState(() {
      if (uiConfig?.showCounterpartySelector == true && _selectedCounterpartyId == null) {
        _counterpartyError = 'Counterparty is required';
      } else {
        _counterpartyError = null;
      }
    });
    _notifyValidityChange();
  }

  /// Check if template requires attachment (from RPC response)
  bool get _requiresAttachment {
    return _rpcResponse?.template?.requiredAttachment ??
           widget.template['required_attachment'] == true;
  }

  /// Check if attachment requirement is satisfied
  bool get _attachmentRequirementSatisfied {
    if (!_requiresAttachment) return true;
    return _pendingAttachments.isNotEmpty;
  }

  /// 🔧 RPC-based: Comprehensive form validation using RPC uiConfig
  bool get _isFormValid {
    // Still loading
    if (_isLoadingRpc || _rpcResponse == null) return false;

    // Amount validation (keep client-side for UX)
    final amountError = TemplateFormValidator.validateAmountField(_amountController.text);
    if (amountError != null) return false;

    final uiConfig = _rpcResponse!.uiConfig;
    if (uiConfig == null) return false;

    // Cash location validation
    if (uiConfig.showCashLocationSelector && _selectedMyCashLocationId == null) {
      return false;
    }

    // Counterparty validation (external)
    if (uiConfig.showCounterpartySelector && _selectedCounterpartyId == null) {
      return false;
    }

    // Counterparty store validation (internal)
    if (uiConfig.showCounterpartyStoreSelector && _selectedCounterpartyStoreId == null) {
      return false;
    }

    // Counterparty cash location validation (internal)
    if (uiConfig.showCounterpartyCashLocationSelector && _selectedCounterpartyCashLocationId == null) {
      return false;
    }

    // Attachment requirement
    return _attachmentRequirementSatisfied;
  }

  /// Check if transaction is being created (for loading indicator)
  bool get isSubmitting => _isSubmitting;

  /// Get UI config helpers
  bool get _showCashLocationSelector => _rpcResponse?.uiConfig?.showCashLocationSelector ?? false;
  bool get _showCounterpartySelector => _rpcResponse?.uiConfig?.showCounterpartySelector ?? false;
  bool get _showCounterpartyStoreSelector => _rpcResponse?.uiConfig?.showCounterpartyStoreSelector ?? false;
  bool get _showCounterpartyCashLocationSelector => _rpcResponse?.uiConfig?.showCounterpartyCashLocationSelector ?? false;
  bool get _counterpartyIsLocked => _rpcResponse?.uiConfig?.counterpartyIsLocked ?? false;
  String? get _lockedCounterpartyName => _rpcResponse?.uiConfig?.lockedCounterpartyName;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔧 RPC-based: Show loading state
    if (_isLoadingRpc) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 🔧 RPC-based: Show error state
    if (_rpcError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: TossColors.error,
                size: 48,
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                _rpcError!,
                style: TossTextStyles.body.copyWith(color: TossColors.gray700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // ✅ No padding here - parent TossTextFieldKeyboardModal handles it
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔧 ENHANCED: Template info card (Legacy style)
            _buildTemplateInfoCard(),

            const SizedBox(height: TossSpacing.space3),

            // 🔧 ENHANCED: "Just enter these:" section with blue border (Legacy style)
            _buildInputSection(),

            const SizedBox(height: TossSpacing.space3),

            // 🔧 ENHANCED: Template details collapsible section
            _buildTemplateDetailsSection(),
          ],
        ),

        // 🔄 Loading overlay when submitting
        if (_isSubmitting)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'Creating transaction...',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds template info card (Legacy style with icon)
  Widget _buildTemplateInfoCard() {
    final data = widget.template['data'] as List? ?? [];
    if (data.isEmpty) return const SizedBox.shrink();

    final debit = data.firstWhere((e) => e['type'] == 'debit', orElse: () => <String, dynamic>{});
    final credit = data.firstWhere((e) => e['type'] == 'credit', orElse: () => <String, dynamic>{});

    final debitTag = debit['category_tag']?.toString() ?? '';
    final creditTag = credit['category_tag']?.toString() ?? '';

    if (debitTag.isEmpty || creditTag.isEmpty) return const SizedBox.shrink();

    // Get template name from widget
    final templateName = widget.template['name']?.toString() ?? 'Template';

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          // 📋 Template icon (blue)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: TossColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
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
                const SizedBox(height: TossSpacing.space1),
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
    // 🔧 RPC-based: Check if guidance should be shown
    final analysis = _rpcResponse?.analysis;
    final missingItems = analysis?.missingItems ?? [];
    final showGuidance = missingItems.isNotEmpty && missingItems.length <= 3;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: TossColors.primary.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✏️ "Just enter these:" header (Legacy style)
          if (showGuidance) ...[
            Row(
              children: [
                const Icon(
                  Icons.edit,
                  color: TossColors.primary,
                  size: 20,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Just enter these:',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
          ],

          // Dynamic form fields
          _buildDynamicFields(),
        ],
      ),
    );
  }

  /// 🔧 RPC-based: Builds dynamic form fields based on RPC ui_config
  Widget _buildDynamicFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount field (always required)
        _buildAmountField(),

        const SizedBox(height: TossSpacing.space3),

        // Description field (optional)
        _buildDescriptionField(),

        // Cash location selector (if needed - from RPC ui_config)
        if (_showCashLocationSelector) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCashLocationSelector(),
        ],

        // Counterparty section (from RPC ui_config):
        // - Internal counterparty: NO display needed (already saved in template)
        // - External counterparty (showCounterpartySelector): show selector
        if (_showCounterpartySelector) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCounterpartySelector(),
        ],

        // 🆕 Internal counterparty: Store selector (only if NOT already set in defaults)
        if (_showCounterpartyStoreSelector && _selectedCounterpartyStoreId == null) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCounterpartyStoreSelector(),
        ],

        // 🆕 Internal counterparty: Cash location selector (only if NOT already set in defaults)
        if (_showCounterpartyCashLocationSelector && _selectedCounterpartyCashLocationId == null) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCounterpartyCashLocationSelector(),
        ],

        // 📎 Attachments section
        const SizedBox(height: TossSpacing.space3),

        // ⚠️ Required attachment warning banner
        if (_requiresAttachment && !_attachmentRequirementSatisfied) ...[
          _buildAttachmentWarningBanner(),
          const SizedBox(height: TossSpacing.space2),
        ],

        TemplateAttachmentPickerSection(
          attachments: _pendingAttachments,
          onAttachmentsChanged: (attachments) {
            setState(() {
              _pendingAttachments = attachments;
            });
            // 🔧 FIXED: Notify parent when attachment changes affect form validity
            _notifyValidityChange();
          },
          canAddMore: _pendingAttachments.length < TemplateAttachment.maxAttachments,
          isRequired: _requiresAttachment,
        ),
      ],
    );
  }

  /// Builds amount input field with validation and optional calculator button
  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TossTextField(
                controller: _amountController,
                label: 'Amount',
                isRequired: true, // 🔧 Shows red asterisk
                hintText: 'Enter amount (e.g., 1,000,000)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                  ThousandSeparatorInputFormatter(),
                ],
                onChanged: (value) {
                  // Real-time validation happens via listener
                  setState(() {});
                },
              ),
            ),
            // 🧮 Exchange rate calculator button (only if multiple currencies)
            if (_hasMultipleCurrencies) ...[
              const SizedBox(width: TossSpacing.space2),
              Container(
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: TossColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: TossColors.transparent,
                  child: InkWell(
                    onTap: _showExchangeRateCalculator,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space3),
                      child: const Icon(
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
        if (_amountError != null) ...[
          const SizedBox(height: TossSpacing.space1),
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
              // Match TossTextField label style
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        AutonomousCashLocationSelector(
          storeId: storeId,
          selectedLocationId: _selectedMyCashLocationId,
          // Hide built-in label since we render our own styled label above
          hideLabel: true,
          onChanged: (cashLocationId) {
            setState(() {
              _selectedMyCashLocationId = cashLocationId;
              _validateCashLocationField();
            });
          },
        ),
        if (_cashLocationError != null) ...[
          const SizedBox(height: TossSpacing.space1),
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

  /// Builds counterparty selector with validation
  Widget _buildCounterpartySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Counterparty',
              // Match TossTextField label style
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        AutonomousCounterpartySelector(
          selectedCounterpartyId: _selectedCounterpartyId,
          // External template = show only external counterparties
          // This prevents selecting internal companies for external transactions
          isInternal: false,
          // Hide built-in label since we render our own styled label above
          hideLabel: true,
          onChanged: (counterpartyId) {
            setState(() {
              _selectedCounterpartyId = counterpartyId;
              _validateCounterpartyField();
            });
          },
        ),
        if (_counterpartyError != null) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            _counterpartyError!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds locked counterparty display for internal counterparties
  /// Internal counterparties cannot be changed because they require
  /// counterparty_cash_location_id which is already set in the template
  Widget _buildLockedCounterpartyDisplay() {
    final counterpartyName = _lockedCounterpartyName ??
                             _rpcResponse?.defaults?.counterpartyName ??
                             'Internal Counterparty';

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
            const SizedBox(width: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 12,
                    color: TossColors.gray500,
                  ),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    'Internal',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            border: Border.all(color: TossColors.gray200),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: const Icon(
                  Icons.business,
                  color: TossColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      counterpartyName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      'Linked company account',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.lock,
                color: TossColors.gray400,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🆕 Builds counterparty store selector for internal counterparties
  Widget _buildCounterpartyStoreSelector() {
    final linkedCompanyId = _rpcResponse?.uiConfig?.linkedCompanyId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Counterparty Store',
              // Match TossTextField label style
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        // TODO: Implement AutonomousStoreSelector for linked company
        // For now, show a placeholder that indicates store selection is needed
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            border: Border.all(color: TossColors.gray300),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              const Icon(Icons.store_outlined, color: TossColors.gray500),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  _selectedCounterpartyStoreId != null
                      ? 'Store selected'
                      : 'Select counterparty store',
                  style: TossTextStyles.body.copyWith(
                    color: _selectedCounterpartyStoreId != null
                        ? TossColors.gray900
                        : TossColors.gray500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: TossColors.gray400),
            ],
          ),
        ),
        if (linkedCompanyId != null)
          Padding(
            padding: const EdgeInsets.only(top: TossSpacing.space1),
            child: Text(
              'Select a store from the linked company',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
          ),
      ],
    );
  }

  /// 🆕 Builds counterparty cash location selector for internal counterparties
  Widget _buildCounterpartyCashLocationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Counterparty Cash Location',
              // Match TossTextField label style
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        // For counterparty cash location, we need the store to be selected first
        if (_selectedCounterpartyStoreId == null)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              border: Border.all(color: TossColors.gray300),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_outlined, color: TossColors.gray400),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Select store first',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray400),
                ),
              ],
            ),
          )
        else
          AutonomousCashLocationSelector(
            storeId: _selectedCounterpartyStoreId!,
            selectedLocationId: _selectedCounterpartyCashLocationId,
            // Hide built-in label since we render our own styled label above
            hideLabel: true,
            onChanged: (cashLocationId) {
              setState(() {
                _selectedCounterpartyCashLocationId = cashLocationId;
              });
              _notifyValidityChange();
            },
          ),
      ],
    );
  }

  /// Builds required attachment warning banner
  Widget _buildAttachmentWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.warning.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: TossColors.warning,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'This template requires an attachment (receipt, invoice, etc.)',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds template details collapsible section
  Widget _buildTemplateDetailsSection() {
    final data = widget.template['data'] as List? ?? [];
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _showTemplateDetails = !_showTemplateDetails),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
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
                    const Icon(
                      Icons.info_outline,
                      color: TossColors.gray600,
                      size: 20,
                    ),
                    const SizedBox(width: TossSpacing.space2),
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
          const SizedBox(height: TossSpacing.space3),
          // Constrain height to prevent overflow over buttons
          ConstrainedBox(
            constraints: const BoxConstraints(
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

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
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
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              children: [
                // DEBIT/CREDIT badge
                Container(
                  padding: const EdgeInsets.symmetric(
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
                const SizedBox(width: TossSpacing.space3),
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
                        const SizedBox(height: TossSpacing.space1),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.space1),
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
                        const SizedBox(height: TossSpacing.space1),
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 14,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.space1),
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
                        const SizedBox(height: TossSpacing.space1),
                        Row(
                          children: [
                            const Icon(
                              Icons.store_outlined,
                              size: 14,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.space1),
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
                        const SizedBox(height: TossSpacing.space1),
                        Row(
                          children: [
                            const Icon(
                              Icons.account_balance_outlined,
                              size: 14,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.space1),
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
  
  /// 🔧 RPC-based: Creates transaction using create_transaction_from_template RPC
  /// Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md Section 3.2
  /// Returns the created journal ID for attachment uploads
  Future<String> _createTransactionFromTemplate(double amount) async {
    // Get app state for company/user/store IDs
    final legacyAppState = ref.read(Legacy.appStateProvider);
    final user = ref.read(currentUserProvider);

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final companyId = legacyAppState.companyChoosen;
    final storeId = legacyAppState.storeChoosen;
    final userId = user.id;
    final templateId = widget.template['template_id']?.toString() ?? '';

    if (templateId.isEmpty) {
      throw Exception('Template ID is missing');
    }

    // 🔧 RPC-based: Call create_transaction_from_template RPC
    final dataSource = ref.read(templateDataSourceProvider);
    final response = await dataSource.createTransactionFromTemplate(
      templateId: templateId,
      amount: amount,
      companyId: companyId,
      userId: userId,
      storeId: storeId.isNotEmpty ? storeId : null,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      selectedCashLocationId: _selectedMyCashLocationId,
      selectedCounterpartyId: _selectedCounterpartyId,
      selectedCounterpartyStoreId: _selectedCounterpartyStoreId,
      selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
      entryDate: DateTime.now(),
    );

    // Check RPC response
    if (!response.success) {
      // Handle specific error types
      final errorType = response.error;
      final message = response.message ?? 'Transaction creation failed';
      final field = response.field;

      if (errorType == 'account_mapping_required') {
        throw Exception('$message\n\nPlease set up account mapping first.');
      } else if (errorType == 'validation_error' && field != null) {
        throw Exception('$message (Field: $field)');
      } else {
        throw Exception(message);
      }
    }

    final journalId = response.journalId;
    if (journalId == null || journalId.isEmpty) {
      throw Exception('Journal ID not returned from RPC');
    }

    // Upload attachments if any
    if (_pendingAttachments.isNotEmpty) {
      final pendingFiles = _pendingAttachments
          .where((a) => a.localFile != null)
          .map((a) => a.localFile!)
          .toList();

      if (pendingFiles.isNotEmpty) {
        final uploadAttachments = ref.read(uploadTemplateAttachmentsProvider);
        await uploadAttachments(companyId, journalId, userId, pendingFiles);
      }
    }

    return journalId;
  }

  Future<void> _handleSubmit() async {
    // 🔧 RPC-based: Server-side validation with client-side UX feedback

    // Prevent double submission
    if (_isSubmitting) return;

    // 1. Client-side validation for UX (quick feedback)
    if (!_isFormValid) {
      // Show appropriate error based on what's missing
      String errorMessage = 'Please fill in all required fields';

      final amountError = TemplateFormValidator.validateAmountField(_amountController.text);
      if (amountError != null) {
        errorMessage = amountError;
      } else if (_showCashLocationSelector && _selectedMyCashLocationId == null) {
        errorMessage = 'Please select a cash location';
      } else if (_showCounterpartySelector && _selectedCounterpartyId == null) {
        errorMessage = 'Please select a counterparty';
      } else if (_showCounterpartyStoreSelector && _selectedCounterpartyStoreId == null) {
        errorMessage = 'Please select a counterparty store';
      } else if (_showCounterpartyCashLocationSelector && _selectedCounterpartyCashLocationId == null) {
        errorMessage = 'Please select a counterparty cash location';
      } else if (!_attachmentRequirementSatisfied) {
        errorMessage = 'Attachment is required for this template';
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Validation Error',
            message: errorMessage,
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
      return;
    }

    try {
      // 2. Show loading state
      setState(() {
        _isSubmitting = true;
      });

      // 3. Parse amount
      final cleanAmount = _amountController.text.replaceAll(',', '').replaceAll(' ', '');
      final amount = double.parse(cleanAmount);

      // 4. Create transaction from template via RPC (server validates everything)
      await _createTransactionFromTemplate(amount);

      // 5. Success feedback
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Transaction Created!',
            message: 'Transaction created successfully',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );

        // Close modal and notify parent
        Navigator.of(context).pop(true); // Return true to indicate success
      }

    } catch (e) {
      // 6. Error feedback
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Transaction Failed',
            message: e.toString().replaceFirst('Exception: ', ''),
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    }
  }
}