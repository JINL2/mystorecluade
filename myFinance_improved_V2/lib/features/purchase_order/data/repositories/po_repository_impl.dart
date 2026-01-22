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
  Future<PurchaseOrder> getById(String poId) async {
    final model = await _datasource.getById(poId);
    return model.toEntity();
  }

  @override
  Future<PurchaseOrder> create(POCreateParams params) async {
    final model = await _datasource.create(params);
    return model.toEntity();
  }

  @override
  Future<PurchaseOrder> update(
      String poId, int version, Map<String, dynamic> updates) async {
    final model = await _datasource.update(poId, version, updates);
    return model.toEntity();
  }

  @override
  Future<void> delete(String poId) async {
    await _datasource.delete(poId);
  }

  @override
  Future<void> confirm(String poId) async {
    await _datasource.confirm(poId);
  }

  @override
  Future<void> updateStatus(String poId, POStatus newStatus,
      {String? notes}) async {
    await _datasource.updateStatus(poId, newStatus, notes: notes);
  }

  @override
  Future<String> convertFromPI(String piId,
      {Map<String, dynamic>? options}) async {
    return _datasource.convertFromPI(piId, options: options);
  }

  @override
  Future<String> generateNumber(String companyId) async {
    return _datasource.generateNumber(companyId);
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
  Future<List<AcceptedPIForConversion>> getAcceptedPIsForConversion() async {
    return _datasource.getAcceptedPIsForConversion();
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
