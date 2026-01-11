/// Attribute types available for selection
/// Note: UI properties (icon) are in presentation/utils/attribute_type_ui.dart
enum AttributeType {
  text('Text'),
  number('Number'),
  date('Date'),
  barcode('Barcode');

  final String label;

  const AttributeType(this.label);
}

/// Option item for attribute
class AttributeOptionItem {
  final String value;
  final int sortOrder;

  const AttributeOptionItem({
    required this.value,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() => {
        'option_value': value,
        'sort_order': sortOrder,
      };
}

/// Result from add attribute dialog
class AddAttributeResult {
  final String name;
  final List<AttributeOptionItem> options;

  const AddAttributeResult({
    required this.name,
    this.options = const [],
  });
}
