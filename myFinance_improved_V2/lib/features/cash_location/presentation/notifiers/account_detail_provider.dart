import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/use_case_providers.dart';
import 'account_detail_notifier.dart';
import 'account_detail_state.dart';

/// Provider for Account Detail page state
///
/// Usage:
/// ```dart
/// // Watch state
/// final state = ref.watch(accountDetailProvider(locationId));
///
/// // Call methods
/// ref.read(accountDetailProvider(locationId).notifier).loadMore(...);
/// ```
final accountDetailProvider = StateNotifierProvider.family<
    AccountDetailNotifier,
    AccountDetailState,
    String>(
  (ref, locationId) {
    return AccountDetailNotifier(
      getStockFlowUseCase: ref.read(getStockFlowUseCaseProvider),
      createErrorUseCase: ref.read(createErrorAdjustmentUseCaseProvider),
      createForeignCurrencyUseCase: ref.read(createForeignCurrencyTranslationUseCaseProvider),
    );
  },
);
