import '../../domain/entities/chat_response.dart';

class ChatResponseModel extends ChatResponse {
  ChatResponseModel({
    required super.answer,
    required super.iterations,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      answer: json['answer'] as String,
      iterations: json['iterations'] as int,
    );
  }
}
