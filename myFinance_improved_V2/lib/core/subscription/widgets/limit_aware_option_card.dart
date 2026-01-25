import 'package:flutter/material.dart';

import '../../../shared/themes/toss_border_radius.dart';
import '../../../shared/themes/toss_colors.dart';
import '../../../shared/themes/toss_spacing.dart';
import '../../../shared/themes/toss_text_styles.dart';

/// A reusable option card that handles subscription limit states
///
/// Shows different visual states based on whether the action is available:
/// - Enabled: Normal appearance with primary colors
/// - Disabled: Muted appearance with warning icon and colors
///
/// Used in bottom sheets for create/join actions (company, store, etc.)
class LimitAwareOptionCard extends StatelessWidget {
  const LimitAwareOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.canTap = true,
  });

  /// Icon to display (overridden with lock icon when disabled)
  final IconData icon;

  /// Title text
  final String title;

  /// Subtitle text (can show limit info when disabled)
  final String subtitle;

  /// Callback when tapped
  final VoidCallback onTap;

  /// Whether the action is available
  /// When false, shows disabled state with lock icon
  final bool canTap;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !canTap;

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: isDisabled
                ? Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: isDisabled
                  ? Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.1)
                  : Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: TossSpacing.inputHeightLG,
                height: TossSpacing.inputHeightLG,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? TossColors.warning.withValues(alpha: 0.1)
                      : Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  isDisabled ? Icons.lock_outline : icon,
                  color: isDisabled
                      ? TossColors.warning
                      : Theme.of(context).colorScheme.primary,
                  size: TossSpacing.iconMD,
                ),
              ),

              const SizedBox(width: TossSpacing.space4),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        color: isDisabled
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1 / 2),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: isDisabled
                            ? TossColors.warning
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing icon
              Icon(
                isDisabled ? Icons.arrow_upward : Icons.arrow_forward_ios,
                color: isDisabled
                    ? TossColors.warning
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: TossSpacing.iconXS,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
