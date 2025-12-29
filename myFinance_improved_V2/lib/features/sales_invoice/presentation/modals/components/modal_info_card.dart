// lib/features/sales_invoice/presentation/modals/components/modal_info_card.dart
//
// Reusable info card extracted from invoice_detail_modal.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Reusable info card for modal content sections
class ModalInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget content;

  const ModalInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: TossColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: TossColors.primary,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Customer info card builder
class CustomerInfoCard extends StatelessWidget {
  final String? name;
  final String? phone;

  const CustomerInfoCard({
    super.key,
    this.name,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return ModalInfoCard(
      icon: Icons.person,
      title: 'Customer',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name ?? 'Walk-in Customer',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          if (phone != null) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              phone!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Items summary card
class ItemsSummaryCard extends StatelessWidget {
  final int itemCount;
  final int totalQuantity;

  const ItemsSummaryCard({
    super.key,
    required this.itemCount,
    required this.totalQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return ModalInfoCard(
      icon: Icons.shopping_cart,
      title: 'Items',
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$itemCount products',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
            ),
          ),
          Text(
            'Qty: $totalQuantity',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Payment info card
class PaymentInfoCard extends StatelessWidget {
  final String paymentMethod;
  final String paymentStatus;
  final bool isPaid;

  const PaymentInfoCard({
    super.key,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return ModalInfoCard(
      icon: Icons.payment,
      title: 'Payment',
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            paymentMethod,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: isPaid
                  ? TossColors.success.withValues(alpha: 0.1)
                  : TossColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
            child: Text(
              paymentStatus,
              style: TossTextStyles.caption.copyWith(
                color: isPaid ? TossColors.success : TossColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Store info card
class StoreInfoCard extends StatelessWidget {
  final String storeName;

  const StoreInfoCard({
    super.key,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return ModalInfoCard(
      icon: Icons.store,
      title: 'Store',
      content: Text(
        storeName,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
        ),
      ),
    );
  }
}

/// Created by card
class CreatedByCard extends StatelessWidget {
  final String createdByName;

  const CreatedByCard({
    super.key,
    required this.createdByName,
  });

  @override
  Widget build(BuildContext context) {
    return ModalInfoCard(
      icon: Icons.person_outline,
      title: 'Created By',
      content: Text(
        createdByName,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
        ),
      ),
    );
  }
}
