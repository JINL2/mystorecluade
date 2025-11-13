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
import '../../../../../shared/widgets/toss/toss_card.dart';
import '../../../domain/entities/stock_flow.dart';
import '../../providers/bank_tab_provider.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../location_selector.dart';
import '../real_section_widget.dart';
import '../sheets/cash_ending_selection_helpers.dart';
import '../sheets/flow_detail_bottom_sheet.dart';
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
  @override
  void initState() {
    super.initState();
    // Listen for location changes
    ref.listenManual(
      cashEndingProvider.select((state) => state.selectedBankLocationId),
      (previous, next) {
        if (next != null && next.isNotEmpty && next != previous) {
          _previousLocationId = next;
          _loadStockFlowsFromProvider(next);
        }
      },
    );
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  @override
  void didUpdateWidget(BankTab oldWidget) {
    super.didUpdateWidget(oldWidget);
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

  /// Load more flows for pagination
  void _loadMoreFlows() {
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedBankLocationId == null ||
        pageState.selectedStoreId == null) {
      return;
    }

    ref.read(bankTabProvider.notifier).loadStockFlows(
      companyId: widget.companyId,
      storeId: pageState.selectedStoreId!,
      locationId: pageState.selectedBankLocationId!,
      loadMore: true,
    );
  }
  void _showFlowDetails(ActualFlow flow) {
    final pageState = ref.read(cashEndingProvider);
    final tabState = ref.read(bankTabProvider);
    FlowDetailBottomSheet.show(
      context: context,
      flow: flow,
      locationSummary: tabState.locationSummary,
      baseCurrencySymbol: pageState.currencies.isNotEmpty
          ? pageState.currencies.first.symbol
          : '\$',
    );
  }
  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(cashEndingProvider);
    final tabState = ref.watch(bankTabProvider);

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
            // Card 3: Real Section
            RealSectionWidget(
              actualFlows: tabState.stockFlows,
              locationSummary: tabState.locationSummary,
              isLoading: tabState.isLoadingFlows,
              hasMore: tabState.hasMoreFlows,
              baseCurrencySymbol: pageState.currencies.isNotEmpty
                  ? pageState.currencies.first.symbol
                  : '\$',
              onLoadMore: _loadMoreFlows,
              onItemTap: _showFlowDetails,
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildLocationSelectionCard(CashEndingState state) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Selector
          StoreSelector(
            stores: state.stores,
            selectedStoreId: state.selectedStoreId,
            onTap: () {
              CashEndingSelectionHelpers.showStoreSelector(
                context: context,
                ref: ref,
                stores: state.stores,
                selectedStoreId: state.selectedStoreId,
                companyId: widget.companyId,
              );
            },
          ),
          // Bank Location Selector (show if store selected)
          if (state.selectedStoreId != null) ...[
            const SizedBox(height: TossSpacing.space4),
            LocationSelector(
              locationType: 'bank',
              isLoading: false,
              locations: state.bankLocations,
              selectedLocationId: state.selectedBankLocationId,
              onTap: () {
                CashEndingSelectionHelpers.showLocationSelector(
                  context: context,
                  ref: ref,
                  locationType: 'bank',
                  locations: state.bankLocations,
                  selectedLocationId: state.selectedBankLocationId,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildBankBalanceCard(CashEndingState state) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bank balance input field (from legacy)
          _buildBankAmountInput(),
          const SizedBox(height: TossSpacing.space6),
          // Save button
          _buildBankSaveButton(state),
        ],
      ),
    );
  }
  /// Builds the bank balance amount input field (from legacy lines 146-242)
  Widget _buildBankAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              TossIcons.bank,
              size: 24,
              color: TossColors.primary,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Bank Balance',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: _bankAmountController.text.isNotEmpty
                  ? TossColors.primary.withOpacity(0.3)
                  : TossColors.gray200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            child: TextField(
              controller: _bankAmountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  // Auto-format with commas (from legacy)
                  if (newValue.text.isEmpty) return newValue;
                  final number =
                      int.tryParse(newValue.text.replaceAll(',', ''));
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
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray400,
                  fontWeight: FontWeight.w600,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space4,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: TossColors.white,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {}); // Rebuild to update button state
              },
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Enter the current bank balance amount',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
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
        return Center(
          child: TossButton1.primary(
            text: 'Save Bank Balance',
            isLoading: tabState.isSaving,
            isEnabled: isEnabled,
            fullWidth: false,
            onPressed: isEnabled
                ? () async {
                    final currencyId = state.selectedBankCurrencyId!;
                    await widget.onSave(context, state, currencyId);
                  }
                : null,
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            borderRadius: 12,
          ),
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
}
