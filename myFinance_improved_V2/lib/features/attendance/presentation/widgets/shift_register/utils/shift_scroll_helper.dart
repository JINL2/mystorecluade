import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper class for smooth scrolling behavior in shift register
class ShiftScrollHelper {
  static bool _isAutoScrolling = false;

  /// Perform smooth scroll to bottom with progressive multi-stage scrolling for long distances
  static Future<void> performSmoothScroll(ScrollController scrollController) async {
    // Prevent multiple simultaneous scroll animations
    if (_isAutoScrolling) return;

    // Small delay to ensure button is rendered and for better UX flow
    await Future.delayed(const Duration(milliseconds: 200));

    if (!scrollController.hasClients) return;

    final currentPosition = scrollController.position.pixels;
    final maxScroll = scrollController.position.maxScrollExtent;
    final targetPosition = maxScroll.clamp(0.0, maxScroll);
    final scrollDistance = (targetPosition - currentPosition).abs();

    // Skip if already at bottom or very close
    if (scrollDistance < 50) return;

    _isAutoScrolling = true;

    try {
      // Calculate dynamic duration based on distance
      const baseDuration = 700;
      const maxDuration = 1400;
      final viewportHeight = scrollController.position.viewportDimension;
      final scrollRatio = (scrollDistance / viewportHeight).clamp(0.0, 3.0);

      // Use a smoother duration curve (logarithmic scaling for better feel)
      final duration = (baseDuration + (maxDuration - baseDuration) * (scrollRatio / 3) * 0.8).round();

      // For very long distances (>2.5x viewport), use progressive multi-stage scrolling
      if (scrollDistance > viewportHeight * 2.5) {
        await _performMultiStageScroll(scrollController, currentPosition, scrollDistance, targetPosition, maxScroll, duration);
      } else if (scrollDistance > viewportHeight) {
        await _performTwoStageScroll(scrollController, currentPosition, scrollDistance, targetPosition, maxScroll, duration);
      } else {
        await _performSingleStageScroll(scrollController, targetPosition, duration);
      }

      // Add subtle haptic feedback when scroll completes (only for longer scrolls)
      if (scrollDistance > viewportHeight * 1.5) {
        HapticFeedback.lightImpact();
      }
    } finally {
      _isAutoScrolling = false;
    }
  }

  static Future<void> _performMultiStageScroll(
    ScrollController controller,
    double currentPosition,
    double scrollDistance,
    double targetPosition,
    double maxScroll,
    int duration,
  ) async {
    // Stage 1: Accelerate to 60% of distance
    final stage1Position = (currentPosition + (scrollDistance * 0.6)).clamp(0.0, maxScroll);
    await controller.animateTo(
      stage1Position,
      duration: Duration(milliseconds: (duration * 0.45).round()),
      curve: Curves.easeInQuad,
    );

    // Stage 2: Continue to 90% with steady speed
    final stage2Position = (currentPosition + (scrollDistance * 0.9)).clamp(0.0, maxScroll);
    await controller.animateTo(
      stage2Position,
      duration: Duration(milliseconds: (duration * 0.35).round()),
      curve: Curves.linear,
    );

    // Stage 3: Decelerate smoothly to final position
    await controller.animateTo(
      targetPosition,
      duration: Duration(milliseconds: (duration * 0.3).round()),
      curve: Curves.easeOutQuad,
    );
  }

  static Future<void> _performTwoStageScroll(
    ScrollController controller,
    double currentPosition,
    double scrollDistance,
    double targetPosition,
    double maxScroll,
    int duration,
  ) async {
    final intermediatePosition = (currentPosition + (scrollDistance * 0.75)).clamp(0.0, maxScroll);

    // First stage: smooth acceleration
    await controller.animateTo(
      intermediatePosition,
      duration: Duration(milliseconds: (duration * 0.6).round()),
      curve: Curves.easeIn,
    );

    // Second stage: smooth deceleration
    await controller.animateTo(
      targetPosition,
      duration: Duration(milliseconds: (duration * 0.4).round()),
      curve: Curves.easeOut,
    );
  }

  static Future<void> _performSingleStageScroll(
    ScrollController controller,
    double targetPosition,
    int duration,
  ) async {
    await controller.animateTo(
      targetPosition,
      duration: Duration(milliseconds: duration),
      curve: Curves.decelerate,
    );
  }
}
