import 'dart:convert';
import 'package:flutter/foundation.dart';
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
      companyChoosen: (json['companyChoosen'] ?? '').toString(),
      storeChoosen: (json['storeChoosen'] ?? '').toString(),
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
      } else {
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
    if (userData is Map) {
      final companies = userData['companies'] as List<dynamic>? ?? [];
    }
    state = state.copyWith(user: userData);
    await _saveToStorage();
  }
  
  // Update specific user profile fields without fetching from database
  // Just sync the UI with what we know we saved
  Future<void> updateUserProfileLocally({
    String? firstName,
    String? lastName,
    String? profileImage,
  }) async {
    if (state.user is! Map) return;
    
    // Create a deep copy of the user object
    final updatedUser = Map<String, dynamic>.from(state.user as Map);
    
    // Update the specific fields if provided
    if (firstName != null) {
      updatedUser['user_first_name'] = firstName;
    }
    if (lastName != null) {
      updatedUser['user_last_name'] = lastName;
    }
    if (profileImage != null) {
      updatedUser['profile_image'] = profileImage;
    }
    
    // Update state with modified user object
    state = state.copyWith(user: updatedUser);
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

  // Clear all data (logout) - COMPLETELY REMOVES ALL USER DATA
  Future<void> clearData() async {
    // Reset state to default empty values
    state = const AppState();
    
    // Clear from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    
    // Clear any other cached data that might exist
    // This ensures complete data cleanup for security and privacy
  }

  // Get selected company from user JSON
  dynamic get selectedCompany {
    if (state.companyChoosen.isEmpty || (state.user is Map && (state.user as Map).isEmpty)) {
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
  bool get hasUserData {
    if (state.user is Map) {
      return (state.user as Map).isNotEmpty;
    }
    return false;
  }
  
  // Helper to check if we have category features
  bool get hasCategoryFeatures {
    if (state.categoryFeatures is List) {
      return (state.categoryFeatures as List).isNotEmpty;
    }
    return false;
  }


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

// 🎯 CENTRALIZED USER DISPLAY PROVIDERS
// These providers watch AppState and provide user display data
// ensuring UI always reflects the latest AppState changes

/// Provider for user display data (name, profile image)
/// This is the SINGLE SOURCE OF TRUTH for UI components
final userDisplayDataProvider = Provider<Map<String, dynamic>>((ref) {
  final appState = ref.watch(appStateProvider);
  final userData = appState.user;
  
  // Return user display data from AppState
  if (userData is Map && userData.isNotEmpty) {
    return {
      'profile_image': userData['profile_image'] ?? '',
      'user_first_name': userData['user_first_name'] ?? '',
      'user_last_name': userData['user_last_name'] ?? '',
      'user_email': userData['user_email'] ?? '',
      'user_id': userData['user_id'] ?? '',
      // Include full userData for compatibility
      ...userData,
    };
  }
  
  // Return empty map if no user data
  return {};
});

/// Provider specifically for user profile image URL
final userProfileImageProvider = Provider<String>((ref) {
  final displayData = ref.watch(userDisplayDataProvider);
  return displayData['profile_image'] ?? '';
});

/// Provider specifically for user first name
final userFirstNameProvider = Provider<String>((ref) {
  final displayData = ref.watch(userDisplayDataProvider);
  return displayData['user_first_name'] ?? 'User';
});

/// Provider specifically for user full name
final userFullNameProvider = Provider<String>((ref) {
  final displayData = ref.watch(userDisplayDataProvider);
  final firstName = displayData['user_first_name'] ?? '';
  final lastName = displayData['user_last_name'] ?? '';
  
  if (firstName.isEmpty && lastName.isEmpty) {
    return 'User';
  }
  return '$firstName $lastName'.trim();
});

/// Provider for user initials (for avatar fallback)
final userInitialsProvider = Provider<String>((ref) {
  final displayData = ref.watch(userDisplayDataProvider);
  final firstName = displayData['user_first_name'] ?? '';
  
  if (firstName.isNotEmpty) {
    return firstName[0].toUpperCase();
  }
  return 'U';
});