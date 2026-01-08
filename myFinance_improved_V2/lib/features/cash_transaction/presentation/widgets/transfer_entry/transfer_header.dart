import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/transfer_scope.dart';

/// Transfer Entry Sheet Header Widget
class TransferEntryHeader extends StatelessWidget {
  final TransferScope? selectedScope;
  final int currentStep;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const TransferEntryHeader({
    super.key,
    required this.selectedScope,
    required this.currentStep,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space2,
        TossSpacing.space2,
        0,
      ),
      child: Row(
        children: [
          // Back button
          if (currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
              color: TossColors.gray600,
            )
          else
            const SizedBox(width: TossSpacing.iconXXL),

          Expanded(
            child: Column(
              children: [
                Text(
                  'Cash Transfer',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
                if (selectedScope != null) ...[
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    selectedScope!.label,
                    style: TossTextStyles.caption.copyWith(
                      color: selectedScope!.isDebtTransaction
                          ? TossColors.gray700
                          : TossColors.gray500,
                      fontWeight: selectedScope!.isDebtTransaction
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Close button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            color: TossColors.gray500,
          ),
        ],
      ),
    );
  }
}
