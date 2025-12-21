import 'package:flutter/foundation.dart';

/// Widget Migration Configuration
/// 
/// Controls the gradual rollout of widget replacements.
/// Start with everything disabled, enable one by one after testing.
class WidgetMigrationConfig {
  // Master switch - set to false to disable all replacements instantly
  static const bool enableMigration = true;
  
  // Individual widget feature flags (all start disabled for safety)
  static const bool _useIconButtons = kDebugMode && true; // TESTING: Enabled for inventory only
  static const bool _useCards = kDebugMode && false; // Start disabled  
  static const bool _useAppBars = kDebugMode && false; // Start disabled
  static const bool _useButtons = kDebugMode && false; // Start disabled
  static const bool _useFloatingActionButtons = kDebugMode && false; // Start disabled
  
  // Page-specific rollout controls
  static const Map<String, bool> _pageRollout = {
    'inventory_management': kDebugMode && true, // TESTING: Enabled for IconButton test
    'debug_pages': kDebugMode && false,
    'reports': false,
    'transactions': false,
    'auth': false, // NEVER enable for auth pages
    'payments': false, // NEVER enable for payment pages
    // Database-critical pages - NEVER ENABLE
    'journal_input': false, // CRITICAL: Database transactions
    'cash_ending': false, // CRITICAL: Financial data
    'cash_location': false, // CRITICAL: Cash management
    'transaction_template': false, // CRITICAL: Template storage
    'sale_product': false, // CRITICAL: Sales transactions
    'employee_setting': false, // CRITICAL: Employee data
    'counter_party': false, // CRITICAL: Business relationships
    'debt_control': false, // CRITICAL: Financial records
  };
  
  // CRITICAL: Pages with database operations that must NEVER be migrated
  static const Set<String> _databaseCriticalPages = {
    'journal_input',
    'cash_ending', 
    'cash_location',
    'transaction_template',
    'sale_product',
    'sale_payment',
    'employee_setting',
    'counter_party',
    'debt_control',
    'balance_sheet',
    'transaction_history',
  };
  
  // Widgets that handle forms/state - NEVER migrate these
  static const Set<String> _statefulWidgetsToExclude = {
    'TextField',
    'TextFormField',
    'Form',
    'FormField',
    'showModalBottomSheet', // State management issues
    'showDialog', // Builder pattern differences
    'StatefulBuilder',
    'AnimatedBuilder',
  };
  
  /// Check if a specific widget type should use the new implementation
  static bool shouldUseNewWidget(String widgetType, {String? pageName}) {
    if (!enableMigration) return false;
    
    // CRITICAL: Never migrate database-critical pages
    if (pageName != null && _databaseCriticalPages.contains(pageName)) {
      logMigration(widgetType, pageName, success: false);
      return false; // Always use native widgets for database operations
    }
    
    // CRITICAL: Never migrate stateful form widgets
    if (_statefulWidgetsToExclude.contains(widgetType)) {
      logMigration(widgetType, pageName ?? 'unknown', success: false);
      return false; // Preserve state management for forms
    }
    
    // Check page-specific rollout
    if (pageName != null) {
      final pageEnabled = _pageRollout[pageName] ?? false;
      if (!pageEnabled) return false;
    }
    
    // Check widget-specific flags
    switch (widgetType.toLowerCase()) {
      case 'iconbutton':
        return _useIconButtons;
      case 'card':
      case 'container':
        return _useCards;
      case 'appbar':
        return _useAppBars;
      case 'elevatedbutton':
      case 'textbutton':
        return _useButtons;
      case 'floatingactionbutton':
        return _useFloatingActionButtons;
      default:
        return false;
    }
  }
  
  /// Get migration status for monitoring
  static Map<String, dynamic> getMigrationStatus() {
    return {
      'enabled': enableMigration,
      'widgets': {
        'IconButton': _useIconButtons,
        'Card': _useCards,
        'AppBar': _useAppBars,
        'Buttons': _useButtons,
        'FAB': _useFloatingActionButtons,
      },
      'pages': _pageRollout,
      'mode': kDebugMode ? 'debug' : 'release',
    };
  }
  
  /// Log migration event for monitoring
  static void logMigration(String widget, String page, {bool success = true}) {
    if (kDebugMode) {
      print('[Widget Migration] $widget in $page: ${success ? "✓" : "✗"}');
    }
  }
}