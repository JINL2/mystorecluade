import 'package:flutter/material.dart';
import '../../../../core/themes/index.dart';
import '../models/dashboard_model.dart';

class DashboardToolbar extends StatelessWidget {
  final UserDashboard dashboard;
  final bool isEditMode;
  final Function(List<GlobalFilter>) onFilterChanged;
  final Function(RefreshConfig) onRefreshSettingsChanged;
  
  const DashboardToolbar({
    super.key,
    required this.dashboard,
    required this.isEditMode,
    required this.onFilterChanged,
    required this.onRefreshSettingsChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          // Filters
          if (dashboard.globalFilters.isNotEmpty) ...[
            Icon(
              Icons.filter_list,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: SizedBox(
                height: 32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dashboard.globalFilters.length,
                  itemBuilder: (context, index) {
                    final filter = dashboard.globalFilters[index];
                    return Padding(
                      padding: EdgeInsets.only(right: TossSpacing.space2),
                      child: Chip(
                        label: Text(
                          '${filter.label ?? filter.field}: ${filter.value}',
                          style: TossTextStyles.caption,
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          final updatedFilters = List<GlobalFilter>.from(dashboard.globalFilters);
                          updatedFilters.removeAt(index);
                          onFilterChanged(updatedFilters);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else ...[
            const Expanded(child: SizedBox()),
          ],
          
          // Add filter button
          if (isEditMode)
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Filter'),
              onPressed: () => _showAddFilterDialog(context),
            ),
          
          SizedBox(width: TossSpacing.space4),
          
          // Refresh settings
          if (dashboard.refreshSettings.enabled) ...[
            Icon(
              Icons.refresh,
              size: 18,
              color: Theme.of(context).disabledColor,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              'Every ${dashboard.refreshSettings.intervalMinutes}m',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(width: TossSpacing.space2),
          ],
          
          // Time range selector
          PopupMenuButton<String>(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space1),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
              child: Row(
                children: const [
                  Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: 8),
                  Text('Last 30 days'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
            onSelected: (value) {
              // Handle time range change
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'today', child: Text('Today')),
              const PopupMenuItem(value: '7days', child: Text('Last 7 days')),
              const PopupMenuItem(value: '30days', child: Text('Last 30 days')),
              const PopupMenuItem(value: '90days', child: Text('Last 90 days')),
              const PopupMenuItem(value: 'custom', child: Text('Custom range...')),
            ],
          ),
        ],
      ),
    );
  }
  
  void _showAddFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Filter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Field',
                hintText: 'e.g., product_category',
              ),
            ),
            SizedBox(height: TossSpacing.space4),
            DropdownButtonFormField<FilterOperator>(
              decoration: const InputDecoration(labelText: 'Operator'),
              items: FilterOperator.values.map((op) {
                return DropdownMenuItem(
                  value: op,
                  child: Text(op.name),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: TossSpacing.space4),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Value',
                hintText: 'Filter value',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add filter logic
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}