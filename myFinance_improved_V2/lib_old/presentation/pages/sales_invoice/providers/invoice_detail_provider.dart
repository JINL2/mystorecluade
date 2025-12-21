import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/invoice_models.dart';
import '../models/invoice_item_models.dart';
import '../../../providers/app_state_provider.dart';

// State for managing invoice detail
class InvoiceDetailState {
  final bool isLoading;
  final Invoice? invoice;
  final List<InvoiceItem>? items;
  final String? error;

  InvoiceDetailState({
    this.isLoading = false,
    this.invoice,
    this.items,
    this.error,
  });

  InvoiceDetailState copyWith({
    bool? isLoading,
    Invoice? invoice,
    List<InvoiceItem>? items,
    String? error,
  }) {
    return InvoiceDetailState(
      isLoading: isLoading ?? this.isLoading,
      invoice: invoice ?? this.invoice,
      items: items ?? this.items,
      error: error,
    );
  }
}

// Provider for invoice detail state
class InvoiceDetailNotifier extends StateNotifier<InvoiceDetailState> {
  final Ref ref;
  final SupabaseClient _supabase = Supabase.instance.client;

  InvoiceDetailNotifier(this.ref) : super(InvoiceDetailState());

  // Set invoice data
  void setInvoice(Invoice invoice) {
    state = state.copyWith(invoice: invoice);
  }

  // Fetch invoice items from RPC (to be implemented when RPC is ready)
  Future<void> fetchInvoiceItems(String invoiceId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get company ID from app state
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) {
        throw Exception('Company not selected');
      }

      print('Fetching invoice items for invoice: $invoiceId');
      print('Company ID: ${appState.companyChoosen}');

      // TODO: Call RPC function when available
      // For now, we'll just return an empty list
      // Future implementation:
      /*
      final response = await _supabase.rpc(
        'get_invoice_items',
        params: {
          'p_company_id': appState.companyChoosen,
          'p_invoice_id': invoiceId,
        },
      );

      if (response != null && response['success'] == true) {
        final items = (response['items'] as List)
            .map((item) => InvoiceItem.fromJson(item as Map<String, dynamic>))
            .toList();
        
        state = state.copyWith(
          isLoading: false,
          items: items,
        );
      } else {
        throw Exception(response?['message'] ?? 'Failed to fetch invoice items');
      }
      */

      // Temporary: Set empty items list
      state = state.copyWith(
        isLoading: false,
        items: [],
      );
    } catch (e) {
      print('Error fetching invoice items: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Clear state
  void clear() {
    state = InvoiceDetailState();
  }
}

// Provider instance
final invoiceDetailProvider = StateNotifierProvider.autoDispose<InvoiceDetailNotifier, InvoiceDetailState>((ref) {
  return InvoiceDetailNotifier(ref);
});

// Provider to fetch invoice detail with items
final fetchInvoiceDetailProvider = FutureProvider.family.autoDispose<void, String>((ref, invoiceId) async {
  final notifier = ref.watch(invoiceDetailProvider.notifier);
  await notifier.fetchInvoiceItems(invoiceId);
});