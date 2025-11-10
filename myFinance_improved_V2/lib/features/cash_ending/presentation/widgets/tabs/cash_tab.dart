// lib/features/cash_ending/presentation/widgets/tabs/cash_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/keyboard_toolbar_1.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../../shared/widgets/toss/toss_card.dart';
import '../../../domain/entities/denomination.dart';
import '../../../domain/entities/stock_flow.dart';
import '../../../domain/providers/repository_providers.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../denomination_input.dart';
import '../error_banner.dart';
import '../location_selector.dart';
import '../real_section_widget.dart';
import '../sheets/cash_ending_selection_helpers.dart';
import '../sheets/currency_selector_sheet.dart';
import '../store_selector.dart';
import '../total_display.dart';

/// Cash Tab - Denomination-based cash counting
///
/// Structure from legacy:
/// - Card 1: Store + Location selection
/// - Card 2: Denomination inputs + Total + Submit
/// - Card 3: Real section (transaction history)
class CashTab extends ConsumerStatefulWidget {
  final String companyId;
  final Future<void> Function(BuildContext, CashEndingState, String) onSave;

  const CashTab({
    super.key,
    required this.companyId,
    required this.onSave,
  });

  @override
  ConsumerState<CashTab> createState() => _CashTabState();
}

class _CashTabState extends ConsumerState<CashTab> {
  // Store TextEditingControllers for each denomination
  final Map<String, Map<String, TextEditingController>> _controllers = {};

  // Store FocusNodes for each denomination (for keyboard toolbar)
  final Map<String, Map<String, FocusNode>> _focusNodes = {};

  // Keyboard toolbar controller
  KeyboardToolbarController? _toolbarController;

  // Stock flow data for Real section
  List<ActualFlow> _actualFlows = [];
  LocationSummary? _locationSummary;
  bool _isLoadingFlows = false;
  bool _hasMoreFlows = false;
  int _flowsOffset = 0;
  String? _previousLocationId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Add listener for location changes (like lib_old pattern)
    // This will trigger when location is auto-selected
    ref.listenManual(
      cashEndingProvider.select((state) => state.selectedCashLocationId),
      (previous, next) {

        // Load stock flows when location changes
        if (next != null && next.isNotEmpty && next != previous) {
          _previousLocationId = next;
          _loadStockFlows();
        }
      },
    );

    // Load initial data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(cashEndingProvider);

      _previousLocationId = state.selectedCashLocationId;

      if (state.selectedCashLocationId != null &&
          state.selectedCashLocationId!.isNotEmpty) {
        _loadStockFlows();
      } else {
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers first
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.dispose();
      }
    }

    // Dispose all focus nodes (these are the ones we manage)
    for (final currencyFocusNodes in _focusNodes.values) {
      for (final focusNode in currencyFocusNodes.values) {
        focusNode.dispose();
      }
    }

    // Clear toolbar controller references without disposing
    // (FocusNodes already disposed above)
    _toolbarController = null;

    super.dispose();
  }

  @override
  void didUpdateWidget(CashTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload flows if location changed
    final state = ref.read(cashEndingProvider);

    if (state.selectedCashLocationId != _previousLocationId) {
      _previousLocationId = state.selectedCashLocationId;
      _loadStockFlows();
    } else {
    }
  }

  TextEditingController _getController(String currencyId, String denominationId) {
    _controllers.putIfAbsent(currencyId, () => {});
    _controllers[currencyId]!.putIfAbsent(
      denominationId,
      () => TextEditingController(),
    );
    return _controllers[currencyId]![denominationId]!;
  }

  FocusNode _getFocusNode(String currencyId, String denominationId) {
    _focusNodes.putIfAbsent(currencyId, () => {});
    _focusNodes[currencyId]!.putIfAbsent(
      denominationId,
      () => FocusNode(),
    );
    return _focusNodes[currencyId]![denominationId]!;
  }

  void _initializeToolbarController(List<Denomination> denominations, String currencyId) {
    // Dispose existing controller if any
    _toolbarController?.dispose();

    // Create new controller with denomination count
    _toolbarController = KeyboardToolbarController(
      fieldCount: denominations.length,
    );

    // Map focus nodes to toolbar controller
    for (int i = 0; i < denominations.length; i++) {
      final denom = denominations[i];
      final focusNode = _getFocusNode(currencyId, denom.denominationId);

      // Replace toolbar's focus node with our focus node
      _toolbarController!.focusNodes[i].dispose();
      _toolbarController!.focusNodes[i] = focusNode;
    }
  }

  double _calculateTotal(String currencyId, List<Denomination> denominations) {
    double total = 0.0;
    final currencyControllers = _controllers[currencyId] ?? {};

    for (final denom in denominations) {
      final controller = currencyControllers[denom.denominationId];
      if (controller != null) {
        final quantity = int.tryParse(controller.text.trim()) ?? 0;
        total += denom.value * quantity;
      }
    }

    return total;
  }

  /// Load stock flows for the selected location
  Future<void> _loadStockFlows({bool loadMore = false}) async {
    final state = ref.read(cashEndingProvider);


    if (state.selectedCashLocationId == null ||
        state.selectedCashLocationId!.isEmpty ||
        state.selectedStoreId == null) {
      return;
    }

    if (_isLoadingFlows) {
      return;
    }

    setState(() {
      _isLoadingFlows = true;
      if (!loadMore) {
        _flowsOffset = 0;
        _actualFlows = [];
      }
    });

    try {
      final repository = ref.read(stockFlowRepositoryProvider);

      final resultWrapper = await repository.getLocationStockFlow(
        companyId: widget.companyId,
        storeId: state.selectedStoreId!,
        cashLocationId: state.selectedCashLocationId!,
        offset: _flowsOffset,
        limit: 20,
      );

      // Unwrap Result and check success
      final result = resultWrapper.successOrNull;
      if (result != null && result.success) {
        setState(() {
          if (loadMore) {
            _actualFlows.addAll(result.actualFlows);
          } else {
            _actualFlows = result.actualFlows;
            _locationSummary = result.locationSummary;
          }
          _hasMoreFlows = result.pagination?.hasMore ?? false;
          _flowsOffset += result.actualFlows.length;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [CashTab] Failed to load stock flows: $e');
      debugPrint('📍 Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load transaction history. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFlows = false;
        });
      }
    }
  }

  /// Load more flows for pagination
  void _loadMoreFlows() {
    _loadStockFlows(loadMore: true);
  }

  /// Reload stock flows (called after save)
  /// Public method exposed for parent to call after successful save
  void reloadStockFlows() {
    _loadStockFlows();
  }

  /// Show flow details in bottom sheet
  void _showFlowDetails(ActualFlow flow) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFlowDetailsSheet(flow),
    );
  }

  Widget _buildFlowDetailsSheet(ActualFlow flow) {
    final currencySymbol = _locationSummary?.baseCurrencySymbol ??
        (ref.read(cashEndingProvider).currencies.isNotEmpty
            ? ref.read(cashEndingProvider).currencies.first.symbol
            : '\$');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cash Count Details',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: TossSpacing.space4),

                  // Total Balance Card
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space5),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$currencySymbol${NumberFormat('#,###').format(flow.balanceAfter)}',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                              ),
                            ),
                            const Icon(
                              Icons.copy,
                              color: TossColors.primary,
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space4),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Previous Balance',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$currencySymbol${NumberFormat('#,###').format(flow.balanceBefore)}',
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Change',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$currencySymbol${NumberFormat('#,###').format(flow.flowAmount)}',
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space6),

                  // Denomination Breakdown
                  Text(
                    'Denomination Breakdown',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space4),

                  if (flow.currentDenominations.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space5),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      child: Center(
                        child: Text(
                          'No denomination details available',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ),
                    )
                  else
                    ...flow.currentDenominations.map((deno) => _buildNewDenominationCard(deno, currencySymbol)),

                  const SizedBox(height: TossSpacing.space6),

                  // Bottom Info
                  _buildInfoRow('Counted By', flow.createdBy.fullName),
                  _buildInfoRow('Date', _formatFullDate(flow.createdAt)),
                  _buildInfoRow('Time', flow.getFormattedTime()),

                  const SizedBox(height: TossSpacing.space5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewDenominationCard(DenominationDetail deno, String currencySymbol) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currencySymbol${NumberFormat('#,###').format(deno.denominationValue)}',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  deno.denominationType,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Expanded(
                child: _buildQuantityColumn('Previous Qty', deno.previousQuantity),
              ),
              Expanded(
                child: _buildQuantityColumn('Change', deno.quantityChange),
              ),
              Expanded(
                child: _buildQuantityColumn('Current Qty', deno.currentQuantity),
              ),
            ],
          ),
          const Divider(height: TossSpacing.space4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontSize: 15,
                ),
              ),
              Text(
                '$currencySymbol${NumberFormat('#,###').format(deno.subtotal)}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityColumn(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cashEndingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Error Banner
          if (_errorMessage != null)
            ErrorBanner(
              message: _errorMessage!,
              onRetry: () {
                setState(() => _errorMessage = null);
                _loadStockFlows();
              },
              onDismiss: () {
                setState(() => _errorMessage = null);
              },
            ),

          // Card 1: Store and Location Selection
          _buildLocationSelectionCard(state),

          // Card 2: Cash Counting (show if location selected)
          if (state.selectedCashLocationId != null &&
              state.selectedCashLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space6),
            _buildCashCountingCard(state),

            // Card 3: Real Section
            const SizedBox(height: TossSpacing.space6),
            RealSectionWidget(
              actualFlows: _actualFlows,
              locationSummary: _locationSummary,
              isLoading: _isLoadingFlows,
              hasMore: _hasMoreFlows,
              baseCurrencySymbol: state.currencies.isNotEmpty
                  ? state.currencies.first.symbol
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

          // Location Selector (always show like lib_old)
          const SizedBox(height: TossSpacing.space6),
          LocationSelector(
            locationType: 'cash',
            isLoading: false,
            locations: state.cashLocations,
            selectedLocationId: state.selectedCashLocationId,
            onTap: () {
              CashEndingSelectionHelpers.showLocationSelector(
                context: context,
                ref: ref,
                locationType: 'cash',
                locations: state.cashLocations,
                selectedLocationId: state.selectedCashLocationId,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCashCountingCard(CashEndingState state) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: _buildCashCountingSection(state),
    );
  }

  Widget _buildCashCountingSection(CashEndingState state) {
    if (state.isLoadingCurrencies) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space8),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.currencies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space8),
          child: Column(
            children: [
              const Icon(Icons.inbox, size: 64, color: TossColors.gray400),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No currencies available',
                style: TossTextStyles.bodyLarge
                    .copyWith(color: TossColors.gray600),
              ),
            ],
          ),
        ),
      );
    }

    final selectedCurrencyId =
        state.selectedCashCurrencyId ?? state.currencies.first.currencyId;
    final currency = state.currencies.firstWhere(
      (c) => c.currencyId == selectedCurrencyId,
      orElse: () => state.currencies.first,
    );

    // Wrap in Stack to render toolbar separately from Column
    return Stack(
      children: [
        // Main content in Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        // Header: "Cash Count" title + Currency selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cash Count',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            if (state.currencies.length > 1)
              GestureDetector(
                onTap: () {
                  CurrencySelectorSheet.show(
                    context: context,
                    ref: ref,
                    currencies: state.currencies,
                    selectedCurrencyId: selectedCurrencyId,
                    tabType: 'cash',
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currency.currencyCode,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: TossColors.primary,
                      size: 24,
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: TossSpacing.space5),

        // Denomination Inputs
        if (currency.denominations.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space8),
              child: Text(
                'No denominations configured for this currency',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else ...[
          // Initialize toolbar controller for this currency
          Builder(
            builder: (context) {
              // Initialize toolbar controller when building denominations
              if (_toolbarController == null ||
                  _toolbarController!.focusNodes.length != currency.denominations.length) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _initializeToolbarController(currency.denominations, selectedCurrencyId);
                });
              }
              return const SizedBox.shrink();
            },
          ),
          ...currency.denominations.map((denom) {
            final controller = _getController(selectedCurrencyId, denom.denominationId);
            final focusNode = _getFocusNode(selectedCurrencyId, denom.denominationId);

            return DenominationInput(
              denomination: denom,
              controller: controller,
              focusNode: focusNode,
              currencySymbol: currency.symbol,
              onChanged: () {
                setState(() {}); // Update total display
              },
            );
          }),
        ],

        const SizedBox(height: TossSpacing.space8),

        // Total Display
        TotalDisplay(
          totalAmount: _calculateTotal(selectedCurrencyId, currency.denominations),
          currencySymbol: currency.symbol,
          label: 'Cash Total',
        ),

        const SizedBox(height: TossSpacing.space10),

        // Submit Button
        Center(
          child: TossButton1.primary(
            text: 'Save Cash Ending',
            isLoading: state.isSaving,
            isEnabled: !state.isSaving,
            fullWidth: false,
            onPressed: !state.isSaving
                ? () async {
                    try {
                      await widget.onSave(context, state, selectedCurrencyId);
                    } catch (e) {
                      // Error handled by parent
                    }
                  }
                : null,
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            borderRadius: 12,
          ),
        ),
          ],
        ), // End of Column

        // Single shared keyboard toolbar - rendered separately in Stack
        if (_toolbarController != null)
          KeyboardToolbar1(
            controller: _toolbarController,
            showToolbar: true,
            // Callbacks will be evaluated when buttons are pressed
            onPrevious: () {
              final callback = _toolbarController!.focusPrevious;
              callback?.call();
            },
            onNext: () {
              final callback = _toolbarController!.focusNext;
              callback?.call();
            },
            onDone: () => _toolbarController!.unfocusAll(),
          ),
      ],
    ); // End of Stack
  }

  // Expose quantities for parent to access
  Map<String, Map<String, int>> get denominationQuantities {
    final quantities = <String, Map<String, int>>{};
    for (final currencyId in _controllers.keys) {
      quantities[currencyId] = {};
      for (final denominationId in _controllers[currencyId]!.keys) {
        final controller = _controllers[currencyId]![denominationId]!;
        final quantity = int.tryParse(controller.text.trim()) ?? 0;
        if (quantity > 0) {
          quantities[currencyId]![denominationId] = quantity;
        }
      }
    }
    return quantities;
  }

  void clearQuantities() {
    setState(() {
      for (final currencyControllers in _controllers.values) {
        for (final controller in currencyControllers.values) {
          controller.clear();
        }
      }
    });
  }
}
