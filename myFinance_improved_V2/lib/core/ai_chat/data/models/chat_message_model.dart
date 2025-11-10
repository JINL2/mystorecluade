import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.content,
    required super.isUser,
    required super.timestamp,
    super.iterations,
  });

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      content: entity.content,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
      iterations: entity.iterations,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: const Uuid().v4(), // Generate new ID for display
      content: json['content'] as String,
      isUser: json['role'] == 'user',
      timestamp: DateTime.parse(json['timestamp'] as String),
      iterations: json['iterations'] as int?,
    );
  }

  Map<String, dynamic> toJson(String companyId, String storeId, [String? featureId]) {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'company_id': companyId,
      'store_id': storeId,
      if (featureId != null) 'feature_id': featureId,
      if (iterations != null) 'iterations': iterations,
    };
  }
}
