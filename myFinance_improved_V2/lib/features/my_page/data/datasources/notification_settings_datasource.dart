import 'package:supabase_flutter/supabase_flutter.dart';

// =============================================================================
// Models
// =============================================================================

/// Notification Setting 모델
class NotificationSetting {
  final String featureId;
  final String featureName;
  final String? description;
  final String? iconKey;
  final String scopeLevel; // 'user' or 'store'
  final String displayGroup; // 'shift_attendance' or 'finance'
  final int sortOrder;
  final bool isEnabled; // All Stores 설정 (store_id=NULL)
  final Map<String?, bool> storePreferences; // store_id -> is_enabled

  NotificationSetting({
    required this.featureId,
    required this.featureName,
    this.description,
    this.iconKey,
    required this.scopeLevel,
    required this.displayGroup,
    required this.sortOrder,
    required this.isEnabled,
    this.storePreferences = const {},
  });

  NotificationSetting copyWith({
    bool? isEnabled,
    Map<String?, bool>? storePreferences,
  }) {
    return NotificationSetting(
      featureId: featureId,
      featureName: featureName,
      description: description,
      iconKey: iconKey,
      scopeLevel: scopeLevel,
      displayGroup: displayGroup,
      sortOrder: sortOrder,
      isEnabled: isEnabled ?? this.isEnabled,
      storePreferences: storePreferences ?? this.storePreferences,
    );
  }

  /// 특정 store의 설정 가져오기
  bool isEnabledForStore(String? storeId) {
    // 1. store별 설정 있으면 사용
    if (storePreferences.containsKey(storeId)) {
      return storePreferences[storeId]!;
    }
    // 2. 없으면 All Stores(null) 설정 따라감
    return storePreferences[null] ?? isEnabled;
  }

  /// store별 상세 설정 가능 여부
  bool get hasStoreSettings => scopeLevel == 'store';
}

/// Store 설정 아이템
class StoreSettingItem {
  final String storeId;
  final String storeName;
  final bool isEnabled;
  final bool isOverridden; // 개별 설정 여부
  final String? companyId; // For database-driven grouping
  final String? companyName; // For display grouping

  StoreSettingItem({
    required this.storeId,
    required this.storeName,
    required this.isEnabled,
    required this.isOverridden,
    this.companyId,
    this.companyName,
  });
}

/// Store 알림 설정 (상세 화면용)
class StoreNotificationSettings {
  final String featureId;
  final String featureName;
  final String? description;
  final bool allStoresEnabled;
  final List<StoreSettingItem> storeSettings;

  StoreNotificationSettings({
    required this.featureId,
    required this.featureName,
    this.description,
    required this.allStoresEnabled,
    required this.storeSettings,
  });
}

// =============================================================================
// DataSource
// =============================================================================

/// Notification Settings DataSource
///
/// 핵심 로직:
/// - row 없음 = 알림 ON (default)
/// - row 있고 is_enabled = false → 알림 OFF
/// - store_id = NULL → All Stores (전체)
/// - store_id = 값 → 해당 store만
class NotificationSettingsDataSource {
  final _supabase = Supabase.instance.client;

  /// 알림 설정 목록 가져오기 (RPC 사용)
  ///
  /// Returns notification settings with master push enabled status and features list.
  /// RPC: my_page_get_notification_settings
  Future<({bool masterPushEnabled, List<NotificationSetting> features})> getNotificationSettings({
    required String userId,
    required String companyId,
    required String roleId,
    required String roleType,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>?>(
        'my_page_get_notification_settings',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_role_id': roleId,
          'p_role_type': roleType,
        },
      );

      if (response == null) {
        return (masterPushEnabled: true, features: <NotificationSetting>[]);
      }

      final masterPushEnabled = response['master_push_enabled'] as bool? ?? true;
      final featuresJson = response['features'] as List<dynamic>? ?? [];

      final features = featuresJson.map((f) {
        final featureMap = Map<String, dynamic>.from(f as Map);

        // Parse store_preferences from JSON object
        final storePrefsJson = featureMap['store_preferences'] as Map<String, dynamic>? ?? {};
        final storePreferences = <String?, bool>{};

        for (final entry in storePrefsJson.entries) {
          // 'null' string key means store_id is NULL (All Stores)
          final storeId = entry.key == 'null' ? null : entry.key;
          storePreferences[storeId] = entry.value as bool;
        }

        return NotificationSetting(
          featureId: featureMap['feature_id'] as String,
          featureName: featureMap['feature_name'] as String,
          description: featureMap['feature_description'] as String?,
          iconKey: featureMap['icon_key'] as String?,
          scopeLevel: featureMap['scope_level'] as String? ?? 'user',
          displayGroup: featureMap['display_group'] as String? ?? 'general',
          sortOrder: featureMap['sort_order'] as int? ?? 0,
          isEnabled: featureMap['is_enabled'] as bool? ?? true,
          storePreferences: storePreferences,
        );
      }).toList();

      return (masterPushEnabled: masterPushEnabled, features: features);
    } catch (e) {
      throw Exception('Failed to get notification settings: $e');
    }
  }

  /// Store별 상세 설정 가져오기 (RPC 사용)
  ///
  /// Uses my_page_get_store_settings RPC to get store-level notification settings.
  Future<StoreNotificationSettings> getStoreSettings({
    required String userId,
    required String companyId,
    required String featureId,
    required String roleType,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>?>(
        'my_page_get_store_settings',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_feature_id': featureId,
          'p_role_type': roleType,
        },
      );

      if (response == null) {
        return StoreNotificationSettings(
          featureId: featureId,
          featureName: '',
          description: null,
          allStoresEnabled: true,
          storeSettings: [],
        );
      }

      final allStoresEnabled = response['all_stores_enabled'] as bool? ?? true;
      final storeSettingsJson = response['store_settings'] as List<dynamic>? ?? [];

      final storeSettings = storeSettingsJson.map((store) {
        final storeMap = store as Map<String, dynamic>;
        return StoreSettingItem(
          storeId: storeMap['store_id'] as String,
          storeName: storeMap['store_name'] as String? ?? '',
          isEnabled: storeMap['is_enabled'] as bool? ?? allStoresEnabled,
          isOverridden: storeMap['is_overridden'] as bool? ?? false,
          companyId: storeMap['company_id'] as String?,
          companyName: storeMap['company_name'] as String?,
        );
      }).toList();

      return StoreNotificationSettings(
        featureId: response['feature_id'] as String? ?? featureId,
        featureName: response['feature_name'] as String? ?? '',
        description: response['feature_description'] as String?,
        allStoresEnabled: allStoresEnabled,
        storeSettings: storeSettings,
      );
    } catch (e) {
      throw Exception('Failed to get store settings: $e');
    }
  }

  /// 접근 가능한 Store 목록 가져오기 (RPC 사용)
  ///
  /// Uses get_user_companies_and_stores_v2 RPC to get stores with company info.
  /// The RPC returns all companies and stores the user has access to.
  Future<List<Map<String, dynamic>>> getAccessibleStores({
    required String userId,
    required String companyId,
    required String roleType,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>?>(
        'get_user_companies_and_stores_v2',
        params: {'p_user_id': userId},
      );

      if (response == null) return [];

      final companies = response['companies'] as List<dynamic>? ?? [];

      // Find the specific company
      final companyData = companies.firstWhere(
        (c) => (c as Map<String, dynamic>)['company_id'] == companyId,
        orElse: () => null,
      );

      if (companyData == null) return [];

      final companyMap = companyData as Map<String, dynamic>;
      final companyName = companyMap['company_name'] as String? ?? 'Unknown';
      final stores = companyMap['stores'] as List<dynamic>? ?? [];

      return stores.map((store) {
        final storeMap = store as Map<String, dynamic>;
        return {
          'store_id': storeMap['store_id'] as String,
          'store_name': storeMap['store_name'] as String,
          'company_id': companyId,
          'company_name': companyName,
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get accessible stores: $e');
    }
  }

  /// 알림 토글 (RPC 사용)
  ///
  /// Uses my_page_toggle_notification RPC to toggle notification settings.
  /// - enabled = true: Delete row (no row = default ON)
  /// - enabled = false: Upsert with is_enabled = false
  Future<void> toggle({
    required String userId,
    required String featureId,
    required String companyId,
    String? storeId,
    required bool currentValue,
  }) async {
    try {
      await _supabase.rpc<Map<String, dynamic>>(
        'my_page_toggle_notification',
        params: {
          'p_user_id': userId,
          'p_feature_id': featureId,
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_enabled': !currentValue, // Toggle: flip the current value
        },
      );
    } catch (e) {
      throw Exception('Failed to toggle notification: $e');
    }
  }

  // ===========================================================================
  // Role Info (사용자 역할 정보)
  // ===========================================================================

  /// 현재 유저의 role_id, role_type 가져오기 (RPC 사용)
  ///
  /// Uses get_user_companies_and_stores_v2 RPC to get role info.
  Future<({String roleId, String roleType})?> getCurrentUserRoleInfo({
    required String userId,
    required String companyId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>?>(
        'get_user_companies_and_stores_v2',
        params: {'p_user_id': userId},
      );

      if (response == null) return null;

      final companies = response['companies'] as List<dynamic>? ?? [];

      // Find the specific company
      final companyData = companies.firstWhere(
        (c) => (c as Map<String, dynamic>)['company_id'] == companyId,
        orElse: () => null,
      );

      if (companyData == null) return null;

      final companyMap = companyData as Map<String, dynamic>;
      final role = companyMap['role'] as Map<String, dynamic>?;

      if (role == null) return null;

      final roleId = role['role_id'] as String?;
      final roleType = role['role_type'] as String? ?? 'employee';

      if (roleId == null) return null;

      return (roleId: roleId, roleType: roleType);
    } catch (e) {
      return null;
    }
  }

  // ===========================================================================
  // Master Push Settings (user_notification_settings)
  // ===========================================================================

  /// Master Push 설정 저장 (RPC 사용)
  ///
  /// Uses my_page_update_user_settings RPC with master_push action.
  Future<void> setMasterPushEnabled({
    required String userId,
    required bool enabled,
  }) async {
    try {
      await _supabase.rpc<Map<String, dynamic>>(
        'my_page_update_user_settings',
        params: {
          'p_user_id': userId,
          'p_action': 'master_push',
          'p_data': {'push_enabled': enabled},
        },
      );
    } catch (e) {
      throw Exception('Failed to update master push setting: $e');
    }
  }
}
