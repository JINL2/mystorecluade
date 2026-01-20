import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';

/// Merge info section for history detail
/// v4: Added items_by_product view to show which sessions each product came from
class HistoryMergeInfoSection extends StatefulWidget {
  final SessionHistoryItem session;
  final MergeInfo mergeInfo;

  const HistoryMergeInfoSection({
    super.key,
    required this.session,
    required this.mergeInfo,
  });

  @override
  State<HistoryMergeInfoSection> createState() => _HistoryMergeInfoSectionState();
}

class _HistoryMergeInfoSectionState extends State<HistoryMergeInfoSection> {
  /// 0 = By Session, 1 = By Product
  int _viewMode = 0;

  MergeInfo get mergeInfo => widget.mergeInfo;
  SessionHistoryItem get session => widget.session;

  @override
  Widget build(BuildContext context) {
    final originalSession = mergeInfo.originalSession;
    final mergedSessions = mergeInfo.mergedSessions;

    return Container(
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space1),
                  decoration: BoxDecoration(
                    color: TossColors.info.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.merge_type,
                    size: TossSpacing.iconSM,
                    color: TossColors.info,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Merged Session',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${mergeInfo.totalMergedSessionsCount + 1} sessions',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.info,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Total summary after merge
          Container(
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: TossSpacing.iconSM, color: TossColors.success),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Total after merge: ',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
                Text(
                  '${session.totalQuantity} items',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: TossColors.success,
                  ),
                ),
                if (session.totalRejected > 0) ...[
                  Text(
                    ' (${session.totalRejected} rejected)',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // v4: View mode toggle (By Session / By Product)
          if (mergeInfo.hasItemsByProduct) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Row(
                children: [
                  _buildViewModeButton(
                    label: 'By Session',
                    isSelected: _viewMode == 0,
                    onTap: () => setState(() => _viewMode = 0),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  _buildViewModeButton(
                    label: 'By Product',
                    isSelected: _viewMode == 1,
                    onTap: () => setState(() => _viewMode = 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
          ],

          // Content based on view mode
          if (_viewMode == 0) ...[
            // Original session (this session's items before merge)
            _buildMergeSessionCard(
              sessionName: session.sessionName,
              items: originalSession.items,
              totalQuantity: originalSession.totalQuantity,
              totalRejected: originalSession.totalRejected,
            ),

            // Merged sessions
            ...mergedSessions.map(
              (MergedSessionInfo mergedSession) => _buildMergeSessionCard(
                sessionName: mergedSession.sourceSessionName,
                items: mergedSession.items,
                totalQuantity: mergedSession.totalQuantity,
                totalRejected: mergedSession.totalRejected,
                createdBy: mergedSession.sourceCreatedBy,
              ),
            ),
          ] else ...[
            // v4: By Product view - show which sessions each product came from
            ...mergeInfo.itemsByProduct.map(
              (item) => _buildProductSourceCard(item),
            ),
          ],

          const SizedBox(height: TossSpacing.space3),
        ],
      ),
    );
  }

  Widget _buildMergeSessionCard({
    required String sessionName,
    required List<MergedSessionItem> items,
    required int totalQuantity,
    required int totalRejected,
    SessionHistoryUser? createdBy,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: const BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                topRight: Radius.circular(TossBorderRadius.md - 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: TossSpacing.iconSM2,
                  color: TossColors.textSecondary,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessionName,
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (createdBy != null)
                        Text(
                          '${createdBy.firstName} ${createdBy.lastName}'.trim().isEmpty
                              ? 'by Unknown'
                              : 'by ${createdBy.firstName} ${createdBy.lastName}'.trim(),
                          style: TossTextStyles.micro.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$totalQuantity',
                        style: TossTextStyles.caption.copyWith(
                          fontWeight: TossFontWeight.bold,
                          color: TossColors.success,
                        ),
                      ),
                      if (totalRejected > 0) ...[
                        Text(
                          ' / ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                        Text(
                          '$totalRejected',
                          style: TossTextStyles.caption.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            color: TossColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Items list
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Text(
                'No items',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 12, endIndent: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildMergedItemRow(item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMergedItemRow(MergedSessionItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.sku.isNotEmpty)
                  Text(
                    'SKU: ${item.sku}',
                    style: TossTextStyles.micro.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.quantity}',
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: TossFontWeight.semibold,
                  color: TossColors.success,
                ),
              ),
              if (item.quantityRejected > 0) ...[
                Text(
                  ' / ',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
                Text(
                  '${item.quantityRejected}',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.error,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// v4: View mode toggle button
  Widget _buildViewModeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.textSecondary,
            fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
          ),
        ),
      ),
    );
  }

  /// v4: Build product source card showing which sessions a product came from
  Widget _buildProductSourceCard(ItemByProduct item) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: const BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                topRight: Radius.circular(TossBorderRadius.md - 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.textPrimary,
                        ),
                      ),
                      if (item.sku.isNotEmpty)
                        Text(
                          'SKU: ${item.sku}',
                          style: TossTextStyles.micro.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    'Total: ${item.totalQuantity}',
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: TossColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sources list - which sessions this product came from
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item.sources.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 12, endIndent: 12),
            itemBuilder: (context, index) {
              final source = item.sources[index];
              return _buildSourceRow(source);
            },
          ),
        ],
      ),
    );
  }

  /// v4: Build source row showing session name and quantity
  Widget _buildSourceRow(ProductSourceInfo source) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: TossSpacing.iconSM2,
            color: TossColors.textTertiary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.sessionName,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'by ${source.scannedBy.firstName} ${source.scannedBy.lastName}'.trim(),
                  style: TossTextStyles.micro.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${source.quantity}',
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: TossFontWeight.semibold,
              color: TossColors.success,
            ),
          ),
          if (source.quantityRejected > 0) ...[
            Text(
              ' / ${source.quantityRejected}',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
