import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/po_remote_datasource.dart';
import '../../data/repositories/po_repository_impl.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/po_repository.dart'
    hide SupplierFilterItem, BaseCurrencyData, CurrencyInfo, ProductItem, ProductSearchResult;

part 'po_providers.g.dart';

// === Datasource & Repository (DI Layer) ===
// Note: These providers are kept here for simplicity.
// In larger projects, consider moving to a separate DI module.
@Riverpod(keepAlive: true)
PORemoteDatasource poDatasource(PoDatasourceRef ref) {
  return PORemoteDatasourceImpl(Supabase.instance.client);
}

@Riverpod(keepAlive: true)
PORepository poRepository(PoRepositoryRef ref) {
  return PORepositoryImpl(ref.watch(poDatasourceProvider));
}

// === List State ===
class POListState {
  final List<POListItem> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int totalCount;
  final int currentPage;
  final bool hasMore;
  final POListParams? lastParams;

  const POListState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.totalCount = 0,
    this.currentPage = 1,
    this.hasMore = false,
    this.lastParams,
  });

  POListState copyWith({
    List<POListItem>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
    POListParams? lastParams,
  }) {
    return POListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      lastParams: lastParams ?? this.lastParams,
    );
  }
}

@riverpod
class PoList extends _$PoList {
  @override
  POListState build() {
    return const POListState();
  }

  String? get _companyId {
    final appState = ref.read(appStateProvider);
    return appState.companyChoosen.isNotEmpty ? appState.companyChoosen : null;
  }

  String? get _storeId {
    final appState = ref.read(appStateProvider);
    return appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
  }

  PORepository get _repository => ref.read(poRepositoryProvider);

  Future<void> loadList({
    List<POStatus>? statuses,
    List<OrderStatus>? orderStatuses,
    List<ReceivingStatus>? receivingStatuses,
    String? counterpartyId,
    String? supplierId,
    bool? hasLc,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? searchQuery,
    bool refresh = false,
  }) async {
    if (_companyId == null) {
      state = state.copyWith(error: 'Company not selected');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final params = POListParams(
        companyId: _companyId!,
        storeId: _storeId,
        statuses: statuses,
        orderStatuses: orderStatuses,
        receivingStatuses: receivingStatuses,
        counterpartyId: counterpartyId,
        supplierId: supplierId,
        hasLc: hasLc,
        dateFrom: dateFrom,
        dateTo: dateTo,
        searchQuery: searchQuery,
        page: 1,
        pageSize: 20,
      );

      final result = await _repository.getList(params);

      state = state.copyWith(
        items: result.data,
        isLoading: false,
        totalCount: result.totalCount,
        currentPage: result.page,
        hasMore: result.hasMore,
        lastParams: params,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.lastParams == null) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final params = POListParams(
        companyId: state.lastParams!.companyId,
        storeId: state.lastParams!.storeId,
        statuses: state.lastParams!.statuses,
        orderStatuses: state.lastParams!.orderStatuses,
        receivingStatuses: state.lastParams!.receivingStatuses,
        counterpartyId: state.lastParams!.counterpartyId,
        supplierId: state.lastParams!.supplierId,
        hasLc: state.lastParams!.hasLc,
        dateFrom: state.lastParams!.dateFrom,
        dateTo: state.lastParams!.dateTo,
        searchQuery: state.lastParams!.searchQuery,
        page: state.currentPage + 1,
        pageSize: state.lastParams!.pageSize,
      );

      final result = await _repository.getList(params);

      state = state.copyWith(
        items: [...state.items, ...result.data],
        isLoadingMore: false,
        currentPage: result.page,
        hasMore: result.hasMore,
        lastParams: params,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  void refresh() {
    if (state.lastParams != null) {
      loadList(
        statuses: state.lastParams!.statuses,
        orderStatuses: state.lastParams!.orderStatuses,
        receivingStatuses: state.lastParams!.receivingStatuses,
        counterpartyId: state.lastParams!.counterpartyId,
        supplierId: state.lastParams!.supplierId,
        hasLc: state.lastParams!.hasLc,
        dateFrom: state.lastParams!.dateFrom,
        dateTo: state.lastParams!.dateTo,
        searchQuery: state.lastParams!.searchQuery,
        refresh: true,
      );
    } else {
      loadList(refresh: true);
    }
  }
}

// === Detail State ===
class PODetailState {
  final PurchaseOrder? po;
  final bool isLoading;
  final String? error;

  const PODetailState({
    this.po,
    this.isLoading = false,
    this.error,
  });

  PODetailState copyWith({
    PurchaseOrder? po,
    bool? isLoading,
    String? error,
  }) {
    return PODetailState(
      po: po ?? this.po,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

@riverpod
class PoDetail extends _$PoDetail {
  @override
  PODetailState build() {
    return const PODetailState();
  }

  PORepository get _repository => ref.read(poRepositoryProvider);

  String? get _companyId {
    final appState = ref.read(appStateProvider);
    return appState.companyChoosen.isNotEmpty ? appState.companyChoosen : null;
  }

  String? get _userId {
    final appState = ref.read(appStateProvider);
    return appState.userId.isNotEmpty ? appState.userId : null;
  }

  Future<void> load(String poId) async {
    if (_companyId == null) {
      state = state.copyWith(error: 'Company not selected');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final po = await _repository.getById(poId, companyId: _companyId!);
      state = state.copyWith(po: po, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Close order using inventory_close_order RPC
  /// This cancels the order and all linked shipments/sessions
  Future<Map<String, dynamic>?> closeOrder() async {
    if (state.po == null) return null;
    if (_companyId == null || _userId == null) {
      state = state.copyWith(error: 'Company or user not selected');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.closeOrder(
        orderId: state.po!.poId,
        userId: _userId!,
        companyId: _companyId!,
      );

      // Reload the PO to get updated status
      await load(state.po!.poId);

      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  void clear() {
    state = const PODetailState();
  }
}

// === Form State ===
class POFormState {
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final PurchaseOrder? savedPO;

  const POFormState({
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.savedPO,
  });

  POFormState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? error,
    PurchaseOrder? savedPO,
  }) {
    return POFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      savedPO: savedPO,
    );
  }
}

@riverpod
class PoForm extends _$PoForm {
  @override
  POFormState build() {
    return const POFormState();
  }

  PORepository get _repository => ref.read(poRepositoryProvider);

  void reset() {
    state = const POFormState();
  }

  /// Create order using inventory_create_order_v4 RPC
  /// Note: orderNumber is auto-generated by RPC when not provided
  Future<Map<String, dynamic>?> createOrder({
    required List<Map<String, dynamic>> items,
    required String orderTitle,
    String? counterpartyId,
    Map<String, dynamic>? supplierInfo,
    String? notes,
  }) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final userId = appState.userId;

    if (companyId.isEmpty || userId.isEmpty) {
      state = state.copyWith(error: 'Company or user not selected');
      return null;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      final response = await _repository.createOrderV4(
        companyId: companyId,
        userId: userId,
        items: items,
        orderTitle: orderTitle,
        counterpartyId: counterpartyId,
        supplierInfo: supplierInfo,
        notes: notes,
        // orderNumber is null - RPC auto-generates PO number
      );

      state = state.copyWith(isSaving: false);
      return response;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      rethrow;
    }
  }
}

// === Supplier List for Filter ===
/// Simple supplier item for filter selection
class SupplierFilterItem {
  final String counterpartyId;
  final String name;
  final String? type;
  final String? email;
  final String? phone;

  const SupplierFilterItem({
    required this.counterpartyId,
    required this.name,
    this.type,
    this.email,
    this.phone,
  });

  factory SupplierFilterItem.fromJson(Map<String, dynamic> json) {
    return SupplierFilterItem(
      counterpartyId: json['counterparty_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

@riverpod
Future<List<SupplierFilterItem>> supplierList(
  SupplierListRef ref,
) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return [];
  }

  final repository = ref.watch(poRepositoryProvider);
  final items = await repository.getSuppliers(companyId);

  // Convert domain SupplierFilterItem to presentation SupplierFilterItem
  return items.map((e) => SupplierFilterItem(
    counterpartyId: e.counterpartyId,
    name: e.name,
    type: e.type,
    email: e.email,
    phone: e.phone,
  )).toList();
}

// === Base Currency for PO ===
/// Currency info from get_base_currency RPC
class POCurrencyInfo {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final String? flagEmoji;
  final double exchangeRateToBase;
  final DateTime? rateDate;
  final List<PODenomination> denominations;

  const POCurrencyInfo({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    this.flagEmoji,
    this.exchangeRateToBase = 1.0,
    this.rateDate,
    this.denominations = const [],
  });

  factory POCurrencyInfo.fromJson(Map<String, dynamic> json) {
    return POCurrencyInfo(
      currencyId: json['currency_id'] as String? ?? '',
      currencyCode: json['currency_code'] as String? ?? '',
      currencyName: json['currency_name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      flagEmoji: json['flag_emoji'] as String?,
      exchangeRateToBase:
          (json['exchange_rate_to_base'] as num?)?.toDouble() ?? 1.0,
      rateDate: json['rate_date'] != null
          ? DateTime.tryParse(json['rate_date'] as String)
          : null,
      denominations: (json['denominations'] as List<dynamic>?)
              ?.map((e) => PODenomination.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PODenomination {
  final String denominationId;
  final double value;

  const PODenomination({
    required this.denominationId,
    required this.value,
  });

  factory PODenomination.fromJson(Map<String, dynamic> json) {
    return PODenomination(
      denominationId: json['denomination_id'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Base currency data from get_base_currency RPC
class POBaseCurrencyData {
  final POCurrencyInfo baseCurrency;
  final List<POCurrencyInfo> companyCurrencies;

  const POBaseCurrencyData({
    required this.baseCurrency,
    required this.companyCurrencies,
  });

  factory POBaseCurrencyData.fromJson(Map<String, dynamic> json) {
    final baseCurrencyJson = json['base_currency'] as Map<String, dynamic>?;
    final companyCurrenciesJson = json['company_currencies'] as List<dynamic>?;

    return POBaseCurrencyData(
      baseCurrency: baseCurrencyJson != null
          ? POCurrencyInfo.fromJson(baseCurrencyJson)
          : const POCurrencyInfo(
              currencyId: '',
              currencyCode: 'USD',
              currencyName: 'US Dollar',
              symbol: '\$',
            ),
      companyCurrencies: companyCurrenciesJson
              ?.map((e) => POCurrencyInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Get exchange rate for a specific currency code
  double? getExchangeRate(String currencyCode) {
    if (currencyCode == baseCurrency.currencyCode) return 1.0;
    final currency = companyCurrencies.firstWhere(
      (c) => c.currencyCode == currencyCode,
      orElse: () => const POCurrencyInfo(
        currencyId: '',
        currencyCode: '',
        currencyName: '',
        symbol: '',
      ),
    );
    return currency.currencyCode.isNotEmpty
        ? currency.exchangeRateToBase
        : null;
  }
}

@riverpod
Future<POBaseCurrencyData> poBaseCurrency(PoBaseCurrencyRef ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return const POBaseCurrencyData(
      baseCurrency: POCurrencyInfo(
        currencyId: '',
        currencyCode: 'USD',
        currencyName: 'US Dollar',
        symbol: '\$',
      ),
      companyCurrencies: [],
    );
  }

  final repository = ref.watch(poRepositoryProvider);
  final data = await repository.getBaseCurrency(companyId);

  // Convert domain BaseCurrencyData to presentation POBaseCurrencyData
  return POBaseCurrencyData(
    baseCurrency: POCurrencyInfo(
      currencyId: data.baseCurrency.currencyId,
      currencyCode: data.baseCurrency.currencyCode,
      currencyName: data.baseCurrency.currencyName,
      symbol: data.baseCurrency.symbol,
      flagEmoji: data.baseCurrency.flagEmoji,
      exchangeRateToBase: data.baseCurrency.exchangeRateToBase,
      rateDate: data.baseCurrency.rateDate,
    ),
    companyCurrencies: data.companyCurrencies.map((c) => POCurrencyInfo(
      currencyId: c.currencyId,
      currencyCode: c.currencyCode,
      currencyName: c.currencyName,
      symbol: c.symbol,
      flagEmoji: c.flagEmoji,
      exchangeRateToBase: c.exchangeRateToBase,
      rateDate: c.rateDate,
    )).toList(),
  );
}

// === Product Search for Order Items ===

/// Product item from inventory search
class InventoryProductItem {
  final String productId;
  final String productName;
  final String? productSku;
  final String? productBarcode;
  final String? variantId;
  final String? variantName;
  final String? variantSku;
  final String displayName;
  final String? displaySku;
  final String unit;
  final double costPrice;
  final double sellingPrice;
  final double quantityOnHand;
  final List<String> imageUrls;
  final bool hasVariants;

  const InventoryProductItem({
    required this.productId,
    required this.productName,
    this.productSku,
    this.productBarcode,
    this.variantId,
    this.variantName,
    this.variantSku,
    required this.displayName,
    this.displaySku,
    required this.unit,
    required this.costPrice,
    required this.sellingPrice,
    required this.quantityOnHand,
    this.imageUrls = const [],
    this.hasVariants = false,
  });

  factory InventoryProductItem.fromJson(Map<String, dynamic> json) {
    final price = json['price'] as Map<String, dynamic>? ?? {};
    final stock = json['stock'] as Map<String, dynamic>? ?? {};
    final imageUrlsRaw = json['image_urls'];

    return InventoryProductItem(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productSku: json['product_sku'] as String?,
      productBarcode: json['product_barcode'] as String?,
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      variantSku: json['variant_sku'] as String?,
      displayName: json['display_name'] as String? ?? json['product_name'] as String,
      displaySku: json['display_sku'] as String?,
      unit: json['unit'] as String? ?? 'PCS',
      costPrice: (price['cost'] as num?)?.toDouble() ?? 0,
      sellingPrice: (price['selling'] as num?)?.toDouble() ?? 0,
      quantityOnHand: (stock['quantity_on_hand'] as num?)?.toDouble() ?? 0,
      imageUrls: imageUrlsRaw is List
          ? imageUrlsRaw.map((e) => e.toString()).toList()
          : const [],
      hasVariants: json['has_variants'] as bool? ?? false,
    );
  }

  /// Unique key for item (product_id + variant_id or just product_id)
  String get uniqueKey => variantId != null ? '${productId}_$variantId' : productId;
}

/// Product search state
class ProductSearchState {
  final List<InventoryProductItem> items;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const ProductSearchState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  ProductSearchState copyWith({
    List<InventoryProductItem>? items,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return ProductSearchState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

@riverpod
class ProductSearch extends _$ProductSearch {
  @override
  ProductSearchState build() {
    return const ProductSearchState();
  }

  String? get _companyId {
    final appState = ref.read(appStateProvider);
    return appState.companyChoosen.isNotEmpty ? appState.companyChoosen : null;
  }

  String? get _storeId {
    final appState = ref.read(appStateProvider);
    return appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
  }

  PORepository get _repository => ref.read(poRepositoryProvider);

  Future<void> search(String query) async {
    if (_companyId == null || _storeId == null) {
      state = state.copyWith(error: 'Company or store not selected');
      return;
    }

    // Update search query immediately
    state = state.copyWith(searchQuery: query, isLoading: true, error: null);

    // If empty query, clear results
    if (query.trim().isEmpty) {
      state = state.copyWith(items: [], isLoading: false);
      return;
    }

    try {
      final result = await _repository.searchProducts(
        companyId: _companyId!,
        storeId: _storeId!,
        query: query,
      );

      // Convert domain ProductItem to presentation InventoryProductItem
      final items = result.items.map((e) => InventoryProductItem(
        productId: e.productId,
        productName: e.productName,
        productSku: e.productSku,
        productBarcode: e.productBarcode,
        variantId: e.variantId,
        variantName: e.variantName,
        variantSku: e.variantSku,
        displayName: e.displayName,
        displaySku: e.displaySku,
        unit: e.unit,
        costPrice: e.costPrice,
        sellingPrice: e.sellingPrice,
        quantityOnHand: e.quantityOnHand,
        imageUrls: e.imageUrls,
        hasVariants: e.hasVariants,
      )).toList();

      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clear() {
    state = const ProductSearchState();
  }
}
