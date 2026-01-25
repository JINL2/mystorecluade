import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_state_provider.dart';
import '../../cache/subscription_cache_service.dart';
import '../../services/revenuecat_service.dart';
import '../entities/subscription_state.dart';

part 'subscription_state_notifier.g.dart';

// =============================================================================
// ARCHITECTURE DOCUMENTATION
// =============================================================================
//
// ## SubscriptionStateNotifier - Single Source of Truth (SSOT)
//
// ### 역할
// - 구독 상태의 **유일한 진실 공급원**
// - UI는 이 provider를 직접 watch해야 함
//
// ### 데이터 소스 (우선순위 순)
// 1. **Cache (1hr TTL)**: 앱 시작 시 즉시 UI 표시
// 2. **Supabase RPC**: 최신 데이터 fetch
// 3. **RevenueCat SDK**: 같은 기기에서 구매 시 즉시 반영
// 4. **Supabase Realtime**: 다른 기기/웹에서 변경 시 반영
//
// ### 데이터 흐름
// ```
//  RevenueCat SDK ──┐
//                   ├──▶ SubscriptionStateNotifier ──▶ UI Components
//  Supabase Realtime┘              │
//                                  ▼
//                         AppState (backward compat only)
// ```
//
// ### AppState와의 관계
// - AppState.planType, maxEmployees 등은 **backward compatibility 전용**
// - 새 코드는 반드시 subscriptionStateNotifierProvider를 watch할 것
// - syncFromSubscriptionState()는 레거시 코드 지원용
//
// =============================================================================

/// 구독 상태 관리 Notifier (SSOT)
///
/// 앱 전체에서 구독 상태를 관리하는 중앙 허브.
/// UI에서 구독 정보가 필요하면 이 provider를 watch하세요.
@Riverpod(keepAlive: true)
class SubscriptionStateNotifier extends _$SubscriptionStateNotifier {
  void Function(CustomerInfo)? _revenueCatListener;
  RealtimeChannel? _realtimeChannel;
  bool _isDisposed = false;

  // Debounce: 중복 fetch 방지 (네트워크 불안정 시 비용 절감)
  Timer? _debounceTimer;
  DateTime? _lastFetchTime;
  static const _minFetchInterval = Duration(seconds: 5);

  @override
  Future<SubscriptionState> build() async {
    ref.onDispose(_cleanup);
    return SubscriptionState.initial('');
  }

  // ===========================================================================
  // PUBLIC API
  // ===========================================================================

  /// 구독 상태 초기화 (로그인 후 호출)
  ///
  /// 순서:
  /// 1. 캐시에서 로드 (즉시 UI)
  /// 2. DB에서 최신 데이터 fetch
  /// 3. RevenueCat 리스너 설정
  /// 4. Realtime 구독 설정
  Future<void> initialize(String userId) async {
    if (userId.isEmpty) return;
    _isDisposed = false;

    await _loadFromCache(userId);
    await _fetchFromDatabase(userId);
    _setupRevenueCatListener(userId);
    await _setupRealtimeSubscription(userId);
  }

  /// 강제 새로고침 (구매 완료 후 호출)
  Future<void> forceRefresh(String userId) async {
    if (userId.isEmpty) return;

    state = AsyncData(
      state.valueOrNull?.copyWith(syncStatus: SyncStatus.syncing) ??
          SubscriptionState.initial(userId).copyWith(syncStatus: SyncStatus.syncing),
    );

    await SubscriptionCacheService.instance.invalidate(userId);
    await _fetchFromDatabase(userId);
  }

  // ===========================================================================
  // CACHE OPERATIONS
  // ===========================================================================

  Future<void> _loadFromCache(String userId) async {
    try {
      final cache = await SubscriptionCacheService.instance.getSubscription(userId);
      if (cache.data != null) {
        final cachedState = SubscriptionState.fromJson(cache.data!);
        state = AsyncData(cachedState.copyWith(
          syncStatus: cache.isStale ? SyncStatus.stale : SyncStatus.synced,
        ));
      }
    } catch (_) {
      // Cache miss is not an error - will fetch from DB
    }
  }

  Future<void> _saveToCache(SubscriptionState subState) async {
    try {
      await SubscriptionCacheService.instance.saveSubscription(
        subState.userId,
        subState.toJson(),
      );
    } catch (_) {
      // Cache save failure is not critical
    }
  }

  // ===========================================================================
  // DATABASE OPERATIONS
  // ===========================================================================

  /// Debounced fetch - 최소 5초 간격으로만 실제 RPC 호출
  ///
  /// 네트워크 불안정 시 Realtime 재연결이 반복되면 RPC 호출이 폭발적으로
  /// 증가할 수 있음. Debounce로 비용 절감.
  void _debouncedFetch(String userId) {
    // 이미 예약된 fetch가 있으면 무시
    if (_debounceTimer?.isActive == true) return;

    // 최근 fetch 후 5초 이내면 무시
    final now = DateTime.now();
    if (_lastFetchTime != null &&
        now.difference(_lastFetchTime!) < _minFetchInterval) {
      return;
    }

    // 500ms 후 실행 (빠른 연속 호출 병합)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _fetchFromDatabase(userId);
    });
  }

  Future<void> _fetchFromDatabase(String userId) async {
    if (_isDisposed) return;

    _lastFetchTime = DateTime.now();

    try {
      final response = await Supabase.instance.client.rpc(
        'get_user_subscription_state',
        params: {'p_user_id': userId},
      );

      if (_isDisposed) return;

      final newState = response != null
          ? SubscriptionState.fromRpc(userId, response as Map<String, dynamic>)
          : SubscriptionState.initial(userId).copyWith(
              syncStatus: SyncStatus.synced,
              lastSyncedAt: DateTime.now(),
            );

      state = AsyncData(newState);
      await _saveToCache(newState);
      _syncToAppState(newState);
    } catch (e) {
      if (_isDisposed) return;
      _handleFetchError(e);
    }
  }

  void _handleFetchError(Object error) {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      // Keep existing data, mark as error
      state = AsyncData(currentState.copyWith(
        syncStatus: SyncStatus.error,
        errorMessage: error.toString(),
      ));
    } else {
      state = AsyncError(error, StackTrace.current);
    }
  }

  // ===========================================================================
  // APPSTATE SYNC (Backward Compatibility)
  // ===========================================================================

  /// AppState에 구독 정보 동기화
  ///
  /// NOTE: 이것은 레거시 코드 지원용입니다.
  /// 새 코드는 subscriptionStateNotifierProvider를 직접 watch하세요.
  void _syncToAppState(SubscriptionState subState) {
    try {
      ref.read(appStateProvider.notifier).syncFromSubscriptionState(subState);
    } catch (_) {
      // AppState sync failure is not critical
    }
  }

  // ===========================================================================
  // REVENUECAT LISTENER
  // ===========================================================================

  void _setupRevenueCatListener(String userId) {
    if (_revenueCatListener != null) {
      RevenueCatService().removeCustomerInfoUpdateListener(_revenueCatListener!);
    }

    _revenueCatListener = (CustomerInfo customerInfo) {
      if (_isDisposed) return;
      // RevenueCat 업데이트 시 DB에서 최신 데이터 fetch
      // (limits 등 전체 정보는 DB에 있으므로)
      // Debounce 적용으로 중복 호출 방지
      _debouncedFetch(userId);
    };

    RevenueCatService().addCustomerInfoUpdateListener(_revenueCatListener!);
  }

  // ===========================================================================
  // SUPABASE REALTIME
  // ===========================================================================

  Future<void> _setupRealtimeSubscription(String userId) async {
    try {
      await _realtimeChannel?.unsubscribe();

      _realtimeChannel = Supabase.instance.client
          .channel('subscription_user:$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'subscription_user',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: userId,
            ),
            callback: (payload) {
              if (_isDisposed) return;
              // Debounce 적용: 네트워크 불안정 시 재연결 반복되어도
              // 최소 5초 간격으로만 RPC 호출 (비용 절감)
              _debouncedFetch(userId);
            },
          );

      await _realtimeChannel!.subscribe();
    } catch (_) {
      // Realtime failure is not critical - cache + RevenueCat still work
    }
  }

  // ===========================================================================
  // CLEANUP
  // ===========================================================================

  void _cleanup() {
    _isDisposed = true;

    // Cancel debounce timer
    _debounceTimer?.cancel();
    _debounceTimer = null;

    if (_revenueCatListener != null) {
      RevenueCatService().removeCustomerInfoUpdateListener(_revenueCatListener!);
      _revenueCatListener = null;
    }

    _realtimeChannel?.unsubscribe();
    _realtimeChannel = null;
  }
}

// =============================================================================
// CONVENIENCE PROVIDERS (REMOVED 2026-01-25)
// =============================================================================
//
// The following convenience providers were removed as they had ZERO usage:
// - currentPlanNameProvider - Use subscriptionStateNotifierProvider.valueOrNull?.planName
// - isPaidSubscriptionProvider - Use subscriptionStateNotifierProvider.valueOrNull?.isPaid
// - subscriptionSyncStatusProvider - Use subscriptionStateNotifierProvider.valueOrNull?.syncStatus
// - isSubscriptionStaleProvider - Use subscriptionStateNotifierProvider.valueOrNull?.isStale
//
// Access these values directly from SubscriptionState:
//   final subState = ref.watch(subscriptionStateNotifierProvider).valueOrNull;
//   final planName = subState?.planName ?? 'free';
//   final isPaid = subState?.isPaid ?? false;
