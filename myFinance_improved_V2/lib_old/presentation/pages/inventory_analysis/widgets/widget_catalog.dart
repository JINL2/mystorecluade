import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../models/dashboard_model.dart';
import '../providers/dashboard_provider.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class WidgetCatalog extends ConsumerStatefulWidget {
  final Function(DashboardWidget) onWidgetSelected;
  final bool isEditMode;
  
  const WidgetCatalog({
    super.key,
    required this.onWidgetSelected,
    required this.isEditMode,
  });
  
  @override
  ConsumerState<WidgetCatalog> createState() => _WidgetCatalogState();
}

class _WidgetCatalogState extends ConsumerState<WidgetCatalog> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(widgetTemplatesProvider);
    final categories = ['All', ...templates.map((t) => t.category).toSet()];
    
    final filteredTemplates = templates.where((template) {
      final matchesCategory = _selectedCategory == 'All' || template.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          template.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (template.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      return matchesCategory && matchesSearch;
    }).toList();
    
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Widget Catalog',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                'Drag widgets to add them to your dashboard',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        
        // Search bar
        Padding(
          padding: EdgeInsets.all(TossSpacing.paddingMD),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search widgets...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD, vertical: TossSpacing.space3),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        
        // Category chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == _selectedCategory;
              
              return Padding(
                padding: EdgeInsets.only(right: TossSpacing.space2),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
              );
            },
          ),
        ),
        
        SizedBox(height: TossSpacing.space4),
        
        // Widget list
        Expanded(
          child: filteredTemplates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: Theme.of(context).disabledColor,
                      ),
                      SizedBox(height: TossSpacing.space4),
                      Text(
                        'No widgets found',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(TossSpacing.paddingMD),
                  itemCount: filteredTemplates.length,
                  itemBuilder: (context, index) {
                    final template = filteredTemplates[index];
                    return _WidgetTemplateCard(
                      template: template,
                      onTap: () => _selectWidget(template),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  void _selectWidget(WidgetTemplate template) {
    final dashboardWidget = DashboardWidget(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: template.type,
      title: template.name,
      position: const WidgetPosition(x: 0, y: 0),
      size: template.defaultSize,
      dataSource: const DataSourceConfig(
        type: DataSourceType.manual,
      ),
      visualization: const VisualizationConfig(),
    );
    
    widget.onWidgetSelected(dashboardWidget);
  }
}

class _WidgetTemplateCard extends StatelessWidget {
  final WidgetTemplate template;
  final VoidCallback onTap;
  
  const _WidgetTemplateCard({
    required this.template,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space3),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Center(
                  child: Text(
                    template.icon ?? _getDefaultIcon(template.type),
                    style: TossTextStyles.h3,
                  ),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (template.description != null) ...[
                      SizedBox(height: TossSpacing.space1/2),
                      Text(
                        template.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: TossSpacing.space1),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space1,
                            vertical: TossSpacing.space1/2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                          ),
                          child: Text(
                            template.category,
                            style: TossTextStyles.body.copyWith(
                              fontSize: 10,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Text(
                          '${template.defaultSize.width}x${template.defaultSize.height}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Add button
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getDefaultIcon(WidgetType type) {
    switch (type) {
      case WidgetType.metricCard:
        return '📊';
      case WidgetType.lineChart:
        return '📈';
      case WidgetType.barChart:
        return '📊';
      case WidgetType.pieChart:
        return '🥧';
      case WidgetType.table:
        return '📋';
      case WidgetType.heatMap:
        return '🗺️';
      case WidgetType.gauge:
        return '🎯';
      case WidgetType.alertFeed:
        return '🔔';
      case WidgetType.actionPanel:
        return '⚡';
      case WidgetType.customKpi:
        return '🔧';
      case WidgetType.comparison:
        return '⚖️';
      case WidgetType.trendIndicator:
        return '📈';
      case WidgetType.filterControl:
        return '🔍';
      case WidgetType.textNote:
        return '📝';
      case WidgetType.image:
        return '🖼️';
    }
  }
}