import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_session_response.freezed.dart';

/// Response from joining a session via RPC
@freezed
class JoinSessionResponse with _$JoinSessionResponse {
  const factory JoinSessionResponse({
    required String memberId,
    required String sessionId,
    required String userId,
    required String joinedAt,
    required String createdBy,
    required String createdByName,
  }) = _JoinSessionResponse;
}
