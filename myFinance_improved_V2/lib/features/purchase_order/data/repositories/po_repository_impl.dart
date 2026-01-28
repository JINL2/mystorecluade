import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/po_repository.dart';
import '../datasources/po_remote_datasource.dart';

/// PO Repository Implementation
class PORepositoryImpl implements PORepository {
  final PORemoteDatasource _datasource;

  PORepositoryImpl(this._datasource);

  @override
  Future<PaginatedPOResponse> getList(POListParams params) async {
    return _datasource.getList(params);
  }

  @override
  Future<PurchaseOrder> getById(String poId, {required String companyId}) async {
    final model = await _datasource.getById(poId, companyId: companyId);
    return model.toEntity();
  }

  @override
  Future<Map<String, dynamic>> closeOrder({
    required String orderId,
    required String userId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    return _datasource.closeOrder(
      orderId: orderId,
      userId: userId,
      companyId: companyId,
      timezone: timezone,
    );
  }

  @override
  Future<Map<String, dynamic>> createOrderV4({
    required String companyId,
    required String userId,
    required List<Map<String, dynamic>> items,
    required String orderTitle,
    String? counterpartyId,
    Map<String, dynamic>? supplierInfo,
    String? notes,
    String? orderNumber,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    return _datasource.createOrderV4(
      companyId: companyId,
      userId: userId,
      items: items,
      orderTitle: orderTitle,
      counterpartyId: counterpartyId,
      supplierInfo: supplierInfo,
      notes: notes,
      orderNumber: orderNumber,
      timezone: timezone,
    );
  }

  @override
  Future<List<SupplierFilterItem>> getSuppliers(String companyId) async {
    return _datasource.getSuppliers(companyId);
  }

  @override
  Future<BaseCurrencyData> getBaseCurrency(String companyId) async {
    return _datasource.getBaseCurrency(companyId);
  }

  @override
  Future<ProductSearchResult> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    return _datasource.searchProducts(
      companyId: companyId,
      storeId: storeId,
      query: query,
      page: page,
      limit: limit,
    );
  }
}
