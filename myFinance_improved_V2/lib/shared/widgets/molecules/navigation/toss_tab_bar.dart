import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Data class for tab items in TossTabBar
///
/// Supports text, icon, or custom widget tabs
class TossTab {
  final String? text;
  final IconData? icon;
  final Widget? child;
  final bool enabled;

  const TossTab({
    this.text,
    this.icon,
    this.child,
    this.enabled = true,
  }) : assert(
          text != null || icon != null || child != null,
          'At least one of text, icon, or child must be provided',
        );

  /// Create a text tab
  const TossTab.text(String text, {bool enabled = true})
      : this(text: text, enabled: enabled);

  /// Create an icon tab
  const TossTab.icon(IconData icon, {bool enabled = true})
      : this(icon: icon, enabled: enabled);

  /// Create a custom widget tab (e.g., text with badge)
  const TossTab.custom(Widget child, {bool enabled = true})
      : this(child: child, enabled: enabled);
}

/// A reusable tab bar component following the Toss design system.
///
/// Supports both simple string tabs and custom TossTab items:
///
/// ```dart
/// // Simple string tabs
/// TossTabBar(
///   tabs: ['Cash', 'Bank', 'Vault'],
///   onTabChanged: (index) => print('Selected tab: $index'),
/// )
///
/// // Custom tabs with badges
/// TossTabBar.custom(
///   tabs: [
///     TossTab.text('All'),
///     TossTab.custom(
///       Row(children: [Text('Unread'), Badge(count: 5)]),
///     ),
///   ],
/// )
/// ```
class TossTabBar extends StatefulWidget {
  /// List of tab labels (for simple string tabs)
  final List<String>? _stringTabs;

  /// List of custom tab items
  final List<TossTab>? _customTabs;

  /// Callback when tab selection changes
  final ValueChanged<int>? onTabChanged;

  /// Initial selected tab index
  final int initialIndex;

  /// Custom text style for selected tab
  final TextStyle? selectedLabelStyle;

  /// Custom text style for unselected tabs
  final TextStyle? unselectedLabelStyle;

  /// Color for the selected tab indicator
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

  /// Whether to show bottom border
  final bool showDivider;

  /// Simple string tabs constructor
  const TossTabBar({
    super.key,
    required List<String> tabs,
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
    this.showDivider = true,
  }) : _stringTabs = tabs,
       _customTabs = null;

  /// Custom TossTab items constructor
  const TossTabBar.custom({
    super.key,
    required List<TossTab> tabs,
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
    this.showDivider = true,
  }) : _customTabs = tabs,
       _stringTabs = null;

  /// Get the number of tabs
  int get tabCount => _stringTabs?.length ?? _customTabs?.length ?? 0;

  @override
  State<TossTabBar> createState() => _TossTabBarState();
}

class _TossTabBarState extends State<TossTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TabController? _internalController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller == null) {
      _internalController = TabController(
        length: widget.tabCount,
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
          length: widget.tabCount,
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
    if (widget.tabCount != oldWidget.tabCount) {
      if (_internalController != null) {
        final previousIndex = _internalController!.index;
        _internalController!.removeListener(_handleTabChange);
        _internalController!.dispose();
        _internalController = TabController(
          length: widget.tabCount,
          vsync: this,
          initialIndex: previousIndex.clamp(0, widget.tabCount - 1),
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

  List<Widget> _buildTabs() {
    if (widget._stringTabs != null) {
      return widget._stringTabs!.map((tab) => Tab(text: tab)).toList();
    }

    if (widget._customTabs != null) {
      return widget._customTabs!.map((tab) => _buildTab(tab)).toList();
    }

    return [];
  }

  Widget _buildTab(TossTab tab) {
    Widget tabContent;

    if (tab.child != null) {
      tabContent = tab.child!;
    } else if (tab.text != null) {
      tabContent = Text(tab.text!);
    } else if (tab.icon != null) {
      tabContent = Icon(tab.icon, size: TossSpacing.iconSM);
    } else {
      tabContent = const SizedBox.shrink();
    }

    if (!tab.enabled) {
      tabContent = Opacity(opacity: 0.4, child: tabContent);
    }

    return Tab(child: tabContent);
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = widget.selectedColor ?? TossColors.primary;
    const selectedLabelColor = TossColors.gray900;
    final unselectedLabelColor = widget.unselectedColor ?? TossColors.gray500;

    final selectedTextStyle = widget.selectedLabelStyle ??
      TossTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w700,
      );

    final unselectedTextStyle = widget.unselectedLabelStyle ??
      TossTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w500,
      );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: widget.padding ?? const EdgeInsets.only(
            top: TossSpacing.space4,
            left: TossSpacing.space4,
            right: TossSpacing.space4,
            bottom: 0,
          ),
          decoration: widget.showDivider
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray200,
                    width: 1,
                  ),
                ),
              )
            : null,
          child: Theme(
            data: ThemeData(
              splashColor: TossColors.transparent,
              highlightColor: TossColors.transparent,
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
              labelColor: selectedLabelColor,
              unselectedLabelColor: unselectedLabelColor,
              labelStyle: selectedTextStyle,
              unselectedLabelStyle: unselectedTextStyle,
              dividerColor: TossColors.transparent,
              overlayColor: WidgetStateProperty.all(TossColors.transparent),
              labelPadding: EdgeInsets.zero,
              tabs: _buildTabs(),
            ),
          ),
        ),
        // Full-width gray line at the bottom
        Container(
          height: 1,
          color: TossColors.gray100,
        ),
      ],
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
  /// List of tab labels (for simple string tabs)
  final List<String>? _stringTabs;

  /// List of custom tab items
  final List<TossTab>? _customTabs;

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

  /// Simple string tabs constructor
  const TossTabBarView({
    super.key,
    required List<String> tabs,
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
  }) : _stringTabs = tabs,
       _customTabs = null,
       assert(tabs.length == children.length, 'tabs and children must have the same length');

  /// Custom TossTab items constructor
  const TossTabBarView.custom({
    super.key,
    required List<TossTab> tabs,
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
  }) : _customTabs = tabs,
       _stringTabs = null,
       assert(tabs.length == children.length, 'tabs and children must have the same length');

  /// Get the number of tabs
  int get tabCount => _stringTabs?.length ?? _customTabs?.length ?? 0;

  @override
  State<TossTabBarView> createState() => _TossTabBarViewState();
}

class _TossTabBarViewState extends State<TossTabBarView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabCount,
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

    if (widget.tabCount != oldWidget.tabCount) {
      final previousIndex = _tabController.index;
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabCount,
        vsync: this,
        initialIndex: previousIndex.clamp(0, widget.tabCount - 1),
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
        if (widget._stringTabs != null)
          TossTabBar(
            tabs: widget._stringTabs!,
            controller: _tabController,
            selectedLabelStyle: widget.selectedLabelStyle,
            unselectedLabelStyle: widget.unselectedLabelStyle,
            selectedColor: widget.selectedColor,
            unselectedColor: widget.unselectedColor,
            indicatorHeight: widget.indicatorHeight,
            padding: widget.tabBarPadding,
            isScrollable: widget.isScrollable,
          )
        else if (widget._customTabs != null)
          TossTabBar.custom(
            tabs: widget._customTabs!,
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

