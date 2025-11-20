import '../entities/chat_message.dart';
import '../entities/chat_response.dart';

abstract class AiChatRepository {
  Future<ChatResponse> sendMessage({
    required String question,
    required String companyId,
    required String storeId,
    required String sessionId,
    required String currentDate,
    required String timezone,
    String? featureId,
    Map<String, dynamic>? contextInfo,
  });

  Future<void> saveMessageToHistory({
    required String sessionId,
    required ChatMessage message,
    required String companyId,
    required String storeId,
    String? featureId,
  });

  Future<List<ChatMessage>> loadChatHistory({
    required String sessionId,
  });
}
