import 'package:flutter/material.dart';
import '../../../core/themes/index.dart';

/// Toss-style bottom sheet helper
/// Standardizes bottom sheet configuration across the app
class TossBottomSheet {
  TossBottomSheet._();

  /// Show standard Toss bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    bool isScrollControlled = true,
    double heightFactor = 0.8,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * heightFactor,
      ),
      builder: builder,
    );
  }

  /// Show full-screen bottom sheet
  static Future<T?> showFullscreen<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) {
    return show<T>(
      context: context,
      builder: builder,
      heightFactor: 0.95,
    );
  }

  /// Show compact bottom sheet
  static Future<T?> showCompact<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) {
    return show<T>(
      context: context,
      builder: builder,
      heightFactor: 0.6,
    );
  }
}