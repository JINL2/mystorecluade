import '../../../../app/providers/app_state.dart';

/// Store option for selection lists
class StoreOption {
  final String id;
  final String name;

  const StoreOption({
    required this.id,
    required this.name,
  });
}

/// Utility class for store-related operations
class StoreUtils {
  /// Get all stores for the current company from AppState
  static List<StoreOption> getCompanyStores(AppState appState) {
    final currentCompanyId = appState.companyChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    // Find current company
    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) {
      return [
        StoreOption(
          id: appState.storeChoosen,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
        ),
      ];
    }

    final storesList = company['stores'] as List<dynamic>? ?? [];

    if (storesList.isEmpty) {
      return [
        StoreOption(
          id: appState.storeChoosen,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
        ),
      ];
    }

    return storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return StoreOption(
        id: storeMap['store_id'] as String? ?? '',
        name: storeMap['store_name'] as String? ?? 'Unknown Store',
      );
    }).toList();
  }

  /// Get store names list for filter dropdowns
  static List<String> getStoreNames(AppState appState) {
    return getCompanyStores(appState).map((s) => s.name).toList();
  }

  /// Find store by name
  static StoreOption? findStoreByName(AppState appState, String name) {
    final stores = getCompanyStores(appState);
    for (final store in stores) {
      if (store.name == name) {
        return store;
      }
    }
    return null;
  }

  /// Find store by ID
  static StoreOption? findStoreById(AppState appState, String id) {
    final stores = getCompanyStores(appState);
    for (final store in stores) {
      if (store.id == id) {
        return store;
      }
    }
    return null;
  }
}
