import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../widgets/common/toss_app_bar.dart';
import '../../../widgets/toss/toss_card.dart';

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
  bool _marketingUpdates = false;
  
  // Email notifications
  bool _emailNotifications = true;
  bool _weeklyReports = true;
  bool _monthlyReports = true;
  bool _securityAlerts = true;

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.surface,
      appBar: const TossAppBar(
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
            
            TossCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNotificationToggle(
                    'Enable Push Notifications',
                    'Receive notifications on your device',
                    _pushNotifications,
                    (value) => setState(() => _pushNotifications = value),
                  ),
                  _buildDivider(),
                  _buildNotificationToggle(
                    'Transaction Alerts',
                    'Get notified of new transactions',
                    _transactionNotifications,
                    (value) => setState(() => _transactionNotifications = value),
                    enabled: _pushNotifications,
                  ),
                  _buildDivider(),
                  _buildNotificationToggle(
                    'Cash Ending Reminders',
                    'Daily reminders for cash ending',
                    _cashEndingReminders,
                    (value) => setState(() => _cashEndingReminders = value),
                    enabled: _pushNotifications,
                  ),
                  _buildDivider(),
                  _buildNotificationToggle(
                    'Employee Updates',
                    'Notifications about employee activities',
                    _employeeUpdates,
                    (value) => setState(() => _employeeUpdates = value),
                    enabled: _pushNotifications,
                  ),
                  _buildDivider(),
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
            
            TossCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNotificationToggle(
                    'Enable Email Notifications',
                    'Receive notifications via email',
                    _emailNotifications,
                    (value) => setState(() => _emailNotifications = value),
                  ),
                  _buildDivider(),
                  _buildNotificationToggle(
                    'Weekly Reports',
                    'Summary of your weekly business activity',
                    _weeklyReports,
                    (value) => setState(() => _weeklyReports = value),
                    enabled: _emailNotifications,
                  ),
                  _buildDivider(),
                  _buildNotificationToggle(
                    'Monthly Reports',
                    'Comprehensive monthly business reports',
                    _monthlyReports,
                    (value) => setState(() => _monthlyReports = value),
                    enabled: _emailNotifications,
                  ),
                  _buildDivider(),
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
            
            SizedBox(height: TossSpacing.space8),
            
            // Marketing & Updates
            Text(
              'Marketing & Updates',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space4),
            
            TossCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNotificationToggle(
                    'Marketing Updates',
                    'New features, tips, and promotional offers',
                    _marketingUpdates,
                    (value) => setState(() => _marketingUpdates = value),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space8),
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


  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      color: TossColors.gray100,
    );
  }
}