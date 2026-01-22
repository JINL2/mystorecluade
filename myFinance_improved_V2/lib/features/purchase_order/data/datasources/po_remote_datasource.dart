import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/po_repository.dart';
import '../mappers/po_status_mapper.dart';
import '../models/po_model.dart';

/// PO Remote Datasource - handles all Supabase RPC calls
abstract class PORemoteDatasource {
  Future<PaginatedPOResponse> getList(POListParams params);
  Future<POModel> getById(String poId);
  Future<POModel> create(POCreateParams params);
  Future<POModel> update(String poId, int version, Map<String, dynamic> updates);
  Future<void> delete(String poId);
  Future<void> confirm(String poId);
  Future<void> updateStatus(String poId, POStatus newStatus, {String? notes});
  Future<String> convertFromPI(String piId, {Map<String, dynamic>? options});
  Future<String> generateNumber(String companyId);
  Future<List<AcceptedPIForConversion>> getAcceptedPIsForConversion();
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
  Future<POModel> getById(String poId) async {
    // Get company_id from appState (passed through provider)
    // For now, we'll get it from the order itself first
    final orderCheck = await _supabase
        .from('inventory_purchase_orders')
        .select('company_id')
        .eq('order_id', poId)
        .maybeSingle();

    if (orderCheck == null) {
      throw Exception('Order not found');
    }

    final companyId = orderCheck['company_id'] as String;

    // Call inventory_get_order_detail_v2 RPC
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
  Future<POModel> create(POCreateParams params) async {
    // Generate PO number
    final poNumber = await generateNumber(params.companyId);

    // Calculate total
    double totalAmount = 0;
    for (final item in params.items) {
      final lineTotal =
          item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
      totalAmount += lineTotal;
    }

    // Insert PO
    final poResponse = await _supabase
        .from('trade_purchase_orders')
        .insert({
          'po_number': poNumber,
          'company_id': params.companyId,
          'store_id': params.storeId,
          'pi_id': params.piId,
          'buyer_id': params.counterpartyId,
          'buyer_po_number': params.buyerPoNumber,
          'buyer_info': params.buyerInfo,
          'currency_id': params.currencyId,
          'total_amount': totalAmount,
          'incoterms_code': params.incotermsCode,
          'incoterms_place': params.incotermsPlace,
          'payment_terms_code': params.paymentTermsCode,
          'order_date_utc': params.orderDateUtc?.toIso8601String(),
          'required_shipment_date_utc':
              params.requiredShipmentDateUtc?.toIso8601String(),
          'partial_shipment_allowed': params.partialShipmentAllowed,
          'transshipment_allowed': params.transshipmentAllowed,
          'status': 'draft',
          'version': 1,
          'shipped_percent': 0,
          'notes': params.notes,
          'bank_account_ids': params.bankAccountIds.isNotEmpty
              ? params.bankAccountIds
              : null,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final poId = (poResponse as Map<String, dynamic>)['po_id'] as String;

    // Insert items
    if (params.items.isNotEmpty) {
      final itemsToInsert = params.items.asMap().entries.map((entry) {
        final item = entry.value;
        final lineTotal =
            item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
        return {
          'po_id': poId,
          'product_id': item.productId,
          'description': item.description,
          'sku': item.sku,
          'hs_code': item.hsCode,
          'quantity_ordered': item.quantity,
          'quantity_shipped': 0,
          'unit': item.unit ?? 'PCS',
          'unit_price': item.unitPrice,
          'total_amount': lineTotal,
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_po_items').insert(itemsToInsert);
    }

    return getById(poId);
  }

  @override
  Future<POModel> update(
      String poId, int version, Map<String, dynamic> updates) async {
    // Add version check and update timestamp
    updates['updated_at_utc'] = DateTime.now().toUtc().toIso8601String();
    updates['version'] = version + 1;

    await _supabase
        .from('trade_purchase_orders')
        .update(updates)
        .eq('po_id', poId)
        .eq('version', version); // Optimistic locking

    // If items are included in updates, handle them
    if (updates.containsKey('items')) {
      final items = updates['items'] as List<POItemCreateParams>?;
      if (items != null) {
        // Delete existing items and re-insert
        await _supabase.from('trade_po_items').delete().eq('po_id', poId);

        if (items.isNotEmpty) {
          final itemsToInsert = items.asMap().entries.map((entry) {
            final item = entry.value;
            final lineTotal = item.quantity *
                item.unitPrice *
                (1 - item.discountPercent / 100);
            return {
              'po_id': poId,
              'product_id': item.productId,
              'description': item.description,
              'sku': item.sku,
              'hs_code': item.hsCode,
              'quantity_ordered': item.quantity,
              'quantity_shipped': 0,
              'unit': item.unit ?? 'PCS',
              'unit_price': item.unitPrice,
              'total_amount': lineTotal,
              'sort_order': entry.key,
              'created_at_utc': DateTime.now().toUtc().toIso8601String(),
            };
          }).toList();

          await _supabase.from('trade_po_items').insert(itemsToInsert);
        }
      }
    }

    return getById(poId);
  }

  @override
  Future<void> delete(String poId) async {
    // Delete items first
    await _supabase.from('trade_po_items').delete().eq('po_id', poId);

    // Delete PO (only draft can be deleted)
    await _supabase
        .from('trade_purchase_orders')
        .delete()
        .eq('po_id', poId)
        .eq('status', 'draft');
  }

  @override
  Future<void> confirm(String poId) async {
    await _supabase.from('trade_purchase_orders').update({
      'status': 'confirmed',
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    }).eq('po_id', poId);
  }

  @override
  Future<void> updateStatus(String poId, POStatus newStatus,
      {String? notes}) async {
    final updates = <String, dynamic>{
      'status': newStatus.dbValue,
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    };
    if (notes != null) {
      updates['notes'] = notes;
    }

    await _supabase
        .from('trade_purchase_orders')
        .update(updates)
        .eq('po_id', poId);
  }

  @override
  Future<String> convertFromPI(String piId,
      {Map<String, dynamic>? options}) async {
    // Get PI data
    final piResponse = await _supabase
        .from('trade_proforma_invoices')
        .select('*')
        .eq('pi_id', piId)
        .single();

    final pi = piResponse as Map<String, dynamic>;

    // Generate PO number
    final poNumber = await generateNumber(pi['company_id'] as String);

    // Create PO from PI
    final poResponse = await _supabase
        .from('trade_purchase_orders')
        .insert({
          'po_number': poNumber,
          'company_id': pi['company_id'],
          'store_id': pi['store_id'],
          'pi_id': piId,
          'buyer_id': pi['counterparty_id'],
          'buyer_info': pi['counterparty_info'],
          'currency_id': pi['currency_id'],
          'total_amount': pi['total_amount'],
          'incoterms_code': pi['incoterms_code'],
          'incoterms_place': pi['incoterms_place'],
          'payment_terms_code': pi['payment_terms_code'],
          'partial_shipment_allowed': pi['partial_shipment_allowed'],
          'transshipment_allowed': pi['transshipment_allowed'],
          'status': 'draft',
          'version': 1,
          'shipped_percent': 0,
          'notes': options?['notes'] ?? pi['notes'],
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final poId = (poResponse as Map<String, dynamic>)['po_id'] as String;

    // Copy PI items to PO items
    final piItemsResponse = await _supabase
        .from('trade_pi_items')
        .select('*')
        .eq('pi_id', piId)
        .order('sort_order', ascending: true);

    final piItems = piItemsResponse as List;
    if (piItems.isNotEmpty) {
      final poItemsToInsert = piItems.asMap().entries.map((entry) {
        final item = entry.value as Map<String, dynamic>;
        return {
          'po_id': poId,
          'product_id': item['product_id'],
          'description': item['description'],
          'sku': item['sku'],
          'hs_code': item['hs_code'],
          'quantity_ordered': item['quantity'],
          'quantity_shipped': 0,
          'unit': item['unit'],
          'unit_price': item['unit_price'],
          'total_amount': item['total_amount'],
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_po_items').insert(poItemsToInsert);
    }

    // Update PI status to converted
    await _supabase.from('trade_proforma_invoices').update({
      'status': 'converted',
      'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
    }).eq('pi_id', piId);

    return poId;
  }

  @override
  Future<String> generateNumber(String companyId) async {
    // Get the latest PO number for this company
    final response = await _supabase
        .from('trade_purchase_orders')
        .select('po_number')
        .eq('company_id', companyId)
        .order('created_at_utc', ascending: false)
        .limit(1);

    final data = response as List;
    int nextNumber = 1;

    if (data.isNotEmpty) {
      final lastNumber = data[0]['po_number'] as String;
      // Extract number from format PO-YYYYMMDD-XXXX
      final parts = lastNumber.split('-');
      if (parts.length >= 3) {
        nextNumber = (int.tryParse(parts.last) ?? 0) + 1;
      }
    }

    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'PO-$dateStr-${nextNumber.toString().padLeft(4, '0')}';
  }

  @override
  Future<List<AcceptedPIForConversion>> getAcceptedPIsForConversion() async {
    // Load accepted PIs that haven't been converted to PO yet
    final response = await _supabase
        .from('trade_proforma_invoices')
        .select('''
          pi_id,
          pi_number,
          counterparty_id,
          counterparty_info,
          total_amount,
          currency_id,
          status,
          created_at_utc
        ''')
        .eq('status', 'accepted')
        .order('created_at_utc', ascending: false);

    final data = response as List;

    // Get currency IDs for lookup
    final currencyIds = data
        .map((e) => (e as Map<String, dynamic>)['currency_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    // Get counterparty IDs for lookup
    final counterpartyIds = data
        .map((e) => (e as Map<String, dynamic>)['counterparty_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    // Fetch currency codes and symbols
    Map<String, Map<String, String>> currencyMap = {};
    if (currencyIds.isNotEmpty) {
      final currencyResponse = await _supabase
          .from('currency_types')
          .select('currency_id, currency_code, symbol')
          .inFilter('currency_id', currencyIds);
      for (final c in currencyResponse as List) {
        final cMap = c as Map<String, dynamic>;
        currencyMap[cMap['currency_id'] as String] = {
          'code': cMap['currency_code'] as String? ?? 'USD',
          'symbol': cMap['symbol'] as String? ?? '\$',
        };
      }
    }

    // Fetch counterparty names
    Map<String, String> counterpartyMap = {};
    if (counterpartyIds.isNotEmpty) {
      final counterpartyResponse = await _supabase
          .from('counterparties')
          .select('counterparty_id, name')
          .inFilter('counterparty_id', counterpartyIds);
      for (final cp in counterpartyResponse as List) {
        final cpMap = cp as Map<String, dynamic>;
        counterpartyMap[cpMap['counterparty_id'] as String] =
            cpMap['name'] as String? ?? 'Unknown';
      }
    }

    final List<AcceptedPIForConversion> items = [];
    for (final row in data) {
      final rowMap = row as Map<String, dynamic>;
      final piId = rowMap['pi_id'] as String;

      // Check if PI is already converted to PO
      final poCheck = await _supabase
          .from('trade_purchase_orders')
          .select('po_id')
          .eq('pi_id', piId)
          .maybeSingle();

      if (poCheck == null) {
        final counterpartyId = rowMap['counterparty_id'] as String?;
        final counterpartyInfo =
            rowMap['counterparty_info'] as Map<String, dynamic>?;
        final currencyId = rowMap['currency_id'] as String?;
        final currency = currencyId != null ? currencyMap[currencyId] : null;

        // Get buyer name: prefer counterparty table, then counterparty_info, then fallback
        final buyerName =
            (counterpartyId != null ? counterpartyMap[counterpartyId] : null) ??
                counterpartyInfo?['name'] as String? ??
                counterpartyInfo?['company_name'] as String? ??
                'Unknown Buyer';

        items.add(AcceptedPIForConversion(
          piId: piId,
          piNumber: rowMap['pi_number'] as String? ?? 'N/A',
          buyerName: buyerName,
          totalAmount: (rowMap['total_amount'] as num?)?.toDouble() ?? 0,
          currencyCode: currency?['code'] ?? 'USD',
          currencySymbol: currency?['symbol'] ?? '\$',
        ));
      }
    }

    return items;
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
