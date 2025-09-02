import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../models/dashboard_model.dart';
import 'widget_renderer.dart';
import 'empty_state.dart';

class DashboardCanvas extends ConsumerWidget {
  final UserDashboard dashboard;
  final bool isEditMode;
  final bool isMobile;
  final Function(String, DashboardWidget) onWidgetUpdate;
  final Function(String) onWidgetRemove;
  final Function(String, WidgetSize) onWidgetResize;
  final Function(String, WidgetPosition) onWidgetMove;
  final VoidCallback? onEnableEditMode;
  final VoidCallback? onViewSampleDashboard;
  
  const DashboardCanvas({
    super.key,
    required this.dashboard,
    required this.isEditMode,
    this.isMobile = false,
    required this.onWidgetUpdate,
    required this.onWidgetRemove,
    required this.onWidgetResize,
    required this.onWidgetMove,
    this.onEnableEditMode,
    this.onViewSampleDashboard,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (dashboard.widgets.isEmpty) {
      return _buildEmptyState(context);
    }
    
    if (isMobile) {
      return _buildMobileLayout(context);
    }
    
    return _buildGridLayout(context);
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      onGetStarted: onEnableEditMode ?? () {},
      onViewSample: onViewSampleDashboard ?? () {},
      onEditMode: onEnableEditMode ?? () {},
      isMobile: isMobile,
    );
  }
  
  Widget _buildGridLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gridSize = dashboard.layout.gridSize;
        final columns = dashboard.layout.columns;
        final cellWidth = constraints.maxWidth / columns;
        
        return Stack(
          children: [
            // Grid background (only in edit mode)
            if (isEditMode) _buildGridBackground(constraints, gridSize),
            
            // Widgets
            ...dashboard.widgets.map((widget) {
              return _buildPositionedWidget(
                widget,
                cellWidth,
                gridSize,
              );
            }).toList(),
          ],
        );
      },
    );
  }
  
  Widget _buildMobileLayout(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.paddingMD),
      itemCount: dashboard.widgets.length,
      itemBuilder: (context, index) {
        final widget = dashboard.widgets[index];
        return Padding(
          padding: EdgeInsets.only(bottom: TossSpacing.paddingMD),
          child: _buildMobileWidget(widget),
        );
      },
    );
  }
  
  Widget _buildGridBackground(BoxConstraints constraints, int gridSize) {
    return CustomPaint(
      size: Size(constraints.maxWidth, constraints.maxHeight),
      painter: GridPainter(gridSize: gridSize.toDouble()),
    );
  }
  
  Widget _buildPositionedWidget(
    DashboardWidget widget,
    double cellWidth,
    int gridSize,
  ) {
    final left = widget.position.x * cellWidth;
    final top = widget.position.y * gridSize.toDouble();
    final width = widget.size.width * cellWidth;
    final height = widget.size.height * gridSize.toDouble();
    
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: _WidgetContainer(
        widget: widget,
        isEditMode: isEditMode,
        onUpdate: (updated) => onWidgetUpdate(widget.id, updated),
        onRemove: () => onWidgetRemove(widget.id),
        onResize: (size) => onWidgetResize(widget.id, size),
        onMove: (position) => onWidgetMove(widget.id, position),
      ),
    );
  }
  
  Widget _buildMobileWidget(DashboardWidget widget) {
    return _WidgetContainer(
      widget: widget,
      isEditMode: isEditMode,
      isMobile: true,
      onUpdate: (updated) => onWidgetUpdate(widget.id, updated),
      onRemove: () => onWidgetRemove(widget.id),
      onResize: (size) => onWidgetResize(widget.id, size),
      onMove: (position) => onWidgetMove(widget.id, position),
    );
  }
}

class _WidgetContainer extends StatefulWidget {
  final DashboardWidget widget;
  final bool isEditMode;
  final bool isMobile;
  final Function(DashboardWidget) onUpdate;
  final VoidCallback onRemove;
  final Function(WidgetSize) onResize;
  final Function(WidgetPosition) onMove;
  
  const _WidgetContainer({
    required this.widget,
    required this.isEditMode,
    this.isMobile = false,
    required this.onUpdate,
    required this.onRemove,
    required this.onResize,
    required this.onMove,
  });
  
  @override
  State<_WidgetContainer> createState() => _WidgetContainerState();
}

class _WidgetContainerState extends State<_WidgetContainer> {
  bool _isHovered = false;
  bool _isDragging = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: _isHovered && widget.isEditMode
                ? Theme.of(context).primaryColor
                : TossColors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
            if (_isHovered)
              BoxShadow(
                color: TossColors.shadow.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Stack(
          children: [
            // Widget content
            Padding(
              padding: EdgeInsets.all(TossSpacing.paddingMD),
              child: WidgetRenderer(
                widget: widget.widget,
                isMobile: widget.isMobile,
              ),
            ),
            
            // Edit mode controls
            if (widget.isEditMode && (_isHovered || widget.isMobile))
              _buildEditControls(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEditControls(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          boxShadow: [
            BoxShadow(
              color: TossColors.shadow.withOpacity(0.15),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Move handle
            if (!widget.isMobile)
              InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(TossSpacing.space1),
                  child: Icon(
                    Icons.drag_indicator,
                    size: 16,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
            
            // Settings
            IconButton(
              icon: const Icon(Icons.settings, size: 16),
              padding: EdgeInsets.all(TossSpacing.space1),
              constraints: const BoxConstraints(),
              onPressed: () => _showWidgetSettings(context),
            ),
            
            // Duplicate
            IconButton(
              icon: const Icon(Icons.content_copy, size: 16),
              padding: EdgeInsets.all(TossSpacing.space1),
              constraints: const BoxConstraints(),
              onPressed: () => _duplicateWidget(),
            ),
            
            // Remove
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              padding: EdgeInsets.all(TossSpacing.space1),
              constraints: const BoxConstraints(),
              onPressed: widget.onRemove,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showWidgetSettings(BuildContext context) {
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
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(TossSpacing.paddingMD),
              child: Text(
                'Widget Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(TossSpacing.paddingMD),
                children: [
                  // Widget configuration UI
                  Text('Configure ${widget.widget.title}'),
                  // Add configuration fields based on widget type
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _duplicateWidget() {
    final duplicated = widget.widget.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: WidgetPosition(
        x: widget.widget.position.x + 1,
        y: widget.widget.position.y + 1,
      ),
    );
    widget.onUpdate(duplicated);
  }
}

// Grid painter for edit mode
class GridPainter extends CustomPainter {
  final double gridSize;
  
  GridPainter({required this.gridSize});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TossColors.gray200
      ..strokeWidth = 1;
    
    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize;
  }
}