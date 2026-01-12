/// Model for session item input (used in add/update operations)
/// This is the Data layer representation - Domain uses SessionItemInput entity
/// Supports v6 variants with variantId
class SessionItemInputModel {
  final String productId;
  final int quantity;
  final int quantityRejected;
  final String? variantId;

  const SessionItemInputModel({
    required this.productId,
    required this.quantity,
    this.quantityRejected = 0,
    this.variantId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'quantity_rejected': quantityRejected,
      if (variantId != null) 'variant_id': variantId,
    };
  }
}
