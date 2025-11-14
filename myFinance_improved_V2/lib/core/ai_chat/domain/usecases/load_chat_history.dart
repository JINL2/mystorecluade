import '../entities/chat_message.dart';
import '../repositories/ai_chat_repository.dart';

class LoadChatHistory {
  final AiChatRepository repository;

  LoadChatHistory(this.repository);

  Future<List<ChatMessage>> call({
    required String sessionId,
  }) async {
    return await repository.loadChatHistory(
      sessionId: sessionId,
    );
  }
}
