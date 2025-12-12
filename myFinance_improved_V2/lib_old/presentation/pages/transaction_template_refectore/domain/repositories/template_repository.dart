import '../entities/template_entity.dart';

/// Repository interface for template data operations
/// 
/// Clean Architecture compliant repository interface.
/// Contains only essential CRUD operations - no Statistics or Feature Creep.
/// Follows the original pragmatic design principles.
abstract class TemplateRepository {
  // === Core CRUD Operations (Essential) ===
  
  /// Saves a new template or updates an existing one
  Future<void> save(TransactionTemplate template);
  
  /// Finds a template by its unique identifier
  Future<TransactionTemplate?> findById(String templateId);
  
  /// Gets templates for a specific company/store (primary query)
  Future<List<TransactionTemplate>> findByContext({
    required String companyId,
    String? storeId,
    bool? isActive,
    String? visibilityLevel,
  });
  
  /// Deletes a template
  Future<void> delete(String templateId);
  
  /// Deletes a template with context validation (UI compatibility)
  Future<void> deleteTemplate({
    required String templateId,
    required String userId,
    required String companyId,
    required String storeId,
  });
  
  // === Business-Essential Queries ===
  
  /// Finds templates by name (exact match) - for validation
  Future<TransactionTemplate?> findByName(String name, String companyId);
  
  /// Checks if a template name already exists for a company
  Future<bool> nameExists(String name, String companyId);
  
  /// Finds templates created by a specific user
  Future<List<TransactionTemplate>> findByCreatedBy(String userId);
  
  /// Counts templates created by a specific user (for quota validation)
  Future<int> countUserTemplates(String userId);
  
  /// Finds similar templates by name (for duplicate detection)
  Future<List<TransactionTemplate>> findSimilar({
    required String templateName,
    required String companyId,
    required double similarityThreshold,
    required int limit,
  });
  
  // === Search Operations (Simplified) ===
  
  /// Basic search with essential criteria only
  Future<List<TransactionTemplate>> search({
    String? namePattern,
    String? companyId,
    String? storeId,
    String? createdBy,
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