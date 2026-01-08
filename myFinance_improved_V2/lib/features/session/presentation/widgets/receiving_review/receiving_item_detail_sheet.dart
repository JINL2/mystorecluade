import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/index.dart';
import '../../../domain/entities/session_review_item.dart';
import '../../providers/session_review_provider.dart';
import '../../providers/states/session_review_state.dart';

/// Receiving item detail bottom sheet - shows scanned by users info
class ReceivingItemDetailSheet extends ConsumerWidget {
  final SessionReviewItem item;
  final SessionReviewParams params;

  const ReceivingItemDetailSheet({
    super.key,
    required this.item,
    required this.params,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionReviewNotifierProvider(params));
    final isEdited = state.isEdited(item.productId);
    final effectiveQuantity = state.getEffectiveQuantity(
      item.productId,
      item.totalQuantity,
    );

    final shipped = item.previousStock;
    final received = effectiveQuantity;
    final rejected = item.totalRejected;
    final accepted = received - rejected;

    // Determine status
    String status;
    Color statusColor;
    if (accepted > shipped) {
      status = 'Over Received';
      statusColor = TossColors.primary;
    } else if (accepted < shipped && rejected == 0) {
      status = 'Under Received';
      statusColor = TossColors.loss;
    } else if (rejected > 0) {
      status = 'Partially Rejected';
      statusColor = TossColors.warning;
    } else {
      status = 'Fully Matched';
      statusColor = TossColors.success;
    }

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.space2),
                width: TossSpacing.iconXL,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.indicator),
                ),
              ),

              // Header with product info
              _buildHeader(context),

              const Divider(height: 1, color: TossColors.gray100),

              // Edited indicator banner
              if (isEdited) _buildEditedBanner(effectiveQuantity),

              // Status Badge
              _buildStatusBadge(status, statusColor, isEdited),

              // Receiving Summary Cards
              _buildSummaryCards(shipped, received, accepted, rejected),

              const SizedBox(height: TossSpacing.space4),

              // Scanned By Section Header
              _buildScannedByHeader(),

              const SizedBox(height: TossSpacing.space2),

              // Scanned By List
              Expanded(
                child: item.scannedBy.isEmpty
                    ? Center(
                        child: Text(
                          'No scan records available',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                        itemCount: item.scannedBy.length,
                        itemBuilder: (context, index) {
                          final user = item.scannedBy[index];
                          return _buildUserRow(user);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: TossSpacing.icon4XL,
            height: TossSpacing.icon4XL,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.inventory_2_outlined,
                          color: TossColors.textTertiary,
                          size: TossSpacing.iconLG,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.inventory_2_outlined,
                    color: TossColors.textTertiary,
                    size: TossSpacing.iconLG,
                  ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.sku != null) ...[
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    item.sku!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Close button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: TossColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEditedBanner(int effectiveQuantity) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        0,
      ),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.edit,
            size: TossSpacing.iconSM2,
            color: TossColors.primary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Manager edited: ${item.totalQuantity} → $effectiveQuantity',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
                fontWeight: TossFontWeight.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color statusColor, bool isEdited) {
    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status,
            style: TossTextStyles.bodyMedium.copyWith(
              color: statusColor,
              fontWeight: TossFontWeight.semibold,
            ),
          ),
          if (isEdited) ...[
            const SizedBox(width: TossSpacing.space2),
            Icon(
              Icons.edit,
              size: TossSpacing.iconXS,
              color: statusColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int shipped, int received, int accepted, int rejected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Shipped',
              '$shipped',
              TossColors.textSecondary,
              Icons.local_shipping_outlined,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: _buildSummaryCard(
              'Received',
              '$received',
              TossColors.primary,
              Icons.download_outlined,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: _buildSummaryCard(
              'Accepted',
              '$accepted',
              TossColors.success,
              Icons.check_circle_outline,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: _buildSummaryCard(
              'Rejected',
              '$rejected',
              TossColors.loss,
              Icons.cancel_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Icon(icon, size: TossSpacing.iconSM, color: color),
          const SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: TossFontWeight.bold,
            ),
          ),
          const SizedBox(height: TossSpacing.space0_5),
          Text(
            label,
            style: TossTextStyles.small.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScannedByHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          const Icon(Icons.people_outline, size: TossSpacing.iconMD, color: TossColors.textSecondary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Scanned By (${item.scannedBy.length} users)',
            style: TossTextStyles.bodyMedium.copyWith(
              fontWeight: TossFontWeight.semibold,
              color: TossColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(ScannedByUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Row(
        children: [
          // User Avatar
          EmployeeProfileAvatar(
            name: user.userName,
            size: TossSpacing.iconXL,
          ),
          const SizedBox(width: TossSpacing.space3),

          // User Name
          Expanded(
            child: Text(
              user.userName,
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: TossFontWeight.medium,
                color: TossColors.textPrimary,
              ),
            ),
          ),

          // Quantity & Rejected
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_box_outlined, size: TossSpacing.iconSM2, color: TossColors.success),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    '${user.quantity}',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.success,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ],
              ),
              if (user.quantityRejected > 0) ...[
                const SizedBox(height: TossSpacing.space1),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cancel_outlined, size: TossSpacing.iconSM2, color: TossColors.loss),
                    const SizedBox(width: TossSpacing.space1),
                    Text(
                      '${user.quantityRejected}',
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.loss,
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
