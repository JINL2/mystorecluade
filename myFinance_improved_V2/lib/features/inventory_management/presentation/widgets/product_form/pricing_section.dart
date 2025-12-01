import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Pricing section for sale price and cost price inputs
class PricingSection extends StatelessWidget {
  final TextEditingController salePriceController;
  final TextEditingController costPriceController;
  final String currencySymbol;

  const PricingSection({
    super.key,
    required this.salePriceController,
    required this.costPriceController,
    this.currencySymbol = '',
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
          _buildSalePriceField(),
          const SizedBox(height: 16),
          _buildCostPriceField(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Icon(Icons.attach_money, color: TossColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Pricing',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSalePriceField() {
    final label = currencySymbol.isNotEmpty
        ? 'Sale price ($currencySymbol)'
        : 'Sale price';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: salePriceController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration('0'),
        ),
      ],
    );
  }

  Widget _buildCostPriceField() {
    final label = currencySymbol.isNotEmpty
        ? 'Cost of goods ($currencySymbol)'
        : 'Cost of goods';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: costPriceController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration('0'),
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
    );
  }
}
