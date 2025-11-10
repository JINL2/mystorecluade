import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/ai_chat_local_datasource.dart';
import '../../data/datasources/ai_chat_remote_datasource.dart';
import '../../data/repositories/ai_chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/load_chat_history.dart';
import '../../domain/usecases/save_message_to_history.dart';
import '../../domain/usecases/send_chat_message.dart';
import 'states/ai_chat_state.dart';

// Datasource Providers
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final _aiChatRemoteDatasourceProvider = Provider<AiChatRemoteDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return AiChatRemoteDatasource(client);
});

final _aiChatLocalDatasourceProvider = Provider<AiChatLocalDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return AiChatLocalDatasource(client);
});

// Repository Provider
final _aiChatRepositoryProvider = Provider<AiChatRepositoryImpl>((ref) {
  final remoteDatasource = ref.watch(_aiChatRemoteDatasourceProvider);
  final localDatasource = ref.watch(_aiChatLocalDatasourceProvider);
  return AiChatRepositoryImpl(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
  );
});

// UseCase Providers
final _sendChatMessageUseCaseProvider = Provider<SendChatMessage>((ref) {
  final repository = ref.watch(_aiChatRepositoryProvider);
  return SendChatMessage(repository);
});

final _saveMessageToHistoryUseCaseProvider =
    Provider<SaveMessageToHistory>((ref) {
  final repository = ref.watch(_aiChatRepositoryProvider);
  return SaveMessageToHistory(repository);
});

final _loadChatHistoryUseCaseProvider = Provider<LoadChatHistory>((ref) {
  final repository = ref.watch(_aiChatRepositoryProvider);
  return LoadChatHistory(repository);
});

// State Notifier
class AiChatNotifier extends StateNotifier<AiChatState> {
  final SendChatMessage _sendChatMessageUseCase;
  final SaveMessageToHistory _saveMessageToHistoryUseCase;
  final LoadChatHistory _loadChatHistoryUseCase;
  final String _companyId;
  final String _storeId;
  bool _isChatOpen = false; // Track if chat is currently open

  AiChatNotifier({
    required SendChatMessage sendChatMessageUseCase,
    required SaveMessageToHistory saveMessageToHistoryUseCase,
    required LoadChatHistory loadChatHistoryUseCase,
    required String companyId,
    required String storeId,
    required String sessionId,
  })  : _sendChatMessageUseCase = sendChatMessageUseCase,
        _saveMessageToHistoryUseCase = saveMessageToHistoryUseCase,
        _loadChatHistoryUseCase = loadChatHistoryUseCase,
        _companyId = companyId,
        _storeId = storeId,
        super(AiChatState(
          sessionId: sessionId,
        )) {
    // Load chat history when notifier is created
    _loadHistory();
  }

  void setChatOpen(bool isOpen) {
    _isChatOpen = isOpen;
    if (isOpen) {
      // Mark as read when chat is opened
      state = state.copyWith(hasUnreadResponse: false);
    }
  }

  Future<void> _loadHistory() async {
    try {
      final messages = await _loadChatHistoryUseCase(
        sessionId: state.sessionId,
      );
      state = state.copyWith(
        messages: messages,
        isLoadingHistory: false,
      );
    } catch (e) {
      // Silently fail - start with empty messages if history load fails
      state = state.copyWith(isLoadingHistory: false);
    }
  }

  Future<void> sendMessage(
    String question, {
    String? featureName,
    Map<String, dynamic>? pageContext,
    String? featureId,
  }) async {
    if (question.trim().isEmpty) return;

    String enrichedQuestion = question;
    if (featureName != null) {
      enrichedQuestion = '[$featureName] $question';
      if (pageContext != null && pageContext.isNotEmpty) {
        enrichedQuestion += '\nPage Context: ${pageContext.toString()}';
      }
    }

    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: question,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      await _saveMessageToHistoryUseCase(
        sessionId: state.sessionId,
        message: userMessage,
        companyId: _companyId,
        storeId: _storeId,
        featureId: featureId,
      );

      // Generate current date and timezone
      final now = DateTime.now();
      final currentDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final timezone = 'Asia/Seoul';  // Korean timezone

      final response = await _sendChatMessageUseCase(
        question: enrichedQuestion,
        companyId: _companyId,
        storeId: _storeId,
        sessionId: state.sessionId,
        currentDate: currentDate,
        timezone: timezone,
        featureId: featureId,
      );

      final aiMessage = ChatMessage(
        id: const Uuid().v4(),
        content: response.answer,
        isUser: false,
        timestamp: DateTime.now(),
        iterations: response.iterations,
      );

      await _saveMessageToHistoryUseCase(
        sessionId: state.sessionId,
        message: aiMessage,
        companyId: _companyId,
        storeId: _storeId,
        featureId: featureId,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
        // If chat is closed, mark as unread
        hasUnreadResponse: !_isChatOpen,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Main Provider - Family to accept sessionId parameter
final aiChatProvider = StateNotifierProvider.autoDispose
    .family<AiChatNotifier, AiChatState, String>((ref, sessionId) {
  // Keep provider alive even when Bottom Sheet is closed
  // This ensures ongoing API calls and DB saves complete
  ref.keepAlive();

  final appState = ref.watch(appStateProvider);
  final sendChatMessageUseCase = ref.watch(_sendChatMessageUseCaseProvider);
  final saveMessageToHistoryUseCase =
      ref.watch(_saveMessageToHistoryUseCaseProvider);
  final loadChatHistoryUseCase = ref.watch(_loadChatHistoryUseCaseProvider);

  return AiChatNotifier(
    sendChatMessageUseCase: sendChatMessageUseCase,
    saveMessageToHistoryUseCase: saveMessageToHistoryUseCase,
    loadChatHistoryUseCase: loadChatHistoryUseCase,
    companyId: appState.companyChoosen,
    storeId: appState.storeChoosen,
    sessionId: sessionId,
  );
});
