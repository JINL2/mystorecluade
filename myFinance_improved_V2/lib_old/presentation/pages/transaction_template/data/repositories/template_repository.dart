/// Template Repository - Data access layer for transaction templates
///
/// Purpose: Orchestrates data operations and provides unified interface:
/// - Coordinates between data service and cache repository
/// - Implements caching strategies for performance
/// - Handles data transformation and validation
/// - Provides error handling and retry logic
/// - Manages data consistency and synchronization
///
/// Usage: TemplateRepository.create(templateData)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/template_data_service.dart';
import '../cache/template_cache_repository.dart';
import '../../../../../data/services/supabase_service.dart';

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepository(
    dataService: ref.read(templateDataServiceProvider),
    cacheRepository: ref.read(templateCacheRepositoryProvider),
  );
});

final templateDataServiceProvider = Provider<TemplateDataService>((ref) {
  return TemplateDataService(SupabaseService());
});

class TemplateRepository {
  final TemplateDataService _dataService;
  final TemplateCacheRepository _cacheRepository;

  TemplateRepository({
    required TemplateDataService dataService,
    required TemplateCacheRepository cacheRepository,
  }) : _dataService = dataService, _cacheRepository = cacheRepository;

  /// Create a new template
  Future<void> createTemplate({
    required String name,
    required String? description,
    required String companyId,
    required String storeId,
    required String userId,
    required List<Map<String, dynamic>> data,
    required List<String> tags,
    required String visibilityLevel,
    required String permission,
    String? counterpartyId,
    String? counterpartyCashLocationId,
  }) async {
    // Create template via data service
    await _dataService.createTemplate(
      name: name,
      description: description,
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      data: data,
      tags: tags,
      visibilityLevel: visibilityLevel,
      permission: permission,
      counterpartyId: counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId,
    );

    // Invalidate cache to force refresh
    await _cacheRepository.invalidateTemplatesCache(companyId, storeId);
  }

  /// Get templates with caching
  Future<List<Map<String, dynamic>>> getTemplates({
    required String companyId,
    required String storeId,
    bool? isActive,
    String? visibilityLevel,
    bool forceRefresh = false,
  }) async {
    // Check cache first unless force refresh is requested
    if (!forceRefresh) {
      final cachedTemplates = await _cacheRepository.getCachedTemplates(
        companyId: companyId,
        storeId: storeId,
        isActive: isActive,
        visibilityLevel: visibilityLevel,
      );
      
      if (cachedTemplates != null) {
        return cachedTemplates;
      }
    }

    // Fetch from data service
    final templates = await _dataService.getTemplates(
      companyId: companyId,
      storeId: storeId,
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    // Cache the results
    await _cacheRepository.cacheTemplates(
      companyId: companyId,
      storeId: storeId,
      templates: templates,
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    return templates;
  }

  /// Search templates
  Future<List<Map<String, dynamic>>> searchTemplates({
    required String companyId,
    required String storeId,
    String? searchQuery,
    List<String>? categoryFilters,
    List<String>? accountFilters,
  }) async {
    // For search operations, always go to data service for fresh results
    return await _dataService.searchTemplates(
      companyId: companyId,
      storeId: storeId,
      searchQuery: searchQuery,
      categoryFilters: categoryFilters,
      accountFilters: accountFilters,
    );
  }

  /// Get template by ID
  Future<Map<String, dynamic>?> getTemplateById(
    String templateId, {
    bool useCache = true,
  }) async {
    // Check cache first if enabled
    if (useCache) {
      final cachedTemplate = await _cacheRepository.getCachedTemplateById(templateId);
      if (cachedTemplate != null) {
        return cachedTemplate;
      }
    }

    // Fetch from data service
    final template = await _dataService.getTemplateById(templateId);
    
    // Cache the result if found
    if (template != null) {
      await _cacheRepository.cacheTemplate(template);
    }

    return template;
  }

  /// Update template
  Future<void> updateTemplate({
    required String templateId,
    required String name,
    String? description,
    required List<Map<String, dynamic>> data,
    required List<String> tags,
    required String visibilityLevel,
    required String permission,
    required String userId,
    required String companyId,
    required String storeId,
    String? counterpartyId,
    String? counterpartyCashLocationId,
  }) async {
    // Update via data service
    await _dataService.updateTemplate(
      templateId: templateId,
      name: name,
      description: description,
      data: data,
      tags: tags,
      visibilityLevel: visibilityLevel,
      permission: permission,
      userId: userId,
      counterpartyId: counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId,
    );

    // Invalidate cache
    await _cacheRepository.invalidateTemplateCache(templateId);
    await _cacheRepository.invalidateTemplatesCache(companyId, storeId);
  }

  /// Delete template (soft delete)
  Future<void> deleteTemplate({
    required String templateId,
    required String userId,
    required String companyId,
    required String storeId,
  }) async {
    // Delete via data service
    await _dataService.deleteTemplate(
      templateId: templateId,
      userId: userId,
    );

    // Invalidate cache
    await _cacheRepository.invalidateTemplateCache(templateId);
    await _cacheRepository.invalidateTemplatesCache(companyId, storeId);
  }

  /// Update template status
  Future<void> updateTemplateStatus({
    required String templateId,
    required bool isActive,
    required String userId,
    required String companyId,
    required String storeId,
  }) async {
    // Update via data service
    await _dataService.updateTemplateStatus(
      templateId: templateId,
      isActive: isActive,
      userId: userId,
    );

    // Invalidate cache
    await _cacheRepository.invalidateTemplateCache(templateId);
    await _cacheRepository.invalidateTemplatesCache(companyId, storeId);
  }

  /// Get template statistics
  Future<Map<String, int>> getTemplateStats({
    required String companyId,
    required String storeId,
  }) async {
    final templates = await getTemplates(
      companyId: companyId,
      storeId: storeId,
    );

    final activeTemplates = templates.where((t) => t['is_active'] == true).length;
    final totalTemplates = templates.length;
    final publicTemplates = templates.where((t) => t['visibility_level'] == 'public').length;
    final privateTemplates = templates.where((t) => t['visibility_level'] == 'private').length;

    return {
      'total': totalTemplates,
      'active': activeTemplates,
      'inactive': totalTemplates - activeTemplates,
      'public': publicTemplates,
      'private': privateTemplates,
    };
  }

  /// Refresh all cached data
  Future<void> refreshCache({
    required String companyId,
    required String storeId,
  }) async {
    await _cacheRepository.invalidateAllCache();
    await getTemplates(
      companyId: companyId,
      storeId: storeId,
      forceRefresh: true,
    );
  }
}