import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';

/// Hero section with master toggle and description
class NotificationHeroSection extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const NotificationHeroSection({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary.withValues(alpha: TossOpacity.light),
            TossColors.primary.withValues(alpha: TossOpacity.subtle),
          ],
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: TossOpacity.light),
          width: TossDimensions.dividerThickness,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconContainer(),
              const SizedBox(width: TossSpacing.space4),
              Expanded(child: _buildTitleSection()),
              Switch.adaptive(
                value: isEnabled,
                onChanged: (value) {
                  HapticFeedback.mediumImpact();
                  onToggle(value);
                },
                activeColor: TossColors.primary,
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildInfoRow(),
        ],
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: TossSpacing.space12,
      height: TossSpacing.space12,
      decoration: BoxDecoration(
        color: isEnabled ? TossColors.primary : TossColors.gray300,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: TossColors.primary.withValues(alpha: TossOpacity.strong),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(
        isEnabled
            ? Icons.notifications_active
            : Icons.notifications_off_outlined,
        color: TossColors.white,
        size: TossSpacing.iconLG,
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Push Notifications',
          style: TossTextStyles.h3.copyWith(
            fontWeight: TossFontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          isEnabled ? 'Active and ready' : 'Currently disabled',
          style: TossTextStyles.caption.copyWith(
            color: isEnabled ? TossColors.primary : TossColors.gray600,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: TossSpacing.space1 / 2),
          child: Icon(
            Icons.info_outline,
            size: TossSpacing.iconSM2,
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: Text(
            'Get notified about important updates, shifts, and team activities',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
