import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Issuing Bank section for LC form (text input fields)
/// This is for the buyer's bank - entered as text, not selected from cash_location
class LCIssuingBankSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController swiftController;
  final TextEditingController addressController;

  const LCIssuingBankSection({
    super.key,
    required this.nameController,
    required this.swiftController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TossTextField.filled(
          inlineLabel: 'Bank Name *',
          controller: nameController,
          hintText: '',
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: TossTextField.filled(
                inlineLabel: 'SWIFT Code',
                controller: swiftController,
                hintText: '',
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              flex: 2,
              child: TossTextField.filled(
                inlineLabel: 'Address',
                controller: addressController,
                hintText: '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build issuing bank info from text controllers for saving
  Map<String, dynamic>? buildBankInfo() {
    final name = nameController.text.trim();
    if (name.isEmpty) return null;
    return {
      'name': name,
      if (swiftController.text.trim().isNotEmpty)
        'swift': swiftController.text.trim(),
      if (addressController.text.trim().isNotEmpty)
        'address': addressController.text.trim(),
    };
  }
}
