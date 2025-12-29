import '../../domain/entities/session_review_item.dart';

/// Model for session submit item (used in submit operations)
/// This is the Data layer representation - Domain uses SessionSubmitItem entity
class SessionSubmitItemModel {
  final String productId;
  final int quantity;
  final int quantityRejected;

  const SessionSubmitItemModel({
    required this.productId,
    required this.quantity,
    this.quantityRejected = 0,
  });

  /// Convert to JSON for RPC call
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'quantity_rejected': quantityRejected,
    };
  }

  /// Create model from domain entity
  factory SessionSubmitItemModel.fromEntity(SessionSubmitItem entity) {
    return SessionSubmitItemModel(
      productId: entity.productId,
      quantity: entity.quantity,
      quantityRejected: entity.quantityRejected,
    );
  }
}
