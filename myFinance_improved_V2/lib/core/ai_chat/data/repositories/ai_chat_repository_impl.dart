import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_response.dart';
import '../../domain/repositories/ai_chat_repository.dart';
import '../datasources/ai_chat_local_datasource.dart';
import '../datasources/ai_chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDatasource remoteDatasource;
  final AiChatLocalDatasource localDatasource;

  AiChatRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<ChatResponse> sendMessage({
    required String question,
    required String companyId,
    required String storeId,
    required String sessionId,
    required String currentDate,
    required String timezone,
    String? featureId,
    Map<String, dynamic>? contextInfo,
  }) async {
    return await remoteDatasource.sendMessage(
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

  @override
  Future<void> saveMessageToHistory({
    required String sessionId,
    required ChatMessage message,
    required String companyId,
    required String storeId,
    String? featureId,
  }) async {
    final model = ChatMessageModel.fromEntity(message);
    await localDatasource.saveMessage(
      sessionId: sessionId,
      message: model,
      companyId: companyId,
      storeId: storeId,
      featureId: featureId,
    );
  }

  @override
  Future<List<ChatMessage>> loadChatHistory({
    required String sessionId,
  }) async {
    return await localDatasource.loadHistory(
      sessionId: sessionId,
    );
  }
}
