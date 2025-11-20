import '../entities/chat_message.dart';
import '../repositories/ai_chat_repository.dart';

class SaveMessageToHistory {
  final AiChatRepository repository;

  SaveMessageToHistory(this.repository);

  Future<void> call({
    required String sessionId,
    required ChatMessage message,
    required String companyId,
    required String storeId,
    String? featureId,
  }) async {
    return await repository.saveMessageToHistory(
      sessionId: sessionId,
      message: message,
      companyId: companyId,
      storeId: storeId,
      featureId: featureId,
    );
  }
}
