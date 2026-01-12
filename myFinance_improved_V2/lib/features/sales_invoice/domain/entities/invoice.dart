import 'package:equatable/equatable.dart';
import 'customer.dart';
import 'invoice_amounts.dart';
import 'items_summary.dart';

/// Cash location info for invoice
class InvoiceCashLocation extends Equatable {
  final String cashLocationId;
  final String locationName;
  final String locationType; // 'cash', 'bank', 'vault'

  const InvoiceCashLocation({
    required this.cashLocationId,
    required this.locationName,
    required this.locationType,
  });

  @override
  List<Object?> get props => [cashLocationId, locationName, locationType];
}

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
  final InvoiceCashLocation? cashLocation;
  final String paymentMethod;
  final String paymentStatus;
  final InvoiceAmounts amounts;
  final ItemsSummary itemsSummary;
  final String? aiDescription;
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
    this.cashLocation,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.amounts,
    required this.itemsSummary,
    this.aiDescription,
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

  // NOTE: timeString and dateString moved to presentation/extensions/invoice_display_extension.dart
  // UI formatting is a Presentation concern, not Domain

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
        cashLocation,
        paymentMethod,
        paymentStatus,
        amounts,
        itemsSummary,
        aiDescription,
        createdById,
        createdByName,
        createdByEmail,
        createdAt,
      ];
}
