/// Account Mapping Status Widget
///
/// Purpose: Displays account mapping verification status
/// Shows loading, success, or error states for internal counterparty validation
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Status row for account mapping verification
class AccountMappingStatusRow extends StatelessWidget {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final String message;
  final String? counterpartyId;
  final String? counterpartyName;
  final void Function(String counterpartyId, String counterpartyName)?
      onNavigateToSettings;

  const AccountMappingStatusRow({
    super.key,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
    required this.message,
    this.counterpartyId,
    this.counterpartyName,
    this.onNavigateToSettings,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Widget leadingWidget;

    if (isLoading) {
      backgroundColor = TossColors.gray50;
      borderColor = TossColors.gray200;
      textColor = TossColors.gray600;
      leadingWidget = const TossLoadingView.inline(size: 16);
    } else if (isError) {
      backgroundColor = TossColors.error.withValues(alpha: 0.1);
      borderColor = TossColors.error.withValues(alpha: 0.3);
      textColor = TossColors.error;
      leadingWidget =
          const Icon(Icons.warning, color: TossColors.error, size: 18);
    } else if (isSuccess) {
      backgroundColor = TossColors.success.withValues(alpha: 0.1);
      borderColor = TossColors.success.withValues(alpha: 0.3);
      textColor = TossColors.success;
      leadingWidget =
          const Icon(Icons.check_circle, color: TossColors.success, size: 18);
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              message,
              style: TossTextStyles.bodySmall.copyWith(
                color: textColor,
                fontWeight: isError ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          // Show "Set Up" button for error state with counterparty info
          if (isError &&
              counterpartyId != null &&
              counterpartyName != null &&
              onNavigateToSettings != null)
            GestureDetector(
              onTap: () =>
                  onNavigateToSettings!(counterpartyId!, counterpartyName!),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  'Set Up',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Container for multiple account mapping status widgets
class AccountMappingWarnings extends StatelessWidget {
  final bool isCheckingDebitMapping;
  final bool isCheckingCreditMapping;
  final String? debitMappingError;
  final String? creditMappingError;
  final Map<String, dynamic>? debitAccountMapping;
  final Map<String, dynamic>? creditAccountMapping;
  final String? debitCounterpartyId;
  final String? creditCounterpartyId;
  final Map<String, dynamic>? debitCounterpartyData;
  final Map<String, dynamic>? creditCounterpartyData;
  final void Function(String counterpartyId, String counterpartyName)?
      onNavigateToSettings;

  const AccountMappingWarnings({
    super.key,
    this.isCheckingDebitMapping = false,
    this.isCheckingCreditMapping = false,
    this.debitMappingError,
    this.creditMappingError,
    this.debitAccountMapping,
    this.creditAccountMapping,
    this.debitCounterpartyId,
    this.creditCounterpartyId,
    this.debitCounterpartyData,
    this.creditCounterpartyData,
    this.onNavigateToSettings,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> warnings = [];

    // Debit mapping check status
    if (isCheckingDebitMapping) {
      warnings.add(
        const AccountMappingStatusRow(
          isLoading: true,
          message: 'Checking debit account mapping...',
        ),
      );
    } else if (debitMappingError != null) {
      warnings.add(
        AccountMappingStatusRow(
          isError: true,
          message: 'Debit: $debitMappingError',
          counterpartyId: debitCounterpartyId,
          counterpartyName: debitCounterpartyData?['name']?.toString(),
          onNavigateToSettings: onNavigateToSettings,
        ),
      );
    } else if (debitAccountMapping != null) {
      warnings.add(
        const AccountMappingStatusRow(
          isSuccess: true,
          message: 'Debit account mapping verified',
        ),
      );
    }

    // Credit mapping check status
    if (isCheckingCreditMapping) {
      warnings.add(
        const AccountMappingStatusRow(
          isLoading: true,
          message: 'Checking credit account mapping...',
        ),
      );
    } else if (creditMappingError != null) {
      warnings.add(
        AccountMappingStatusRow(
          isError: true,
          message: 'Credit: $creditMappingError',
          counterpartyId: creditCounterpartyId,
          counterpartyName: creditCounterpartyData?['name']?.toString(),
          onNavigateToSettings: onNavigateToSettings,
        ),
      );
    } else if (creditAccountMapping != null) {
      warnings.add(
        const AccountMappingStatusRow(
          isSuccess: true,
          message: 'Credit account mapping verified',
        ),
      );
    }

    if (warnings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(children: warnings);
  }
}
