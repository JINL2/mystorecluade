import 'dart:io';
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
      } else {
        // Android support varies by manufacturer
        _isSupported = await FlutterAppBadger.isAppBadgeSupported();
      }
    } catch (e) {
      _isSupported = false;
    }
  }

  /// Update badge count on app icon
  Future<void> updateBadgeCount(int count) async {
    if (!_isSupported) return;

    try {
      if (count > 0) {
        await FlutterAppBadger.updateBadgeCount(count);
      } else {
        await removeBadge();
      }
    } catch (_) {
      // Badge update failed silently
    }
  }

  /// Remove badge from app icon
  Future<void> removeBadge() async {
    if (!_isSupported) return;

    try {
      await FlutterAppBadger.removeBadge();
    } catch (_) {
      // Badge removal failed silently
    }
  }

  /// Check if badge is supported on current platform
  bool get isSupported => _isSupported;
}
