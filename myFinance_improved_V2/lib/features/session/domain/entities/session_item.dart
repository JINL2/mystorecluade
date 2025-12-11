/// Item added to an inventory session
class SessionItem {
  final String itemId;
  final String sessionId;
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final int quantity;
  final double? unitPrice;
  final DateTime addedAt;
  final String? notes;

  const SessionItem({
    required this.itemId,
    required this.sessionId,
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.imageUrl,
    required this.quantity,
    this.unitPrice,
    required this.addedAt,
    this.notes,
  });

  double get totalPrice => (unitPrice ?? 0) * quantity;

  SessionItem copyWith({
    String? itemId,
    String? sessionId,
    String? productId,
    String? productName,
    String? sku,
    String? barcode,
    String? imageUrl,
    int? quantity,
    double? unitPrice,
    DateTime? addedAt,
    String? notes,
  }) {
    return SessionItem(
      itemId: itemId ?? this.itemId,
      sessionId: sessionId ?? this.sessionId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      addedAt: addedAt ?? this.addedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'SessionItem(itemId: $itemId, productName: $productName, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionItem && other.itemId == itemId;
  }

  @override
  int get hashCode => itemId.hashCode;
}
