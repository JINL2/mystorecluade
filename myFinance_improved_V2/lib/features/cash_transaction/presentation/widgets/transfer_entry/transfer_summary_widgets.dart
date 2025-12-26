import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/transfer_scope.dart';

/// FROM Summary Card - Shows source cash location info
class FromSummaryCard extends StatelessWidget {
  final String fromCashLocationName;
  final VoidCallback? onChangePressed;

  const FromSummaryCard({
    super.key,
    required this.fromCashLocationName,
    this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const Center(
              child: Icon(
                Icons.logout,
                color: TossColors.gray600,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FROM',
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.gray500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  fromCashLocationName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onChangePressed != null)
            GestureDetector(
              onTap: onChangePressed,
              child: Text(
                'Change',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Complete Transfer Summary - Shows both FROM and TO with arrow
class TransferSummaryWidget extends StatelessWidget {
  final TransferScope? selectedScope;
  final String fromStoreName;
  final String fromCashLocationName;
  final String? toCompanyName;
  final String? toStoreName;
  final String? toCashLocationName;

  const TransferSummaryWidget({
    super.key,
    required this.selectedScope,
    required this.fromStoreName,
    required this.fromCashLocationName,
    this.toCompanyName,
    this.toStoreName,
    this.toCashLocationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          // From
          _buildFromRow(),

          // Arrow
          const Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Icon(
              Icons.arrow_downward,
              color: TossColors.gray400,
              size: 20,
            ),
          ),

          // To
          _buildToRow(),
        ],
      ),
    );
  }

  Widget _buildFromRow() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: TossColors.gray100,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.logout,
              color: TossColors.gray600,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FROM',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (selectedScope != TransferScope.withinStore)
                Text(
                  fromStoreName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              Text(
                fromCashLocationName,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToRow() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: TossColors.gray100,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.login,
              color: TossColors.gray600,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TO',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (selectedScope == TransferScope.betweenCompanies && toCompanyName != null)
                Text(
                  toCompanyName!,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              if (selectedScope != TransferScope.withinStore && toStoreName != null)
                Text(
                  toStoreName!,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              Text(
                toCashLocationName ?? '',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
