/// Transaction Template Usage Modal - Create transactions from saved templates
///
/// Purpose: Allows users to create transactions from templates with minimal input.
/// Handles complex templates with cash locations, counterparties, and debt tracking.
/// Supports attachment uploads for receipts and documents.
///
/// Architecture:
/// - Uses Riverpod Provider (TemplateUsageNotifier) for state management
/// - Provider-based state prevents "Looking up deactivated widget's ancestor" errors
/// - get_template_for_usage RPC: Analyzes template and returns UI configuration
/// - TemplateRpcService: Creates transactions via insert_journal_with_everything_utc RPC
///
/// Usage: TemplateUsageBottomSheet.show(context, template)
library;

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Provider
import '../providers/template_usage_provider.dart';
import '../providers/states/template_usage_state.dart';

// Domain
import '../../domain/entities/template_attachment.dart';

// Widgets
import '../widgets/template_attachment_picker_section.dart';
import '../widgets/template_usage/template_usage_widgets.dart';
import 'edit_template_bottom_sheet.dart';

/// Main Template Usage Bottom Sheet
class TemplateUsageBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> template;

  const TemplateUsageBottomSheet({
    super.key,
    required this.template,
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

    final templateId = template['template_id']?.toString() ?? '';

    return TossTextFieldKeyboardModal.show(
      context: context,
      title: templateName,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space3,
      ),
      content: TemplateUsageBottomSheet(
        template: template,
      ),
      actionButtons: [
        if (canEdit)
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final isSubmitting = ref.watch(templateUsageSubmittingProvider(templateId));
                return TossButton.secondary(
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
          child: Consumer(
            builder: (context, ref, _) {
              final isSubmitting = ref.watch(templateUsageSubmittingProvider(templateId));
              final isFormValid = ref.watch(templateUsageFormValidProvider(templateId));
              final isButtonEnabled = isFormValid && !isSubmitting;

              return TossButton.primary(
                text: isSubmitting ? 'Creating...' : 'Create Transaction',
                fullWidth: true,
                isEnabled: isButtonEnabled,
                onPressed: !isButtonEnabled ? null : () async {
                  final notifier = ref.read(templateUsageNotifierProvider(templateId).notifier);
                  final success = await notifier.submitTransaction(template);

                  if (success && context.mounted) {
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => TossDialog.success(
                        title: 'Transaction Created!',
                        message: 'Transaction created successfully',
                        primaryButtonText: 'Done',
                        onPrimaryPressed: () => ctx.pop(),
                      ),
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } else if (context.mounted) {
                    final state = ref.read(templateUsageNotifierProvider(templateId));
                    if (state.submitError != null) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (ctx) => TossDialog.error(
                          title: 'Transaction Failed',
                          message: state.submitError!,
                          primaryButtonText: 'OK',
                          onPrimaryPressed: () => ctx.pop(),
                        ),
                      );
                    }
                  }
                },
              );
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
  // Controllers still needed for TextField binding
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  String get _templateId => widget.template['template_id']?.toString() ?? '';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();

    // Initialize provider and load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(templateUsageNotifierProvider(_templateId).notifier);
      notifier.loadTemplateForUsage(widget.template);
      notifier.checkForMultipleCurrencies();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Show exchange rate calculator bottom sheet
  void _showExchangeRateCalculator() {
    final state = ref.read(templateUsageNotifierProvider(_templateId));
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black.withValues(alpha: 0.5),
      isDismissible: true,
      enableDrag: true,
      builder: (ctx) => ExchangeRateCalculator(
        initialAmount: state.amount.replaceAll(',', ''),
        onAmountSelected: (amount) {
          final formatter = NumberFormat('#,##0.##', 'en_US');
          final numericValue = double.tryParse(amount) ?? 0;
          final formattedAmount = formatter.format(numericValue);
          _amountController.text = formattedAmount;
          ref.read(templateUsageNotifierProvider(_templateId).notifier)
              .updateAmount(formattedAmount);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(templateUsageNotifierProvider(_templateId));

    if (state.isLoadingRpc) {
      return const Padding(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: TossLoadingView(),
      );
    }

    if (state.rpcError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: TossColors.error, size: 48),
              const SizedBox(height: TossSpacing.space3),
              Text(
                state.rpcError!,
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
            _buildInputSection(state),

            const SizedBox(height: TossSpacing.space3),

            // Template details collapsible section
            TemplateDetailsSection(
              template: widget.template,
              isExpanded: state.showTemplateDetails,
              onToggle: () => ref
                  .read(templateUsageNotifierProvider(_templateId).notifier)
                  .toggleTemplateDetails(),
            ),
          ],
        ),

        // Loading overlay when submitting
        if (state.isSubmitting) const LoadingOverlay(),
      ],
    );
  }

  /// Builds input section with blue border
  Widget _buildInputSection(TemplateUsageState state) {
    final analysis = state.rpcResponse?.analysis;
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
          _buildDynamicFields(state),
        ],
      ),
    );
  }

  /// Builds dynamic form fields based on RPC ui_config
  Widget _buildDynamicFields(TemplateUsageState state) {
    final notifier = ref.read(templateUsageNotifierProvider(_templateId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount field
        AmountField(
          controller: _amountController,
          errorText: state.amountError,
          showCalculatorButton: state.hasMultipleCurrencies,
          onCalculatorPressed: _showExchangeRateCalculator,
          onChanged: (value) => notifier.updateAmount(value),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Description field
        TossTextField(
          controller: _descriptionController,
          label: 'Note',
          hintText: 'Add a note (optional)',
          maxLines: 2,
          onChanged: (value) => notifier.updateDescription(value),
        ),

        // Cash location selector
        if (state.showCashLocationSelector) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCashLocationSelector(state),
        ],

        // Counterparty selector (external)
        if (state.showCounterpartySelector) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildCounterpartySelector(state),
        ],

        // Internal counterparty: Store selector
        if (state.showCounterpartyStoreSelector && state.selectedCounterpartyStoreId == null) ...[
          const SizedBox(height: TossSpacing.space3),
          CounterpartyStoreSelector(
            selectedStoreId: state.selectedCounterpartyStoreId,
            linkedCompanyId: state.rpcResponse?.uiConfig?.linkedCompanyId,
          ),
        ],

        // Internal counterparty: Cash location selector
        if (state.showCounterpartyCashLocationSelector && state.selectedCounterpartyCashLocationId == null) ...[
          const SizedBox(height: TossSpacing.space3),
          CounterpartyCashLocationSelector(
            selectedStoreId: state.selectedCounterpartyStoreId,
            selectedCashLocationId: state.selectedCounterpartyCashLocationId,
            onChanged: (cashLocationId) => notifier.selectCounterpartyCashLocation(cashLocationId),
          ),
        ],

        // Attachments section
        const SizedBox(height: TossSpacing.space3),

        // Required attachment warning banner
        if (state.requiresAttachment && !state.attachmentRequirementSatisfied) ...[
          const AttachmentWarningBanner(),
          const SizedBox(height: TossSpacing.space2),
        ],

        TemplateAttachmentPickerSection(
          attachments: state.pendingAttachments,
          onAttachmentsChanged: (attachments) => notifier.updateAttachments(attachments),
          canAddMore: state.pendingAttachments.length < TemplateAttachment.maxAttachments,
          isRequired: state.requiresAttachment,
        ),
      ],
    );
  }

  /// Builds cash location selector with validation
  Widget _buildCashLocationSelector(TemplateUsageState state) {
    final notifier = ref.read(templateUsageNotifierProvider(_templateId).notifier);

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
          selectedLocationId: state.selectedMyCashLocationId,
          hint: 'Select cash location',
          hideLabel: true,
          onCashLocationSelected: (cashLocation) {
            notifier.selectCashLocation(cashLocation.id);
          },
          onChanged: (cashLocationId) {
            notifier.selectCashLocation(cashLocationId);
          },
        ),
        if (state.cashLocationError != null) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            state.cashLocationError!,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      ],
    );
  }

  /// Builds counterparty selector with validation
  Widget _buildCounterpartySelector(TemplateUsageState state) {
    final notifier = ref.read(templateUsageNotifierProvider(_templateId).notifier);

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
          selectedCounterpartyId: state.selectedCounterpartyId,
          hint: 'Select counterparty',
          isInternal: false,
          hideLabel: true,
          onCounterpartySelected: (counterparty) {
            notifier.selectCounterparty(counterparty.id);
          },
          onChanged: (counterpartyId) {
            notifier.selectCounterparty(counterpartyId);
          },
        ),
        if (state.counterpartyError != null) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            state.counterpartyError!,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      ],
    );
  }
}
