import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/subscription/index.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Bottom sheet for company-related actions (create/join)
class CompanyActionsSheet extends ConsumerWidget {
  const CompanyActionsSheet({
    super.key,
    required this.onCreateCompany,
    required this.onJoinCompany,
  });

  final VoidCallback onCreateCompany;
  final VoidCallback onJoinCompany;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch cached company limit for instant UI response
    final companyLimit = ref.watch(companyLimitFromCacheProvider);

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
                Text(
                  'Company Actions',
                  style: TossTextStyles.h3.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
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
                // Create Company - with limit check
                LimitAwareOptionCard(
                  icon: Icons.business,
                  title: 'Create Company',
                  subtitle: companyLimit.canAdd
                      ? 'Start a new company and invite others'
                      : 'Limit reached (${companyLimit.limitDisplayText})',
                  canTap: companyLimit.canAdd,
                  onTap: () => _handleCreateCompany(context, ref, companyLimit),
                ),

                const SizedBox(height: TossSpacing.space4),

                // Join Company by Code - no limit check needed
                LimitAwareOptionCard(
                  icon: Icons.group_add,
                  title: 'Join Company',
                  subtitle: 'Enter company invite code to join',
                  onTap: onJoinCompany,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  /// Handle create company with fresh limit check
  Future<void> _handleCreateCompany(
    BuildContext context,
    WidgetRef ref,
    SubscriptionLimitCheck cachedLimit,
  ) async {
    // If cache says can't add, show upgrade dialog immediately
    if (!cachedLimit.canAdd) {
      await SubscriptionUpgradeDialog.show(
        context,
        limitCheck: cachedLimit,
        resourceType: 'company',
      );
      return;
    }

    // Fresh check before proceeding
    try {
      final freshLimit = await ref.read(companyLimitFreshProvider.future);

      if (!context.mounted) return;

      if (freshLimit.canAdd) {
        // Close bottom sheet and proceed
        Navigator.of(context).pop();
        onCreateCompany();
      } else {
        // Show upgrade dialog with fresh data
        await SubscriptionUpgradeDialog.show(
          context,
          limitCheck: freshLimit,
          resourceType: 'company',
        );
      }
    } catch (e) {
      // On error, trust cache and proceed
      if (!context.mounted) return;
      Navigator.of(context).pop();
      onCreateCompany();
    }
  }

  /// Show the company actions sheet
  static Future<T?> show<T>(BuildContext context, {
    required VoidCallback onCreateCompany,
    required VoidCallback onJoinCompany,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => CompanyActionsSheet(
        onCreateCompany: onCreateCompany,
        onJoinCompany: onJoinCompany,
      ),
    );
  }
}
