import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../trade_shared/presentation/providers/trade_shared_providers.dart';

/// Incoterms and Payment Terms section for PI form
class PIShippingTermsSection extends ConsumerWidget {
  final String? incotermsCode;
  final TextEditingController incotermsPlaceController;
  final String? paymentTermsCode;
  final TextEditingController paymentTermsDetailController;
  final ValueChanged<String?> onIncotermsChanged;
  final ValueChanged<String?> onPaymentTermsChanged;

  const PIShippingTermsSection({
    super.key,
    required this.incotermsCode,
    required this.incotermsPlaceController,
    required this.paymentTermsCode,
    required this.paymentTermsDetailController,
    required this.onIncotermsChanged,
    required this.onPaymentTermsChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterDataState = ref.watch(masterDataProvider);
    final incoterms = masterDataState.incoterms;
    final paymentTerms = masterDataState.paymentTerms;

    // Fallback to hardcoded values if not loaded
    final incotermItems = incoterms.isNotEmpty
        ? incoterms.map((i) => TossDropdownItem<String>(
            value: i.code,
            label: i.code,
            subtitle: i.name,
          )).toList()
        : ['FOB', 'CIF', 'CFR', 'EXW', 'DDP', 'DAP']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    final paymentTermItems = paymentTerms.isNotEmpty
        ? paymentTerms.map((p) => TossDropdownItem<String>(
            value: p.code,
            label: p.code,
            subtitle: p.name,
          )).toList()
        : ['LC_AT_SIGHT', 'LC_USANCE', 'TT_ADVANCE', 'TT_AFTER', 'DA', 'DP']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return Column(
      children: [
        // Incoterms Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TossDropdown<String>(
                label: 'Incoterms',
                value: incotermsCode,
                hint: 'Select',
                isLoading: masterDataState.isLoading,
                items: incotermItems,
                onChanged: onIncotermsChanged,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _buildTextField(
                controller: incotermsPlaceController,
                label: 'Place',
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        // Payment Terms Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TossDropdown<String>(
                label: 'Payment Terms',
                value: paymentTermsCode,
                hint: 'Select',
                isLoading: masterDataState.isLoading,
                items: paymentTermItems,
                onChanged: onPaymentTermsChanged,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _buildTextField(
                controller: paymentTermsDetailController,
                label: 'Detail',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: controller,
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: TossColors.surface,
            contentPadding: const EdgeInsets.all(TossSpacing.space3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
