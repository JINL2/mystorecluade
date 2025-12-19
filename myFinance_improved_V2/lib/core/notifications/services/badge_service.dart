import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

/// Service for managing app icon badge count
class BadgeService {
  static final BadgeService _instance = BadgeService._internal();
  factory BadgeService() => _instance;
  BadgeService._internal();

  bool _isSupported = false;

  /// Initialize badge service and check platform support
  Future<void> initialize() async {
    try {
      if (Platform.isIOS) {
        _isSupported = await FlutterAppBadger.isAppBadgeSupported();
        if (kDebugMode) {
          debugPrint('🔔 Badge Service initialized - Supported: $_isSupported');
        }
      } else {
        // Android support varies by manufacturer
        _isSupported = await FlutterAppBadger.isAppBadgeSupported();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Badge Service initialization failed: $e');
      }
      _isSupported = false;
    }
  }

  /// Update badge count on app icon
  Future<void> updateBadgeCount(int count) async {
    if (!_isSupported) return;

    try {
      if (count > 0) {
        await FlutterAppBadger.updateBadgeCount(count);
        if (kDebugMode) {
          debugPrint('🔔 Badge updated: $count');
        }
      } else {
        await removeBadge();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to update badge: $e');
      }
    }
  }

  /// Remove badge from app icon
  Future<void> removeBadge() async {
    if (!_isSupported) return;

    try {
      await FlutterAppBadger.removeBadge();
      if (kDebugMode) {
        debugPrint('🔔 Badge removed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to remove badge: $e');
      }
    }
  }

  /// Check if badge is supported on current platform
  bool get isSupported => _isSupported;
}
