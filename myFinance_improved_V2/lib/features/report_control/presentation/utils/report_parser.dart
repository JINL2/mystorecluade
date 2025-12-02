// lib/features/report_control/presentation/utils/report_parser.dart

import 'dart:convert';

/// Report Parser Utility
///
/// Handles parsing of report JSON from various formats.
/// Clean Architecture: Pure utility, no dependencies.
class ReportParser {
  ReportParser._();

  /// Parse report body to JSON
  ///
  /// Handles multiple formats:
  /// 1. AI wrapper: {"success": true, "report": {"content": "..."}}
  /// 2. Direct JSON: {"template_id": "...", "account_changes": {...}}
  /// 3. Plain text: Returns null
  static Map<String, dynamic>? parse(String body) {
    try {
      print('🔍 [Parser] Step 1: Checking if body is JSON...');

      // Check if body is JSON
      if (!body.trim().startsWith('{')) {
        print('❌ [Parser] Body is not JSON (doesn\'t start with {)');
        return null;
      }

      print('🔍 [Parser] Step 2: Parsing outer JSON...');
      print('📄 [Parser] Body length: ${body.length} chars');

      // Parse outer JSON
      final outerJson = jsonDecode(body) as Map<String, dynamic>;
      print('✅ [Parser] Outer JSON parsed. Keys: ${outerJson.keys.join(', ')}');

      Map<String, dynamic> reportJson;

      // Case 1: AI response wrapper (has "report.content")
      if (outerJson.containsKey('report') && outerJson['report'] is Map) {
        print('🔍 [Parser] Step 3a: Found "report" wrapper');
        final reportWrapper = outerJson['report'] as Map<String, dynamic>;
        print('📦 [Parser] Report wrapper keys: ${reportWrapper.keys.join(', ')}');

        // Check if content is a JSON string (nested JSON)
        if (reportWrapper.containsKey('content') &&
            reportWrapper['content'] is String) {
          print('🔍 [Parser] Step 4a: Content is String, parsing nested JSON...');
          final contentStr = reportWrapper['content'] as String;
          print('📝 [Parser] Content preview: ${contentStr.substring(0, contentStr.length > 100 ? 100 : contentStr.length)}...');

          reportJson = jsonDecode(contentStr) as Map<String, dynamic>;
          print('✅ [Parser] Nested JSON parsed. Keys: ${reportJson.keys.join(', ')}');
        } else if (reportWrapper.containsKey('content') &&
            reportWrapper['content'] is Map) {
          print('🔍 [Parser] Step 4b: Content is already Map');
          reportJson = reportWrapper['content'] as Map<String, dynamic>;
        } else {
          print('❌ [Parser] No valid content field found');
          return null;
        }
      } else if (outerJson.containsKey('template_id') ||
          outerJson.containsKey('account_changes')) {
        print('🔍 [Parser] Step 3b: Direct report JSON');
        reportJson = outerJson;
      } else {
        print('❌ [Parser] No recognized format');
        return null;
      }

      print('✅ [Parser] SUCCESS! Report JSON extracted');
      return reportJson;
    } catch (e, stackTrace) {
      print('❌ [Parser] FAILED: $e');
      print('📚 [Parser] Stack trace: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      return null;
    }
  }

  /// Validate if JSON has required fields for a report
  static bool isValidReport(Map<String, dynamic> json) {
    return json.containsKey('template_id') ||
        json.containsKey('template_code') ||
        json.containsKey('account_changes');
  }
}
