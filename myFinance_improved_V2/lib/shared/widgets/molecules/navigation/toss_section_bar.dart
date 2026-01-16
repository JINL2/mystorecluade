import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Section bar style variants
enum TossSectionBarStyle {
  /// Common style: gray background with white sliding indicator (default)
  /// Used for: P&L / B/S / Trend tabs (full width)
  common,

  /// Compact style: same colors as common but smaller, no margin
  /// Used for: Store / Company toggle (inline)
  compact,
}

/// A section bar component following the Toss design system.
///
/// This widget displays tabs in a pill/segmented control style with a
/// rounded background container and a sliding indicator.
///
/// Features:
/// - Two style variants: common (default) and compact
/// - Animated sliding indicator for selected tab
/// - Haptic feedback on selection
/// - Support for external TabController
/// - Customizable styling
///
/// Usage examples:
/// ```dart
/// // Common style (default) - gray background, white indicator
/// TossSectionBar(
///   tabs: ['P&L', 'B/S', 'Trend'],
///   onTabChanged: (index) => print('Selected: $index'),
/// )
///
/// // Compact style - same colors, smaller size, no margin
/// TossSectionBar.compact(
///   tabs: ['Store', 'Company'],
///   onTabChanged: (index) => print('Selected: $index'),
/// )
///
/// // Custom height
/// TossSectionBar(
///   tabs: ['Option A', 'Option B'],
///   height: 36,
/// )
/// ```
class TossSectionBar extends StatefulWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Optional list of counts to display next to each tab label
  /// If provided, must have the same length as tabs
  final List<int>? tabCounts;

  /// Callback when tab selection changes
  final ValueChanged<int>? onTabChanged;

  /// Initial selected tab index (ignored if controller is provided)
  final int initialIndex;

  /// External tab controller (optional)
  final TabController? controller;

  /// Height of the tab bar container (default: 44)
  final double height;

  /// Horizontal margin around the tab bar
  final EdgeInsetsGeometry? margin;

  /// Background color of the container (default: gray100)
  final Color? backgroundColor;

  /// Color of the selected tab indicator (default: white)
  final Color? indicatorColor;

  /// Text color for selected tab (default: charcoal #212529)
  final Color? selectedLabelColor;

  /// Text color for unselected tabs (default: darkGray #6B7785)
  final Color? unselectedLabelColor;

  /// Whether to enable haptic feedback on tab change
  final bool enableHapticFeedback;

  /// Custom label style for selected tab
  final TextStyle? labelStyle;

  /// Custom label style for unselected tab
  final TextStyle? unselectedLabelStyle;

  /// Padding for each tab label
  final EdgeInsetsGeometry? labelPadding;

  /// Style variant: common (default) or compact
  final TossSectionBarStyle style;

  const TossSectionBar({
    super.key,
    required this.tabs,
    this.tabCounts,
    this.onTabChanged,
    this.initialIndex = 0,
    this.controller,
    this.height = 44,
    this.margin,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.enableHapticFeedback = true,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.style = TossSectionBarStyle.common,
  }) : assert(tabs.length >= 2, 'At least 2 tabs are required'),
       assert(tabCounts == null || tabCounts.length == tabs.length,
           'tabCounts must have the same length as tabs');

  /// Creates a compact-style section bar (same colors, smaller size, no margin)
  const TossSectionBar.compact({
    super.key,
    required this.tabs,
    this.tabCounts,
    this.onTabChanged,
    this.initialIndex = 0,
    this.controller,
    this.height = 32,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.enableHapticFeedback = true,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
  })  : style = TossSectionBarStyle.compact,
        assert(tabs.length >= 2, 'At least 2 tabs are required'),
        assert(tabCounts == null || tabCounts.length == tabs.length,
            'tabCounts must have the same length as tabs');

  @override
  State<TossSectionBar> createState() => _TossSectionBarState();
}

class _TossSectionBarState extends State<TossSectionBar>
    with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(TossSectionBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller if external controller changed
    if (widget.controller != oldWidget.controller) {
      _tabController.removeListener(_handleTabChange);

      if (widget.controller == null) {
        _internalController = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: widget.initialIndex,
        );
        _tabController = _internalController!;
      } else {
        _internalController?.dispose();
        _internalController = null;
        _tabController = widget.controller!;
      }

      _tabController.addListener(_handleTabChange);
    }

    // Update tabs length if changed
    if (widget.tabs.length != oldWidget.tabs.length && _internalController != null) {
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

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _internalController?.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!mounted) return;
    if (_tabController.indexIsChanging) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }
      widget.onTabChanged?.call(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = widget.style == TossSectionBarStyle.compact;

    final backgroundColor = widget.backgroundColor ?? TossColors.gray100;
    final indicatorColor = widget.indicatorColor ?? TossColors.white;
    final selectedLabelColor = widget.selectedLabelColor ?? TossColors.charcoal;
    final unselectedLabelColor = widget.unselectedLabelColor ?? TossColors.darkGray;

    // Both styles use same indicator styling
    final indicatorShadow = [
      BoxShadow(
        color: TossColors.black.withValues(alpha: 0.06),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ];

    // Compact style uses smaller text
    final defaultLabelStyle = isCompact
        ? TossTextStyles.caption.copyWith(fontWeight: FontWeight.w600)
        : TossTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600);
    final defaultUnselectedLabelStyle = isCompact
        ? TossTextStyles.caption.copyWith(fontWeight: FontWeight.w500)
        : TossTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500);

    final tabBar = TabBar(
      controller: _tabController,
      isScrollable: isCompact, // Allow compact style to size to content
      tabAlignment: isCompact ? TabAlignment.start : null,
      indicator: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        boxShadow: indicatorShadow,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.only(
        left: isCompact ? 2 : 4,
        right: isCompact ? 2 : 4,
        top: isCompact ? 2 : 3,
        bottom: isCompact ? 2 : 3,
      ),
      dividerColor: TossColors.transparent,
      labelColor: selectedLabelColor,
      unselectedLabelColor: unselectedLabelColor,
      labelStyle: widget.labelStyle ?? defaultLabelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle ?? defaultUnselectedLabelStyle,
      labelPadding: widget.labelPadding ?? EdgeInsets.symmetric(
        horizontal: isCompact ? TossSpacing.space3 : TossSpacing.space3,
      ),
      overlayColor: WidgetStateProperty.all(TossColors.transparent),
      splashFactory: NoSplash.splashFactory,
      tabs: widget.tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final count = widget.tabCounts?[index];

        return Tab(
          height: widget.height,
          child: Center(
            child: count != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tab),
                      const SizedBox(width: 4),
                      Text(
                        '$count',
                        style: (widget.labelStyle ?? defaultLabelStyle).copyWith(
                          fontWeight: FontWeight.w500,
                          color: unselectedLabelColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  )
                : Text(tab),
          ),
        );
      }).toList(),
    );

    // For compact style, use IntrinsicWidth to size to content
    if (isCompact) {
      return Container(
        height: widget.height,
        margin: widget.margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: tabBar,
      );
    }

    // For segmented style, use Stack with full width
    return Container(
      height: widget.height,
      margin: widget.margin ??
          const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space2,
          ),
      child: Stack(
        children: [
          // Background container
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
          ),
          // Tab bar with indicator
          tabBar,
        ],
      ),
    );
  }
}

/// A widget that combines TossSectionBar with TabBarView.
///
/// Provides a complete section bar solution with content views.
///
/// Example usage:
/// ```dart
/// TossSectionBarView(
///   tabs: ['P&L', 'B/S', 'Trend'],
///   children: [
///     PnlContent(),
///     BsContent(),
///     TrendContent(),
///   ],
/// )
/// ```
class TossSectionBarView extends StatefulWidget {
  /// List of tab labels
  final List<String> tabs;

  /// List of widgets to display for each tab
  final List<Widget> children;

  /// Callback when tab selection changes
  final ValueChanged<int>? onTabChanged;

  /// Initial selected tab index
  final int initialIndex;

  /// Height of the tab bar container
  final double height;

  /// Horizontal margin around the tab bar
  final EdgeInsetsGeometry? margin;

  /// Background color of the container
  final Color? backgroundColor;

  /// Color of the selected tab indicator
  final Color? indicatorColor;

  /// Text color for selected tab
  final Color? selectedLabelColor;

  /// Text color for unselected tabs
  final Color? unselectedLabelColor;

  /// Whether to enable haptic feedback on tab change
  final bool enableHapticFeedback;

  /// Physics for the TabBarView scrolling
  final ScrollPhysics? physics;

  /// External tab controller (optional)
  final TabController? controller;

  const TossSectionBarView({
    super.key,
    required this.tabs,
    required this.children,
    this.onTabChanged,
    this.initialIndex = 0,
    this.height = 44,
    this.margin,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.enableHapticFeedback = true,
    this.physics,
    this.controller,
  }) : assert(
          tabs.length == children.length,
          'tabs and children must have the same length',
        );

  @override
  State<TossSectionBarView> createState() =>
      _TossSectionBarViewState();
}

class _TossSectionBarViewState extends State<TossSectionBarView>
    with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(TossSectionBarView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _tabController.removeListener(_handleTabChange);

      if (widget.controller == null) {
        _internalController = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: widget.initialIndex,
        );
        _tabController = _internalController!;
      } else {
        _internalController?.dispose();
        _internalController = null;
        _tabController = widget.controller!;
      }

      _tabController.addListener(_handleTabChange);
    }

    if (widget.tabs.length != oldWidget.tabs.length && _internalController != null) {
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

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _internalController?.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!mounted) return;
    if (_tabController.indexIsChanging) {
      widget.onTabChanged?.call(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TossSectionBar(
          tabs: widget.tabs,
          controller: _tabController,
          height: widget.height,
          margin: widget.margin,
          backgroundColor: widget.backgroundColor,
          indicatorColor: widget.indicatorColor,
          selectedLabelColor: widget.selectedLabelColor,
          unselectedLabelColor: widget.unselectedLabelColor,
          enableHapticFeedback: widget.enableHapticFeedback,
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
