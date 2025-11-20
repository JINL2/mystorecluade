import '../entities/chat_response.dart';
import '../repositories/ai_chat_repository.dart';

class SendChatMessage {
  final AiChatRepository repository;

  SendChatMessage(this.repository);

  Future<ChatResponse> call({
    required String question,
    required String companyId,
    required String storeId,
    required String sessionId,
    required String currentDate,
    required String timezone,
    String? featureId,
    Map<String, dynamic>? contextInfo,
  }) async {
    return await repository.sendMessage(
      question: question,
      companyId: companyId,
      storeId: storeId,
      sessionId: sessionId,
      currentDate: currentDate,
      timezone: timezone,
      featureId: featureId,
      contextInfo: contextInfo,
    );
  }
}
