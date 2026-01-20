import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../models/close_session_response_model.dart';
import '../models/inventory_session_model.dart';
import '../models/join_session_response_model.dart';
import '../models/product_search_model.dart';
import '../models/session_compare_model.dart';
import '../models/session_history_item_model.dart';
import '../models/session_item_input_model.dart';
import '../models/session_item_model.dart';
import '../models/session_list_item_model.dart';
import '../models/session_review_item_model.dart';
import '../models/shipment_model.dart';
import '../models/update_session_items_response_model.dart';
import '../models/user_session_items_model.dart';

/// Provider for SessionDatasource
final sessionDatasourceProvider = Provider<SessionDatasource>((ref) {
  return SessionDatasource(Supabase.instance.client);
});

/// Remote datasource for session operations
class SessionDatasource {
  final SupabaseClient _client;

  SessionDatasource(this._client);

  /// Get all sessions for a company
  Future<List<InventorySessionModel>> getSessions({
    required String companyId,
    String? sessionType,
    String? status,
  }) async {
    var query = _client
        .from('inventory_sessions')
        .select()
        .eq('company_id', companyId);

    if (sessionType != null) {
      query = query.eq('session_type', sessionType);
    }
    if (status != null) {
      query = query.eq('status', status);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List)
        .map((json) => InventorySessionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get a specific session by ID
  Future<InventorySessionModel?> getSession({
    required String sessionId,
  }) async {
    final response = await _client
        .from('inventory_sessions')
        .select()
        .eq('session_id', sessionId)
        .maybeSingle();

    if (response == null) return null;
    return InventorySessionModel.fromJson(response);
  }

  /// Create a new session
  Future<InventorySessionModel> createSession({
    required String companyId,
    required String sessionName,
    required String sessionType,
    required String storeId,
    required String createdBy,
    String? notes,
  }) async {
    final response = await _client.from('inventory_sessions').insert({
      'company_id': companyId,
      'session_name': sessionName,
      'session_type': sessionType,
      'store_id': storeId,
      'created_by': createdBy,
      'status': 'active',
      'notes': notes,
    }).select().single();

    return InventorySessionModel.fromJson(response);
  }

  /// Update session status
  Future<InventorySessionModel> updateSessionStatus({
    required String sessionId,
    required String status,
  }) async {
    final updateData = <String, dynamic>{
      'status': status,
    };

    if (status == 'completed') {
      updateData['completed_at'] = DateTime.now().toIso8601String();
    }

    final response = await _client
        .from('inventory_sessions')
        .update(updateData)
        .eq('session_id', sessionId)
        .select()
        .single();

    return InventorySessionModel.fromJson(response);
  }

  /// Delete a session
  Future<void> deleteSession({
    required String sessionId,
  }) async {
    await _client
        .from('inventory_sessions')
        .delete()
        .eq('session_id', sessionId);
  }

  /// Get items in a session
  Future<List<SessionItemModel>> getSessionItems({
    required String sessionId,
  }) async {
    final response = await _client
        .from('session_items')
        .select()
        .eq('session_id', sessionId)
        .order('added_at', ascending: false);

    return (response as List)
        .map((json) => SessionItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Add item to session
  Future<SessionItemModel> addSessionItem({
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
    final response = await _client.from('session_items').insert({
      'session_id': sessionId,
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'barcode': barcode,
      'image_url': imageUrl,
      'quantity': quantity,
      'unit_price': unitPrice,
      'notes': notes,
    }).select().single();

    return SessionItemModel.fromJson(response);
  }

  /// Update item quantity
  Future<SessionItemModel> updateSessionItem({
    required String itemId,
    required int quantity,
    String? notes,
  }) async {
    final updateData = <String, dynamic>{
      'quantity': quantity,
    };
    if (notes != null) {
      updateData['notes'] = notes;
    }

    final response = await _client
        .from('session_items')
        .update(updateData)
        .eq('item_id', itemId)
        .select()
        .single();

    return SessionItemModel.fromJson(response);
  }

  /// Remove item from session
  Future<void> removeSessionItem({
    required String itemId,
  }) async {
    await _client
        .from('session_items')
        .delete()
        .eq('item_id', itemId);
  }

  /// Complete session
  Future<InventorySessionModel> completeSession({
    required String sessionId,
  }) async {
    // TODO: Call RPC function to apply inventory changes
    // For now, just update status
    return updateSessionStatus(sessionId: sessionId, status: 'completed');
  }

  /// Get session list via RPC (inventory_get_session_list)
  Future<SessionListResponseModel> getSessionList({
    required String companyId,
    String? storeId,
    String? sessionType,
    String? shipmentId,
    bool? isActive,
    String? createdBy,
    int limit = 50,
    int offset = 0,
  }) async {
    final params = <String, dynamic>{
      'p_company_id': companyId,
      'p_timezone': DateTimeUtils.getLocalTimezone(),
      'p_limit': limit,
      'p_offset': offset,
    };

    if (storeId != null) params['p_store_id'] = storeId;
    if (sessionType != null) params['p_session_type'] = sessionType;
    if (shipmentId != null) params['p_shipment_id'] = shipmentId;
    if (isActive != null) params['p_is_active'] = isActive;
    if (createdBy != null) params['p_created_by'] = createdBy;

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_get_session_list',
      params: params,
    ).single();

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to get session list');
    }

    final dataList = response['data'] as List<dynamic>? ?? [];
    final sessions = dataList
        .map((json) => SessionListItemModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return SessionListResponseModel(
      sessions: sessions,
      totalCount: response['total_count'] as int? ?? 0,
      limit: response['limit'] as int? ?? limit,
      offset: response['offset'] as int? ?? offset,
    );
  }

  /// Get session items for review via RPC (inventory_get_session_items_v2)
  /// v2: Returns variant info (variant_id, display_name, variant_sku, etc.)
  /// Anyone can call this function to view session items
  Future<SessionReviewResponseModel> getSessionReviewItems({
    required String sessionId,
    required String userId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_get_session_items_v2',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to get session items');
    }

    final data = response['data'] as Map<String, dynamic>? ?? {};
    return SessionReviewResponseModel.fromJson(data);
  }

  /// Get product stock by store via RPC (inventory_product_stock_stores)
  /// Returns stock quantity for each product in the specified store
  Future<Map<String, int>> getProductStockByStore({
    required String companyId,
    required String storeId,
    required List<String> productIds,
  }) async {
    if (productIds.isEmpty) {
      return {};
    }

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_product_stock_stores',
      params: {
        'p_company_id': companyId,
        'p_product_ids': productIds,
      },
    ).single();

    if (response['success'] != true) {
      final error = response['error'] as Map<String, dynamic>?;
      throw Exception(error?['message'] ?? 'Failed to get product stock');
    }

    final data = response['data'] as Map<String, dynamic>? ?? {};
    final products = data['products'] as List<dynamic>? ?? [];

    // Build a map of productId -> stock quantity for the specified store
    final stockMap = <String, int>{};
    for (final product in products) {
      final productMap = product as Map<String, dynamic>;
      final productId = productMap['product_id']?.toString() ?? '';
      final stores = productMap['stores'] as List<dynamic>? ?? [];

      // Find the stock for the specified store
      for (final store in stores) {
        final storeMap = store as Map<String, dynamic>;
        if (storeMap['store_id']?.toString() == storeId) {
          stockMap[productId] = (storeMap['quantity_on_hand'] as num?)?.toInt() ?? 0;
          break;
        }
      }

      // If store not found, default to 0
      if (!stockMap.containsKey(productId)) {
        stockMap[productId] = 0;
      }
    }

    return stockMap;
  }

  /// Submit session with confirmed items via RPC (inventory_submit_session_v3)
  /// Creates receiving record, updates inventory stock, and closes session
  /// Only session creator can submit
  /// V3 includes variant_id support for variant products
  /// V2 includes stock_changes with before/after quantities for display tracking
  Future<SessionSubmitResponseModel> submitSession({
    required String sessionId,
    required String userId,
    required List<Map<String, dynamic>> items,
    bool isFinal = false,
    String? notes,
  }) async {
    debugPrint('🔄 [Datasource] submitSession called');
    debugPrint('🔄 [Datasource] sessionId: $sessionId');
    debugPrint('🔄 [Datasource] userId: $userId');
    debugPrint('🔄 [Datasource] items: $items');
    debugPrint('🔄 [Datasource] isFinal: $isFinal');

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_submit_session_v3',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_items': items,
        'p_is_final': isFinal,
        if (notes != null) 'p_notes': notes,
        'p_time': DateTimeUtils.toLocalWithOffset(DateTime.now()),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    debugPrint('🔄 [Datasource] RPC response: $response');

    if (response['success'] != true) {
      debugPrint('❌ [Datasource] RPC failed: ${response['error']}');
      throw Exception(response['error'] ?? 'Failed to submit session');
    }

    final data = response['data'] as Map<String, dynamic>? ?? {};
    debugPrint('✅ [Datasource] RPC data: $data');
    return SessionSubmitResponseModel.fromJson(data);
  }

  /// Create a new session via RPC (inventory_create_session)
  /// For counting: no shipmentId needed
  /// For receiving: shipmentId is required
  Future<CreateSessionResponseModel> createSessionViaRpc({
    required String companyId,
    required String storeId,
    required String userId,
    required String sessionType,
    String? sessionName,
    String? shipmentId,
  }) async {
    final params = <String, dynamic>{
      'p_company_id': companyId,
      'p_store_id': storeId,
      'p_user_id': userId,
      'p_session_type': sessionType,
      'p_timezone': DateTimeUtils.getLocalTimezone(),
    };

    if (sessionName != null && sessionName.isNotEmpty) {
      params['p_session_name'] = sessionName;
    }
    if (shipmentId != null) {
      params['p_shipment_id'] = shipmentId;
    }

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_create_session',
      params: params,
    ).single();

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to create session');
    }

    final data = response['data'] as Map<String, dynamic>? ?? {};
    return CreateSessionResponseModel.fromJson(data);
  }

  /// Get shipment list via RPC (inventory_get_shipment_list)
  /// For receiving session creation - select a shipment to receive
  Future<ShipmentListResponseModel> getShipmentList({
    required String companyId,
    String? search,
    String? status,
    String? supplierId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    int offset = 0,
  }) async {
    final params = <String, dynamic>{
      'p_company_id': companyId,
      'p_timezone': DateTimeUtils.getLocalTimezone(),
      'p_limit': limit,
      'p_offset': offset,
    };

    if (search != null && search.isNotEmpty) {
      params['p_search'] = search;
    }
    if (status != null) {
      params['p_status'] = status;
    }
    if (supplierId != null) {
      params['p_supplier_id'] = supplierId;
    }
    if (startDate != null) {
      params['p_start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      params['p_end_date'] = endDate.toIso8601String();
    }

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_get_shipment_list',
      params: params,
    ).single();

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to get shipment list');
    }

    return ShipmentListResponseModel.fromJson(response);
  }

  /// Get inventory products with pagination via RPC (get_inventory_page_v6)
  /// Used for initial loading (no search) and search functionality
  /// v6 returns variants expanded - each variant is a separate row
  Future<ProductSearchResponseModel> getInventoryPage({
    required String companyId,
    required String storeId,
    String? search,
    int page = 1,
    int limit = 15,
  }) async {
    final params = <String, dynamic>{
      'p_company_id': companyId,
      'p_store_id': storeId,
      'p_page': page,
      'p_limit': limit,
      'p_timezone': DateTimeUtils.getLocalTimezone(),
    };

    if (search != null && search.isNotEmpty) {
      params['p_search'] = search;
    }

    final response = await _client.rpc<Map<String, dynamic>>(
      'get_inventory_page_v6',
      params: params,
    ).single();

    // Parse response
    Map<String, dynamic> dataToProcess;
    if (response.containsKey('success')) {
      if (response['success'] == true) {
        dataToProcess = response['data'] as Map<String, dynamic>? ?? {};
      } else {
        throw Exception(response['error'] ?? 'Failed to get inventory');
      }
    } else {
      dataToProcess = response;
    }

    return ProductSearchResponseModel.fromJson(dataToProcess);
  }

  /// Search products for session item selection via RPC (get_inventory_page_v6)
  /// This is a convenience method that calls getInventoryPage with search query
  Future<ProductSearchResponseModel> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int limit = 20,
  }) async {
    return getInventoryPage(
      companyId: companyId,
      storeId: storeId,
      search: query,
      page: 1,
      limit: limit,
    );
  }

  /// Add multiple items to a session via RPC (inventory_add_session_items_v2)
  /// v2: variant_id support - items include variant_id (null for non-variant products)
  Future<AddSessionItemsResponseModel> addSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInputModel> items,
  }) async {
    final itemsJson = items.map((item) => item.toJson()).toList();

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_add_session_items_v2',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_items': itemsJson,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] == true) {
      return AddSessionItemsResponseModel(
        success: true,
        message: response['message']?.toString(),
        itemsAdded: (response['items_added'] as num?)?.toInt() ?? items.length,
      );
    } else {
      throw Exception(response['error'] ?? 'Failed to add session items');
    }
  }

  /// Join an active session via RPC (inventory_join_session)
  /// Returns success even if already joined
  Future<JoinSessionResponseModel> joinSession({
    required String sessionId,
    required String userId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_join_session',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_time': DateTimeUtils.toLocalWithOffset(DateTime.now()),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] == true) {
      final data = response['data'] as Map<String, dynamic>? ?? {};
      return JoinSessionResponseModel.fromJson(data);
    } else {
      throw Exception(response['error'] ?? 'Failed to join session');
    }
  }

  /// Close a session without saving/submitting data via RPC (inventory_close_session)
  /// Only session creator can close the session
  Future<CloseSessionResponseModel> closeSession({
    required String sessionId,
    required String userId,
    required String companyId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_close_session',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_company_id': companyId,
        'p_time': DateTimeUtils.toLocalWithOffset(DateTime.now()),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] == true) {
      final data = response['data'] as Map<String, dynamic>? ?? {};
      return CloseSessionResponseModel.fromJson(data);
    } else {
      throw Exception(response['error'] ?? 'Failed to close session');
    }
  }

  /// Get individual user session items via RPC (inventory_get_user_session_items_v2)
  /// V2 supports variants with variant_id, display_name, etc.
  /// Returns each item_id separately (no grouping by product_id)
  /// Used for showing previously added items when user enters session detail page
  Future<UserSessionItemsResponseModel> getUserSessionItems({
    required String sessionId,
    required String userId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_get_user_session_items_v2',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to get user session items');
    }

    final data = response['data'] as Map<String, dynamic>? ?? {};
    return UserSessionItemsResponseModel.fromJson(data);
  }

  /// Update or insert session items via RPC (inventory_update_session_item_v2)
  /// - V2 supports variant_id for product variants
  /// - Existing products/variants: Consolidates multiple items into one and updates quantity
  /// - New products/variants: Inserts new item
  /// - Products not in items: Keeps as-is (no deletion)
  /// - Validates variant ownership (variant must belong to product)
  Future<UpdateSessionItemsResponseModel> updateSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInputModel> items,
  }) async {
    final itemsJson = items.map((item) => item.toJson()).toList();

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_update_session_item_v2',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_items': itemsJson,
        'p_time': DateTimeUtils.toLocalWithOffset(DateTime.now()),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] == true) {
      final data = response['data'] as Map<String, dynamic>? ?? {};
      return UpdateSessionItemsResponseModel.fromJson(data, response['message']?.toString());
    } else {
      throw Exception(response['error'] ?? 'Failed to update session items');
    }
  }

  /// Get session history via RPC (inventory_get_session_history_v3)
  /// Returns detailed session history including members, items, merge info, and receiving info
  /// V3 includes:
  /// - Full variant support: items grouped by (product_id, variant_id)
  /// - variant_id, variant_name, display_name, has_variants in items
  /// - confirmed_quantity matches by variant_id
  /// - merge_info items include variant information
  /// - is_merged_session: boolean flag for merged sessions
  /// - receiving_info: stock_snapshot with variant info
  Future<SessionHistoryResponseModel> getSessionHistory({
    required String companyId,
    String? storeId,
    String? sessionType,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 15,
    int offset = 0,
  }) async {
    final params = <String, dynamic>{
      'p_company_id': companyId,
      'p_timezone': DateTimeUtils.getLocalTimezone(),
      'p_limit': limit,
      'p_offset': offset,
    };

    if (storeId != null) params['p_store_id'] = storeId;
    if (sessionType != null) params['p_session_type'] = sessionType;
    if (isActive != null) params['p_is_active'] = isActive;
    if (startDate != null) {
      params['p_start_date'] = DateTimeUtils.toLocalWithOffset(startDate);
    }
    if (endDate != null) {
      params['p_end_date'] = DateTimeUtils.toLocalWithOffset(endDate);
    }

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_get_session_history_v3',
      params: params,
    ).single();

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to get session history');
    }

    return SessionHistoryResponseModel.fromJson(response);
  }

  /// Compare two sessions via RPC (inventory_compare_sessions_v2)
  /// Returns items that exist in target session but not in source session
  /// v2: Supports variant comparison - each (product_id, variant_id) pair compared separately
  Future<SessionCompareResponseModel> compareSessions({
    required String sourceSessionId,
    required String targetSessionId,
    required String userId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_compare_sessions_v2',
      params: {
        'p_session_id_a': sourceSessionId,
        'p_session_id_b': targetSessionId,
        'p_user_id': userId,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    // Debug: Print the actual RPC response structure
    debugPrint('🔍 [compareSessions] Response keys: ${response.keys.toList()}');
    if (response['data'] != null) {
      final data = response['data'] as Map<String, dynamic>;
      debugPrint('🔍 [compareSessions] Data keys: ${data.keys.toList()}');
      debugPrint('🔍 [compareSessions] Full data: $data');
    }

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to compare sessions');
    }

    return SessionCompareResponseModel.fromJson(response);
  }

  /// Merge source session into target session via RPC (inventory_merge_sessions_v2)
  /// - Copies all items from source to target with source_session_id tracking
  /// - Adds source's members to target (skips duplicates)
  /// - Deactivates source session
  /// v2: Supports variant_id - copies variant info and includes in response
  Future<Map<String, dynamic>> mergeSessions({
    required String targetSessionId,
    required String sourceSessionId,
    required String userId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_merge_sessions_v2',
      params: {
        'p_target_session_id': targetSessionId,
        'p_source_session_id': sourceSessionId,
        'p_user_id': userId,
        'p_time': DateTimeUtils.toLocalWithOffset(DateTime.now()),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to merge sessions');
    }

    return response;
  }
}
