// lib/features/report_control/presentation/pages/templates/daily_attendance/daily_attendance_template.dart

import 'package:flutter/material.dart';

import '../../../../domain/entities/report_notification.dart';
import '../../../utils/template_registry.dart';
import '../../../utils/report_parser.dart';
import 'daily_attendance_detail_page.dart';

/// Daily Attendance Template
///
/// Self-registering template for Daily Attendance reports
class DailyAttendanceTemplate {
  /// Template UUIDs (from database)
  static const String templateId1 = 'cfa343c3-1fdb-4193-a264-448eaff28ccd';
  static const String templateId2 = 'a26dba4b-d6eb-435a-bc5e-8a90c4b26d2c';

  /// Template codes (from database)
  static const String templateCode = 'daily_attendance';
  static const String templateCode2 = 'daily_attendance_json';

  /// Register this template with the registry
  static void register() {
    // Register by UUID (primary)
    TemplateRegistry.register(templateId1, _buildPage);
    TemplateRegistry.register(templateId2, _buildPage);

    // Register by code (fallback)
    TemplateRegistry.register(templateCode, _buildPage);
    TemplateRegistry.register(templateCode2, _buildPage);

    print('✅ [AttendanceTemplate] Registered:');
    print('   - UUIDs: $templateId1, $templateId2');
    print('   - Codes: $templateCode, $templateCode2');

    // Verify registration
    print('✅ [Registry] Registered template: $templateCode');
    print('✅ [Registry] Registered template: $templateCode2');
  }

  /// Build the page from notification
  static Widget _buildPage(ReportNotification notification) {
    // Return a loader widget that will parse and display the report
    // notification.body contains the JSON structure
    return DailyAttendanceDetailPage(notification: notification);
  }

  /// Build error page
  static Widget _buildErrorPage(String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}
