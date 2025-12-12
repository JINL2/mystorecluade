import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/session_item.dart';
import '../../domain/entities/session_list_item.dart';
import '../models/inventory_session_model.dart';
import '../models/session_item_model.dart';
import '../models/session_list_item_model.dart';
import '../models/session_review_item_model.dart';
import '../models/shipment_model.dart';

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

    return SessionListResponse(
      sessions: sessions,
      totalCount: response['total_count'] as int? ?? 0,
      limit: response['limit'] as int? ?? limit,
      offset: response['offset'] as int? ?? offset,
    );
  }

  /// Get session items for review via RPC (inventory_get_session_items)
  /// Only session creator can call this
  Future<SessionReviewResponseModel> getSessionReviewItems({
    required String sessionId,
    required String userId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_get_session_items',
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

  /// Submit session with confirmed items via RPC (inventory_submit_session)
  /// Creates receiving record, updates inventory stock, and closes session
  /// Only session creator can submit
  Future<SessionSubmitResponseModel> submitSession({
    required String sessionId,
    required String userId,
    required List<Map<String, dynamic>> items,
    bool isFinal = false,
    String? notes,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_submit_session',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_items': items,
        'p_is_final': isFinal,
        if (notes != null) 'p_notes': notes,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to submit session');
    }

    final data = response['data'] as Map<String, dynamic>? ?? {};
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

  /// Search products for session item selection via RPC (get_inventory_page_v3)
  Future<ProductSearchResponse> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int limit = 20,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'get_inventory_page_v3',
      params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': 1,
        'p_limit': limit,
        'p_search': query,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    // Parse response
    Map<String, dynamic> dataToProcess;
    if (response.containsKey('success')) {
      if (response['success'] == true) {
        dataToProcess = response['data'] as Map<String, dynamic>? ?? {};
      } else {
        throw Exception(response['error'] ?? 'Failed to search products');
      }
    } else {
      dataToProcess = response;
    }

    final productsJson = dataToProcess['products'] as List<dynamic>? ?? [];
    final products = productsJson.map((json) {
      final map = json as Map<String, dynamic>;

      // Parse image URL from various formats
      String? imageUrl;
      if (map['images'] is Map) {
        final images = map['images'] as Map<String, dynamic>;
        imageUrl = images['thumbnail']?.toString() ??
            images['main_image']?.toString();
      } else if (map['image_urls'] is List) {
        final urls = map['image_urls'] as List;
        if (urls.isNotEmpty) imageUrl = urls.first.toString();
      } else {
        imageUrl =
            map['image_url']?.toString() ?? map['thumbnail']?.toString();
      }

      return ProductSearchResult(
        productId: map['product_id']?.toString() ?? '',
        productName: map['product_name']?.toString() ?? '',
        sku: map['sku']?.toString(),
        barcode: map['barcode']?.toString(),
        imageUrl: imageUrl,
        sellingPrice: (map['selling_price'] as num?)?.toDouble() ?? 0,
        currentStock: (map['current_stock'] as num?)?.toInt() ?? 0,
      );
    }).toList();

    return ProductSearchResponse(
      products: products,
      totalCount: dataToProcess['total_count'] as int? ?? products.length,
    );
  }

  /// Add multiple items to a session via RPC (inventory_add_session_items)
  Future<AddSessionItemsResponse> addSessionItems({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  }) async {
    final itemsJson = items.map((item) => item.toJson()).toList();

    final response = await _client.rpc<Map<String, dynamic>>(
      'inventory_add_session_items',
      params: {
        'p_session_id': sessionId,
        'p_user_id': userId,
        'p_items': itemsJson,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      },
    ).single();

    if (response['success'] == true) {
      return AddSessionItemsResponse(
        success: true,
        message: response['message']?.toString(),
        itemsAdded: (response['items_added'] as num?)?.toInt() ?? items.length,
      );
    } else {
      throw Exception(response['error'] ?? 'Failed to add session items');
    }
  }
}
