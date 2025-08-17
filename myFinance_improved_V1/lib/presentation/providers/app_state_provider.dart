import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App state class to hold persistent data - FOLLOWING READMEAppState.md EXACTLY
class AppState {
  const AppState({
    this.categoryFeatures = const [],
    this.user = const {},
    this.companyChoosen = '',
    this.storeChoosen = '',
  });

  // As per READMEAppState.md requirements:
  final dynamic categoryFeatures; // JSON Array from get_categories_with_features() RPC
  final dynamic user; // JSON Object from get_user_companies_and_stores(user_id) RPC
  final String companyChoosen; // Currently selected company ID (session only)
  final String storeChoosen; // Currently selected store ID (session only)

  AppState copyWith({
    dynamic? categoryFeatures,
    dynamic? user,
    String? companyChoosen,
    String? storeChoosen,
  }) {
    return AppState(
      categoryFeatures: categoryFeatures ?? this.categoryFeatures,
      user: user ?? this.user,
      companyChoosen: companyChoosen ?? this.companyChoosen,
      storeChoosen: storeChoosen ?? this.storeChoosen,
    );
  }

  Map<String, dynamic> toJson() {
    // Persist all app state fields as per updated READMEAppState.md
    return {
      'categoryFeatures': categoryFeatures,
      'user': user,
      'companyChoosen': companyChoosen,
      'storeChoosen': storeChoosen,
    };
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      categoryFeatures: json['categoryFeatures'] ?? [],
      user: json['user'] ?? {},
      // Load persisted values or default to empty string
      companyChoosen: json['companyChoosen'] ?? '',
      storeChoosen: json['storeChoosen'] ?? '',
    );
  }
}

// App state notifier with persistence
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState()) {
    _loadFromStorage();
  }

  static const String _storageKey = 'app_state';

  // Load state from SharedPreferences
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = AppState.fromJson(json);
      }
    } catch (e) {
    }
  }

  // Save state to SharedPreferences
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.toJson());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
    }
  }

  // Set categoryFeatures from get_categories_with_features() RPC
  Future<void> setCategoryFeatures(dynamic features) async {
    state = state.copyWith(categoryFeatures: features);
    await _saveToStorage();
  }

  // Set user from get_user_companies_and_stores(user_id) RPC
  Future<void> setUser(dynamic userData) async {
    state = state.copyWith(user: userData);
    await _saveToStorage();
  }

  // Set companyChoosen (now persisted as per updated requirements)
  Future<void> setCompanyChoosen(String companyId) async {
    state = state.copyWith(
      companyChoosen: companyId,
      // Note: Don't automatically clear storeChoosen here - let the caller decide
    );
    await _saveToStorage(); // Now persisting to storage
  }

  // Set storeChoosen (now persisted as per updated requirements)
  Future<void> setStoreChoosen(String storeId) async {
    state = state.copyWith(storeChoosen: storeId);
    await _saveToStorage(); // Now persisting to storage
  }

  // Clear all data (logout)
  Future<void> clearData() async {
    state = const AppState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  // Get selected company from user JSON
  dynamic get selectedCompany {
    if (state.companyChoosen.isEmpty || state.user.isEmpty) {
      return null;
    }
    
    try {
      final companies = state.user['companies'] as List<dynamic>?;
      if (companies == null) return null;
      
      return companies.firstWhere(
        (company) => company['company_id'] == state.companyChoosen,
        orElse: () => null,
      );
    } catch (e) {
      return null;
    }
  }

  // Get selected store from selected company
  dynamic get selectedStore {
    if (state.storeChoosen.isEmpty || selectedCompany == null) {
      return null;
    }
    
    try {
      final stores = selectedCompany['stores'] as List<dynamic>?;
      if (stores == null) return null;
      
      return stores.firstWhere(
        (store) => store['store_id'] == state.storeChoosen,
        orElse: () => null,
      );
    } catch (e) {
      return null;
    }
  }

  // Helper to check if we have user data
  bool get hasUserData => state.user.isNotEmpty;
  
  // Helper to check if we have category features
  bool get hasCategoryFeatures => (state.categoryFeatures as List).isNotEmpty;


  // Refresh all data from API
  Future<void> refreshAllData() async {
    // Clear persistent data to force refresh from API
    state = state.copyWith(
      categoryFeatures: [],
      user: {},
    );
    await _saveToStorage();
  }

}

// Provider for app state
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// Computed providers for convenience
final selectedCompanyProvider = Provider<dynamic>((ref) {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  // Force the provider to rebuild when app state changes
  return appStateNotifier.selectedCompany;
});

final selectedStoreProvider = Provider<dynamic>((ref) {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  // Force the provider to rebuild when app state changes
  return appStateNotifier.selectedStore;
});

final userDataProvider = Provider<dynamic>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.user;
});

final categoryFeaturesProvider = Provider<dynamic>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.categoryFeatures;
});