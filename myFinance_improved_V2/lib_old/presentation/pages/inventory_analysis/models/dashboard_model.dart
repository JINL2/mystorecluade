import 'package:flutter/material.dart';

// Dashboard Configuration
class UserDashboard {
  final String id;
  final String name;
  final String? description;
  final bool isDefault;
  final bool isPublic;
  final List<String> tags;
  final List<DashboardWidget> widgets;
  final LayoutConfiguration layout;
  final List<GlobalFilter> globalFilters;
  final RefreshConfig refreshSettings;
  final ShareConfig shareSettings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserDashboard({
    required this.id,
    required this.name,
    this.description,
    this.isDefault = false,
    this.isPublic = false,
    this.tags = const [],
    this.widgets = const [],
    required this.layout,
    this.globalFilters = const [],
    required this.refreshSettings,
    required this.shareSettings,
    this.createdAt,
    this.updatedAt,
  });

  UserDashboard copyWith({
    String? id,
    String? name,
    String? description,
    bool? isDefault,
    bool? isPublic,
    List<String>? tags,
    List<DashboardWidget>? widgets,
    LayoutConfiguration? layout,
    List<GlobalFilter>? globalFilters,
    RefreshConfig? refreshSettings,
    ShareConfig? shareSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserDashboard(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
      widgets: widgets ?? this.widgets,
      layout: layout ?? this.layout,
      globalFilters: globalFilters ?? this.globalFilters,
      refreshSettings: refreshSettings ?? this.refreshSettings,
      shareSettings: shareSettings ?? this.shareSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Widget Configuration
class DashboardWidget {
  final String id;
  final WidgetType type;
  final String title;
  final WidgetPosition position;
  final WidgetSize size;
  final DataSourceConfig dataSource;
  final VisualizationConfig visualization;
  final List<AlertRule> alerts;
  final Map<String, dynamic> customSettings;
  final bool isVisible;
  final DateTime? lastUpdated;

  const DashboardWidget({
    required this.id,
    required this.type,
    required this.title,
    required this.position,
    required this.size,
    required this.dataSource,
    required this.visualization,
    this.alerts = const [],
    this.customSettings = const {},
    this.isVisible = true,
    this.lastUpdated,
  });

  DashboardWidget copyWith({
    String? id,
    WidgetType? type,
    String? title,
    WidgetPosition? position,
    WidgetSize? size,
    DataSourceConfig? dataSource,
    VisualizationConfig? visualization,
    List<AlertRule>? alerts,
    Map<String, dynamic>? customSettings,
    bool? isVisible,
    DateTime? lastUpdated,
  }) {
    return DashboardWidget(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      position: position ?? this.position,
      size: size ?? this.size,
      dataSource: dataSource ?? this.dataSource,
      visualization: visualization ?? this.visualization,
      alerts: alerts ?? this.alerts,
      customSettings: customSettings ?? this.customSettings,
      isVisible: isVisible ?? this.isVisible,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Widget Types
enum WidgetType {
  metricCard,
  lineChart,
  barChart,
  pieChart,
  table,
  heatMap,
  gauge,
  alertFeed,
  actionPanel,
  customKpi,
  comparison,
  trendIndicator,
  filterControl,
  textNote,
  image,
}

// Widget Position
class WidgetPosition {
  final int x;
  final int y;

  const WidgetPosition({
    required this.x,
    required this.y,
  });

  WidgetPosition copyWith({
    int? x,
    int? y,
  }) {
    return WidgetPosition(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}

// Widget Size
class WidgetSize {
  final int width;
  final int height;
  final int? minWidth;
  final int? minHeight;
  final int? maxWidth;
  final int? maxHeight;

  const WidgetSize({
    required this.width,
    required this.height,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
  });

  WidgetSize copyWith({
    int? width,
    int? height,
    int? minWidth,
    int? minHeight,
    int? maxWidth,
    int? maxHeight,
  }) {
    return WidgetSize(
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }
}

// Data Source Configuration
class DataSourceConfig {
  final DataSourceType type;
  final String? tableName;
  final String? apiEndpoint;
  final Map<String, dynamic>? query;
  final List<String>? fields;
  final Map<String, dynamic>? filters;
  final String? aggregation;
  final String? groupBy;
  final String? orderBy;
  final int? limit;
  final bool realtime;
  final int? cacheMinutes;

  const DataSourceConfig({
    required this.type,
    this.tableName,
    this.apiEndpoint,
    this.query,
    this.fields,
    this.filters,
    this.aggregation,
    this.groupBy,
    this.orderBy,
    this.limit,
    this.realtime = false,
    this.cacheMinutes,
  });

  DataSourceConfig copyWith({
    DataSourceType? type,
    String? tableName,
    String? apiEndpoint,
    Map<String, dynamic>? query,
    List<String>? fields,
    Map<String, dynamic>? filters,
    String? aggregation,
    String? groupBy,
    String? orderBy,
    int? limit,
    bool? realtime,
    int? cacheMinutes,
  }) {
    return DataSourceConfig(
      type: type ?? this.type,
      tableName: tableName ?? this.tableName,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      query: query ?? this.query,
      fields: fields ?? this.fields,
      filters: filters ?? this.filters,
      aggregation: aggregation ?? this.aggregation,
      groupBy: groupBy ?? this.groupBy,
      orderBy: orderBy ?? this.orderBy,
      limit: limit ?? this.limit,
      realtime: realtime ?? this.realtime,
      cacheMinutes: cacheMinutes ?? this.cacheMinutes,
    );
  }
}

enum DataSourceType {
  database,
  api,
  calculated,
  manual,
  external,
}

// Visualization Configuration
class VisualizationConfig {
  final ChartConfig? chartConfig;
  final ColorScheme? colorScheme;
  final String? numberFormat;
  final String? dateFormat;
  final bool? showLegend;
  final bool? showGrid;
  final bool? showTooltip;
  final Map<String, dynamic>? customStyles;

  const VisualizationConfig({
    this.chartConfig,
    this.colorScheme,
    this.numberFormat,
    this.dateFormat,
    this.showLegend,
    this.showGrid,
    this.showTooltip,
    this.customStyles,
  });

  VisualizationConfig copyWith({
    ChartConfig? chartConfig,
    ColorScheme? colorScheme,
    String? numberFormat,
    String? dateFormat,
    bool? showLegend,
    bool? showGrid,
    bool? showTooltip,
    Map<String, dynamic>? customStyles,
  }) {
    return VisualizationConfig(
      chartConfig: chartConfig ?? this.chartConfig,
      colorScheme: colorScheme ?? this.colorScheme,
      numberFormat: numberFormat ?? this.numberFormat,
      dateFormat: dateFormat ?? this.dateFormat,
      showLegend: showLegend ?? this.showLegend,
      showGrid: showGrid ?? this.showGrid,
      showTooltip: showTooltip ?? this.showTooltip,
      customStyles: customStyles ?? this.customStyles,
    );
  }
}

// Chart Configuration
class ChartConfig {
  final String? xAxis;
  final String? yAxis;
  final List<String>? series;
  final String? chartType;
  final bool? stacked;
  final bool? smooth;
  final double? opacity;
  final Map<String, dynamic>? advanced;

  const ChartConfig({
    this.xAxis,
    this.yAxis,
    this.series,
    this.chartType,
    this.stacked,
    this.smooth,
    this.opacity,
    this.advanced,
  });

  ChartConfig copyWith({
    String? xAxis,
    String? yAxis,
    List<String>? series,
    String? chartType,
    bool? stacked,
    bool? smooth,
    double? opacity,
    Map<String, dynamic>? advanced,
  }) {
    return ChartConfig(
      xAxis: xAxis ?? this.xAxis,
      yAxis: yAxis ?? this.yAxis,
      series: series ?? this.series,
      chartType: chartType ?? this.chartType,
      stacked: stacked ?? this.stacked,
      smooth: smooth ?? this.smooth,
      opacity: opacity ?? this.opacity,
      advanced: advanced ?? this.advanced,
    );
  }
}

// Layout Configuration
class LayoutConfiguration {
  final String type;
  final int gridSize;
  final bool snapToGrid;
  final int columns;
  final int minRows;
  final bool responsive;
  final Map<String, dynamic>? breakpoints;

  const LayoutConfiguration({
    this.type = 'grid',
    this.gridSize = 10,
    this.snapToGrid = true,
    this.columns = 12,
    this.minRows = 8,
    this.responsive = true,
    this.breakpoints,
  });

  LayoutConfiguration copyWith({
    String? type,
    int? gridSize,
    bool? snapToGrid,
    int? columns,
    int? minRows,
    bool? responsive,
    Map<String, dynamic>? breakpoints,
  }) {
    return LayoutConfiguration(
      type: type ?? this.type,
      gridSize: gridSize ?? this.gridSize,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      columns: columns ?? this.columns,
      minRows: minRows ?? this.minRows,
      responsive: responsive ?? this.responsive,
      breakpoints: breakpoints ?? this.breakpoints,
    );
  }
}

// Global Filters
class GlobalFilter {
  final String id;
  final String field;
  final FilterOperator operator;
  final dynamic value;
  final String? label;
  final bool isActive;

  const GlobalFilter({
    required this.id,
    required this.field,
    required this.operator,
    this.value,
    this.label,
    this.isActive = true,
  });

  GlobalFilter copyWith({
    String? id,
    String? field,
    FilterOperator? operator,
    dynamic value,
    String? label,
    bool? isActive,
  }) {
    return GlobalFilter(
      id: id ?? this.id,
      field: field ?? this.field,
      operator: operator ?? this.operator,
      value: value ?? this.value,
      label: label ?? this.label,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum FilterOperator {
  equals,
  notEquals,
  contains,
  notContains,
  greaterThan,
  lessThan,
  between,
  inList,
  notInList,
  isNull,
  isNotNull,
}

// Refresh Configuration
class RefreshConfig {
  final bool enabled;
  final int intervalMinutes;
  final DateTime? lastRefresh;
  final bool showIndicator;

  const RefreshConfig({
    this.enabled = false,
    this.intervalMinutes = 5,
    this.lastRefresh,
    this.showIndicator = false,
  });

  RefreshConfig copyWith({
    bool? enabled,
    int? intervalMinutes,
    DateTime? lastRefresh,
    bool? showIndicator,
  }) {
    return RefreshConfig(
      enabled: enabled ?? this.enabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      lastRefresh: lastRefresh ?? this.lastRefresh,
      showIndicator: showIndicator ?? this.showIndicator,
    );
  }
}

// Share Configuration
class ShareConfig {
  final bool isPublic;
  final List<String> sharedWith;
  final String defaultPermission;
  final String? shareLink;
  final DateTime? linkExpiry;

  const ShareConfig({
    this.isPublic = false,
    this.sharedWith = const [],
    this.defaultPermission = 'view',
    this.shareLink,
    this.linkExpiry,
  });

  ShareConfig copyWith({
    bool? isPublic,
    List<String>? sharedWith,
    String? defaultPermission,
    String? shareLink,
    DateTime? linkExpiry,
  }) {
    return ShareConfig(
      isPublic: isPublic ?? this.isPublic,
      sharedWith: sharedWith ?? this.sharedWith,
      defaultPermission: defaultPermission ?? this.defaultPermission,
      shareLink: shareLink ?? this.shareLink,
      linkExpiry: linkExpiry ?? this.linkExpiry,
    );
  }
}

// Alert Rules
class AlertRule {
  final String id;
  final String name;
  final AlertCondition condition;
  final AlertAction action;
  final bool isActive;
  final DateTime? lastTriggered;

  const AlertRule({
    required this.id,
    required this.name,
    required this.condition,
    required this.action,
    this.isActive = true,
    this.lastTriggered,
  });

  AlertRule copyWith({
    String? id,
    String? name,
    AlertCondition? condition,
    AlertAction? action,
    bool? isActive,
    DateTime? lastTriggered,
  }) {
    return AlertRule(
      id: id ?? this.id,
      name: name ?? this.name,
      condition: condition ?? this.condition,
      action: action ?? this.action,
      isActive: isActive ?? this.isActive,
      lastTriggered: lastTriggered ?? this.lastTriggered,
    );
  }
}

// Alert Condition
class AlertCondition {
  final String metric;
  final FilterOperator operator;
  final dynamic threshold;
  final int? duration;
  final String? aggregation;

  const AlertCondition({
    required this.metric,
    required this.operator,
    required this.threshold,
    this.duration,
    this.aggregation,
  });

  AlertCondition copyWith({
    String? metric,
    FilterOperator? operator,
    dynamic threshold,
    int? duration,
    String? aggregation,
  }) {
    return AlertCondition(
      metric: metric ?? this.metric,
      operator: operator ?? this.operator,
      threshold: threshold ?? this.threshold,
      duration: duration ?? this.duration,
      aggregation: aggregation ?? this.aggregation,
    );
  }
}

// Alert Action
class AlertAction {
  final AlertActionType type;
  final String? recipient;
  final String? message;
  final Map<String, dynamic>? payload;

  const AlertAction({
    required this.type,
    this.recipient,
    this.message,
    this.payload,
  });

  AlertAction copyWith({
    AlertActionType? type,
    String? recipient,
    String? message,
    Map<String, dynamic>? payload,
  }) {
    return AlertAction(
      type: type ?? this.type,
      recipient: recipient ?? this.recipient,
      message: message ?? this.message,
      payload: payload ?? this.payload,
    );
  }
}

enum AlertActionType {
  notification,
  email,
  sms,
  webhook,
  log,
}

// Custom Metric
class CustomMetric {
  final String id;
  final String name;
  final String? description;
  final String formula;
  final List<DataInput> dataInputs;
  final MetricThresholds thresholds;
  final MetricVisualization visualization;
  final List<AlertRule> alerts;

  const CustomMetric({
    required this.id,
    required this.name,
    this.description,
    required this.formula,
    required this.dataInputs,
    required this.thresholds,
    required this.visualization,
    this.alerts = const [],
  });

  CustomMetric copyWith({
    String? id,
    String? name,
    String? description,
    String? formula,
    List<DataInput>? dataInputs,
    MetricThresholds? thresholds,
    MetricVisualization? visualization,
    List<AlertRule>? alerts,
  }) {
    return CustomMetric(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      formula: formula ?? this.formula,
      dataInputs: dataInputs ?? this.dataInputs,
      thresholds: thresholds ?? this.thresholds,
      visualization: visualization ?? this.visualization,
      alerts: alerts ?? this.alerts,
    );
  }
}

// Data Input
class DataInput {
  final String field;
  final String source;
  final String? alias;
  final Map<String, dynamic>? transform;

  const DataInput({
    required this.field,
    required this.source,
    this.alias,
    this.transform,
  });

  DataInput copyWith({
    String? field,
    String? source,
    String? alias,
    Map<String, dynamic>? transform,
  }) {
    return DataInput(
      field: field ?? this.field,
      source: source ?? this.source,
      alias: alias ?? this.alias,
      transform: transform ?? this.transform,
    );
  }
}

// Metric Thresholds
class MetricThresholds {
  final double? excellent;
  final double? good;
  final double? warning;
  final double? critical;

  const MetricThresholds({
    this.excellent,
    this.good,
    this.warning,
    this.critical,
  });

  MetricThresholds copyWith({
    double? excellent,
    double? good,
    double? warning,
    double? critical,
  }) {
    return MetricThresholds(
      excellent: excellent ?? this.excellent,
      good: good ?? this.good,
      warning: warning ?? this.warning,
      critical: critical ?? this.critical,
    );
  }
}

// Metric Visualization
class MetricVisualization {
  final String type;
  final String? format;
  final String? prefix;
  final String? suffix;
  final int? decimals;
  final ColorMapping? colorMapping;

  const MetricVisualization({
    this.type = 'number',
    this.format,
    this.prefix,
    this.suffix,
    this.decimals,
    this.colorMapping,
  });

  MetricVisualization copyWith({
    String? type,
    String? format,
    String? prefix,
    String? suffix,
    int? decimals,
    ColorMapping? colorMapping,
  }) {
    return MetricVisualization(
      type: type ?? this.type,
      format: format ?? this.format,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      decimals: decimals ?? this.decimals,
      colorMapping: colorMapping ?? this.colorMapping,
    );
  }
}

// Color Mapping
class ColorMapping {
  final String? excellent;
  final String? good;
  final String? warning;
  final String? critical;
  final String? defaultColor;

  const ColorMapping({
    this.excellent,
    this.good,
    this.warning,
    this.critical,
    this.defaultColor,
  });

  ColorMapping copyWith({
    String? excellent,
    String? good,
    String? warning,
    String? critical,
    String? defaultColor,
  }) {
    return ColorMapping(
      excellent: excellent ?? this.excellent,
      good: good ?? this.good,
      warning: warning ?? this.warning,
      critical: critical ?? this.critical,
      defaultColor: defaultColor ?? this.defaultColor,
    );
  }
}

// User Preferences
class UserPreferences {
  final String userId;
  final String? defaultDashboardId;
  final String colorScheme;
  final String numberFormat;
  final String timezone;
  final String language;
  final AlertPreferences? alertPreferences;
  final List<CustomMetric> customMetrics;
  final List<SavedView> savedViews;
  final Map<String, dynamic>? advanced;

  const UserPreferences({
    required this.userId,
    this.defaultDashboardId,
    this.colorScheme = 'light',
    this.numberFormat = 'US',
    this.timezone = 'UTC',
    this.language = 'en',
    this.alertPreferences,
    this.customMetrics = const [],
    this.savedViews = const [],
    this.advanced,
  });

  UserPreferences copyWith({
    String? userId,
    String? defaultDashboardId,
    String? colorScheme,
    String? numberFormat,
    String? timezone,
    String? language,
    AlertPreferences? alertPreferences,
    List<CustomMetric>? customMetrics,
    List<SavedView>? savedViews,
    Map<String, dynamic>? advanced,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      defaultDashboardId: defaultDashboardId ?? this.defaultDashboardId,
      colorScheme: colorScheme ?? this.colorScheme,
      numberFormat: numberFormat ?? this.numberFormat,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      alertPreferences: alertPreferences ?? this.alertPreferences,
      customMetrics: customMetrics ?? this.customMetrics,
      savedViews: savedViews ?? this.savedViews,
      advanced: advanced ?? this.advanced,
    );
  }
}

// Alert Preferences
class AlertPreferences {
  final bool enabled;
  final bool email;
  final bool sms;
  final bool inApp;
  final String level;
  final List<String>? mutedAlerts;

  const AlertPreferences({
    this.enabled = true,
    this.email = true,
    this.sms = false,
    this.inApp = true,
    this.level = 'all',
    this.mutedAlerts,
  });

  AlertPreferences copyWith({
    bool? enabled,
    bool? email,
    bool? sms,
    bool? inApp,
    String? level,
    List<String>? mutedAlerts,
  }) {
    return AlertPreferences(
      enabled: enabled ?? this.enabled,
      email: email ?? this.email,
      sms: sms ?? this.sms,
      inApp: inApp ?? this.inApp,
      level: level ?? this.level,
      mutedAlerts: mutedAlerts ?? this.mutedAlerts,
    );
  }
}

// Saved View
class SavedView {
  final String id;
  final String name;
  final String dashboardId;
  final List<GlobalFilter> filters;
  final Map<String, dynamic>? settings;
  final DateTime? createdAt;

  const SavedView({
    required this.id,
    required this.name,
    required this.dashboardId,
    required this.filters,
    this.settings,
    this.createdAt,
  });

  SavedView copyWith({
    String? id,
    String? name,
    String? dashboardId,
    List<GlobalFilter>? filters,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
  }) {
    return SavedView(
      id: id ?? this.id,
      name: name ?? this.name,
      dashboardId: dashboardId ?? this.dashboardId,
      filters: filters ?? this.filters,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Widget Template
class WidgetTemplate {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String? icon;
  final WidgetType type;
  final WidgetSize defaultSize;
  final Map<String, dynamic>? defaultConfig;
  final List<String>? requiredDataFields;
  final List<String>? tags;

  const WidgetTemplate({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.icon,
    required this.type,
    required this.defaultSize,
    this.defaultConfig,
    this.requiredDataFields,
    this.tags,
  });

  WidgetTemplate copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? icon,
    WidgetType? type,
    WidgetSize? defaultSize,
    Map<String, dynamic>? defaultConfig,
    List<String>? requiredDataFields,
    List<String>? tags,
  }) {
    return WidgetTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      defaultSize: defaultSize ?? this.defaultSize,
      defaultConfig: defaultConfig ?? this.defaultConfig,
      requiredDataFields: requiredDataFields ?? this.requiredDataFields,
      tags: tags ?? this.tags,
    );
  }
}

// Dashboard Template
class DashboardTemplate {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String? thumbnail;
  final List<DashboardWidget> widgets;
  final LayoutConfiguration layout;
  final List<GlobalFilter>? defaultFilters;
  final List<String>? tags;
  final int useCount;

  const DashboardTemplate({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.thumbnail,
    required this.widgets,
    required this.layout,
    this.defaultFilters,
    this.tags,
    this.useCount = 0,
  });

  DashboardTemplate copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? thumbnail,
    List<DashboardWidget>? widgets,
    LayoutConfiguration? layout,
    List<GlobalFilter>? defaultFilters,
    List<String>? tags,
    int? useCount,
  }) {
    return DashboardTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      widgets: widgets ?? this.widgets,
      layout: layout ?? this.layout,
      defaultFilters: defaultFilters ?? this.defaultFilters,
      tags: tags ?? this.tags,
      useCount: useCount ?? this.useCount,
    );
  }
}