import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/pi_repository.dart';
import '../models/pi_dropdown_models.dart';
import '../models/pi_model.dart';

// Re-export dropdown models for external use
export '../models/pi_dropdown_models.dart';

/// PI Remote Datasource - handles all Supabase queries
abstract class PIRemoteDatasource {
  Future<PaginatedPIResponse> getList(PIListParams params);
  Future<PIModel> getById(String piId);
  Future<PIModel> create(PICreateParams params);
  Future<PIModel> update(String piId, PICreateParams params);
  Future<void> delete(String piId);
  Future<void> send(String piId);
  Future<void> accept(String piId);
  Future<void> reject(String piId, String? reason);
  Future<String> convertToPO(String piId);
  Future<PIModel> duplicate(String piId);
  Future<String> generateNumber(String companyId);

  // Dropdown data methods
  Future<List<CounterpartyDropdownItem>> getCounterparties(String companyId);
  Future<List<CurrencyDropdownItem>> getCompanyCurrencies(String companyId);
  Future<List<TermsTemplateItem>> getTermsTemplates(String companyId);
  Future<TermsTemplateItem> saveTermsTemplate({
    required String companyId,
    required String templateName,
    required String content,
    bool isDefault = false,
  });
}

class PIRemoteDatasourceImpl implements PIRemoteDatasource {
  final SupabaseClient _supabase;

  PIRemoteDatasourceImpl(this._supabase);

  @override
  Future<PaginatedPIResponse> getList(PIListParams params) async {
    // Build query - just get PI data, we'll add currency/counterparty from JSONB
    // Note: We include records where store_id matches OR store_id is NULL
    // This ensures PI created without store assignment are still visible
    var query = _supabase
        .from('trade_proforma_invoices')
        .select('*')
        .eq('company_id', params.companyId);

    if (params.storeId != null) {
      // Include records that match store_id OR have NULL store_id
      query = query.or('store_id.eq.${params.storeId},store_id.is.null');
    }

    if (params.statuses != null && params.statuses!.isNotEmpty) {
      query = query.inFilter('status', params.statuses!.map((e) => e.name).toList());
    }

    if (params.counterpartyId != null) {
      query = query.eq('counterparty_id', params.counterpartyId!);
    }

    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      query = query.ilike('pi_number', '%${params.searchQuery}%');
    }

    // Get total count first (must apply same filters as main query)
    var countQuery = _supabase
        .from('trade_proforma_invoices')
        .select('pi_id')
        .eq('company_id', params.companyId);

    if (params.storeId != null) {
      countQuery = countQuery.or('store_id.eq.${params.storeId},store_id.is.null');
    }
    if (params.statuses != null && params.statuses!.isNotEmpty) {
      countQuery = countQuery.inFilter('status', params.statuses!.map((e) => e.name).toList());
    }
    if (params.counterpartyId != null) {
      countQuery = countQuery.eq('counterparty_id', params.counterpartyId!);
    }
    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      countQuery = countQuery.ilike('pi_number', '%${params.searchQuery}%');
    }

    final countResponse = await countQuery;
    final totalCount = (countResponse as List).length;

    // Get paginated data
    final offset = (params.page - 1) * params.pageSize;
    final response = await query
        .order('created_at_utc', ascending: false)
        .range(offset, offset + params.pageSize - 1);

    final data = response as List;

    // Get all unique currency IDs to fetch currency codes
    final currencyIds = data
        .map((e) => (e as Map<String, dynamic>)['currency_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    // Fetch currency codes
    Map<String, String> currencyCodeMap = {};
    if (currencyIds.isNotEmpty) {
      final currencyResponse = await _supabase
          .from('currency_types')
          .select('currency_id, currency_code')
          .inFilter('currency_id', currencyIds);
      for (final c in currencyResponse as List) {
        currencyCodeMap[c['currency_id'] as String] = c['currency_code'] as String;
      }
    }

    // Get all unique counterparty IDs to fetch names
    final counterpartyIds = data
        .map((e) => (e as Map<String, dynamic>)['counterparty_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    // Fetch counterparty names
    Map<String, String> counterpartyNameMap = {};
    if (counterpartyIds.isNotEmpty) {
      final counterpartyResponse = await _supabase
          .from('counterparties')
          .select('counterparty_id, name')
          .inFilter('counterparty_id', counterpartyIds);
      for (final c in counterpartyResponse as List) {
        counterpartyNameMap[c['counterparty_id'] as String] = c['name'] as String;
      }
    }

    final items = data.map((e) {
      final map = e as Map<String, dynamic>;
      // counterparty_info contains the name in JSONB
      final counterpartyInfo = map['counterparty_info'] as Map<String, dynamic>?;
      String? counterpartyName = counterpartyInfo?['name'] as String?;
      // Fallback to counterparty table if name not in JSONB
      if (counterpartyName == null) {
        final counterpartyId = map['counterparty_id'] as String?;
        if (counterpartyId != null && counterpartyNameMap.containsKey(counterpartyId)) {
          counterpartyName = counterpartyNameMap[counterpartyId];
        }
      }
      map['counterparty_name'] = counterpartyName;
      // Get currency code from map
      final currencyId = map['currency_id'] as String?;
      if (currencyId != null && currencyCodeMap.containsKey(currencyId)) {
        map['currency_code'] = currencyCodeMap[currencyId];
      }
      return PIModel.fromJson(map);
    }).toList();

    return PaginatedPIResponse(
      data: items,
      totalCount: totalCount,
      page: params.page,
      pageSize: params.pageSize,
      hasMore: offset + items.length < totalCount,
    );
  }

  @override
  Future<PIModel> getById(String piId) async {
    // Get PI data
    final piResponse = await _supabase
        .from('trade_proforma_invoices')
        .select('*')
        .eq('pi_id', piId)
        .single();

    final piMap = piResponse;
    // counterparty_info contains the name in JSONB
    final counterpartyInfo = piMap['counterparty_info'] as Map<String, dynamic>?;
    String? counterpartyName = counterpartyInfo?['name'] as String?;

    // If name not in counterparty_info, fetch from counterparties table
    final counterpartyId = piMap['counterparty_id'] as String?;
    if (counterpartyName == null && counterpartyId != null) {
      final counterpartyResponse = await _supabase
          .from('counterparties')
          .select('name')
          .eq('counterparty_id', counterpartyId)
          .maybeSingle();
      if (counterpartyResponse != null) {
        counterpartyName = counterpartyResponse['name'] as String?;
      }
    }
    piMap['counterparty_name'] = counterpartyName;

    // Build seller_info from company name + store contact details
    final companyId = piMap['company_id'] as String?;
    final storeId = piMap['store_id'] as String?;
    Map<String, dynamic> sellerInfo = {};

    // Get company name
    if (companyId != null) {
      final companyResponse = await _supabase
          .from('companies')
          .select('company_name')
          .eq('company_id', companyId)
          .maybeSingle();
      if (companyResponse != null) {
        sellerInfo['name'] = companyResponse['company_name'] as String?;
      }
    }

    // Get store contact details (address, phone, email)
    if (storeId != null) {
      final storeResponse = await _supabase
          .from('stores')
          .select('store_address, store_phone, store_email')
          .eq('store_id', storeId)
          .maybeSingle();
      if (storeResponse != null) {
        if (storeResponse['store_address'] != null) {
          sellerInfo['address'] = storeResponse['store_address'] as String?;
        }
        if (storeResponse['store_phone'] != null) {
          sellerInfo['phone'] = storeResponse['store_phone'] as String?;
        }
        if (storeResponse['store_email'] != null) {
          sellerInfo['email'] = storeResponse['store_email'] as String?;
        }
      }
    }

    piMap['seller_info'] = sellerInfo;

    // Get banking info from cash_locations (bank type accounts for trade)
    // If bank_account_ids is specified, filter by those IDs; otherwise get all bank accounts
    if (companyId != null) {
      final bankAccountIds = (piMap['bank_account_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList();

      dynamic bankingResponse;
      if (bankAccountIds != null && bankAccountIds.isNotEmpty) {
        // Filter by selected bank account IDs
        bankingResponse = await _supabase
            .from('cash_locations')
            .select('''
              cash_location_id,
              location_name,
              currency_code,
              bank_name,
              bank_account,
              beneficiary_name,
              bank_address,
              swift_code,
              bank_branch,
              account_type
            ''')
            .eq('company_id', companyId)
            .inFilter('cash_location_id', bankAccountIds)
            .eq('is_deleted', false);
      } else {
        // Get all bank accounts for this company
        bankingResponse = await _supabase
            .from('cash_locations')
            .select('''
              cash_location_id,
              location_name,
              currency_code,
              bank_name,
              bank_account,
              beneficiary_name,
              bank_address,
              swift_code,
              bank_branch,
              account_type
            ''')
            .eq('company_id', companyId)
            .eq('location_type', 'bank')
            .eq('is_deleted', false);
      }

      if (bankingResponse != null && (bankingResponse as List).isNotEmpty) {
        piMap['banking_info'] = bankingResponse.map((bank) {
          return {
            'cash_location_id': bank['cash_location_id'],
            'location_name': bank['location_name'],
            'currency_code': bank['currency_code'],
            'bank_name': bank['bank_name'],
            'bank_account': bank['bank_account'],
            'beneficiary_name': bank['beneficiary_name'],
            'bank_address': bank['bank_address'],
            'swift_code': bank['swift_code'],
            'bank_branch': bank['bank_branch'],
            'account_type': bank['account_type'],
          };
        }).toList();
      }
    }

    // Get currency code
    final currencyId = piMap['currency_id'] as String?;
    if (currencyId != null) {
      final currencyResponse = await _supabase
          .from('currency_types')
          .select('currency_code')
          .eq('currency_id', currencyId)
          .maybeSingle();
      if (currencyResponse != null) {
        piMap['currency_code'] = currencyResponse['currency_code'];
      }
    }

    // Get items from trade_pi_items table
    final itemsResponse = await _supabase
        .from('trade_pi_items')
        .select('*')
        .eq('pi_id', piId)
        .order('sort_order', ascending: true);

    final itemsList = itemsResponse as List;

    // Get product image URLs for items that have product_id
    final productIds = itemsList
        .map((e) => (e as Map<String, dynamic>)['product_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    Map<String, String?> productImageMap = {};
    if (productIds.isNotEmpty) {
      final productsResponse = await _supabase
          .from('inventory_products')
          .select('product_id, image_urls')
          .inFilter('product_id', productIds);

      for (final p in productsResponse as List) {
        final productId = p['product_id'] as String;
        final imageUrls = p['image_urls'];
        // image_urls is JSONB - extract first image URL
        String? firstImageUrl;
        if (imageUrls != null) {
          if (imageUrls is List && imageUrls.isNotEmpty) {
            firstImageUrl = imageUrls[0] as String?;
          } else if (imageUrls is Map && imageUrls['urls'] is List) {
            final urls = imageUrls['urls'] as List;
            if (urls.isNotEmpty) {
              firstImageUrl = urls[0] as String?;
            }
          }
        }
        productImageMap[productId] = firstImageUrl;
      }
    }

    // Add image_url to each item
    final itemsWithImages = itemsList.map((e) {
      final item = Map<String, dynamic>.from(e as Map<String, dynamic>);
      final productId = item['product_id'] as String?;
      if (productId != null && productImageMap.containsKey(productId)) {
        item['image_url'] = productImageMap[productId];
      }
      return item;
    }).toList();

    piMap['items'] = itemsWithImages;

    return PIModel.fromJson(piMap);
  }

  @override
  Future<PIModel> create(PICreateParams params) async {
    // Generate PI number
    final piNumber = await generateNumber(params.companyId);

    // Build seller_info from company name + store contact details
    Map<String, dynamic> sellerInfo = {};

    // Get company name
    final companyResponse = await _supabase
        .from('companies')
        .select('company_name')
        .eq('company_id', params.companyId)
        .maybeSingle();
    if (companyResponse != null) {
      sellerInfo['name'] = companyResponse['company_name'] as String?;
    }

    // Get store contact details (address, phone, email)
    if (params.storeId != null) {
      final storeResponse = await _supabase
          .from('stores')
          .select('store_address, store_phone, store_email')
          .eq('store_id', params.storeId!)
          .maybeSingle();
      if (storeResponse != null) {
        if (storeResponse['store_address'] != null) {
          sellerInfo['address'] = storeResponse['store_address'] as String?;
        }
        if (storeResponse['store_phone'] != null) {
          sellerInfo['phone'] = storeResponse['store_phone'] as String?;
        }
        if (storeResponse['store_email'] != null) {
          sellerInfo['email'] = storeResponse['store_email'] as String?;
        }
      }
    }

    // Calculate totals
    double subtotal = 0;
    for (final item in params.items) {
      final lineTotal = item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
      subtotal += lineTotal;
    }
    final discountAmount = subtotal * (0 / 100); // No discount percent in params
    final totalAmount = subtotal - discountAmount;

    // Insert PI
    final piResponse = await _supabase
        .from('trade_proforma_invoices')
        .insert({
          'pi_number': piNumber,
          'company_id': params.companyId,
          'store_id': params.storeId,
          'counterparty_id': params.counterpartyId,
          'counterparty_info': params.counterpartyInfo,
          'seller_info': sellerInfo,
          'currency_id': params.currencyId,
          'subtotal': subtotal,
          'discount_amount': discountAmount,
          'total_amount': totalAmount,
          'incoterms_code': params.incotermsCode,
          'incoterms_place': params.incotermsPlace,
          'port_of_loading': params.portOfLoading,
          'port_of_discharge': params.portOfDischarge,
          'final_destination': params.finalDestination,
          'country_of_origin': params.countryOfOrigin,
          'payment_terms_code': params.paymentTermsCode,
          'payment_terms_detail': params.paymentTermsDetail,
          'partial_shipment_allowed': params.partialShipmentAllowed,
          'transshipment_allowed': params.transshipmentAllowed,
          'shipping_method_code': params.shippingMethodCode,
          'estimated_shipment_date': params.estimatedShipmentDate?.toIso8601String(),
          'lead_time_days': params.leadTimeDays,
          'validity_date': params.validityDate?.toIso8601String(),
          'status': 'draft',
          'version': 1,
          'notes': params.notes,
          'internal_notes': params.internalNotes,
          'terms_and_conditions': params.termsAndConditions,
          'bank_account_ids': params.bankAccountIds.isNotEmpty ? params.bankAccountIds : null,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final piId = (piResponse as Map<String, dynamic>)['pi_id'] as String;

    // Insert items
    if (params.items.isNotEmpty) {
      final itemsToInsert = params.items.asMap().entries.map((entry) {
        final item = entry.value;
        final lineTotal = item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
        return {
          'pi_id': piId,
          'product_id': item.productId,
          'description': item.description,
          'sku': item.sku,
          'hs_code': item.hsCode,
          'country_of_origin': item.countryOfOrigin,
          'quantity': item.quantity,
          'unit': item.unit ?? 'PCS',
          'unit_price': item.unitPrice,
          'discount_percent': item.discountPercent,
          'total_amount': lineTotal,
          'packing_info': item.packingInfo,
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_pi_items').insert(itemsToInsert);
    }

    return getById(piId);
  }

  @override
  Future<PIModel> update(String piId, PICreateParams params) async {
    // Calculate totals
    double subtotal = 0;
    for (final item in params.items) {
      final lineTotal = item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
      subtotal += lineTotal;
    }
    final totalAmount = subtotal;

    // Update PI
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'counterparty_id': params.counterpartyId,
          'counterparty_info': params.counterpartyInfo,
          'currency_id': params.currencyId,
          'subtotal': subtotal,
          'total_amount': totalAmount,
          'incoterms_code': params.incotermsCode,
          'incoterms_place': params.incotermsPlace,
          'port_of_loading': params.portOfLoading,
          'port_of_discharge': params.portOfDischarge,
          'final_destination': params.finalDestination,
          'country_of_origin': params.countryOfOrigin,
          'payment_terms_code': params.paymentTermsCode,
          'payment_terms_detail': params.paymentTermsDetail,
          'partial_shipment_allowed': params.partialShipmentAllowed,
          'transshipment_allowed': params.transshipmentAllowed,
          'shipping_method_code': params.shippingMethodCode,
          'estimated_shipment_date': params.estimatedShipmentDate?.toIso8601String(),
          'lead_time_days': params.leadTimeDays,
          'validity_date': params.validityDate?.toIso8601String(),
          'notes': params.notes,
          'internal_notes': params.internalNotes,
          'terms_and_conditions': params.termsAndConditions,
          'bank_account_ids': params.bankAccountIds.isNotEmpty ? params.bankAccountIds : null,
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);

    // Delete existing items and re-insert
    await _supabase
        .from('trade_pi_items')
        .delete()
        .eq('pi_id', piId);

    if (params.items.isNotEmpty) {
      final itemsToInsert = params.items.asMap().entries.map((entry) {
        final item = entry.value;
        final lineTotal = item.quantity * item.unitPrice * (1 - item.discountPercent / 100);
        return {
          'pi_id': piId,
          'product_id': item.productId,
          'description': item.description,
          'sku': item.sku,
          'hs_code': item.hsCode,
          'country_of_origin': item.countryOfOrigin,
          'quantity': item.quantity,
          'unit': item.unit ?? 'PCS',
          'unit_price': item.unitPrice,
          'discount_percent': item.discountPercent,
          'total_amount': lineTotal,
          'packing_info': item.packingInfo,
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_pi_items').insert(itemsToInsert);
    }

    return getById(piId);
  }

  @override
  Future<void> delete(String piId) async {
    // Delete items first
    await _supabase
        .from('trade_pi_items')
        .delete()
        .eq('pi_id', piId);

    // Delete PI (only draft can be deleted)
    await _supabase
        .from('trade_proforma_invoices')
        .delete()
        .eq('pi_id', piId)
        .eq('status', 'draft');
  }

  @override
  Future<void> send(String piId) async {
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'status': 'sent',
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);
  }

  @override
  Future<void> accept(String piId) async {
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'status': 'accepted',
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);
  }

  @override
  Future<void> reject(String piId, String? reason) async {
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'status': 'rejected',
          'internal_notes': reason,
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);
  }

  @override
  Future<String> convertToPO(String piId) async {
    // Get PI data
    final pi = await getById(piId);

    // Generate PO number
    final poNumber = 'PO-${DateTime.now().millisecondsSinceEpoch}';

    // Create PO
    final poResponse = await _supabase
        .from('trade_purchase_orders')
        .insert({
          'po_number': poNumber,
          'company_id': pi.companyId,
          'store_id': pi.storeId,
          'pi_id': piId,
          'supplier_id': pi.counterpartyId,
          'supplier_info': pi.counterpartyInfo,
          'currency_id': pi.currencyId,
          'subtotal': pi.subtotal,
          'total_amount': pi.totalAmount,
          'incoterms_code': pi.incotermsCode,
          'incoterms_place': pi.incotermsPlace,
          'port_of_loading': pi.portOfLoading,
          'port_of_discharge': pi.portOfDischarge,
          'payment_terms_code': pi.paymentTermsCode,
          'payment_terms_detail': pi.paymentTermsDetail,
          'status': 'draft',
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final newPoId = (poResponse as Map<String, dynamic>)['po_id'] as String;

    // Update PI status to converted
    await _supabase
        .from('trade_proforma_invoices')
        .update({
          'status': 'converted',
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('pi_id', piId);

    return newPoId;
  }

  @override
  Future<PIModel> duplicate(String piId) async {
    final original = await getById(piId);
    final piNumber = await generateNumber(original.companyId);

    // Insert duplicated PI
    final piResponse = await _supabase
        .from('trade_proforma_invoices')
        .insert({
          'pi_number': piNumber,
          'company_id': original.companyId,
          'store_id': original.storeId,
          'counterparty_id': original.counterpartyId,
          'counterparty_info': original.counterpartyInfo,
          'currency_id': original.currencyId,
          'subtotal': original.subtotal,
          'discount_percent': original.discountPercent,
          'discount_amount': original.discountAmount,
          'total_amount': original.totalAmount,
          'incoterms_code': original.incotermsCode,
          'incoterms_place': original.incotermsPlace,
          'port_of_loading': original.portOfLoading,
          'port_of_discharge': original.portOfDischarge,
          'final_destination': original.finalDestination,
          'country_of_origin': original.countryOfOrigin,
          'payment_terms_code': original.paymentTermsCode,
          'payment_terms_detail': original.paymentTermsDetail,
          'partial_shipment_allowed': original.partialShipmentAllowed,
          'transshipment_allowed': original.transshipmentAllowed,
          'shipping_method_code': original.shippingMethodCode,
          'status': 'draft',
          'version': 1,
          'notes': original.notes,
          'terms_and_conditions': original.termsAndConditions,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    final newPiId = (piResponse as Map<String, dynamic>)['pi_id'] as String;

    // Duplicate items
    if (original.items.isNotEmpty) {
      final itemsToInsert = original.items.asMap().entries.map((entry) {
        final item = entry.value;
        return {
          'pi_id': newPiId,
          'product_id': item.productId,
          'description': item.description,
          'sku': item.sku,
          'hs_code': item.hsCode,
          'country_of_origin': item.countryOfOrigin,
          'quantity': item.quantity,
          'unit': item.unit,
          'unit_price': item.unitPrice,
          'discount_percent': item.discountPercent,
          'total_amount': item.totalAmount,
          'packing_info': item.packingInfo,
          'sort_order': entry.key,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();

      await _supabase.from('trade_pi_items').insert(itemsToInsert);
    }

    return getById(newPiId);
  }

  @override
  Future<String> generateNumber(String companyId) async {
    // Get the latest PI number for this company
    final response = await _supabase
        .from('trade_proforma_invoices')
        .select('pi_number')
        .eq('company_id', companyId)
        .order('created_at_utc', ascending: false)
        .limit(1);

    final data = response as List;
    int nextNumber = 1;

    if (data.isNotEmpty) {
      final lastNumber = data[0]['pi_number'] as String;
      // Extract number from format PI-YYYYMMDD-XXXX
      final parts = lastNumber.split('-');
      if (parts.length >= 3) {
        nextNumber = (int.tryParse(parts.last) ?? 0) + 1;
      }
    }

    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'PI-$dateStr-${nextNumber.toString().padLeft(4, '0')}';
  }

  @override
  Future<List<CounterpartyDropdownItem>> getCounterparties(String companyId) async {
    final response = await _supabase
        .from('counterparties')
        .select('counterparty_id, name, address, city, country, email, phone')
        .eq('company_id', companyId)
        .eq('is_active', true)
        .order('name', ascending: true);

    final data = response as List;
    return data
        .map((e) => CounterpartyDropdownItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CurrencyDropdownItem>> getCompanyCurrencies(String companyId) async {
    // Use view_company_currency to get company-specific currencies
    final response = await _supabase
        .from('view_company_currency')
        .select('currency_id, currency_code, symbol, currency_name')
        .eq('company_id', companyId)
        .order('currency_code', ascending: true);

    final data = response as List;
    return data
        .map((e) => CurrencyDropdownItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TermsTemplateItem>> getTermsTemplates(String companyId) async {
    final response = await _supabase
        .from('trade_terms_templates')
        .select('template_id, template_name, content, is_default, sort_order')
        .eq('company_id', companyId)
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    final data = response as List;
    return data
        .map((e) => TermsTemplateItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TermsTemplateItem> saveTermsTemplate({
    required String companyId,
    required String templateName,
    required String content,
    bool isDefault = false,
  }) async {
    final response = await _supabase
        .from('trade_terms_templates')
        .insert({
          'company_id': companyId,
          'template_name': templateName,
          'content': content,
          'is_default': isDefault,
          'is_active': true,
          'created_at_utc': DateTime.now().toUtc().toIso8601String(),
          'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
        })
        .select()
        .single();

    return TermsTemplateItem.fromJson(response as Map<String, dynamic>);
  }
}
