import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../providers/balance_sheet_providers.dart';
import 'balance_sheet_input/balance_sheet_input_widgets.dart';

/// Balance Sheet Input Screen
///
/// Shows Store selector, Date selector (optional), and Generate button
/// Balance Sheet (v2) doesn't need date selector - all-time cumulative
/// Income Statement still needs date selector
class BalanceSheetInput extends ConsumerWidget {
  final String companyId;
  final VoidCallback onGenerate;
  final bool showDateSelector;
  final String buttonText;

  const BalanceSheetInput({
    super.key,
    required this.companyId,
    required this.onGenerate,
    this.showDateSelector = false,
    this.buttonText = 'Generate Balance Sheet',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(balanceSheetPageNotifierProvider);
    final appState = ref.watch(appStateProvider);
    final storesAsync = ref.watch(storesProvider(companyId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Store Selector
          StoreSelectorCard(
            storesAsync: storesAsync,
            selectedStoreId: appState.storeChoosen,
          ),
          const SizedBox(height: TossSpacing.space4),

          // Date Selector (only for Income Statement)
          if (showDateSelector) ...[
            DateRangeSelector(dateRange: pageState.dateRange),
            const SizedBox(height: TossSpacing.space6),
          ] else ...[
            const SizedBox(height: TossSpacing.space2),
          ],

          // Generate Button
          GenerateButton(
            onPressed: onGenerate,
            buttonText: buttonText,
          ),
        ],
      ),
    );
  }
}
