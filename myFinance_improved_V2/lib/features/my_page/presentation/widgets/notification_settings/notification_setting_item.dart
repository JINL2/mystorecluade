import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';

import '../../../data/datasources/notification_settings_datasource.dart';
import '../../pages/notification_store_settings_page.dart';
import 'notification_utils.dart';

/// Individual notification setting item widget
class NotificationSettingItem extends StatelessWidget {
  final NotificationSetting setting;
  final bool masterEnabled;
  final String? roleType;
  final ValueChanged<bool>? onToggle;

  const NotificationSettingItem({
    super.key,
    required this.setting,
    required this.masterEnabled,
    this.roleType,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = masterEnabled;
    final hasStoreSettings = setting.scopeLevel == 'store';

    final content = Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          _buildIcon(isEnabled),
          const SizedBox(width: TossSpacing.space3),
          Expanded(child: _buildContent(isEnabled)),
          _buildAction(context, isEnabled, hasStoreSettings),
        ],
      ),
    );

    if (hasStoreSettings && isEnabled) {
      return InkWell(
        onTap: () => _navigateToStoreSettings(context),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: content,
      );
    }

    return content;
  }

  Widget _buildIcon(bool isEnabled) {
    return Container(
      width: TossSpacing.space11,
      height: TossSpacing.space11,
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: TossOpacity.light),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Icon(
        NotificationUtils.getIconFromKey(setting.iconKey),
        size: TossSpacing.iconMD,
        color: TossColors.primary,
      ),
    );
  }

  Widget _buildContent(bool isEnabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          NotificationUtils.formatName(setting.featureName),
          style: TossTextStyles.body.copyWith(
            fontWeight: TossFontWeight.semibold,
            color: isEnabled ? TossColors.gray900 : TossColors.gray400,
          ),
        ),
        if (setting.description?.isNotEmpty == true) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            setting.description!,
            style: TossTextStyles.caption.copyWith(
              color: isEnabled ? TossColors.gray600 : TossColors.gray400,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAction(BuildContext context, bool isEnabled, bool hasStoreSettings) {
    if (hasStoreSettings) {
      return Icon(
        Icons.chevron_right,
        size: TossSpacing.iconMD2,
        color: isEnabled ? TossColors.gray400 : TossColors.gray300,
      );
    }

    return Switch.adaptive(
      value: isEnabled ? setting.isEnabled : false,
      onChanged: isEnabled
          ? (newValue) {
              HapticFeedback.selectionClick();
              onToggle?.call(newValue);
            }
          : null,
      activeColor: TossColors.primary,
    );
  }

  void _navigateToStoreSettings(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NotificationStoreSettingsPage(
          featureId: setting.featureId,
          featureName: NotificationUtils.formatName(setting.featureName),
          roleType: roleType ?? 'employee',
        ),
      ),
    );
  }
}
