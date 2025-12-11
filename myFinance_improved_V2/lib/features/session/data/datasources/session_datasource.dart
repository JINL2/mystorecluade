import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/session_list_item.dart';
import '../models/inventory_session_model.dart';
import '../models/session_item_model.dart';
import '../models/session_list_item_model.dart';

export '../../domain/entities/session_list_item.dart';

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
}
