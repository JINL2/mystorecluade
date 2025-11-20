import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/chat_message.dart';

part 'ai_chat_state.freezed.dart';

@freezed
class AiChatState with _$AiChatState {
  const factory AiChatState({
    @Default([]) List<ChatMessage> messages,
    @Default(false) bool isLoading,
    @Default(true) bool isLoadingHistory,
    @Default(false) bool hasUnreadResponse,
    String? error,
    required String sessionId,
  }) = _AiChatState;
}
