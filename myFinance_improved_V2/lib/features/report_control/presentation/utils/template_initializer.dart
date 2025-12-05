// lib/features/report_control/presentation/utils/template_initializer.dart

import '../pages/templates/financial_summary/financial_summary_template.dart';
import '../pages/templates/daily_attendance/daily_attendance_template.dart';
import 'template_registry.dart';

/// Template Initializer
///
/// Initializes all report templates at app startup.
/// This is the ONLY place where templates are registered.
///
/// Adding a new template:
/// 1. Create template folder
/// 2. Create template class with register() method
/// 3. Add ONE line here: NewTemplate.register();
class TemplateInitializer {
  static bool _initialized = false;

  /// Initialize all templates
  ///
  /// Called once at app startup
  static void initialize() {
    if (_initialized) {
      print('⚠️ [TemplateInit] Already initialized, skipping');
      return;
    }

    print('🚀 [TemplateInit] Initializing report templates...');

    // Register all templates
    FinancialSummaryTemplate.register();
    DailyAttendanceTemplate.register();

    // TODO: Add more templates here
    // CashLocationTemplate.register();

    _initialized = true;

    print('✅ [TemplateInit] Initialized ${TemplateRegistry.getRegisteredCodes().length} templates');
    print('📋 [TemplateInit] Registered codes: ${TemplateRegistry.getRegisteredCodes().join(', ')}');
  }

  /// Load UUID → Code mappings from database
  ///
  /// Called after templates are registered
  static void loadUuidMappings(List<Map<String, String>> mappings) {
    print('🔍 [TemplateInit] Loading ${mappings.length} UUID mappings...');

    for (final mapping in mappings) {
      final uuid = mapping['template_id'];
      final code = mapping['template_code'];

      if (uuid != null && code != null) {
        TemplateRegistry.loadUuidMapping(uuid, code);
      }
    }

    print('✅ [TemplateInit] UUID mappings loaded');
  }

  /// Reset (for testing)
  static void reset() {
    _initialized = false;
    TemplateRegistry.clear();
  }
}
