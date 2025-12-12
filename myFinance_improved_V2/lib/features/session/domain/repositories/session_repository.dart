import '../entities/inventory_session.dart';
import '../entities/session_item.dart';
import '../entities/session_list_item.dart';
import '../entities/session_review_item.dart';

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
}
