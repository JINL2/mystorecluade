import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/session_review_provider.dart';
import '../../providers/states/session_review_state.dart';

/// Item detail bottom sheet - shows scanned by users info
class ReviewItemDetailSheet extends ConsumerWidget {
  final SessionReviewItem item;
  final SessionReviewParams params;

  const ReviewItemDetailSheet({
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
    final effectiveNewStock = state.getEffectiveNewStock(item);
    final effectiveStockChange = state.getEffectiveStockChange(item);

    // Determine change color based on effective values
    Color changeColor;
    String changePrefix = '';
    if (effectiveStockChange > 0) {
      changeColor = TossColors.success;
      changePrefix = '+';
    } else if (effectiveStockChange < 0) {
      changeColor = TossColors.loss;
      changePrefix = '';
    } else {
      changeColor = TossColors.textSecondary;
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
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),

              // Header
              _buildHeader(context),

              const Divider(height: 1, color: TossColors.gray100),

              // Edited indicator
              if (isEdited) _buildEditedIndicator(effectiveQuantity),

              // Stock Summary Card
              _buildStockSummary(
                effectiveNewStock,
                effectiveStockChange,
                changeColor,
                changePrefix,
                isEdited,
              ),

              // Quantity Summary
              _buildQuantitySummary(effectiveQuantity, isEdited),

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
            width: 64,
            height: 64,
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
                          size: 28,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.inventory_2_outlined,
                    color: TossColors.textTertiary,
                    size: 28,
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
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.sku != null) ...[
                  const SizedBox(height: 4),
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

  Widget _buildEditedIndicator(int effectiveQuantity) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.primary),
          ),
          child: Row(
            children: [
              const Icon(Icons.edit, size: 16, color: TossColors.primary),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  'Manager edited count: ${item.totalQuantity} → $effectiveQuantity',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
      ],
    );
  }

  Widget _buildStockSummary(
    int effectiveNewStock,
    int effectiveStockChange,
    Color changeColor,
    String changePrefix,
    bool isEdited,
  ) {
    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStockColumn('Previous', '${item.previousStock}', TossColors.textSecondary),
          const Icon(Icons.arrow_forward, color: TossColors.textTertiary, size: 20),
          _buildStockColumn(
            'New',
            '$effectiveNewStock',
            isEdited ? TossColors.primary : TossColors.textPrimary,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: changeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Text(
              '$changePrefix$effectiveStockChange',
              style: TossTextStyles.h4.copyWith(
                color: changeColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TossTextStyles.h4.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySummary(int effectiveQuantity, bool isEdited) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              isEdited ? 'Edited Count' : 'Total Counted',
              '$effectiveQuantity',
              isEdited ? TossColors.primary : TossColors.primary,
              isEdited ? Icons.edit : Icons.add_box_outlined,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: _buildSummaryCard(
              'Rejected',
              '${item.totalRejected}',
              TossColors.loss,
              Icons.cancel_outlined,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: _buildSummaryCard(
              'Net Quantity',
              '${effectiveQuantity - item.totalRejected}',
              TossColors.success,
              Icons.check_circle_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TossTextStyles.h4.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
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
          const Icon(Icons.people_outline, size: 20, color: TossColors.textSecondary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Scanned By (${item.scannedBy.length} users)',
            style: TossTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
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
          CircleAvatar(
            radius: 20,
            backgroundColor: TossColors.primary.withValues(alpha: 0.1),
            child: Text(
              user.userName.isNotEmpty ? user.userName[0].toUpperCase() : '?',
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // User Name
          Expanded(
            child: Text(
              user.userName,
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
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
                  const Icon(Icons.add_box_outlined, size: 16, color: TossColors.success),
                  const SizedBox(width: 4),
                  Text(
                    '${user.quantity}',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (user.quantityRejected > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cancel_outlined, size: 16, color: TossColors.loss),
                    const SizedBox(width: 4),
                    Text(
                      '${user.quantityRejected}',
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.loss,
                        fontWeight: FontWeight.w600,
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
