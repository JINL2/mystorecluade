import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/inventory_metadata.dart';

/// Classification section for category and brand selection
class ClassificationSection extends StatelessWidget {
  final Category? selectedCategory;
  final Brand? selectedBrand;
  final VoidCallback onCategoryTap;
  final VoidCallback onBrandTap;

  const ClassificationSection({
    super.key,
    this.selectedCategory,
    this.selectedBrand,
    required this.onCategoryTap,
    required this.onBrandTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 16),
          _buildCategoryTile(),
          const Divider(height: 1, color: TossColors.gray200),
          _buildBrandTile(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Icon(Icons.folder_outlined, color: TossColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Classification',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Category', style: TossTextStyles.body),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedCategory?.name ?? 'Select product category',
            style: TossTextStyles.body.copyWith(
              color: selectedCategory != null
                  ? TossColors.gray900
                  : TossColors.gray400,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: TossColors.gray400),
        ],
      ),
      onTap: onCategoryTap,
    );
  }

  Widget _buildBrandTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Brand', style: TossTextStyles.body),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedBrand?.name ?? 'Choose brand',
            style: TossTextStyles.body.copyWith(
              color: selectedBrand != null
                  ? TossColors.gray900
                  : TossColors.gray400,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: TossColors.gray400),
        ],
      ),
      onTap: onBrandTap,
    );
  }
}
