import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_session.freezed.dart';

/// Inventory session entity for counting/receiving operations
@freezed
class InventorySession with _$InventorySession {
  const InventorySession._();

  const factory InventorySession({
    required String sessionId,
    required String sessionName,
    required String sessionType, // 'counting' or 'receiving'
    required String storeId,
    required String storeName,
    required String status, // 'active', 'completed', 'cancelled'
    required DateTime createdAt,
    DateTime? completedAt,
    required String createdBy,
    @Default(0) int itemCount,
    String? notes,
  }) = _InventorySession;

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isCounting => sessionType == 'counting';
  bool get isReceiving => sessionType == 'receiving';
}

/// Response from creating a session
@freezed
class CreateSessionResponse with _$CreateSessionResponse {
  const factory CreateSessionResponse({
    required String sessionId,
    String? sessionName,
    required String sessionType,
    String? shipmentId,
    String? shipmentNumber,
    required bool isActive,
    required bool isFinal,
    required String createdBy,
    required String createdAt,
  }) = _CreateSessionResponse;
}
