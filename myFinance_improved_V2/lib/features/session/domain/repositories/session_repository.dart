import '../entities/close_session_response.dart';
import '../entities/inventory_session.dart';
import '../entities/join_session_response.dart';
import '../entities/session_compare_result.dart';
import '../entities/session_history_item.dart';
import '../entities/session_item.dart';
import '../entities/session_list_item.dart';
import '../entities/session_review_item.dart';
import '../entities/shipment.dart';
import '../entities/update_session_items_response.dart';
import '../entities/user_session_items.dart';

/// Repository interface for session operations
abstract class SessionRepository {
  /// Get session list via RPC (inventory_get_session_list_v2)
  /// v2: Replaced isActive with status, added supplier/date filters
  Future<SessionListResponse> getSessionList({
    required String companyId,
    String? storeId,
    String? sessionType,
    String? shipmentId,
    /// v2: Status filter ('in_progress', 'complete', 'cancelled')
    String? status,
    String? supplierId,
    DateTime? startDate,
    DateTime? endDate,
    String? createdBy,
    int limit = 50,
    int offset = 0,
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

  /// Create a new session via RPC (inventory_create_session_v2)
  /// v2: p_time is TIMESTAMP (without timezone) - treated as user's local time
  ///     Conversion: p_time AT TIME ZONE p_timezone for UTC storage
  ///     If p_time is NULL, uses NOW()
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

  /// Get session history via RPC (inventory_get_session_history_v4)
  /// Returns detailed session history including members, items, merge info, receiving info, and counting info
  Future<SessionHistoryResponse> getSessionHistory({
    required String companyId,
    String? storeId,
    String? sessionType,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    int limit = 15,
    int offset = 0,
  });

  /// Get product stock by store via RPC (inventory_product_stock_stores_v2)
  /// v2: Supports both variant and non-variant products
  /// Returns stock quantity for each product/variant in the specified store
  /// Key format: productId for non-variant products, productId:variantId for variants
  Future<Map<String, int>> getProductStockByStore({
    required String companyId,
    required String storeId,
    required List<String> productIds,
  });

  /// Get individual items added by a specific user in a session
  /// Returns each item_id separately (no grouping by product_id)
  /// via RPC (inventory_get_user_session_items_v2)
  Future<UserSessionItemsResponse> getUserSessionItems({
    required String sessionId,
    required String userId,
  });

  /// Update or insert session items via RPC (inventory_update_session_item_v2)
  /// - Existing products: Consolidates multiple items into one and updates quantity
  /// - New products: Inserts new item
  /// - Products not in items: Keeps as-is (no deletion)
  Future<UpdateSessionItemsResponse> updateSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  });

  /// Compare two sessions via RPC (inventory_compare_sessions_v2)
  /// Returns items that exist in target session but not in source session
  Future<SessionCompareResult> compareSessions({
    required String sourceSessionId,
    required String targetSessionId,
    required String userId,
  });

  /// Merge source session into target session via RPC (inventory_merge_sessions_v2)
  /// - Copies all items from source to target with source_session_id tracking
  /// - Adds source's members to target (skips duplicates)
  /// - Deactivates source session
  Future<void> mergeSessions({
    required String targetSessionId,
    required String sourceSessionId,
    required String userId,
  });
}
