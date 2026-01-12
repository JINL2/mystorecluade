import '../../domain/entities/invoice.dart';

/// Presentation extension for Invoice display formatting
///
/// These methods are UI concerns and should NOT be in Domain Entity.
/// - timeString: UI time format (HH:mm)
/// - dateString: UI date format with relative dates ("Today", "Yesterday")
extension InvoiceDisplay on Invoice {
  /// Get formatted time string (HH:mm)
  String get timeString {
    return '${saleDate.hour.toString().padLeft(2, '0')}:${saleDate.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted date string with relative dates
  String get dateString {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final invoiceDay = DateTime(saleDate.year, saleDate.month, saleDate.day);

    if (invoiceDay == today) {
      return 'Today, ${_formatDate(saleDate)}';
    } else if (invoiceDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${_formatDate(saleDate)}';
    } else {
      return '${_getDayName(saleDate)}, ${_formatDate(saleDate)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }
}
