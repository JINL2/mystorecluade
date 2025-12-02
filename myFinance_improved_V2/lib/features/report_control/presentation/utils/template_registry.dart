// lib/features/report_control/presentation/utils/template_registry.dart

import 'package:flutter/material.dart';

import '../../domain/entities/report_notification.dart';

/// Template Registry
///
/// Central registry for all report templates.
/// Maps template codes (and UUIDs) to their corresponding page builders.
///
/// Clean Architecture:
/// - This is in Presentation layer (OK to depend on widgets)
/// - Uses Domain entities (ReportNotification)
/// - No dependency on Data layer
class TemplateRegistry {
  TemplateRegistry._();

  /// Template builders mapped by template_code
  static final Map<String, ReportTemplateBuilder> _buildersByCode = {};

  /// UUID → Code mapping (loaded from database at runtime)
  static final Map<String, String> _uuidToCodeMap = {};

  /// Register a template builder
  ///
  /// Called by each template's register() method
  static void register(String templateCode, ReportTemplateBuilder builder) {
    _buildersByCode[templateCode] = builder;
    print('✅ [Registry] Registered template: $templateCode');
  }

  /// Load UUID → Code mappings from database
  ///
  /// Called once at app initialization
  static void loadUuidMapping(String uuid, String code) {
    _uuidToCodeMap[uuid] = code;
  }

  /// Build page by template UUID
  ///
  /// 1. Convert UUID → Code
  /// 2. Find builder by Code
  /// 3. Build page
  static Widget? buildByUuid(String templateUuid, ReportNotification notification) {
    print('🔍 [Registry] Looking up UUID: $templateUuid');

    final code = _uuidToCodeMap[templateUuid];
    if (code == null) {
      print('❌ [Registry] No code found for UUID: $templateUuid');
      return null;
    }

    print('✅ [Registry] UUID → Code: $code');
    return buildByCode(code, notification);
  }

  /// Build page by template code
  static Widget? buildByCode(String templateCode, ReportNotification notification) {
    print('🔍 [Registry] Looking up code: $templateCode');

    final builder = _buildersByCode[templateCode];
    if (builder == null) {
      print('❌ [Registry] No builder found for code: $templateCode');
      return null;
    }

    print('✅ [Registry] Building page for: $templateCode');
    return builder(notification);
  }

  /// Check if template is registered
  static bool isRegistered(String templateCode) {
    return _buildersByCode.containsKey(templateCode);
  }

  /// Get all registered template codes
  static List<String> getRegisteredCodes() {
    return _buildersByCode.keys.toList();
  }

  /// Clear all registrations (for testing)
  static void clear() {
    _buildersByCode.clear();
    _uuidToCodeMap.clear();
  }
}

/// Template builder function type
///
/// Takes ReportNotification and returns a Widget (page)
typedef ReportTemplateBuilder = Widget Function(ReportNotification notification);
