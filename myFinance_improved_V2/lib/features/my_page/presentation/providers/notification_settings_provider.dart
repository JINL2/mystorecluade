import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../data/datasources/notification_settings_datasource.dart';

part 'notification_settings_provider.g.dart';

// =============================================================================
// Type Aliases
// =============================================================================

/// Role 정보 타입 (DataSource에서 반환하는 Record 타입)
typedef RoleInfo = ({String roleId, String roleType});

// =============================================================================
// DataSource Provider
// =============================================================================

/// NotificationSettingsDataSource Provider
@Riverpod(keepAlive: true)
NotificationSettingsDataSource notificationSettingsDataSource(Ref ref) {
  return NotificationSettingsDataSource();
}

// =============================================================================
// State Classes
// =============================================================================

/// Notification Settings State (메인 화면)
class NotificationSettingsState {
  final bool isLoading;
  final bool masterPushEnabled;
  final List<NotificationSetting> settings;
  final String? errorMessage;

  const NotificationSettingsState({
    this.isLoading = false,
    this.masterPushEnabled = true,
    this.settings = const [],
    this.errorMessage,
  });

  NotificationSettingsState copyWith({
    bool? isLoading,
    bool? masterPushEnabled,
    List<NotificationSetting>? settings,
    String? errorMessage,
  }) {
    return NotificationSettingsState(
      isLoading: isLoading ?? this.isLoading,
      masterPushEnabled: masterPushEnabled ?? this.masterPushEnabled,
      settings: settings ?? this.settings,
      errorMessage: errorMessage,
    );
  }

  /// display_group별로 그룹핑된 설정 반환
  Map<String, List<NotificationSetting>> get groupedSettings {
    final grouped = <String, List<NotificationSetting>>{};
    for (var setting in settings) {
      grouped.putIfAbsent(setting.displayGroup, () => []);
      grouped[setting.displayGroup]!.add(setting);
    }
    return grouped;
  }
}

/// Store 상세 설정 State
class StoreSettingsState {
  final bool isLoading;
  final StoreNotificationSettings? settings;
  final String? errorMessage;

  const StoreSettingsState({
    this.isLoading = false,
    this.settings,
    this.errorMessage,
  });

  StoreSettingsState copyWith({
    bool? isLoading,
    StoreNotificationSettings? settings,
    String? errorMessage,
  }) {
    return StoreSettingsState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      errorMessage: errorMessage,
    );
  }
}

// =============================================================================
// Main Settings Notifier
// =============================================================================

/// Notification Settings Notifier (메인 화면)
@riverpod
class NotificationSettingsNotifier extends _$NotificationSettingsNotifier {
  late final NotificationSettingsDataSource _dataSource;
  RoleInfo? _cachedRoleInfo;

  @override
  NotificationSettingsState build() {
    _dataSource = ref.watch(notificationSettingsDataSourceProvider);
    return const NotificationSettingsState();
  }

  /// 현재 사용자 ID 가져오기 (Auth Provider 통해)
  String? get _currentUserId => ref.read(currentUserIdProvider);

  /// 알림 설정 로드
  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final appState = ref.read(appStateProvider);
      final userId = _currentUserId;
      final companyId = appState.companyChoosen;

      // ignore: avoid_print
      print('[NotificationSettings] userId: $userId, companyId: $companyId');

      if (userId == null || companyId.isEmpty) {
        // ignore: avoid_print
        print('[NotificationSettings] ERROR: User or company not found');
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'User or company not found',
        );
        return;
      }

      // user_roles에서 현재 유저의 role_id, role_type 가져오기 (DataSource 통해)
      final roleInfo = await _dataSource.getCurrentUserRoleInfo(
        userId: userId,
        companyId: companyId,
      );
      // ignore: avoid_print
      print('[NotificationSettings] roleInfo: $roleInfo');

      if (roleInfo == null) {
        // ignore: avoid_print
        print('[NotificationSettings] ERROR: User role not found');
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'User role not found',
        );
        return;
      }

      _cachedRoleInfo = roleInfo;

      // Master Push 설정 로드
      final masterPushEnabled = await _dataSource.getMasterPushEnabled(
        userId: userId,
      );

      final settings = await _dataSource.getNotificationSettings(
        userId: userId,
        companyId: companyId,
        roleId: roleInfo.roleId,
        roleType: roleInfo.roleType,
      );

      // ignore: avoid_print
      print('[NotificationSettings] Loaded ${settings.length} settings, masterPush: $masterPushEnabled');

      state = state.copyWith(
        isLoading: false,
        settings: settings,
        masterPushEnabled: masterPushEnabled,
      );
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[NotificationSettings] ERROR: $e');
      // ignore: avoid_print
      print('[NotificationSettings] StackTrace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Master Push 토글
  Future<void> toggleMasterPush(bool value) async {
    // 낙관적 업데이트 (UI 먼저 반영)
    state = state.copyWith(masterPushEnabled: value);

    try {
      final appState = ref.read(appStateProvider);
      final userId = _currentUserId;
      final companyId = appState.companyChoosen;

      if (userId == null || companyId.isEmpty) return;

      // DB 저장
      await _dataSource.setMasterPushEnabled(
        userId: userId,
        enabled: value,
      );
    } catch (e) {
      // 실패 시 원복
      state = state.copyWith(
        masterPushEnabled: !value,
        errorMessage: e.toString(),
      );
    }
  }

  /// 개별 알림 토글 (All Stores)
  Future<void> toggleNotification(String featureId, bool newValue) async {
    try {
      final appState = ref.read(appStateProvider);
      final userId = _currentUserId;
      final companyId = appState.companyChoosen;

      if (userId == null || companyId.isEmpty) return;

      // 낙관적 업데이트 (UI 먼저 반영)
      final updatedSettings = state.settings.map((s) {
        if (s.featureId == featureId) {
          return s.copyWith(isEnabled: newValue);
        }
        return s;
      }).toList();

      state = state.copyWith(settings: updatedSettings);

      // DB 업데이트
      await _dataSource.toggle(
        userId: userId,
        featureId: featureId,
        companyId: companyId,
        storeId: null, // All Stores
        currentValue: !newValue, // 이전 값
      );
    } catch (e) {
      // 실패 시 원복
      await loadSettings();
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 캐시된 roleType 반환
  String? get cachedRoleType => _cachedRoleInfo?.roleType;

  /// 에러 클리어
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// =============================================================================
// Store Settings Notifier
// =============================================================================

/// Store 상세 설정 Notifier
@riverpod
class StoreSettingsNotifier extends _$StoreSettingsNotifier {
  late final NotificationSettingsDataSource _dataSource;
  String? _currentFeatureId;

  @override
  StoreSettingsState build() {
    _dataSource = ref.watch(notificationSettingsDataSourceProvider);
    return const StoreSettingsState();
  }

  /// 현재 사용자 ID 가져오기 (Auth Provider 통해)
  String? get _currentUserId => ref.read(currentUserIdProvider);

  /// Store 설정 로드
  Future<void> loadSettings(String featureId, String roleType) async {
    _currentFeatureId = featureId;
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final appState = ref.read(appStateProvider);
      final userId = _currentUserId;
      final companyId = appState.companyChoosen;

      if (userId == null || companyId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'User or company not found',
        );
        return;
      }

      final settings = await _dataSource.getStoreSettings(
        userId: userId,
        companyId: companyId,
        featureId: featureId,
        roleType: roleType,
      );

      state = state.copyWith(
        isLoading: false,
        settings: settings,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// All Stores 토글
  Future<void> toggleAllStores(bool newValue) async {
    if (state.settings == null || _currentFeatureId == null) return;

    try {
      final appState = ref.read(appStateProvider);
      final userId = _currentUserId;
      final companyId = appState.companyChoosen;

      if (userId == null || companyId.isEmpty) return;

      // Update all individual stores to match the new value
      final updatedStoreSettings = state.settings!.storeSettings.map((s) {
        return StoreSettingItem(
          storeId: s.storeId,
          storeName: s.storeName,
          isEnabled: newValue,
          isOverridden: false, // Reset override when using "All Stores"
          companyId: s.companyId,
          companyName: s.companyName,
        );
      }).toList();

      // 낙관적 업데이트
      state = state.copyWith(
        settings: StoreNotificationSettings(
          featureId: state.settings!.featureId,
          featureName: state.settings!.featureName,
          description: state.settings!.description,
          allStoresEnabled: newValue,
          storeSettings: updatedStoreSettings,
        ),
      );

      // DB 업데이트
      await _dataSource.toggle(
        userId: userId,
        featureId: _currentFeatureId!,
        companyId: companyId,
        storeId: null,
        currentValue: !newValue,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 개별 Store 토글
  Future<void> toggleStore(String storeId, bool newValue) async {
    if (state.settings == null || _currentFeatureId == null) return;

    try {
      final appState = ref.read(appStateProvider);
      final userId = _currentUserId;
      final companyId = appState.companyChoosen;

      if (userId == null || companyId.isEmpty) return;

      // 낙관적 업데이트
      final updatedStoreSettings = state.settings!.storeSettings.map((s) {
        if (s.storeId == storeId) {
          return StoreSettingItem(
            storeId: s.storeId,
            storeName: s.storeName,
            isEnabled: newValue,
            isOverridden: true,
            companyId: s.companyId,
            companyName: s.companyName,
          );
        }
        return s;
      }).toList();

      state = state.copyWith(
        settings: StoreNotificationSettings(
          featureId: state.settings!.featureId,
          featureName: state.settings!.featureName,
          description: state.settings!.description,
          allStoresEnabled: state.settings!.allStoresEnabled,
          storeSettings: updatedStoreSettings,
        ),
      );

      // DB 업데이트
      await _dataSource.toggle(
        userId: userId,
        featureId: _currentFeatureId!,
        companyId: companyId,
        storeId: storeId,
        currentValue: !newValue,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 에러 클리어
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
