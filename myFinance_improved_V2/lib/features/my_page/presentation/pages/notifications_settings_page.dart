import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';

import '../../data/datasources/notification_settings_datasource.dart';
import '../providers/notification_settings_provider.dart';
import 'notification_store_settings_page.dart';

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
      ref.read(notificationSettingsProvider.notifier).loadSettings();
    });
  }

  /// Play preview for selected alert mode
  Future<void> _playAlertPreview(int mode) async {
    try {
      switch (mode) {
        case 0: // Full Alerts
          await _playSound();
          await _playVibration();
          break;
        case 1: // Sound Only
          await _playSound();
          break;
        case 2: // Vibration Only
          await _playVibration();
          break;
        case 3: // Visual Only
          // Show visual-only preview (banner animation)
          if (!_isDesktop) {
            HapticFeedback.lightImpact(); // Mobile only
          }
          _showVisualPreview();
          break;
      }
    } catch (e) {
      debugPrint('Preview error: $e');
    }
  }

  /// Check if running on desktop platform
  bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Play notification sound (mobile + desktop compatible)
  Future<void> _playSound() async {
    if (_isDesktop) {
      // Desktop: Show visual feedback since SystemSound doesn't work
      debugPrint('🔊 Sound preview (desktop platforms don\'t support SystemSound)');
      // Alternative: Could use audioplayers package for desktop audio
      return;
    }

    // Mobile: Use system notification sound
    await SystemSound.play(SystemSoundType.alert);
  }

  /// Play vibration pattern (mobile-only)
  Future<void> _playVibration() async {
    if (_isDesktop) {
      // Desktop: No vibration support (no vibration motors)
      debugPrint('📳 Vibration preview (desktop platforms don\'t have vibration)');
      return;
    }

    // Mobile: Double vibration pattern
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// Show visual-only preview - iOS-style top banner
  void _showVisualPreview() {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8, // Below status bar
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            tween: Tween(begin: -100.0, end: 0.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray900,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // App icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TossColors.primary,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: const Icon(
                      Icons.store_rounded,
                      color: TossColors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Shift Starting Soon',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Your shift starts in 15 minutes',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Time indicator
                  Text(
                    'now',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-dismiss after 3 seconds with slide-up animation
    Future<void>.delayed(const Duration(milliseconds: 3000), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationSettingsProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: const TossAppBar1(
        title: 'Notifications',
        backgroundColor: TossColors.gray100,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? _buildErrorView(state.errorMessage!)
              : _buildModernContent(state),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 40,
              color: TossColors.error,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'Failed to load settings',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Please try again',
            style: TossTextStyles.body.copyWith(color: TossColors.gray600),
          ),
          const SizedBox(height: TossSpacing.space4),
          ElevatedButton(
            onPressed: () {
              ref.read(notificationSettingsProvider.notifier).loadSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space6,
                vertical: TossSpacing.space3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildModernContent(NotificationSettingsState state) {
    final groupedSettings = state.groupedSettings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section with Master Toggle
          _buildHeroSection(state),

          const SizedBox(height: TossSpacing.space6),

          // General notification controls
          if (state.masterPushEnabled) ...[
            _buildGeneralControls(),
            const SizedBox(height: TossSpacing.space6),
          ],

          // Notification Categories (when master is enabled)
          if (state.masterPushEnabled && groupedSettings.isNotEmpty) ...[
            ...groupedSettings.entries.map((entry) {
              final groupName = entry.key;
              final settings = entry.value;
              return _buildModernGroupSection(groupName, settings, state);
            }),
          ],

          // Empty State (when master is enabled but no settings)
          if (state.masterPushEnabled &&
              state.settings.isEmpty &&
              !state.isLoading) ...[
            _buildEmptyState(),
          ],

          // Disabled State (when master is off)
          if (!state.masterPushEnabled) _buildDisabledState(),

          const SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }

  /// Hero section with master toggle and description
  Widget _buildHeroSection(NotificationSettingsState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary.withValues(alpha: 0.08),
            TossColors.primary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: state.masterPushEnabled
                      ? TossColors.primary
                      : TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  boxShadow: state.masterPushEnabled
                      ? [
                          BoxShadow(
                            color: TossColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  state.masterPushEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off_outlined,
                  color: TossColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: TossSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Push Notifications',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      state.masterPushEnabled
                          ? 'Active and ready'
                          : 'Currently disabled',
                      style: TossTextStyles.caption.copyWith(
                        color: state.masterPushEnabled
                            ? TossColors.primary
                            : TossColors.gray600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: state.masterPushEnabled,
                onChanged: (value) {
                  HapticFeedback.mediumImpact();
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .toggleMasterPush(value);
                },
                activeColor: TossColors.primary,
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.info_outline,
                  size: 16,
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
          ),
        ],
      ),
    );
  }

  /// General notification controls for business alerts
  Widget _buildGeneralControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: TossSpacing.space2,
            bottom: TossSpacing.space3,
          ),
          child: Text(
            'ALERT MODE',
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            boxShadow: [
              BoxShadow(
                color: TossColors.gray900.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildAlertModeOption(
                icon: Icons.notifications_active_rounded,
                title: 'Full Alerts',
                description: 'Sound + Vibration',
                mode: 0,
                isSelected: _selectedAlertMode == 0,
                isFirst: true,
                onTap: () {
                  setState(() {
                    _selectedAlertMode = 0;
                  });
                  _playAlertPreview(0); // Play preview when user taps
                  // TODO: Save to backend
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
              ),
              _buildAlertModeOption(
                icon: Icons.volume_up_rounded,
                title: 'Sound Only',
                description: 'Best for desk work',
                mode: 1,
                isSelected: _selectedAlertMode == 1,
                onTap: () {
                  setState(() {
                    _selectedAlertMode = 1;
                  });
                  _playAlertPreview(1); // Play preview when user taps
                  // TODO: Save to backend
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
              ),
              _buildAlertModeOption(
                icon: Icons.vibration_rounded,
                title: 'Vibration Only',
                description: 'Best for meetings',
                mode: 2,
                isSelected: _selectedAlertMode == 2,
                onTap: () {
                  setState(() {
                    _selectedAlertMode = 2;
                  });
                  _playAlertPreview(2); // Play preview when user taps
                  // TODO: Save to backend
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
              ),
              _buildAlertModeOption(
                icon: Icons.notifications_off_rounded,
                title: 'Visual Only',
                description: 'Silent notifications',
                mode: 3,
                isSelected: _selectedAlertMode == 3,
                isLast: true,
                onTap: () {
                  setState(() {
                    _selectedAlertMode = 3;
                  });
                  _playAlertPreview(3); // Play preview when user taps
                  // TODO: Save to backend
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build individual alert mode option
  Widget _buildAlertModeOption({
    required IconData icon,
    required String title,
    required String description,
    required int mode,
    required bool isSelected,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(TossBorderRadius.xl) : Radius.zero,
        bottom: isLast ? Radius.circular(TossBorderRadius.xl) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primarySurface : TossColors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: 0.15)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? TossColors.primary : TossColors.gray600,
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
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? TossColors.primary : TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    description,
                    style: TossTextStyles.caption.copyWith(
                      color: isSelected ? TossColors.primary.withValues(alpha: 0.7) : TossColors.gray600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: TossColors.primary,
                size: 24,
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: TossColors.gray300,
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Individual notification control item
  Widget _buildGeneralControl({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              icon,
              size: 22,
              color: TossColors.primary,
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
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  subtitle,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: TossColors.primary,
          ),
        ],
      ),
    );
  }

  /// Modern group section with enhanced visuals
  Widget _buildModernGroupSection(
    String groupName,
    List<NotificationSetting> settings,
    NotificationSettingsState state,
  ) {
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
            _formatGroupName(groupName),
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
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
                color: TossColors.gray900.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: settings
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final setting = entry.value;
                  return Column(
                    children: [
                      _buildModernSettingItem(setting, state),
                      if (index < settings.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space4,
                          ),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: TossColors.gray100,
                          ),
                        ),
                    ],
                  );
                })
                .toList(),
          ),
        ),

        const SizedBox(height: TossSpacing.space5),
      ],
    );
  }

  /// Modern setting item with enhanced interaction
  Widget _buildModernSettingItem(
    NotificationSetting setting,
    NotificationSettingsState state,
  ) {
    final isEnabled = state.masterPushEnabled;
    final hasStoreSettings = setting.scopeLevel == 'store';
    final roleType =
        ref.read(notificationSettingsProvider.notifier).cachedRoleType;

    final content = Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          // Icon with consistent styling
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              _getIconFromKey(setting.iconKey),
              size: 22,
              color: TossColors.primary,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatFeatureName(setting.featureName),
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
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
            ),
          ),

          // Action (Store settings or toggle)
          if (hasStoreSettings) ...[
            Icon(
              Icons.chevron_right,
              size: 24,
              color: isEnabled ? TossColors.gray400 : TossColors.gray300,
            ),
          ] else ...[
            Switch.adaptive(
              value: isEnabled ? setting.isEnabled : false,
              onChanged: isEnabled
                  ? (newValue) {
                      HapticFeedback.selectionClick();
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .toggleNotification(setting.featureId, newValue);
                    }
                  : null,
              activeColor: TossColors.primary,
            ),
          ],
        ],
      ),
    );

    // Make tappable if has store settings
    if (hasStoreSettings && isEnabled) {
      return InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => NotificationStoreSettingsPage(
                featureId: setting.featureId,
                featureName: _formatFeatureName(setting.featureName),
                roleType: roleType ?? 'employee',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: content,
      );
    }

    return content;
  }

  /// Empty state when no settings available
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space8),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 40,
                color: TossColors.gray400,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No notification settings',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
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

  /// Disabled state when master toggle is off
  Widget _buildDisabledState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 48,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Notifications are disabled',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
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

  String _formatGroupName(String groupName) {
    return groupName
        .split('_')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  String _formatFeatureName(String featureName) {
    return featureName
        .split('_')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  IconData _getIconFromKey(String? iconKey) {
    switch (iconKey) {
      case 'Clock':
        return Icons.access_time_rounded; // Regular clock for shift start
      case 'ClockOff':
        return Icons.timer_off_outlined; // Clock off for shift end
      case 'UserX':
        // Icon for "late" - warning/alert about time
        return Icons.running_with_errors_rounded; // Person running (late) with emphasis
      case 'FileText':
        return Icons.description_outlined;
      case 'TrendingDown':
        return Icons.trending_down_rounded;
      case 'TrendingUp':
        return Icons.trending_up_rounded;
      case 'Bell':
        return Icons.notifications_outlined;
      case 'BellRing':
        return Icons.notifications_active_outlined;
      case 'DollarSign':
        return Icons.attach_money_rounded;
      case 'Receipt':
        return Icons.receipt_long_outlined;
      case 'Users':
        return Icons.groups_outlined;
      case 'AlertCircle':
        return Icons.error_outline_rounded;
      case 'CheckCircle':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.notifications_outlined;
    }
  }
}
