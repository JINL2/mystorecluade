import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/create_store.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/states/store_state.dart';

/// StateNotifier for managing Store creation state
class StoreNotifier extends StateNotifier<StoreState> {
  StoreNotifier(this._createStore) : super(const StoreState.initial());

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
    state = const StoreState.loading();

    final result = await _createStore(CreateStoreParams(
      storeName: storeName,
      companyId: companyId,
      storeAddress: storeAddress,
      storePhone: storePhone,
      huddleTime: huddleTime,
      paymentTime: paymentTime,
      allowedDistance: allowedDistance,
    ),);

    result.fold(
      (failure) => state = StoreState.error(failure.message, failure.code),
      (store) => state = StoreState.created(store),
    );
  }

  /// Reset state to initial
  void reset() {
    state = const StoreState.initial();
  }
}
