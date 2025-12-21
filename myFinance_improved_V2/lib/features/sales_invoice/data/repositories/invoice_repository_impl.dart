import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/value_objects/invoice_filter.dart';
import '../datasources/invoice_remote_datasource.dart';

/// Invoice repository implementation
class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource _remoteDataSource;

  InvoiceRepositoryImpl(this._remoteDataSource);

  @override
  Future<InvoicePageResult> getInvoices({
    required String companyId,
    required String storeId,
    required InvoiceFilter filter,
  }) async {
    final response = await _remoteDataSource.getInvoices(
      companyId: companyId,
      storeId: storeId,
      filter: filter,
    );

    return response.toResult();
  }

  @override
  Future<Invoice?> getInvoiceById({
    required String invoiceId,
  }) async {
    // TODO: Implement get invoice by ID
    throw UnimplementedError('Get invoice by ID not implemented yet');
  }

  @override
  Future<InvoicePageResult> refresh({
    required String companyId,
    required String storeId,
    required InvoiceFilter filter,
  }) async {
    return getInvoices(
      companyId: companyId,
      storeId: storeId,
      filter: filter,
    );
  }

  @override
  Future<RefundResult> refundInvoice({
    required List<String> invoiceIds,
    required String userId,
    String? notes,
  }) async {
    final response = await _remoteDataSource.refundInvoice(
      invoiceIds: invoiceIds,
      userId: userId,
      notes: notes,
    );
    return RefundResult.fromJson(response);
  }
}
