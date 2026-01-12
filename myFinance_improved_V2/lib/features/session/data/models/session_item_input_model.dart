/// Model for session item input (used in add/update operations)
/// This is the Data layer representation - Domain uses SessionItemInput entity
/// v2: variant_id is always included (null for non-variant products)
class SessionItemInputModel {
  final String productId;
  final int quantity;
  final int quantityRejected;
  /// Variant ID for variant products, null for non-variant products
  final String? variantId;

  const SessionItemInputModel({
    required this.productId,
    required this.quantity,
    this.quantityRejected = 0,
    this.variantId,
  });

  /// Convert to JSON for RPC call (v2 format)
  /// variant_id is always included (null for non-variant products)
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'variant_id': variantId,
      'quantity': quantity,
      'quantity_rejected': quantityRejected,
    };
  }
}
