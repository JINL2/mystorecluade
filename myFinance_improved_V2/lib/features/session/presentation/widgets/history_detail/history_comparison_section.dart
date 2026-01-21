import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';

/// Comparison section for merged session detail
/// Shows unique products in each session (A-only vs B-only)
class HistoryComparisonSection extends StatelessWidget {
  final SessionHistoryItem session;
  final MergeInfo mergeInfo;

  const HistoryComparisonSection({
    super.key,
    required this.session,
    required this.mergeInfo,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate unique products for each session
    final comparisonData = _calculateComparison();

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
                    Icons.compare_arrows,
                    size: TossSpacing.iconSM,
                    color: TossColors.info,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Session Comparison',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Comparison description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: TossSpacing.iconSM2,
                    color: TossColors.textTertiary,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Products that exist in only one session',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Original session unique items
          _buildSessionComparisonCard(
            sessionName: session.sessionName,
            label: 'Only in this session',
            items: comparisonData.originalOnly,
            color: TossColors.primary,
            icon: Icons.inventory_2,
          ),

          // Merged sessions unique items
          ...comparisonData.mergedSessions.entries.map((entry) {
            return _buildSessionComparisonCard(
              sessionName: entry.key,
              label: 'Only in this session',
              items: entry.value,
              color: TossColors.warning,
              icon: Icons.inventory_2_outlined,
            );
          }),

          // Common items section
          if (comparisonData.commonItems.isNotEmpty) ...[
            _buildCommonItemsCard(comparisonData.commonItems),
          ],

          const SizedBox(height: TossSpacing.space3),
        ],
      ),
    );
  }

  /// Calculate comparison data between sessions
  _ComparisonData _calculateComparison() {
    final originalItems = mergeInfo.originalSession.items;
    final mergedSessions = mergeInfo.mergedSessions;

    // Build product ID set for original session
    final originalProductIds = <String>{};
    for (final item in originalItems) {
      final key = _getProductKey(item.productId, item.variantId);
      originalProductIds.add(key);
    }

    // Build product ID sets for merged sessions
    final mergedProductIdSets = <String, Set<String>>{};
    final mergedItemMaps = <String, Map<String, MergedSessionItem>>{};

    for (final merged in mergedSessions) {
      final productIds = <String>{};
      final itemMap = <String, MergedSessionItem>{};
      for (final item in merged.items) {
        final key = _getProductKey(item.productId, item.variantId);
        productIds.add(key);
        itemMap[key] = item;
      }
      mergedProductIdSets[merged.sourceSessionName] = productIds;
      mergedItemMaps[merged.sourceSessionName] = itemMap;
    }

    // Calculate all product IDs from merged sessions
    final allMergedProductIds = <String>{};
    for (final ids in mergedProductIdSets.values) {
      allMergedProductIds.addAll(ids);
    }

    // Original-only items (not in any merged session)
    final originalOnlyItems = <MergedSessionItem>[];
    final originalItemMap = <String, MergedSessionItem>{};
    for (final item in originalItems) {
      final key = _getProductKey(item.productId, item.variantId);
      originalItemMap[key] = item;
      if (!allMergedProductIds.contains(key)) {
        originalOnlyItems.add(item);
      }
    }

    // Merged session-only items (not in original)
    final mergedOnlyItems = <String, List<MergedSessionItem>>{};
    for (final entry in mergedProductIdSets.entries) {
      final sessionName = entry.key;
      final productIds = entry.value;
      final itemMap = mergedItemMaps[sessionName]!;

      final uniqueItems = <MergedSessionItem>[];
      for (final id in productIds) {
        // Check if this product is unique to this merged session
        // (not in original and not in other merged sessions)
        if (!originalProductIds.contains(id)) {
          bool isUniqueToThisSession = true;
          for (final otherEntry in mergedProductIdSets.entries) {
            if (otherEntry.key != sessionName && otherEntry.value.contains(id)) {
              isUniqueToThisSession = false;
              break;
            }
          }
          if (isUniqueToThisSession) {
            uniqueItems.add(itemMap[id]!);
          }
        }
      }
      mergedOnlyItems[sessionName] = uniqueItems;
    }

    // Common items (in both original and at least one merged session)
    final commonItems = <MergedSessionItem>[];
    for (final item in originalItems) {
      final key = _getProductKey(item.productId, item.variantId);
      if (allMergedProductIds.contains(key)) {
        commonItems.add(item);
      }
    }

    return _ComparisonData(
      originalOnly: originalOnlyItems,
      mergedSessions: mergedOnlyItems,
      commonItems: commonItems,
    );
  }

  String _getProductKey(String productId, String? variantId) {
    return variantId != null ? '$productId:$variantId' : productId;
  }

  Widget _buildSessionComparisonCard({
    required String sessionName,
    required String label,
    required List<MergedSessionItem> items,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                topRight: Radius.circular(TossBorderRadius.md - 1),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: TossSpacing.iconSM2, color: color),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessionName,
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        label,
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
                  child: Text(
                    '${items.length}',
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items list
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Center(
                child: Text(
                  'No unique products',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 12,
                endIndent: 12,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildItemRow(item, color);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCommonItemsCard(List<MergedSessionItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.success.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.success.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                topRight: Radius.circular(TossBorderRadius.md - 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: TossSpacing.iconSM2,
                  color: TossColors.success,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Common Products',
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.success,
                        ),
                      ),
                      Text(
                        'Exist in multiple sessions',
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
                  child: Text(
                    '${items.length}',
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: TossColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              indent: 12,
              endIndent: 12,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemRow(item, TossColors.success);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(MergedSessionItem item, Color accentColor) {
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${item.quantity}',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: accentColor,
                  ),
                ),
                if (item.quantityRejected > 0) ...[
                  Text(
                    ' / ${item.quantityRejected}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal class to hold comparison calculation results
class _ComparisonData {
  final List<MergedSessionItem> originalOnly;
  final Map<String, List<MergedSessionItem>> mergedSessions;
  final List<MergedSessionItem> commonItems;

  _ComparisonData({
    required this.originalOnly,
    required this.mergedSessions,
    required this.commonItems,
  });
}
