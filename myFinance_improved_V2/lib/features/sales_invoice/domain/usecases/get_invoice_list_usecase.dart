import '../repositories/invoice_repository.dart';
import '../value_objects/invoice_filter.dart';

/// Use case for retrieving invoice list
///
/// Orchestrates invoice list retrieval with filtering and sorting.
/// Contains business logic for invoice list management.
class GetInvoiceListUseCase {
  final InvoiceRepository _invoiceRepository;

  const GetInvoiceListUseCase({
    required InvoiceRepository invoiceRepository,
  }) : _invoiceRepository = invoiceRepository;

  /// Executes the get invoice list use case
  ///
  /// Parameters:
  /// - [companyId]: Company ID to filter invoices
  /// - [storeId]: Store ID to filter invoices
  /// - [filter]: Filter options (period, status, search query)
  ///
  /// Returns: InvoicePageResult containing invoices and metadata
  Future<InvoicePageResult> execute({
    required String companyId,
    required String storeId,
    required InvoiceFilter filter,
  }) async {
    // Validate input parameters
    if (companyId.isEmpty) {
      throw ArgumentError('Company ID cannot be empty');
    }

    if (storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }

    // Fetch invoices from repository
    final result = await _invoiceRepository.getInvoices(
      companyId: companyId,
      storeId: storeId,
      filter: filter,
    );

    return result;
  }
}
