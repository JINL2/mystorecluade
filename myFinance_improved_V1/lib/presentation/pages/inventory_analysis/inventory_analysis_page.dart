import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_icons.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../helpers/navigation_helper.dart';
import 'widgets/dashboard_canvas.dart';
import 'widgets/widget_catalog.dart';
import 'widgets/dashboard_toolbar.dart';
import 'providers/dashboard_provider.dart';
import 'models/dashboard_model.dart';

class InventoryAnalysisPage extends ConsumerStatefulWidget {
  const InventoryAnalysisPage({super.key});

  @override
  ConsumerState<InventoryAnalysisPage> createState() => _InventoryAnalysisPageState();
}

class _InventoryAnalysisPageState extends ConsumerState<InventoryAnalysisPage> {
  bool _isWidgetCatalogOpen = false;
  bool _isEditMode = false;
  
  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    final dashboardNotifier = ref.read(dashboardProvider.notifier);
    
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: Text(
          'Supply Chain Analytics',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        actions: [
          // Only keep the most essential action (settings/menu)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          final isTablet = constraints.maxWidth < 1200;
          
          if (isMobile) {
            return _buildMobileLayout(dashboard, dashboardNotifier);
          } else if (isTablet) {
            return _buildTabletLayout(dashboard, dashboardNotifier);
          } else {
            return _buildDesktopLayout(dashboard, dashboardNotifier);
          }
        },
      ),
    );
  }
  
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                height: 4,
                width: 40,
                margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Dashboard selector
                    ListTile(
                      leading: Icon(TossIcons.dashboard, color: TossColors.primary),
                      title: Text(
                        'Switch Dashboard',
                        style: TossTextStyles.bodyLarge,
                      ),
                      subtitle: Text(
                        ref.watch(dashboardProvider).name,
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showDashboardSelector(context);
                      },
                    ),
                    
                    const Divider(height: 1),
                    
                    // Edit mode toggle
                    ListTile(
                      leading: Icon(
                        _isEditMode ? Icons.check_circle : Icons.edit,
                        color: _isEditMode ? TossColors.success : TossColors.gray700,
                      ),
                      title: Text(
                        _isEditMode ? 'Save Changes' : 'Edit Dashboard',
                        style: TossTextStyles.bodyLarge,
                      ),
                      subtitle: Text(
                        _isEditMode ? 'Click to save your changes' : 'Customize widgets and layout',
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _toggleEditMode();
                      },
                    ),
                    
                    const Divider(height: 1),
                    
                    // Settings
                    ListTile(
                      leading: Icon(TossIcons.settings, color: TossColors.gray700),
                      title: Text(
                        'Dashboard Settings',
                        style: TossTextStyles.bodyLarge,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showDashboardSettings(context);
                      },
                    ),
                    
                    // Share
                    ListTile(
                      leading: Icon(TossIcons.share, color: TossColors.gray700),
                      title: Text(
                        'Share Dashboard',
                        style: TossTextStyles.bodyLarge,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showShareDialog(context);
                      },
                    ),
                    
                    // Export
                    ListTile(
                      leading: Icon(TossIcons.download, color: TossColors.gray700),
                      title: Text(
                        'Export Data',
                        style: TossTextStyles.bodyLarge,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showExportOptions(context);
                      },
                    ),
                    
                    SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        ref.read(dashboardProvider.notifier).saveDashboard();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Dashboard saved'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    });
  }
  
  void _showDashboardSelector(BuildContext context) {
    final dashboards = ref.read(userDashboardsProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Text(
                  'Select Dashboard',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              // Dashboard list
              ...dashboards.map((dashboard) => ListTile(
                leading: Icon(
                  dashboard.isDefault ? Icons.star : Icons.dashboard_outlined,
                  color: dashboard.isDefault ? TossColors.warning : TossColors.gray600,
                ),
                title: Text(
                  dashboard.name,
                  style: TossTextStyles.bodyLarge,
                ),
                subtitle: dashboard.description != null
                    ? Text(
                        dashboard.description!,
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                      )
                    : null,
                trailing: dashboard.id == ref.watch(dashboardProvider).id
                    ? Icon(Icons.check, color: TossColors.primary)
                    : null,
                onTap: () {
                  ref.read(dashboardProvider.notifier).loadDashboard(dashboard.id);
                  Navigator.pop(context);
                },
              )).toList(),
              SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                height: 4,
                width: 40,
                margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Text(
                  'Export Dashboard',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              
              const Divider(height: 16),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Export options
                    ListTile(
                      leading: Icon(TossIcons.download, color: TossColors.error),
                      title: Text('Export as PDF', style: TossTextStyles.bodyLarge),
                      subtitle: Text(
                        'Full dashboard report with charts',
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _exportDashboard('pdf');
                      },
                    ),
                    ListTile(
                      leading: Icon(TossIcons.analytics, color: TossColors.success),
                      title: Text('Export as Excel', style: TossTextStyles.bodyLarge),
                      subtitle: Text(
                        'Data tables with formatting',
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _exportDashboard('excel');
                      },
                    ),
                    ListTile(
                      leading: Icon(TossIcons.settings, color: TossColors.primary),
                      title: Text('Export as CSV', style: TossTextStyles.bodyLarge),
                      subtitle: Text(
                        'Raw data for analysis',
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _exportDashboard('csv');
                      },
                    ),
                    ListTile(
                      leading: Icon(TossIcons.share, color: TossColors.info),
                      title: Text('Export as Image', style: TossTextStyles.bodyLarge),
                      subtitle: Text(
                        'Screenshot of current view',
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _exportDashboard('image');
                      },
                    ),
                    SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget? _buildFloatingActionButton() {
    // Show FAB for adding widgets in edit mode, or for quick actions otherwise
    if (_isEditMode) {
      return FloatingActionButton(
        onPressed: () {
          setState(() {
            _isWidgetCatalogOpen = !_isWidgetCatalogOpen;
          });
        },
        backgroundColor: TossColors.primary,
        child: Icon(
          _isWidgetCatalogOpen ? Icons.close : Icons.add,
          color: TossColors.white,
        ),
      );
    }
    
    // Show quick actions FAB when not in edit mode and dashboard has widgets
    if (ref.watch(dashboardProvider).widgets.isNotEmpty) {
      return FloatingActionButton(
        onPressed: () => _showQuickActions(context),
        backgroundColor: TossColors.primary,
        child: const Icon(
          Icons.flash_on,
          color: TossColors.white,
        ),
      );
    }
    
    return null;
  }
  
  void _showQuickActions(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Text(
                  'Quick Actions',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              // Actions
              ListTile(
                leading: Icon(TossIcons.refresh, color: TossColors.primary),
                title: Text('Refresh Data', style: TossTextStyles.bodyLarge),
                subtitle: Text(
                  'Update all widgets with latest data',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Refresh logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Dashboard refreshed'),
                      backgroundColor: TossColors.success,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(TossIcons.filter, color: TossColors.gray700),
                title: Text('Apply Filters', style: TossTextStyles.bodyLarge),
                subtitle: Text(
                  'Filter data across all widgets',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Show filter dialog
                },
              ),
              ListTile(
                leading: Icon(TossIcons.analytics, color: TossColors.gray700),
                title: Text('View Insights', style: TossTextStyles.bodyLarge),
                subtitle: Text(
                  'AI-powered analytics and recommendations',
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Show insights
                },
              ),
              SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDesktopLayout(
    UserDashboard dashboard,
    DashboardNotifier notifier,
  ) {
    return Row(
      children: [
        // Widget Catalog Sidebar (collapsible)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isWidgetCatalogOpen ? 300 : 0,
          child: _isWidgetCatalogOpen
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: WidgetCatalog(
                    onWidgetSelected: (widget) {
                      notifier.addWidget(widget);
                      setState(() {
                        _isWidgetCatalogOpen = false;
                      });
                    },
                    isEditMode: _isEditMode,
                  ),
                )
              : null,
        ),
        
        // Main Dashboard Area
        Expanded(
          child: Column(
            children: [
              // Dashboard Toolbar
              if (_isEditMode || dashboard.globalFilters.isNotEmpty)
                DashboardToolbar(
                  dashboard: dashboard,
                  isEditMode: _isEditMode,
                  onFilterChanged: notifier.updateGlobalFilters,
                  onRefreshSettingsChanged: notifier.updateRefreshSettings,
                ),
              
              // Dashboard Canvas
              Expanded(
                child: DashboardCanvas(
                  dashboard: dashboard,
                  isEditMode: _isEditMode,
                  onWidgetUpdate: notifier.updateWidget,
                  onWidgetRemove: notifier.removeWidget,
                  onWidgetResize: notifier.resizeWidget,
                  onWidgetMove: notifier.moveWidget,
                  onEnableEditMode: () => _enableEditMode(),
                  onViewSampleDashboard: () => _loadSampleDashboard(notifier),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabletLayout(
    UserDashboard dashboard,
    DashboardNotifier notifier,
  ) {
    return Stack(
      children: [
        // Main Dashboard
        Column(
          children: [
            if (_isEditMode || dashboard.globalFilters.isNotEmpty)
              DashboardToolbar(
                dashboard: dashboard,
                isEditMode: _isEditMode,
                onFilterChanged: notifier.updateGlobalFilters,
                onRefreshSettingsChanged: notifier.updateRefreshSettings,
              ),
            Expanded(
              child: DashboardCanvas(
                dashboard: dashboard,
                isEditMode: _isEditMode,
                onWidgetUpdate: notifier.updateWidget,
                onWidgetRemove: notifier.removeWidget,
                onWidgetResize: notifier.resizeWidget,
                onWidgetMove: notifier.moveWidget,
                onEnableEditMode: () => _enableEditMode(),
                onViewSampleDashboard: () => _loadSampleDashboard(notifier),
              ),
            ),
          ],
        ),
        
        // Overlay Widget Catalog
        if (_isWidgetCatalogOpen)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: TossColors.shadow.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              child: WidgetCatalog(
                onWidgetSelected: (widget) {
                  notifier.addWidget(widget);
                  setState(() {
                    _isWidgetCatalogOpen = false;
                  });
                },
                isEditMode: _isEditMode,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildMobileLayout(
    UserDashboard dashboard,
    DashboardNotifier notifier,
  ) {
    return Column(
      children: [
        // Simplified Toolbar
        if (dashboard.globalFilters.isNotEmpty)
          Container(
            height: 48,
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
                const Icon(Icons.filter_list, size: 20),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    '${dashboard.globalFilters.length} filters active',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => notifier.clearFilters(),
                ),
              ],
            ),
          ),
        
        // Mobile Dashboard Canvas
        Expanded(
          child: DashboardCanvas(
            dashboard: dashboard,
            isEditMode: _isEditMode,
            isMobile: true,
            onWidgetUpdate: notifier.updateWidget,
            onWidgetRemove: notifier.removeWidget,
            onWidgetResize: notifier.resizeWidget,
            onWidgetMove: notifier.moveWidget,
            onEnableEditMode: () => _enableEditMode(),
            onViewSampleDashboard: () => _loadSampleDashboard(notifier),
          ),
        ),
      ],
    );
  }
  
  void _showDashboardSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 40,
              margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(TossSpacing.paddingMD),
              child: Text(
                'Dashboard Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(TossSpacing.paddingMD),
                children: [
                  _buildSettingSection('General', [
                    _buildSettingItem(
                      'Dashboard Name',
                      ref.watch(dashboardProvider).name,
                      onTap: () => _editDashboardName(context),
                    ),
                    _buildSettingItem(
                      'Description',
                      ref.watch(dashboardProvider).description ?? 'No description',
                      onTap: () => _editDashboardDescription(context),
                    ),
                    SwitchListTile(
                      title: const Text('Set as Default'),
                      subtitle: const Text('Open this dashboard by default'),
                      value: ref.watch(dashboardProvider).isDefault,
                      onChanged: (value) {
                        ref.read(dashboardProvider.notifier).setAsDefault(value);
                      },
                    ),
                  ]),
                  _buildSettingSection('Layout', [
                    _buildSettingItem(
                      'Grid Size',
                      '${ref.watch(dashboardProvider).layout.gridSize}px',
                      onTap: () => _editGridSize(context),
                    ),
                    SwitchListTile(
                      title: const Text('Snap to Grid'),
                      subtitle: const Text('Align widgets to grid when moving'),
                      value: ref.watch(dashboardProvider).layout.snapToGrid,
                      onChanged: (value) {
                        ref.read(dashboardProvider.notifier).updateLayoutSettings(
                          snapToGrid: value,
                        );
                      },
                    ),
                  ]),
                  _buildSettingSection('Data', [
                    _buildSettingItem(
                      'Auto Refresh',
                      ref.watch(dashboardProvider).refreshSettings.enabled
                          ? 'Every ${ref.watch(dashboardProvider).refreshSettings.intervalMinutes} minutes'
                          : 'Disabled',
                      onTap: () => _editRefreshSettings(context),
                    ),
                    _buildSettingItem(
                      'Time Zone',
                      ref.watch(userPreferencesProvider).timezone,
                      onTap: () => _editTimezone(context),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
          child: Text(
            title,
            style: TossTextStyles.labelLarge.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ...items,
        SizedBox(height: TossSpacing.space4),
      ],
    );
  }
  
  Widget _buildSettingItem(String title, String value, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
  
  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Dashboard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy Link'),
              subtitle: const Text('Share a read-only link'),
              onTap: () {
                // Copy link to clipboard
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Share with Team'),
              subtitle: const Text('Grant access to team members'),
              onTap: () {
                Navigator.pop(context);
                _showTeamShareDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Make Public'),
              subtitle: const Text('Allow anyone in organization to view'),
              onTap: () {
                ref.read(dashboardProvider.notifier).updateShareSettings(
                  isPublic: true,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _exportDashboard(String format) {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exporting dashboard as $format...')),
    );
  }
  
  void _editDashboardName(BuildContext context) {
    // Implement edit dialog
  }
  
  void _editDashboardDescription(BuildContext context) {
    // Implement edit dialog
  }
  
  void _editGridSize(BuildContext context) {
    // Implement edit dialog
  }
  
  void _editRefreshSettings(BuildContext context) {
    // Implement edit dialog
  }
  
  void _editTimezone(BuildContext context) {
    // Implement edit dialog
  }
  
  void _showTeamShareDialog(BuildContext context) {
    // Implement team share dialog
  }
  
  void _enableEditMode() {
    setState(() {
      _isEditMode = true;
    });
  }
  
  void _loadSampleDashboard(DashboardNotifier notifier) {
    // Load sample dashboard with priority problems widget
    final sampleWidgets = [
      DashboardWidget(
        id: 'sample1',
        type: WidgetType.metricCard,
        title: '🔴 Critical Issues',
        position: const WidgetPosition(x: 0, y: 0),
        size: const WidgetSize(width: 2, height: 2),
        dataSource: const DataSourceConfig(
          type: DataSourceType.calculated,
        ),
        visualization: const VisualizationConfig(
          showLegend: false,
        ),
      ),
      DashboardWidget(
        id: 'sample2',
        type: WidgetType.metricCard,
        title: '🟡 Warning Items',
        position: const WidgetPosition(x: 2, y: 0),
        size: const WidgetSize(width: 2, height: 2),
        dataSource: const DataSourceConfig(
          type: DataSourceType.calculated,
        ),
        visualization: const VisualizationConfig(
          showLegend: false,
        ),
      ),
      DashboardWidget(
        id: 'sample3',
        type: WidgetType.table,
        title: '📊 Priority Problems',
        position: const WidgetPosition(x: 0, y: 2),
        size: const WidgetSize(width: 4, height: 4),
        dataSource: const DataSourceConfig(
          type: DataSourceType.database,
          tableName: 'supply_chain_issues',
        ),
        visualization: const VisualizationConfig(),
      ),
      DashboardWidget(
        id: 'sample4',
        type: WidgetType.lineChart,
        title: '📈 Supply Chain Flow',
        position: const WidgetPosition(x: 4, y: 0),
        size: const WidgetSize(width: 4, height: 6),
        dataSource: const DataSourceConfig(
          type: DataSourceType.database,
          tableName: 'supply_chain_flow',
        ),
        visualization: const VisualizationConfig(
          chartConfig: ChartConfig(
            chartType: 'area',
            smooth: true,
          ),
        ),
      ),
    ];
    
    // Add sample widgets to dashboard
    for (final widget in sampleWidgets) {
      notifier.addWidget(widget);
    }
    
    // Enable edit mode to allow customization
    setState(() {
      _isEditMode = true;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sample dashboard loaded! You can now customize it.'),
        backgroundColor: TossColors.success,
      ),
    );
  }
}