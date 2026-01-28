import '../entities/template_entity.dart';

/// Repository interface for template data operations
///
/// Clean Architecture compliant repository interface.
/// Contains only essential CRUD operations - no Statistics or Feature Creep.
/// Uses RPC calls for list/search operations (transaction_template_get_list).
/// Follows the original pragmatic design principles.
abstract class TemplateRepository {
  // === Core CRUD Operations (Essential) ===

  /// Upserts a template via RPC
  ///
  /// Uses RPC: transaction_template_upsert_template
  /// - If templateId is null: INSERT (create new template)
  /// - If templateId is provided: UPDATE (modify existing template)
  /// [localTime] and [timezone] are required for UTC timestamp conversion
  Future<String> upsert({
    String? templateId,
    required String name,
    required List<Map<String, dynamic>> data,
    required String companyId,
    required String visibilityLevel,
    required String permission,
    required String userId,
    required String localTime,
    required String timezone,
    String? templateDescription,
    Map<String, dynamic>? tags,
    String? storeId,
    String? counterpartyId,
    String? counterpartyCashLocationId,
    bool? isActive,
    bool? requiredAttachment,
  });

  /// Finds a template by its unique identifier
  Future<TransactionTemplate?> findById(String templateId);

  /// Gets templates for a specific company/store via RPC
  ///
  /// Uses RPC: transaction_template_get_list
  /// [timezone] is required for UTC to local time conversion
  Future<List<TransactionTemplate>> findByContext({
    required String companyId,
    required String timezone,
    String? storeId,
    bool? isActive,
    String? visibilityLevel,
  });

  /// Deletes a template via RPC (soft delete)
  ///
  /// Uses RPC: transaction_template_delete_template
  /// Sets is_active = false with proper audit trail
  /// [localTime] and [timezone] are required for UTC timestamp conversion
  Future<void> delete({
    required String templateId,
    required String userId,
    required String companyId,
    required String localTime,
    required String timezone,
  });

  // === Business-Essential Queries ===

  /// Checks if a template name already exists for a company
  Future<bool> nameExists(String name, String companyId);

  /// Counts templates created by a specific user (for quota validation)
  Future<int> countUserTemplates(String userId);

  /// Finds similar templates by name (for duplicate detection)
  Future<List<TransactionTemplate>> findSimilar({
    required String templateName,
    required String companyId,
    required double similarityThreshold,
    required int limit,
  });

  // === Search Operations via RPC ===

  /// Search templates with filters via RPC
  ///
  /// Uses RPC: transaction_template_get_list
  /// [timezone] is required for UTC to local time conversion
  Future<List<TransactionTemplate>> search({
    required String timezone,
    String? namePattern,
    String? companyId,
    String? storeId,
    String? createdBy,
    List<String>? categoryFilters,
    List<String>? accountFilters,
    int? limit,
    int? offset,
  });
}

// REMOVED: All Statistics classes - Clean Architecture violation
// These DTOs should be in Application Layer, not Domain Repository
//
// - TemplateUsageStatistics
// - CompanyTemplateStatistics  
// - TemplateUsageInfo
//
// Domain Repository should only contain pure business interfaces