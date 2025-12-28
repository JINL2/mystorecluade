import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/usecases/join_by_code.dart';
import 'states/join_state.dart';
import 'usecase_providers.dart';

part 'join_notifier.g.dart';

/// Notifier for managing join operations
///
/// Migrated from StateNotifier to @riverpod Notifier pattern.
/// Handles the state flow for joining companies/stores by code.
/// States: Initial → Loading → Success/Error
@riverpod
class JoinNotifier extends _$JoinNotifier {
  @override
  JoinState build() => const JoinState.initial();

  /// Join a company or store by code
  ///
  /// Updates state through: Loading → Success/Error
  /// The use case handles code validation
  Future<void> joinByCode({
    required String userId,
    required String code,
  }) async {
    final joinByCode = ref.read(joinByCodeUseCaseProvider);

    state = const JoinState.loading();

    final result = await joinByCode(
      JoinByCodeParams(
        userId: userId,
        code: code,
      ),
    );

    result.fold(
      (failure) {
        state = JoinState.error(failure.message, failure.code);
      },
      (joinResult) {
        state = JoinState.success(joinResult);
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const JoinState.initial();
  }
}
