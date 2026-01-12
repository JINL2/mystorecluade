import '../../domain/entities/session_review_item.dart';

/// Model for session submit item (used in submit operations)
/// This is the Data layer representation - Domain uses SessionSubmitItem entity
/// v3 supports variantId for variant products
class SessionSubmitItemModel {
  final String productId;
  /// Variant ID for variant products, null for simple products
  final String? variantId;
  final int quantity;
  final int quantityRejected;

  const SessionSubmitItemModel({
    required this.productId,
    this.variantId,
    required this.quantity,
    this.quantityRejected = 0,
  });

  /// Convert to JSON for RPC call (v3 format)
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'variant_id': variantId,
      'quantity': quantity,
      'quantity_rejected': quantityRejected,
    };
  }

  /// Create model from domain entity
  factory SessionSubmitItemModel.fromEntity(SessionSubmitItem entity) {
    return SessionSubmitItemModel(
      productId: entity.productId,
      variantId: entity.variantId,
      quantity: entity.quantity,
      quantityRejected: entity.quantityRejected,
    );
  }
}
