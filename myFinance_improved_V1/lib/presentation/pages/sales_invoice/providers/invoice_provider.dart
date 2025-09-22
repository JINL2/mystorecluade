import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/invoice_models.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/app_state_provider.dart';
import '../../../../data/services/inventory_service.dart';

// State for managing invoice page
class InvoicePageState {
  final bool isLoading;
  final InvoicePageResponse? response;
  final String? error;
  final InvoicePeriod selectedPeriod;
  final InvoiceSortOption sortBy;
  final bool sortAscending;
  final String searchQuery;
  final int currentPage;

  InvoicePageState({
    this.isLoading = false,
    this.response,
    this.error,
    this.selectedPeriod = InvoicePeriod.thisMonth,
    this.sortBy = InvoiceSortOption.date,
    this.sortAscending = false,
    this.searchQuery = '',
    this.currentPage = 1,
  });

  InvoicePageState copyWith({
    bool? isLoading,
    InvoicePageResponse? response,
    String? error,
    InvoicePeriod? selectedPeriod,
    InvoiceSortOption? sortBy,
    bool? sortAscending,
    String? searchQuery,
    int? currentPage,
  }) {
    return InvoicePageState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  // Get sorted invoices
  List<Invoice> get sortedInvoices {
    if (response == null) return [];
    
    final invoices = List<Invoice>.from(response!.invoices);
    
    switch (sortBy) {
      case InvoiceSortOption.date:
        invoices.sort((a, b) => sortAscending 
            ? a.saleDate.compareTo(b.saleDate)
            : b.saleDate.compareTo(a.saleDate));
        break;
      case InvoiceSortOption.invoiceId:
        invoices.sort((a, b) => sortAscending
            ? a.invoiceNumber.compareTo(b.invoiceNumber)
            : b.invoiceNumber.compareTo(a.invoiceNumber));
        break;
      case InvoiceSortOption.user:
        invoices.sort((a, b) {
          final aName = a.customer?.name ?? '';
          final bName = b.customer?.name ?? '';
          return sortAscending
              ? aName.compareTo(bName)
              : bName.compareTo(aName);
        });
        break;
      case InvoiceSortOption.products:
        invoices.sort((a, b) => sortAscending
            ? a.itemsSummary.itemCount.compareTo(b.itemsSummary.itemCount)
            : b.itemsSummary.itemCount.compareTo(a.itemsSummary.itemCount));
        break;
      case InvoiceSortOption.amount:
        invoices.sort((a, b) => sortAscending
            ? a.amounts.totalAmount.compareTo(b.amounts.totalAmount)
            : b.amounts.totalAmount.compareTo(a.amounts.totalAmount));
        break;
    }
    
    return invoices;
  }

  // Group invoices by date for display
  Map<String, List<Invoice>> get groupedInvoices {
    final Map<String, List<Invoice>> grouped = {};
    
    for (final invoice in sortedInvoices) {
      final dateKey = invoice.dateString;
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(invoice);
    }
    
    return grouped;
  }
}

// Provider for invoice page state
class InvoicePageNotifier extends StateNotifier<InvoicePageState> {
  final Ref ref;
  final SupabaseClient _supabase = Supabase.instance.client;
  static const int _itemsPerPage = 20;

  InvoicePageNotifier(this.ref) : super(InvoicePageState());

  // Load invoices from RPC
  Future<void> loadInvoices() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get company and store IDs from app state
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty || appState.storeChoosen.isEmpty) {
        throw Exception('Company or store not selected. Please select a company and store first.');
      }

      // Get date range based on selected period
      final dateRange = state.selectedPeriod.getDateRange();

      print('Loading invoices with params:');
      print('Company ID: ${appState.companyChoosen}');
      print('Store ID: ${appState.storeChoosen}');
      print('Page: ${state.currentPage}');
      print('Search: ${state.searchQuery}');
      print('Start Date: ${dateRange.startDate?.toIso8601String()}');
      print('End Date: ${dateRange.endDate?.toIso8601String()}');

      // Call RPC function
      final response = await _supabase.rpc(
        'get_invoice_page',
        params: {
          'p_company_id': appState.companyChoosen,
          'p_store_id': appState.storeChoosen,
          'p_page': state.currentPage,
          'p_limit': _itemsPerPage,
          'p_search': state.searchQuery.isEmpty ? null : state.searchQuery,
          'p_start_date': dateRange.startDate?.toIso8601String(),
          'p_end_date': dateRange.endDate?.toIso8601String(),
        },
      );

      print('RPC Response received: ${response != null}');
      
      if (response == null) {
        throw Exception('No response received from server');
      }

      // Check if response has success field
      if (response is Map && response['success'] == true) {
        try {
          final pageResponse = InvoicePageResponse.fromJson(response as Map<String, dynamic>);
          state = state.copyWith(
            isLoading: false,
            response: pageResponse,
          );
          print('Successfully loaded ${pageResponse.invoices.length} invoices');
        } catch (parseError) {
          print('Error parsing response: $parseError');
          print('Response structure: ${response.runtimeType}');
          throw Exception('Failed to parse invoice data: ${parseError.toString()}');
        }
      } else if (response is Map && response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to load invoices');
      } else {
        print('Unexpected response format: ${response.runtimeType}');
        throw Exception('Unexpected response format from server');
      }
    } catch (e, stackTrace) {
      print('Error loading invoices: $e');
      print('Stack trace: $stackTrace');
      
      // Provide more user-friendly error messages
      String errorMessage = 'Failed to load invoices';
      
      if (e.toString().contains('Company or store not selected')) {
        errorMessage = 'Please select a company and store first';
      } else if (e.toString().contains('Failed to parse')) {
        errorMessage = 'Error processing invoice data. Please try again.';
      } else if (e.toString().contains('No response')) {
        errorMessage = 'No response from server. Please check your connection.';
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }
      
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  // Update selected period
  void updatePeriod(InvoicePeriod period) {
    state = state.copyWith(
      selectedPeriod: period,
      currentPage: 1,
    );
    loadInvoices();
  }

  // Update sort option
  void updateSort(InvoiceSortOption option) {
    if (state.sortBy == option) {
      // Toggle ascending/descending
      state = state.copyWith(sortAscending: !state.sortAscending);
    } else {
      state = state.copyWith(
        sortBy: option,
        sortAscending: false,
      );
    }
  }

  // Update search query
  void updateSearch(String query) {
    state = state.copyWith(
      searchQuery: query,
      currentPage: 1,
    );
    
    // Debounce search
    Future.delayed(Duration(milliseconds: 500), () {
      if (state.searchQuery == query) {
        loadInvoices();
      }
    });
  }

  // Navigate to next page
  void nextPage() {
    if (state.response?.pagination.hasNext ?? false) {
      state = state.copyWith(currentPage: state.currentPage + 1);
      loadInvoices();
    }
  }

  // Navigate to previous page
  void previousPage() {
    if (state.response?.pagination.hasPrev ?? false) {
      state = state.copyWith(currentPage: state.currentPage - 1);
      loadInvoices();
    }
  }

  // Go to specific page
  void goToPage(int page) {
    if (page > 0 && page <= (state.response?.pagination.totalPages ?? 1)) {
      state = state.copyWith(currentPage: page);
      loadInvoices();
    }
  }

  // Refresh invoices
  Future<void> refresh() async {
    await loadInvoices();
  }
}

// Provider instance
final invoicePageProvider = StateNotifierProvider<InvoicePageNotifier, InvoicePageState>((ref) {
  return InvoicePageNotifier(ref);
});

// Create Invoice Page State and Provider

class CreateInvoiceState {
  final bool isLoading;
  final SalesProductData? productData;
  final List<SalesProduct> filteredProducts;
  final String? error;
  final String searchQuery;
  final Map<String, int> selectedProducts;

  CreateInvoiceState({
    this.isLoading = false,
    this.productData,
    this.filteredProducts = const [],
    this.error,
    this.searchQuery = '',
    this.selectedProducts = const {},
  });

  CreateInvoiceState copyWith({
    bool? isLoading,
    SalesProductData? productData,
    List<SalesProduct>? filteredProducts,
    String? error,
    String? searchQuery,
    Map<String, int>? selectedProducts,
  }) {
    return CreateInvoiceState(
      isLoading: isLoading ?? this.isLoading,
      productData: productData ?? this.productData,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProducts: selectedProducts ?? this.selectedProducts,
    );
  }

  // Get products sorted by availability (available first)
  List<SalesProduct> get sortedFilteredProducts {
    final products = List<SalesProduct>.from(filteredProducts);
    products.sort((a, b) {
      // Available products first
      if (a.hasAvailableStock && !b.hasAvailableStock) return -1;
      if (!a.hasAvailableStock && b.hasAvailableStock) return 1;
      // Then by name
      return a.productName.compareTo(b.productName);
    });
    return products;
  }

  // Get total selected items count
  int get totalSelectedItems => selectedProducts.values.fold(0, (sum, count) => sum + count);

  // Get total selected products count
  int get totalSelectedProducts => selectedProducts.length;
}

class CreateInvoiceNotifier extends StateNotifier<CreateInvoiceState> {
  final Ref ref;
  final InventoryService _inventoryService;

  CreateInvoiceNotifier(this.ref, this._inventoryService) : super(CreateInvoiceState());

  // Load products for invoice creation
  Future<void> loadProducts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get company ID from app state
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) {
        throw Exception('Company not selected. Please select a company first.');
      }

      print('🔍 [CREATE_INVOICE] Loading products for company: ${appState.companyChoosen}');

      // Call RPC function
      final response = await _inventoryService.getInventoryProductListCompany(
        companyId: appState.companyChoosen,
      );

      print('📥 [CREATE_INVOICE] Response received: ${response != null}');

      if (response != null) {
        // Parse response
        SalesProductData productData;
        
        // Check if response has success wrapper
        if (response.containsKey('success') && response['success'] == true) {
          productData = SalesProductData.fromJson(response['data'] as Map<String, dynamic>? ?? {});
        } else if (!response.containsKey('success')) {
          // Direct data response
          productData = SalesProductData.fromJson(response);
        } else {
          throw Exception(response['error']?['message'] ?? 'Failed to load products');
        }

        print('✅ [CREATE_INVOICE] Products loaded: ${productData.products.length}');

        state = state.copyWith(
          isLoading: false,
          productData: productData,
          filteredProducts: productData.products,
        );

        // Apply current search filter if any
        if (state.searchQuery.isNotEmpty) {
          _filterProducts(state.searchQuery);
        }

      } else {
        throw Exception('No response received from server');
      }
    } catch (e, stackTrace) {
      print('❌ [CREATE_INVOICE] Error loading products: $e');
      print('📋 [CREATE_INVOICE] Stack trace: $stackTrace');

      String errorMessage = 'Failed to load products';
      
      if (e.toString().contains('Company not selected')) {
        errorMessage = 'Please select a company first';
      } else if (e.toString().contains('No response')) {
        errorMessage = 'No response from server. Please check your connection.';
      } else {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  // Filter products based on search query
  void searchProducts(String query) {
    state = state.copyWith(searchQuery: query);
    _filterProducts(query);
  }

  void _filterProducts(String query) {
    if (state.productData == null) return;

    if (query.isEmpty) {
      state = state.copyWith(filteredProducts: state.productData!.products);
    } else {
      final searchLower = query.toLowerCase();
      final filtered = state.productData!.products.where((product) {
        return product.productName.toLowerCase().contains(searchLower) ||
               product.sku.toLowerCase().contains(searchLower) ||
               product.barcode.toLowerCase().contains(searchLower) ||
               (product.brand?.toLowerCase().contains(searchLower) ?? false);
      }).toList();

      state = state.copyWith(filteredProducts: filtered);
    }
  }

  // Update product count in selected products
  void updateProductCount(SalesProduct product, int count) {
    print('🔧 [PROVIDER] updateProductCount called: ${product.productName} → $count');
    print('🔧 [PROVIDER] Available quantity: ${product.availableQuantity}');
    print('🔧 [PROVIDER] Current selection: ${state.selectedProducts}');
    
    final updatedSelection = Map<String, int>.from(state.selectedProducts);
    
    if (count > 0) {
      // Allow adding products even if out of stock (for backorders/special orders)
      // Optional: Add warning for out-of-stock items
      if (count > product.availableQuantity && product.availableQuantity > 0) {
        print('⚠️ [PROVIDER] Warning: Adding more than available stock (${product.availableQuantity} available)');
      }
      updatedSelection[product.productId] = count;
      print('✅ [PROVIDER] Product added to selection');
    } else {
      updatedSelection.remove(product.productId);
      print('🗑️ [PROVIDER] Product removed from selection');
    }

    print('🔧 [PROVIDER] Updated selection: $updatedSelection');
    state = state.copyWith(selectedProducts: updatedSelection);
    print('✅ [PROVIDER] State updated successfully');
  }

  // Get selected product count for a specific product
  int getProductCount(String productId) {
    return state.selectedProducts[productId] ?? 0;
  }

  // Clear all selections
  void clearSelections() {
    state = state.copyWith(selectedProducts: {});
  }

  // Refresh products
  Future<void> refresh() async {
    await loadProducts();
  }
}

// Provider for create invoice
final createInvoiceProvider = StateNotifierProvider.autoDispose<CreateInvoiceNotifier, CreateInvoiceState>((ref) {
  final inventoryService = InventoryService();
  return CreateInvoiceNotifier(ref, inventoryService);
});

// Provider to auto-load products when company changes
final createInvoiceProductsProvider = FutureProvider.autoDispose<void>((ref) async {
  final notifier = ref.watch(createInvoiceProvider.notifier);
  final appState = ref.watch(appStateProvider);
  
  // Watch for company changes
  if (appState.companyChoosen.isNotEmpty) {
    await notifier.loadProducts();
  }
});