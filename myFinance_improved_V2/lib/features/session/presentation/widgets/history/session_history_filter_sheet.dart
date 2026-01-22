import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import '../../providers/session_history_provider.dart';
import '../../providers/states/session_history_filter_state.dart';
import 'filter_chip_widget.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Filter bottom sheet for session history
class SessionHistoryFilterSheet extends ConsumerStatefulWidget {
  const SessionHistoryFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return TossBottomSheet.showWithBuilder(
      context: context,
      heightFactor: 0.85,
      builder: (context) => const SessionHistoryFilterSheet(),
    );
  }

  @override
  ConsumerState<SessionHistoryFilterSheet> createState() =>
      _SessionHistoryFilterSheetState();
}

class _SessionHistoryFilterSheetState
    extends ConsumerState<SessionHistoryFilterSheet> {
  String? _selectedStoreId;
  late DateRangeType _dateRangeType;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  bool? _isActive;
  String? _sessionType;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(sessionHistoryNotifierProvider).filter;
    _selectedStoreId = filter.selectedStoreId;
    _dateRangeType = filter.dateRangeType;
    _customStartDate = filter.customStartDate;
    _customEndDate = filter.customEndDate;
    _isActive = filter.isActive;
    _sessionType = filter.sessionType;
  }

  List<Map<String, dynamic>> _getStoresForCurrentCompany() {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final companies =
        appState.user['companies'] as List<dynamic>? ?? <dynamic>[];

    for (final company in companies) {
      final companyMap = company as Map<String, dynamic>;
      if (companyMap['company_id'] == companyId) {
        final stores = companyMap['stores'] as List<dynamic>? ?? <dynamic>[];
        return stores.map((s) => s as Map<String, dynamic>).toList();
      }
    }
    return [];
  }

  void _applyFilters() {
    final newFilter = SessionHistoryFilterState(
      selectedStoreId: _selectedStoreId,
      dateRangeType: _dateRangeType,
      customStartDate: _customStartDate,
      customEndDate: _customEndDate,
      isActive: _isActive,
      sessionType: _sessionType,
    );
    ref.read(sessionHistoryNotifierProvider.notifier).updateFilter(newFilter);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedStoreId = null;
      _dateRangeType = DateRangeType.thisMonth;
      _customStartDate = null;
      _customEndDate = null;
      _isActive = null;
      _sessionType = null;
    });
  }

  Future<void> _selectCustomDateRange() async {
    final now = DateTime.now();
    final initialStart = _customStartDate ?? DateTime(now.year, now.month, 1);
    final initialEnd = _customEndDate ?? now;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: TossColors.white,
              surface: TossColors.white,
              onSurface: TossColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateRangeType = DateRangeType.custom;
        _customStartDate = picked.start;
        _customEndDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stores = _getStoresForCurrentCompany();

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandleBar(),
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stores.isNotEmpty) ...[
                    _buildSectionTitle('Store'),
                    _buildStoreSelector(stores),
                    const SizedBox(height: TossSpacing.space5),
                  ],
                  _buildSectionTitle('Date Range'),
                  _buildDateRangeSelector(),
                  const SizedBox(height: TossSpacing.space5),
                  _buildSectionTitle('Status'),
                  _buildActiveStatusSelector(),
                  const SizedBox(height: TossSpacing.space5),
                  _buildSectionTitle('Session Type'),
                  _buildSessionTypeSelector(),
                  const SizedBox(height: TossSpacing.space5),
                ],
              ),
            ),
          ),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space3),
      width: TossSpacing.iconXL,
      height: 4,
      decoration: BoxDecoration(
        color: TossColors.gray300,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: TossFontWeight.bold,
            ),
          ),
          TossButton.textButton(
            text: 'Clear All',
            onPressed: _clearFilters,
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space5,
        TossSpacing.space4,
        TossSpacing.space5,
        MediaQuery.of(context).padding.bottom + TossSpacing.space4,
      ),
      child: TossButton.primary(
        text: 'Apply Filters',
        onPressed: _applyFilters,
        fullWidth: true,
        height: TossSpacing.inputHeightLG + 4,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Text(
        title,
        style: TossTextStyles.bodySmall.copyWith(
          color: TossColors.textSecondary,
          fontWeight: TossFontWeight.semibold,
        ),
      ),
    );
  }

  Widget _buildStoreSelector(List<Map<String, dynamic>> stores) {
    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: [
        StoreChipWidget(
          label: 'All Stores',
          isSelected: _selectedStoreId == null,
          onTap: () => setState(() => _selectedStoreId = null),
        ),
        ...stores.map((store) {
          final storeId = store['store_id']?.toString() ?? '';
          final storeName = store['store_name']?.toString() ?? 'Unknown';
          return StoreChipWidget(
            label: storeName,
            isSelected: _selectedStoreId == storeId,
            onTap: () => setState(() => _selectedStoreId = storeId),
          );
        }),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilterChipWidget(
                label: 'This Month',
                isSelected: _dateRangeType == DateRangeType.thisMonth,
                onTap: () => setState(() {
                  _dateRangeType = DateRangeType.thisMonth;
                  _customStartDate = null;
                  _customEndDate = null;
                }),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: FilterChipWidget(
                label: 'Last Month',
                isSelected: _dateRangeType == DateRangeType.lastMonth,
                onTap: () => setState(() {
                  _dateRangeType = DateRangeType.lastMonth;
                  _customStartDate = null;
                  _customEndDate = null;
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Expanded(
              child: FilterChipWidget(
                label: 'This Year',
                isSelected: _dateRangeType == DateRangeType.thisYear,
                onTap: () => setState(() {
                  _dateRangeType = DateRangeType.thisYear;
                  _customStartDate = null;
                  _customEndDate = null;
                }),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: FilterChipWidget(
                label: _dateRangeType == DateRangeType.custom &&
                        _customStartDate != null &&
                        _customEndDate != null
                    ? '${_customStartDate!.month}/${_customStartDate!.day} - ${_customEndDate!.month}/${_customEndDate!.day}'
                    : 'Custom',
                isSelected: _dateRangeType == DateRangeType.custom,
                onTap: _selectCustomDateRange,
                prefixIcon: Icon(
                  Icons.calendar_today,
                  size: TossSpacing.iconXS,
                  color: _dateRangeType == DateRangeType.custom
                      ? TossColors.primary
                      : TossColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveStatusSelector() {
    return Row(
      children: [
        Expanded(
          child: FilterChipWidget(
            label: 'All',
            isSelected: _isActive == null,
            onTap: () => setState(() => _isActive = null),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: FilterChipWidget(
            label: 'Active',
            isSelected: _isActive == true,
            onTap: () => setState(() => _isActive = true),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: FilterChipWidget(
            label: 'Closed',
            isSelected: _isActive == false,
            onTap: () => setState(() => _isActive = false),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: FilterChipWidget(
            label: 'All',
            isSelected: _sessionType == null,
            onTap: () => setState(() => _sessionType = null),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: FilterChipWidget(
            label: 'Counting',
            isSelected: _sessionType == 'counting',
            onTap: () => setState(() => _sessionType = 'counting'),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: FilterChipWidget(
            label: 'Receiving',
            isSelected: _sessionType == 'receiving',
            onTap: () => setState(() => _sessionType = 'receiving'),
          ),
        ),
      ],
    );
  }
}
