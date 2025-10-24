import 'package:equatable/equatable.dart';
import 'customer.dart';
import 'invoice_amounts.dart';
import 'items_summary.dart';

/// Core Invoice entity representing a sales invoice
class Invoice extends Equatable {
  final String invoiceId;
  final String invoiceNumber;
  final DateTime saleDate;
  final String status;
  final Customer? customer;
  final String storeId;
  final String storeName;
  final String storeCode;
  final String paymentMethod;
  final String paymentStatus;
  final InvoiceAmounts amounts;
  final ItemsSummary itemsSummary;
  final String? createdById;
  final String? createdByName;
  final String? createdByEmail;
  final DateTime createdAt;

  const Invoice({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.saleDate,
    required this.status,
    this.customer,
    required this.storeId,
    required this.storeName,
    required this.storeCode,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.amounts,
    required this.itemsSummary,
    this.createdById,
    this.createdByName,
    this.createdByEmail,
    required this.createdAt,
  });

  /// Helper getters for status checking
  bool get isCompleted => status == 'completed';
  bool get isDraft => status == 'draft';
  bool get isCancelled => status == 'cancelled';

  /// Helper getters for payment status
  bool get isPaid => paymentStatus == 'paid';
  bool get isPending => paymentStatus == 'pending';

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

  @override
  List<Object?> get props => [
        invoiceId,
        invoiceNumber,
        saleDate,
        status,
        customer,
        storeId,
        storeName,
        storeCode,
        paymentMethod,
        paymentStatus,
        amounts,
        itemsSummary,
        createdById,
        createdByName,
        createdByEmail,
        createdAt,
      ];
}
