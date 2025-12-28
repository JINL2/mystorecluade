import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../domain/usecases/create_store.dart';
import 'states/store_state.dart';
import 'usecase_providers.dart';

part 'store_notifier.g.dart';

/// Notifier for managing Store creation state
///
/// Migrated from StateNotifier to @riverpod Notifier pattern.
/// Uses StoreState (freezed) for type-safe state management.
@riverpod
class StoreNotifier extends _$StoreNotifier {
  @override
  StoreState build() => const StoreState.initial();

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
    final createStore = ref.read(createStoreUseCaseProvider);

    state = const StoreState.loading();

    try {
      final result = await createStore(
        CreateStoreParams(
          storeName: storeName,
          companyId: companyId,
          storeAddress: storeAddress,
          storePhone: storePhone,
          huddleTime: huddleTime,
          paymentTime: paymentTime,
          allowedDistance: allowedDistance,
        ),
      );

      result.fold(
        (failure) {
          state = StoreState.error(failure.message, failure.code);
        },
        (store) {
          state = StoreState.created(store);
        },
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'StoreNotifier.createStore failed',
        extra: {'storeName': storeName, 'companyId': companyId},
      );
      state = StoreState.error(e.toString(), 'EXCEPTION');
    }
  }

  /// Reset state to initial
  void reset() {
    state = const StoreState.initial();
  }
}
