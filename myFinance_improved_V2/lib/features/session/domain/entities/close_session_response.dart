import 'package:freezed_annotation/freezed_annotation.dart';

part 'close_session_response.freezed.dart';

/// Response from closing a session via RPC
@freezed
class CloseSessionResponse with _$CloseSessionResponse {
  const factory CloseSessionResponse({
    required String sessionId,
    required String sessionName,
    required String sessionType,
    required String closedAt,
  }) = _CloseSessionResponse;
}
