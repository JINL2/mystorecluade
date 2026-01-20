/// Model for attribute option used in AttributeDetailPage
/// This is a presentation-layer model for UI state management
class AttributeOptionItem {
  final String? id;
  final String value;
  final int sortOrder;
  final bool isNew;

  AttributeOptionItem({
    this.id,
    required this.value,
    required this.sortOrder,
    this.isNew = false,
  });

  AttributeOptionItem copyWith({
    String? id,
    String? value,
    int? sortOrder,
    bool? isNew,
  }) {
    return AttributeOptionItem(
      id: id ?? this.id,
      value: value ?? this.value,
      sortOrder: sortOrder ?? this.sortOrder,
      isNew: isNew ?? this.isNew,
    );
  }
}
