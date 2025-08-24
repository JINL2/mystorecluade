import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
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
        fontSize: TossTextStyles.bodyLarge.fontSize!,
      );
      
    final unselectedStyle = widget.unselectedLabelStyle ?? 
      TossTextStyles.body.copyWith(
        fontSize: TossTextStyles.bodyLarge.fontSize!,
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

/// A minimal, clean tab bar component following modern design principles.
/// 
/// This creates a simple tab bar with an underline indicator
/// and clear visual hierarchy through color and weight changes.
class TossPillTabBar extends StatelessWidget {
  /// List of tab items to display
  final List<TossTabItem> tabs;
  
  /// External tab controller (required)
  final TabController controller;
  
  /// Callback when tab selection changes
  final ValueChanged<int>? onTap;
  
  /// Margin around the tab bar
  final EdgeInsets? margin;
  
  /// Height of the tab bar
  final double height;
  
  /// Color for the selected tab label and indicator
  final Color? labelColor;
  
  /// Color for unselected tab labels
  final Color? unselectedLabelColor;
  
  /// Color for the indicator
  final Color? indicatorColor;
  
  /// Text style for selected tab
  final TextStyle? labelStyle;
  
  /// Text style for unselected tabs
  final TextStyle? unselectedLabelStyle;
  
  /// Thickness of the indicator
  final double indicatorWeight;
  
  /// Whether tabs should be scrollable
  final bool isScrollable;

  const TossPillTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onTap,
    this.margin,
    this.height = 48,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicatorWeight = 3.0,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: TossSpacing.space5,
            vertical: TossSpacing.space3,
          ),
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: isScrollable,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: indicatorWeight,
            color: indicatorColor ?? TossColors.primary,
          ),
          insets: EdgeInsets.zero,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: labelColor ?? TossColors.gray900,
        unselectedLabelColor: unselectedLabelColor ?? TossColors.gray400,
        labelStyle: labelStyle ??
            TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: TossTextStyles.bodyLarge.fontSize!,
            ),
        unselectedLabelStyle: unselectedLabelStyle ??
            TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: TossTextStyles.bodyLarge.fontSize!,
            ),
        labelPadding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        tabs: tabs.map((tab) => _buildTab(tab)).toList(),
      ),
    );
  }

  Widget _buildTab(TossTabItem tab) {
    if (tab.text != null) {
      final textWidget = Text(tab.text!);
      
      if (!tab.enabled) {
        return Tab(
          child: Opacity(
            opacity: 0.4,
            child: textWidget,
          ),
        );
      }
      
      return Tab(text: tab.text);
    }
    
    if (tab.child != null) {
      if (!tab.enabled) {
        return Tab(
          child: Opacity(
            opacity: 0.4,
            child: tab.child,
          ),
        );
      }
      
      return Tab(child: tab.child);
    }
    
    if (tab.icon != null) {
      final iconWidget = Icon(tab.icon, size: 20);
      
      if (!tab.enabled) {
        return Tab(
          child: Opacity(
            opacity: 0.4,
            child: iconWidget,
          ),
        );
      }
      
      return Tab(icon: Icon(tab.icon!, size: 20));
    }
    
    return const Tab(text: '');
  }
}

/// A minimal tab bar with clean design and smooth animations
class TossMinimalTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController controller;
  final ValueChanged<int>? onTap;
  final EdgeInsets? padding;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool showDivider;
  
  const TossMinimalTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onTap,
    this.padding,
    this.selectedColor,
    this.unselectedColor,
    this.showDivider = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      decoration: showDivider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            )
          : null,
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: false,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 2.5,
            color: selectedColor ?? TossColors.primary,
          ),
          insets: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelColor: selectedColor ?? TossColors.gray900,
        unselectedLabelColor: unselectedColor ?? TossColors.gray400,
        labelStyle: TossTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: TossTextStyles.body.fontSize!,
        ),
        unselectedLabelStyle: TossTextStyles.body.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: TossTextStyles.body.fontSize!,
        ),
        labelPadding: EdgeInsets.zero,
        tabs: tabs.map((text) => Tab(
          height: 46,
          child: Text(text),
        )).toList(),
      ),
    );
  }
}

/// Data class for tab items in TossPillTabBar
class TossTabItem {
  final String? text;
  final IconData? icon;
  final Widget? child;
  final bool enabled;

  const TossTabItem({
    this.text,
    this.icon,
    this.child,
    this.enabled = true,
  }) : assert(
          text != null || icon != null || child != null,
          'At least one of text, icon, or child must be provided',
        );

  /// Create a text tab
  const TossTabItem.text(
    String text, {
    bool enabled = true,
  }) : this(text: text, enabled: enabled);

  /// Create an icon tab
  const TossTabItem.icon(
    IconData icon, {
    bool enabled = true,
  }) : this(icon: icon, enabled: enabled);

  /// Create a custom widget tab
  const TossTabItem.custom(
    Widget child, {
    bool enabled = true,
  }) : this(child: child, enabled: enabled);
}