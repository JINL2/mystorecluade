import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/chat_message.dart';

part 'ai_chat_state.freezed.dart';

@freezed
class AiChatState with _$AiChatState {
  const factory AiChatState({
    @Default([]) List<ChatMessage> messages,
    @Default(false) bool isLoading,
    @Default('') String streamingText,
    List<Map<String, dynamic>>? currentResultData,
    String? sessionId,
    @Default(false) bool hasUnreadResponse,
    String? error,
  }) = _AiChatState;
}
