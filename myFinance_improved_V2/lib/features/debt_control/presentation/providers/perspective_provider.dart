import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/debt_control_state.dart';

/// Perspective state provider for viewpoint selection
final perspectiveProvider =
    StateNotifierProvider<PerspectiveNotifier, PerspectiveState>(
  (ref) => PerspectiveNotifier(),
);

class PerspectiveNotifier extends StateNotifier<PerspectiveState> {
  PerspectiveNotifier() : super(const PerspectiveState());

  /// Change perspective (company, store, headquarters)
  void changePerspective(String perspective) {
    state = state.copyWith(
      selectedPerspective: perspective,
      isChangingPerspective: false,
    );
  }

  /// Select store for store perspective
  void selectStore(String storeId, String storeName) {
    state = state.copyWith(
      selectedPerspective: 'store',
      selectedStoreId: storeId,
      selectedStoreName: storeName,
      isChangingPerspective: false,
    );
  }

  /// Set available stores
  void setAvailableStores(List<Map<String, String>> stores) {
    state = state.copyWith(availableStores: stores);
  }

  /// Start changing perspective (for loading state)
  void startChangingPerspective() {
    state = state.copyWith(isChangingPerspective: true);
  }

  /// Reset to company perspective
  void resetToCompany() {
    state = const PerspectiveState(selectedPerspective: 'company');
  }
}
