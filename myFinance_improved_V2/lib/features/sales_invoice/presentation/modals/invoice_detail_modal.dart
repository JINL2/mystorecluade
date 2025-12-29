// lib/features/sales_invoice/presentation/modals/invoice_detail_modal.dart
//
// Invoice Detail Modal - Bottom sheet for invoice details
// Refactored following Clean Architecture 2025 - Single Responsibility Principle
//
// Extracted components:
// - ModalHeaderSection: Handle bar, invoice info, close button
// - QuickSummaryCard: Total amount and status display
// - ModalInfoCard: Reusable info cards (Customer, Items, Payment, Store, Created By)
// - RefundConfirmationDialog: Refund confirmation dialog
// - ModalRefundButton: Bottom refund button

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/widgets/ai/ai_description_box.dart';
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../domain/entities/invoice.dart';
import 'components/modal_header_section.dart';
import 'components/modal_info_card.dart';
import 'components/modal_refund_button.dart';
import 'components/quick_summary_card.dart';
import 'components/refund_confirmation_dialog.dart';

/// Invoice Detail Modal
///
/// Displays invoice details in a bottom sheet modal with the following features:
/// - Quick summary with total amount and status
/// - Customer information
/// - Items summary
/// - Payment information
/// - Store information
/// - Created by information
/// - Refund action for completed invoices
class InvoiceDetailModal extends StatelessWidget {
  final Invoice invoice;
  final String? currencySymbol;
  final void Function(Invoice invoice)? onRefundPressed;

  const InvoiceDetailModal({
    super.key,
    required this.invoice,
    this.currencySymbol,
    this.onRefundPressed,
  });

  /// Show invoice detail modal
  static void show(
    BuildContext context,
    Invoice invoice,
    String? currencySymbol, {
    void Function(Invoice invoice)? onRefundPressed,
  }) {
    HapticFeedback.lightImpact();

    TossBottomSheet.showWithBuilder<void>(
      context: context,
      heightFactor: 0.85,
      builder: (context) => InvoiceDetailModal(
        invoice: invoice,
        currencySymbol: currencySymbol,
        onRefundPressed: onRefundPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symbol = currencySymbol ?? '';

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Header
          ModalHeaderSection(invoice: invoice),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: [
                  // Quick Summary
                  QuickSummaryCard(
                    invoice: invoice,
                    currencySymbol: symbol,
                  ),

                  const SizedBox(height: TossSpacing.space4),

                  // Customer Info
                  CustomerInfoCard(
                    name: invoice.customer?.name,
                    phone: invoice.customer?.phone,
                  ),

                  const SizedBox(height: TossSpacing.space3),

                  // Items Summary
                  ItemsSummaryCard(
                    itemCount: invoice.itemsSummary.itemCount,
                    totalQuantity: invoice.itemsSummary.totalQuantity,
                  ),

                  const SizedBox(height: TossSpacing.space3),

                  // Payment Info
                  PaymentInfoCard(
                    paymentMethod: invoice.paymentMethod,
                    paymentStatus: invoice.paymentStatus,
                    isPaid: invoice.isPaid,
                  ),

                  const SizedBox(height: TossSpacing.space3),

                  // Store Info
                  StoreInfoCard(storeName: invoice.storeName),

                  // Created By
                  if (invoice.createdByName != null) ...[
                    const SizedBox(height: TossSpacing.space3),
                    CreatedByCard(createdByName: invoice.createdByName!),
                  ],

                  // AI Summary (if available)
                  if (invoice.aiDescription != null &&
                      invoice.aiDescription!.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space3),
                    AiDescriptionBox(text: invoice.aiDescription!),
                  ],

                  const SizedBox(height: TossSpacing.space4),
                ],
              ),
            ),
          ),

          // Refund Button (only for completed invoices)
          if (invoice.isCompleted && onRefundPressed != null)
            ModalRefundButton(
              onPressed: () => _handleRefundPressed(context),
            ),
        ],
      ),
    );
  }

  void _handleRefundPressed(BuildContext context) async {
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final symbol = currencySymbol ?? '';

    final confirmed = await RefundConfirmationDialog.show(
      context,
      invoice: invoice,
      currencySymbol: symbol,
      formatter: formatter,
    );

    if (confirmed == true && context.mounted) {
      Navigator.pop(context); // Close bottom sheet
      onRefundPressed?.call(invoice);
    }
  }
}
