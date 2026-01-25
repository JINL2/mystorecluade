import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../core/homepage_logger.dart';
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

    homepageLogger.d('joinByCode called - userId: $userId, code: $code');

    state = const JoinState.loading();
    homepageLogger.d('State set to JoinLoading');

    try {
      final result = await joinByCode(
        JoinByCodeParams(
          userId: userId,
          code: code,
        ),
      );

      homepageLogger.d('Result received from use case');
      result.fold(
        (failure) {
          homepageLogger.e('Error: ${failure.message}');
          state = JoinState.error(failure.message, failure.code);
        },
        (joinResult) {
          final joinType = joinResult.isStoreJoin ? 'store' : 'company';
          homepageLogger.i('Success: Joined $joinType - ${joinResult.entityName}');
          state = JoinState.success(joinResult);
        },
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'JoinNotifier.joinByCode failed',
        extra: {'userId': userId, 'code': code},
      );
      homepageLogger.e('Exception caught: $e');
      state = JoinState.error(e.toString(), 'EXCEPTION');
    }
  }

  /// Reset state to initial
  void reset() {
    state = const JoinState.initial();
  }
}
