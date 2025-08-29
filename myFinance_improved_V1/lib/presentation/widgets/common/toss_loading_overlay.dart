import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';

class TossLoadingOverlay extends StatelessWidget {
  const TossLoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
  });

  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;

  static Future<T?> show<T>({
    required BuildContext context,
    String? message,
    Color? backgroundColor,
    Color? indicatorColor,
    Future<T> Function()? task,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: backgroundColor ?? Colors.black.withOpacity(0.5),
      builder: (context) => TossLoadingOverlay(
        message: message,
        indicatorColor: indicatorColor,
      ),
    );

    if (task != null) {
      try {
        final result = await task();
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        return result;
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        rethrow;
      }
    }
    
    return null;
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space8),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    indicatorColor ?? TossColors.primary,
                  ),
                  strokeWidth: 3,
                ),
              ),
              if (message != null) ...[
                SizedBox(height: TossSpacing.space6),
                Text(
                  message!,
                  style: TextStyle(
                    color: TossColors.gray700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}