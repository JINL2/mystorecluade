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

  /// 알림 설정 목록 가져오기
  Future<List<NotificationSetting>> getNotificationSettings({
    required String userId,
    required String companyId,
    required String roleId,
    required String roleType,
  }) async {
    try {
      // 1. Notification 카테고리 ID 가져오기
      final categoryRes = await _supabase
          .from('categories')
          .select('category_id')
          .eq('name', 'Notification')
          .maybeSingle();

      // 카테고리가 없으면 빈 리스트 반환
      if (categoryRes == null) {
        return [];
      }

      final categoryId = categoryRes['category_id'] as String;

      // 2. features 가져오기 (notification_configs 조인 시도)
      List<Map<String, dynamic>> featuresRes;
      try {
        featuresRes = await _supabase
            .from('features')
            .select('''
              feature_id,
              feature_name,
              feature_description,
              icon_key,
              notification_configs(
                scope_level,
                display_group,
                sort_order,
                is_active
              )
            ''')
            .eq('category_id', categoryId);
      } catch (e) {
        // notification_configs 테이블이 없으면 기본 features만 가져오기
        featuresRes = await _supabase
            .from('features')
            .select('feature_id, feature_name, feature_description, icon_key')
            .eq('category_id', categoryId);
      }

      // 3. 접근 가능한 feature_id Set
      Set<String> accessibleFeatures;

      if (roleType == 'owner') {
        // owner는 전부 접근 가능
        accessibleFeatures =
            featuresRes.map((f) => f['feature_id'] as String).toSet();
      } else {
        // owner 아니면 role_permissions 체크 (row가 있으면 권한 있음)
        final rolePermRes = await _supabase
            .from('role_permissions')
            .select('feature_id')
            .eq('role_id', roleId);

        accessibleFeatures =
            rolePermRes.map((r) => r['feature_id'] as String).toSet();
      }

      // 4. notification_preferences에서 개인 설정 가져오기
      final prefsRes = await _supabase
          .from('notification_preferences')
          .select('feature_id, store_id, is_enabled')
          .eq('user_id', userId)
          .eq('company_id', companyId);

      // preferences Map: feature_id -> { store_id -> is_enabled }
      final prefsMap = <String, Map<String?, bool>>{};
      for (var p in prefsRes) {
        final fid = p['feature_id'] as String;
        final sid = p['store_id'] as String?;
        final enabled = p['is_enabled'] as bool;

        prefsMap.putIfAbsent(fid, () => {});
        prefsMap[fid]![sid] = enabled;
      }

      // 5. 결과 조합
      final result = <NotificationSetting>[];

      for (var f in featuresRes) {
        final featureId = f['feature_id'] as String;

        // 권한 없으면 스킵
        if (!accessibleFeatures.contains(featureId)) continue;

        // notification_configs 처리 (없을 수 있음)
        // 1:1 관계면 Map, 1:N 관계면 List로 반환됨
        Map<String, dynamic>? config;
        final configData = f['notification_configs'];

        if (configData != null) {
          if (configData is List && configData.isNotEmpty) {
            config = configData.first as Map<String, dynamic>;
          } else if (configData is Map<String, dynamic>) {
            config = configData;
          }

          // is_active가 false면 스킵
          if (config != null && config['is_active'] == false) continue;
        }

        // feature의 preferences
        final featurePrefs = prefsMap[featureId] ?? {};
        // All Stores 설정 (store_id=NULL), default true
        final allStoresEnabled = featurePrefs[null] ?? true;

        result.add(NotificationSetting(
          featureId: featureId,
          featureName: f['feature_name'] as String,
          description: f['feature_description'] as String?,
          iconKey: f['icon_key'] as String?,
          scopeLevel: config?['scope_level'] as String? ?? 'user',
          displayGroup: config?['display_group'] as String? ?? 'general',
          sortOrder: config?['sort_order'] as int? ?? 0,
          isEnabled: allStoresEnabled,
          storePreferences: featurePrefs,
        ),);
      }

      // 정렬: display_group → sort_order
      result.sort((a, b) {
        final groupCompare = a.displayGroup.compareTo(b.displayGroup);
        if (groupCompare != 0) return groupCompare;
        return a.sortOrder.compareTo(b.sortOrder);
      });

      return result;
    } catch (e) {
      throw Exception('Failed to get notification settings: $e');
    }
  }

  /// Store별 상세 설정 가져오기
  Future<StoreNotificationSettings> getStoreSettings({
    required String userId,
    required String companyId,
    required String featureId,
    required String roleType,
  }) async {
    try {
      // 1. feature 정보 가져오기
      final featureRes = await _supabase
          .from('features')
          .select('feature_name, feature_description')
          .eq('feature_id', featureId)
          .single();

      // 2. 접근 가능한 store 목록
      final stores = await getAccessibleStores(
        userId: userId,
        companyId: companyId,
        roleType: roleType,
      );

      // 3. 이 feature의 preferences
      final prefsRes = await _supabase
          .from('notification_preferences')
          .select('store_id, is_enabled')
          .eq('user_id', userId)
          .eq('feature_id', featureId)
          .eq('company_id', companyId);

      final prefsMap = <String?, bool>{};
      for (var p in prefsRes) {
        prefsMap[p['store_id'] as String?] = p['is_enabled'] as bool;
      }

      // 4. All Stores 설정
      final allStoresEnabled = prefsMap[null] ?? true;

      // 5. 각 store 설정
      final storeSettings = stores.map((store) {
        final enabled = prefsMap.containsKey(store['store_id'])
            ? prefsMap[store['store_id']]!
            : allStoresEnabled;

        return StoreSettingItem(
          storeId: store['store_id'] as String,
          storeName: store['store_name'] as String,
          isEnabled: enabled,
          isOverridden: prefsMap.containsKey(store['store_id']),
          companyId: store['company_id'] as String?,
          companyName: store['company_name'] as String?,
        );
      }).toList();

      return StoreNotificationSettings(
        featureId: featureId,
        featureName: featureRes['feature_name'] as String,
        description: featureRes['feature_description'] as String?,
        allStoresEnabled: allStoresEnabled,
        storeSettings: storeSettings,
      );
    } catch (e) {
      throw Exception('Failed to get store settings: $e');
    }
  }

  /// 접근 가능한 Store 목록 가져오기
  Future<List<Map<String, dynamic>>> getAccessibleStores({
    required String userId,
    required String companyId,
    required String roleType,
  }) async {
    try {
      if (roleType == 'owner') {
        // owner는 전체 store - with company info for grouping
        final res = await _supabase
            .from('stores')
            .select('store_id, store_name, company_id, companies!inner(company_name)')
            .eq('company_id', companyId)
            .eq('is_deleted', false)
            .order('store_name');

        return res.map((store) {
          return {
            'store_id': store['store_id'],
            'store_name': store['store_name'],
            'company_id': store['company_id'],
            'company_name': (store['companies'] as Map?)?['company_name'] ?? 'Unknown',
          };
        }).toList();
      } else {
        // owner 아니면 user_stores에서 가져오기 - with company info
        final res = await _supabase
            .from('user_stores')
            .select('stores!inner(store_id, store_name, company_id, companies!inner(company_name))')
            .eq('user_id', userId)
            .eq('is_deleted', false);

        return res.map((us) {
          final s = us['stores'] as Map<String, dynamic>;
          final companies = s['companies'] as Map?;
          return {
            'store_id': s['store_id'],
            'store_name': s['store_name'],
            'company_id': s['company_id'],
            'company_name': companies?['company_name'] ?? 'Unknown',
          };
        }).toList();
      }
    } catch (e) {
      throw Exception('Failed to get accessible stores: $e');
    }
  }

  /// 알림 끄기 (OFF) - upsert
  Future<void> turnOff({
    required String userId,
    required String featureId,
    required String companyId,
    String? storeId,
  }) async {
    try {
      await _supabase.from('notification_preferences').upsert(
        {
          'user_id': userId,
          'feature_id': featureId,
          'company_id': companyId,
          'store_id': storeId,
          'is_enabled': false,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'user_id,feature_id,company_id,store_id',
      );
    } catch (e) {
      throw Exception('Failed to turn off notification: $e');
    }
  }

  /// 알림 켜기 (ON) - row 삭제
  Future<void> turnOn({
    required String userId,
    required String featureId,
    required String companyId,
    String? storeId,
  }) async {
    try {
      var query = _supabase
          .from('notification_preferences')
          .delete()
          .eq('user_id', userId)
          .eq('feature_id', featureId)
          .eq('company_id', companyId);

      if (storeId == null) {
        query = query.isFilter('store_id', null);
      } else {
        query = query.eq('store_id', storeId);
      }

      await query;
    } catch (e) {
      throw Exception('Failed to turn on notification: $e');
    }
  }

  /// 토글 (현재 상태 반전)
  Future<void> toggle({
    required String userId,
    required String featureId,
    required String companyId,
    String? storeId,
    required bool currentValue,
  }) async {
    if (currentValue) {
      // 현재 ON → OFF로
      await turnOff(
        userId: userId,
        featureId: featureId,
        companyId: companyId,
        storeId: storeId,
      );
    } else {
      // 현재 OFF → ON으로
      await turnOn(
        userId: userId,
        featureId: featureId,
        companyId: companyId,
        storeId: storeId,
      );
    }
  }

  // ===========================================================================
  // Role Info (사용자 역할 정보)
  // ===========================================================================

  /// 현재 유저의 role_id, role_type 가져오기
  Future<({String roleId, String roleType})?> getCurrentUserRoleInfo({
    required String userId,
    required String companyId,
  }) async {
    try {
      final result = await _supabase
          .from('user_roles')
          .select('role_id, roles!inner(company_id, role_type)')
          .eq('user_id', userId)
          .eq('roles.company_id', companyId)
          .eq('is_deleted', false)
          .limit(1)
          .maybeSingle();

      if (result == null) return null;

      final roleId = result['role_id'] as String;
      final roles = result['roles'] as Map<String, dynamic>;
      final roleType = roles['role_type'] as String? ?? 'employee';

      return (roleId: roleId, roleType: roleType);
    } catch (e) {
      return null;
    }
  }

  // ===========================================================================
  // Master Push Settings (user_notification_settings)
  // ===========================================================================

  /// Master Push 설정 가져오기
  /// row 없으면 default true (알림 활성화)
  Future<bool> getMasterPushEnabled({
    required String userId,
  }) async {
    try {
      final result = await _supabase
          .from('user_notification_settings')
          .select('push_enabled')
          .eq('user_id', userId)
          .maybeSingle();

      // row 없으면 default true
      if (result == null) return true;

      return result['push_enabled'] as bool? ?? true;
    } catch (e) {
      // 테이블이 없거나 에러 시 default true
      return true;
    }
  }

  /// Master Push 설정 저장 (upsert)
  Future<void> setMasterPushEnabled({
    required String userId,
    required bool enabled,
  }) async {
    try {
      await _supabase.from('user_notification_settings').upsert(
        {
          'user_id': userId,
          'push_enabled': enabled,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'user_id',
      );
    } catch (e) {
      throw Exception('Failed to update master push setting: $e');
    }
  }
}
