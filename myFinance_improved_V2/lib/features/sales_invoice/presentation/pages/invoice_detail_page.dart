import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_dimensions.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/ai/ai_description_box.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_detail.dart';
import '../providers/invoice_attachment_provider.dart';
import '../providers/invoice_detail_provider.dart';
import '../widgets/invoice_attachment_section.dart';
import '../widgets/invoice_detail/created_by_section.dart';
import '../widgets/invoice_detail/invoice_confirmation_dialogs.dart';
import '../widgets/invoice_detail/payment_breakdown_section.dart';
import '../widgets/invoice_detail/payment_method_section.dart';
import '../widgets/invoice_detail/view_items_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Invoice Detail Page - Full page view for invoice details
///
/// Features:
/// - Loads invoice detail from RPC on init
/// - AppBar with invoice number, date/time/store info
/// - Collapsible "View items" card with actual item details
/// - Payment breakdown section (subtotal, discount, total)
/// - Payment method section with icon
/// - Created by section with avatar
/// - Refund action for completed invoices
class InvoiceDetailPage extends ConsumerStatefulWidget {
  final Invoice invoice;
  final String? currencySymbol;
  final void Function(Invoice invoice)? onRefundPressed;
  final void Function(Invoice invoice)? onDeletePressed;

  const InvoiceDetailPage({
    super.key,
    required this.invoice,
    this.currencySymbol,
    this.onRefundPressed,
    this.onDeletePressed,
  });

  /// Navigate to invoice detail page
  static void navigate(
    BuildContext context,
    Invoice invoice,
    String? currencySymbol, {
    void Function(Invoice invoice)? onRefundPressed,
    void Function(Invoice invoice)? onDeletePressed,
  }) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InvoiceDetailPage(
          invoice: invoice,
          currencySymbol: currencySymbol,
          onRefundPressed: onRefundPressed,
          onDeletePressed: onDeletePressed,
        ),
      ),
    );
  }

  @override
  ConsumerState<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends ConsumerState<InvoiceDetailPage> {
  String get _symbol => widget.currencySymbol ?? '';

  Invoice get invoice => widget.invoice;

  @override
  void initState() {
    super.initState();
    // Load invoice detail on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceDetailNotifierProvider.notifier).loadDetail(invoice.invoiceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(invoiceDetailNotifierProvider);
    final detail = detailState.detail;

    return TossScaffold(
      appBar: _buildAppBar(context, detail),
      body: detailState.isLoading
          ? const TossLoadingView()
          : detailState.error != null
              ? _buildErrorState(detailState.error!)
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // View Items Card (Collapsible)
                            Padding(
                              padding: const EdgeInsets.all(TossSpacing.space4),
                              child: ViewItemsCard(
                                invoice: invoice,
                                detail: detail,
                                currencySymbol: _symbol,
                              ),
                            ),

                            // Gray divider before Payment breakdown
                            const GrayDividerSpace(),

                            // Payment Breakdown Section
                            PaymentBreakdownSection(
                              invoice: invoice,
                              detail: detail,
                              currencySymbol: _symbol,
                            ),

                            // Gray divider before Payment method
                            const GrayDividerSpace(),

                            // Payment Method Section
                            PaymentMethodSection(
                              invoice: invoice,
                              detail: detail,
                            ),

                            // Gray divider before Created by
                            const GrayDividerSpace(),

                            // Created By Section
                            CreatedBySection(
                              invoice: invoice,
                              detail: detail,
                            ),

                            // AI Description Section (if available)
                            if (detail?.hasAiDescription == true) ...[
                              const GrayDividerSpace(),
                              _buildAiDescriptionSection(detail!),
                            ],

                            // Attachments Section (always show for adding images)
                            const GrayDividerSpace(),
                            _buildAttachmentsSection(detail),

                            const SizedBox(height: TossSpacing.space6),
                          ],
                        ),
                      ),
                    ),

                    // Bottom buttons area
                    _buildBottomButtons(context),
                  ],
                ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: TossDimensions.errorIconSize,
            color: TossColors.error,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Error loading invoice',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Text(
              error,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          TossButton.primary(
            text: 'Retry',
            onPressed: () {
              ref
                  .read(invoiceDetailNotifierProvider.notifier)
                  .loadDetail(invoice.invoiceId);
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, InvoiceDetail? detail) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    final saleDate = detail?.saleDate ?? invoice.saleDate;
    final storeName = detail?.storeName ?? invoice.storeName;
    final invoiceNumber = detail?.invoiceNumber ?? invoice.invoiceNumber;

    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: TossSpacing.iconMD2),
        onPressed: () => Navigator.of(context).pop(),
        color: TossColors.gray900,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoiceNumber,
            style: TossTextStyles.body.copyWith(
              fontWeight: TossFontWeight.semibold,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space0_5),
          Text(
            '${dateFormat.format(saleDate)} · ${timeFormat.format(saleDate)} · $storeName',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        if (widget.onDeletePressed != null && !invoice.isCancelled)
          IconButton(
            icon: Icon(Icons.delete_outline, size: TossSpacing.iconMD2),
            onPressed: () => InvoiceConfirmationDialogs.showDeleteConfirmation(
              context,
              invoice: invoice,
              onConfirm: () {
                Navigator.pop(context); // Close page
                widget.onDeletePressed?.call(invoice);
              },
            ),
            color: TossColors.gray600,
          ),
      ],
    );
  }

  Widget _buildAiDescriptionSection(InvoiceDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: AiDescriptionBox(text: detail.aiDescription ?? ''),
    );
  }

  Widget _buildAttachmentsSection(InvoiceDetail? detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: InvoiceAttachmentSection(
        existingAttachments: detail?.validAttachments ?? [],
      ),
    );
  }

  /// Build bottom buttons area based on state
  Widget _buildBottomButtons(BuildContext context) {
    final attachmentState = ref.watch(invoiceAttachmentNotifierProvider);
    final hasPendingAttachments = attachmentState.hasPendingAttachments;
    final isUploading = attachmentState.isUploading;

    // If has pending attachments, show confirm button
    if (hasPendingAttachments) {
      return _buildConfirmAttachmentsButton(context, isUploading);
    }

    // Otherwise show refund button (if applicable)
    if (invoice.isCompleted && !invoice.isCancelled && widget.onRefundPressed != null) {
      return _buildRefundButton(context);
    }

    return const SizedBox.shrink();
  }

  /// Build confirm button for saving pending attachments
  Widget _buildConfirmAttachmentsButton(BuildContext context, bool isUploading) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space3 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: TossButton.primary(
        text: isUploading ? 'Saving...' : 'Confirm',
        onPressed: isUploading ? null : () => _saveAttachments(context),
        leadingIcon: isUploading
            ? TossLoadingView.inline(size: TossSpacing.iconMD, color: TossColors.white)
            : Icon(Icons.check, size: TossSpacing.iconMD, color: TossColors.white),
        fullWidth: true,
      ),
    );
  }

  /// Save pending attachments
  Future<void> _saveAttachments(BuildContext context) async {
    HapticFeedback.mediumImpact();

    final detailState = ref.read(invoiceDetailNotifierProvider);
    final detail = detailState.detail;
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (detail == null || detail.journalId == null) {
      TossToast.error(context, 'Invoice detail not loaded');
      return;
    }

    if (companyId.isEmpty) {
      TossToast.error(context, 'Company not selected');
      return;
    }

    final success = await ref
        .read(invoiceAttachmentNotifierProvider.notifier)
        .uploadAttachments(
          companyId: companyId,
          journalId: detail.journalId!,
          userId: detail.createdById ?? '',
        );

    if (!mounted) return;

    if (success) {
      TossToast.success(context, 'Images saved successfully');
      // Reload invoice detail to show saved attachments
      ref.read(invoiceDetailNotifierProvider.notifier).loadDetail(invoice.invoiceId);
    } else {
      final errorMessage = ref.read(invoiceAttachmentNotifierProvider).errorMessage;
      TossToast.error(context, errorMessage ?? 'Failed to save images');
    }
  }

  Widget _buildRefundButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space3 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: TossButton.destructive(
        text: 'Refund',
        onPressed: () {
          HapticFeedback.mediumImpact();
          InvoiceConfirmationDialogs.showRefundConfirmation(
            context,
            invoice: invoice,
            currencySymbol: _symbol,
            onConfirm: () {
              Navigator.pop(context); // Close page
              widget.onRefundPressed?.call(invoice);
            },
          );
        },
        leadingIcon: Icon(Icons.replay, size: TossSpacing.iconMD, color: TossColors.white),
        fullWidth: true,
      ),
    );
  }
}
