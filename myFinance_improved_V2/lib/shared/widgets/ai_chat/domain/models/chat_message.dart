/// Chat message model for AI Chat
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<Map<String, dynamic>>? resultData;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.resultData,
  });

  /// Check if this message has SQL result data
  bool get hasResultData => resultData != null && resultData!.isNotEmpty;

  /// Get the number of result rows
  int get resultRowCount => resultData?.length ?? 0;

  @override
  String toString() =>
      'ChatMessage(id: $id, isUser: $isUser, content: ${content.substring(0, content.length.clamp(0, 50))}...)';
}
