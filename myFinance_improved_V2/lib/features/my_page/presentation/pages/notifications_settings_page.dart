import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_white_card.dart';

import '../../data/datasources/notification_settings_datasource.dart';
import '../providers/notification_settings_provider.dart';
import '../widgets/common_widgets.dart';
import 'notification_store_settings_page.dart';

class NotificationsSettingsPage extends ConsumerStatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  ConsumerState<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState
    extends ConsumerState<NotificationsSettingsPage> {
  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 알림 설정 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationSettingsProvider.notifier).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationSettingsProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: const TossAppBar1(
        title: 'Notifications',
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? _buildErrorView(state.errorMessage!)
              : _buildContent(state),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'Failed to load settings',
            style: TossTextStyles.body.copyWith(color: TossColors.gray600),
          ),
          const SizedBox(height: TossSpacing.space2),
          TextButton(
            onPressed: () {
              ref.read(notificationSettingsProvider.notifier).loadSettings();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(NotificationSettingsState state) {
    final groupedSettings = state.groupedSettings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.screenPaddingMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Master Push Notifications Toggle
          Text(
            'Push Notifications',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),

          TossWhiteCard(
            padding: EdgeInsets.zero,
            child: _buildNotificationToggle(
              title: 'Enable Push Notifications',
              subtitle: 'Receive notifications on your device',
              value: state.masterPushEnabled,
              onChanged: (value) {
                ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleMasterPush(value);
              },
            ),
          ),

          // Grouped Notification Settings (Master가 켜져있을 때만 표시)
          if (state.masterPushEnabled && groupedSettings.isNotEmpty) ...[
            ...groupedSettings.entries.map((entry) {
              final groupName = entry.key;
              final settings = entry.value;
              return _buildGroupSection(groupName, settings, state);
            }),
          ],

          // Empty state (Master가 켜져있을 때만 표시)
          if (state.masterPushEnabled && state.settings.isEmpty && !state.isLoading) ...[
            const SizedBox(height: TossSpacing.space8),
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.notifications_off_outlined,
                    size: 48,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(height: TossSpacing.space4),
                  Text(
                    'No notification settings available',
                    style:
                        TossTextStyles.body.copyWith(color: TossColors.gray600),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }

  /// 그룹 섹션 빌드
  Widget _buildGroupSection(
    String groupName,
    List<NotificationSetting> settings,
    NotificationSettingsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space6),
        Text(
          _formatGroupName(groupName),
          style: TossTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        TossWhiteCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: settings
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final setting = entry.value;
                  return Column(
                    children: [
                      _buildSettingItem(setting, state),
                      if (index < settings.length - 1) const CommonDivider(),
                    ],
                  );
                })
                .toList(),
          ),
        ),
      ],
    );
  }

  /// display_group 이름을 사람이 읽기 좋은 형태로 변환
  /// 예: shift_attendance → Shift Attendance
  String _formatGroupName(String groupName) {
    return groupName
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }

  Widget _buildSettingItem(
    NotificationSetting setting,
    NotificationSettingsState state,
  ) {
    final isEnabled = state.masterPushEnabled;
    final hasStoreSettings = setting.scopeLevel == 'store';
    final roleType =
        ref.read(notificationSettingsProvider.notifier).cachedRoleType;

    return _buildNotificationToggle(
      title: _formatFeatureName(setting.featureName),
      subtitle: setting.description ?? '',
      value: setting.isEnabled,
      onChanged: (value) {
        ref
            .read(notificationSettingsProvider.notifier)
            .toggleNotification(setting.featureId, value);
      },
      enabled: isEnabled,
      iconKey: setting.iconKey,
      showChevron: hasStoreSettings,
      onChevronTap: hasStoreSettings
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => NotificationStoreSettingsPage(
                    featureId: setting.featureId,
                    featureName: _formatFeatureName(setting.featureName),
                    roleType: roleType ?? 'employee',
                  ),
                ),
              );
            }
          : null,
    );
  }

  /// feature_name을 사람이 읽기 좋은 형태로 변환
  /// 예: shift_start → Shift Start
  String _formatFeatureName(String featureName) {
    return featureName
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
    String? iconKey,
    bool showChevron = false,
    VoidCallback? onChevronTap,
  }) {
    final content = Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          // Icon (optional)
          if (iconKey != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: enabled
                    ? TossColors.primary.withValues(alpha: 0.1)
                    : TossColors.gray200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconFromKey(iconKey),
                size: 20,
                color: enabled ? TossColors.primary : TossColors.gray400,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
          ],
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
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      color: enabled ? TossColors.gray600 : TossColors.gray400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Store 설정 가능한 경우: chevron만 표시
          if (showChevron) ...[
            Icon(
              Icons.chevron_right,
              size: 24,
              color: enabled ? TossColors.gray400 : TossColors.gray300,
            ),
          ] else ...[
            // Store 설정 없는 경우: 토글 표시
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
        ],
      ),
    );

    // Store 설정 가능하면 전체 row 탭 가능
    if (showChevron && onChevronTap != null) {
      return InkWell(
        onTap: onChevronTap,
        child: content,
      );
    }

    return content;
  }

  /// iconKey를 Flutter IconData로 변환
  IconData _getIconFromKey(String? iconKey) {
    switch (iconKey) {
      case 'Clock':
        return Icons.access_time;
      case 'ClockOff':
        return Icons.timer_off_outlined;
      case 'UserX':
        return Icons.person_off_outlined;
      case 'FileText':
        return Icons.description_outlined;
      case 'TrendingDown':
        return Icons.trending_down;
      case 'TrendingUp':
        return Icons.trending_up;
      case 'Bell':
        return Icons.notifications_outlined;
      case 'BellRing':
        return Icons.notifications_active_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}
