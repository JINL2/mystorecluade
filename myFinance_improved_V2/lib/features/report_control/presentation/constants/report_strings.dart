// lib/features/report_control/presentation/constants/report_strings.dart

/// UI strings for Report Control feature
///
/// Centralized strings for consistency and easy i18n support
class ReportStrings {
  ReportStrings._(); // Private constructor

  // ==================== Tab Labels ====================
  static const String tabReceivedReports = 'Received Reports';
  static const String tabSubscribeReports = 'Subscribe to Reports';

  // ==================== Empty States ====================
  static const String noReportsMessage = 'No reports received';
  static const String noTemplatesMessage = 'No report templates available';

  // ==================== Filter Labels ====================
  static const String filterAll = 'All';
  static const String filterCompleted = 'Completed';
  static const String filterFailed = 'Failed';
  static const String filterPending = 'Pending';
  static const String filterUnreadOnly = 'Unread only';
  static const String filterReset = 'Reset filters';

  // ==================== Status Labels ====================
  static const String statusCompleted = 'Completed';
  static const String statusFailed = 'Failed';
  static const String statusPending = 'Pending';
  static const String statusSubscribed = 'Subscribed';
  static const String statusPaused = 'Paused';
  static const String statusAvailable = 'Available';

  // ==================== Subscription Messages ====================
  static const String subscribeSuccess = 'Successfully subscribed';
  static const String subscribeFailed =
      'Failed to subscribe. Please try again.';
  static const String updateSuccess = 'Settings saved successfully';
  static const String updateFailed =
      'Failed to save settings. Please try again.';
  static const String unsubscribeSuccess = 'Successfully unsubscribed';
  static const String unsubscribeFailed =
      'Failed to unsubscribe. Please try again.';

  // ==================== Dialog Labels ====================
  static const String unsubscribeConfirmTitle = 'Unsubscribe';
  static const String unsubscribeConfirmMessage =
      'Are you sure you want to unsubscribe?';
  static const String confirmYes = 'Yes';
  static const String confirmNo = 'No';
  static const String selectMonthlyDay = 'Select monthly send day';

  // ==================== Settings Labels ====================
  static const String subscriptionEnabled = 'Enable subscription';
  static const String sendTime = 'Send time';
  static const String sendDays = 'Send days';
  static const String monthlySendDay = 'Monthly send day';
  static const String storeLabel = 'Store';

  // ==================== Action Labels ====================
  static const String subscribe = 'Subscribe';
  static const String unsubscribe = 'Unsubscribe';
  static const String saveSettings = 'Save settings';
  static const String retry = 'Retry';

  // ==================== Section Headers ====================
  static const String sectionSubscribed = 'Subscribed Reports';
  static const String sectionAvailable = 'Available Reports';

  // ==================== Frequency Labels ====================
  static const String frequencyDaily = 'Daily';
  static const String frequencyWeekly = 'Weekly';
  static const String frequencyMonthly = 'Monthly';

  // ==================== Day Labels ====================
  static const List<String> dayNames = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  // ==================== Error Labels ====================
  static const String errorOccurred = 'Error occurred';
  static const String processingTime = 'Processing time';
}
