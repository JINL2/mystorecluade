import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Session state tracking for smart data fetching decisions
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

  bool get isFreshLogin {
    // If no login time recorded, we need fresh data
    if (lastLoginTime == null) {
      return true;
    }
    final timeSinceLogin = DateTime.now().difference(lastLoginTime!);
    final isFresh = timeSinceLogin.inMinutes < 5;
    return isFresh;
  }

  bool get isUserDataStale {
    if (userDataCacheExpiry == null) {
      return true;
    }
    final isStale = DateTime.now().isAfter(userDataCacheExpiry!);
    return isStale;
  }

  bool get areFeaturesStale {
    if (featuresCacheExpiry == null) return true;
    return DateTime.now().isAfter(featuresCacheExpiry!);
  }

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
          ? DateTime.parse(json['lastLoginTime']) 
          : null,
      lastDataFetchTime: json['lastDataFetchTime'] != null 
          ? DateTime.parse(json['lastDataFetchTime']) 
          : null,
      userDataCacheExpiry: json['userDataCacheExpiry'] != null 
          ? DateTime.parse(json['userDataCacheExpiry']) 
          : null,
      featuresCacheExpiry: json['featuresCacheExpiry'] != null 
          ? DateTime.parse(json['featuresCacheExpiry']) 
          : null,
      sessionId: json['sessionId'] ?? '',
    );
  }
}

/// Session manager for intelligent data fetching decisions
class SessionManagerNotifier extends StateNotifier<SessionState> {
  SessionManagerNotifier() : super(const SessionState()) {
    _loadFromStorage();
  }

  static const String _storageKey = 'session_state';
  
  // Cache TTL settings (configurable based on data sensitivity)
  static const Duration _userDataTTL = Duration(hours: 2); // User data expires after 2 hours
  static const Duration _featuresTTL = Duration(hours: 6); // Features expire after 6 hours
  static const Duration _freshLoginWindow = Duration(minutes: 5); // Fresh login window

  /// Load session state from storage
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = SessionState.fromJson(json);
      } else {
      }
    } catch (e) {
      // If loading fails, start with fresh state
    }
  }

  /// Save session state to storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.toJson());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
    }
  }

  /// Record a fresh login event
  Future<void> recordLogin() async {
    final now = DateTime.now();
    final sessionId = '${now.millisecondsSinceEpoch}'; // Simple session ID
    
    state = state.copyWith(
      lastLoginTime: now,
      sessionId: sessionId,
    );
    await _saveToStorage();
    
  }

  /// Record successful user data fetch with TTL
  Future<void> recordUserDataFetch() async {
    final now = DateTime.now();
    final expiry = now.add(_userDataTTL);
    
    state = state.copyWith(
      lastDataFetchTime: now,
      userDataCacheExpiry: expiry,
    );
    await _saveToStorage();
    
  }

  /// Record successful features data fetch with TTL
  Future<void> recordFeaturesFetch() async {
    final now = DateTime.now();
    final expiry = now.add(_featuresTTL);
    
    state = state.copyWith(
      featuresCacheExpiry: expiry,
    );
    await _saveToStorage();
    
  }

  /// Check if we should fetch fresh user data
  bool shouldFetchUserData() {
    // Check if data is stale or we have a fresh login
    final shouldFetch = state.shouldForceFreshData;
    return shouldFetch;
  }

  /// Check if we should fetch fresh features data
  bool shouldFetchFeatures() {
    final shouldFetch = state.isFreshLogin || state.areFeaturesStale;
    return shouldFetch;
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
  Future<void> clearSession() async {
    state = const SessionState();
    await _saveToStorage();
  }

  /// Force expire cache (for manual refresh)
  Future<void> expireCache() async {
    state = state.copyWith(
      userDataCacheExpiry: DateTime.now().subtract(Duration(seconds: 1)),
      featuresCacheExpiry: DateTime.now().subtract(Duration(seconds: 1)),
    );
    await _saveToStorage();
  }
}

/// Provider for session management
final sessionManagerProvider = StateNotifierProvider<SessionManagerNotifier, SessionState>((ref) {
  return SessionManagerNotifier();
});

/// Convenience providers for common session checks
final shouldFetchUserDataProvider = Provider<bool>((ref) {
  final sessionManager = ref.read(sessionManagerProvider.notifier);
  return sessionManager.shouldFetchUserData();
});

final shouldFetchFeaturesProvider = Provider<bool>((ref) {
  final sessionManager = ref.read(sessionManagerProvider.notifier);
  return sessionManager.shouldFetchFeatures();
});

final isFreshLoginProvider = Provider<bool>((ref) {
  final sessionState = ref.watch(sessionManagerProvider);
  return sessionState.isFreshLogin;
});