import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message_model.dart';

class AiChatLocalDatasource {
  final SupabaseClient _client;

  AiChatLocalDatasource(this._client);

  Future<void> saveMessage({
    required String sessionId,
    required ChatMessageModel message,
    required String companyId,
    required String storeId,
    String? featureId,
  }) async {
    await _client.from('ai_chat_history').insert({
      'session_id': sessionId,
      'message': message.toJson(companyId, storeId, featureId),
      'created_at': message.timestamp.toIso8601String(),
    });
  }

  Future<List<ChatMessageModel>> loadHistory({
    required String sessionId,
  }) async {
    final response = await _client
        .from('ai_chat_history')
        .select('message, created_at')
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);

    return (response as List).map((item) {
      final messageData = item['message'] as Map<String, dynamic>;
      return ChatMessageModel.fromJson(messageData);
    }).toList();
  }
}
