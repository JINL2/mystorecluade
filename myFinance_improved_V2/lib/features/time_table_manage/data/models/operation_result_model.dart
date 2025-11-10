import '../../domain/entities/operation_result.dart';

/// Operation Result Model (DTO + Mapper)
///
/// Data Transfer Object for OperationResult entity with JSON serialization.
class OperationResultModel {
  final bool success;
  final String? message;
  final String? errorCode;
  final Map<String, dynamic> metadata;

  const OperationResultModel({
    required this.success,
    this.message,
    this.errorCode,
    this.metadata = const {},
  });

  /// Create from JSON
  factory OperationResultModel.fromJson(Map<String, dynamic> json) {
    return OperationResultModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      errorCode: json['error_code'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (errorCode != null) 'error_code': errorCode,
      if (metadata.isNotEmpty) 'metadata': metadata,
    };
  }

  /// Map to Domain Entity
  OperationResult toEntity() {
    return OperationResult(
      success: success,
      message: message,
      errorCode: errorCode,
      metadata: metadata,
    );
  }

  /// Create from Domain Entity
  factory OperationResultModel.fromEntity(OperationResult entity) {
    return OperationResultModel(
      success: entity.success,
      message: entity.message,
      errorCode: entity.errorCode,
      metadata: entity.metadata,
    );
  }
}
