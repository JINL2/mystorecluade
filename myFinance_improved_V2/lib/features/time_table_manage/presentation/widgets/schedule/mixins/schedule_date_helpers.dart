/// Schedule Date Helpers Mixin
///
/// Provides date and week formatting utilities for ScheduleTabContent.
/// Extracted to reduce file size and improve maintainability.
mixin ScheduleDateHelpersMixin {
  /// Get Monday of the week for a given date
  DateTime getWeekStart(DateTime date) {
    final weekday = date.weekday; // Monday = 1, Sunday = 7
    return date.subtract(Duration(days: weekday - 1));
  }

  /// Get week label (e.g., "This week", "Next week", "Last week", or "Week 52")
  String getWeekLabel(DateTime currentWeekStart) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayWeekStart = today.subtract(Duration(days: today.weekday - 1));

    // Check if _currentWeekStart is the same week as today
    if (currentWeekStart.year == todayWeekStart.year &&
        currentWeekStart.month == todayWeekStart.month &&
        currentWeekStart.day == todayWeekStart.day) {
      return 'This week';
    }

    // Check if it's next week (7 days ahead)
    final nextWeekStart = todayWeekStart.add(const Duration(days: 7));
    if (currentWeekStart.year == nextWeekStart.year &&
        currentWeekStart.month == nextWeekStart.month &&
        currentWeekStart.day == nextWeekStart.day) {
      return 'Next week';
    }

    // Check if it's previous week (7 days back)
    final previousWeekStart = todayWeekStart.subtract(const Duration(days: 7));
    if (currentWeekStart.year == previousWeekStart.year &&
        currentWeekStart.month == previousWeekStart.month &&
        currentWeekStart.day == previousWeekStart.day) {
      return 'Last week';
    }

    // Otherwise, return "Week [number]" (ISO week number)
    final weekNumber = getIsoWeekNumber(currentWeekStart);
    return 'Week $weekNumber';
  }

  /// Calculate ISO week number (1-53)
  /// ISO 8601: Week 1 is the week containing the first Thursday of the year
  int getIsoWeekNumber(DateTime date) {
    // Find the Thursday of the current week
    final thursday = date.add(Duration(days: 4 - date.weekday));

    // Find January 1st of that Thursday's year
    final jan1 = DateTime(thursday.year, 1, 1);

    // Calculate the number of days from Jan 1 to the Thursday
    final daysDiff = thursday.difference(jan1).inDays;

    // Week number is (days / 7) + 1
    return (daysDiff / 7).floor() + 1;
  }

  /// Format week range for navigation (e.g., "10-16 Jun")
  String formatWeekRange(DateTime currentWeekStart) {
    final weekEnd = currentWeekStart.add(const Duration(days: 6));
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${currentWeekStart.day}-${weekEnd.day} ${months[currentWeekStart.month - 1]}';
  }

  /// Format selected date (e.g., "Wed, 12 Jun")
  String formatSelectedDate(DateTime selectedDate) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dayName = weekdays[selectedDate.weekday - 1];
    return '$dayName, ${selectedDate.day} ${months[selectedDate.month - 1]}';
  }

  /// Format time string to HH:mm format
  String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '--:--';

    try {
      // Remove timezone offset and seconds (e.g., "02:00:00+07" -> "02:00")
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
    } catch (e) {
      // Return original on error
    }

    return timeString;
  }
}
