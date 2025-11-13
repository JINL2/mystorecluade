import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/join_by_code.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/states/join_state.dart';

/// StateNotifier for managing join operations
///
/// Handles the state flow for joining companies/stores by code
/// States: Initial → Loading → Success/Error
class JoinNotifier extends StateNotifier<JoinState> {
  JoinNotifier(this._joinByCode) : super(const JoinState.initial());

  final JoinByCode _joinByCode;

  /// Join a company or store by code
  ///
  /// Updates state through: Loading → Success/Error
  /// The use case handles code validation
  Future<void> joinByCode({
    required String userId,
    required String code,
  }) async {
    state = const JoinState.loading();

    final result = await _joinByCode(JoinByCodeParams(
      userId: userId,
      code: code,
    ),);

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
