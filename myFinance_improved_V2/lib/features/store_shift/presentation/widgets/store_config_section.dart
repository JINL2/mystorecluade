import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_card.dart';

/// Store Configuration Section Widget
///
/// Displays operational settings with edit actions.
/// Feature-specific widget for store_shift.
class StoreConfigSection extends StatelessWidget {
  final Map<String, dynamic> store;
  final VoidCallback? onEditSettings;
  final VoidCallback? onEditLocation;

  const StoreConfigSection({
    super.key,
    required this.store,
    this.onEditSettings,
    this.onEditLocation,
  });

  String _getLocationSubtitle() {
    if (store['store_latitude'] != null && store['store_longitude'] != null) {
      return 'Location configured';
    }
    return 'Set store location';
  }

  Widget _buildConfigOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        splashColor: TossColors.primary.withValues(alpha: 0.1),
        highlightColor: TossColors.primary.withValues(alpha: 0.05),
        child: Ink(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: onTap != null
                ? TossColors.gray50
                : TossColors.gray50.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.iconXL,
                height: TossSpacing.iconXL,
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  icon,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  LucideIcons.chevronRight,
                  color: TossColors.gray400,
                  size: TossSpacing.iconSM,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Operational Settings',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: onEditSettings,
                icon: Icon(
                  IconMapper.getIcon('editRegular'),
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Huddle Time
          _buildConfigOption(
            icon: LucideIcons.users,
            title: 'Huddle Time',
            subtitle:
                '${store['huddle_time'] ?? 15} minutes for team meetings',
            onTap: null,
          ),
          const SizedBox(height: TossSpacing.space3),

          // Payment Time
          _buildConfigOption(
            icon: LucideIcons.clock,
            title: 'Payment Time',
            subtitle:
                '${store['payment_time'] ?? 30} minutes for payment processing',
            onTap: null,
          ),
          const SizedBox(height: TossSpacing.space3),

          // Check-in Distance
          _buildConfigOption(
            icon: LucideIcons.mapPin,
            title: 'Check-in Distance',
            subtitle:
                '${store['allowed_distance'] ?? 100} meters maximum distance',
            onTap: null,
          ),
          const SizedBox(height: TossSpacing.space3),

          // Store Location
          _buildConfigOption(
            icon: LucideIcons.map,
            title: 'Store Location',
            subtitle: _getLocationSubtitle(),
            onTap: onEditLocation,
          ),
        ],
      ),
    );
  }
}
