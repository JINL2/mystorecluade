import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/po_repository.dart';
import '../mappers/po_status_mapper.dart';
import '../models/po_model.dart';

/// PO Remote Datasource - handles all Supabase RPC calls
abstract class PORemoteDatasource {
  Future<PaginatedPOResponse> getList(POListParams params);
  Future<POModel> getById(String poId, {required String companyId});
  Future<Map<String, dynamic>> closeOrder({
    required String orderId,
    required String userId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  });

  /// Create order using inventory_create_order_v4 RPC
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
  });

  /// Get suppliers/counterparties for filter selection
  Future<List<SupplierFilterItem>> getSuppliers(String companyId);

  /// Get base currency and company currencies
  Future<BaseCurrencyData> getBaseCurrency(String companyId);

  /// Search products for order items
  Future<ProductSearchResult> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int page = 1,
    int limit = 20,
  });
}

class PORemoteDatasourceImpl implements PORemoteDatasource {
  final SupabaseClient _supabase;

  PORemoteDatasourceImpl(this._supabase);

  @override
  Future<PaginatedPOResponse> getList(POListParams params) async {
    // Calculate offset for pagination
    final offset = (params.page - 1) * params.pageSize;

    // Convert legacy POStatus to OrderStatus for RPC
    String? orderStatusFilter;
    String? receivingStatusFilter;

    if (params.orderStatuses != null && params.orderStatuses!.isNotEmpty) {
      orderStatusFilter = params.orderStatuses!.map((e) => e.dbValue).join(',');
    } else if (params.statuses != null && params.statuses!.isNotEmpty) {
      // Convert POStatus to order_status filter (direct mapping)
      final orderStatuses = <String>[];
      for (final status in params.statuses!) {
        switch (status) {
          case POStatus.pending:
            orderStatuses.add('pending');
            break;
          case POStatus.process:
            orderStatuses.add('process');
            break;
          case POStatus.complete:
            orderStatuses.add('complete');
            break;
          case POStatus.cancelled:
            orderStatuses.add('cancelled');
            break;
        }
      }
      if (orderStatuses.isNotEmpty) {
        orderStatusFilter = orderStatuses.toSet().join(',');
      }
    }

    if (params.receivingStatuses != null &&
        params.receivingStatuses!.isNotEmpty) {
      receivingStatusFilter =
          params.receivingStatuses!.map((e) => e.dbValue).join(',');
    }

    // Build RPC parameters
    final rpcParams = <String, dynamic>{
      'p_company_id': params.companyId,
      'p_limit': params.pageSize,
      'p_offset': offset,
    };

    // Add optional filters
    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      rpcParams['p_search'] = params.searchQuery;
    }
    if (orderStatusFilter != null) {
      rpcParams['p_order_status'] = orderStatusFilter;
    }
    if (receivingStatusFilter != null) {
      rpcParams['p_receiving_status'] = receivingStatusFilter;
    }
    if (params.effectiveSupplierId != null) {
      rpcParams['p_supplier_id'] = params.effectiveSupplierId;
    }
    if (params.dateFrom != null) {
      rpcParams['p_start_date'] = params.dateFrom!.toIso8601String();
    }
    if (params.dateTo != null) {
      rpcParams['p_end_date'] = params.dateTo!.toIso8601String();
    }
    if (params.timezone != null) {
      rpcParams['p_timezone'] = params.timezone;
    }

    // Call RPC - returns jsonb object with success, data, total_count
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_get_order_list',
      params: rpcParams,
    );

    // Check for RPC error
    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to load orders');
    }

    // Extract data array from response
    final dataList = response['data'] as List<dynamic>? ?? [];
    final totalCount = response['total_count'] as int? ?? 0;

    // Parse response into models
    final items = dataList.map((e) {
      final map = e as Map<String, dynamic>;
      return POListItemModel.fromJson(map);
    }).toList();

    // Calculate hasMore based on total count
    final hasMore = (offset + items.length) < totalCount;

    return PaginatedPOResponse(
      data: items.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      page: params.page,
      pageSize: params.pageSize,
      hasMore: hasMore,
    );
  }

  @override
  Future<POModel> getById(String poId, {required String companyId}) async {
    // Call inventory_get_order_detail_v2 RPC
    // companyId is now passed from AppState via provider
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_get_order_detail_v2',
      params: {
        'p_order_id': poId,
        'p_company_id': companyId,
        'p_timezone': 'UTC',
      },
    );

    // Check for RPC error
    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to load order detail');
    }

    // Extract data from response
    final data = response['data'] as Map<String, dynamic>? ?? {};

    // Map RPC response to POModel format
    final poMap = <String, dynamic>{
      // Map order_id to po_id for compatibility
      'po_id': data['order_id'],
      'po_number': data['order_number'],
      'company_id': companyId,
      'store_id': data['store_id'],
      // Currency
      'currency_code': data['currency_code'] ?? 'USD',
      'total_amount': data['total_amount'] ?? 0,
      // Dates
      'order_date_utc': data['order_date'],
      'created_at_utc': data['created_at'],
      // Status - map from new format
      'status': data['order_status'] ?? 'draft',
      'order_status': data['order_status'] ?? 'draft',
      'receiving_status': data['receiving_status'] ?? 'pending',
      // Progress
      'shipped_percent': data['fulfilled_percentage'] ?? 0,
      // Notes
      'notes': data['notes'],
      // Actions
      'can_cancel': data['can_cancel'] ?? false,
    };

    // Map supplier info to buyer info for UI compatibility
    // (In inventory system, we order FROM suppliers, so supplier = counterparty)
    final supplierInfo = <String, dynamic>{
      'name': data['supplier_name'],
      'phone': data['supplier_phone'],
      'email': data['supplier_email'],
      'address': data['supplier_address'],
    };
    poMap['buyer_id'] = data['supplier_id'];
    poMap['buyer_name'] = data['supplier_name'];
    poMap['buyer_info'] = supplierInfo;
    poMap['supplier_id'] = data['supplier_id'];
    poMap['supplier_name'] = data['supplier_name'];
    poMap['is_registered_supplier'] = data['is_registered_supplier'] ?? false;

    // Map items with variant support
    final itemsData = data['items'] as List<dynamic>? ?? [];
    final items = itemsData.map((item) {
      final itemMap = item as Map<String, dynamic>;
      return {
        'item_id': itemMap['item_id'],
        'po_id': poId,
        'product_id': itemMap['product_id'],
        'variant_id': itemMap['variant_id'],
        // Use display_name which combines product + variant names
        'description': itemMap['display_name'] ?? itemMap['product_name'] ?? '',
        'product_name': itemMap['product_name'],
        'variant_name': itemMap['variant_name'],
        'has_variants': itemMap['has_variants'] ?? false,
        'sku': itemMap['sku'],
        'quantity_ordered': itemMap['quantity_ordered'] ?? 0,
        'quantity_shipped': itemMap['quantity_fulfilled'] ?? 0,
        'unit': itemMap['unit'] ?? 'PCS',
        'unit_price': itemMap['unit_price'] ?? 0,
        'total_amount': itemMap['total_amount'] ?? 0,
        'image_url': itemMap['image_url'],
        'sort_order': itemMap['sort_order'] ?? 0,
      };
    }).toList();
    poMap['items'] = items;

    // Map shipments if available
    if (data['has_shipments'] == true) {
      poMap['has_shipments'] = true;
      poMap['shipment_count'] = data['shipment_count'] ?? 0;
      poMap['shipments'] = data['shipments'] ?? <dynamic>[];
    }

    return POModel.fromJson(poMap);
  }

  @override
  Future<Map<String, dynamic>> closeOrder({
    required String orderId,
    required String userId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_close_order',
      params: {
        'p_order_id': orderId,
        'p_user_id': userId,
        'p_company_id': companyId,
        'p_timezone': timezone,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to close order');
    }

    return response;
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
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'inventory_create_order_v4',
      params: {
        'p_company_id': companyId,
        'p_user_id': userId,
        'p_items': items,
        'p_time': DateTime.now().toIso8601String(),
        'p_timezone': timezone,
        'p_counterparty_id': counterpartyId,
        'p_supplier_info': supplierInfo,
        'p_notes': notes ?? orderTitle,
        'p_order_number': orderNumber,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to create order');
    }

    return response;
  }

  @override
  Future<List<SupplierFilterItem>> getSuppliers(String companyId) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'get_counterparty_info',
      params: {'p_company_id': companyId},
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to load suppliers');
    }

    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) {
      final map = e as Map<String, dynamic>;
      return SupplierFilterItem(
        counterpartyId: map['counterparty_id'] as String? ?? '',
        name: map['name'] as String? ?? 'Unknown',
        type: map['type'] as String?,
        email: map['email'] as String?,
        phone: map['phone'] as String?,
      );
    }).toList();
  }

  @override
  Future<BaseCurrencyData> getBaseCurrency(String companyId) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'get_base_currency',
      params: {'p_company_id': companyId},
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to load currency');
    }

    final data = response['data'] as Map<String, dynamic>? ?? {};

    // Parse base currency
    final baseCurrency = CurrencyInfo(
      currencyId: data['base_currency_id'] as String? ?? '',
      currencyCode: data['base_currency_code'] as String? ?? 'VND',
      currencyName: data['base_currency_name'] as String? ?? 'Vietnamese Dong',
      symbol: data['base_currency_symbol'] as String? ?? '₫',
      flagEmoji: data['base_currency_flag'] as String?,
      exchangeRateToBase: 1.0,
    );

    // Parse company currencies
    final currenciesData = data['currencies'] as List<dynamic>? ?? [];
    final companyCurrencies = currenciesData.map((e) {
      final map = e as Map<String, dynamic>;
      return CurrencyInfo(
        currencyId: map['currency_id'] as String? ?? '',
        currencyCode: map['currency_code'] as String? ?? '',
        currencyName: map['currency_name'] as String? ?? '',
        symbol: map['symbol'] as String? ?? '',
        flagEmoji: map['flag_emoji'] as String?,
        exchangeRateToBase: (map['exchange_rate'] as num?)?.toDouble() ?? 1.0,
        rateDate: map['rate_date'] != null
            ? DateTime.tryParse(map['rate_date'] as String)
            : null,
      );
    }).toList();

    return BaseCurrencyData(
      baseCurrency: baseCurrency,
      companyCurrencies: companyCurrencies,
    );
  }

  @override
  Future<ProductSearchResult> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _supabase.rpc<Map<String, dynamic>>(
      'get_inventory_page_v6',
      params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_search': query,
        'p_page': page,
        'p_limit': limit,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to search products');
    }

    final data = response['data'] as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    final totalCount = data['total_count'] as int? ?? 0;

    final productItems = items.map((e) {
      final map = e as Map<String, dynamic>;
      final imageUrls = <String>[];
      if (map['image_urls'] != null) {
        imageUrls.addAll((map['image_urls'] as List).cast<String>());
      } else if (map['image_url'] != null) {
        imageUrls.add(map['image_url'] as String);
      }

      return ProductItem(
        productId: map['product_id'] as String? ?? '',
        productName: map['product_name'] as String? ?? '',
        productSku: map['product_sku'] as String?,
        productBarcode: map['product_barcode'] as String?,
        variantId: map['variant_id'] as String?,
        variantName: map['variant_name'] as String?,
        variantSku: map['variant_sku'] as String?,
        displayName: map['display_name'] as String? ?? map['product_name'] as String? ?? '',
        displaySku: map['display_sku'] as String? ?? map['product_sku'] as String?,
        unit: map['unit'] as String? ?? 'PCS',
        costPrice: (map['cost_price'] as num?)?.toDouble() ?? 0,
        sellingPrice: (map['selling_price'] as num?)?.toDouble() ?? 0,
        quantityOnHand: (map['quantity_on_hand'] as num?)?.toDouble() ?? 0,
        imageUrls: imageUrls,
        hasVariants: map['has_variants'] as bool? ?? false,
      );
    }).toList();

    final hasMore = (page * limit) < totalCount;

    return ProductSearchResult(
      items: productItems,
      totalCount: totalCount,
      page: page,
      hasMore: hasMore,
    );
  }
}
