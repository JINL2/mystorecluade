/// Cart item entity - represents a product in the shopping cart
/// Supports variant products from get_inventory_page_v6
class CartItem {
  final String id;
  final String productId;
  final String? variantId;
  final String sku;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final int available;
  final int customerOrdered;

  const CartItem({
    required this.id,
    required this.productId,
    this.variantId,
    required this.sku,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    required this.available,
    this.customerOrdered = 0,
  });

  /// Unique identifier for cart comparison
  /// Uses variantId if exists, otherwise productId
  String get uniqueId => variantId ?? productId;

  double get subtotal => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? variantId,
    String? sku,
    String? name,
    String? image,
    double? price,
    int? quantity,
    int? available,
    int? customerOrdered,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      available: available ?? this.available,
      customerOrdered: customerOrdered ?? this.customerOrdered,
    );
  }
}
