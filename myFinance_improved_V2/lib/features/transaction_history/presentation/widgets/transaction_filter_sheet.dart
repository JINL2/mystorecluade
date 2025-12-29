// lib/features/transaction_history/presentation/widgets/transaction_filter_sheet.dart
//
// Transaction Filter Sheet - Refactored following Clean Architecture 2025
// Single Responsibility Principle applied
//
// Extracted widgets:
// - filter_sheet/scope_toggle_section.dart
// - filter_sheet/quick_date_filters_section.dart
// - filter_sheet/date_range_section.dart
// - filter_sheet/filter_options_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/selectors/autonomous_cash_location_selector.dart';
import '../../../../shared/widgets/selectors/autonomous_counterparty_selector.dart';
import '../../../../shared/widgets/selectors/enhanced_account_selector.dart';
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../shared/widgets/toss/toss_secondary_button.dart';
import '../../domain/entities/transaction_filter.dart';
import '../providers/transaction_providers.dart';
import 'filter_sheet/date_range_section.dart';
import 'filter_sheet/filter_options_section.dart';
import 'filter_sheet/quick_date_filters_section.dart';
import 'filter_sheet/scope_toggle_section.dart';

/// Transaction filter bottom sheet
class TransactionFilterSheet extends ConsumerStatefulWidget {
  const TransactionFilterSheet({super.key});

  @override
  ConsumerState<TransactionFilterSheet> createState() =>
      _TransactionFilterSheetState();
}

class _TransactionFilterSheetState
    extends ConsumerState<TransactionFilterSheet> {
  late TransactionFilter _filter;
  TransactionScope _selectedScope = TransactionScope.store;
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  String? _selectedAccountId;
  List<String>? _selectedAccountIds;
  String? _selectedCashLocationId;
  String? _selectedCounterpartyId;
  String? _selectedJournalType;
  String? _selectedCreatedBy;

  @override
  void initState() {
    super.initState();
    _initializeFromCurrentFilter();
  }

  void _initializeFromCurrentFilter() {
    _filter = ref.read(transactionFilterStateProvider);
    _selectedScope = _filter.scope;
    _selectedFromDate = _filter.dateFrom;
    _selectedToDate = _filter.dateTo;
    _selectedAccountId = _filter.accountId;
    _selectedAccountIds = _filter.accountIds;
    // Initialize single account from multi if available
    if (_selectedAccountIds != null && _selectedAccountIds!.isNotEmpty) {
      _selectedAccountId = _selectedAccountIds!.first;
    }
    _selectedCashLocationId = _filter.cashLocationId;
    _selectedCounterpartyId = _filter.counterpartyId;
    _selectedJournalType = _filter.journalType;
    _selectedCreatedBy = _filter.createdBy;
  }

  @override
  Widget build(BuildContext context) {
    final filterOptionsAsync = ref.watch(transactionFilterOptionsProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.8;

    return TossBottomSheet(
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight - 100,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: TossSpacing.space4),

              // Scope Toggle
              ScopeToggleSection(
                selectedScope: _selectedScope,
                onScopeChanged: (scope) => setState(() => _selectedScope = scope),
              ),

              const SizedBox(height: TossSpacing.space4),

              // Quick Date Filters
              QuickDateFiltersSection(
                onDateRangeSelected: (from, to) {
                  setState(() {
                    _selectedFromDate = from;
                    _selectedToDate = to;
                  });
                },
              ),

              const SizedBox(height: TossSpacing.space4),

              // Custom Date Range
              DateRangeSection(
                fromDate: _selectedFromDate,
                toDate: _selectedToDate,
                onFromDateChanged: (date) =>
                    setState(() => _selectedFromDate = date),
                onToDateChanged: (date) =>
                    setState(() => _selectedToDate = date),
              ),

              const SizedBox(height: TossSpacing.space4),

              // Account Selector
              EnhancedAccountSelector(
                selectedAccountId: _selectedAccountId,
                contextType: 'transaction_filter',
                showQuickAccess: true,
                maxQuickItems: 5,
                onAccountSelected: (account) {
                  setState(() {
                    _selectedAccountId = account.id;
                    _selectedAccountIds = [account.id];
                  });
                },
                label: 'Account',
                hint: 'All Accounts',
                showSearch: true,
                showTransactionCount: true,
              ),

              const SizedBox(height: TossSpacing.space4),

              // Cash Location Selector
              AutonomousCashLocationSelector(
                selectedLocationId: _selectedCashLocationId,
                onChanged: (value) =>
                    setState(() => _selectedCashLocationId = value),
              ),

              const SizedBox(height: TossSpacing.space4),

              // Counterparty Selector
              AutonomousCounterpartySelector(
                selectedCounterpartyId: _selectedCounterpartyId,
                onChanged: (value) =>
                    setState(() => _selectedCounterpartyId = value),
              ),

              const SizedBox(height: TossSpacing.space4),

              // Filter Options (Transaction Type, Created By)
              filterOptionsAsync.when(
                data: (options) => FilterOptionsSection(
                  optionsSnapshot: AsyncSnapshot.withData(
                    ConnectionState.done,
                    options,
                  ),
                  selectedJournalType: _selectedJournalType,
                  selectedCreatedBy: _selectedCreatedBy,
                  onJournalTypeChanged: (value) =>
                      setState(() => _selectedJournalType = value),
                  onCreatedByChanged: (value) =>
                      setState(() => _selectedCreatedBy = value),
                ),
                loading: () => const Column(
                  children: [
                    SizedBox(height: TossSpacing.space6),
                    Center(child: TossLoadingView()),
                    SizedBox(height: TossSpacing.space6),
                  ],
                ),
                error: (error, _) => FilterOptionsSection(
                  optionsSnapshot: AsyncSnapshot.withError(
                    ConnectionState.done,
                    error,
                  ),
                  selectedJournalType: _selectedJournalType,
                  selectedCreatedBy: _selectedCreatedBy,
                  onJournalTypeChanged: (value) =>
                      setState(() => _selectedJournalType = value),
                  onCreatedByChanged: (value) =>
                      setState(() => _selectedCreatedBy = value),
                ),
              ),

              const SizedBox(height: TossSpacing.space6),

              // Action Buttons
              _buildActionButtons(),

              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter Transactions',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: TossColors.gray700),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TossSecondaryButton(
            text: 'Clear All',
            onPressed: _clearFilters,
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: TossPrimaryButton(
            text: 'Apply Filter',
            onPressed: _applyFilters,
          ),
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedScope = TransactionScope.store;
      _selectedFromDate = null;
      _selectedToDate = null;
      _selectedAccountId = null;
      _selectedAccountIds = null;
      _selectedCashLocationId = null;
      _selectedCounterpartyId = null;
      _selectedJournalType = null;
      _selectedCreatedBy = null;
    });

    ref.read(transactionFilterStateProvider.notifier).clearFilter();
    Navigator.pop(context);
  }

  void _applyFilters() {
    final newFilter = TransactionFilter(
      scope: _selectedScope,
      dateFrom: _selectedFromDate,
      dateTo: _selectedToDate,
      accountId: _selectedAccountId,
      accountIds: _selectedAccountIds,
      cashLocationId: _selectedCashLocationId,
      counterpartyId: _selectedCounterpartyId,
      journalType: _selectedJournalType,
      createdBy: _selectedCreatedBy,
    );

    ref.read(transactionFilterStateProvider.notifier).updateFilter(newFilter);
    Navigator.pop(context);
  }
}
