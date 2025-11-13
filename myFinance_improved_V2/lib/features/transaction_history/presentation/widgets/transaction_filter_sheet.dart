import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';

import '../../domain/entities/transaction_filter.dart';
import '../providers/transaction_providers.dart';

class TransactionFilterSheet extends ConsumerStatefulWidget {
  const TransactionFilterSheet({super.key});

  @override
  ConsumerState<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends ConsumerState<TransactionFilterSheet> {
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
    final maxHeight = screenHeight * 0.8; // Use 80% of screen height max
    
    return TossBottomSheet(
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight - 100, // Account for TossBottomSheet padding and handle
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // Header - Using Toss design principles
          Row(
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
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Scope Toggle - Store vs Company view
          _buildScopeToggle(),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Quick Date Filters - Toss style chips
          _buildQuickDateFilters(),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Custom Date Range - Toss style date pickers
          _buildDateRangeSection(),
          
          const SizedBox(height: TossSpacing.space4),
          
          // TODO: Add selector components when available
          // For now, filters work with basic date/type filtering
          
          // Filter Options that still need async data (Transaction Type, Created By)
          filterOptionsAsync.when(
            data: (options) => Column(
              children: [
                // Transaction Type
                TossDropdown<String?>(
                  label: 'Transaction Type',
                  value: _selectedJournalType,
                  hint: 'All Types',
                  items: [
                    const TossDropdownItem(
                      value: null,
                      label: 'All Types',
                    ),
                    ...options.journalTypes.map((type) => 
                      TossDropdownItem(
                        value: type.id,
                        label: type.name,
                        subtitle: '${type.transactionCount} transactions',
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedJournalType = value;
                    });
                  },
                ),
                const SizedBox(height: TossSpacing.space4),
                
                // Created By
                TossDropdown<String?>(
                  label: 'Created By',
                  value: _selectedCreatedBy,
                  hint: 'All Users',
                  items: [
                    const TossDropdownItem(
                      value: null,
                      label: 'All Users',
                    ),
                    ...options.users.map((user) => 
                      TossDropdownItem(
                        value: user.id,
                        label: user.name,
                        subtitle: '${user.transactionCount} transactions',
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCreatedBy = value;
                    });
                  },
                ),
                const SizedBox(height: TossSpacing.space4),
              ],
            ),
            loading: () => const Column(
              children: [
                SizedBox(height: TossSpacing.space6),
                Center(
                  child: TossLoadingView(),
                ),
                SizedBox(height: TossSpacing.space6),
              ],
            ),
            error: (error, _) => Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: TossColors.error, size: TossSpacing.iconSM),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          'Failed to load filter options',
                          style: TossTextStyles.caption.copyWith(color: TossColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
              ],
            ),
          ),
          
          const SizedBox(height: TossSpacing.space6),
          
          // Action Buttons - Already using Toss components correctly
          Row(
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
          ),
          
          // Add bottom padding for safe area and visual spacing
          const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  // Scope toggle widget
  Widget _buildScopeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scope',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedScope = TransactionScope.store),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(TossBorderRadius.lg - 1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: _selectedScope == TransactionScope.store
                          ? TossColors.white
                          : TossColors.transparent,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(TossBorderRadius.lg - 1),
                      ),
                      border: _selectedScope == TransactionScope.store
                          ? Border.all(color: TossColors.primary)
                          : null,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.store,
                            size: TossSpacing.iconXS,
                            color: _selectedScope == TransactionScope.store
                                ? TossColors.primary
                                : TossColors.gray500,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            'Store View',
                            style: TossTextStyles.caption.copyWith(
                              color: _selectedScope == TransactionScope.store
                                  ? TossColors.primary
                                  : TossColors.gray600,
                              fontWeight: _selectedScope == TransactionScope.store
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: TossSpacing.space6, color: TossColors.gray200),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedScope = TransactionScope.company),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(TossBorderRadius.lg - 1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: _selectedScope == TransactionScope.company
                          ? TossColors.white
                          : TossColors.transparent,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(TossBorderRadius.lg - 1),
                      ),
                      border: _selectedScope == TransactionScope.company
                          ? Border.all(color: TossColors.primary)
                          : null,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.business,
                            size: TossSpacing.iconXS,
                            color: _selectedScope == TransactionScope.company
                                ? TossColors.primary
                                : TossColors.gray500,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            'Company View',
                            style: TossTextStyles.caption.copyWith(
                              color: _selectedScope == TransactionScope.company
                                  ? TossColors.primary
                                  : TossColors.gray600,
                              fontWeight: _selectedScope == TransactionScope.company
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Quick date filters using Toss design chips
  Widget _buildQuickDateFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Filters',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            _buildQuickFilterChip('Today', () {
              final now = DateTime.now();
              setState(() {
                _selectedFromDate = DateTime(now.year, now.month, now.day);
                _selectedToDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
              });
            }),
            _buildQuickFilterChip('Yesterday', () {
              final yesterday = DateTime.now().subtract(const Duration(days: 1));
              setState(() {
                _selectedFromDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
                _selectedToDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
              });
            }),
            _buildQuickFilterChip('This Week', () {
              final now = DateTime.now();
              final weekStart = now.subtract(Duration(days: now.weekday - 1));
              setState(() {
                _selectedFromDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
                _selectedToDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
              });
            }),
            _buildQuickFilterChip('This Month', () {
              final now = DateTime.now();
              setState(() {
                _selectedFromDate = DateTime(now.year, now.month, 1);
                _selectedToDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
              });
            }),
          ],
        ),
      ],
    );
  }

  // Toss-style filter chip
  Widget _buildQuickFilterChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(
            color: TossColors.gray200,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
          ),
        ),
      ),
    );
  }

  // Date range section with Toss styling
  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                'From',
                _selectedFromDate,
                (date) => setState(() => _selectedFromDate = date),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _buildDatePicker(
                'To',
                _selectedToDate,
                (date) => setState(() => _selectedToDate = date),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Toss-style date picker
  Widget _buildDatePicker(
    String label,
    DateTime? value,
    void Function(DateTime?) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: TossColors.primary,
                  onPrimary: TossColors.white,
                  surface: TossColors.white,
                  onSurface: TossColors.gray900,
                ),
              ),
              child: child!,
            );
          },
        );
        
        if (picked != null) {
          onChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: TossColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1 / 2),
                Text(
                  value != null
                      ? DateFormat('MMM d, yyyy').format(value)
                      : 'Select date',
                  style: TossTextStyles.body.copyWith(
                    color: value != null ? TossColors.gray900 : TossColors.gray400,
                    fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.calendar_today,
              size: TossSpacing.iconXS,
              color: TossColors.gray500,
            ),
          ],
        ),
      ),
    );
  }



  void _clearFilters() {
    setState(() {
      _selectedScope = TransactionScope.store; // Reset to default
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