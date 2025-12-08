// lib/features/report_control/presentation/pages/templates/cash_location/cash_location_template.dart

import 'package:flutter/material.dart';

import '../../../../domain/entities/report_notification.dart';
import '../../../utils/template_registry.dart';
import 'cash_location_detail_page.dart';
import 'domain/entities/example_cash_location_data.dart';

/// Cash Location Template
///
/// Self-registering template for Daily Cash Location reports.
///
/// Clean Architecture:
/// - Uses Domain entities (ReportNotification, CashLocationReport)
/// - Returns Presentation widgets
/// - No dependency on Data layer
class CashLocationTemplate {
  /// Template UUID (from database)
  static const String templateId = 'eaa21539-aa01-4078-b899-16a81cf96de9';

  /// Template code (matches database)
  static const String templateCode = 'daily_cash_location';

  /// Alternative codes (for compatibility)
  static const List<String> alternateCodes = [
    'daily_cash_location_json',
    'cash_location',
  ];

  /// Register this template with the registry
  ///
  /// Called once at app initialization
  static void register() {
    // Register by UUID (primary - for routing from notification)
    TemplateRegistry.register(templateId, _buildPage);

    // Register by code (for fallback/lookup)
    TemplateRegistry.register(templateCode, _buildPage);

    // Register alternate codes
    for (final code in alternateCodes) {
      TemplateRegistry.register(code, _buildPage);
    }

    print('✅ [CashLocationTemplate] Registered:');
    print('   - UUID: $templateId');
    print('   - Codes: $templateCode, ${alternateCodes.join(', ')}');
  }

  /// Build the page from notification
  ///
  /// Like daily_attendance: passes notification directly to detail page
  /// Detail page handles JSON parsing via ReportParser
  static Widget _buildPage(ReportNotification notification) {
    return CashLocationDetailPage(notification: notification);
  }

  /// Build example page (for testing UI)
  static Widget buildExamplePage() {
    return CashLocationDetailPage.withReport(
      report: ExampleCashLocationData.sampleReport,
      title: 'Cash Location Report (Example)',
    );
  }
}
