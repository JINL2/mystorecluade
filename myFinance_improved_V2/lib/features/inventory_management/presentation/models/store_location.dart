/// Store location data class for Move Stock Dialog
/// This is a presentation-layer model for UI state management
class StoreLocation {
  final String id;
  final String name;
  final int stock;
  final bool isCurrentStore;

  StoreLocation({
    required this.id,
    required this.name,
    required this.stock,
    this.isCurrentStore = false,
  });

  /// Create a copy with updated stock
  StoreLocation copyWith({int? stock}) {
    return StoreLocation(
      id: id,
      name: name,
      stock: stock ?? this.stock,
      isCurrentStore: isCurrentStore,
    );
  }
}
