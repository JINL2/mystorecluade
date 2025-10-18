import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/create_store.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/store_state.dart';

/// StateNotifier for managing Store creation state
class StoreNotifier extends StateNotifier<StoreState> {
  StoreNotifier(this._createStore) : super(const StoreInitial());

  final CreateStore _createStore;

  /// Create a new store
  Future<void> createStore({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    state = const StoreLoading();

    final result = await _createStore(CreateStoreParams(
      storeName: storeName,
      companyId: companyId,
      storeAddress: storeAddress,
      storePhone: storePhone,
      huddleTime: huddleTime,
      paymentTime: paymentTime,
      allowedDistance: allowedDistance,
    ));

    result.fold(
      (failure) => state = StoreError(failure.message, failure.code),
      (store) => state = StoreCreated(store),
    );
  }

  /// Reset state to initial
  void reset() {
    state = const StoreInitial();
  }
}
