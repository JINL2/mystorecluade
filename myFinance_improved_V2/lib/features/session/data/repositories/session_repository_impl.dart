import '../../domain/entities/close_session_response.dart';
import '../../domain/entities/inventory_session.dart';
import '../../domain/entities/join_session_response.dart';
import '../../domain/entities/session_compare_result.dart';
import '../../domain/entities/session_history_item.dart';
import '../../domain/entities/session_item.dart';
import '../../domain/entities/session_list_item.dart';
import '../../domain/entities/session_review_item.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/entities/update_session_items_response.dart';
import '../../domain/entities/user_session_items.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_datasource.dart';
import '../models/session_item_input_model.dart';

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
    final model = await _datasource.getSessionList(
      companyId: companyId,
      storeId: storeId,
      sessionType: sessionType,
      shipmentId: shipmentId,
      isActive: isActive,
      createdBy: createdBy,
      limit: limit,
      offset: offset,
    );
    return model.toEntity();
  }

  @override
  Future<List<InventorySession>> getSessions({
    required String companyId,
    String? sessionType,
    String? status,
  }) async {
    final models = await _datasource.getSessions(
      companyId: companyId,
      sessionType: sessionType,
      status: status,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<InventorySession?> getSession({
    required String sessionId,
  }) async {
    final model = await _datasource.getSession(sessionId: sessionId);
    return model?.toEntity();
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
    final model = await _datasource.createSession(
      companyId: companyId,
      sessionName: sessionName,
      sessionType: sessionType,
      storeId: storeId,
      createdBy: createdBy,
      notes: notes,
    );
    return model.toEntity();
  }

  @override
  Future<InventorySession> updateSessionStatus({
    required String sessionId,
    required String status,
  }) async {
    final model = await _datasource.updateSessionStatus(
      sessionId: sessionId,
      status: status,
    );
    return model.toEntity();
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
    final models = await _datasource.getSessionItems(sessionId: sessionId);
    return models.map((m) => m.toEntity()).toList();
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
    final model = await _datasource.addSessionItem(
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
    return model.toEntity();
  }

  @override
  Future<SessionItem> updateSessionItem({
    required String itemId,
    required int quantity,
    String? notes,
  }) async {
    final model = await _datasource.updateSessionItem(
      itemId: itemId,
      quantity: quantity,
      notes: notes,
    );
    return model.toEntity();
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
    final model = await _datasource.completeSession(sessionId: sessionId);
    return model.toEntity();
  }

  @override
  Future<SessionReviewResponse> getSessionReviewItems({
    required String sessionId,
    required String userId,
  }) async {
    final model = await _datasource.getSessionReviewItems(
      sessionId: sessionId,
      userId: userId,
    );
    return model.toEntity();
  }

  @override
  Future<SessionSubmitResponse> submitSession({
    required String sessionId,
    required String userId,
    required List<SessionSubmitItem> items,
    bool isFinal = false,
    String? notes,
  }) async {
    final model = await _datasource.submitSession(
      sessionId: sessionId,
      userId: userId,
      items: items.map((e) => e.toJson()).toList(),
      isFinal: isFinal,
      notes: notes,
    );
    return model.toEntity();
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
    final model = await _datasource.createSessionViaRpc(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      sessionType: sessionType,
      sessionName: sessionName,
      shipmentId: shipmentId,
    );
    return model.toEntity();
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
    final model = await _datasource.getShipmentList(
      companyId: companyId,
      search: search,
      status: status,
      supplierId: supplierId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      offset: offset,
    );
    return model.toEntity();
  }

  @override
  Future<ProductSearchResponse> getInventoryPage({
    required String companyId,
    required String storeId,
    String? search,
    int page = 1,
    int limit = 15,
  }) async {
    final model = await _datasource.getInventoryPage(
      companyId: companyId,
      storeId: storeId,
      search: search,
      page: page,
      limit: limit,
    );
    return model.toEntity();
  }

  @override
  Future<ProductSearchResponse> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int limit = 20,
  }) async {
    final model = await _datasource.searchProducts(
      companyId: companyId,
      storeId: storeId,
      query: query,
      limit: limit,
    );
    return model.toEntity();
  }

  @override
  Future<AddSessionItemsResponse> addSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  }) async {
    // Convert Domain Entity to Data Model
    final modelItems = items
        .map((e) => SessionItemInputModel(
              productId: e.productId,
              quantity: e.quantity,
              quantityRejected: e.quantityRejected,
            ))
        .toList();
    final model = await _datasource.addSessionItems(
      sessionId: sessionId,
      userId: userId,
      items: modelItems,
    );
    return model.toEntity();
  }

  @override
  Future<JoinSessionResponse> joinSession({
    required String sessionId,
    required String userId,
  }) async {
    final model = await _datasource.joinSession(
      sessionId: sessionId,
      userId: userId,
    );
    return model.toEntity();
  }

  @override
  Future<CloseSessionResponse> closeSession({
    required String sessionId,
    required String userId,
    required String companyId,
  }) async {
    final model = await _datasource.closeSession(
      sessionId: sessionId,
      userId: userId,
      companyId: companyId,
    );
    return model.toEntity();
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
    final model = await _datasource.getSessionHistory(
      companyId: companyId,
      storeId: storeId,
      sessionType: sessionType,
      isActive: isActive,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      offset: offset,
    );
    return model.toEntity();
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
    // Convert Domain Entity to Data Model
    final modelItems = items
        .map((e) => SessionItemInputModel(
              productId: e.productId,
              quantity: e.quantity,
              quantityRejected: e.quantityRejected,
            ))
        .toList();
    final model = await _datasource.updateSessionItems(
      sessionId: sessionId,
      userId: userId,
      items: modelItems,
    );
    return model.toEntity();
  }

  @override
  Future<SessionCompareResult> compareSessions({
    required String sourceSessionId,
    required String targetSessionId,
    required String userId,
  }) async {
    final model = await _datasource.compareSessions(
      sourceSessionId: sourceSessionId,
      targetSessionId: targetSessionId,
      userId: userId,
    );
    return model.toEntity();
  }

  @override
  Future<void> mergeSessions({
    required String targetSessionId,
    required String sourceSessionId,
    required String userId,
  }) async {
    await _datasource.mergeSessions(
      targetSessionId: targetSessionId,
      sourceSessionId: sourceSessionId,
      userId: userId,
    );
  }
}
