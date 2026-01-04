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

/// Result from add attribute dialog
class AddAttributeResult {
  final String name;
  final AttributeType type;

  const AddAttributeResult({
    required this.name,
    required this.type,
  });
}
