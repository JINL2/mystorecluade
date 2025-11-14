import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_response_model.dart';

class AiChatRemoteDatasource {
  final SupabaseClient _client;

  AiChatRemoteDatasource(this._client);

  Future<ChatResponseModel> sendMessage({
    required String question,
    required String companyId,
    required String storeId,
    required String sessionId,
    required String currentDate,
    required String timezone,
    String? featureId,
    Map<String, dynamic>? contextInfo,
  }) async {
    final body = <String, dynamic>{
      'question': question,
      'company_id': companyId,
      'store_id': storeId,
      'session_id': sessionId,
      'current_date': currentDate,
      'timezone': timezone,
    };

    if (featureId != null) {
      body['feature_id'] = featureId;
    }

    if (contextInfo != null && contextInfo.isNotEmpty) {
      body['context_info'] = contextInfo;
    }

    final response = await _client.functions.invoke(
      'ai-chat',
      body: body,
    );

    if (response.data == null) {
      throw Exception('No response from AI');
    }

    return ChatResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
