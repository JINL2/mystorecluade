import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Toss Animation System - Smooth & Professional
/// Based on Toss's actual animation timings
/// 
/// Core Principles:
/// - 200-250ms for most transitions (sweet spot)
/// - No bouncy effects (professional feel)
/// - Ease-out for entering, ease-in for exiting
/// - Consistent timing creates rhythm
/// - Subtle micro-interactions (50-100ms)
class TossAnimations {
  TossAnimations._();

  // ==================== DURATION CONSTANTS ====================
  // Toss uses consistent, predictable timing
  
  /// Instant (50ms) - Immediate feedback
  static const Duration instant = Duration(milliseconds: 50);
  
  /// Quick (100ms) - Micro-interactions
  static const Duration quick = Duration(milliseconds: 100);
  
  /// Fast (150ms) - Button presses, hovers
  static const Duration fast = Duration(milliseconds: 150);
  
  /// Normal (200ms) - Default for most animations ⭐
  static const Duration normal = Duration(milliseconds: 200);
  
  /// Medium (250ms) - Page transitions ⭐
  static const Duration medium = Duration(milliseconds: 250);
  
  /// Slow (300ms) - Complex transitions
  static const Duration slow = Duration(milliseconds: 300);
  
  /// Slower (400ms) - Major scene changes
  static const Duration slower = Duration(milliseconds: 400);

  // ==================== CURVE CONSTANTS ====================
  // Toss avoids bouncy effects for professional feel
  
  /// Standard curve - Smooth and professional ⭐
  static const Curve standard = Curves.easeInOutCubic;
  
  /// Enter curve - Smooth deceleration ⭐
  static const Curve enter = Curves.easeOutCubic;
  
  /// Exit curve - Smooth acceleration
  static const Curve exit = Curves.easeInCubic;
  
  /// Emphasis curve - Slight overshoot (no bounce)
  static const Curve emphasis = Curves.fastOutSlowIn;
  
  /// Linear - Constant speed (progress bars)
  static const Curve linear = Curves.linear;
  
  /// Accelerate - Speed up gradually
  static const Curve accelerate = Curves.easeIn;
  
  /// Decelerate - Slow down gradually ⭐
  static const Curve decelerate = Curves.easeOut;
  
  /// Sharp - Quick response
  static const Curve sharp = Curves.easeOutExpo;
  
  /// NO BOUNCE - Toss doesn't use elasticOut or bounceOut

  // ==================== COMMON TRANSITIONS ====================
  
  /// Fade transition for smooth opacity changes
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
  
  /// Slide transition from bottom (sheets, modals)
  static Widget slideFromBottom({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: enter,
      )),
      child: child,
    );
  }
  
  /// Slide transition from right (page navigation)
  static Widget slideFromRight({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: standard,
      )),
      child: child,
    );
  }
  
  /// Scale transition for emphasis
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
    double beginScale = 0.8,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: beginScale,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: enter,
      )),
      child: fadeTransition(child: child, animation: animation),
    );
  }

  // ==================== MICRO INTERACTIONS ====================
  
  /// Button press scale animation
  static AnimationController createButtonController(TickerProvider vsync) {
    return AnimationController(
      duration: fast,
      vsync: vsync,
    );
  }
  
  /// Card hover/press animation
  static AnimationController createCardController(TickerProvider vsync) {
    return AnimationController(
      duration: normal,
      vsync: vsync,
    );
  }
  
  /// List item animation controller
  static AnimationController createListItemController(TickerProvider vsync) {
    return AnimationController(
      duration: medium,
      vsync: vsync,
    );
  }

  // ==================== PAGE ROUTE TRANSITIONS ====================
  
  /// Toss-style page route with slide and fade
  static PageRouteBuilder<T> pageRoute<T>({
    required Widget Function(BuildContext, Animation<double>, Animation<double>) pageBuilder,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: pageBuilder,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(
          tween.chain(CurveTween(curve: standard)),
        );
        
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
  
  /// Bottom sheet route animation
  static PageRouteBuilder<T> bottomSheetRoute<T>({
    required Widget Function(BuildContext) builder,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionDuration: duration,
      reverseTransitionDuration: normal,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      opaque: false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return slideFromBottom(
          animation: animation,
          child: child,
        );
      },
    );
  }

  // ==================== STAGGER ANIMATIONS ====================
  
  /// Creates staggered animation intervals for lists
  static List<Interval> createStaggerIntervals(int itemCount, {double delay = 0.05}) {
    return List.generate(itemCount, (index) {
      final start = index * delay;
      final end = start + 0.5;
      return Interval(
        start.clamp(0.0, 1.0),
        end.clamp(0.0, 1.0),
        curve: enter,
      );
    });
  }

  // ==================== ANIMATED WIDGETS ====================
  
  /// Animated container with Toss defaults
  static Widget animatedContainer({
    required Widget child,
    Duration duration = normal,
    Curve curve = standard,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Decoration? decoration,
    double? width,
    double? height,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }
  
  /// Animated opacity with Toss defaults
  static Widget animatedOpacity({
    required Widget child,
    required double opacity,
    Duration duration = normal,
    Curve curve = standard,
  }) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
  
  /// Animated scale with Toss defaults
  static Widget animatedScale({
    required Widget child,
    required double scale,
    Duration duration = normal,
    Curve curve = standard,
  }) {
    return AnimatedScale(
      scale: scale,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
  
  /// Animated slide with Toss defaults
  static Widget animatedSlide({
    required Widget child,
    required Offset offset,
    Duration duration = normal,
    Curve curve = standard,
  }) {
    return AnimatedSlide(
      offset: offset,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  // ==================== LOADING ANIMATIONS ====================
  
  /// Toss-style shimmer effect for loading states
  static LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Colors.grey[300]!,
      Colors.grey[100]!,
      Colors.grey[300]!,
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: const Alignment(-1.0, -0.3),
    end: const Alignment(1.0, 0.3),
  );
  
  /// Pulse animation for loading indicators
  static Animation<double> createPulseAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  // ==================== GESTURE ANIMATIONS ====================
  
  /// Creates a tap scale animation
  static Animation<double> createTapAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }
  
  /// Creates a long press scale animation
  static Animation<double> createLongPressAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }
  
  /// Creates a swipe animation
  static Animation<Offset> createSwipeAnimation(
    AnimationController controller,
    Offset begin,
    Offset end,
  ) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));
  }

  // ==================== SCROLL ANIMATIONS ====================
  
  /// Fade in on scroll animation
  static Widget fadeInOnScroll({
    required Widget child,
    required ScrollController scrollController,
    double triggerOffset = 100,
  }) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset = scrollController.hasClients
            ? scrollController.offset
            : 0.0;
        final opacity = (offset / triggerOffset).clamp(0.0, 1.0);
        
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
    );
  }
  
  /// Parallax scroll effect
  static Widget parallaxScroll({
    required Widget child,
    required ScrollController scrollController,
    double speed = 0.5,
  }) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset = scrollController.hasClients
            ? scrollController.offset * speed
            : 0.0;
        
        return Transform.translate(
          offset: Offset(0, -offset),
          child: child,
        );
      },
    );
  }
}

/// Toss-style animated widget wrapper for micro-interactions
class TossAnimatedWidget extends StatefulWidget {
  final Widget child;
  final bool enableTap;
  final bool enableHover;
  final VoidCallback? onTap;
  final Duration duration;
  final Curve curve;
  
  const TossAnimatedWidget({
    super.key,
    required this.child,
    this.enableTap = true,
    this.enableHover = false,
    this.onTap,
    this.duration = TossAnimations.quick,
    this.curve = TossAnimations.standard,
  });
  
  @override
  State<TossAnimatedWidget> createState() => _TossAnimatedWidgetState();
}

class _TossAnimatedWidgetState extends State<TossAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enableTap ? (_) => _controller.forward() : null,
      onTapUp: widget.enableTap ? (_) {
        _controller.reverse();
        widget.onTap?.call();
      } : null,
      onTapCancel: widget.enableTap ? () => _controller.reverse() : null,
      child: MouseRegion(
        onEnter: widget.enableHover ? (_) => _controller.forward() : null,
        onExit: widget.enableHover ? (_) => _controller.reverse() : null,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}