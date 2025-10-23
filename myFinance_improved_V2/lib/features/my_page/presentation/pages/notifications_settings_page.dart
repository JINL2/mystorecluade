import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_white_card.dart';

import '../widgets/common_widgets.dart';

class NotificationsSettingsPage extends ConsumerStatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  ConsumerState<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends ConsumerState<NotificationsSettingsPage> {
  // Notification preferences
  bool _pushNotifications = true;
  bool _transactionNotifications = true;
  bool _cashEndingReminders = true;
  bool _employeeUpdates = false;
  bool _systemMaintenanceAlerts = true;

  // Email notifications
  bool _emailNotifications = true;
  bool _weeklyReports = true;
  bool _monthlyReports = true;
  bool _securityAlerts = true;

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: const TossAppBar1(
        title: 'Notifications',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.screenPaddingMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Push Notifications
            Text(
              'Push Notifications',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space4),

            TossWhiteCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNotificationToggle(
                    'Enable Push Notifications',
                    'Receive notifications on your device',
                    _pushNotifications,
                    (value) => setState(() => _pushNotifications = value),
                  ),
                  const CommonDivider(),
                  _buildNotificationToggle(
                    'Transaction Alerts',
                    'Get notified of new transactions',
                    _transactionNotifications,
                    (value) => setState(() => _transactionNotifications = value),
                    enabled: _pushNotifications,
                  ),
                  const CommonDivider(),
                  _buildNotificationToggle(
                    'Cash Ending Reminders',
                    'Daily reminders for cash ending',
                    _cashEndingReminders,
                    (value) => setState(() => _cashEndingReminders = value),
                    enabled: _pushNotifications,
                  ),
                  const CommonDivider(),
                  _buildNotificationToggle(
                    'Employee Updates',
                    'Notifications about employee activities',
                    _employeeUpdates,
                    (value) => setState(() => _employeeUpdates = value),
                    enabled: _pushNotifications,
                  ),
                  const CommonDivider(),
                  _buildNotificationToggle(
                    'System Maintenance',
                    'Important system updates and maintenance',
                    _systemMaintenanceAlerts,
                    (value) => setState(() => _systemMaintenanceAlerts = value),
                    enabled: _pushNotifications,
                  ),
                ],
              ),
            ),

            SizedBox(height: TossSpacing.space8),

            // Email Notifications
            Text(
              'Email Notifications',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space4),

            TossWhiteCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNotificationToggle(
                    'Enable Email Notifications',
                    'Receive notifications via email',
                    _emailNotifications,
                    (value) => setState(() => _emailNotifications = value),
                  ),
                  const CommonDivider(),
                  _buildNotificationToggle(
                    'Weekly Reports',
                    'Summary of your weekly business activity',
                    _weeklyReports,
                    (value) => setState(() => _weeklyReports = value),
                    enabled: _emailNotifications,
                  ),
                  const CommonDivider(),
                  _buildNotificationToggle(
                    'Monthly Reports',
                    'Comprehensive monthly business reports',
                    _monthlyReports,
                    (value) => setState(() => _monthlyReports = value),
                    enabled: _emailNotifications,
                  ),
                  const CommonDivider(),
                  _buildNotificationToggle(
                    'Security Alerts',
                    'Important security notifications',
                    _securityAlerts,
                    (value) => setState(() => _securityAlerts = value),
                    enabled: _emailNotifications,
                  ),
                ],
              ),
            ),

            // Note about in-app notifications
            SizedBox(height: TossSpacing.space8),
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: TossColors.gray600, size: 20),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'In-app notifications have been disabled. You can view all notifications in the notification center.',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: enabled ? TossColors.gray900 : TossColors.gray500,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  subtitle,
                  style: TossTextStyles.caption.copyWith(
                    color: enabled ? TossColors.gray600 : TossColors.gray400,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled ? value : false,
            onChanged: enabled
                ? (newValue) {
                    HapticFeedback.selectionClick();
                    onChanged(newValue);
                  }
                : null,
            activeColor: TossColors.primary,
          ),
        ],
      ),
    );
  }
}
