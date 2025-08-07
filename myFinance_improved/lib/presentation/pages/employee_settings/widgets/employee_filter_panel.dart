// lib/presentation/pages/employee_settings/widgets/employee_filter_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../domain/entities/employee_filter.dart';
import '../../../providers/employee_provider.dart';

class EmployeeFilterPanel extends ConsumerStatefulWidget {
  final bool isMobile;

  const EmployeeFilterPanel({
    super.key,
    this.isMobile = false,
  });

  @override
  ConsumerState<EmployeeFilterPanel> createState() => _EmployeeFilterPanelState();
}

class _EmployeeFilterPanelState extends ConsumerState<EmployeeFilterPanel> {
  bool _rolesExpanded = true;
  bool _storesExpanded = true;
  bool _sortExpanded = true;

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(companyRolesProvider);
    final storesAsync = ref.watch(companyStoresProvider);
    final filter = ref.watch(employeeFilterProvider);

    return Container(
      decoration: BoxDecoration(
        color: widget.isMobile ? TossColors.background : TossColors.gray50,
        border: widget.isMobile
            ? null
            : Border(
                right: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isMobile) ...[
            AppBar(
              backgroundColor: TossColors.background,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close, color: TossColors.gray900),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Filters',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ),
          ] else ...[
            Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (filter.selectedRoleIds.isNotEmpty || filter.selectedStoreIds.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        ref.read(employeeFilterProvider.notifier).clearFilters();
                      },
                      child: Text(
                        'Clear all',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Filter Section
                  _buildDropdownFilterSection(
                    context: context,
                    ref: ref,
                    title: 'Roles',
                    items: rolesAsync.when(
                      data: (roles) => roles,
                      loading: () => [],
                      error: (_, __) => [],
                    ),
                    selectedIds: filter.selectedRoleIds,
                    onToggle: (roleId) {
                      ref.read(employeeFilterProvider.notifier).toggleRoleFilter(roleId);
                    },
                    onSelectAll: () {
                      final allRoleIds = rolesAsync.value?.map((r) => r['role_id'].toString()).toList() ?? [];
                      for (final id in allRoleIds) {
                        if (!filter.selectedRoleIds.contains(id)) {
                          ref.read(employeeFilterProvider.notifier).toggleRoleFilter(id);
                        }
                      }
                    },
                    onClearAll: () {
                      ref.read(employeeFilterProvider.notifier).clearRoleFilters();
                    },
                    nameKey: 'role_name',
                    idKey: 'role_id',
                    isExpanded: _rolesExpanded,
                    onExpandToggle: () => setState(() => _rolesExpanded = !_rolesExpanded),
                  ),
                  
                  SizedBox(height: TossSpacing.space6),
                  
                  // Store Filter Section
                  _buildDropdownFilterSection(
                    context: context,
                    ref: ref,
                    title: 'Stores',
                    items: storesAsync.when(
                      data: (stores) => stores,
                      loading: () => [],
                      error: (_, __) => [],
                    ),
                    selectedIds: filter.selectedStoreIds,
                    onToggle: (storeId) {
                      ref.read(employeeFilterProvider.notifier).toggleStoreFilter(storeId);
                    },
                    onSelectAll: () {
                      final allStoreIds = storesAsync.value?.map((s) => s['store_id'].toString()).toList() ?? [];
                      for (final id in allStoreIds) {
                        if (!filter.selectedStoreIds.contains(id)) {
                          ref.read(employeeFilterProvider.notifier).toggleStoreFilter(id);
                        }
                      }
                    },
                    onClearAll: () {
                      ref.read(employeeFilterProvider.notifier).clearStoreFilters();
                    },
                    nameKey: 'store_name',
                    idKey: 'store_id',
                    isExpanded: _storesExpanded,
                    onExpandToggle: () => setState(() => _storesExpanded = !_storesExpanded),
                  ),
                  
                  SizedBox(height: TossSpacing.space6),
                  
                  // Sort Options
                  _buildSortSection(context, ref, filter),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilterSection({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required List<Map<String, dynamic>> items,
    required List<String> selectedIds,
    required Function(String) onToggle,
    required VoidCallback onSelectAll,
    required VoidCallback onClearAll,
    required String nameKey,
    required String idKey,
    required bool isExpanded,
    required VoidCallback onExpandToggle,
  }) {
    final selectedCount = selectedIds.length;
    final totalCount = items.length;
    final allSelected = selectedCount == totalCount && totalCount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onExpandToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  color: TossColors.gray600,
                  size: 20,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  title,
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (isExpanded && items.isNotEmpty) ...[
                  TextButton(
                    onPressed: allSelected ? onClearAll : onSelectAll,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      allSelected ? 'Clear' : 'Select all',
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        
        if (isExpanded) ...[
          SizedBox(height: TossSpacing.space2),
          if (items.isEmpty) ...[
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'No $title available',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ),
          ] else ...[
            Column(
              children: items.map((item) {
                final id = item[idKey].toString();
                final name = item[nameKey] ?? 'Unknown';
                final isSelected = selectedIds.contains(id);
                
                return InkWell(
                  onTap: () => onToggle(id),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: TossSpacing.space2,
                      horizontal: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? TossColors.primary : TossColors.gray300,
                              width: 2,
                            ),
                            color: isSelected ? TossColors.primary : Colors.transparent,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Text(
                            name,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildSortSection(BuildContext context, WidgetRef ref, filter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _sortExpanded = !_sortExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              children: [
                Icon(
                  _sortExpanded ? Icons.expand_more : Icons.chevron_right,
                  color: TossColors.gray600,
                  size: 20,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Sort By',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  _getSortLabel(filter.sortBy),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        if (_sortExpanded) ...[
          SizedBox(height: TossSpacing.space2),
          Column(
            children: [
              _buildSortOption(
                context: context,
                ref: ref,
                label: 'Name',
                sortBy: EmployeeSortBy.name,
                currentSortBy: filter.sortBy,
              ),
              _buildSortOption(
                context: context,
                ref: ref,
                label: 'Role',
                sortBy: EmployeeSortBy.role,
                currentSortBy: filter.sortBy,
              ),
              _buildSortOption(
                context: context,
                ref: ref,
                label: 'Salary',
                sortBy: EmployeeSortBy.salary,
                currentSortBy: filter.sortBy,
              ),
              _buildSortOption(
                context: context,
                ref: ref,
                label: 'Join Date',
                sortBy: EmployeeSortBy.joinDate,
                currentSortBy: filter.sortBy,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required EmployeeSortBy sortBy,
    required EmployeeSortBy currentSortBy,
  }) {
    final isSelected = sortBy == currentSortBy;
    
    return InkWell(
      onTap: () {
        ref.read(employeeFilterProvider.notifier).setSortBy(sortBy);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: TossSpacing.space2,
          horizontal: TossSpacing.space2,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? TossColors.primary : TossColors.gray300,
                  width: 2,
                ),
                color: isSelected ? TossColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: TossSpacing.space3),
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortLabel(EmployeeSortBy sortBy) {
    switch (sortBy) {
      case EmployeeSortBy.name:
        return 'Name';
      case EmployeeSortBy.role:
        return 'Role';
      case EmployeeSortBy.salary:
        return 'Salary';
      case EmployeeSortBy.joinDate:
        return 'Join Date';
    }
  }
}