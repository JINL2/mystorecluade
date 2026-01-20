import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../domain/entities/transfer_scope.dart';
import '../../providers/cash_transaction_providers.dart';
import 'transfer_summary_widgets.dart';

/// Amount Input Section - Final step for all transfer types
class AmountInputSection extends ConsumerWidget {
  final TransferScope? selectedScope;
  final String fromStoreName;
  final String fromCashLocationName;
  final String? toCompanyName;
  final String? toStoreName;
  final String? toCashLocationName;
  final double amount;
  final void Function(double) onAmountChanged;

  /// Optional callback for exchange rate calculator button
  /// When provided (not null), shows a calculator button next to the amount display
  final VoidCallback? onExchangeRateTap;

  /// Key for accessing TossAmountKeypad state from parent
  final GlobalKey<TossAmountKeypadState>? keypadKey;

  const AmountInputSection({
    super.key,
    required this.selectedScope,
    required this.fromStoreName,
    required this.fromCashLocationName,
    this.toCompanyName,
    this.toStoreName,
    this.toCashLocationName,
    required this.amount,
    required this.onAmountChanged,
    this.onExchangeRateTap,
    this.keypadKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final currencyAsync = ref.watch(
      companyCurrencySymbolProvider(appState.companyChoosen),
    );

    // Show loading until currency data is ready
    return currencyAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space8),
          child: TossLoadingView(),
        ),
      ),
      error: (_, __) => _buildContent(context, '₩'),
      data: (currencySymbol) => _buildContent(context, currencySymbol),
    );
  }

  Widget _buildContent(BuildContext context, String currencySymbol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transfer summary with fade-in animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: TossAnimations.medium,
          curve: TossAnimations.decelerate,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: TransferSummaryWidget(
            selectedScope: selectedScope,
            fromStoreName: fromStoreName,
            fromCashLocationName: fromCashLocationName,
            toCompanyName: toCompanyName,
            toStoreName: toStoreName,
            toCashLocationName: toCashLocationName,
          ),
        ),

        // Debt transaction notice
        if (selectedScope?.isDebtTransaction == true) ...[
          const SizedBox(height: TossSpacing.space2),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: TossAnimations.medium,
            curve: TossAnimations.decelerate,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 10 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: InfoCard.alertWarning(
              message: 'This transfer will create a debt entry between stores/companies.',
            ),
          ),
        ],

        const SizedBox(height: TossSpacing.space3),

        // Amount keypad with fade-in animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: TossAnimations.slow,
          curve: TossAnimations.decelerate,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 15 * (1 - value)),
                child: child,
              ),
            );
          },
          child: TossAmountKeypad(
            key: keypadKey,
            initialAmount: amount,
            currencySymbol: currencySymbol,
            onAmountChanged: onAmountChanged,
            showSubmitButton: false,
            onExchangeRateTap: onExchangeRateTap,
          ),
        ),

        // Bottom padding for fixed button
        const SizedBox(height: 80),
      ],
    );
  }
}
