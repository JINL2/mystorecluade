import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../data/models/transaction_history_model.dart';
import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../widgets/toss/toss_chip.dart';
import '../../../widgets/toss/toss_multi_select_dropdown.dart';
import '../providers/transaction_history_provider.dart';

class TransactionFilterSheet extends ConsumerStatefulWidget {
  const TransactionFilterSheet({super.key});

  @override
  ConsumerState<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends ConsumerState<TransactionFilterSheet> {
  late TransactionFilter _filter;
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
    _selectedFromDate = _filter.dateFrom;
    _selectedToDate = _filter.dateTo;
    _selectedAccountId = _filter.accountId;
    _selectedAccountIds = _filter.accountIds;
    _selectedCashLocationId = _filter.cashLocationId;
    _selectedCounterpartyId = _filter.counterpartyId;
    _selectedJournalType = _filter.journalType;
    _selectedCreatedBy = _filter.createdBy;
  }

  @override
  Widget build(BuildContext context) {
    final filterOptionsAsync = ref.watch(transactionFilterOptionsProvider);
    
    return TossBottomSheet(
      content: Column(
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
                icon: Icon(Icons.close, color: TossColors.gray700),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Quick Date Filters - Toss style chips
          _buildQuickDateFilters(),
          
          SizedBox(height: TossSpacing.space4),
          
          // Custom Date Range - Toss style date pickers
          _buildDateRangeSection(),
          
          SizedBox(height: TossSpacing.space4),
          
          // Filter Options using proper TossDropdown components
          filterOptionsAsync.when(
            data: (options) => Column(
              children: [
                // Journal Type - Using TossDropdown
                if (options.journalTypes.isNotEmpty) ...[
                  TossDropdown<String?>(
                    label: 'Transaction Type',
                    value: _selectedJournalType,
                    hint: 'All Types',
                    items: [
                      TossDropdownItem(
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
                  SizedBox(height: TossSpacing.space4),
                ],
                
                // Created By - Using TossDropdown
                if (options.users.isNotEmpty) ...[
                  TossDropdown<String?>(
                    label: 'Created By',
                    value: _selectedCreatedBy,
                    hint: 'All Users',
                    items: [
                      TossDropdownItem(
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
                  SizedBox(height: TossSpacing.space4),
                ],
                
                // Accounts - Using Multi-Select Dropdown
                if (options.accounts.isNotEmpty) ...[
                  TossMultiSelectDropdown<String>(
                    label: 'Accounts',
                    selectedValues: _selectedAccountIds,
                    hint: 'All Accounts',
                    searchable: true,
                    items: options.accounts.map((account) => 
                      TossMultiSelectItem(
                        value: account.id!,
                        label: account.name,
                        subtitle: account.type != null 
                          ? '${account.type} • ${account.transactionCount} transactions'
                          : '${account.transactionCount} transactions',
                      ),
                    ).toList(),
                    onChanged: (values) {
                      setState(() {
                        _selectedAccountIds = values;
                        _selectedAccountId = null; // Clear single selection
                      });
                    },
                  ),
                  SizedBox(height: TossSpacing.space4),
                ],
                
                // Cash Location - Using TossDropdown
                if (options.cashLocations.isNotEmpty) ...[
                  TossDropdown<String?>(
                    label: 'Cash Location',
                    value: _selectedCashLocationId,
                    hint: 'All Locations',
                    items: [
                      TossDropdownItem(
                        value: null,
                        label: 'All Locations',
                      ),
                      ...options.cashLocations.map((location) => 
                        TossDropdownItem(
                          value: location.id,
                          label: location.name,
                          subtitle: location.type != null
                            ? '${location.type} • ${location.transactionCount} transactions'
                            : '${location.transactionCount} transactions',
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCashLocationId = value;
                      });
                    },
                  ),
                  SizedBox(height: TossSpacing.space4),
                ],
                
                // Counterparty - Using TossDropdown
                if (options.counterparties.isNotEmpty) ...[
                  TossDropdown<String?>(
                    label: 'Counterparty',
                    value: _selectedCounterpartyId,
                    hint: 'All Counterparties',
                    items: [
                      TossDropdownItem(
                        value: null,
                        label: 'All Counterparties',
                      ),
                      ...options.counterparties.map((counterparty) => 
                        TossDropdownItem(
                          value: counterparty.id,
                          label: counterparty.name,
                          subtitle: counterparty.type != null
                            ? '${counterparty.type} • ${counterparty.transactionCount} transactions'
                            : '${counterparty.transactionCount} transactions',
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCounterpartyId = value;
                      });
                    },
                  ),
                  SizedBox(height: TossSpacing.space4),
                ],
              ],
            ),
            loading: () => Center(
              child: CircularProgressIndicator(color: TossColors.primary),
            ),
            error: (_, __) => SizedBox.shrink(),
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Action Buttons - Already using Toss components correctly
          Row(
            children: [
              Expanded(
                child: TossSecondaryButton(
                  text: 'Clear All',
                  onPressed: _clearFilters,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: TossPrimaryButton(
                  text: 'Apply Filter',
                  onPressed: _applyFilters,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  // Quick date filters using Toss design chips
  Widget _buildQuickDateFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Filters',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
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
              final yesterday = DateTime.now().subtract(Duration(days: 1));
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
        padding: EdgeInsets.symmetric(
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
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                'From',
                _selectedFromDate,
                (date) => setState(() => _selectedFromDate = date),
              ),
            ),
            SizedBox(width: TossSpacing.space3),
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
          lastDate: DateTime.now().add(Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: TossColors.primary,
                  onPrimary: Colors.white,
                  surface: Colors.white,
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
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: value != null ? TossColors.primary : TossColors.gray200,
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
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value != null
                      ? DateFormat('MMM d, yyyy').format(value)
                      : 'Select date',
                  style: TossTextStyles.caption.copyWith(
                    color: value != null ? TossColors.gray900 : TossColors.gray400,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.calendar_today,
              size: 16,
              color: value != null ? TossColors.primary : TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
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