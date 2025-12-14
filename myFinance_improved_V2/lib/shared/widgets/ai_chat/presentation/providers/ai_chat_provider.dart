import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../data/services/ai_chat_service.dart';
import '../../domain/models/chat_message.dart';
import 'ai_chat_state.dart';

// Service Provider
final _aiChatServiceProvider = Provider<AiChatService>((ref) {
  return AiChatService();
});

/// AI Chat State Notifier
class AiChatNotifier extends StateNotifier<AiChatState> {
  final AiChatService _service;
  final String _companyId;
  final String _userId;
  final String _storeId;
  bool _isChatOpen = false;

  AiChatNotifier({
    required AiChatService service,
    required String companyId,
    required String userId,
    required String storeId,
  })  : _service = service,
        _companyId = companyId,
        _userId = userId,
        _storeId = storeId,
        super(const AiChatState());

  /// Set whether the chat UI is currently open
  void setChatOpen(bool isOpen) {
    _isChatOpen = isOpen;
    if (isOpen) {
      // Mark as read when chat is opened
      state = state.copyWith(hasUnreadResponse: false);
    }
  }

  /// Send a message and process the SSE stream response
  Future<void> sendMessage(
    String question, {
    String? featureName,
    Map<String, dynamic>? pageContext,
    String? featureId,
  }) async {
    if (question.trim().isEmpty) return;

    // Build page context as separate field (not mixed into question)
    final fullPageContext = <String, dynamic>{};
    if (featureName != null) {
      fullPageContext['page_name'] = featureName;
    }
    if (pageContext != null) {
      fullPageContext.addAll(pageContext);
    }

    // Create user message
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: question,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Update state with user message and start loading
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      streamingText: '',
      currentResultData: null,
      error: null,
    );

    try {
      // Process SSE stream - send pure question + separate page context
      await for (final event in _service.askQuestion(
        question: question,
        companyId: _companyId,
        userId: _userId,
        sessionId: state.sessionId,
        storeId: _storeId,
        pageContext: fullPageContext.isNotEmpty ? fullPageContext : null,
      )) {
        switch (event.type) {
          case 'result':
            // SQL query results received
            state = state.copyWith(
              currentResultData: event.resultData,
            );
            break;

          case 'stream':
            // Streaming text chunk received
            state = state.copyWith(
              streamingText: state.streamingText + (event.streamContent ?? ''),
            );
            break;

          case 'done':
            // Stream completed - create AI message
            final aiMessage = ChatMessage(
              id: const Uuid().v4(),
              content: state.streamingText,
              isUser: false,
              timestamp: DateTime.now(),
              resultData: state.currentResultData,
            );

            state = state.copyWith(
              messages: [...state.messages, aiMessage],
              sessionId: event.sessionId ?? state.sessionId,
              isLoading: false,
              streamingText: '',
              currentResultData: null,
              hasUnreadResponse: !_isChatOpen,
            );
            break;

          case 'error':
            // Error occurred
            state = state.copyWith(
              error: event.errorMessage ?? 'Unknown error occurred',
              isLoading: false,
              streamingText: '',
            );
            break;
        }
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        streamingText: '',
      );
    }
  }

  /// Clear the current error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear all messages and start a new conversation
  void clearMessages() {
    state = const AiChatState();
  }
}

/// AI Chat Provider - keyed by feature name for separate chat instances
final aiChatProvider = StateNotifierProvider.autoDispose
    .family<AiChatNotifier, AiChatState, String>((ref, featureKey) {
  // Keep provider alive even when Bottom Sheet is closed
  ref.keepAlive();

  final appState = ref.watch(appStateProvider);
  final service = ref.watch(_aiChatServiceProvider);

  return AiChatNotifier(
    service: service,
    companyId: appState.companyChoosen,
    userId: appState.userId,
    storeId: appState.storeChoosen,
  );
});
