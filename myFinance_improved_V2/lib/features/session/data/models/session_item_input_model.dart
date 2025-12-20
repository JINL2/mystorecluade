/// Model for session item input (used in add/update operations)
/// This is the Data layer representation - Domain uses SessionItemInput entity
class SessionItemInputModel {
  final String productId;
  final int quantity;
  final int quantityRejected;

  const SessionItemInputModel({
    required this.productId,
    required this.quantity,
    this.quantityRejected = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'quantity_rejected': quantityRejected,
    };
  }
}
