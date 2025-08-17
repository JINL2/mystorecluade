import 'package:flutter/material.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';

/// A reusable tab bar component following the Toss design system.
/// 
/// Example usage:
/// ```dart
/// TossTabBar(
///   tabs: ['Cash', 'Bank', 'Vault'],
///   onTabChanged: (index) => print('Selected tab: $index'),
/// )
/// ```
class TossTabBar extends StatefulWidget {
  /// List of tab labels to display
  final List<String> tabs;
  
  /// Callback when tab selection changes
  final ValueChanged<int>? onTabChanged;
  
  /// Initial selected tab index
  final int initialIndex;
  
  /// Custom text style for selected tab
  final TextStyle? selectedLabelStyle;
  
  /// Custom text style for unselected tabs
  final TextStyle? unselectedLabelStyle;
  
  /// Color for the selected tab label and indicator
  final Color? selectedColor;
  
  /// Color for unselected tab labels
  final Color? unselectedColor;
  
  /// Height of the indicator line
  final double indicatorHeight;
  
  /// Horizontal padding for the tab bar
  final EdgeInsetsGeometry? padding;
  
  /// Whether to expand tabs to fill available width
  final bool isScrollable;
  
  /// External tab controller (optional)
  final TabController? controller;

  const TossTabBar({
    super.key,
    required this.tabs,
    this.onTabChanged,
    this.initialIndex = 0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorHeight = 2.0,
    this.padding,
    this.isScrollable = false,
    this.controller,
  });

  @override
  State<TossTabBar> createState() => _TossTabBarState();
}

class _TossTabBarState extends State<TossTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TabController? _internalController;
  
  TabController get _effectiveController => widget.controller ?? _internalController!;
  
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.initialIndex,
      );
      _tabController = _internalController!;
    } else {
      _tabController = widget.controller!;
    }
    
    _tabController.addListener(_handleTabChange);
  }
  
  @override
  void didUpdateWidget(TossTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update controller if external controller changed
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null && _internalController != null) {
        _internalController!.removeListener(_handleTabChange);
      }
      
      if (widget.controller == null) {
        _internalController = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: widget.initialIndex,
        );
        _tabController = _internalController!;
      } else {
        _tabController = widget.controller!;
      }
      
      _tabController.addListener(_handleTabChange);
    }
    
    // Update tabs length if changed
    if (widget.tabs.length != oldWidget.tabs.length) {
      if (_internalController != null) {
        final previousIndex = _internalController!.index;
        _internalController!.removeListener(_handleTabChange);
        _internalController!.dispose();
        _internalController = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: previousIndex.clamp(0, widget.tabs.length - 1),
        );
        _tabController = _internalController!;
        _tabController.addListener(_handleTabChange);
      }
    }
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _internalController?.dispose();
    super.dispose();
  }
  
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      widget.onTabChanged?.call(_tabController.index);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final selectedColor = widget.selectedColor ?? Colors.black87;
    final unselectedColor = widget.unselectedColor ?? Colors.grey[400]!;
    
    final selectedStyle = widget.selectedLabelStyle ?? 
      TossTextStyles.body.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 17,
      );
      
    final unselectedStyle = widget.unselectedLabelStyle ?? 
      TossTextStyles.body.copyWith(
        fontSize: 17,
      );
    
    return Container(
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: widget.isScrollable,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: widget.indicatorHeight,
              color: selectedColor,
            ),
            insets: EdgeInsets.zero,
          ),
          indicatorColor: selectedColor,
          labelColor: selectedColor,
          unselectedLabelColor: unselectedColor,
          labelStyle: selectedStyle,
          unselectedLabelStyle: unselectedStyle,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
    );
  }
}

/// A widget that combines TossTabBar with TabBarView for complete tab functionality.
/// 
/// Example usage:
/// ```dart
/// TossTabBarView(
///   tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
///   children: [
///     Container(child: Text('Content 1')),
///     Container(child: Text('Content 2')),
///     Container(child: Text('Content 3')),
///   ],
///   onTabChanged: (index) => print('Selected tab: $index'),
/// )
/// ```
class TossTabBarView extends StatefulWidget {
  /// List of tab labels
  final List<String> tabs;
  
  /// List of widgets to display for each tab
  final List<Widget> children;
  
  /// Callback when tab selection changes
  final ValueChanged<int>? onTabChanged;
  
  /// Initial selected tab index
  final int initialIndex;
  
  /// Custom text style for selected tab
  final TextStyle? selectedLabelStyle;
  
  /// Custom text style for unselected tabs
  final TextStyle? unselectedLabelStyle;
  
  /// Color for the selected tab label and indicator
  final Color? selectedColor;
  
  /// Color for unselected tab labels
  final Color? unselectedColor;
  
  /// Height of the indicator line
  final double indicatorHeight;
  
  /// Horizontal padding for the tab bar
  final EdgeInsetsGeometry? tabBarPadding;
  
  /// Whether to expand tabs to fill available width
  final bool isScrollable;
  
  /// Whether the TabBarView should be scrollable
  final ScrollPhysics? physics;

  const TossTabBarView({
    super.key,
    required this.tabs,
    required this.children,
    this.onTabChanged,
    this.initialIndex = 0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorHeight = 2.0,
    this.tabBarPadding,
    this.isScrollable = false,
    this.physics,
  }) : assert(tabs.length == children.length, 'tabs and children must have the same length');

  @override
  State<TossTabBarView> createState() => _TossTabBarViewState();
}

class _TossTabBarViewState extends State<TossTabBarView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }
  
  @override
  void didUpdateWidget(TossTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.tabs.length != oldWidget.tabs.length) {
      final previousIndex = _tabController.index;
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: previousIndex.clamp(0, widget.tabs.length - 1),
      );
      
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          widget.onTabChanged?.call(_tabController.index);
        }
      });
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TossTabBar(
          tabs: widget.tabs,
          controller: _tabController,
          selectedLabelStyle: widget.selectedLabelStyle,
          unselectedLabelStyle: widget.unselectedLabelStyle,
          selectedColor: widget.selectedColor,
          unselectedColor: widget.unselectedColor,
          indicatorHeight: widget.indicatorHeight,
          padding: widget.tabBarPadding,
          isScrollable: widget.isScrollable,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: widget.physics,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}