# Inventory Analysis Dashboard

## Overview

A flexible, user-configurable analytics dashboard for supply chain and inventory management. Users can create custom dashboards with drag-and-drop widgets, define their own metrics, and organize information based on their specific needs.

## Route

```
/inventoryAnalysis
```

## Key Features

### 1. User-Configurable Dashboard
- **Widget-Based Architecture**: Modular components that users can add, remove, and arrange
- **Drag-and-Drop Interface**: Easy customization without technical knowledge
- **Multiple Dashboard Support**: Create and save different dashboard configurations
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

### 2. Widget Catalog
Available widget types:
- **Metrics**: Key metrics, trend indicators, custom KPIs
- **Charts**: Line, bar, pie, heat maps, gauges
- **Tables**: Data tables with sorting and filtering
- **Alerts**: Real-time alert feeds
- **Controls**: Action panels, filter controls
- **Custom**: Text notes, images, custom widgets

### 3. Personalization Features
- **Custom Metrics**: Users can define their own formulas and calculations
- **Flexible Data Sources**: Connect to multiple data sources (database, API, manual entry)
- **Personal Preferences**: Theme, number format, timezone, language settings
- **Saved Views**: Save and share dashboard configurations

### 4. Edit Mode
- **Visual Editing**: Toggle edit mode to modify dashboard layout
- **Widget Configuration**: Configure data sources, visualization options, and alerts
- **Grid System**: Snap-to-grid for precise widget placement
- **Real-time Preview**: See changes immediately

## File Structure

```
inventory_analysis/
├── inventory_analysis_page.dart    # Main page component
├── models/
│   └── dashboard_model.dart       # Data models (Dashboard, Widget, etc.)
├── providers/
│   └── dashboard_provider.dart    # State management
├── widgets/
│   ├── dashboard_canvas.dart      # Main dashboard canvas
│   ├── dashboard_toolbar.dart     # Toolbar with filters and settings
│   ├── widget_catalog.dart        # Widget selection catalog
│   └── widget_renderer.dart       # Widget rendering logic
└── README.md                       # This file
```

## Data Models

### UserDashboard
- Dashboard configuration with widgets, layout, filters, and settings
- Support for multiple dashboards per user
- Share settings for collaboration

### DashboardWidget
- Individual widget configuration
- Position, size, data source, visualization settings
- Custom settings based on widget type

### CustomMetric
- User-defined metrics with formulas
- Data inputs and thresholds
- Visualization preferences

## Usage

### Creating a Dashboard
1. Navigate to `/inventoryAnalysis`
2. Click "Edit" button to enter edit mode
3. Click "Add Widget" to open widget catalog
4. Select widgets to add to dashboard
5. Configure widget data sources and settings
6. Save dashboard configuration

### Widget Configuration
- Click widget settings icon in edit mode
- Configure data source (database, API, manual)
- Set visualization options (colors, format, etc.)
- Define alerts and thresholds
- Save widget configuration

### Sharing Dashboards
- Click share button in toolbar
- Options:
  - Copy link for read-only access
  - Share with team members
  - Make public within organization

## Key Differences from Original Design

### User-Driven vs Prescriptive
- **Original**: Fixed 3-level hierarchy with predefined personas (CEO, Purchasing, Store Manager)
- **New**: Flexible system where users create their own views

### Information Architecture
- **Original**: Progressive disclosure (Overview → Detail → Action)
- **New**: User-defined organization with customizable widgets

### Personalization
- **Original**: Role-based dashboards
- **New**: Individual preferences and custom metrics

### Flexibility
- **Original**: Static layouts and predetermined metrics
- **New**: Drag-and-drop interface with user-defined KPIs

## Integration Points

### With Existing Inventory Management
- Shares data models (`Product`, `InventoryCount`)
- Can display inventory data in widgets
- Links to detailed inventory pages

### With Homepage
- Can be accessed from Quick Access section
- Dashboard summaries can appear on homepage

### With Other Features
- Transaction history integration
- Sales invoice data visualization
- Cash flow analysis widgets

## Future Enhancements

1. **Advanced Analytics**
   - Machine learning predictions
   - Anomaly detection
   - Trend analysis

2. **Collaboration Features**
   - Real-time collaboration
   - Comments and annotations
   - Team workspaces

3. **Automation**
   - Automated alerts
   - Scheduled reports
   - Workflow triggers

4. **Mobile Enhancements**
   - Native mobile widgets
   - Offline support
   - Push notifications

## Technical Notes

- Built with Flutter and Riverpod for state management
- Uses fl_chart for data visualization
- Supports real-time data updates
- Implements responsive design patterns
- Follows Toss design system guidelines