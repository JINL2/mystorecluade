import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Inventory section for quantity, weight, and unit selection
class InventorySection extends StatelessWidget {
  final TextEditingController onHandController;
  final TextEditingController weightController;
  final String? selectedUnit;
  final VoidCallback onUnitTap;
  final ValueChanged<String>? onChanged;

  const InventorySection({
    super.key,
    required this.onHandController,
    required this.weightController,
    this.selectedUnit,
    required this.onUnitTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 16),
          _buildOnHandField(),
          const SizedBox(height: 16),
          _buildWeightField(),
          const SizedBox(height: 16),
          const Divider(height: 1, color: TossColors.gray200),
          _buildUnitTile(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Icon(Icons.inventory_2_outlined, color: TossColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Inventory',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOnHandField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'On-hand quantity',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: onHandController,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: TossColors.gray300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight (g)',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: TossColors.gray300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Unit',
        style: TossTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: TossColors.gray900,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedUnit ?? 'piece',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: TossColors.gray400,
            size: 20,
          ),
        ],
      ),
      onTap: onUnitTap,
    );
  }
}
