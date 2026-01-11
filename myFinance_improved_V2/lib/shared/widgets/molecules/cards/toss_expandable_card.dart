import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Toss-style expandable card with smooth animated expand/collapse
///
/// Features:
/// - Smooth SizeTransition animation for expand/collapse
/// - Animated rotation for chevron icon
/// - Customizable header (title string or custom widget)
/// - Optional always-visible footer (e.g., subtotal)
/// - Optional always-visible divider
/// - Light border styling (gray100)
///
/// Example (simple):
/// ```dart
/// TossExpandableCard(
///   title: 'Payment Details',
///   isExpanded: _isExpanded,
///   onToggle: () => setState(() => _isExpanded = !_isExpanded),
///   content: Column(
///     children: [
///       Text('Content here'),
///     ],
///   ),
/// )
/// ```
///
/// Example (with custom header and footer):
/// ```dart
/// TossExpandableCard(
///   headerWidget: Row(
///     children: [
///       Text('VND • Vietnamese Dong'),
///       Spacer(),
///       Text('Exchange rate: 1.0'),
///     ],
///   ),
///   isExpanded: _isExpanded,
///   onToggle: () => setState(() => _isExpanded = !_isExpanded),
///   content: DenominationInputs(),
///   footer: SubtotalDisplay(), // always visible
///   alwaysShowDivider: true,
/// )
/// ```
class TossExpandableCard extends StatefulWidget {
  /// Title text displayed in header (ignored if headerWidget is provided)
  final String title;

  /// Whether the card is expanded
  final bool isExpanded;

  /// Callback when header is tapped (if canToggle is true)
  final VoidCallback onToggle;

  /// Content widget shown when expanded
  final Widget content;

  /// Custom header widget (alternative to title string)
  /// When provided, [title] and [titleStyle] are ignored
  final Widget? headerWidget;

  /// Footer widget always visible below content (e.g., subtotal)
  final Widget? footer;

  /// Whether to show divider even when collapsed (default: false)
  final bool alwaysShowDivider;

  /// Card background color (default: transparent)
  final Color? backgroundColor;

  /// Whether the card can be toggled (default: true)
  /// When false, header tap is disabled and toggle icon is hidden
  final bool canToggle;

  /// Whether to show the expand/collapse icon (default: true)
  final bool showToggleIcon;

  /// Style for the title text
  final TextStyle? titleStyle;

  /// Padding for the header
  final EdgeInsets? padding;

  /// Padding for the content
  final EdgeInsets? contentPadding;

  /// Padding for the footer
  final EdgeInsets? footerPadding;

  /// Border color
  final Color? borderColor;

  /// Divider color
  final Color? dividerColor;

  /// Border radius
  final double borderRadius;

  /// Animation duration
  final Duration animationDuration;

  /// Icon color
  final Color? iconColor;

  /// Custom expand icon (default: LucideIcons.chevronDown with rotation)
  final IconData? expandIcon;

  const TossExpandableCard({
    super.key,
    this.title = '',
    required this.isExpanded,
    required this.onToggle,
    required this.content,
    this.headerWidget,
    this.footer,
    this.alwaysShowDivider = false,
    this.backgroundColor,
    this.canToggle = true,
    this.showToggleIcon = true,
    this.titleStyle,
    this.padding,
    this.contentPadding,
    this.footerPadding,
    this.borderColor,
    this.dividerColor,
    this.borderRadius = 12,
    this.animationDuration = TossAnimations.fast,
    this.iconColor,
    this.expandIcon,
  });

  @override
  State<TossExpandableCard> createState() => _TossExpandableCardState();
}

class _TossExpandableCardState extends State<TossExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: TossAnimations.standard,
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TossExpandableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasFooter = widget.footer != null;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border.all(
          color: widget.borderColor ?? TossColors.gray100,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header - Always visible
          InkWell(
            onTap: widget.canToggle ? widget.onToggle : null,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(widget.borderRadius),
              bottom: (hasFooter || widget.alwaysShowDivider)
                  ? Radius.zero
                  : Radius.circular(widget.borderRadius),
            ),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: widget.headerWidget ??
                        Text(
                          widget.title,
                          style: widget.titleStyle ??
                              TossTextStyles.bodyMedium.copyWith(
                                color: TossColors.gray900,
                              ),
                        ),
                  ),
                  if (widget.canToggle && widget.showToggleIcon)
                    AnimatedRotation(
                      turns: widget.isExpanded ? 0.5 : 0,
                      duration: widget.animationDuration,
                      child: Icon(
                        widget.expandIcon ?? LucideIcons.chevronDown,
                        color: widget.iconColor ?? TossColors.gray600,
                        size: TossSpacing.iconMD,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Always-visible divider (if alwaysShowDivider is true)
          if (widget.alwaysShowDivider)
            Container(
              height: 1,
              color: widget.dividerColor ?? TossColors.gray100,
            ),

          // Animated Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Divider before content (only if not alwaysShowDivider)
                if (!widget.alwaysShowDivider)
                  Container(
                    height: 1,
                    color: widget.dividerColor ?? TossColors.gray100,
                  ),
                Padding(
                  padding: widget.contentPadding ??
                      const EdgeInsets.all(TossSpacing.space3),
                  child: widget.content,
                ),
                // Divider before footer (if footer exists)
                if (hasFooter)
                  Container(
                    height: 1,
                    color: widget.dividerColor ?? TossColors.gray100,
                  ),
              ],
            ),
          ),

          // Footer - Always visible (if provided)
          if (hasFooter)
            Padding(
              padding: widget.footerPadding ??
                  const EdgeInsets.all(TossSpacing.space3),
              child: widget.footer,
            ),
        ],
      ),
    );
  }
}

/// Backward compatibility alias for [TossExpandableCard]
/// @deprecated Use [TossExpandableCard] directly instead.
typedef TossExpandableCardAnimated = TossExpandableCard;
