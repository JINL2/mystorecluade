import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';

import '../providers/notification_settings_provider.dart';
import '../widgets/notification_settings/notification_settings_widgets.dart';

/// Messenger-inspired notification settings page following 2025 UX best practices
/// Inspired by WhatsApp, Telegram, Signal, and Facebook Messenger
/// Features: Sound, Vibration, Preview, Per-category controls
class NotificationsSettingsPage extends ConsumerStatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  ConsumerState<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState
    extends ConsumerState<NotificationsSettingsPage> {
  // Alert mode: 0=Full Alerts, 1=Sound Only, 2=Vibration Only, 3=Visual Only
  int _selectedAlertMode = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationSettingsNotifierProvider.notifier).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationSettingsNotifierProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: const TossAppBar1(
        title: 'Notifications',
        backgroundColor: TossColors.gray100,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? NotificationErrorView(
                  errorMessage: state.errorMessage!,
                  onRetry: () {
                    ref.read(notificationSettingsNotifierProvider.notifier).loadSettings();
                  },
                )
              : _buildContent(state),
    );
  }

  Widget _buildContent(NotificationSettingsState state) {
    final groupedSettings = state.groupedSettings;
    final roleType =
        ref.read(notificationSettingsNotifierProvider.notifier).cachedRoleType;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section with Master Toggle
          NotificationHeroSection(
            isEnabled: state.masterPushEnabled,
            onToggle: (value) {
              ref
                  .read(notificationSettingsNotifierProvider.notifier)
                  .toggleMasterPush(value);
            },
          ),

          const SizedBox(height: TossSpacing.space6),

          // General notification controls
          if (state.masterPushEnabled) ...[
            AlertModeSection(
              selectedMode: _selectedAlertMode,
              onModeChanged: (mode) {
                setState(() {
                  _selectedAlertMode = mode;
                });
                // TODO: Save to backend
              },
            ),
            const SizedBox(height: TossSpacing.space6),
          ],

          // Notification Categories (when master is enabled)
          if (state.masterPushEnabled && groupedSettings.isNotEmpty) ...[
            ...groupedSettings.entries.map((entry) {
              return NotificationGroupSection(
                groupName: entry.key,
                settings: entry.value,
                masterEnabled: state.masterPushEnabled,
                roleType: roleType,
                onToggle: (featureId, value) {
                  ref
                      .read(notificationSettingsNotifierProvider.notifier)
                      .toggleNotification(featureId, value);
                },
              );
            }),
          ],

          // Empty State (when master is enabled but no settings)
          if (state.masterPushEnabled &&
              state.settings.isEmpty &&
              !state.isLoading) ...[
            const NotificationEmptyState(),
          ],

          // Disabled State (when master is off)
          if (!state.masterPushEnabled) const NotificationDisabledState(),

          const SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }
}
