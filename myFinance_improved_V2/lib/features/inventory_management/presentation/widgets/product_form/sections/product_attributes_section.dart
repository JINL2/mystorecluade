import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/widgets/index.dart';
import '../../../../domain/entities/inventory_metadata.dart';
import '../../../pages/attribute_value_selector_page.dart';
import '../../../pages/attributes_edit_page.dart';
import '../form_section_header.dart';
import '../rows/form_list_row.dart';

/// Shared Attributes section for Add/Edit Product pages
class ProductAttributesSection extends StatelessWidget {
  final InventoryMetadata? metadata;
  final Category? selectedCategory;
  final Brand? selectedBrand;
  final ValueChanged<Category?> onCategorySelected;
  final ValueChanged<Brand?> onBrandSelected;
  final Future<Category?> Function(String name)? onCategoryQuickAdd;
  final Future<Brand?> Function(String name)? onBrandQuickAdd;

  const ProductAttributesSection({
    super.key,
    required this.metadata,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.onCategorySelected,
    required this.onBrandSelected,
    this.onCategoryQuickAdd,
    this.onBrandQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          FormSectionHeader(
            title: 'Attributes',
            showHelpBadge: true,
            actionText: 'Edit',
            onActionTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const AttributesEditPage(),
                ),
              );
            },
            onHelpTap: () => _showAttributesInfoDialog(context),
          ),
          FormListRow(
            label: 'Category',
            value: selectedCategory?.name,
            placeholder: 'Enter a value',
            showChevron: true,
            onTap: metadata != null ? () => _showCategorySelector(context) : null,
          ),
          FormListRow(
            label: 'Brand',
            value: selectedBrand?.name,
            placeholder: 'Enter a value',
            showChevron: true,
            onTap: metadata != null ? () => _showBrandSelector(context) : null,
          ),
        ],
      ),
    );
  }

  void _showCategorySelector(BuildContext context) {
    if (metadata == null) return;

    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => AttributeValueSelectorPage<Category>(
          title: 'category',
          searchHint: 'Search or enter a category',
          values: metadata!.categories,
          selectedValue: selectedCategory,
          getName: (category) => category.name,
          getId: (category) => category.id,
          onSelect: onCategorySelected,
          onQuickAdd: onCategoryQuickAdd,
        ),
      ),
    );
  }

  void _showBrandSelector(BuildContext context) {
    if (metadata == null) return;

    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => AttributeValueSelectorPage<Brand>(
          title: 'brand',
          searchHint: 'Search or enter a brand',
          values: metadata!.brands,
          selectedValue: selectedBrand,
          getName: (brand) => brand.name,
          getId: (brand) => brand.id,
          onSelect: onBrandSelected,
          onQuickAdd: onBrandQuickAdd,
        ),
      ),
    );
  }

  void _showAttributesInfoDialog(BuildContext context) {
    TossInfoDialog.show(
      context: context,
      title: 'What are attributes?',
      bulletPoints: [
        'Attributes are custom fields you can add to each item.',
        'You can choose from: text, number, date, or barcode.',
        'Attributes help you organize, search, and filter your inventory more easily.',
      ],
    );
  }
}
