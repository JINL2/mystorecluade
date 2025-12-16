import '../entities/invoice.dart';
import '../entities/invoice_detail.dart';
import '../value_objects/invoice_filter.dart';

/// Invoice repository interface
abstract class InvoiceRepository {
  /// Get paginated invoices with filters
  Future<InvoicePageResult> getInvoices({
    required String companyId,
    required String storeId,
    required InvoiceFilter filter,
  });

  /// Get invoice by ID
  Future<Invoice?> getInvoiceById({
    required String invoiceId,
  });

  /// Get invoice detail with items
  Future<InvoiceDetail> getInvoiceDetail({
    required String invoiceId,
  });

  /// Refresh invoice data
  Future<InvoicePageResult> refresh({
    required String companyId,
    required String storeId,
    required InvoiceFilter filter,
  });

  /// Refund invoice(s)
  Future<RefundResult> refundInvoice({
    required List<String> invoiceIds,
    required String userId,
    String? notes,
  });
}

/// Invoice page result
class InvoicePageResult {
  final List<Invoice> invoices;
  final Pagination pagination;
  final InvoiceSummary summary;
  final Currency currency;

  const InvoicePageResult({
    required this.invoices,
    required this.pagination,
    required this.summary,
    required this.currency,
  });
}

/// Pagination info
class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });
}

/// Invoice summary
class InvoiceSummary {
  final int invoiceCount;
  final double totalAmount;
  final double avgPerInvoice;
  final StatusSummary byStatus;
  final PaymentSummary byPayment;

  const InvoiceSummary({
    required this.invoiceCount,
    required this.totalAmount,
    required this.avgPerInvoice,
    required this.byStatus,
    required this.byPayment,
  });
}

/// Status summary
class StatusSummary {
  final int completed;
  final int draft;
  final int cancelled;

  const StatusSummary({
    required this.completed,
    required this.draft,
    required this.cancelled,
  });
}

/// Payment summary
class PaymentSummary {
  final int cash;
  final int card;
  final int transfer;

  const PaymentSummary({
    required this.cash,
    required this.card,
    required this.transfer,
  });
}

/// Currency
class Currency {
  final String code;
  final String name;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });
}

/// Refund result
class RefundResult {
  final bool success;
  final int totalProcessed;
  final int totalSucceeded;
  final int totalFailed;
  final double totalAmountRefunded;
  final List<RefundItemResult> results;
  final String? errorMessage;

  const RefundResult({
    required this.success,
    this.totalProcessed = 0,
    this.totalSucceeded = 0,
    this.totalFailed = 0,
    this.totalAmountRefunded = 0,
    this.results = const [],
    this.errorMessage,
  });

  factory RefundResult.fromJson(Map<String, dynamic> json) {
    final resultsList = (json['results'] as List<dynamic>? ?? [])
        .map((e) => RefundItemResult.fromJson(e as Map<String, dynamic>))
        .toList();

    return RefundResult(
      success: json['success'] as bool? ?? false,
      totalProcessed: json['total_processed'] as int? ?? 0,
      totalSucceeded: json['total_succeeded'] as int? ?? 0,
      totalFailed: json['total_failed'] as int? ?? 0,
      totalAmountRefunded: (json['total_amount_refunded'] as num?)?.toDouble() ?? 0,
      results: resultsList,
      errorMessage: json['message'] as String?,
    );
  }
}

/// Individual refund item result
class RefundItemResult {
  final bool success;
  final String invoiceId;
  final String? invoiceNumber;
  final int itemsRefunded;
  final double totalRefunded;
  final String? error;
  final List<String> warnings;

  const RefundItemResult({
    required this.success,
    required this.invoiceId,
    this.invoiceNumber,
    this.itemsRefunded = 0,
    this.totalRefunded = 0,
    this.error,
    this.warnings = const [],
  });

  factory RefundItemResult.fromJson(Map<String, dynamic> json) {
    final warningsList = (json['warnings'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return RefundItemResult(
      success: json['success'] as bool? ?? false,
      invoiceId: json['invoice_id'] as String? ?? '',
      invoiceNumber: json['invoice_number'] as String?,
      itemsRefunded: json['items_refunded'] as int? ?? 0,
      totalRefunded: (json['total_refunded'] as num?)?.toDouble() ?? 0,
      error: json['error'] as String?,
      warnings: warningsList,
    );
  }
}
