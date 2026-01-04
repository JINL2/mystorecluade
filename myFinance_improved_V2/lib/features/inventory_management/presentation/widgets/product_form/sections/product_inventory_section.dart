import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_spacing.dart';
import '../form_section_header.dart';
import '../rows/form_list_row.dart';
import '../rows/form_number_input_row.dart';

/// Shared Inventory section for Add/Edit Product pages
class ProductInventorySection extends StatelessWidget {
  final String? selectedLocationName;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final String unit;
  final VoidCallback onLocationTap;
  final VoidCallback onUnitTap;

  const ProductInventorySection({
    super.key,
    required this.selectedLocationName,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.unit,
    required this.onLocationTap,
    required this.onUnitTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          const FormSectionHeader(title: 'Inventory'),
          FormListRow(
            label: 'Location',
            value: selectedLocationName,
            placeholder: 'Select store location',
            showChevron: true,
            onTap: onLocationTap,
          ),
          FormNumberInputRow(
            label: 'On-hand quantity',
            controller: quantityController,
            focusNode: quantityFocusNode,
            placeholder: 'e.g. 50',
          ),
          FormListRow(
            label: 'Unit',
            value: unit,
            placeholder: 'piece',
            showChevron: true,
            isValueActive: true,
            onTap: onUnitTap,
          ),
        ],
      ),
    );
  }
}
