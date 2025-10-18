import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'state_synchronizer.dart';

/// SmartSelectionProvider - Intelligent company and store selection
/// Preserves user preferences and provides smart defaults
/// 
/// Features:
/// - Remembers last selections
/// - Validates selections still exist
/// - Provides intelligent defaults
/// - Syncs with app state
/// - Handles edge cases gracefully
class SmartSelectionProvider {
  // Singleton pattern
  SmartSelectionProvider._privateConstructor();
  static final SmartSelectionProvider _instance = SmartSelectionProvider._privateConstructor();
  static SmartSelectionProvider get instance => _instance;
  
  // Storage keys
  static const String _lastCompanyKey = 'smart_last_selected_company';
  static const String _lastStoreKey = 'smart_last_selected_store';
  static const String _selectionHistoryKey = 'smart_selection_history';
  static const String _preferencesKey = 'smart_selection_preferences';
  
  // In-memory cache
  String? _lastCompanyId;
  String? _lastStoreId;
  final List<_SelectionRecord> _selectionHistory = [];
  _SelectionPreferences _preferences = _SelectionPreferences();
  
  /// Initialize smart selection (call on app start)
  static Future<void> initialize() async {
    final provider = instance;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load last selections
      provider._lastCompanyId = prefs.getString(_lastCompanyKey);
      provider._lastStoreId = prefs.getString(_lastStoreKey);
      
      // Load preferences
      final prefsJson = prefs.getString(_preferencesKey);
      if (prefsJson != null) {
        provider._preferences = _SelectionPreferences.fromJson(prefsJson);
      }
      
      // Load selection history
      final historyJson = prefs.getStringList(_selectionHistoryKey) ?? [];
      provider._selectionHistory.clear();
      for (final record in historyJson.take(20)) {
        try {
          provider._selectionHistory.add(_SelectionRecord.fromJson(record));
        } catch (_) {}
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to initialize SmartSelectionProvider: $e');
      }
    }
  }
  
  /// Auto-select company and store intelligently
  /// Only selects if no current selection exists
  static Future<void> autoSelectIfNeeded({
    required dynamic appState,
    bool forceSelection = false,
  }) async {
    final provider = instance;
    
    // Use StateSynchronizer to prevent race conditions
    await StateSynchronizer.instance.synchronized(
      'smart_selection',
      () async {
        await provider._performAutoSelection(
          appState: appState,
          forceSelection: forceSelection,
        );
      },
    );
  }
  
  /// Perform the actual auto-selection logic
  Future<void> _performAutoSelection({
    required dynamic appState,
    bool forceSelection = false,
  }) async {
    try {
      // Check if we have companies
      final companies = _getCompaniesFromState(appState);
      if (companies.isEmpty) {
        if (kDebugMode) {
          debugPrint('No companies available for selection');
        }
        return;
      }
      
      // Check current selection
      final currentCompanyId = _getCurrentCompanyId(appState);
      final currentStoreId = _getCurrentStoreId(appState);
      
      // If we have a valid selection and not forcing, keep it
      if (!forceSelection && currentCompanyId != null) {
        // Just ensure the selection is still valid
        if (_isCompanyValid(currentCompanyId, companies)) {
          // Record the selection
          await _recordSelection(currentCompanyId, currentStoreId);
          return;
        }
      }
      
      // Try to restore previous selection
      if (_lastCompanyId != null) {
        final restoredCompany = _findCompanyById(_lastCompanyId!, companies);
        if (restoredCompany != null) {
          // Restore company selection
          await _selectCompany(appState, _lastCompanyId!);
          
          // Try to restore store selection
          if (_lastStoreId != null) {
            final stores = _getStoresForCompany(restoredCompany);
            if (_isStoreValid(_lastStoreId!, stores)) {
              await _selectStore(appState, _lastStoreId!);
            } else {
              // Select first available store
              await _selectFirstStore(appState, restoredCompany);
            }
          } else {
            // Select first available store
            await _selectFirstStore(appState, restoredCompany);
          }
          
          return;
        }
      }
      
      // No valid previous selection, use intelligent default
      await _selectIntelligentDefault(appState, companies);
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in smart selection: $e');
      }
    }
  }
  
  /// Select intelligent default based on preferences and history
  Future<void> _selectIntelligentDefault(
    dynamic appState,
    List<dynamic> companies,
  ) async {
    dynamic selectedCompany;
    
    // Strategy 1: Select company with most stores
    if (_preferences.preferCompanyWithMostStores) {
      selectedCompany = _findCompanyWithMostStores(companies);
    }
    
    // Strategy 2: Select most recently used from history
    if (selectedCompany == null && _selectionHistory.isNotEmpty) {
      for (final record in _selectionHistory) {
        final company = _findCompanyById(record.companyId, companies);
        if (company != null) {
          selectedCompany = company;
          break;
        }
      }
    }
    
    // Strategy 3: Select first company
    selectedCompany ??= companies.first;
    
    // Apply selection
    final companyId = _getCompanyId(selectedCompany);
    if (companyId != null) {
      await _selectCompany(appState, companyId);
      await _selectFirstStore(appState, selectedCompany);
    }
  }
  
  /// Record a selection for future reference
  static Future<void> recordSelection(String companyId, String? storeId) async {
    await instance._recordSelection(companyId, storeId);
  }
  
  Future<void> _recordSelection(String companyId, String? storeId) async {
    try {
      // Update last selection
      _lastCompanyId = companyId;
      _lastStoreId = storeId;
      
      // Add to history
      _selectionHistory.insert(
        0,
        _SelectionRecord(
          companyId: companyId,
          storeId: storeId,
          timestamp: DateTime.now(),
        ),
      );
      
      // Limit history size
      if (_selectionHistory.length > 20) {
        _selectionHistory.removeLast();
      }
      
      // Persist to storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastCompanyKey, companyId);
      if (storeId != null) {
        await prefs.setString(_lastStoreKey, storeId);
      }
      
      // Save history
      final historyJson = _selectionHistory
          .map((record) => record.toJson())
          .toList();
      await prefs.setStringList(_selectionHistoryKey, historyJson);
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to record selection: $e');
      }
    }
  }
  
  /// Update preferences
  static Future<void> updatePreferences(_SelectionPreferences preferences) async {
    final provider = instance;
    provider._preferences = preferences;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_preferencesKey, preferences.toJson());
    } catch (_) {}
  }
  
  /// Clear selection history
  static Future<void> clearHistory() async {
    final provider = instance;
    provider._selectionHistory.clear();
    provider._lastCompanyId = null;
    provider._lastStoreId = null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastCompanyKey);
      await prefs.remove(_lastStoreKey);
      await prefs.remove(_selectionHistoryKey);
    } catch (_) {}
  }
  
  /// Get selection statistics
  static Map<String, dynamic> getStats() {
    final provider = instance;
    
    final companyFrequency = <String, int>{};
    for (final record in provider._selectionHistory) {
      companyFrequency[record.companyId] = 
          (companyFrequency[record.companyId] ?? 0) + 1;
    }
    
    return {
      'last_company': provider._lastCompanyId,
      'last_store': provider._lastStoreId,
      'history_count': provider._selectionHistory.length,
      'most_used_company': _getMostUsedCompany(companyFrequency),
      'preferences': provider._preferences.toMap(),
    };
  }
  
  static String? _getMostUsedCompany(Map<String, int> frequency) {
    if (frequency.isEmpty) return null;
    
    String? mostUsed;
    int maxCount = 0;
    
    frequency.forEach((company, count) {
      if (count > maxCount) {
        maxCount = count;
        mostUsed = company;
      }
    });
    
    return mostUsed;
  }
  
  // Helper methods for state interaction
  // These would need to be adapted based on your actual state structure
  
  List<dynamic> _getCompaniesFromState(dynamic appState) {
    // Adapt based on your state structure
    try {
      return appState.companies ?? [];
    } catch (_) {
      return [];
    }
  }
  
  String? _getCurrentCompanyId(dynamic appState) {
    try {
      return appState.selectedCompany;
    } catch (_) {
      return null;
    }
  }
  
  String? _getCurrentStoreId(dynamic appState) {
    try {
      return appState.selectedStore;
    } catch (_) {
      return null;
    }
  }
  
  bool _isCompanyValid(String companyId, List<dynamic> companies) {
    return companies.any((c) => _getCompanyId(c) == companyId);
  }
  
  bool _isStoreValid(String storeId, List<dynamic> stores) {
    return stores.any((s) => _getStoreId(s) == storeId);
  }
  
  dynamic _findCompanyById(String companyId, List<dynamic> companies) {
    try {
      return companies.firstWhere((c) => _getCompanyId(c) == companyId);
    } catch (_) {
      return null;
    }
  }
  
  dynamic _findCompanyWithMostStores(List<dynamic> companies) {
    if (companies.isEmpty) return null;
    
    dynamic bestCompany = companies.first;
    int maxStores = 0;
    
    for (final company in companies) {
      final stores = _getStoresForCompany(company);
      if (stores.length > maxStores) {
        maxStores = stores.length;
        bestCompany = company;
      }
    }
    
    return bestCompany;
  }
  
  List<dynamic> _getStoresForCompany(dynamic company) {
    try {
      return company['stores'] ?? [];
    } catch (_) {
      return [];
    }
  }
  
  String? _getCompanyId(dynamic company) {
    try {
      return company['company_id'] ?? company['id'];
    } catch (_) {
      return null;
    }
  }
  
  String? _getStoreId(dynamic store) {
    try {
      return store['store_id'] ?? store['id'];
    } catch (_) {
      return null;
    }
  }
  
  Future<void> _selectCompany(dynamic appState, String companyId) async {
    try {
      await appState.setCompanyChoosen(companyId);
      await _recordSelection(companyId, null);
    } catch (_) {}
  }
  
  Future<void> _selectStore(dynamic appState, String storeId) async {
    try {
      await appState.setStoreChoosen(storeId);
      if (_lastCompanyId != null) {
        await _recordSelection(_lastCompanyId!, storeId);
      }
    } catch (_) {}
  }
  
  Future<void> _selectFirstStore(dynamic appState, dynamic company) async {
    final stores = _getStoresForCompany(company);
    if (stores.isNotEmpty) {
      final storeId = _getStoreId(stores.first);
      if (storeId != null) {
        await _selectStore(appState, storeId);
      }
    }
  }
}

/// Selection record for history
class _SelectionRecord {
  final String companyId;
  final String? storeId;
  final DateTime timestamp;
  
  _SelectionRecord({
    required this.companyId,
    this.storeId,
    required this.timestamp,
  });
  
  factory _SelectionRecord.fromJson(String json) {
    final parts = json.split('|');
    return _SelectionRecord(
      companyId: parts[0],
      storeId: parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null,
      timestamp: DateTime.parse(parts[2]),
    );
  }
  
  String toJson() {
    return '$companyId|${storeId ?? ''}|${timestamp.toIso8601String()}';
  }
}

/// Selection preferences
class _SelectionPreferences {
  final bool preferCompanyWithMostStores;
  final bool preferLastUsed;
  final bool autoSelectFirstStore;
  
  _SelectionPreferences({
    this.preferCompanyWithMostStores = true,
    this.preferLastUsed = true,
    this.autoSelectFirstStore = true,
  });
  
  factory _SelectionPreferences.fromJson(String json) {
    final parts = json.split('|');
    return _SelectionPreferences(
      preferCompanyWithMostStores: parts[0] == 'true',
      preferLastUsed: parts[1] == 'true',
      autoSelectFirstStore: parts[2] == 'true',
    );
  }
  
  String toJson() {
    return '$preferCompanyWithMostStores|$preferLastUsed|$autoSelectFirstStore';
  }
  
  Map<String, bool> toMap() {
    return {
      'prefer_company_with_most_stores': preferCompanyWithMostStores,
      'prefer_last_used': preferLastUsed,
      'auto_select_first_store': autoSelectFirstStore,
    };
  }
}