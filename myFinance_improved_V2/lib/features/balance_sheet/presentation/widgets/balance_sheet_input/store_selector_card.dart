import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/entities/store.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/index.dart';
import 'store_selector_sheet.dart';

/// Store selector card widget
class StoreSelectorCard extends ConsumerWidget {
  final AsyncValue<List<Store>> storesAsync;
  final String selectedStoreId;

  const StoreSelectorCard({
    super.key,
    required this.storesAsync,
    required this.selectedStoreId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        storesAsync.when(
          data: (stores) => _StoreCard(
            stores: stores,
            selectedStoreId: selectedStoreId,
          ),
          loading: () => _buildLoadingCard('Loading stores...'),
          error: (error, _) => _buildErrorCard('Failed to load stores'),
        ),
      ],
    );
  }

  Widget _buildLoadingCard(String message) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TossLoadingView.inline(size: 16),
            const SizedBox(width: TossSpacing.space2),
            Text(
              message,
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.errorLight,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: TossColors.error, size: TossSpacing.iconMD),
          const SizedBox(width: TossSpacing.space2),
          Text(
            message,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      ),
    );
  }
}

/// Internal store card widget
class _StoreCard extends ConsumerWidget {
  final List<Store> stores;
  final String selectedStoreId;

  const _StoreCard({
    required this.stores,
    required this.selectedStoreId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get selected store name
    String storeName = 'Select Store';
    if (selectedStoreId.isEmpty && stores.isNotEmpty) {
      storeName = 'All Stores (Headquarters)';
    } else if (selectedStoreId.isNotEmpty) {
      try {
        final store = stores.firstWhere((s) => s.id == selectedStoreId);
        storeName = store.storeName;
      } catch (e) {
        storeName = 'Select Store';
      }
    }

    return InkWell(
      onTap: () {
        showStoreSelectorSheet(context, ref, stores, selectedStoreId);
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: Border.all(
            color: selectedStoreId.isNotEmpty
                ? TossColors.primary.withValues(alpha: 0.3)
                : TossColors.gray200,
            width: selectedStoreId.isNotEmpty ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Store Icon
            Container(
              width: TossSpacing.iconXL,
              height: TossSpacing.iconXL,
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                selectedStoreId.isEmpty
                    ? Icons.business_outlined
                    : Icons.store_outlined,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Store Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Store',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    storeName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconMD,
            ),
          ],
        ),
      ),
    );
  }
}
