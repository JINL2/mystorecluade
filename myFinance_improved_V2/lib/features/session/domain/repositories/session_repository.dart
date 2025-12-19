import '../entities/close_session_response.dart';
import '../entities/inventory_session.dart';
import '../entities/join_session_response.dart';
import '../entities/session_compare_result.dart';
import '../entities/session_history_item.dart';
import '../entities/session_item.dart';
import '../entities/update_session_items_response.dart';
import '../entities/user_session_items.dart';
import '../entities/session_list_item.dart';
import '../entities/session_review_item.dart';
import '../entities/shipment.dart';

/// Repository interface for session operations
abstract class SessionRepository {
  /// Get session list via RPC
  Future<SessionListResponse> getSessionList({
    required String companyId,
    String? storeId,
    String? sessionType,
    String? shipmentId,
    bool? isActive,
    String? createdBy,
    int limit = 50,
    int offset = 0,
  });

  /// Get all sessions for a company
  Future<List<InventorySession>> getSessions({
    required String companyId,
    String? sessionType,
    String? status,
  });

  /// Get a specific session by ID
  Future<InventorySession?> getSession({
    required String sessionId,
  });

  /// Create a new session
  Future<InventorySession> createSession({
    required String companyId,
    required String sessionName,
    required String sessionType,
    required String storeId,
    required String createdBy,
    String? notes,
  });

  /// Update session status
  Future<InventorySession> updateSessionStatus({
    required String sessionId,
    required String status,
  });

  /// Delete a session
  Future<void> deleteSession({
    required String sessionId,
  });

  /// Get items in a session
  Future<List<SessionItem>> getSessionItems({
    required String sessionId,
  });

  /// Add item to session
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
  });

  /// Update item quantity
  Future<SessionItem> updateSessionItem({
    required String itemId,
    required int quantity,
    String? notes,
  });

  /// Remove item from session
  Future<void> removeSessionItem({
    required String itemId,
  });

  /// Complete session and apply changes to inventory
  Future<InventorySession> completeSession({
    required String sessionId,
  });

  /// Get session items for review (aggregated by product with user breakdown)
  /// Only session creator can call this
  Future<SessionReviewResponse> getSessionReviewItems({
    required String sessionId,
    required String userId,
  });

  /// Submit session with confirmed items
  /// Creates receiving record, updates inventory stock, and closes session
  /// Only session creator can submit
  Future<SessionSubmitResponse> submitSession({
    required String sessionId,
    required String userId,
    required List<SessionSubmitItem> items,
    bool isFinal = false,
    String? notes,
  });

  /// Create a new session via RPC (inventory_create_session)
  /// For counting: no shipmentId needed
  /// For receiving: shipmentId is required
  Future<CreateSessionResponse> createSessionViaRpc({
    required String companyId,
    required String storeId,
    required String userId,
    required String sessionType,
    String? sessionName,
    String? shipmentId,
  });

  /// Get shipment list via RPC (inventory_get_shipment_list)
  /// For receiving session creation - select a shipment to receive
  Future<ShipmentListResponse> getShipmentList({
    required String companyId,
    String? search,
    String? status,
    String? supplierId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    int offset = 0,
  });

  /// Get inventory products with pagination
  /// For initial loading and infinite scroll
  Future<ProductSearchResponse> getInventoryPage({
    required String companyId,
    required String storeId,
    String? search,
    int page = 1,
    int limit = 15,
  });

  /// Search products for session item selection
  Future<ProductSearchResponse> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int limit = 20,
  });

  /// Add multiple items to a session via RPC
  Future<AddSessionItemsResponse> addSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  });

  /// Join an active session via RPC (inventory_join_session)
  /// Returns success even if already joined
  Future<JoinSessionResponse> joinSession({
    required String sessionId,
    required String userId,
  });

  /// Close a session without saving/submitting data via RPC (inventory_close_session)
  /// Only session creator can close the session
  Future<CloseSessionResponse> closeSession({
    required String sessionId,
    required String userId,
    required String companyId,
  });

  /// Get session history via RPC (inventory_get_session_history)
  /// Returns detailed session history including members and items
  Future<SessionHistoryResponse> getSessionHistory({
    required String companyId,
    String? storeId,
    String? sessionType,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 15,
    int offset = 0,
  });

  /// Get product stock by store via RPC (inventory_product_stock_stores)
  /// Returns stock quantity for each product in the specified store
  Future<Map<String, int>> getProductStockByStore({
    required String companyId,
    required String storeId,
    required List<String> productIds,
  });

  /// Get individual items added by a specific user in a session
  /// Returns each item_id separately (no grouping by product_id)
  /// via RPC (inventory_get_user_session_items)
  Future<UserSessionItemsResponse> getUserSessionItems({
    required String sessionId,
    required String userId,
  });

  /// Update or insert session items via RPC (inventory_update_session_item)
  /// - Existing products: Consolidates multiple items into one and updates quantity
  /// - New products: Inserts new item
  /// - Products not in items: Keeps as-is (no deletion)
  Future<UpdateSessionItemsResponse> updateSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  });

  /// Compare two sessions via RPC (inventory_compare_sessions)
  /// Returns items that exist in target session but not in source session
  Future<SessionCompareResult> compareSessions({
    required String sourceSessionId,
    required String targetSessionId,
    required String userId,
  });
}
