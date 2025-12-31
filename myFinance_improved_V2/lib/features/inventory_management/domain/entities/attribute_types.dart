import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Attribute types available for selection
enum AttributeType {
  text('Text', LucideIcons.type),
  number('Number', LucideIcons.hash),
  date('Date', LucideIcons.calendar),
  barcode('Barcode', LucideIcons.scanLine);

  final String label;
  final IconData icon;

  const AttributeType(this.label, this.icon);
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
