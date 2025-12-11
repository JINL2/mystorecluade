// =====================================================
// TEMPLATE CACHE SERVICE
// Caches frequently used templates for performance
// Based on TRANSACTION_TEMPLATES_GUIDE.md recommendations
// =====================================================

import 'package:supabase_flutter/supabase_flutter.dart';

/// Service to cache transaction templates for improved performance
/// Implements the caching strategy recommended in TRANSACTION_TEMPLATES_GUIDE.md
class TemplateCacheService {
  static final TemplateCacheService _instance = TemplateCacheService._internal();
  factory TemplateCacheService() => _instance;
  TemplateCacheService._internal();

  // Cache storage with template_id as key
  final Map<String, Map<String, dynamic>> _cache = {};
  
  // Cache metadata to track usage and expiry
  final Map<String, DateTime> _cacheTimestamps = {};
  
  // Cache duration (templates are relatively stable, so we can cache for longer)
  static const Duration _cacheDuration = Duration(minutes: 30);
  
  // Maximum cache size to prevent memory issues
  static const int _maxCacheSize = 50;

  /// Get a template from cache or fetch from database
  Future<Map<String, dynamic>?> getTemplate(String templateId) async {
    // Check if template is in cache and not expired
    if (_cache.containsKey(templateId)) {
      final timestamp = _cacheTimestamps[templateId];
      if (timestamp != null && 
          DateTime.now().difference(timestamp) < _cacheDuration) {
        // Return cached template
        return Map<String, dynamic>.from(_cache[templateId]!);
      }
      // Remove expired entry
      _removeFromCache(templateId);
    }
    
    // Fetch from database
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('transaction_templates')
          .select('*')
          .eq('template_id', templateId)
          .single();
      
      // Add to cache
      _addToCache(templateId, response);
      
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Error fetching template $templateId: $e');
      return null;
    }
  }
  
  /// Pre-cache multiple templates (useful for quick access templates)
  Future<void> preCacheTemplates(List<String> templateIds) async {
    if (templateIds.isEmpty) return;
    
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('transaction_templates')
          .select('*')
          .inFilter('template_id', templateIds);
      
      // Add all templates to cache
      for (var template in response) {
        final templateId = template['template_id'] as String;
        _addToCache(templateId, template);
      }
    } catch (e) {
      print('Error pre-caching templates: $e');
    }
  }
  
  /// Add a template to the cache
  void _addToCache(String templateId, Map<String, dynamic> template) {
    // Check cache size limit
    if (_cache.length >= _maxCacheSize) {
      // Remove oldest entry
      _removeOldestEntry();
    }
    
    _cache[templateId] = Map<String, dynamic>.from(template);
    _cacheTimestamps[templateId] = DateTime.now();
  }
  
  /// Remove a template from the cache
  void _removeFromCache(String templateId) {
    _cache.remove(templateId);
    _cacheTimestamps.remove(templateId);
  }
  
  /// Remove the oldest cached entry
  void _removeOldestEntry() {
    if (_cacheTimestamps.isEmpty) return;
    
    String? oldestKey;
    DateTime? oldestTime;
    
    for (var entry in _cacheTimestamps.entries) {
      if (oldestTime == null || entry.value.isBefore(oldestTime)) {
        oldestKey = entry.key;
        oldestTime = entry.value;
      }
    }
    
    if (oldestKey != null) {
      _removeFromCache(oldestKey);
    }
  }
  
  /// Clear all cached templates
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }
  
  /// Invalidate a specific template (useful after updates)
  void invalidateTemplate(String templateId) {
    _removeFromCache(templateId);
  }
  
  /// Get cache statistics (for debugging)
  Map<String, dynamic> getCacheStats() {
    return {
      'size': _cache.length,
      'maxSize': _maxCacheSize,
      'cacheDuration': _cacheDuration.inMinutes,
      'templates': _cache.keys.toList(),
    };
  }
}