import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Inputs Section - Showcases input field components
class InputsSection extends StatelessWidget {
  const InputsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Default Input',
              hintText: 'Enter text here',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Input with Helper',
              hintText: 'Enter text',
              helperText: 'This is helper text',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Input with Error',
              hintText: 'Enter text',
              errorText: 'This field is required',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Disabled Input',
              hintText: 'Cannot edit',
            ),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
