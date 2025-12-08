// lib/features/report_control/presentation/pages/templates/monthly_salary/monthly_salary_template.dart

import 'package:flutter/material.dart';

import '../../../../domain/entities/report_notification.dart';
import '../../../utils/template_registry.dart';
import 'monthly_salary_detail_page.dart';

/// Monthly Salary Template
///
/// Self-registering template for Monthly Payroll reports.
///
/// Clean Architecture:
/// - Uses Domain entities (ReportNotification, MonthlySalaryReport)
/// - Returns Presentation widgets
/// - No dependency on Data layer
class MonthlySalaryTemplate {
  /// Template UUID (from database)
  static const String templateId = 'd002ea8c-e010-42e7-92b8-1bd9d401b086';

  /// Template code (matches database)
  static const String templateCode = 'monthly_payroll_report';

  /// Alternative codes (for compatibility)
  static const List<String> alternateCodes = [
    'monthly_salary',
    'monthly_salary_report',
    'payroll_report',
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

    print('✅ [MonthlySalaryTemplate] Registered:');
    print('   - UUID: $templateId');
    print('   - Codes: $templateCode, ${alternateCodes.join(', ')}');
  }

  /// Build the page from notification
  ///
  /// Passes notification directly to detail page
  /// Detail page handles JSON parsing via ReportParser
  static Widget _buildPage(ReportNotification notification) {
    return MonthlySalaryDetailPage(notification: notification);
  }
}
