// lib/features/report_control/presentation/widgets/subscription_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../constants/report_constants.dart';
import '../constants/report_strings.dart';
import '../constants/report_icons.dart';
import '../utils/category_utils.dart';
import '../../domain/entities/template_with_subscription.dart';
import '../providers/report_provider.dart';

/// Simplified subscription dialog
/// - Subscribe: Create new subscription
/// - Unsubscribe: Delete subscription completely
/// - No ON/OFF toggle (simpler UX)
/// - No store_id (company-wide subscriptions only)
class SubscriptionDialog extends ConsumerStatefulWidget {
  final TemplateWithSubscription template;
  final String userId;
  final String companyId;

  const SubscriptionDialog({
    super.key,
    required this.template,
    required this.userId,
    required this.companyId,
  });

  @override
  ConsumerState<SubscriptionDialog> createState() => _SubscriptionDialogState();
}

class _SubscriptionDialogState extends ConsumerState<SubscriptionDialog> {
  late String _scheduleTime; // ✅ Stored in UTC format for DB
  late List<int> _scheduleDays;
  late int? _monthlySendDay;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize with current or default values (already in UTC from DB)
    _scheduleTime = widget.template.subscriptionScheduleTime ??
        widget.template.defaultScheduleTime ??
        '09:00:00'; // Default UTC time
    _scheduleDays = List<int>.from(
      widget.template.subscriptionScheduleDays ??
          widget.template.defaultScheduleDays ??
          [],
    );
    _monthlySendDay = widget.template.subscriptionMonthlySendDay ??
        widget.template.defaultMonthlyDay;
  }

  /// Get local time string for display (UTC → Local)
  String get _localTimeString {
    try {
      final parts = _scheduleTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Create UTC DateTime from time string
      final now = DateTime.now().toUtc();
      final utcDateTime =
          DateTime.utc(now.year, now.month, now.day, hour, minute);

      // Convert to local
      final localDateTime = utcDateTime.toLocal();
      final result = DateTimeUtils.formatTimeOnly(localDateTime);

      print(
          '[SubscriptionDialog] 📍 Display time: UTC $_scheduleTime → Local $result');
      return result;
    } catch (e) {
      print('[SubscriptionDialog] ❌ Error converting time: $e');
      return _scheduleTime; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubscribed = widget.template.isSubscribed;
    final frequency = widget.template.frequency.toLowerCase();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and close button
              Row(
                children: [
                  // Category icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      ReportIcons.getCategoryIcon(widget.template.categoryName),
                      size: 24,
                      color: _getCategoryColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.template.templateName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getFrequencyText(frequency),
                          style: TextStyle(
                            fontSize: 14,
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                    color: TossColors.gray600,
                  ),
                ],
              ),

              // Description
              if (widget.template.description != null) ...[
                const SizedBox(height: 16),
                Text(
                  widget.template.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: TossColors.gray700,
                  ),
                ),
              ],

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Schedule time picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading:
                    const Icon(Icons.access_time, color: TossColors.primary),
                title: const Text('Delivery time'),
                subtitle: Text(_localTimeString), // ✅ Show local time, not UTC
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectTime,
              ),

              // Days picker (for weekly frequency)
              if (frequency == 'weekly') ...[
                const SizedBox(height: 16),
                const Text(
                  'Delivery days',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(7, (index) {
                    final dayNames = [
                      'Sun',
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat'
                    ];
                    final isSelected = _scheduleDays.contains(index);
                    return FilterChip(
                      label: Text(dayNames[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _scheduleDays.add(index);
                            _scheduleDays.sort();
                          } else {
                            _scheduleDays.remove(index);
                          }
                        });
                      },
                      selectedColor: TossColors.primary.withOpacity(0.2),
                      checkmarkColor: TossColors.primary,
                    );
                  }),
                ),
              ],

              // Monthly day picker (for monthly frequency)
              if (frequency == 'monthly') ...[
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today,
                      color: TossColors.primary),
                  title: const Text('Monthly delivery day'),
                  subtitle: Text(_monthlySendDay != null
                      ? 'Day $_monthlySendDay of month'
                      : 'Not selected'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _selectMonthlyDay,
                ),
              ],

              const SizedBox(height: 24),

              // Action buttons - minimal design
              if (isSubscribed) ...[
                // Two buttons side by side for subscribed templates
                Row(
                  children: [
                    // Update Settings button
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleUpdateSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TossColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unsubscribe button
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _handleUnsubscribe,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TossColors.error,
                          side: const BorderSide(
                              color: TossColors.error, width: 1),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else
                // Subscribe button (for non-subscribed templates)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Subscribe',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get category color (matches report cards)
  Color _getCategoryColor() => CategoryUtils.getCategoryColor(widget.template.categoryName);

  Future<void> _selectTime() async {
    // ✅ Convert UTC time to local for initial time picker display
    final parts = _scheduleTime.split(':');
    final utcHour = int.parse(parts[0]);
    final utcMinute = int.parse(parts[1]);

    final now = DateTime.now().toUtc();
    final utcDateTime =
        DateTime.utc(now.year, now.month, now.day, utcHour, utcMinute);
    final localDateTime = utcDateTime.toLocal();

    final initialTime = TimeOfDay(
      hour: localDateTime.hour,
      minute: localDateTime.minute,
    );

    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (newTime != null && mounted) { // ✅ mounted 체크 추가
      // ✅ Convert selected local time back to UTC for database storage
      final selectedLocal =
          DateTime(now.year, now.month, now.day, newTime.hour, newTime.minute);
      final selectedUtc = selectedLocal.toUtc();
      final utcTimeString = DateTimeUtils.formatTimeOnly(selectedUtc);

      setState(() {
        _scheduleTime = '$utcTimeString:00';
      });

      print(
          '[SubscriptionDialog] 🕐 Selected local: ${newTime.hour}:${newTime.minute} → Stored UTC: $_scheduleTime');
    }
  }

  Future<void> _selectMonthlyDay() async {
    final day = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select monthly delivery day'),
        children: List.generate(ReportConstants.maxDayOfMonth, (index) {
          final day = index + 1;
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, day),
            child: Text('Day $day of month'),
          );
        }),
      ),
    );

    if (day != null && mounted) { // ✅ mounted 체크 추가
      setState(() {
        _monthlySendDay = day;
      });
    }
  }

  Future<void> _handleSubscribe() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    // ✅ No store_id - company-wide subscription only
    final subscriptionId =
        await ref.read(reportProvider.notifier).subscribeToTemplate(
              userId: widget.userId,
              companyId: widget.companyId,
              storeId: null, // ✅ Always null (no store-specific subscriptions)
              templateId: widget.template.templateId,
              subscriptionName: null,
              scheduleTime: _scheduleTime,
              scheduleDays: _scheduleDays.isEmpty ? null : _scheduleDays,
              monthlySendDay: _monthlySendDay,
              timezone: DateTimeUtils.getLocalTimezone(),
              notificationChannels: ReportConstants.defaultNotificationChannels,
            );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (subscriptionId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ReportStrings.subscribeSuccess),
          backgroundColor: TossColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ReportStrings.subscribeFailed),
          backgroundColor: TossColors.error,
        ),
      );
    }
  }

  Future<void> _handleUpdateSettings() async {
    if (widget.template.subscriptionId == null) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    // ✅ Update existing subscription settings (time, days, etc.)
    final success = await ref.read(reportProvider.notifier).updateSubscription(
          subscriptionId: widget.template.subscriptionId!,
          userId: widget.userId,
          scheduleTime: _scheduleTime,
          scheduleDays: _scheduleDays.isEmpty ? null : _scheduleDays,
          monthlySendDay: _monthlySendDay,
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings updated successfully'),
          backgroundColor: TossColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update settings'),
          backgroundColor: TossColors.error,
        ),
      );
    }
  }

  Future<void> _handleUnsubscribe() async {
    if (widget.template.subscriptionId == null) return;
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(ReportStrings.unsubscribeConfirmTitle),
        content: const Text(ReportStrings.unsubscribeConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(ReportStrings.confirmNo),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              ReportStrings.confirmYes,
              style: TextStyle(color: TossColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    final success =
        await ref.read(reportProvider.notifier).unsubscribeFromTemplate(
              subscriptionId: widget.template.subscriptionId!,
              userId: widget.userId,
              companyId: widget.companyId,
            );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ReportStrings.unsubscribeSuccess),
          backgroundColor: TossColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ReportStrings.unsubscribeFailed),
          backgroundColor: TossColors.error,
        ),
      );
    }
  }

  String _getFrequencyText(String frequency) {
    switch (frequency) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'monthly':
        return 'Monthly';
      default:
        return frequency;
    }
  }
}
