/// Model for attribute item used in AttributesEditPage
/// This is a presentation-layer model for UI state management
class AttributeItem {
  final String id;
  final String name;
  final bool isBuiltIn;
  final int optionCount;

  AttributeItem({
    required this.id,
    required this.name,
    this.isBuiltIn = false,
    this.optionCount = 0,
  });

  AttributeItem copyWith({
    String? id,
    String? name,
    bool? isBuiltIn,
    int? optionCount,
  }) {
    return AttributeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      optionCount: optionCount ?? this.optionCount,
    );
  }
}
