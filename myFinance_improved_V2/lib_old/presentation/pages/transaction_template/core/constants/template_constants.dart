/// Template Constants - Core business constants for transaction templates
///
/// Purpose: Centralized constants for consistent business logic:
/// - Permission IDs and role definitions
/// - Visibility and permission level enums
/// - Default values and validation rules
/// - Business thresholds and limits
/// - API endpoints and database field names
///
/// Benefits:
/// - Single source of truth for business values
/// - Easy to change business rules in one place
/// - Prevents typos in hardcoded strings
/// - Makes code self-documenting
/// - Enables compile-time checks

/// Permission IDs - UUIDs for specific permissions
class TemplatePermissions {
  /// Admin permission UUID for template management
  static const String adminPermissionId = 'c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14';
  
  /// Permission to create templates
  static const String createTemplatePermission = 'create_transaction_template';
  
  /// Permission to delete templates
  static const String deleteTemplatePermission = 'delete_transaction_template';
  
  /// Permission to modify templates
  static const String modifyTemplatePermission = 'modify_transaction_template';
}

/// Template visibility levels - who can see the template
class TemplateVisibility {
  /// Template visible to all users in company
  static const String public = 'Public';
  
  /// Template visible only to creator
  static const String private = 'Private';
  
  /// All valid visibility levels
  static const List<String> validLevels = [public, private];
  
  /// Default visibility for new templates
  static const String defaultLevel = public;
}

/// Template permission levels - who can use the template
class TemplatePermissionLevels {
  /// Template usable by all users
  static const String common = 'Common';
  
  /// Template usable only by managers
  static const String manager = 'Manager';
  
  /// All valid permission levels
  static const List<String> validLevels = [common, manager];
  
  /// Default permission level for new templates
  static const String defaultLevel = common;
}

/// Template UI constants
class TemplateUI {
  /// Tab names for template page
  static const String generalTab = 'General';
  static const String adminTab = 'Admin';
  
  /// Default tab configuration
  static const List<String> defaultTabs = [generalTab];
  static const List<String> adminTabs = [generalTab, adminTab];
}

/// Template validation rules
class TemplateValidationRules {
  /// Minimum template name length
  static const int minNameLength = 1;
  
  /// Maximum template name length
  static const int maxNameLength = 100;
  
  /// Maximum description length
  static const int maxDescriptionLength = 500;
  
  /// Required fields for template creation
  static const List<String> requiredFields = ['name', 'visibilityLevel', 'permission'];
}

/// Database field names - prevents typos in queries
class TemplateFields {
  // Template table fields
  static const String templateId = 'template_id';
  static const String name = 'name';
  static const String description = 'template_description';
  static const String data = 'data';
  static const String permission = 'permission';
  static const String tags = 'tags';
  static const String visibilityLevel = 'visibility_level';
  static const String isActive = 'is_active';
  static const String companyId = 'company_id';
  static const String storeId = 'store_id';
  static const String counterpartyId = 'counterparty_id';
  static const String counterpartyCashLocationId = 'counterparty_cash_location_id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String updatedBy = 'updated_by';
}

/// Business thresholds and limits
class TemplateThresholds {
  /// Maximum number of templates per user
  static const int maxTemplatesPerUser = 100;
  
  /// Template usage tracking period (days)
  static const int usageTrackingDays = 90;
  
  /// Recency bonus scoring
  static const int recencyBonus7Days = 15;
  static const int recencyBonus30Days = 8;
  static const int recencyBonus90Days = 3;
  static const int recencyBonusOlder = 1;
}

/// Account type constants
class AccountTypes {
  static const String cash = 'cash';
  static const String payable = 'payable';
  static const String receivable = 'receivable';
  static const String fixedAsset = 'fixedasset';
  
  /// Account types that require counterparty
  static const List<String> requireCounterparty = [payable, receivable];
  
  /// Account types excluded from templates
  static const List<String> excludedFromTemplates = [fixedAsset];
}

/// Transaction types
class TransactionTypes {
  static const String debit = 'debit';
  static const String credit = 'credit';
  
  static const List<String> validTypes = [debit, credit];
}

/// Default values for template creation
class TemplateDefaults {
  static const String defaultAmount = '0';
  static const String defaultDebit = '0';
  static const String defaultCredit = '0';
  static const bool defaultIsActive = true;
}