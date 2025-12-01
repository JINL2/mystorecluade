import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Product information section containing name, SKU, barcode, and optional description fields
class ProductInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController productNumberController;
  final TextEditingController barcodeController;
  final TextEditingController? descriptionController;
  final bool showDescription;

  const ProductInfoSection({
    super.key,
    required this.nameController,
    required this.productNumberController,
    required this.barcodeController,
    this.descriptionController,
    this.showDescription = false,
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
          _buildProductNameField(),
          const SizedBox(height: 16),
          _buildProductNumberField(),
          const SizedBox(height: 16),
          _buildBarcodeField(),
          if (showDescription && descriptionController != null) ...[
            const SizedBox(height: 16),
            _buildDescriptionField(),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Icon(Icons.info_outline, color: TossColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Product Information',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProductNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product name *',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: nameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product name is required';
            }
            return null;
          },
          decoration: _buildInputDecoration('Enter product name'),
        ),
      ],
    );
  }

  Widget _buildProductNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product number (Optional)',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: productNumberController,
          decoration: _buildInputDecoration(
            'Enter product number for inventory tracking',
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Barcode (Optional)',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: barcodeController,
          decoration: _buildInputDecoration('Enter barcode'),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          decoration: _buildInputDecoration('Enter product description'),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TossTextStyles.body.copyWith(
        color: TossColors.gray400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: TossColors.gray300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: TossColors.gray300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: TossColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: TossColors.error, width: 2),
      ),
    );
  }
}
