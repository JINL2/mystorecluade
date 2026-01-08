import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Error view for notification settings
class NotificationErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const NotificationErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: TossSpacing.space20,
            height: TossSpacing.space20,
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: TossOpacity.light),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: TossSpacing.space10,
              color: TossColors.error,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'Failed to load settings',
            style: TossTextStyles.h3.copyWith(
              fontWeight: TossFontWeight.semibold,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Please try again',
            style: TossTextStyles.body.copyWith(color: TossColors.gray600),
          ),
          const SizedBox(height: TossSpacing.space4),
          TossButton.primary(
            text: 'Retry',
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

/// Empty state when no settings available
class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space8),
      child: Center(
        child: Column(
          children: [
            Container(
              width: TossSpacing.space20,
              height: TossSpacing.space20,
              decoration: const BoxDecoration(
                color: TossColors.gray100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                size: TossSpacing.space10,
                color: TossColors.gray400,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No notification settings',
              style: TossTextStyles.h3.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Your notification preferences will appear here',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Disabled state when master toggle is off
class NotificationDisabledState extends StatelessWidget {
  const NotificationDisabledState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray200,
          width: TossDimensions.dividerThickness,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            size: TossSpacing.space12,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Notifications are disabled',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: TossFontWeight.semibold,
              color: TossColors.gray700,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Turn on notifications to customize your preferences',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
