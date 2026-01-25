import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/subscription/index.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Bottom sheet for store-related actions (create/join)
class StoreActionsSheet extends ConsumerWidget {
  const StoreActionsSheet({
    super.key,
    required this.companyName,
    required this.onCreateStore,
    required this.onJoinStore,
  });

  final String companyName;
  final VoidCallback onCreateStore;
  final VoidCallback onJoinStore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch cached store limit for instant UI response
    final storeLimit = ref.watch(storeLimitFromCacheProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.bottomSheet),
          topRight: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: TossSpacing.space10,
            height: TossSpacing.space1,
            margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Store',
                      style: TossTextStyles.h3.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'For $companyName',
                      style: TossTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space8),

          // Options
          Padding(
            padding: const EdgeInsets.fromLTRB(TossSpacing.paddingXL, 0, TossSpacing.paddingXL, TossSpacing.paddingXL),
            child: Column(
              children: [
                // Create Store - with limit check
                LimitAwareOptionCard(
                  icon: Icons.store,
                  title: 'Create Store',
                  subtitle: storeLimit.canAdd
                      ? 'Add a new store to $companyName'
                      : 'Limit reached (${storeLimit.limitDisplayText})',
                  canTap: storeLimit.canAdd,
                  onTap: () => _handleCreateStore(context, ref, storeLimit),
                ),

                const SizedBox(height: TossSpacing.space4),

                // Join Store by Code - no limit check needed
                LimitAwareOptionCard(
                  icon: Icons.add_location,
                  title: 'Join by Code',
                  subtitle: 'Enter store invite code to join',
                  onTap: onJoinStore,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  /// Handle create store with fresh limit check
  Future<void> _handleCreateStore(
    BuildContext context,
    WidgetRef ref,
    SubscriptionLimitCheck cachedLimit,
  ) async {
    // If cache says can't add, show upgrade dialog immediately
    if (!cachedLimit.canAdd) {
      await SubscriptionUpgradeDialog.show(
        context,
        limitCheck: cachedLimit,
        resourceType: 'store',
      );
      return;
    }

    // Fresh check before proceeding
    try {
      final freshLimit = await ref.read(storeLimitFreshProvider().future);

      if (!context.mounted) return;

      if (freshLimit.canAdd) {
        // Close bottom sheet and proceed
        Navigator.of(context).pop();
        onCreateStore();
      } else {
        // Show upgrade dialog with fresh data
        await SubscriptionUpgradeDialog.show(
          context,
          limitCheck: freshLimit,
          resourceType: 'store',
        );
      }
    } catch (e) {
      // On error, trust cache and proceed
      if (!context.mounted) return;
      Navigator.of(context).pop();
      onCreateStore();
    }
  }

  /// Show the store actions sheet
  static Future<T?> show<T>(
    BuildContext context, {
    required String companyName,
    required VoidCallback onCreateStore,
    required VoidCallback onJoinStore,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => StoreActionsSheet(
        companyName: companyName,
        onCreateStore: onCreateStore,
        onJoinStore: onJoinStore,
      ),
    );
  }
}
