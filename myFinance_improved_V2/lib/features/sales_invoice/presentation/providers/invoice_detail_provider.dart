import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/invoice_detail.dart';
import '../../domain/repositories/invoice_repository.dart';
import 'invoice_providers.dart';

/// State for invoice detail
class InvoiceDetailState {
  final InvoiceDetail? detail;
  final bool isLoading;
  final String? error;

  const InvoiceDetailState({
    this.detail,
    this.isLoading = false,
    this.error,
  });

  InvoiceDetailState copyWith({
    InvoiceDetail? detail,
    bool? isLoading,
    String? error,
  }) {
    return InvoiceDetailState(
      detail: detail ?? this.detail,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Invoice detail notifier
class InvoiceDetailNotifier extends StateNotifier<InvoiceDetailState> {
  final InvoiceRepository _repository;

  InvoiceDetailNotifier(this._repository) : super(const InvoiceDetailState());

  /// Load invoice detail
  Future<void> loadDetail(String invoiceId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final detail = await _repository.getInvoiceDetail(invoiceId: invoiceId);
      state = state.copyWith(detail: detail, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear state
  void clear() {
    state = const InvoiceDetailState();
  }
}

/// Invoice detail provider
final invoiceDetailProvider =
    StateNotifierProvider<InvoiceDetailNotifier, InvoiceDetailState>((ref) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return InvoiceDetailNotifier(repository);
});
