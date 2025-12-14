import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../domain/models/ai_event.dart';

/// Service for AI Chat SSE streaming
class AiChatService {
  AiChatService();

  /// Get the base URL for Supabase functions
  String get _baseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Get the anon key for authorization
  String get _anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Ask a question and receive SSE streaming response
  Stream<AiEvent> askQuestion({
    required String question,
    required String companyId,
    required String userId,
    String? sessionId,
    String? storeId,
    Map<String, dynamic>? pageContext,
  }) async* {
    final request = http.Request(
      'POST',
      Uri.parse('$_baseUrl/functions/v1/ai-respond-user'),
    );

    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_anonKey',
    });

    final body = <String, dynamic>{
      'question': question,
      'company_id': companyId,
      'user_id': userId,
      'session_id': sessionId,
      'store_id': storeId,
    };

    // Add page_context as separate field (not mixed into question)
    if (pageContext != null && pageContext.isNotEmpty) {
      body['page_context'] = pageContext;
    }

    request.body = jsonEncode(body);

    final httpClient = http.Client();

    try {
      final response = await httpClient.send(request);

      if (response.statusCode != 200) {
        yield AiEvent(
          type: 'error',
          raw: {
            'success': false,
            'message': 'HTTP Error: ${response.statusCode}',
          },
        );
        return;
      }

      String buffer = '';

      await for (final chunk in response.stream.transform(utf8.decoder)) {
        buffer += chunk;

        // Process complete SSE messages
        while (buffer.contains('\n')) {
          final newlineIndex = buffer.indexOf('\n');
          final line = buffer.substring(0, newlineIndex).trim();
          buffer = buffer.substring(newlineIndex + 1);

          if (line.startsWith('data: ')) {
            final jsonStr = line.substring(6).trim();
            if (jsonStr.isEmpty) continue;

            try {
              final data = jsonDecode(jsonStr) as Map<String, dynamic>;
              yield AiEvent.fromJson(data);
            } catch (e) {
              // JSON parse error - skip this line
              continue;
            }
          }
        }
      }

      // Process any remaining data in buffer
      if (buffer.trim().startsWith('data: ')) {
        final jsonStr = buffer.trim().substring(6).trim();
        if (jsonStr.isNotEmpty) {
          try {
            final data = jsonDecode(jsonStr) as Map<String, dynamic>;
            yield AiEvent.fromJson(data);
          } catch (e) {
            // Ignore parse errors for trailing data
          }
        }
      }
    } catch (e) {
      yield AiEvent(
        type: 'error',
        raw: {
          'success': false,
          'message': 'Network error: $e',
        },
      );
    } finally {
      httpClient.close();
    }
  }
}
