import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/session_history_provider.dart';
import '../../providers/states/session_history_filter_state.dart';

/// Filter bottom sheet for session history
class SessionHistoryFilterSheet extends ConsumerStatefulWidget {
  const SessionHistoryFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
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
    final filter = ref.read(sessionHistoryProvider).filter;
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
        return stores
            .map((s) => s as Map<String, dynamic>)
            .toList();
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
    ref.read(sessionHistoryProvider.notifier).updateFilter(newFilter);
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
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store filter
                  if (stores.isNotEmpty) ...[
                    _buildSectionTitle('Store'),
                    _buildStoreSelector(stores),
                    const SizedBox(height: TossSpacing.space5),
                  ],

                  // Date range filter
                  _buildSectionTitle('Date Range'),
                  _buildDateRangeSelector(),
                  const SizedBox(height: TossSpacing.space5),

                  // Active status filter
                  _buildSectionTitle('Status'),
                  _buildActiveStatusSelector(),
                  const SizedBox(height: TossSpacing.space5),

                  // Session type filter
                  _buildSectionTitle('Session Type'),
                  _buildSessionTypeSelector(),
                  const SizedBox(height: TossSpacing.space5),
                ],
              ),
            ),
          ),
          // Apply button
          Padding(
            padding: EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              MediaQuery.of(context).padding.bottom + TossSpacing.space4,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: TossColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Apply Filters',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
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
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStoreSelector(List<Map<String, dynamic>> stores) {
    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: [
        // All stores option
        _buildStoreChip(null, 'All Stores'),
        // Individual stores
        ...stores.map((store) {
          final storeId = store['store_id']?.toString() ?? '';
          final storeName = store['store_name']?.toString() ?? 'Unknown';
          return _buildStoreChip(storeId, storeName);
        }),
      ],
    );
  }

  Widget _buildStoreChip(String? storeId, String storeName) {
    final isSelected = _selectedStoreId == storeId;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedStoreId = storeId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? TossColors.primary.withValues(alpha: 0.15)
              : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Text(
          storeName,
          style: TossTextStyles.bodySmall.copyWith(
            color: isSelected ? TossColors.primary : TossColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDateRangeChip(
                'This Month',
                DateRangeType.thisMonth,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: _buildDateRangeChip(
                'Last Month',
                DateRangeType.lastMonth,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Expanded(
              child: _buildDateRangeChip(
                'This Year',
                DateRangeType.thisYear,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: _buildCustomDateRangeChip(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeChip(String label, DateRangeType type) {
    final isSelected = _dateRangeType == type;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _dateRangeType = type;
          if (type != DateRangeType.custom) {
            _customStartDate = null;
            _customEndDate = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: isSelected ? TossColors.primary : TossColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDateRangeChip() {
    final isSelected = _dateRangeType == DateRangeType.custom;
    String label = 'Custom';
    if (isSelected && _customStartDate != null && _customEndDate != null) {
      label =
          '${_formatDate(_customStartDate!)} - ${_formatDate(_customEndDate!)}';
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _selectCustomDateRange();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: isSelected ? TossColors.primary : TossColors.textSecondary,
              ),
              const SizedBox(width: TossSpacing.space1),
              Flexible(
                child: Text(
                  label,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  Widget _buildActiveStatusSelector() {
    return Row(
      children: [
        Expanded(child: _buildActiveChip('All', null)),
        const SizedBox(width: TossSpacing.space2),
        Expanded(child: _buildActiveChip('Active', true)),
        const SizedBox(width: TossSpacing.space2),
        Expanded(child: _buildActiveChip('Closed', false)),
      ],
    );
  }

  Widget _buildActiveChip(String label, bool? value) {
    final isSelected = _isActive == value;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _isActive = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: isSelected ? TossColors.primary : TossColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionTypeSelector() {
    return Row(
      children: [
        Expanded(child: _buildTypeChip('All', null)),
        const SizedBox(width: TossSpacing.space2),
        Expanded(child: _buildTypeChip('Counting', 'counting')),
        const SizedBox(width: TossSpacing.space2),
        Expanded(child: _buildTypeChip('Receiving', 'receiving')),
      ],
    );
  }

  Widget _buildTypeChip(String label, String? value) {
    final isSelected = _sessionType == value;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _sessionType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: isSelected ? TossColors.primary : TossColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
