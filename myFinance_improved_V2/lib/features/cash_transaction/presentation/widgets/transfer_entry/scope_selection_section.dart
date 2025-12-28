import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/transfer_scope.dart';
import 'transfer_scope_card.dart';

/// Scope Selection Section - Step 0
class ScopeSelectionSection extends StatelessWidget {
  final TransferScope? selectedScope;
  final bool Function(TransferScope) isScopeAvailable;
  final void Function(TransferScope) onScopeSelected;

  const ScopeSelectionSection({
    super.key,
    required this.selectedScope,
    required this.isScopeAvailable,
    required this.onScopeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        Text(
          'What type of transfer?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select where the money is going',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Scope options
        ...TransferScope.values.map((scope) {
          final isSelected = selectedScope == scope;
          final isAvailable = isScopeAvailable(scope);

          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space2),
            child: TransferScopeCard(
              scope: scope,
              isSelected: isSelected,
              isAvailable: isAvailable,
              onTap: isAvailable ? () => onScopeSelected(scope) : null,
            ),
          );
        }),
      ],
    );
  }
}
