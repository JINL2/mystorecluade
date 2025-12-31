import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifications/services/production_token_service.dart';

/// App initialization scenarios
enum InitScenario {
  /// User just logged in - load all data + register FCM token
  freshLogin,

  /// App restarted with existing session - load minimal data only
  /// - Manager: revenue data
  /// - Employee: salary data
  appRestart,

  /// User manually refreshed - reload all data + refresh FCM token
  manualRefresh,
}

/// Service to manage app initialization based on scenario
///
/// Handles 3 scenarios:
/// 1. freshLogin: After auth → Load ALL data (companies, permissions, revenue/salary) + FCM token
/// 2. appRestart: Already logged in → Load MINIMAL data only (revenue for manager / salary for employee)
/// 3. manualRefresh: Pull-to-refresh → Reload ALL data + refresh FCM token
class AppInitService {
  static final AppInitService _instance = AppInitService._internal();
  factory AppInitService() => _instance;
  AppInitService._internal();

  static const String _lastSessionKey = 'last_session_user_id';
  static const String _lastLoginTimeKey = 'last_login_timestamp';

  final ProductionTokenService _tokenService = ProductionTokenService();

  bool _isInitialized = false;
  InitScenario? _lastScenario;

  /// Determine which scenario applies based on current state
  Future<InitScenario> determineScenario(String? userId) async {
    if (userId == null) {
      return InitScenario.freshLogin;
    }

    final prefs = await SharedPreferences.getInstance();
    final lastSessionUserId = prefs.getString(_lastSessionKey);
    final lastLoginTime = prefs.getInt(_lastLoginTimeKey);

    // If user ID changed or no previous session → fresh login
    if (lastSessionUserId != userId) {
      await _saveSession(userId);
      return InitScenario.freshLogin;
    }

    // If last login was more than 24 hours ago → treat as fresh login
    if (lastLoginTime != null) {
      final lastLogin = DateTime.fromMillisecondsSinceEpoch(lastLoginTime);
      final hoursSinceLogin = DateTime.now().difference(lastLogin).inHours;
      if (hoursSinceLogin > 24) {
        await _saveSession(userId);
        return InitScenario.freshLogin;
      }
    }

    // Same user, recent session → app restart
    return InitScenario.appRestart;
  }

  /// Save current session info
  Future<void> _saveSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSessionKey, userId);
    await prefs.setInt(_lastLoginTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Execute initialization based on scenario
  ///
  /// Returns list of provider keys that should be invalidated
  Future<void> executeScenario(
    InitScenario scenario,
    WidgetRef ref, {
    required Future<void> Function() loadAllData,
    required Future<void> Function() loadMinimalData,
  }) async {
    _lastScenario = scenario;

    switch (scenario) {
      case InitScenario.freshLogin:
        await _handleFreshLogin(loadAllData);
        break;

      case InitScenario.appRestart:
        await _handleAppRestart(loadMinimalData);
        break;

      case InitScenario.manualRefresh:
        await _handleManualRefresh(loadAllData);
        break;
    }
  }

  /// Fresh login: Load all data + register FCM token
  Future<void> _handleFreshLogin(Future<void> Function() loadAllData) async {
    if (kDebugMode) {
      debugPrint('🔐 AppInitService: Fresh login - loading all data');
    }

    // Load all user data (companies, permissions, etc.)
    await loadAllData();

    // FCM token is automatically registered via ProductionTokenService.onAuthStateChange
    // No manual call needed here

    _isInitialized = true;
  }

  /// App restart: Only load minimal data (revenue for manager / salary for employee)
  Future<void> _handleAppRestart(Future<void> Function() loadMinimalData) async {
    if (kDebugMode) {
      debugPrint('🔄 AppInitService: App restart - loading minimal data only (revenue/salary)');
    }

    // Only load time-sensitive data:
    // - Manager: revenue data
    // - Employee: salary data
    // Skip: companies, permissions, categories (use cached)
    await loadMinimalData();

    // Skip FCM token - already registered from previous session
    _isInitialized = true;
  }

  /// Manual refresh: Reload all data + refresh FCM token
  Future<void> _handleManualRefresh(Future<void> Function() loadAllData) async {
    if (kDebugMode) {
      debugPrint('🔃 AppInitService: Manual refresh - reloading all data');
    }

    // Reload all data
    await loadAllData();

    // Force FCM token refresh
    try {
      await _tokenService.registerTokenAfterAuth();
      if (kDebugMode) {
        debugPrint('✅ FCM token refreshed on manual refresh');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ FCM token refresh failed: $e');
      }
      // Don't fail the refresh for FCM issues
    }
  }

  /// Mark that manual refresh is triggered
  void markManualRefresh() {
    _lastScenario = InitScenario.manualRefresh;
  }

  /// Clear session on logout
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSessionKey);
    await prefs.remove(_lastLoginTimeKey);
    _isInitialized = false;
    _lastScenario = null;
  }

  // Getters for debugging
  bool get isInitialized => _isInitialized;
  InitScenario? get lastScenario => _lastScenario;
}
