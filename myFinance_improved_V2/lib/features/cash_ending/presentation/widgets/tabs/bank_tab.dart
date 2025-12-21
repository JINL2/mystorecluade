// lib/features/cash_ending/presentation/widgets/tabs/bank_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_icons.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../cash_location/presentation/pages/account_detail_page.dart';
import '../../providers/bank_tab_provider.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../grand_total_section.dart';
import '../section_label.dart';
import '../store_selector.dart';
/// Bank Tab - Single amount input (no denominations)
///
/// Structure from legacy:
/// - Card 1: Store + Location selection
/// - Card 2: Bank balance amount input + Submit
/// Key difference from Cash: No denominations, just one amount field
class BankTab extends ConsumerStatefulWidget {
  final String companyId;
  final Function(BuildContext, CashEndingState, String) onSave;
  const BankTab({
    super.key,
    required this.companyId,
    required this.onSave,
  });
  @override
  ConsumerState<BankTab> createState() => _BankTabState();
}
class _BankTabState extends ConsumerState<BankTab> {
  final TextEditingController _bankAmountController = TextEditingController();
  String? _previousLocationId;

  // Track previous resetInputsCounter to detect changes
  int _previousResetCounter = 0;
  @override
  void initState() {
    super.initState();
    // Reset bank tab state to clear any previous isSaving/error state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Reset to ensure clean state
      ref.read(bankTabProvider.notifier).reset();

      final pageState = ref.read(cashEndingProvider);
      _previousLocationId = pageState.selectedBankLocationId;
      if (pageState.selectedBankLocationId != null &&
          pageState.selectedBankLocationId!.isNotEmpty) {
        _loadStockFlowsFromProvider(pageState.selectedBankLocationId!);
      }
    });
  }
  @override
  void dispose() {
    _bankAmountController.dispose();
    super.dispose();
  }

  /// Clear bank amount input field
  void _clearAllInputs() {
    debugPrint('🧹 [BankTab] Clearing all input fields');
    _bankAmountController.clear();
    setState(() {
      // Force rebuild to update UI
    });
  }
  @override
  void didUpdateWidget(BankTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) return;

    final pageState = ref.read(cashEndingProvider);
    if (pageState.selectedBankLocationId != _previousLocationId) {
      _previousLocationId = pageState.selectedBankLocationId;
      if (pageState.selectedBankLocationId != null &&
          pageState.selectedBankLocationId!.isNotEmpty) {
        _loadStockFlowsFromProvider(pageState.selectedBankLocationId!);
      }
    }
  }

  /// Load stock flows via provider
  void _loadStockFlowsFromProvider(String locationId) {
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedStoreId == null || pageState.selectedStoreId!.isEmpty) {
      return;
    }

    ref.read(bankTabProvider.notifier).loadStockFlows(
      companyId: widget.companyId,
      storeId: pageState.selectedStoreId!,
      locationId: locationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(cashEndingProvider);
    final tabState = ref.watch(bankTabProvider);

    // ✅ Clear all inputs when resetInputsCounter changes
    if (pageState.resetInputsCounter != _previousResetCounter) {
      _previousResetCounter = pageState.resetInputsCounter;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _clearAllInputs();
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card 1: Store and Location Selection
          _buildLocationSelectionCard(pageState),
          // Card 2: Bank Balance Input (show if location selected)
          if (pageState.selectedBankLocationId != null &&
              pageState.selectedBankLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space6),
            _buildBankBalanceCard(pageState),
          ],
        ],
      ),
    );
  }
  Widget _buildLocationSelectionCard(CashEndingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store Selector
        StoreSelector(
          stores: state.stores,
          selectedStoreId: state.selectedStoreId,
          onChanged: (storeId) async {
            if (storeId != null) {
              await ref.read(cashEndingProvider.notifier).selectStore(
                storeId,
                widget.companyId,
              );
            }
          },
        ),

        // Bank Location Selector (show if store selected)
        if (state.selectedStoreId != null) ...[
          const SizedBox(height: TossSpacing.space4),
          if (state.bankLocations.isEmpty)
            // Show disabled state when no bank accounts available
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TossColors.gray300, width: 1),
              ),
              child: Row(
                children: [
                  Icon(TossIcons.bank, size: 20, color: TossColors.gray400),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bank Account',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'No bank accounts available',
                          style: TossTextStyles.bodyMedium.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            TossDropdown<String>(
              label: 'Bank Account',
              hint: 'Select Bank Account',
              value: state.selectedBankLocationId,
              isLoading: false,
              items: state.bankLocations.map((location) =>
                TossDropdownItem<String>(
                  value: location.locationId,
                  label: location.locationName,
                )
              ).toList(),
              onChanged: (locationId) {
                if (locationId != null) {
                  ref.read(cashEndingProvider.notifier).setSelectedBankLocation(locationId);

                  // Set the currency for the selected bank location
                  final selectedLocation = state.bankLocations.firstWhere(
                    (loc) => loc.locationId == locationId,
                  );
                  ref.read(cashEndingProvider.notifier).setSelectedBankCurrency(selectedLocation.currencyId);
                }
              },
            ),
        ],
      ],
    );
  }
  Widget _buildBankBalanceCard(CashEndingState state) {
    // Get selected bank currency
    final selectedCurrency = state.selectedBankCurrencyId != null
        ? state.currencies.firstWhere(
            (c) => c.currencyId == state.selectedBankCurrencyId,
            orElse: () => state.currencies.first,
          )
        : (state.currencies.isNotEmpty ? state.currencies.first : null);

    final currencyCode = selectedCurrency?.currencyCode ?? '';
    final currencySymbol = selectedCurrency?.symbol ?? '';

    // Calculate current bank amount from input
    final bankAmount = double.tryParse(
      _bankAmountController.text.replaceAll(',', ''),
    ) ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(text: 'Current bank balance ($currencyCode)'),
        const SizedBox(height: TossSpacing.space2),
        // Bank balance input field
        _buildBankAmountInput(),

        const SizedBox(height: TossSpacing.space4),

        // Grand Total with Journal and Difference
        GrandTotalSection(
          totalAmount: bankAmount,
          currencySymbol: currencySymbol,
          label: 'Bank Balance $currencyCode',
          isBaseCurrency: true,
          journalAmount: state.bankLocationJournalAmount,
          isLoadingJournal: state.isLoadingBankJournalAmount,
          onHistoryTap: state.selectedBankLocationId != null
              ? () => _navigateToAccountDetail(state, bankAmount, currencySymbol)
              : null,
        ),

        const SizedBox(height: TossSpacing.space4),

        // Save button
        _buildBankSaveButton(state),
      ],
    );
  }
  /// Builds the bank balance amount input field
  Widget _buildBankAmountInput() {
    return Container(
          height: 56,
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _bankAmountController.text.isNotEmpty
                  ? TossColors.primary.withOpacity(0.5)
                  : TossColors.gray200,
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: _bankAmountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((oldValue, newValue) {
                // Auto-format with commas
                if (newValue.text.isEmpty) return newValue;
                final number = int.tryParse(newValue.text.replaceAll(',', ''));
                if (number == null) return oldValue;
                final formatted = NumberFormat('#,###').format(number);
                return TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }),
            ],
            textAlign: TextAlign.center,
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray400,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              fillColor: TossColors.white,
              filled: true,
            ),
            onChanged: (value) {
              setState(() {}); // Rebuild to update total and button
            },
          ),
        );
  }
  /// Builds the save button with validation (from legacy lines 245-258)
  Widget _buildBankSaveButton(CashEndingState state) {
    // Enable button when currency is available (amount can be 0)
    // Note: Bank balance can be 0, so we don't check hasAmount
    final hasCurrency = state.selectedBankCurrencyId != null;
    return Builder(
      builder: (context) {
        final tabState = ref.watch(bankTabProvider);
        final isEnabled = hasCurrency && !tabState.isSaving;
        return TossButton1.primary(
          text: 'Submit Ending',
          isLoading: tabState.isSaving,
          isEnabled: isEnabled,
          fullWidth: true,
            onPressed: isEnabled
                ? () async {
                    final currencyId = state.selectedBankCurrencyId!;
                    await widget.onSave(context, state, currencyId);
                  }
                : null,
            textStyle: TossTextStyles.titleLarge.copyWith(
              color: TossColors.white,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: TossSpacing.space4,
            ),
            borderRadius: 12,
        );
      },
    );
  }
  // Expose amount for parent to access
  String get bankAmount => _bankAmountController.text.replaceAll(',', '');
  void clearAmount() {
    setState(() {
      _bankAmountController.clear();
    });
  }

  /// Navigate to AccountDetailPage for transaction history
  void _navigateToAccountDetail(CashEndingState state, double bankAmount, String currencySymbol) {
    if (state.selectedBankLocationId == null) return;

    // Find the selected location
    final selectedLocation = state.bankLocations.firstWhere(
      (loc) => loc.locationId == state.selectedBankLocationId,
      orElse: () => state.bankLocations.first,
    );

    // Calculate difference
    final journalAmount = state.bankLocationJournalAmount ?? 0.0;
    final difference = bankAmount - journalAmount;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailPage(
          locationId: state.selectedBankLocationId,
          accountName: selectedLocation.locationName,
          locationType: 'bank',
          balance: journalAmount.toInt(),
          errors: difference.toInt().abs(),
          totalJournal: journalAmount.toInt(),
          totalReal: bankAmount.toInt(),
          cashDifference: difference.toInt(),
          currencySymbol: currencySymbol,
        ),
      ),
    );
  }
}
