// lib/features/report_control/presentation/pages/templates/financial_summary/financial_summary_template.dart

import 'package:flutter/material.dart';

import '../../../../domain/entities/report_notification.dart';
import '../../../../domain/entities/report_detail.dart';
import '../../../utils/report_parser.dart';
import '../../../utils/template_registry.dart';
import 'financial_summary_detail_page.dart';

/// Financial Summary Template
///
/// Self-registering template for Daily Financial Summary reports.
///
/// Clean Architecture:
/// - Uses Domain entities (ReportNotification, ReportDetail)
/// - Returns Presentation widgets
/// - No dependency on Data layer
class FinancialSummaryTemplate {
  /// Template code (matches database)
  static const String templateCode = 'daily_fraud_detection';

  /// Alternative codes (for compatibility)
  static const List<String> alternateCodes = [
    'daily_fraud_detection_json',
    'financial_summary',
  ];

  /// Register this template with the registry
  ///
  /// Called once at app initialization
  static void register() {
    // Register primary code
    TemplateRegistry.register(templateCode, _buildPage);

    // Register alternate codes
    for (final code in alternateCodes) {
      TemplateRegistry.register(code, _buildPage);
    }

    print('✅ [FinancialTemplate] Registered with codes: $templateCode, ${alternateCodes.join(', ')}');
  }

  /// Build the page from notification
  static Widget _buildPage(ReportNotification notification) {
    try {
      print('🔍 [FinancialTemplate] Building page...');

      // Parse JSON from notification body
      final reportJson = ReportParser.parse(notification.body);

      if (reportJson == null) {
        print('❌ [FinancialTemplate] Failed to parse JSON');
        return _buildErrorPage('Failed to parse report data');
      }

      // Convert to ReportDetail
      final reportDetail = ReportDetail.fromJson(reportJson);

      print('✅ [FinancialTemplate] ReportDetail created successfully');

      // Return detail page
      return FinancialSummaryDetailPage(report: reportDetail);
    } catch (e, stackTrace) {
      print('❌ [FinancialTemplate] Error building page: $e');
      print('📚 [FinancialTemplate] Stack trace: ${stackTrace.toString().split('\n').take(3).join('\n')}');

      return _buildErrorPage('Error: $e');
    }
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
