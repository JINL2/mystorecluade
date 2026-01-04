import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Confirming Bank section for LC form (optional text input fields)
class LCConfirmingBankSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController swiftController;

  const LCConfirmingBankSection({
    super.key,
    required this.nameController,
    required this.swiftController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TossTextField.filled(
          inlineLabel: 'Bank Name',
          controller: nameController,
          hintText: '',
        ),
        const SizedBox(height: TossSpacing.space3),
        TossTextField.filled(
          inlineLabel: 'SWIFT Code',
          controller: swiftController,
          hintText: '',
        ),
      ],
    );
  }

  /// Build confirming bank info from text controllers for saving
  Map<String, dynamic>? buildBankInfo() {
    final name = nameController.text.trim();
    if (name.isEmpty) return null;
    return {
      'name': name,
      if (swiftController.text.trim().isNotEmpty)
        'swift': swiftController.text.trim(),
    };
  }
}
