import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_model.dart';
import 'package:uuid/uuid.dart';

// Dashboard State Provider
final dashboardProvider = StateNotifierProvider<DashboardNotifier, UserDashboard>((ref) {
  return DashboardNotifier(ref);
});

// User Dashboards List Provider
final userDashboardsProvider = StateProvider<List<UserDashboard>>((ref) {
  // Return user's saved dashboards
  return [
    _createDefaultDashboard(),
  ];
});

// User Preferences Provider
final userPreferencesProvider = StateProvider<UserPreferences>((ref) {
  return const UserPreferences(
    userId: 'current_user',
    colorScheme: 'light',
    numberFormat: 'US',
    timezone: 'UTC',
    language: 'en',
  );
});

// Widget Templates Provider
final widgetTemplatesProvider = Provider<List<WidgetTemplate>>((ref) {
  return _getWidgetTemplates();
});

// Dashboard Templates Provider
final dashboardTemplatesProvider = Provider<List<DashboardTemplate>>((ref) {
  return _getDashboardTemplates();
});

// Dashboard Notifier
class DashboardNotifier extends StateNotifier<UserDashboard> {
  final Ref ref;
  final _uuid = const Uuid();
  
  DashboardNotifier(this.ref) : super(_createDefaultDashboard());
  
  // Load a dashboard
  void loadDashboard(String dashboardId) {
    final dashboards = ref.read(userDashboardsProvider);
    final dashboard = dashboards.firstWhere(
      (d) => d.id == dashboardId,
      orElse: () => _createDefaultDashboard(),
    );
    state = dashboard;
  }
  
  // Save current dashboard
  Future<void> saveDashboard() async {
    state = state.copyWith(updatedAt: DateTime.now());
    // Save to backend
    _saveDashboardToBackend(state);
  }
  
  // Add widget to dashboard
  void addWidget(DashboardWidget widget) {
    final newWidget = widget.copyWith(
      id: _uuid.v4(),
      position: _findAvailablePosition(),
    );
    state = state.copyWith(
      widgets: [...state.widgets, newWidget],
      updatedAt: DateTime.now(),
    );
  }
  
  // Update widget
  void updateWidget(String widgetId, DashboardWidget updatedWidget) {
    state = state.copyWith(
      widgets: state.widgets.map((w) {
        return w.id == widgetId ? updatedWidget : w;
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }
  
  // Remove widget
  void removeWidget(String widgetId) {
    state = state.copyWith(
      widgets: state.widgets.where((w) => w.id != widgetId).toList(),
      updatedAt: DateTime.now(),
    );
  }
  
  // Move widget
  void moveWidget(String widgetId, WidgetPosition newPosition) {
    state = state.copyWith(
      widgets: state.widgets.map((w) {
        return w.id == widgetId ? w.copyWith(position: newPosition) : w;
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }
  
  // Resize widget
  void resizeWidget(String widgetId, WidgetSize newSize) {
    state = state.copyWith(
      widgets: state.widgets.map((w) {
        return w.id == widgetId ? w.copyWith(size: newSize) : w;
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }
  
  // Update global filters
  void updateGlobalFilters(List<GlobalFilter> filters) {
    state = state.copyWith(
      globalFilters: filters,
      updatedAt: DateTime.now(),
    );
  }
  
  // Clear filters
  void clearFilters() {
    state = state.copyWith(
      globalFilters: [],
      updatedAt: DateTime.now(),
    );
  }
  
  // Update refresh settings
  void updateRefreshSettings(RefreshConfig settings) {
    state = state.copyWith(
      refreshSettings: settings,
      updatedAt: DateTime.now(),
    );
  }
  
  // Update share settings
  void updateShareSettings({bool? isPublic}) {
    state = state.copyWith(
      shareSettings: state.shareSettings.copyWith(
        isPublic: isPublic ?? state.shareSettings.isPublic,
      ),
      updatedAt: DateTime.now(),
    );
  }
  
  // Update layout settings
  void updateLayoutSettings({bool? snapToGrid, int? gridSize}) {
    state = state.copyWith(
      layout: state.layout.copyWith(
        snapToGrid: snapToGrid ?? state.layout.snapToGrid,
        gridSize: gridSize ?? state.layout.gridSize,
      ),
      updatedAt: DateTime.now(),
    );
  }
  
  // Set as default dashboard
  void setAsDefault(bool isDefault) {
    state = state.copyWith(
      isDefault: isDefault,
      updatedAt: DateTime.now(),
    );
    if (isDefault) {
      // Update user preferences
      ref.read(userPreferencesProvider.notifier).update((prefs) =>
        prefs.copyWith(defaultDashboardId: state.id),
      );
    }
  }
  
  // Create dashboard from template
  void createFromTemplate(DashboardTemplate template) {
    state = UserDashboard(
      id: _uuid.v4(),
      name: template.name,
      description: template.description,
      widgets: template.widgets,
      layout: template.layout,
      globalFilters: template.defaultFilters ?? [],
      refreshSettings: const RefreshConfig(),
      shareSettings: const ShareConfig(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  // Helper: Find available position for new widget
  WidgetPosition _findAvailablePosition() {
    // Simple algorithm to find next available position
    int maxY = 0;
    for (final widget in state.widgets) {
      final bottomY = widget.position.y + widget.size.height;
      if (bottomY > maxY) {
        maxY = bottomY;
      }
    }
    return WidgetPosition(x: 0, y: maxY);
  }
  
  // Helper: Save dashboard to backend
  Future<void> _saveDashboardToBackend(UserDashboard dashboard) async {
    // Implement backend save logic
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

// Create default dashboard
UserDashboard _createDefaultDashboard() {
  return UserDashboard(
    id: 'default',
    name: 'Supply Chain Analytics',
    description: 'Monitor and analyze supply chain performance',
    isDefault: true,
    layout: const LayoutConfiguration(),
    refreshSettings: const RefreshConfig(
      enabled: true,
      intervalMinutes: 5,
    ),
    shareSettings: const ShareConfig(),
    widgets: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

// Get widget templates
List<WidgetTemplate> _getWidgetTemplates() {
  return [
    // Metrics
    const WidgetTemplate(
      id: 'metric_1',
      name: 'Key Metric',
      category: 'Metrics',
      description: 'Display a single important metric',
      icon: '📊',
      type: WidgetType.metricCard,
      defaultSize: WidgetSize(width: 2, height: 2),
      requiredDataFields: ['value', 'label'],
    ),
    const WidgetTemplate(
      id: 'trend_1',
      name: 'Trend Indicator',
      category: 'Metrics',
      description: 'Show metric with trend arrow',
      icon: '📈',
      type: WidgetType.trendIndicator,
      defaultSize: WidgetSize(width: 2, height: 2),
      requiredDataFields: ['value', 'previousValue'],
    ),
    
    // Charts
    const WidgetTemplate(
      id: 'line_1',
      name: 'Line Chart',
      category: 'Charts',
      description: 'Time series data visualization',
      icon: '📉',
      type: WidgetType.lineChart,
      defaultSize: WidgetSize(width: 4, height: 3),
      requiredDataFields: ['x', 'y'],
    ),
    const WidgetTemplate(
      id: 'bar_1',
      name: 'Bar Chart',
      category: 'Charts',
      description: 'Compare values across categories',
      icon: '📊',
      type: WidgetType.barChart,
      defaultSize: WidgetSize(width: 4, height: 3),
      requiredDataFields: ['category', 'value'],
    ),
    const WidgetTemplate(
      id: 'pie_1',
      name: 'Pie Chart',
      category: 'Charts',
      description: 'Show distribution of values',
      icon: '🥧',
      type: WidgetType.pieChart,
      defaultSize: WidgetSize(width: 3, height: 3),
      requiredDataFields: ['label', 'value'],
    ),
    
    // Tables
    const WidgetTemplate(
      id: 'table_1',
      name: 'Data Table',
      category: 'Tables',
      description: 'Display tabular data',
      icon: '📋',
      type: WidgetType.table,
      defaultSize: WidgetSize(width: 6, height: 4),
      requiredDataFields: [],
    ),
    
    // Analytics
    const WidgetTemplate(
      id: 'heat_1',
      name: 'Heat Map',
      category: 'Analytics',
      description: 'Visualize data density',
      icon: '🗺️',
      type: WidgetType.heatMap,
      defaultSize: WidgetSize(width: 4, height: 4),
      requiredDataFields: ['x', 'y', 'value'],
    ),
    const WidgetTemplate(
      id: 'gauge_1',
      name: 'Gauge',
      category: 'Analytics',
      description: 'Show progress toward goal',
      icon: '🎯',
      type: WidgetType.gauge,
      defaultSize: WidgetSize(width: 3, height: 3),
      requiredDataFields: ['value', 'min', 'max'],
    ),
    
    // Alerts
    const WidgetTemplate(
      id: 'alert_1',
      name: 'Alert Feed',
      category: 'Monitoring',
      description: 'Real-time alerts and notifications',
      icon: '🔔',
      type: WidgetType.alertFeed,
      defaultSize: WidgetSize(width: 4, height: 4),
      requiredDataFields: [],
    ),
    
    // Actions
    const WidgetTemplate(
      id: 'action_1',
      name: 'Action Panel',
      category: 'Controls',
      description: 'Quick action buttons',
      icon: '⚡',
      type: WidgetType.actionPanel,
      defaultSize: WidgetSize(width: 3, height: 2),
      requiredDataFields: [],
    ),
    
    // Custom
    const WidgetTemplate(
      id: 'custom_1',
      name: 'Custom KPI',
      category: 'Custom',
      description: 'Build your own metric',
      icon: '🔧',
      type: WidgetType.customKpi,
      defaultSize: WidgetSize(width: 3, height: 3),
      requiredDataFields: [],
    ),
  ];
}

// Get dashboard templates
List<DashboardTemplate> _getDashboardTemplates() {
  return [
    DashboardTemplate(
      id: 'starter',
      name: 'Starter Dashboard',
      category: 'Basic',
      description: 'Essential metrics to get started',
      widgets: [
        DashboardWidget(
          id: '1',
          type: WidgetType.metricCard,
          title: 'Total Inventory Value',
          position: const WidgetPosition(x: 0, y: 0),
          size: const WidgetSize(width: 2, height: 2),
          dataSource: const DataSourceConfig(
            type: DataSourceType.database,
            tableName: 'inventory',
            aggregation: 'sum',
          ),
          visualization: const VisualizationConfig(),
        ),
        DashboardWidget(
          id: '2',
          type: WidgetType.trendIndicator,
          title: 'Order Fulfillment Rate',
          position: const WidgetPosition(x: 2, y: 0),
          size: const WidgetSize(width: 2, height: 2),
          dataSource: const DataSourceConfig(
            type: DataSourceType.calculated,
          ),
          visualization: const VisualizationConfig(),
        ),
      ],
      layout: const LayoutConfiguration(),
    ),
    DashboardTemplate(
      id: 'operational',
      name: 'Operational Dashboard',
      category: 'Operations',
      description: 'Monitor daily operations',
      widgets: [],
      layout: const LayoutConfiguration(),
    ),
    DashboardTemplate(
      id: 'analytical',
      name: 'Analytics Dashboard',
      category: 'Analytics',
      description: 'Deep dive into data analysis',
      widgets: [],
      layout: const LayoutConfiguration(),
    ),
  ];
}