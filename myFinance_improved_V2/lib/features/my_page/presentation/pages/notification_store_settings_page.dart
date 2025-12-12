import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_white_card.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(storeSettingsProvider.notifier)
          .loadSettings(widget.featureId, widget.roleType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeSettingsProvider);

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
                  .read(storeSettingsProvider.notifier)
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.screenPaddingMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feature Description
          if (settings.description != null &&
              settings.description!.isNotEmpty) ...[
            Text(
              settings.description!,
              style: TossTextStyles.body.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space6),
          ],

          // All Stores Toggle
          Text(
            'Default Setting',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TossWhiteCard(
            padding: EdgeInsets.zero,
            child: _buildToggleItem(
              title: 'All Stores',
              value: settings.allStoresEnabled,
              onChanged: (value) {
                ref.read(storeSettingsProvider.notifier).toggleAllStores(value);
              },
            ),
          ),

          // Individual Store Settings
          if (settings.storeSettings.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space6),
            Text(
              'Store Settings',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            TossWhiteCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: settings.storeSettings
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final storeSetting = entry.value;
                      return Column(
                        children: [
                          _buildToggleItem(
                            title: storeSetting.storeName,
                            value: storeSetting.isEnabled,
                            onChanged: (value) {
                              ref
                                  .read(storeSettingsProvider.notifier)
                                  .toggleStore(storeSetting.storeId, value);
                            },
                          ),
                          if (index < settings.storeSettings.length - 1)
                            const CommonDivider(),
                        ],
                      );
                    })
                    .toList(),
              ),
            ),
          ],

          const SizedBox(height: TossSpacing.space8),
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
}
