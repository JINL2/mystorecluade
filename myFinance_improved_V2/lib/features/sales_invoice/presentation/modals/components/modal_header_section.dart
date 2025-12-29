// lib/features/sales_invoice/presentation/modals/components/modal_header_section.dart
//
// Modal header section extracted from invoice_detail_modal.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';

/// Modal header section with handle bar, invoice info, and close button
class ModalHeaderSection extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback? onClose;

  const ModalHeaderSection({
    super.key,
    required this.invoice,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          width: 48,
          height: 4,
          margin: const EdgeInsets.only(top: TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray300,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),

        // Header content
        Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(invoice.saleDate),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              // Close button
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose ?? () => Navigator.pop(context),
                color: TossColors.gray600,
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: TossColors.gray100),
      ],
    );
  }
}
