import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
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

      // Use Utf8Decoder with allowMalformed to handle partial multi-byte characters at chunk boundaries
      await for (final chunk
          in response.stream.transform(const Utf8Decoder(allowMalformed: true))) {
        buffer += chunk;

        // Normalize CRLF and CR to LF for consistent parsing
        buffer = buffer.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

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
              // JSON parse error - log and skip this line
              debugPrint('[AiChatService] JSON parse error: $e');
              debugPrint(
                '[AiChatService] Line: ${jsonStr.substring(0, min(100, jsonStr.length))}...',
              );
              continue;
            }
          }
        }
      }

      // Process any remaining data in buffer
      final trimmedBuffer = buffer.trim();
      if (trimmedBuffer.startsWith('data: ')) {
        final jsonStr = trimmedBuffer.substring(6).trim();
        if (jsonStr.isNotEmpty) {
          try {
            final data = jsonDecode(jsonStr) as Map<String, dynamic>;
            yield AiEvent.fromJson(data);
          } catch (e) {
            // Log parse errors for trailing data to help debugging
            debugPrint('[AiChatService] Final buffer parse error: $e');
            debugPrint(
              '[AiChatService] Buffer: ${jsonStr.substring(0, min(100, jsonStr.length))}...',
            );
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
