import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared animation mixin for Cash Ending tabs
/// Provides automatic UI transitions when location is selected
mixin AnimatedTabMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  // Animation controllers
  late AnimationController expansionController;
  late AnimationController contentController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;
  
  // Scroll controller for auto-scrolling
  late ScrollController scrollController;
  
  // Track animation state
  bool hasTriggeredAnimation = false;
  bool isAnimating = false;
  
  // Configuration (can be overridden by implementing class)
  Duration get expansionDuration => const Duration(milliseconds: 400);
  Duration get contentDuration => const Duration(milliseconds: 600);
  Duration get scrollDelay => const Duration(milliseconds: 500);
  Duration get focusDelay => const Duration(milliseconds: 1200);
  
  /// Initialize animation controllers and animations
  void initializeAnimations() {
    // Initialize scroll controller
    scrollController = ScrollController();
    
    // Initialize expansion animation controller
    expansionController = AnimationController(
      duration: expansionDuration,
      vsync: this,
    );
    
    // Initialize content animation controller
    contentController = AnimationController(
      duration: contentDuration,
      vsync: this,
    );
    
    // Setup fade animation
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: contentController,
      curve: Curves.easeInOut,
    ));
    
    // Setup slide animation
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: contentController,
      curve: Curves.easeOutCubic,
    ));
    
    // Setup subtle scale animation
    scaleAnimation = Tween<double>(
      begin: 0.97,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: contentController,
      curve: Curves.easeOut,
    ));
  }
  
  /// Dispose animation controllers
  void disposeAnimations() {
    expansionController.dispose();
    contentController.dispose();
    scrollController.dispose();
  }
  
  /// Check if location was just selected and trigger animation
  void checkLocationChange(String? oldLocation, String? newLocation) {
    // Detect when location is newly selected
    if (oldLocation == null && newLocation != null && !hasTriggeredAnimation) {
      triggerAutomaticTransition();
    }
    
    // Reset animation flag if location is cleared
    if (newLocation == null) {
      resetAnimations();
    }
  }
  
  /// Orchestrates the complete automatic transition sequence
  void triggerAutomaticTransition() {
    if (isAnimating) return;
    
    hasTriggeredAnimation = true;
    isAnimating = true;
    
    // 1. Haptic feedback for tactile response
    HapticFeedback.lightImpact();
    
    // 2. Start animations simultaneously
    expansionController.forward();
    contentController.forward();
    
    // 3. Auto-scroll after a short delay
    Future.delayed(scrollDelay, () {
      autoScrollToContent();
    });
    
    // 4. Focus on first input after scroll completes
    Future.delayed(focusDelay, () {
      focusFirstInput();
      isAnimating = false;
    });
  }
  
  /// Reset all animations to initial state
  void resetAnimations() {
    hasTriggeredAnimation = false;
    isAnimating = false;
    expansionController.reset();
    contentController.reset();
  }
  
  /// Auto-scrolls to the content section smoothly
  void autoScrollToContent() {
    if (!scrollController.hasClients) return;
    
    // Calculate optimal scroll position (30% of max scroll)
    final targetScroll = scrollController.position.maxScrollExtent * 0.3;
    
    // Ensure we don't scroll beyond bounds
    final clampedScroll = targetScroll.clamp(
      0.0,
      scrollController.position.maxScrollExtent,
    );
    
    scrollController.animateTo(
      clampedScroll,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }
  
  /// Override this in implementing class to focus specific inputs
  void focusFirstInput() {
    // Default implementation - can be overridden
    if (mounted) {
      setState(() {
        // Trigger rebuild to signal focus intent
      });
    }
  }
  
  /// Wrap a widget with fade transition animation
  Widget wrapWithFadeTransition(Widget child) {
    return AnimatedBuilder(
      animation: contentController,
      builder: (context, _) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }
  
  /// Wrap a widget with slide transition animation
  Widget wrapWithSlideTransition(Widget child) {
    return AnimatedBuilder(
      animation: contentController,
      builder: (context, _) {
        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }
  
  /// Wrap a widget with scale transition animation
  Widget wrapWithScaleTransition(Widget child) {
    return AnimatedBuilder(
      animation: contentController,
      builder: (context, _) {
        return ScaleTransition(
          scale: scaleAnimation,
          child: child,
        );
      },
    );
  }
  
  /// Wrap a widget with all three animations combined
  Widget wrapWithFullAnimation(Widget child) {
    return AnimatedBuilder(
      animation: contentController,
      builder: (context, _) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }
  
  /// Build an animated card with all transitions applied
  Widget buildAnimatedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? elevation,
  }) {
    return wrapWithFullAnimation(
      Card(
        elevation: elevation ?? (2 + (scaleAnimation.value * 2)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
  
  /// Build delayed animation for staggered effects
  Widget buildDelayedAnimation({
    required Widget child,
    required Duration delay,
    Curve curve = Curves.easeIn,
  }) {
    return AnimatedBuilder(
      animation: contentController,
      builder: (context, _) {
        // Calculate delayed opacity based on animation progress
        final progress = contentController.value;
        final delayedProgress = ((progress - (delay.inMilliseconds / contentDuration.inMilliseconds))
            .clamp(0.0, 1.0) * 2)
            .clamp(0.0, 1.0);
        
        return Opacity(
          opacity: curve.transform(delayedProgress),
          child: Transform.translate(
            offset: Offset(0, (1 - delayedProgress) * 10),
            child: child,
          ),
        );
      },
    );
  }
}