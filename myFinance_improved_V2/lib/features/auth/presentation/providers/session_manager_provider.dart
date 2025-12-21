import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Session state tracking for smart data fetching decisions
///
/// This class manages session lifecycle, cache TTL, and determines
/// when fresh data should be fetched vs using cached data.
class SessionState {
  const SessionState({
    this.lastLoginTime,
    this.lastDataFetchTime,
    this.userDataCacheExpiry,
    this.featuresCacheExpiry,
    this.sessionId = '',
  });

  final DateTime? lastLoginTime;
  final DateTime? lastDataFetchTime;
  final DateTime? userDataCacheExpiry;
  final DateTime? featuresCacheExpiry;
  final String sessionId;

  /// Check if this is a fresh login (within 5 minutes)
  bool get isFreshLogin {
    if (lastLoginTime == null) {
      return true;
    }
    final timeSinceLogin = DateTime.now().difference(lastLoginTime!);
    return timeSinceLogin.inMinutes < 5;
  }

  /// Check if user data cache has expired
  bool get isUserDataStale {
    if (userDataCacheExpiry == null) {
      return true;
    }
    return DateTime.now().isAfter(userDataCacheExpiry!);
  }

  /// Check if features cache has expired
  bool get areFeaturesStale {
    if (featuresCacheExpiry == null) return true;
    return DateTime.now().isAfter(featuresCacheExpiry!);
  }

  /// Determine if we should force fresh data fetch
  bool get shouldForceFreshData {
    return isFreshLogin || isUserDataStale;
  }

  SessionState copyWith({
    DateTime? lastLoginTime,
    DateTime? lastDataFetchTime,
    DateTime? userDataCacheExpiry,
    DateTime? featuresCacheExpiry,
    String? sessionId,
  }) {
    return SessionState(
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
      lastDataFetchTime: lastDataFetchTime ?? this.lastDataFetchTime,
      userDataCacheExpiry: userDataCacheExpiry ?? this.userDataCacheExpiry,
      featuresCacheExpiry: featuresCacheExpiry ?? this.featuresCacheExpiry,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastLoginTime': lastLoginTime?.toIso8601String(),
      'lastDataFetchTime': lastDataFetchTime?.toIso8601String(),
      'userDataCacheExpiry': userDataCacheExpiry?.toIso8601String(),
      'featuresCacheExpiry': featuresCacheExpiry?.toIso8601String(),
      'sessionId': sessionId,
    };
  }

  factory SessionState.fromJson(Map<String, dynamic> json) {
    return SessionState(
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'] as String)
          : null,
      lastDataFetchTime: json['lastDataFetchTime'] != null
          ? DateTime.parse(json['lastDataFetchTime'] as String)
          : null,
      userDataCacheExpiry: json['userDataCacheExpiry'] != null
          ? DateTime.parse(json['userDataCacheExpiry'] as String)
          : null,
      featuresCacheExpiry: json['featuresCacheExpiry'] != null
          ? DateTime.parse(json['featuresCacheExpiry'] as String)
          : null,
      sessionId: json['sessionId'] as String? ?? '',
    );
  }
}

/// Session manager for intelligent data fetching decisions
///
/// Manages session lifecycle, cache TTL, and provides intelligent
/// decisions about when to fetch fresh data vs reuse cached data.
///
/// Cache TTL Settings:
/// - User data: 2 hours
/// - Features: 6 hours
/// - Fresh login window: 5 minutes
class SessionManagerNotifier extends StateNotifier<SessionState> {
  SessionManagerNotifier() : super(const SessionState()) {
    _loadFromStorage();
  }

  static const String _storageKey = 'session_state';

  // Cache TTL settings (configurable based on data sensitivity)
  static const Duration _userDataTTL = Duration(hours: 2);
  static const Duration _featuresTTL = Duration(hours: 6);

  /// Load session state from persistent storage
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = SessionState.fromJson(json);
      }
    } catch (e) {
      // If loading fails, start with fresh state
      if (kDebugMode) {
        debugPrint('⚠️ [SessionManager] Failed to load state: $e');
      }
    }
  }

  /// Save session state to persistent storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.toJson());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [SessionManager] Failed to save state: $e');
      }
    }
  }

  /// Record a fresh login event
  ///
  /// Called after successful authentication.
  /// Sets cache expiry and session ID.
  Future<void> recordLogin() async {
    final now = DateTime.now();
    final sessionId = '${now.millisecondsSinceEpoch}';

    state = state.copyWith(
      lastLoginTime: now,
      sessionId: sessionId,
    );
    await _saveToStorage();

    if (kDebugMode) {
      debugPrint('✅ [SessionManager] Login recorded: $sessionId');
    }
  }

  /// Record successful user data fetch
  ///
  /// Updates cache expiry for user data (2 hour TTL).
  Future<void> recordUserDataFetch() async {
    final now = DateTime.now();
    final expiry = now.add(_userDataTTL);

    state = state.copyWith(
      lastDataFetchTime: now,
      userDataCacheExpiry: expiry,
    );
    await _saveToStorage();

    if (kDebugMode) {
      debugPrint('✅ [SessionManager] User data cached until: $expiry');
    }
  }

  /// Record successful features data fetch
  ///
  /// Updates cache expiry for features (6 hour TTL).
  Future<void> recordFeaturesFetch() async {
    final now = DateTime.now();
    final expiry = now.add(_featuresTTL);

    state = state.copyWith(
      featuresCacheExpiry: expiry,
    );
    await _saveToStorage();

    if (kDebugMode) {
      debugPrint('✅ [SessionManager] Features cached until: $expiry');
    }
  }

  /// Check if we should fetch fresh user data
  ///
  /// Returns true if:
  /// - This is a fresh login (within 5 minutes)
  /// - User data cache has expired
  bool shouldFetchUserData() {
    return state.shouldForceFreshData;
  }

  /// Check if we should fetch fresh features data
  ///
  /// Returns true if:
  /// - This is a fresh login
  /// - Features cache has expired
  bool shouldFetchFeatures() {
    return state.isFreshLogin || state.areFeaturesStale;
  }

  /// Get cache status for debugging
  Map<String, dynamic> getCacheStatus() {
    return {
      'isFreshLogin': state.isFreshLogin,
      'isUserDataStale': state.isUserDataStale,
      'areFeaturesStale': state.areFeaturesStale,
      'shouldForceFreshData': state.shouldForceFreshData,
      'lastLoginTime': state.lastLoginTime?.toIso8601String(),
      'userDataCacheExpiry': state.userDataCacheExpiry?.toIso8601String(),
      'featuresCacheExpiry': state.featuresCacheExpiry?.toIso8601String(),
    };
  }

  /// Clear session state (on logout)
  ///
  /// Resets all session tracking to initial state.
  Future<void> clearSession() async {
    state = const SessionState();
    await _saveToStorage();

    if (kDebugMode) {
      debugPrint('✅ [SessionManager] Session cleared');
    }
  }

  /// Force expire cache (for manual refresh)
  ///
  /// Used when user explicitly requests fresh data (pull-to-refresh).
  Future<void> expireCache() async {
    if (kDebugMode) {
      debugPrint('🔴 [SessionManager] Expiring cache - forcing fresh data fetch');
    }

    state = state.copyWith(
      userDataCacheExpiry: DateTime.now().subtract(const Duration(seconds: 1)),
      featuresCacheExpiry: DateTime.now().subtract(const Duration(seconds: 1)),
    );
    await _saveToStorage();

    if (kDebugMode) {
      debugPrint('🔴 [SessionManager] Cache expired successfully');
    }
  }
}

/// Provider for session management
///
/// Manages session lifecycle and cache TTL.
final sessionManagerProvider =
    StateNotifierProvider<SessionManagerNotifier, SessionState>((ref) {
  return SessionManagerNotifier();
});

/// Convenience provider to check if user data should be fetched
final shouldFetchUserDataProvider = Provider<bool>((ref) {
  final sessionManager = ref.read(sessionManagerProvider.notifier);
  return sessionManager.shouldFetchUserData();
});

/// Convenience provider to check if features should be fetched
final shouldFetchFeaturesProvider = Provider<bool>((ref) {
  final sessionManager = ref.read(sessionManagerProvider.notifier);
  return sessionManager.shouldFetchFeatures();
});

/// Convenience provider to check if this is a fresh login
final isFreshLoginProvider = Provider<bool>((ref) {
  final sessionState = ref.watch(sessionManagerProvider);
  return sessionState.isFreshLogin;
});
