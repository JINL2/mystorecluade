import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                      'Store Actions',
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
                // Create Store
                _buildOptionCard(
                  context,
                  icon: Icons.store,
                  title: 'Create Store',
                  subtitle: 'Add a new store to $companyName',
                  onTap: onCreateStore,
                ),

                const SizedBox(height: TossSpacing.space4),

                // Join Store by Code
                _buildOptionCard(
                  context,
                  icon: Icons.add_location,
                  title: 'Join Store',
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

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.inputHeightLG,
                height: TossSpacing.inputHeightLG,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: TossSpacing.iconMD,
                ),
              ),
              const SizedBox(width: TossSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1/2),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: TossSpacing.iconXS,
              ),
            ],
          ),
        ),
      ),
    );
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
