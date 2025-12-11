import '../../domain/entities/inventory_session.dart';
import '../../domain/entities/session_item.dart';
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
}
