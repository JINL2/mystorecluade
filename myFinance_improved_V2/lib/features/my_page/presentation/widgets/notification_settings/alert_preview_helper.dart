import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Helper class for notification alert previews
class AlertPreviewHelper {
  AlertPreviewHelper._();

  /// Check if running on desktop platform
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Play preview for selected alert mode
  static Future<void> playAlertPreview(BuildContext context, int mode) async {
    try {
      switch (mode) {
        case 0: // Full Alerts
          await playSound();
          await playVibration();
          break;
        case 1: // Sound Only
          await playSound();
          break;
        case 2: // Vibration Only
          await playVibration();
          break;
        case 3: // Visual Only
          if (!isDesktop) {
            HapticFeedback.lightImpact();
          }
          showVisualPreview(context);
          break;
      }
    } catch (e) {
      debugPrint('Preview error: $e');
    }
  }

  /// Play notification sound (mobile + desktop compatible)
  static Future<void> playSound() async {
    if (isDesktop) {
      debugPrint('🔊 Sound preview (desktop platforms don\'t support SystemSound)');
      return;
    }
    await SystemSound.play(SystemSoundType.alert);
  }

  /// Play vibration pattern (mobile-only)
  static Future<void> playVibration() async {
    if (isDesktop) {
      debugPrint('📳 Vibration preview (desktop platforms don\'t have vibration)');
      return;
    }
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// Show visual-only preview - iOS-style top banner
  static void showVisualPreview(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            tween: Tween(begin: -100.0, end: 0.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray900,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TossColors.primary,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: const Icon(
                      Icons.store_rounded,
                      color: TossColors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Shift Starting Soon',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Your shift starts in 15 minutes',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'now',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future<void>.delayed(const Duration(milliseconds: 3000), () {
      overlayEntry.remove();
    });
  }
}
