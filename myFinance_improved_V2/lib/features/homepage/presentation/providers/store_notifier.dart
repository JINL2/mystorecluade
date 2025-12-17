import 'package:flutter/foundation.dart';
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
    debugPrint('🏪 [StoreNotifier] createStore() called');
    debugPrint('🏪 [StoreNotifier] storeName: $storeName, companyId: $companyId');
    state = const StoreState.loading();

    try {
      debugPrint('🏪 [StoreNotifier] Calling _createStore usecase...');
      final result = await _createStore(CreateStoreParams(
        storeName: storeName,
        companyId: companyId,
        storeAddress: storeAddress,
        storePhone: storePhone,
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
      ),);

      debugPrint('🏪 [StoreNotifier] UseCase result received');
      result.fold(
        (failure) {
          debugPrint('❌ [StoreNotifier] Failure: ${failure.message}, code: ${failure.code}');
          state = StoreState.error(failure.message, failure.code);
        },
        (store) {
          debugPrint('✅ [StoreNotifier] Success: store_id=${store.id}');
          state = StoreState.created(store);
        },
      );
    } catch (e, stack) {
      debugPrint('❌ [StoreNotifier] Exception: $e');
      debugPrint('❌ [StoreNotifier] Stack: $stack');
      state = StoreState.error(e.toString(), 'EXCEPTION');
    }
  }

  /// Reset state to initial
  void reset() {
    state = const StoreState.initial();
  }
}
