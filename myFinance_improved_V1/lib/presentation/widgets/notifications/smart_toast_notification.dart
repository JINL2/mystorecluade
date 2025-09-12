import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/notifications/config/notification_display_config.dart';
import '../../../core/notifications/models/notification_payload.dart';
import '../../providers/notification_provider.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
/// Smart toast notification widget that provides non-intrusive notifications
/// Auto-dismisses, swipeable, and respects user preferences
class SmartToastNotification extends ConsumerStatefulWidget {
  final String title;
  final String body;
  final String? category;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final Duration? duration;
  final bool showIcon;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const SmartToastNotification({
    super.key,
    required this.title,
    required this.body,
    this.category,
    this.onTap,
    this.onDismiss,
    this.duration,
    this.showIcon = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  /// Static method to show toast notification
  static void show(
    BuildContext context, {
    required String title,
    required String body,
    String? category,
    VoidCallback? onTap,
    Duration? duration,
    IconData? icon,
  }) {
    final config = NotificationDisplayConfig();
    
    // Check if smart toasts are enabled and not in quiet hours
    if (!config.isSmartToastEnabled || !config.shouldShowNotifications) {
      return;
    }

    // Remove any existing toast first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Calculate duration based on config
    final toastDuration = duration ?? 
      Duration(seconds: config.toastDurationSeconds);

    // Show the smart toast using ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SmartToastNotification(
          title: title,
          body: body,
          category: category,
          onTap: onTap,
          duration: toastDuration,
          icon: icon,
        ),
        duration: toastDuration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: TossColors.transparent,
        elevation: 0,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: TossSpacing.space4,
          right: TossSpacing.space4,
        ),
        padding: EdgeInsets.zero,
        onVisible: () {
          // Analytics: Toast shown
        },
      ),
    );
  }

  /// Show notification from payload
  static void showFromPayload(
    BuildContext context,
    NotificationPayload payload,
  ) {
    show(
      context,
      title: payload.title,
      body: payload.body,
      category: payload.category,
      icon: _getIconForCategory(payload.category),
      onTap: () {
        // Navigate to notifications page
        Navigator.pushNamed(context, '/notifications');
      },
    );
  }

  static IconData _getIconForCategory(String? category) {
    switch (category) {
      case 'shift_reminder':
        return Icons.access_time_rounded;
      case 'transaction':
        return Icons.receipt_long_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'announcement':
        return Icons.campaign_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  ConsumerState<SmartToastNotification> createState() => _SmartToastNotificationState();
}

class _SmartToastNotificationState extends ConsumerState<SmartToastNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    // Auto-mark as read if enabled
    final config = NotificationDisplayConfig();
    if (config.isAutoMarkAsReadEnabled) {
      _markAsReadAfterDelay();
    }
  }

  void _markAsReadAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_isDismissed) {
        // Auto-mark notification as read after showing
        // This prevents the annoying "tap to mark as read" behavior
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    if (_isDismissed) return;
    
    setState(() {
      _isDismissed = true;
    });

    _animationController.reverse().then((_) {
      widget.onDismiss?.call();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = widget.backgroundColor ?? 
      (isDarkMode ? TossColors.gray800 : TossColors.white);
    final textColor = widget.textColor ?? 
      (isDarkMode ? TossColors.white : TossColors.textPrimary);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          onDismissed: (_) => _handleDismiss(),
          child: Material(
            color: TossColors.transparent,
            child: InkWell(
              onTap: () {
                widget.onTap?.call();
                _handleDismiss();
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  boxShadow: TossShadows.elevation2,
                  border: Border.all(
                    color: TossColors.gray200.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.showIcon) ...[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Icon(
                          widget.icon ?? Icons.notifications_none_rounded,
                          color: TossColors.primary,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space3),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TossTextStyles.body.copyWith(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.body.isNotEmpty) ...[
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              widget.body,
                              style: TossTextStyles.caption.copyWith(
                                color: textColor.withOpacity(0.7),
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    // Subtle close button
                    GestureDetector(
                      onTap: _handleDismiss,
                      child: Container(
                        padding: EdgeInsets.all(TossSpacing.space1),
                        child: Icon(
                          Icons.close_rounded,
                          color: textColor.withOpacity(0.5),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension to easily show smart toasts from anywhere
extension SmartToastExtension on BuildContext {
  void showSmartToast({
    required String title,
    required String body,
    String? category,
    VoidCallback? onTap,
    Duration? duration,
    IconData? icon,
  }) {
    SmartToastNotification.show(
      this,
      title: title,
      body: body,
      category: category,
      onTap: onTap,
      duration: duration,
      icon: icon,
    );
  }
}