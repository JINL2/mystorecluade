import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Buttons Section - Showcases standard Flutter buttons with theme styling
class ButtonsSection extends StatelessWidget {
  const ButtonsSection({super.key});

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
          _buildButtonItem(
            'Elevated Button',
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            'ElevatedButton',
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildButtonItem(
            'Outlined Button',
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            'OutlinedButton',
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildButtonItem(
            'Text Button',
            TextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
            'TextButton',
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildButtonItem(
            'Disabled Button',
            ElevatedButton(
              onPressed: null,
              child: const Text('Disabled Button'),
            ),
            'ElevatedButton (disabled)',
          ),
        ],
      ),
    );
  }

  Widget _buildButtonItem(String title, Widget button, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        button,
        const SizedBox(height: TossSpacing.space1),
        Center(
          child: Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
