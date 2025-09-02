import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dashboard_model.dart';
import '../../../../core/themes/index.dart';

class WidgetRenderer extends StatelessWidget {
  final DashboardWidget widget;
  final bool isMobile;
  
  const WidgetRenderer({
    super.key,
    required this.widget,
    this.isMobile = false,
  });
  
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case WidgetType.metricCard:
        return _MetricCardWidget(widget: widget);
      case WidgetType.lineChart:
        return _LineChartWidget(widget: widget);
      case WidgetType.barChart:
        return _BarChartWidget(widget: widget);
      case WidgetType.pieChart:
        return _PieChartWidget(widget: widget);
      case WidgetType.table:
        return _TableWidget(widget: widget);
      case WidgetType.heatMap:
        return _HeatMapWidget(widget: widget);
      case WidgetType.gauge:
        return _GaugeWidget(widget: widget);
      case WidgetType.alertFeed:
        return _AlertFeedWidget(widget: widget);
      case WidgetType.actionPanel:
        return _ActionPanelWidget(widget: widget);
      case WidgetType.customKpi:
        return _CustomKpiWidget(widget: widget);
      case WidgetType.comparison:
        return _ComparisonWidget(widget: widget);
      case WidgetType.trendIndicator:
        return _TrendIndicatorWidget(widget: widget);
      case WidgetType.filterControl:
        return _FilterControlWidget(widget: widget);
      case WidgetType.textNote:
        return _TextNoteWidget(widget: widget);
      case WidgetType.image:
        return _ImageWidget(widget: widget);
    }
  }
}

// Metric Card Widget
class _MetricCardWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _MetricCardWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    // Sample data - replace with actual data from widget.dataSource
    final value = '₩15.2M';
    final label = widget.title;
    final change = '+12.5%';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Text(
          value,
          style: TossTextStyles.h2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: TossSpacing.space1),
        Container(
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1 / 2),
          decoration: BoxDecoration(
            color: TossColors.successLight,
            borderRadius: BorderRadius.circular(TossBorderRadius.badge),
          ),
          child: Text(
            change,
            style: TossTextStyles.label.copyWith(
              color: TossColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Line Chart Widget
class _LineChartWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _LineChartWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: widget.data?.cast<FlSpot>() ?? [],
                  isCurved: true,
                  color: TossColors.primary,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: TossColors.primarySurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
}

// Bar Chart Widget
class _BarChartWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _BarChartWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        Expanded(
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: _generateBarData(context),
            ),
          ),
        ),
      ],
    );
  }
  
  List<BarChartGroupData> _generateBarData(BuildContext context) {
    return List.generate(5, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: math.Random().nextDouble() * 100,
            color: TossColors.primary,
            width: 20,
            borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.badge)),
          ),
        ],
      );
    });
  }
}

// Pie Chart Widget
class _PieChartWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _PieChartWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: _generatePieData(),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }
  
  List<PieChartSectionData> _generatePieData() {
    final colors = [
      TossColors.primary,
      TossColors.error,
      TossColors.success,
      TossColors.warning,
      TossColors.info,
    ];
    
    return List.generate(5, (index) {
      final value = math.Random().nextDouble() * 100;
      return PieChartSectionData(
        value: value,
        title: '${value.toInt()}%',
        color: colors[index % colors.length],
        radius: 50,
        titleStyle: TossTextStyles.label.copyWith(
          fontWeight: FontWeight.bold,
          color: TossColors.textInverse,
        ),
      );
    });
  }
}

// Table Widget
class _TableWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _TableWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    // Sample data
    final headers = ['Product', 'Stock', 'Status'];
    final rows = [
      ['Wallet C', '15', '🔴 Critical'],
      ['Bag A', '45', '🟡 Low'],
      ['Belt G', '120', '🟢 Good'],
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: headers.map((h) => DataColumn(label: Text(h))).toList(),
              rows: rows.map((row) {
                return DataRow(
                  cells: row.map((cell) => DataCell(Text(cell))).toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// Heat Map Widget (Simplified)
class _HeatMapWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _HeatMapWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: 25,
            itemBuilder: (context, index) {
              final intensity = math.Random().nextDouble();
              return Container(
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: intensity),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Gauge Widget
class _GaugeWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _GaugeWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    final value = 75.0;
    final max = 100.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: value / max,
                    strokeWidth: 12,
                    backgroundColor: TossColors.gray300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getGaugeColor(value, max),
                    ),
                  ),
                ),
                Text(
                  '${value.toInt()}%',
                  style: TossTextStyles.h3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getGaugeColor(double value, double max) {
    final percentage = value / max;
    if (percentage >= 0.8) return TossColors.success;
    if (percentage >= 0.6) return TossColors.warning;
    return TossColors.error;
  }
}

// Alert Feed Widget
class _AlertFeedWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _AlertFeedWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    final alerts = [
      {'level': 'critical', 'message': 'Wallet C supply delayed 15 days'},
      {'level': 'warning', 'message': 'Bag A stock running low'},
      {'level': 'info', 'message': 'New supplier available for Belt G'},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        Expanded(
          child: ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return Card(
                margin: EdgeInsets.only(bottom: TossSpacing.space2),
                child: ListTile(
                  leading: Icon(
                    Icons.warning,
                    color: _getAlertColor(alert['level']!),
                  ),
                  title: Text(alert['message']!),
                  subtitle: Text('2 hours ago'),
                  dense: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Color _getAlertColor(String level) {
    switch (level) {
      case 'critical':
        return TossColors.error;
      case 'warning':
        return TossColors.warning;
      default:
        return TossColors.info;
    }
  }
}

// Action Panel Widget
class _ActionPanelWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _ActionPanelWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('New Order'),
              onPressed: () {},
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              onPressed: () {},
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Export'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

// Other widget implementations...
class _CustomKpiWidget extends _MetricCardWidget {
  const _CustomKpiWidget({required super.widget});
}

class _ComparisonWidget extends _BarChartWidget {
  const _ComparisonWidget({required super.widget});
}

class _TrendIndicatorWidget extends _MetricCardWidget {
  const _TrendIndicatorWidget({required super.widget});
}

class _FilterControlWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _FilterControlWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: TossSpacing.space4),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
          ),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Products')),
            DropdownMenuItem(value: 'critical', child: Text('Critical Only')),
            DropdownMenuItem(value: 'warning', child: Text('Warnings')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}

class _TextNoteWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _TextNoteWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          widget.customSettings['text'] ?? 'Add your notes here...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final DashboardWidget widget;
  
  const _ImageWidget({required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Text(
            widget.title,
            style: TossTextStyles.h4,
          ),
          SizedBox(height: TossSpacing.space2),
        ],
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: TossSpacing.iconXL + TossSpacing.space2,
                color: TossColors.gray500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}