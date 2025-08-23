import 'package:flutter/material.dart';
import '../toss/toss_tab_bar.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';

/// Main tab bar component for primary navigation sections.
/// This wraps TossTabBar with predefined styling for main tab bars.
///
/// Example usage:
/// ```dart
/// TabBarMain(
///   tabs: ['Cash', 'Bank', 'Vault'],
///   controller: _tabController,
///   onTabChanged: (index) => print('Selected tab: $index'),
/// )
/// ```
class TabBarMain extends StatelessWidget {
  /// List of tab labels to display
  final List<String> tabs;
  
  /// External tab controller (required)
  final TabController controller;
  
  /// Callback when tab selection changes
  final ValueChanged<int>? onTabChanged;
  
  /// Whether to show a bottom border
  final bool showBottomBorder;
  
  /// Custom padding for the tab bar
  final EdgeInsetsGeometry? padding;
  
  /// Whether tabs should be scrollable
  final bool isScrollable;
  
  /// List of disabled tab indices
  final List<int>? disabledIndices;
  
  const TabBarMain({
    super.key,
    required this.tabs,
    required this.controller,
    this.onTabChanged,
    this.showBottomBorder = true,
    this.padding,
    this.isScrollable = false,
    this.disabledIndices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showBottomBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray200,
                  width: 1.0,
                ),
              ),
            )
          : null,
      child: TossTabBar(
        tabs: tabs,
        controller: controller,
        onTabChanged: onTabChanged,
        selectedColor: TossColors.gray900,
        unselectedColor: TossColors.gray400,
        selectedLabelStyle: TossTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TossTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w400,
        ),
        indicatorHeight: 3.0,
        padding: padding ?? EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        isScrollable: isScrollable,
      ),
    );
  }
}

/// A complete tab bar view component that combines TabBarMain with TabBarView.
/// Provides a full tab navigation experience with content switching.
///
/// Example usage:
/// ```dart
/// TabBarMainView(
///   tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
///   children: [
///     ContentWidget1(),
///     ContentWidget2(),
///     ContentWidget3(),
///   ],
/// )
/// ```
class TabBarMainView extends StatefulWidget {
  /// List of tab labels
  final List<String> tabs;
  
  /// List of widgets to display for each tab
  final List<Widget> children;
  
  /// Callback when tab selection changes
  final ValueChanged<int>? onTabChanged;
  
  /// Initial selected tab index
  final int initialIndex;
  
  /// Whether to show a bottom border on the tab bar
  final bool showBottomBorder;
  
  /// Custom padding for the tab bar
  final EdgeInsetsGeometry? tabBarPadding;
  
  /// Whether tabs should be scrollable
  final bool isScrollable;
  
  /// Whether the TabBarView should be scrollable
  final ScrollPhysics? physics;
  
  /// List of disabled tab indices
  final List<int>? disabledIndices;
  
  /// Custom disabled content builder
  final Widget Function(String tabName)? disabledContentBuilder;

  const TabBarMainView({
    super.key,
    required this.tabs,
    required this.children,
    this.onTabChanged,
    this.initialIndex = 0,
    this.showBottomBorder = true,
    this.tabBarPadding,
    this.isScrollable = false,
    this.physics,
    this.disabledIndices,
    this.disabledContentBuilder,
  }) : assert(tabs.length == children.length, 'tabs and children must have the same length');

  @override
  State<TabBarMainView> createState() => _TabBarMainViewState();
}

class _TabBarMainViewState extends State<TabBarMainView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    
    _tabController.addListener(_handleTabChange);
  }
  
  @override
  void didUpdateWidget(TabBarMainView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.tabs.length != oldWidget.tabs.length) {
      final previousIndex = _tabController.index;
      _tabController.removeListener(_handleTabChange);
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: previousIndex.clamp(0, widget.tabs.length - 1),
      );
      _tabController.addListener(_handleTabChange);
    }
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      // Check if the selected tab is disabled
      if (widget.disabledIndices?.contains(_tabController.index) ?? false) {
        // Prevent navigation to disabled tab
        final previousIndex = _tabController.previousIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tabController.index = previousIndex;
        });
        return;
      }
      widget.onTabChanged?.call(_tabController.index);
    }
  }
  
  Widget _buildTabContent(int index) {
    if (widget.disabledIndices?.contains(index) ?? false) {
      return widget.disabledContentBuilder?.call(widget.tabs[index]) ??
          _buildDefaultDisabledContent(widget.tabs[index]);
    }
    return widget.children[index];
  }
  
  Widget _buildDefaultDisabledContent(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 48,
            color: TossColors.gray300,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            '$tabName is not available',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'You don\'t have permission to access this section',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBarMain(
          tabs: widget.tabs,
          controller: _tabController,
          onTabChanged: widget.onTabChanged,
          showBottomBorder: widget.showBottomBorder,
          padding: widget.tabBarPadding,
          isScrollable: widget.isScrollable,
          disabledIndices: widget.disabledIndices,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
            children: List.generate(
              widget.tabs.length,
              (index) => _buildTabContent(index),
            ),
          ),
        ),
      ],
    );
  }
}