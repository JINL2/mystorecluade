import '../../domain/entities/close_session_response.dart';
import '../../domain/entities/inventory_session.dart';
import '../../domain/entities/join_session_response.dart';
import '../../domain/entities/session_history_item.dart';
import '../../domain/entities/session_item.dart';
import '../../domain/entities/session_list_item.dart';
import '../../domain/entities/session_review_item.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/entities/update_session_items_response.dart';
import '../../domain/entities/user_session_items.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_datasource.dart';

/// Implementation of SessionRepository
class SessionRepositoryImpl implements SessionRepository {
  final SessionDatasource _datasource;

  SessionRepositoryImpl(this._datasource);

  @override
  Future<SessionListResponse> getSessionList({
    required String companyId,
    String? storeId,
    String? sessionType,
    String? shipmentId,
    bool? isActive,
    String? createdBy,
    int limit = 50,
    int offset = 0,
  }) async {
    return _datasource.getSessionList(
      companyId: companyId,
      storeId: storeId,
      sessionType: sessionType,
      shipmentId: shipmentId,
      isActive: isActive,
      createdBy: createdBy,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<InventorySession>> getSessions({
    required String companyId,
    String? sessionType,
    String? status,
  }) async {
    return _datasource.getSessions(
      companyId: companyId,
      sessionType: sessionType,
      status: status,
    );
  }

  @override
  Future<InventorySession?> getSession({
    required String sessionId,
  }) async {
    return _datasource.getSession(sessionId: sessionId);
  }

  @override
  Future<InventorySession> createSession({
    required String companyId,
    required String sessionName,
    required String sessionType,
    required String storeId,
    required String createdBy,
    String? notes,
  }) async {
    return _datasource.createSession(
      companyId: companyId,
      sessionName: sessionName,
      sessionType: sessionType,
      storeId: storeId,
      createdBy: createdBy,
      notes: notes,
    );
  }

  @override
  Future<InventorySession> updateSessionStatus({
    required String sessionId,
    required String status,
  }) async {
    return _datasource.updateSessionStatus(
      sessionId: sessionId,
      status: status,
    );
  }

  @override
  Future<void> deleteSession({
    required String sessionId,
  }) async {
    return _datasource.deleteSession(sessionId: sessionId);
  }

  @override
  Future<List<SessionItem>> getSessionItems({
    required String sessionId,
  }) async {
    return _datasource.getSessionItems(sessionId: sessionId);
  }

  @override
  Future<SessionItem> addSessionItem({
    required String sessionId,
    required String productId,
    required String productName,
    String? sku,
    String? barcode,
    String? imageUrl,
    required int quantity,
    double? unitPrice,
    String? notes,
  }) async {
    return _datasource.addSessionItem(
      sessionId: sessionId,
      productId: productId,
      productName: productName,
      sku: sku,
      barcode: barcode,
      imageUrl: imageUrl,
      quantity: quantity,
      unitPrice: unitPrice,
      notes: notes,
    );
  }

  @override
  Future<SessionItem> updateSessionItem({
    required String itemId,
    required int quantity,
    String? notes,
  }) async {
    return _datasource.updateSessionItem(
      itemId: itemId,
      quantity: quantity,
      notes: notes,
    );
  }

  @override
  Future<void> removeSessionItem({
    required String itemId,
  }) async {
    return _datasource.removeSessionItem(itemId: itemId);
  }

  @override
  Future<InventorySession> completeSession({
    required String sessionId,
  }) async {
    return _datasource.completeSession(sessionId: sessionId);
  }

  @override
  Future<SessionReviewResponse> getSessionReviewItems({
    required String sessionId,
    required String userId,
  }) async {
    return _datasource.getSessionReviewItems(
      sessionId: sessionId,
      userId: userId,
    );
  }

  @override
  Future<SessionSubmitResponse> submitSession({
    required String sessionId,
    required String userId,
    required List<SessionSubmitItem> items,
    bool isFinal = false,
    String? notes,
  }) async {
    return _datasource.submitSession(
      sessionId: sessionId,
      userId: userId,
      items: items.map((e) => e.toJson()).toList(),
      isFinal: isFinal,
      notes: notes,
    );
  }

  @override
  Future<CreateSessionResponse> createSessionViaRpc({
    required String companyId,
    required String storeId,
    required String userId,
    required String sessionType,
    String? sessionName,
    String? shipmentId,
  }) async {
    return _datasource.createSessionViaRpc(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      sessionType: sessionType,
      sessionName: sessionName,
      shipmentId: shipmentId,
    );
  }

  @override
  Future<ShipmentListResponse> getShipmentList({
    required String companyId,
    String? search,
    String? status,
    String? supplierId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    int offset = 0,
  }) async {
    return _datasource.getShipmentList(
      companyId: companyId,
      search: search,
      status: status,
      supplierId: supplierId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<ProductSearchResponse> getInventoryPage({
    required String companyId,
    required String storeId,
    String? search,
    int page = 1,
    int limit = 15,
  }) async {
    return _datasource.getInventoryPage(
      companyId: companyId,
      storeId: storeId,
      search: search,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<ProductSearchResponse> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int limit = 20,
  }) async {
    return _datasource.searchProducts(
      companyId: companyId,
      storeId: storeId,
      query: query,
      limit: limit,
    );
  }

  @override
  Future<AddSessionItemsResponse> addSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  }) async {
    return _datasource.addSessionItems(
      sessionId: sessionId,
      userId: userId,
      items: items,
    );
  }

  @override
  Future<JoinSessionResponse> joinSession({
    required String sessionId,
    required String userId,
  }) async {
    return _datasource.joinSession(
      sessionId: sessionId,
      userId: userId,
    );
  }

  @override
  Future<CloseSessionResponse> closeSession({
    required String sessionId,
    required String userId,
    required String companyId,
  }) async {
    return _datasource.closeSession(
      sessionId: sessionId,
      userId: userId,
      companyId: companyId,
    );
  }

  @override
  Future<SessionHistoryResponse> getSessionHistory({
    required String companyId,
    String? storeId,
    String? sessionType,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 15,
    int offset = 0,
  }) async {
    return _datasource.getSessionHistory(
      companyId: companyId,
      storeId: storeId,
      sessionType: sessionType,
      isActive: isActive,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Map<String, int>> getProductStockByStore({
    required String companyId,
    required String storeId,
    required List<String> productIds,
  }) async {
    return _datasource.getProductStockByStore(
      companyId: companyId,
      storeId: storeId,
      productIds: productIds,
    );
  }

  @override
  Future<UserSessionItemsResponse> getUserSessionItems({
    required String sessionId,
    required String userId,
  }) async {
    final model = await _datasource.getUserSessionItems(
      sessionId: sessionId,
      userId: userId,
    );
    return model.toEntity();
  }

  @override
  Future<UpdateSessionItemsResponse> updateSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  }) async {
    final model = await _datasource.updateSessionItems(
      sessionId: sessionId,
      userId: userId,
      items: items,
    );
    return model.toEntity();
  }
}
