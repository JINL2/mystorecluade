import '../entities/invoice.dart';
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

  /// Refund an invoice
  Future<RefundResult> refundInvoice({
    required String invoiceId,
    required String userId,
  });

  /// Refresh invoice data
  Future<InvoicePageResult> refresh({
    required String companyId,
    required String storeId,
    required InvoiceFilter filter,
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
  final String? invoiceNumber;
  final List<String>? warnings;

  const RefundResult({
    required this.success,
    this.invoiceNumber,
    this.warnings,
  });
}
