/// Transaction Template Usage Modal - Create transactions from saved templates
///
/// Purpose: Allows users to create transactions from templates with minimal input.
/// Handles complex templates with cash locations, counterparties, and debt tracking.
/// Supports attachment uploads for receipts and documents.
///
/// Keyboard Handling: Uses TossKeyboardAwareBottomSheet for proper keyboard management
///
/// Architecture:
/// - get_template_for_usage RPC: Analyzes template and returns UI configuration
/// - TemplateRpcService: Creates transactions via insert_journal_with_everything_utc RPC
/// Reference: docs/TEMPLATE_USAGE_REFACTORING_PLAN.md
///
/// Usage: TemplateUsageBottomSheet.show(context, template)
library;

import 'dart:async';

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart' as Legacy;
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
// Autonomous Selectors

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
// 🧮 Exchange rate calculator (Autonomous Selector)
import 'package:myfinance_improved/shared/widgets/selectors/exchange_rate/index.dart';

// ✅ Extracted widgets
import '../widgets/template_usage/template_usage_widgets.dart';

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

    final GlobalKey<_TemplateUsageBottomSheetState> formKey = GlobalKey();
    final buttonStateNotifier = ValueNotifier<bool>(false);
    final formValidityNotifier = ValueNotifier<bool>(false);

    final actionButtons = <Widget>[
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
                  context.pop();
                  final updated = await EditTemplateBottomSheet.show(context, template);
                  if (updated == true) {
                    // Template was updated
                  }
                },
              );
            },
          ),
        ),
      Expanded(
        flex: canEdit ? 2 : 1,
        child: ValueListenableBuilder<bool>(
          valueListenable: buttonStateNotifier,
          builder: (context, isSubmitting, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: formValidityNotifier,
              builder: (context, isFormValid, _) {
                final isButtonEnabled = isFormValid && !isSubmitting;

                return TossPrimaryButton(
                  text: isSubmitting ? 'Creating...' : 'Create Transaction',
                  fullWidth: true,
                  isEnabled: isButtonEnabled,
                  onPressed: !isButtonEnabled ? null : () async {
                    final state = formKey.currentState;
                    if (state != null) {
                      if (state.isSubmitting) return;
                      final isValid = state._isFormValid;
                      if (isValid) {
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

    return TossTextFieldKeyboardModal.show(
      context: context,
      title: templateName,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
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
  String? _selectedCounterpartyStoreId;
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
    _amountController.addListener(_validateAmountField);
    _amountController.addListener(_notifyValidityChange);
    _loadTemplateForUsage();
    _checkForMultipleCurrencies();
  }

  /// 🔧 RPC-based: Load template analysis from server
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
      setState(() => _hasMultipleCurrencies = false);
      return;
    }

    try {
      final exchangeRatesData = await ref.read(
        calculatorExchangeRateDataProvider(CalculatorExchangeRateParams(companyId: companyId)).future,
      );
      final exchangeRates = exchangeRatesData['exchange_rates'] as List? ?? [];

      if (mounted) {
        setState(() => _hasMultipleCurrencies = exchangeRates.length > 1);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _hasMultipleCurrencies = false);
      }
    }
  }

  /// Show exchange rate calculator bottom sheet
  void _showExchangeRateCalculator() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isDismissible: true,
      enableDrag: true,
      builder: (context) => ExchangeRateCalculator(
        initialAmount: _amountController.text.replaceAll(',', ''),
        onAmountSelected: (amount) {
          final formatter = NumberFormat('#,##0.##', 'en_US');
          final numericValue = double.tryParse(amount) ?? 0;
          setState(() {
            _amountController.text = formatter.format(numericValue);
          });
        },
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

  /// Check if template requires attachment
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
    if (_isLoadingRpc || _rpcResponse == null) return false;

    final amountError = TemplateFormValidator.validateAmountField(_amountController.text);
    if (amountError != null) return false;

    final uiConfig = _rpcResponse!.uiConfig;
    if (uiConfig == null) return false;

    if (uiConfig.showCashLocationSelector && _selectedMyCashLocationId == null) {
      return false;
    }

    if (uiConfig.showCounterpartySelector && _selectedCounterpartyId == null) {
      return false;
    }

    if (uiConfig.showCounterpartyStoreSelector && _selectedCounterpartyStoreId == null) {
      return false;
    }

    if (uiConfig.showCounterpartyCashLocationSelector && _selectedCounterpartyCashLocationId == null) {
      return false;
    }

    return _attachmentRequirementSatisfied;
  }

  /// Check if transaction is being created
  bool get isSubmitting => _isSubmitting;

  /// Get UI config helpers
  bool get _showCashLocationSelector => _rpcResponse?.uiConfig?.showCashLocationSelector ?? false;
  bool get _showCounterpartySelector => _rpcResponse?.uiConfig?.showCounterpartySelector ?? false;
  bool get _showCounterpartyStoreSelector => _rpcResponse?.uiConfig?.showCounterpartyStoreSelector ?? false;
  bool get _showCounterpartyCashLocationSelector => _rpcResponse?.uiConfig?.showCounterpartyCashLocationSelector ?? false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRpc) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_rpcError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: TossColors.error, size: 48),
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

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Template info card
            TemplateInfoCard(template: widget.template),

            const SizedBox(height: TossSpacing.space3),

            // Input section with blue border
            _buildInputSection(),

            const SizedBox(height: TossSpacing.space3),

            // Template details collapsible section
            TemplateDetailsSection(
              template: widget.template,
              isExpanded: _showTemplateDetails,
              onToggle: () => setState(() => _showTemplateDetails = !_showTemplateDetails),
            ),
          ],
        ),

        // Loading overlay when submitting
        if (_isSubmitting) const LoadingOverlay(),
      ],
    );
  }

  /// Builds input section with blue border
  Widget _buildInputSection() {
    final analysis = _rpcResponse?.analysis;
    final missingItems = analysis?.missingItems ?? [];
    final showGuidance = missingItems.isNotEmpty && missingItems.length <= 3;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputSectionHeader(showGuidance: showGuidance),
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
        // Amount field
        AmountField(
          controller: _amountController,
          errorText: _amountError,
          showCalculatorButton: _hasMultipleCurrencies,
          onCalculatorPressed: _showExchangeRateCalculator,
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Description field
        TossTextField(
          controller: _descriptionController,
          label: 'Note',
          hintText: 'Add a note (optional)',
          maxLines: 2,
        ),

        // Cash location selector
        if (_showCashLocationSelector) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCashLocationSelector(),
        ],

        // Counterparty selector (external)
        if (_showCounterpartySelector) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCounterpartySelector(),
        ],

        // Internal counterparty: Store selector
        if (_showCounterpartyStoreSelector && _selectedCounterpartyStoreId == null) ...[
          const SizedBox(height: TossSpacing.space3),
          CounterpartyStoreSelector(
            selectedStoreId: _selectedCounterpartyStoreId,
            linkedCompanyId: _rpcResponse?.uiConfig?.linkedCompanyId,
          ),
        ],

        // Internal counterparty: Cash location selector
        if (_showCounterpartyCashLocationSelector && _selectedCounterpartyCashLocationId == null) ...[
          const SizedBox(height: TossSpacing.space3),
          CounterpartyCashLocationSelector(
            selectedStoreId: _selectedCounterpartyStoreId,
            selectedCashLocationId: _selectedCounterpartyCashLocationId,
            onChanged: (cashLocationId) {
              setState(() => _selectedCounterpartyCashLocationId = cashLocationId);
              _notifyValidityChange();
            },
          ),
        ],

        // Attachments section
        const SizedBox(height: TossSpacing.space3),

        // Required attachment warning banner
        if (_requiresAttachment && !_attachmentRequirementSatisfied) ...[
          const AttachmentWarningBanner(),
          const SizedBox(height: TossSpacing.space2),
        ],

        TemplateAttachmentPickerSection(
          attachments: _pendingAttachments,
          onAttachmentsChanged: (attachments) {
            setState(() => _pendingAttachments = attachments);
            _notifyValidityChange();
          },
          canAddMore: _pendingAttachments.length < TemplateAttachment.maxAttachments,
          isRequired: _requiresAttachment,
        ),
      ],
    );
  }

  /// Builds cash location selector with validation - AutonomousCashLocationSelector
  Widget _buildCashLocationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Cash Location',
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
          selectedLocationId: _selectedMyCashLocationId,
          hint: 'Select cash location',
          hideLabel: true,
          onCashLocationSelected: (cashLocation) {
            setState(() {
              _selectedMyCashLocationId = cashLocation.id;
              _validateCashLocationField();
            });
          },
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
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      ],
    );
  }

  /// Builds counterparty selector with validation - AutonomousCounterpartySelector
  Widget _buildCounterpartySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Counterparty',
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
          hint: 'Select counterparty',
          isInternal: false, // External counterparties only
          hideLabel: true,
          onCounterpartySelected: (counterparty) {
            setState(() {
              _selectedCounterpartyId = counterparty.id;
              _validateCounterpartyField();
            });
          },
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
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      ],
    );
  }

  /// 🔧 REFACTORED: Creates transaction using TemplateRpcService
  Future<String> _createTransactionFromTemplate(double amount) async {
    final legacyAppState = ref.read(Legacy.appStateProvider);
    final user = ref.read(currentUserProvider);

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final companyId = legacyAppState.companyChoosen;
    final storeId = legacyAppState.storeChoosen;
    final userId = user.id;

    final rpcService = ref.read(templateRpcServiceProvider);

    final result = await rpcService.createTransaction(
      template: widget.template,
      amount: amount,
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      selectedCashLocationId: _selectedMyCashLocationId,
      selectedCounterpartyId: _selectedCounterpartyId,
      selectedCounterpartyStoreId: _selectedCounterpartyStoreId,
      selectedCounterpartyCashLocationId: _selectedCounterpartyCashLocationId,
      entryDate: DateTime.now(),
    );

    return result.when(
      success: (journalId, message, createdAt) async {
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
      },
      failure: (errorCode, errorMessage, fieldErrors, isRecoverable, technicalDetails) {
        String message = errorMessage;
        if (fieldErrors.isNotEmpty) {
          final fieldErrorMessages = fieldErrors
              .map((e) => '• ${e.fieldName}: ${e.message}')
              .join('\n');
          message = '$errorMessage\n\n$fieldErrorMessages';
        }
        throw Exception(message);
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    if (!_isFormValid) {
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
      setState(() => _isSubmitting = true);

      final cleanAmount = _amountController.text.replaceAll(',', '').replaceAll(' ', '');
      final amount = double.parse(cleanAmount);

      await _createTransactionFromTemplate(amount);

      if (mounted) {
        setState(() => _isSubmitting = false);

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

        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);

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
