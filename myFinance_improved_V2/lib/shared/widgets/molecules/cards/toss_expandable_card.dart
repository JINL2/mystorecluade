import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Toss-style expandable card with collapsible content
///
/// Features:
/// - Collapsible content section
/// - Smooth expand/collapse animation
/// - Customizable header and content
/// - Light border styling (gray100)
///
/// Example:
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
class TossExpandableCard extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget content;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final Color? borderColor;
  final Color? dividerColor;
  final double borderRadius;
  final IconData? expandIcon;
  final IconData? collapseIcon;

  const TossExpandableCard({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.content,
    this.titleStyle,
    this.padding,
    this.contentPadding,
    this.borderColor,
    this.dividerColor,
    this.borderRadius = 12,
    this.expandIcon,
    this.collapseIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? TossColors.gray100,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header - Always visible
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
              bottom: isExpanded ? Radius.zero : Radius.circular(borderRadius),
            ),
            child: Padding(
              padding: padding ??
                  const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: titleStyle ??
                          TossTextStyles.bodyMedium.copyWith(
                            color: TossColors.gray900,
                          ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? (collapseIcon ?? Icons.expand_less)
                        : (expandIcon ?? Icons.expand_more),
                    color: TossColors.gray600,
                    size: TossSpacing.iconSM,
                  ),
                ],
              ),
            ),
          ),

          // Content - Collapsible
          if (isExpanded) ...[
            // Divider
            Container(
              height: 1,
              color: dividerColor ?? TossColors.gray100,
            ),
            // Content
            Padding(
              padding: contentPadding ??
                  const EdgeInsets.all(TossSpacing.space3),
              child: content,
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated version of TossExpandableCard with smooth expand/collapse
class TossExpandableCardAnimated extends StatefulWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget content;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final Color? borderColor;
  final Color? dividerColor;
  final double borderRadius;
  final Duration animationDuration;

  const TossExpandableCardAnimated({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.content,
    this.titleStyle,
    this.padding,
    this.contentPadding,
    this.borderColor,
    this.dividerColor,
    this.borderRadius = 12,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<TossExpandableCardAnimated> createState() =>
      _TossExpandableCardAnimatedState();
}

class _TossExpandableCardAnimatedState
    extends State<TossExpandableCardAnimated>
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
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TossExpandableCardAnimated oldWidget) {
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? TossColors.gray100,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(widget.borderRadius),
            ),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: widget.titleStyle ??
                          TossTextStyles.bodyMedium.copyWith(
                            color: TossColors.gray900,
                          ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0,
                    duration: widget.animationDuration,
                    child: Icon(
                      Icons.expand_more,
                      color: TossColors.gray600,
                      size: TossSpacing.iconSM,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Animated Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 1,
                  color: widget.dividerColor ?? TossColors.gray100,
                ),
                Padding(
                  padding: widget.contentPadding ??
                      const EdgeInsets.all(TossSpacing.space3),
                  child: widget.content,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
