import 'package:equatable/equatable.dart';

/// Trade item entity - represents an item in trade documents (PI, PO, CI)
/// This is a shared entity that can be used across different trade document types.
class TradeItem extends Equatable {
  final String? id; // null for new items
  final String? productId;
  final String description;
  final String? sku;
  final String? barcode;
  final String? hsCode;
  final String? countryOfOrigin;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double? discountPercent;
  final double? discountAmount;
  final String? packingInfo;
  final int sortOrder;

  // Product metadata (for display purposes)
  final String? productName;
  final String? productImage;
  final int? stockQuantity;

  const TradeItem({
    this.id,
    this.productId,
    required this.description,
    this.sku,
    this.barcode,
    this.hsCode,
    this.countryOfOrigin,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.discountPercent,
    this.discountAmount,
    this.packingInfo,
    this.sortOrder = 0,
    this.productName,
    this.productImage,
    this.stockQuantity,
  });

  /// Calculate total amount after discounts
  double get totalAmount {
    double amount = quantity * unitPrice;
    if (discountPercent != null && discountPercent! > 0) {
      amount -= amount * (discountPercent! / 100);
    }
    if (discountAmount != null && discountAmount! > 0) {
      amount -= discountAmount!;
    }
    return amount < 0 ? 0 : amount;
  }

  /// Display name - prefers description, falls back to productName
  String get displayName => description.isNotEmpty ? description : (productName ?? 'Unnamed Item');

  /// Create a copy with updated fields
  TradeItem copyWith({
    String? id,
    String? productId,
    String? description,
    String? sku,
    String? barcode,
    String? hsCode,
    String? countryOfOrigin,
    double? quantity,
    String? unit,
    double? unitPrice,
    double? discountPercent,
    double? discountAmount,
    String? packingInfo,
    int? sortOrder,
    String? productName,
    String? productImage,
    int? stockQuantity,
  }) {
    return TradeItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      hsCode: hsCode ?? this.hsCode,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      packingInfo: packingInfo ?? this.packingInfo,
      sortOrder: sortOrder ?? this.sortOrder,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  /// Convert to database-ready map for PI items
  Map<String, dynamic> toPIItemMap() {
    return {
      if (id != null) 'item_id': id,
      if (productId != null) 'product_id': productId,
      'description': description,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (hsCode != null) 'hs_code': hsCode,
      if (countryOfOrigin != null) 'country_of_origin': countryOfOrigin,
      'quantity': quantity,
      'unit': unit,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (packingInfo != null) 'packing_info': packingInfo,
      'sort_order': sortOrder,
    };
  }

  /// Convert to database-ready map for PO items
  Map<String, dynamic> toPOItemMap({String? piItemId}) {
    return {
      if (id != null) 'item_id': id,
      if (piItemId != null) 'pi_item_id': piItemId,
      if (productId != null) 'product_id': productId,
      'description': description,
      if (sku != null) 'sku': sku,
      if (hsCode != null) 'hs_code': hsCode,
      'quantity_ordered': quantity,
      'quantity_shipped': 0,
      'unit': unit,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'sort_order': sortOrder,
    };
  }

  /// Convert to database-ready map for CI items
  Map<String, dynamic> toCIItemMap({String? shipmentItemId}) {
    return {
      if (id != null) 'item_id': id,
      if (shipmentItemId != null) 'shipment_item_id': shipmentItemId,
      if (productId != null) 'product_id': productId,
      'description': description,
      if (sku != null) 'sku': sku,
      if (hsCode != null) 'hs_code': hsCode,
      if (countryOfOrigin != null) 'country_of_origin': countryOfOrigin,
      'quantity': quantity,
      'unit': unit,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'sort_order': sortOrder,
    };
  }

  /// Create from database row (PI item format)
  factory TradeItem.fromPIItemMap(Map<String, dynamic> map) {
    return TradeItem(
      id: map['item_id'] as String?,
      productId: map['product_id'] as String?,
      description: map['description'] as String? ?? '',
      sku: map['sku'] as String?,
      barcode: map['barcode'] as String?,
      hsCode: map['hs_code'] as String?,
      countryOfOrigin: map['country_of_origin'] as String?,
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0,
      unit: map['unit'] as String? ?? 'PCS',
      unitPrice: (map['unit_price'] as num?)?.toDouble() ?? 0,
      discountPercent: (map['discount_percent'] as num?)?.toDouble(),
      discountAmount: (map['discount_amount'] as num?)?.toDouble(),
      packingInfo: map['packing_info'] as String?,
      sortOrder: map['sort_order'] as int? ?? 0,
      productName: map['product_name'] as String?,
      productImage: map['product_image'] as String?,
    );
  }

  /// Create from SalesProduct (inventory)
  factory TradeItem.fromSalesProduct({
    required String productId,
    required String productName,
    required String sku,
    String? barcode,
    String? imageUrl,
    double? sellingPrice,
    int? stockQuantity,
    String? unit,
  }) {
    return TradeItem(
      productId: productId,
      description: productName,
      sku: sku,
      barcode: barcode,
      quantity: 1,
      unit: unit ?? 'PCS',
      unitPrice: sellingPrice ?? 0,
      productName: productName,
      productImage: imageUrl,
      stockQuantity: stockQuantity,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        description,
        sku,
        barcode,
        hsCode,
        countryOfOrigin,
        quantity,
        unit,
        unitPrice,
        discountPercent,
        discountAmount,
        packingInfo,
        sortOrder,
      ];
}
