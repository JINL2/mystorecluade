import '../../../domain/entities/operation_result.dart';
import 'operation_result_dto.dart';

/// Extension to map OperationResultDto → Domain Entity
extension OperationResultDtoMapper on OperationResultDto {
  /// Convert DTO to Domain Entity
  OperationResult toEntity() {
    return OperationResult(
      success: success,
      message: message,
      errorCode: errorCode,
      metadata: metadata,
    );
  }
}
