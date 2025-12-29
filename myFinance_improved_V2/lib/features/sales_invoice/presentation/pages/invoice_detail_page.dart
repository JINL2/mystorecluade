import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/ai/ai_description_box.dart';
import '../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_detail.dart';
import '../providers/invoice_detail_provider.dart';
import '../widgets/invoice_attachment_section.dart';
import '../widgets/invoice_detail/created_by_section.dart';
import '../widgets/invoice_detail/invoice_confirmation_dialogs.dart';
import '../widgets/invoice_detail/payment_breakdown_section.dart';
import '../widgets/invoice_detail/payment_method_section.dart';
import '../widgets/invoice_detail/view_items_card.dart';

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
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
              ),
            )
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

                    // Refund Button (only for completed invoices)
                    if (invoice.isCompleted && widget.onRefundPressed != null)
                      _buildRefundButton(context),
                  ],
                ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
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
          ElevatedButton(
            onPressed: () {
              ref
                  .read(invoiceDetailNotifierProvider.notifier)
                  .loadDetail(invoice.invoiceId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
            child: const Text('Retry'),
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
        icon: const Icon(Icons.arrow_back, size: 24),
        onPressed: () => Navigator.of(context).pop(),
        color: TossColors.gray900,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoiceNumber,
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: 2),
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
            icon: const Icon(Icons.delete_outline, size: 24),
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
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.error,
            foregroundColor: TossColors.white,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.replay, size: 20),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Refund',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
