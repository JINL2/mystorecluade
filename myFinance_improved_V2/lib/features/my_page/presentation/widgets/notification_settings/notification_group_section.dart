import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';

import '../../../data/datasources/notification_settings_datasource.dart';
import 'notification_setting_item.dart';
import 'notification_utils.dart';

/// Group section for notification settings
class NotificationGroupSection extends StatelessWidget {
  final String groupName;
  final List<NotificationSetting> settings;
  final bool masterEnabled;
  final String? roleType;
  final void Function(String featureId, bool value)? onToggle;

  const NotificationGroupSection({
    super.key,
    required this.groupName,
    required this.settings,
    required this.masterEnabled,
    this.roleType,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Padding(
          padding: const EdgeInsets.only(
            left: TossSpacing.space2,
            bottom: TossSpacing.space3,
          ),
          child: Text(
            NotificationUtils.formatName(groupName),
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: TossFontWeight.bold,
              color: TossColors.gray700,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Settings Cards
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            boxShadow: [
              BoxShadow(
                color: TossColors.gray900.withValues(alpha: TossOpacity.subtle),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: settings.asMap().entries.map((entry) {
              final index = entry.key;
              final setting = entry.value;
              return Column(
                children: [
                  NotificationSettingItem(
                    setting: setting,
                    masterEnabled: masterEnabled,
                    roleType: roleType,
                    onToggle: (value) => onToggle?.call(setting.featureId, value),
                  ),
                  if (index < settings.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                      ),
                      child: Divider(
                        height: TossDimensions.dividerThickness,
                        thickness: TossDimensions.dividerThickness,
                        color: TossColors.gray100,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: TossSpacing.space5),
      ],
    );
  }
}
