/// SSE Event model for AI Chat streaming responses
class AiEvent {
  final String type;
  final Map<String, dynamic> raw;

  AiEvent({required this.type, required this.raw});

  factory AiEvent.fromJson(Map<String, dynamic> json) {
    return AiEvent(
      type: json['type'] as String? ?? 'unknown',
      raw: json,
    );
  }

  /// result event: SQL query results
  List<Map<String, dynamic>>? get resultData {
    if (type == 'result' && raw['success'] == true) {
      final data = raw['data'];
      if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      }
    }
    return null;
  }

  /// result event: row count
  int get rowCount => raw['row_count'] as int? ?? 0;

  /// result event: SQL log ID
  String? get sqlLogId => raw['sql_log_id'] as String?;

  /// stream event: text chunk
  String? get streamContent {
    if (type == 'stream') {
      return raw['content'] as String?;
    }
    return null;
  }

  /// done event: session ID
  String? get sessionId {
    if (type == 'done') {
      return raw['session_id'] as String?;
    }
    return null;
  }

  /// done event: chat history IDs
  List<int>? get chatHistoryIds {
    if (type == 'done') {
      final ids = raw['chat_history_ids'];
      if (ids is List) {
        return List<int>.from(ids);
      }
    }
    return null;
  }

  /// done event: execution time in milliseconds
  int? get executionTimeMs {
    if (type == 'done') {
      return raw['execution_time_ms'] as int?;
    }
    return null;
  }

  /// error event: error message
  String? get errorMessage {
    if (type == 'error') {
      return raw['message'] as String?;
    }
    return null;
  }

  /// Check if the event indicates success
  bool get isSuccess => raw['success'] as bool? ?? false;

  @override
  String toString() => 'AiEvent(type: $type, raw: $raw)';
}
