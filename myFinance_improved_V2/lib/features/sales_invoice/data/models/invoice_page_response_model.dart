import '../../domain/repositories/invoice_repository.dart';
import 'invoice_model.dart';

/// Invoice page response model
class InvoicePageResponseModel {
  final List<InvoiceModel> invoices;
  final Map<String, dynamic> pagination;
  final Map<String, dynamic> filtersApplied;
  final Map<String, dynamic> summary;
  final Map<String, dynamic> currency;

  InvoicePageResponseModel({
    required this.invoices,
    required this.pagination,
    required this.filtersApplied,
    required this.summary,
    required this.currency,
  });

  /// Create from JSON
  factory InvoicePageResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return InvoicePageResponseModel(
      invoices: data['invoices'] != null
          ? (data['invoices'] as List)
              .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      pagination: (data['pagination'] as Map<String, dynamic>?) ?? {},
      filtersApplied: (data['filters_applied'] as Map<String, dynamic>?) ?? {},
      summary: (data['summary'] as Map<String, dynamic>?) ?? {},
      currency: (data['currency'] as Map<String, dynamic>?) ?? {},
    );
  }

  /// Convert to domain result
  InvoicePageResult toResult() {
    return InvoicePageResult(
      invoices: invoices.map((model) => model.toEntity()).toList(),
      pagination: _paginationFromJson(pagination),
      summary: _summaryFromJson(summary),
      currency: _currencyFromJson(currency),
    );
  }

  /// Convert pagination JSON to domain
  Pagination _paginationFromJson(Map<String, dynamic> json) {
    return Pagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: (json['has_next'] as bool?) ?? false,
      hasPrev: (json['has_prev'] as bool?) ?? false,
    );
  }

  /// Convert summary JSON to domain
  InvoiceSummary _summaryFromJson(Map<String, dynamic> json) {
    final periodTotal = json['period_total'] as Map<String, dynamic>? ?? {};
    final byStatus = json['by_status'] as Map<String, dynamic>? ?? {};
    final byPayment = json['by_payment'] as Map<String, dynamic>? ?? {};

    return InvoiceSummary(
      invoiceCount: (periodTotal['invoice_count'] as num?)?.toInt() ?? 0,
      totalAmount: (periodTotal['total_amount'] as num?)?.toDouble() ?? 0.0,
      avgPerInvoice: (periodTotal['avg_per_invoice'] as num?)?.toDouble() ?? 0.0,
      byStatus: StatusSummary(
        completed: (byStatus['completed'] as num?)?.toInt() ?? 0,
        draft: (byStatus['draft'] as num?)?.toInt() ?? 0,
        cancelled: (byStatus['cancelled'] as num?)?.toInt() ?? 0,
      ),
      byPayment: PaymentSummary(
        cash: (byPayment['cash'] as num?)?.toInt() ?? 0,
        card: (byPayment['card'] as num?)?.toInt() ?? 0,
        transfer: (byPayment['transfer'] as num?)?.toInt() ?? 0,
      ),
    );
  }

  /// Convert currency JSON to domain
  Currency _currencyFromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code']?.toString() ?? 'VND',
      name: json['name']?.toString() ?? 'Vietnamese Dong',
      symbol: json['symbol']?.toString() ?? '₫',
    );
  }
}
