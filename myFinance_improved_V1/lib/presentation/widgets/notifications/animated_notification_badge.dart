import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/notifications/config/notification_display_config.dart';

/// Enhanced animated badge widget for notification count display
/// Provides subtle animations without being intrusive or annoying
class AnimatedNotificationBadge extends StatefulWidget {
  final int count;
  final Widget child;
  final bool animate;
  final Color? badgeColor;
  final Color? textColor;
  final Duration animationDuration;
  final double? maxBadgeSize;

  const AnimatedNotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.animate = true,
    this.badgeColor,
    this.textColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.maxBadgeSize,
  });

  @override
  State<AnimatedNotificationBadge> createState() => _AnimatedNotificationBadgeState();
}

class _AnimatedNotificationBadgeState extends State<AnimatedNotificationBadge>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  int _previousCount = 0;
  late NotificationDisplayConfig _displayConfig;
  
  @override
  void initState() {
    super.initState();
    
    _previousCount = widget.count;
    _displayConfig = NotificationDisplayConfig();
    _displayConfig.initialize();
    
    // Scale animation for badge appearance/count change
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    // Subtle pulse animation for new notifications
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Initial animation
    if (widget.count > 0) {
      _scaleController.forward();
    }
  }
  
  @override
  void didUpdateWidget(AnimatedNotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if count changed
    if (oldWidget.count != widget.count) {
      _handleCountChange(oldWidget.count, widget.count);
    }
  }
  
  void _handleCountChange(int oldCount, int newCount) {
    setState(() {
      _previousCount = oldCount;
    });
    
    if (newCount > 0 && oldCount == 0) {
      // Badge appearing
      _scaleController.forward(from: 0.0);
      _triggerPulseIfEnabled();
    } else if (newCount == 0 && oldCount > 0) {
      // Badge disappearing
      _scaleController.reverse();
    } else if (newCount > oldCount) {
      // Count increased - subtle pulse
      _triggerPulseIfEnabled();
    }
  }
  
  void _triggerPulseIfEnabled() {
    if (!widget.animate || !_displayConfig.isBadgeAnimationEnabled) {
      return;
    }
    
    // Only pulse once, not repeatedly
    _pulseController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _pulseController.reverse();
        }
      });
    });
  }
  
  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  String _formatCount(int count) {
    if (count > 99) {
      return '99+';
    }
    return count.toString();
  }
  
  @override
  Widget build(BuildContext context) {
    final badgeColor = widget.badgeColor ?? TossColors.primary;
    final textColor = widget.textColor ?? TossColors.white;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.count > 0)
          Positioned(
            right: -4,
            top: -4,
            child: AnimatedBuilder(
              animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
              builder: (context, child) {
                final scale = _scaleAnimation.value * _pulseAnimation.value;
                
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                      maxWidth: widget.maxBadgeSize ?? 30,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          _formatCount(widget.count),
                          key: ValueKey<int>(widget.count),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Simple badge widget without animation for comparison
class SimpleNotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final Color? badgeColor;
  final Color? textColor;

  const SimpleNotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.badgeColor,
    this.textColor,
  });

  String _formatCount(int count) {
    if (count > 99) {
      return '99+';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = this.badgeColor ?? TossColors.primary;
    final textColor = this.textColor ?? TossColors.white;
    
    return Badge(
      isLabelVisible: count > 0,
      label: Text(
        _formatCount(count),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: badgeColor,
      child: child,
    );
  }
}