import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/transfer_scope.dart';
import '../../formatters/cash_transaction_ui_extensions.dart';

/// Transfer Scope 선택 카드
class TransferScopeCard extends StatelessWidget {
  final TransferScope scope;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const TransferScopeCard({
    super.key,
    required this.scope,
    required this.isSelected,
    required this.isAvailable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isAvailable ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: isSelected ? TossColors.gray900 : TossColors.gray200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scope.isDebtTransaction
                      ? TossColors.gray200
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Center(
                  child: Icon(
                    scope.icon,
                    color: TossColors.gray600,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scope.label,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scope.description,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    if (scope.isDebtTransaction) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          'Creates A/R & A/P',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check : Icons.chevron_right,
                color: isSelected ? TossColors.gray900 : TossColors.gray300,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
