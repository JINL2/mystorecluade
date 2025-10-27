import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/join_result.dart';

part 'join_state.freezed.dart';

/// Join State - UI state for join operations
///
/// Handles company/store join operations via invite code
@freezed
class JoinState with _$JoinState {
  const factory JoinState.initial() = _Initial;

  const factory JoinState.loading() = _Loading;

  const factory JoinState.success(JoinResult result) = _Success;

  const factory JoinState.error(
    String message,
    String errorCode,
  ) = _Error;
}
