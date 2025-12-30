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

import '../../data/datasources/notification_settings_datasource.dart';
import '../providers/notification_settings_provider.dart';
import '../widgets/common_widgets.dart';

/// Store별 알림 상세 설정 페이지
///
/// scope_level이 'store'인 알림 항목에서 ▶ 버튼을 탭하면 이동하는 페이지
/// All Stores 토글 + 개별 Store 토글 제공
class NotificationStoreSettingsPage extends ConsumerStatefulWidget {
  final String featureId;
  final String featureName;
  final String roleType;

  const NotificationStoreSettingsPage({
    super.key,
    required this.featureId,
    required this.featureName,
    required this.roleType,
  });

  @override
  ConsumerState<NotificationStoreSettingsPage> createState() =>
      _NotificationStoreSettingsPageState();
}

class _NotificationStoreSettingsPageState
    extends ConsumerState<NotificationStoreSettingsPage> {
  // Track which groups are expanded (all expanded by default)
  final Set<String> _expandedGroups = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(storeSettingsNotifierProvider.notifier)
          .loadSettings(widget.featureId, widget.roleType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeSettingsNotifierProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar1(
        title: widget.featureName,
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
              ref
                  .read(storeSettingsNotifierProvider.notifier)
                  .loadSettings(widget.featureId, widget.roleType);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(StoreSettingsState state) {
    final settings = state.settings;
    if (settings == null) return const SizedBox.shrink();

    final enabledCount = settings.storeSettings.where((s) => s.isEnabled).length;
    final totalCount = settings.storeSettings.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.screenPaddingMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feature Description - Simple subtitle
          if (settings.description != null &&
              settings.description!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: TossSpacing.space1 / 2),
                    child: Icon(
                      Icons.info_outline,
                      size: 16,
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      settings.description!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space5),
          ],

          // Quick Summary Card
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TossColors.primary.withValues(alpha: 0.08),
                  TossColors.primary.withValues(alpha: 0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Icon(
                    settings.allStoresEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: TossColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$enabledCount of $totalCount stores active',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        settings.allStoresEnabled
                            ? 'All stores enabled'
                            : 'Custom settings',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space6),

          // Quick Actions Row
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.notifications_active,
                  label: 'Notify All',
                  isSelected: settings.allStoresEnabled,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(storeSettingsNotifierProvider.notifier).toggleAllStores(true);
                  },
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.notifications_off,
                  label: 'Mute All',
                  isSelected: !settings.allStoresEnabled,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(storeSettingsNotifierProvider.notifier).toggleAllStores(false);
                  },
                ),
              ),
            ],
          ),

          // Individual Store Settings (Grouped)
          if (settings.storeSettings.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STORES BY LOCATION',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray700,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray200,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Text(
                    '$enabledCount/$totalCount',
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            ..._buildGroupedStores(settings.storeSettings),
          ],

          const SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TossColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? TossColors.white : TossColors.gray700,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? TossColors.white : TossColors.gray900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStoreItem({
    required String storeName,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          // Store icon with status indicator
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? TossColors.primary.withValues(alpha: 0.12)
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.store,
                  size: 20,
                  color: isEnabled ? TossColors.primary : TossColors.gray400,
                ),
              ),
              if (isEnabled)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: TossColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: TossColors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEnabled ? 'Notifications active' : 'Muted',
                  style: TossTextStyles.caption.copyWith(
                    color: isEnabled ? TossColors.success : TossColors.gray500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isEnabled,
            onChanged: (newValue) {
              HapticFeedback.selectionClick();
              onChanged(newValue);
            },
            activeColor: TossColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: (newValue) {
              HapticFeedback.selectionClick();
              onChanged(newValue);
            },
            activeColor: TossColors.primary,
          ),
        ],
      ),
    );
  }

  /// Group stores by company name (database-driven, not hardcoded)
  Map<String, List<StoreSettingItem>> _groupStores(List<StoreSettingItem> stores) {
    final grouped = <String, List<StoreSettingItem>>{};

    for (var store in stores) {
      // Use company_name from database for proper grouping
      // This automatically works for any company - no hardcoding!
      final groupKey = store.companyName ?? 'Unknown Company';

      grouped.putIfAbsent(groupKey, () => []);
      grouped[groupKey]!.add(store);
    }

    return grouped;
  }

  /// Build grouped store widgets
  List<Widget> _buildGroupedStores(List<StoreSettingItem> stores) {
    final grouped = _groupStores(stores);
    final widgets = <Widget>[];

    grouped.forEach((groupName, groupStores) {
      final isExpanded = _expandedGroups.contains(groupName);
      final groupEnabledCount = groupStores.where((s) => s.isEnabled).length;

      widgets.add(
        Column(
          children: [
            _buildGroupHeader(
              groupName: groupName,
              storeCount: groupStores.length,
              enabledCount: groupEnabledCount,
              isExpanded: isExpanded,
              onToggle: () {
                setState(() {
                  if (isExpanded) {
                    _expandedGroups.remove(groupName);
                  } else {
                    _expandedGroups.add(groupName);
                  }
                });
              },
            ),
            if (isExpanded) ...[
              const SizedBox(height: TossSpacing.space2),
              TossWhiteCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: groupStores.asMap().entries.map((entry) {
                    final index = entry.key;
                    final storeSetting = entry.value;
                    return Column(
                      children: [
                        _buildEnhancedStoreItem(
                          storeName: storeSetting.storeName,
                          isEnabled: storeSetting.isEnabled,
                          onChanged: (value) {
                            ref
                                .read(storeSettingsNotifierProvider.notifier)
                                .toggleStore(storeSetting.storeId, value);
                          },
                        ),
                        if (index < groupStores.length - 1)
                          const CommonDivider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
            const SizedBox(height: TossSpacing.space3),
          ],
        ),
      );
    });

    return widgets;
  }

  /// Build collapsible group header
  Widget _buildGroupHeader({
    required String groupName,
    required int storeCount,
    required int enabledCount,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: enabledCount > 0
                ? TossColors.primary.withValues(alpha: 0.2)
                : TossColors.gray200,
          ),
        ),
        child: Row(
          children: [
            // Group icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: enabledCount > 0
                    ? TossColors.primary.withValues(alpha: 0.12)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.business,
                size: 22,
                color: enabledCount > 0 ? TossColors.primary : TossColors.gray400,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$enabledCount of $storeCount stores active',
                    style: TossTextStyles.caption.copyWith(
                      color: enabledCount > 0 ? TossColors.success : TossColors.gray500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // Expand/collapse indicator
            Container(
              padding: const EdgeInsets.all(TossSpacing.space1 + 2),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
                color: TossColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
